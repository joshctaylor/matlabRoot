%hvdifferential - issue 1.3 (11/03/10) - HVLab HRV Toolbox
%---------------------------------------------------------
%[differential] = hvdifferential (timedata, nsections)
% Computes the single or double differential of time history data 
%
% differential 	= name of new HVLab data structure containing the time integral 
%                 of the input time-history
% timedata      = name of HVLab data structure containing the (real) input 
%                 time-history data
% nsections     = the number of differentiator sections (must be 1 or 2): if 
%                 this argument is not present, nsections defaults to 1
%
%Example:
%--------
%[acclrn] = hvdifferential (displ, 2) 
% returns a new HVLab data structure, acclrn, containing real data representing 
% the double differential of the input time history(s)in HVLab data structure displ
%
%Notes:
%------
% This function is provided as a means of converting a velocity time
% history to acceleration (nsections = 1), or displacement to acceleration
% (nsections = 2). The gain of the trapezoidal integrator tends to infinity
% at frequencies very near to half the sampling rate. Hence quantisation
% errors and measurement noise can cause significant high frequency noise
% in the output signal and it may be necessary to low-pass filter the
% signal before differentiating. It is preferable to use the function
% hvlobessel for this purpose, rather than hvlobutter, since the Bessel
% filter has a more linear phase characteristic and will introduce less
% distortion to the waveform. 
%
% An alternative method for differentiating a function is provided by the
% function hvdifferentiate. The gradient calculation used by this function
% is less susceptible to quantisation errors and measurement noise, but
% provides more attenuation of higher frequencies ( > sample-rate/10) than
% an ideal integrator.
%

% Written by Chris Lewis, January 2007
% HELP notes revised CHL 01/02/2007
% HELP notes revised CHL 02/02/2009
% HELP notes revised, and 2-section differentiation enabled CHL 11/03/2010

function [dasOutarr] = hvdifferential(dasInarr, iSects)

error(HVFUNSTART(['NUMERICAL DIFFERENTIATION'], dasInarr)); % show header and abort if input is not a valid structure
if nargin < 2, iSects = 1; end

for k = 1:length(dasInarr)
    if ~HVISEMPTY(k, dasInarr(k)) % return results only for non-empty array elements
        error(HVISVALID(dasInarr(k), {'real', '~hz', '~xvar'})); % abort if input data is not a real TH
        [dasOutarr(k)] = DIFFERENTIAL(dasInarr(k), iSects); % apply integral
    end
end
return
% =========================================================================
% frequency weight a single workspace data structure
function [dasOut] = DIFFERENTIAL(dasIn, ns)

global HV; %allow access to global parameter structure

% Create output data structure
% ----------------------------
if ns == 1 
    dscrn = ['Differential of ', dasIn.title];
    yunit = [dasIn.yunit, '/', dasIn.xunit];
else
    dscrn = ['Double differential of ', dasIn.title];
    yunit = [dasIn.yunit, '/', dasIn.xunit, '²'];
end
if strcmpi(dasIn.yunit, 'm') 
	if ns == 1 
        yunit = 'm/s';
    else
        yunit = 'm/s^2';
	end
elseif strcmpi(dasIn.yunit, 'm/s') 
	if ns == 1 
        yunit = 'm/s^2';
    else
        yunit = 'm/s^3';
	end
else
	if ns == 1 
        yunit = [dasIn.yunit '/' dasIn.xunit];
    else
        yunit = [dasIn.yunit '/' dasIn.xunit '^2'];
	end
end

dasOut	= HVMAKESTRUCT(dscrn, yunit, dasIn.xunit, 1, 0, dasIn.stats, dasIn.x);
xincr     = dasIn.x(2) - dasIn.x(1);
srate	  = 1 / xincr;
qc		  = 1 / sqrt(2);
HVFUNPAR('sampling rate', srate, 'Hz');
HVFUNPAR('number of samples', length(dasIn.y));
HVFUNPAR('number of differentiations', ns);

% Implement weighting filters
% ---------------------------
if ns == 1
    dasOut.y = Diff1(dasIn.y, srate);
else
    dasOut.y = Diff2(dasIn.y, srate);
end
return

% ======================================
% trapezoidal one section differentiator
function [outarray] = Diff1(inarray, srate)

c 	= 1 / (2 * srate);
b	= [1, -1];
a	= [c, c];
outarray = filter(b, a, inarray);
return

% ======================================
% trapezoidal two section differentiator
function [outarray] = Diff2(inarray, srate)

c 	= 1 / (4 * srate * srate);
b	= [1, -2, 1];
a	= [c, c*2, c];
outarray = filter(b, a, inarray);
return


