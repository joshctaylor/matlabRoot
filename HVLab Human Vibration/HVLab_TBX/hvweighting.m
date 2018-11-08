%hvweighting - issue 1.1 (29/01/07) - HVLab HRV Toolbox
%------------------------------------------------------
% [weighting] = hvweighting (wname, fscale, mode, fmin/finc, fmax)
% Generates a complex frequency weighting function in a new HVLab data
% structure
%
% weighting	= HVLab data structure containing complex frequency weighting
% wname     = lower case string describing desired weighting function (e.g. 'wk')
% fscale	= frequency scale: 1 = constant bandwidth, 2 = exact 1/3 octave 
%             centre frequencies, 3 = preferred 1/3 octave centre frequencies (defaults to 1)
% mode      = form of output: 0 returns complex weighting function, 1 returns 
%             normalised PSD (defaults to 0)
% fmin/finc = increment of frequency scale (if fscale = 0) or lowest 
%             frequency point (if fscale > 0) (defaults to HV.FINCREMENT)
% fmax      = highest frequency point (defaults to 1/2*HV.FINCREMENT)
% 
% Available weightings:
% ---------------------
% ‘wb’, ‘wc’, ‘wd’, ‘we’, ‘wf’, ‘wg’, ‘wh’, ‘wj’, ‘wk’, ‘wm’ as defined in:
% International Organization for Standardization (1999) Human response to 
% vibration – Measuring instrumentation: Amendment 1.  ISO 8041:1990/Amd.1:1999.
% 
% Examples:
% ---------
% [weighting] = hvweighting (‘wk’, 0, 0, fincrement, fmax) 
% returns frequency weighting Wk (ISO 2631-1, 1997) sampled at constant frequency 
% increments, fincrement, between 0 Hz and upper frequency fmax. The frequency weighting 
% is defined by the complex (i.e. real and imaginary) gain at each frequency point.
% 
% [weighting] = hvweighting (‘wk’, 1) 
% returns frequency weighting Wk (ISO 2631-1, 1997) sampled at constant frequency 
% increments, equal to the global parameter HV.FINCREMENT, between 0 Hz and an upper 
% frequency equal to 1/(2*HV.FINCREMENT).
% 
% [weighting] = hvweighting (‘wb’, 2, 0, fmin, fmax) 
% returns frequency weighting Wb (BS 6841, 1987) sampled at 1/3 octave centre 
% frequencies between lower frequency fmin and upper frequency, fmax.
% 
% [weighting] = hvweighting (‘wb’, 3) 
% returns frequency weighting Wb (BS 6841, 1987) sampled at preferred 1/3 octave 
% centre frequencies between a lower frequency equal to the global parameter 
% HV.FINCREMENT and an upper frequency equal to 1 / (2 * HV.FINCREMENT).

% written by Chris Lewis, November 2001
% changed to make weightings not case sensitive, August 2002
% modified to include standard exception handling, September 2002
% Modified CHL 15/10/2002 to correct scaling problem in Wb
% Modified CHL 16/03/06 to remove seat test signals
% Modified CHL 29/1/2007 to bring HELP in line with technical manual

function [dasHw] = hvweighting(strWtg, fscale, pmode, fmin, fmax)

error(HVFUNSTART([strWtg, ' FREQUENCY WEIGHTING'])); % show header and check for global parameters
global HV; % allow access to global parameter structure

% Create output data structure
% ----------------------------
if nargin < 5; fmax = 1/(2 * HV.TINCREMENT); end
if nargin < 4; fmin = HV.FINCREMENT; end

if nargin < 3; pmode = 0; end
if nargin < 2; fscale = 1; end
if fscale > 1
    xvar = 1; %variable increment
else 
    xvar = 0; %constant increment
end
if pmode == 1
    dasHw = HVMAKESTRUCT(['PSD weighting ', strWtg], [], 'Hz', 1, xvar); %mode 1 == real data 
else
    dasHw = HVMAKESTRUCT(['frequency weighting ', strWtg], [], 'Hz', 2, xvar); %mode 2 == complex data
end

% Generate frequency points
% -------------------------
flimit = fmax;
fincr = max(fmin, flimit / 1024);
switch fscale
	case 2
		dasHw.x = Thirdoct_fscale(fincr, flimit);
        HVFUNPAR('frequency resolution = exact third octaves');
	case 3
        dasHw.x = Nomthirdoct_fscale(fincr, flimit);
        HVFUNPAR('frequency resolution = nominal third octaves');
	otherwise						%i.e. case 0
		dasHw.x = Const_fscale(fincr, flimit);
        HVFUNPAR('frequency resolution', fincr, 'Hz');
end
HVFUNPAR('maximum frequency', fmax, 'Hz');

