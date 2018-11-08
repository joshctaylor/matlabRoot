%hvwtgfilter - issue 2.0 (04/12/09) - HVLab HRV Toolbox
%------------------------------------------------------
%[output, response]	= 	hvwtgfilter(input, filter, scale, fp, qp, fz, qz)
% Applies a weighting filter comprising a combination of real or complex
% poles and zeroes to time history(s) in an HVLab data structure
%
% output     = 	HVLab data structure containing filtered time history 
%               data
% response   = 	optional HVLab data structure containing complex frequency
%               response of filter
% input 	 =	HVLab data structure containing unfiltered time history 
%               data
% filter   	 = 	lower case string describing filter configuration
% scale  	 = 	scaling factor
% fp         = 	natural frequency of complex pole pair or real pole
% qp     	 = 	q factor of complex pole pair where applicable
% fz    	 = 	natural frequency of complex zero pair or real zero where
%               applicable
% qz   	     = 	q factor of complex zero pair where applicable
%
%Available filters:
%------------------
% ‘hp02’     =  high pass -  s²/(s² + wp.s/qp + wp²)
% ‘lp01’     =  low pass -   wp/(s + wp)
% ‘lp02’     =  low pass -   wp²/(s² + wp.s/qp + wp²)
% ‘lp12’     =  low pass -  (s + wz)/(s² + wp.s/q + wp²)
% ‘ap11’     =  all pass -  (s + wz)/(s + wp)
% ‘ap22’     =  all pass -  (s + wz.s/qz + wz²)/(s² + wp.s/q + wp²)
%              where: wp = 2pi.fp, wz = 2pi.fz and s = 2pi.f.sqrt(-1)
%Notes:
%------
% The filters in this function provide building blocks for frequency 
% weightings, mass-spring-damper model responses, etc.
%


% Written by Chris Lewis, April 2009
% Modified by Chris Lewis, August 2009, to make fz and qz optional
% Modified by Chris Lewis, December 2009, to add more filters and provide
%                          frequency response output

function [dasOutarr, dasWtgarr] = hvwtgfilter(dasInarr, strWtg, scale, fnp, qp, fnz, qz)

error(HVFUNSTART(['APPLY ', strWtg, ' FILTER TO DATA'], dasInarr)); % show header and abort if input is not a valid structure
if nargin < 7, qz = qp; end;
if nargin < 6, fnz = fnp; end;
if nargin < 5, qp = 0.5; end;

for k = 1:length(dasInarr)
    if ~HVISEMPTY(k, dasInarr(k)) % return results only for non-empty array elements
        error(HVISVALID(dasInarr(k), {'real', '~hz', '~xvar'})); % abort if input data is not a real TH
        [dasOutarr(k), dasWtgarr(k)] = WTGFILTER(dasInarr(k), strWtg, scale, fnp, qp, fnz, qz); % apply weighting
    end
end

return
% =========================================================================
% frequency weight a single workspace data structure
function [dasOut, dasWtg] = WTGFILTER(dasIn, wtg, scale, fnp, qp, fnz, qz)

global HV; %allow access to global parameter structure

% Create output data structure
% ----------------------------
dasOut	= HVMAKESTRUCT([wtg, ' filtered ', dasIn.title], dasIn.yunit, 's', 1, 0, dasIn.stats, dasIn.x);
xincr   = dasIn.x(2) - dasIn.x(1);
srate   = 1 / xincr;
qc	    = 1 / sqrt(2);
dasWtg	= HVMAKESTRUCT([wtg, ' response'], dasIn.yunit, 'Hz', 2, 0, dasIn.stats, Fvals(srate));
HVFUNPAR('sampling rate', srate, 'Hz');
HVFUNPAR('number of samples', length(dasIn.y));

% Implement weighting filters
% ---------------------------
if srate < (fnp * 5), error('Sampling rate is too low'); end % abort sampling rate is too low
errWtg = 1;

if strcmpi(wtg, 'hp02')
   dasOut.y = Highpass02(dasIn.y, srate, fnp, qp, scale);
   dasWtg.y = Highwtg02(dasWtg.x, fnp, qp, scale);
   errWtg = 0;
