%hvtestspectrum - issue 1.1 (04/12/09) - HVLab HRV Toolbox
%---------------------------------------------------------
%[psd, psd_min, psd_max] = hvtestspectrum(test_signal, fincrement, fmax)
% Generates target PSD of test signals specified in seat and glove testing 
% standards
%
%		psd             = 	data structure array containing target psd
%                           of test signal
%		psd_min         = 	data structure array containing lower limit of
%                           psd of test signal
%		psd_max         = 	data structure array containing upper limit of
%                           psd of test signal		
%       test_signal	    = 	lower case string describing desired 
%							test signal (e.g. 'em1')
%		fincrement      =   increment of frequency scale:
%							defaults to HV.FINCREMENT
%		fmax			=	highest frequency point:	
%							defaults to 0.5/HV.TINCREMENT
%
%Available test_signals:
%-----------------------
% ‘em1’, ‘em2’, ‘em3’, ‘em4’, ‘em5’, ‘em6’, ‘em7’, ‘em8’, ‘em9’ as defined in:
%   EN ISO 7096:2000 Earth-moving machinery – Laboratory evaluation of
%   operator seat vibration.
% ‘it1’, ‘it2’, ‘it3’, ‘it4’ as defined in:
%   EN 13490:2001 Mechanical vibration - Industrial trucks - Laboratory
%   evaluation and specification of operator seat vibration.
% ‘ag1’, ‘ag2’, ‘ag3’ as defined in:
%   BS ISO 5007:2003 Agricultural wheeled tractors – Operator's seat -
%   Laboratory measurement of transmitted vibration.
% ‘L’, ‘M’, ‘H’ as defined in:
%   BS EN ISO 10819:1997 Mechanical vibration and shock – Hand-arm
%   vibration – Method for the measurement and evaluation of the vibration
%   transmissibility of gloves at the palm of the hand.
%

% written by Chris Lewis, Apr 2009
% updated by Chris Lewis, Dec 2009 to fix incorrect cut-off freqs in 'ag1'
%
function [dasGz, dasGmin, dasGmax] = hvtestspectrum(strTest, fmin, fmax)

error(HVFUNSTART(['TARGET PSD OF ', strTest, ' TEST SIGNAL'])); % show header and check for global parameters
global HV; % allow access to global parameter structure

% Create output data structure
% ----------------------------
if nargin < 3; fmax = 1/(2 * HV.TINCREMENT); end
if nargin < 2; fmin = HV.FINCREMENT; end

xvar = 0; %constant increment

dasGz = HVMAKESTRUCT(['Target PSD of ', strTest, ' test signal'], [], 'Hz', 1, xvar); %mode 1 == real data
dasGmin = HVMAKESTRUCT(['Minimum PSD of ', strTest, ' test signal'], [], 'Hz', 1, xvar); %mode 1 == real data
dasGmax = HVMAKESTRUCT(['Maximum PSD of ', strTest, ' test signal'], [], 'Hz', 1, xvar); %mode 1 == real data

% Generate frequency points
% -------------------------
flimit = fmax;
fincr = max(fmin, flimit / 2048);
dasGz.x = Const_fscale(fincr, flimit);
HVFUNPAR('frequency resolution', fincr, 'Hz');
HVFUNPAR('maximum frequency', fmax, 'Hz');

% Generate frequency weighting
% ----------------------------
qc = 1 / sqrt(2);
errWtg = 1;

if strcmpi(strTest, 'em1')
   H1 = Highpass02(dasGz.x, 1.5, 0.541);
   H2 = Highpass02(dasGz.x, 1.5, 1.306);
   H3 = Lowpass02(dasGz.x, 2.5, 0.541);
   H4 = Lowpass02(dasGz.x, 2.5, 1.306);
   dasGz.y = H1 .* H2 .* H3 .* H4 * sqrt(2.82);
   errWtg = 0;
end;

if strcmpi(strTest, 'em2')
   H1 = Highpass02(dasGz.x, 1.5, 0.541);
   H2 = Highpass02(dasGz.x, 1.5, 1.306);
   H3 = Lowpass02(dasGz.x, 3.0, 0.541);
   H4 = Lowpass02(dasGz.x, 3.0, 1.306);
   dasGz.y = H1 .* H2 .* H3 .* H4 * sqrt(2.72);
   errWtg = 0;
end;

