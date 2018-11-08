%hvintegral - issue 1.1 (01/02/07) - HVLab HRV Toolbox
%-----------------------------------------------------
%[integral] = hvintegral (timedata, nsections)
% Returns the numerical integral of time history data 
%
% integral 	=	name of new HVLab data structure containing the time integral 
%               of the input time-history
% timedata	= 	name of HVLab data structure containing the input 
%               time-history data
% nsections	= 	the number of integrator sections (must be 1 or 2): if this 
%               argument is not present, nsections defaults to 1
%Example:
%--------
%[displmnt] = hvintegral(acclrtn, 2) 
% returns a new HVLab data structure, displmnt, containing real data representing 
% the double integral of the input time history(s)in HVLab data structure acclrtn
%
%Notes:
%------
% The one-section integrator uses the trapezoidal form to convert acceleration 
% to velocity or velocity to displacement. The two-section integrator uses 
% the Boxer-Thaler approximation (Boxer and Thaler, 1956), which is recommended 
% for converting an acceleration time history to displacement as it has been 
% shown to result in a smaller error amplitude than repeated use of the trapezoidal 
% rule. Quantisation errors and measurement noise may cause significant low 
% frequency drifts in the output signal and it may be necessary to high-pass 
% filter the signal before integrating. It is preferable to use hvhibessel 
% for this purpose, rather than hvhibutter, since the Bessel filter has a more 
% linear phase characteristic and will therefore introduce less distortion to the 
% waveform. 

% Written by Chris Lewis October 2002
% HELP notes revised by CHL 01/02/2007
 
function [dasOutarr] = hvintegral(dasInarr, iSects)

error(HVFUNSTART(['NUMERICAL INTEGRATION'], dasInarr)); % show header and abort if input is not a valid structure
%if nargin < 3, fHpfc = 0; end - optional high pass cut-off frequency?
if nargin < 2, iSects = 1; end

for k = 1:length(dasInarr)
    if ~HVISEMPTY(k, dasInarr(k)) % return results only for non-empty array elements
        error(HVISVALID(dasInarr(k), {'real', '~hz', '~xvar'})); % abort if input data is not a real TH
        [dasOutarr(k)] = INTEGRAL(dasInarr(k), iSects); % apply integral
    end
end
return
% =========================================================================
% frequency weight a single workspace data structure
function [dasOut] = INTEGRAL(dasIn, ns)

global HV; %allow access to global parameter structure

% Create output data structure
% ----------------------------
if ns == 1 
    dscrn = ['Integral of ', dasIn.title];
    yunit = [dasIn.yunit, '.', dasIn.xunit];
else
    dscrn = ['Double integral of ', dasIn.title];
    yunit = [dasIn.yunit, '.', dasIn.xunit, '²'];
end
if or(strcmpi(dasIn.yunit, 'm/s²'), or(strcmpi(dasIn.yunit, 'm/s^2'), strcmpi(dasIn.yunit, 'ms^-^2')))
    if strcmpi(dasIn.xunit, 's') 
        if ns == 1 
            yunit = 'ms^-^1';
        else
            yunit = 'm';
        end
    end
end
dasOut	= HVMAKESTRUCT(dscrn, yunit, dasIn.xunit, 1, 0, dasIn.stats, dasIn.x);
xincr     = dasIn.x(2) - dasIn.x(1);
srate	  = 1 / xincr;
qc		  = 1 / sqrt(2);
HVFUNPAR('sampling rate', srate, 'Hz');
HVFUNPAR('number of samples', length(dasIn.y));
HVFUNPAR('number of integrations', ns);

% Implement weighting filters
% ---------------------------
if ns == 1
    dasOut.y = Integ1(dasIn.y, srate);
else
    dasOut.y = Integ2(dasIn.y, srate);
end
return

% ==================================
% trapezoidal one section integrator
function [outarray] = Integ1(inarray, srate)

c 	= 1 / (2 * srate);
b	= [c, c];
a	= [1, -1];
outarray = filter(b, a, inarray);
return

% ====================================================
% Boxer-Thaler approximation to two section integrator
function [outarray] = Integ2(inarray, srate)

c 	= 1 / (12 * srate * srate);
b	= [c, c*10, c];
a	= [1, -2, 1];
outarray = filter(b, a, inarray);
return

% ==================================
% two pole highpass weighting filter
function [outarray] = Highpass02(inarray, srate, fnp, qp)

wnp	    = 2 * pi * fnp;
c 		= wnp / tan(wnp / (2 * srate));
a1		= c * c + (wnp * c / qp) + wnp * wnp;
b(1)	= c * c / a1;
b(2)	= -2 * c * c / a1;
b(3)	= c * c / a1;
a(1)	= 1;
a(2)	= (2 * wnp * wnp - 2 * c * c) / a1;
a(3)	= (c * c - (wnp * c / qp) + wnp * wnp) / a1;
outarray = filter(b, a, inarray);
return