end;

if strcmpi(wtg, 'lp01')
   dasOut.y = Lowpass12(dasIn.y, srate, fnp, fnp, 0.5, scale);
   dasWtg.y = Lowwtg12(dasWtg.x, fnp, fnp, 0.5, scale);
   %dasWtg.y = Lowwtg01(dasIn.x, fnp, scale);
   errWtg = 0;
end;

if strcmpi(wtg, 'lp02')
   dasOut.y = Lowpass02(dasIn.y, srate, fnp, qp, scale);
   dasWtg.y = Lowwtg02(dasWtg.x, fnp, qp, scale);
   errWtg = 0;
end;

if strcmpi(wtg, 'lp12')
   dasOut.y = Lowpass12(dasIn.y, srate, fnz, fnp, qp, scale);
   dasWtg.y = Lowwtg12(dasWtg.x, fnz, fnp, qp, scale);
   errWtg = 0;
end;

if strcmpi(wtg, 'ap22')
   dasOut.y = Allpass22(dasIn.y, srate, fnz, qz, fnp, qp, scale); 
   dasWtg.y = Allwtg22(dasWtg.x, fnz, qz, fnp, qp, scale); 
   errWtg = 0;
end;

if strcmpi(wtg, 'ap11')
   dasOut.y = Allpass11(dasIn.y, srate, fnz, fnp, scale);
   dasWtg.y = Allwtg11(dasWtg.x, fnz, fnp, scale);
   errWtg = 0;
end;

if errWtg
    dasOut.dtype = 0; % make created data structure invalid
    error('Specified filter not recognised'); % abort if weighting spec. not found
    return
end

return

% ================================================
% two pole highpass weighting filter
function [outarray] = Highpass02(inarray, srate, fnp, qp, scale)

if nargin < 5, scale = 1.0; end

wnp	    = 2 * pi * fnp;
c 		= wnp ./ tan(wnp / (2 * srate));
a1		= c * c + (wnp * c / qp) + wnp * wnp;
b(1)	= c * c * scale / a1;
b(2)	= -2 * c * c * scale / a1;
b(3)	= c * c * scale / a1;
a(1)	= 1;
a(2)	= (2 * wnp * wnp - 2 * c * c) / a1;
a(3)	= (c * c - (wnp * c / qp) + wnp * wnp) / a1;

outarray = filter(b, a, inarray);
return

% ================================================
% two pole lowpass weighting filter
function [outarray] = Lowpass02(inarray, srate, fnp, qp, scale, bypass)

if nargin < 6, bypass = 0; end
if nargin < 5, scale = 1.0; end

wnp	    = 2 * pi * fnp;
c 		= wnp ./ tan(wnp / (2 * srate));
a1		= c * c + (wnp * c / qp) + wnp * wnp;
b(1)	= wnp * wnp * scale / a1;
b(2)	= 2 * wnp * wnp * scale / a1;
b(3)	= wnp * wnp * scale / a1;
a(1)	= 1;
a(2)	= (2 * wnp * wnp - 2 * c * c) / a1;
a(3)	= (c * c - (wnp * c / qp) + wnp * wnp) / a1;

if bypass
    outarray = inarray;
else
    outarray = filter(b, a, inarray);
end  
return

% ================================================
% a-v transition weighting filter
function [outarray] = Lowpass12(inarray, srate, fnz, fnp, qp, scale)

if nargin < 6, scale = 1.0; end

wnz	    = 2 * pi * fnz;
wnp	    = 2 * pi * fnp;
c 		= wnp ./ tan(wnp / (2 * srate));
a1		= c * c + (wnp * c / qp) + wnp * wnp;
b(1)	= (wnz + c) * wnp * wnp * scale / (wnz * a1);
b(2)	= (2 * wnz) * wnp * wnp * scale / (wnz * a1);
b(3)	= (wnz - c) * wnp * wnp * scale / (wnz * a1);
a(1)	= 1;
a(2)	= (2 * wnp * wnp - 2 * c * c) / a1;
a(3)	= (c * c - (wnp * c / qp) + wnp * wnp) / a1;

