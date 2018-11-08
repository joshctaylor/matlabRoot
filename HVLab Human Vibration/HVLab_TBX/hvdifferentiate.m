%hvdifferentiate - issue 1.0 (10/03/10) - HVLab HRV Toolbox
%----------------------------------------------------------
%[differential] = hvdifferentiate (indata)
% Returns the differential of a function
%
% differential 	= name of new HVLab data structure containing the 
%                 differentials of the input data
% indata        = name of HVLab data structure containing the (real) input 
%                 data
%
%Notes:
%------
% Caution should be exercised when differentiating a velocity time history 
% to estimate acceleration, or displacement time history to estimate
% acceleration because the digitised time-history is not an exact
% representation of the original continuous data (i.e. the information
% between the sampling instants is missing). The gradient calculation used
% by this function provides more attenuation of higher frequencies ( >
% sample-rate/10) than an ideal integrator. 
% 
% An alternative method for differentiating a digitised time-history (e.g.
% when converting velocity data to acceleration) is the recursive
% trapezoidal algorithm used by the function hvdifferential. This provides
% accurate results up about sample-rate/5, but the gain of the trapezoidal
% integrator tends to infinity at frequencies very near to half the
% sampling rate. Hence quantisation errors and measurement noise can cause
% significant high frequency noise in the output signal.
%
% Written by Chris Lewis, 11/03/2010

function [dasOutarr] = hvdifferentiate(dasInarr)

error(HVFUNSTART(['GRADIENT DIFFERENTIATION'], dasInarr)); % show header and abort if input is not a valid structure

for k = 1:length(dasInarr)
    if ~HVISEMPTY(k, dasInarr(k)) % return results only for non-empty array elements
        error(HVISVALID(dasInarr(k), {'real', '~xvar'})); % abort if input data is not real
        [dasOutarr(k)] = DIFFERENTIATE(dasInarr(k)); % differentiate each channel
    end
end
return
% =========================================================================
% frequency weight a single workspace data structure
function [dasOut] = DIFFERENTIATE(dasIn)

global HV; %allow access to global parameter structure

% Create output data structure
% ----------------------------
dscrn = ['Differential of ', dasIn.title];
yunit = [dasIn.yunit, '/', dasIn.xunit];

if strcmpi(dasIn.yunit, 'm') 
	yunit = 'm/s';
elseif strcmpi(dasIn.yunit, 'm/s') 
    yunit = 'm/s^2';
elseif strcmpi(dasIn.yunit, 'm/s^2') 
    yunit = 'm/s^3';
else
    yunit = [dasIn.yunit '/' dasIn.xunit];
end

dasOut	= HVMAKESTRUCT(dscrn, yunit, dasIn.xunit, 1, 0, dasIn.stats, dasIn.x);
xincr     = dasIn.x(2) - dasIn.x(1);
dasOut.y = gradient(dasIn.y, xincr);
HVFUNPAR('sampling increment', xincr, dasIn.xunit);
HVFUNPAR('number of samples', length(dasIn.y));

return