if strcmpi(strTest, 'em3')
   H1 = Highpass02(dasGz.x, 1.5, 0.541);
   H2 = Highpass02(dasGz.x, 1.5, 1.306);
   H3 = Lowpass02(dasGz.x, 3.0, 0.541);
   H4 = Lowpass02(dasGz.x, 3.0, 1.306);
   dasGz.y = H1 .* H2 .* H3 .* H4 * sqrt(1.93);
   errWtg = 0;
end;

if strcmpi(strTest, 'em4')
   H1 = Highpass02(dasGz.x, 1.5, 0.541);
   H2 = Highpass02(dasGz.x, 1.5, 1.306);
   H3 = Lowpass02(dasGz.x, 3.0, 0.541);
   H4 = Lowpass02(dasGz.x, 3.0, 1.306);
   dasGz.y = H1 .* H2 .* H3 .* H4 * sqrt(0.60);
   errWtg = 0;
end;

if strcmpi(strTest, 'em5')
   H1 = Lowpass01(dasGz.x, 3.5); 
   H2 = Highpass02(dasGz.x, 1.5, 0.541);
   H3 = Highpass02(dasGz.x, 1.5, 1.306);
   dasGz.y = H1 .* H2 .* H3 * sqrt(1.11);
   errWtg = 0;
end;

if strcmpi(strTest, 'em6')
   H1 = Lowpass02(dasGz.x, 9.0, qc); 
   H2 = Highpass02(dasGz.x, 6.5, 0.7071);
   dasGz.y = H1 .* H2 * sqrt(0.79);
   errWtg = 0;
end;

if strcmpi(strTest, 'em7')
   H5 = Highpass02(dasGz.x, 3.0, 0.510);
   H6 = Highpass02(dasGz.x, 3.0, 0.601);
   H7 = Highpass02(dasGz.x, 3.0, 0.900);
   H8 = Highpass02(dasGz.x, 3.0, 2.563);
   H1 = Lowpass02(dasGz.x, 3.5, 0.510);
   H2 = Lowpass02(dasGz.x, 3.5, 0.601);
   H3 = Lowpass02(dasGz.x, 3.5, 0.900);
   H4 = Lowpass02(dasGz.x, 3.5, 2.563);
   dasGz.y = H1 .* H2 .* H3 .* H4 .* H5 .* H6 .* H7 .* H8 * sqrt(9.25);
   errWtg = 0;
end;

if strcmpi(strTest, 'em8')
   H2 = Highpass02(dasGz.x, 3.0, 0.541);
   H3 = Highpass02(dasGz.x, 3.0, 1.306);
   H1 = Lowpass02(dasGz.x, 3.0, qc);
   dasGz.y = H1 .* H2 .* H3 * sqrt(1.45);
   errWtg = 0;
end;

if strcmpi(strTest, 'em9')
   H2 = Highpass02(dasGz.x, 3.5, 0.541);
   H3 = Highpass02(dasGz.x, 3.5, 1.306);
   H1 = Lowpass02(dasGz.x, 4.0, qc);
   dasGz.y = H1 .* H2 .* H3 * sqrt(2.10);
   errWtg = 0;
end;

if strcmpi(strTest, 'it1')
   H1 = Highpass02(dasGz.x, 4.5, 0.541);
   H2 = Highpass02(dasGz.x, 4.5, 1.306);
   H3 = Lowpass02(dasGz.x, 5.0, qc);
   dasGz.y = H1 .* H2 .* H3 * sqrt(1.66);
   errWtg = 0;
end;

if strcmpi(strTest, 'it2')
   H1 = Highpass02(dasGz.x, 3.0, 0.541);
   H2 = Highpass02(dasGz.x, 3.0, 1.306);
   H3 = Lowpass02(dasGz.x, 3.0, qc);
   dasGz.y = H1 .* H2 .* H3 * sqrt(1.45);
   errWtg = 0;
end;

if strcmpi(strTest, 'it3')
   H1 = Highpass02(dasGz.x, 1.5, 0.541);
   H2 = Highpass02(dasGz.x, 1.5, 1.306);
   H3 = Lowpass02(dasGz.x, 3.0, 0.541);
   H4 = Lowpass02(dasGz.x, 3.0, 1.306);
   dasGz.y = H1 .* H2 .* H3 .* H4 * sqrt(0.60);
   errWtg = 0;
end;