% Generate frequency weighting
% ----------------------------
qc = 1 / sqrt(2);
errWtg = 1;

if strcmpi(strWtg, 'wb')
   H1 = Highpass02(dasHw.x, 0.4, qc);
   H2 = Lowpass02(dasHw.x, 100, qc);
   H3 = Lowpass12(dasHw.x, 16, 16, 0.55);
   H4 = Allpass22(dasHw.x, 2.5, 0.9, 4, 0.95);
   %dasHw.y = H1 .* H2 .* H3 .* H4 / 1.024; % as in 8041:2002 which is in error
   dasHw.y = H1 .* H2 .* H3 .* H4 * 1.024; % which is equivalent to BS 6841
   errWtg = 0;
end;

if strcmpi(strWtg, 'wc')
   H1 = Highpass02(dasHw.x, 0.4, qc);
   H2 = Lowpass02(dasHw.x, 100, qc);
   H3 = Lowpass12(dasHw.x, 8, 8, 0.63);
   dasHw.y = H1 .* H2 .* H3;
   errWtg = 0;
end;

if strcmpi(strWtg, 'wd')
   H1 = Highpass02(dasHw.x, 0.4, qc);
   H2 = Lowpass02(dasHw.x, 100, qc);
   H3 = Lowpass12(dasHw.x, 2, 2, 0.63);
   dasHw.y = H1 .* H2 .* H3;
   errWtg = 0;
end;

if strcmpi(strWtg, 'we')
   H1 = Highpass02(dasHw.x, 0.4, qc);
   H2 = Lowpass02(dasHw.x, 100, qc);
   H3 = Lowpass12(dasHw.x, 1, 1, 0.63);
   errWtg = 0;
	dasHw.y = H1 .* H2 .* H3;
end;

if strcmpi(strWtg, 'wf')
   H1 = Highpass02(dasHw.x, 0.08, qc);
   H2 = Lowpass02(dasHw.x, 0.63, qc);
   %H3 = Lowpass12(dasHw.x, 1000, 0.25, 0.86);	%1000 == infinity
   H3 = Lowpass02(dasHw.x, 0.25, 0.86);			%equivalent to previous line
   H4 = Allpass22(dasHw.x, 0.0625, 0.8, 0.1, 0.8);
   dasHw.y = H1 .* H2 .* H3 .* H4; % as in 8041:2002 and 2631-1:1997
   dasHw.y = H1 .* H2 .* H3 .* H4 * 1.024; % which is equivalent to BS 6841
   errWtg = 0;
end;

if strcmpi(strWtg, 'wfy')
   H1 = Highpass02(dasHw.x, 0.02, qc);
   H2 = Lowpass02(dasHw.x, 0.63, qc);
   %H3 = Lowpass12(dasHw.x, 1000, 0.25, 0.86);	%1000 == infinity
   H3 = Lowpass02(dasHw.x, 0.25, 0.86);			%equivalent to previous line
   %H4 = Allpass22(dasHw.x, 0.0625, 0.8, 0.1, 0.8);
   dasHw.y = H1 .* H2 .* H3; % as in 8041:2002 and 2631-1:1997
   %dasHw.y = H1 .* H2 .* H3 * 1.024; % which is equivalent to BS 6841
   errWtg = 0;
end;
if strcmpi(strWtg, 'wg')
   H1 = Highpass02(dasHw.x, 0.8, qc);
   H2 = Lowpass02(dasHw.x, 100, qc);
   H3 = Lowpass12(dasHw.x, 1.5, 5.3, 0.68);
   dasHw.y = H1 .* H2 .* H3 * 0.42;
   errWtg = 0;
end;

if strcmpi(strWtg, 'wh')
   H1 = Highpass02(dasHw.x, 6.31, qc);
   H2 = Lowpass02(dasHw.x, 1258.93, qc);
   H3 = Lowpass12(dasHw.x, 15.915, 15.915, 0.64);
   dasHw.y = H1 .* H2 .* H3;
   errWtg = 0;
end;

if strcmpi(strWtg, 'wj')
   H1 = Highpass02(dasHw.x, 0.4, qc);
   H2 = Lowpass02(dasHw.x, 100, qc);
   H4 = Allpass22(dasHw.x, 3.75, 0.91, 5.32, 0.91);
   dasHw.y = H1 .* H2 .* H4;
   errWtg = 0;
end;

if strcmpi(strWtg, 'wk')
   H1 = Highpass02(dasHw.x, 0.4, qc);
   H2 = Lowpass02(dasHw.x, 100, qc);
   H3 = Lowpass12(dasHw.x, 12.5, 12.5, 0.63);
   H4 = Allpass22(dasHw.x, 2.37, 0.91, 3.35, 0.91);
   dasHw.y = H1 .* H2 .* H3 .* H4;
   errWtg = 0;