outarray = filter(b, a, inarray);
return

% ================================================
% complex allpass weighting filter (upward step)
function [outarray] = Allpass22(inarray, srate, fnz, qz, fnp, qp, scale)

if nargin < 7, scale = 1.0; end

wnz	    = 2 * pi * fnz;
wnp	    = 2 * pi * fnp;
c 		= wnp ./ tan(wnp / (2 * srate));
a1		= c * c + (wnp * c / qp) + wnp * wnp;
b(1)	= (c * c + (wnz * c / qz) + wnz * wnz) * scale / a1;
b(2)	= (2 * wnz * wnz - 2 * c * c) * scale / a1;
b(3)	= (c * c - (wnz * c / qz) + wnz * wnz) * scale / a1;
a(1)	= 1;
a(2)	= (2 * wnp * wnp - 2 * c * c) / a1;
a(3)	= (c * c - (wnp * c / qp) + wnp * wnp) / a1;

outarray = filter(b, a, inarray);
return

% ================================================
% real allpass weighting filter (upward step)
function [outarray] = Allpass11(inarray, srate, fnz, fnp, scale)

if nargin < 5, scale = 1.0; end

wnz	    = 2 * pi * fnz;
wnp	    = 2 * pi * fnp;
c 		= wnp ./ tan(wnp / (2 * srate));
a1		= (wnp + c);
b(1)	= (wnz + c) * scale / a1;
b(2)	= (2 * wnz) * scale / a1;
b(3)	= (wnz - c) * scale / a1;
a(1)	= 1;
a(2)	= (2 * wnp) / a1;
a(3)	= (wnp - c) / a1;

outarray = filter(b, a, inarray);
return

%================================================
%generate complex two pole highpass weighting
function [wtg] = Highwtg02(xhz, fnp, qp, scale)

s	= 2.*pi.*xhz.*j;
wnp	= 2.*pi.*fnp;
wtg	= scale .* (s.^2) ./ (s.^2 + wnp.*s./qp + wnp.^2);
return

%================================================
%generate complex one pole lowpass weighting
function [wtg] = Lowwtg01(xhz, fnp, scale)

s	= 2.*pi.*xhz.*j;
wnp	= 2.*pi.*fnp;
wtg	= scale .* wnp ./ (s + wnp);
return

%================================================
%generate complex two pole lowpass weighting
function [wtg] = Lowwtg02(xhz, fnp, qp, scale)

s	= 2.*pi.*xhz.*j;
wnp	= 2.*pi.*fnp;
wtg	= scale .* (wnp.^2) ./ (s.^2 + wnp.*s./qp + wnp.^2);
return

%================================================
%generate complex transition weighting
function [wtg] = Lowwtg12(xhz, fnz, fnp, qp, scale)

s	= 2.*pi.*xhz.*j;
wnz	= 2.*pi.*fnz;
wnp	= 2.*pi.*fnp;
wtg	= scale .* ((s + wnz) ./ wnz) .* ((wnp.^2) ./ (s.^2 + wnp.*s./qp + wnp.^2));
return

%================================================
%generate complex allpass weighting
function [wtg] = Allwtg22(xhz, fnz, qz, fnp, qp, scale)

s	= 2.*pi.*xhz.*j;
wnz	= 2.*pi.*fnz;
wnp	= 2.*pi.*fnp;
wtg	= scale .* (s.^2 + wnz.*s./qz + wnz.^2) ./ (s.^2 + wnp.*s./qp + wnp.^2);
return

%================================================
%generate real allpass weighting
function [wtg] = Allwtg11(xhz, fnz, fnp, scale)

s	= 2.*pi.*xhz.*j;
wnz	= 2.*pi.*fnz;
wnp	= 2.*pi.*fnp;
wtg	= scale .* (s + wnz) ./ (s + wnp);
return


%================================================
%generate constant increment frequency scale
function [f] = Fvals(srate)

flimit = srate ./ 2;
fincr = flimit ./ 2048;
f = 0:1/srate:flimit;
f = f';
return