if strcmpi(strTest, 'it4')
   H3 = Highpass02(dasGz.x, 1.5, 0.541);
   H4 = Highpass02(dasGz.x, 1.5, 1.306);
   H1 = Lowpass02(dasGz.x, 3.0, 0.541);
   H2 = Lowpass02(dasGz.x, 3.0, 1.306);
   dasGz.y = H1 .* H2 .* H3 .* H4 * sqrt(1.64);
   errWtg = 0;
end;

if strcmpi(strTest, 'ag1')
   H5 = Highpass02(dasGz.x, 3.0, 0.510);
   H6 = Highpass02(dasGz.x, 3.0, 0.601);
   H7 = Highpass02(dasGz.x, 3.0, 0.900);
   H8 = Highpass02(dasGz.x, 3.0, 2.563);
   H1 = Lowpass02(dasGz.x, 3.5, 0.510);
   H2 = Lowpass02(dasGz.x, 3.5, 0.601);
   H3 = Lowpass02(dasGz.x, 3.5, 0.900);
   H4 = Lowpass02(dasGz.x, 3.5, 2.563);
   dasGz.y = H1 .* H2 .* H3 .* H4 .* H5 .* H6 .* H7 .* H8 * sqrt(9.25);
   errWtg = 0;
end;

if strcmpi(strTest, 'ag2')
   H5 = Highpass02(dasGz.x, 2.1, 0.510);
   H6 = Highpass02(dasGz.x, 2.1, 0.601);
   H7 = Highpass02(dasGz.x, 2.1, 0.900);
   H8 = Highpass02(dasGz.x, 2.1, 2.563);
   H1 = Lowpass02(dasGz.x, 2.6, 0.510);
   H2 = Lowpass02(dasGz.x, 2.6, 0.601);
   H3 = Lowpass02(dasGz.x, 2.6, 0.900);
   H4 = Lowpass02(dasGz.x, 2.6, 2.563);
   dasGz.y = H1 .* H2 .* H3 .* H4 .* H5 .* H6 .* H7 .* H8 * sqrt(7.22);
   errWtg = 0;
end;

if strcmpi(strTest, 'ag3')
   H5 = Highpass02(dasGz.x, 1.95, 0.510);
   H6 = Highpass02(dasGz.x, 1.95, 0.601);
   H7 = Highpass02(dasGz.x, 1.95, 0.900);
   H8 = Highpass02(dasGz.x, 1.95, 2.563);
   H1 = Lowpass02(dasGz.x, 2.45, 0.510);
   H2 = Lowpass02(dasGz.x, 2.45, 0.601);
   H3 = Lowpass02(dasGz.x, 2.45, 0.900);
   H4 = Lowpass02(dasGz.x, 2.45, 2.563);
   dasGz.y = H1 .* H2 .* H3 .* H4 .* H5 .* H6 .* H7 .* H8 * sqrt(5.85);
   errWtg = 0;
end;

if strcmpi(strTest, 'L') 
   H1 = Highpass02(dasGz.x, 8.0, qc);
   H2 = Lowpass02(dasGz.x, 31.5, qc);
   dasGz.y = H1 .* H2 * sqrt(0.82);
   errWtg = 0;
end;

if strcmpi(strTest, 'M')	% unweighted magnitude specified in ISO 10819 is 16,7 m/s²
   H1 = Highpass02(dasGz.x, 31.5, qc);
   H2 = Lowpass02(dasGz.x, 200, qc);
   dasGz.y = H1 .* H2 * sqrt(1.52);
   errWtg = 0;
end;

if strcmpi(strTest, 'H')	% unweighted magnitude specified in ISO 10819 is 92.2 m/s²
    H1 = Highpass02(dasGz.x, 200, qc);
    H2 = Lowpass02(dasGz.x, 1000, qc);
    dasGz.y = H1 .* H2 * sqrt(10.0);
    errWtg = 0;
end;

if errWtg
    error('Specified weighting not recognised'); % abort if weighting spec. not found
    dasGz.dtype = 0; % make created data structure invalid
    return
end

dasGz.y = abs(dasGz.y) .* abs(dasGz.y);

dasGmin.x = dasGz.x;
dasGmin.y = max(0, (dasGz.y - (0.1 * max(dasGz.y))));

dasGmax.x = dasGz.x;
dasGmax.y = dasGz.y + (0.1 * max(dasGz.y));
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