end;

if strcmpi(strWtg, 'wm')
   H1 = Highpass02(dasHw.x, 0.79, qc);
   H2 = Lowpass02(dasHw.x, 100, qc);
   H3 = Lowpass01(dasHw.x, 5.684);
   dasHw.y = H1 .* H2 .* H3;
   errWtg = 0;
end;

if errWtg
    error('Specified weighting not recognised'); % abort if weighting spec. not found
    dasHw.dtype = 0; % make created data structure invalid
    return
end

if pmode == 1
    dasHw.y = abs(dasHw.y) .* abs(dasHw.y);
    dasHw.dtype = 1;
end

return

%================================================
%generate complex single pole highpass weighting
function [wtg] = Highpass01(fhz, fnp)

s	= 2.*pi.*fhz.*j;
wnp	= 2.*pi.*fnp;
wtg	= s ./ (s + wnp);
return

%================================================
%generate complex two pole highpass weighting
function [wtg] = Highpass02(fhz, fnp, qp)

s	= 2.*pi.*fhz.*j;
wnp	= 2.*pi.*fnp;
wtg	= (s.^2) ./ (s.^2 + wnp.*s./qp + wnp.^2);
return

%================================================
%generate complex one pole lowpass weighting
function [wtg] = Lowpass01(fhz, fnp)

s	= 2.*pi.*fhz.*j;
wnp	= 2.*pi.*fnp;
wtg	= wnp ./ (s + wnp);
return

%================================================
%generate complex two pole lowpass weighting
function [wtg] = Lowpass02(fhz, fnp, qp)

s	= 2.*pi.*fhz.*j;
wnp	= 2.*pi.*fnp;
wtg	= (wnp.^2) ./ (s.^2 + wnp.*s./qp + wnp.^2);
return

%================================================
%generate complex transition weighting
function [wtg] = Lowpass12(fhz, fnz, fnp, qp)

s	= 2.*pi.*fhz.*j;
wnz	= 2.*pi.*fnz;
wnp	= 2.*pi.*fnp;
wtg	= ((s + wnz) ./ wnz) .* ((wnp.^2) ./ (s.^2 + wnp.*s./qp + wnp.^2));
return

%================================================
%generate complex allpass weighting
function [wtg] = Allpass22(fhz, fnz, qz, fnp, qp)

s	= 2.*pi.*fhz.*j;
wnz	= 2.*pi.*fnz;
wnp	= 2.*pi.*fnp;
wtg	= (s.^2 + wnz.*s./qz + wnz.^2) ./ (s.^2 + wnp.*s./qp + wnp.^2);
return

%================================================
%generate constant increment frequency scale
function [f] = Const_fscale(fincr, flimit)

f = 0:fincr:flimit;
f = f';
return

%================================================
%generate exact 1/3 octave frequency scale
function [f] = Thirdoct_fscale(fincr, flimit)

omin = fix(10.0 .* log10(fincr));
omax = fix(10.5 .* log10(flimit));
n = omax - omin;			% n is the no. of frequency points							
for k = 1:n
   no = omin + k - 1;			% no is the octave number (1 Hz is '0')
   f(k) = 10.^(no./10);  
end
f = f';
return

%================================================
%generate nominal 1/3 octave frequencies
function [f] = Nomthirdoct_fscale(fincr, flimit)

fnom = [0.01    0.0125  0.016   0.02    0.025   0.0315  0.04    0.05    0.063   0.08    ... %fnom(1)  to fnom(10)
   		0.1     0.125   0.16    0.2	    0.25    0.315   0.4     0.5     0.63    0.8	    ...	%fnom(11) to fnom(20)
   		1       1.25    1.6		2 		2.5		3.15    4 		5 		6.3     8		...	%fnom(21) to fnom(30)
   		10      12.5    16      20      25      31.5    40      50      63 		80		...	%fnom(31) to fnom(40)
   		100     125		160		200 	250		315     400 	500 	630     800	    ...	%fnom(41) to fnom(50)
   		1000    1250    1600    2000	2500    3150    4000	5000	6300    8000	...	%fnom(51) to fnom(60)
   		10000   12500	16000   20000   25000   31500   40000   50000];		                %fnom(61) to fnom(67)
  
omin = fix(10 * log10(fincr));
omax = fix(10.5 * log10(flimit));
omin = max(omin, -20);
omax = min(omax, 46);
n = omax - omin;			% n is the no. of frequency points							
for k = 1:n
   no = omin + k - 1;		% no is the octave number (1 Hz is '0')
   f(k) = fnom(no + 21);  
end
f	= f';
return


