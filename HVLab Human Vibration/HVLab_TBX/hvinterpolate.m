%hvinterpolate - issue 1.0 (01/02/07) - HVLab HRV Toolbox
%--------------------------------------------------------
%[outdata] = hvinterpolate (indata, increment, xlimit)
% Change the sampling increment of a data set using linear interpolation
%
% outdata	=	name of new HVLab data structure containing the interpolated 
%               data
% indata	= 	name of HVLab data structure containing the data to be 
%               interpolated (data must be real only)
% increment	= 	real value specifying the sampling increment of the 
%               interpolated data
% xlimit     = 	largest x-value in the output data: if this argument is 
%               not specified the resampling process will continue to the 
%               end of the input data set 
%Example:
%--------
%[respectra] = hvinterpolate (spectra, 0.25, 50) 
% returns a new HVLab data structure 'respectra' containing the frequency 
% spectrum in data structure 'spectra' over the range 0 to 50 Hz, resampled 
% to an increment of 0.25 Hz.

% Written by Chris Lewis, January 2007, based on code by Tom Gunston
 
function [dasOutarr] = hvinterpolate(dasInarr, newIncr, xLimit)

error(HVFUNSTART(['CHANGE SAMPLING INCREMENT'], dasInarr)); % show header and abort if input is not a valid structure
if nargin < 3, xLimit = 0; end

for k = 1:length(dasInarr)
    if ~HVISEMPTY(k, dasInarr(k)) % return results only for non-empty array elements
        error(HVISVALID(dasInarr(k), {'real', '~xvar'})); % abort if input data is not real
        [dasOutarr(k)] = INTERPOLATE(dasInarr(k), newIncr, xLimit); % interpolate
    end
end
return
% =========================================================================
% change sampling increment of a single workspace data structure
function [dasOut] = INTERPOLATE(dasIn, incr, xend)

global HV; %allow access to global parameter structure

% Create output data structure
dscrn   = ['Interpolated ', dasIn.title];
dasOut	= HVMAKESTRUCT(dscrn, dasIn.yunit, dasIn.xunit, 1, 0, dasIn.stats, dasIn.x);

oldincr	= (dasIn.x(2) - dasIn.x(1));

HVFUNPAR('original sampling increment', oldincr, dasIn.xunit);
HVFUNPAR('new sampling increment', incr, dasIn.xunit);

% generate a new timebase
xstart  = dasIn.x(1);
if xend <= 0
    xend = dasIn.x(end);
end    
dasOut.x = [xstart: incr: xend]';
dasOut.y = interp1(dasIn.x, dasIn.y, dasOut.x);

