%hvrunaverage - issue 1.1 (12/06/09) - HVLab HRV Toolbox
%-------------------------------------------------------
%[outdata] = hrunvaverage(indata, method, window-length, increment, mode)
% Running average of successive points in data sets, using a rectangular
% window
%
% outdata       = HVLab data structure containing the averaged data
% indata        = HVLab data structure containing data to be averaged
% method        = lower case string describing the averaging procedure
%                 to be applied
% window-length = length of averaging window
% increment     = increment of output data - if this argument is not 
%                 present the increment defaults to the same value as the
%                 window-length
% mode          = optional string showing whether window-length and
%                 increment are specified in x-axis units (mode = 'units')
%                 or as sample points (mode = 'points') - if this argument
%                 is not specified, mode defaults to 'units'
%
%Available averaging methods:
%----------------------------
%   ‘sdev’       = standard deviation
%   ‘rms’        = root-mean-square value
%   ‘rmq’        = root-mean-quad value
%   ‘mean’       = mean value
%   ‘median’     = median value
%   ‘minimum’    = minimum value
%   ‘maximum’    = maximum value
%
%Restrictions:
%-------------
% The input data must be real (dtype = 1) or modulus-and-phase (dtype = 3)
%
%Notes:
%------
% This function calculates running averages of the data in the input data
% structure. Averaging is performed over successive sections of the input
% file. The size of these sections is determined by the window-length and
% the increment determines the spacing of the windows. The increment
% cannot be larger than the window-length. If the increment is smaller than
% the window length, the sections will overlap, thus producing a smoother
% output.
%
% To compute the running r.m.s. average using an exponential window use
% the function "hvrunrms".
%

% function written CHL 02/03/2009
% Updated by CHL to fix problem with 'xstart' when mode = 'samples', June 2009 

function [dasOutarr] = hvrunaverage(dasInarr, strMethod, wlength, increment, strMode)

if nargin < 2; strMethod = 'sdev'; end;
if nargin < 3; wlength = 1.0; end;
if nargin < 4; increment = wlength; end;
if nargin < 5; strMode = 'units'; end;

error(HVFUNSTART('RUNNING AVERAGE', dasInarr)); % show header and abort if input is not a valid structure

for k = 1:length(dasInarr)
    if ~HVISEMPTY(k, dasInarr(k)) % return results only for non-empty array elements
        error(HVISVALID(dasInarr(k), {'~cmplx','~xvar'})); % abort if input data is complex or variable increment
        [dasOutarr(k)] = RUNAVERAGE(dasInarr(k), strMethod, wlength, increment, strMode); % apply integral
    end
end
return
% =========================================================================
% running average of a single workspace data structure
function [dasOut] = RUNAVERAGE(dasIn, strmethod, winlen, wincr, strmode)

global HV; %allow access to global parameter structure

% Create output data structure
dscrn = ['running average of ', dasIn.title];
dasOut	= HVMAKESTRUCT(dscrn, dasIn.yunit, dasIn.xunit, 1, 0, dasIn.stats);

wincr = min(wincr, winlen);
xincr = (dasIn.x(2) - dasIn.x(1));

switch strmode
    case 'samples'
        nlen = winlen;
        nincr = wincr;
    case 'points'
        nlen = winlen;
        nincr = wincr;
    case 'units'
        nlen = round(winlen / xincr);
        nincr = round(wincr / xincr);
    otherwise
        error('mode not recognised')
end

switch strmethod
    case 'sum'
        HVFUNPAR('averaging method = sum total');
    case 'mean'
        HVFUNPAR('averaging method = mean value');
    case 'rms'
        HVFUNPAR('averaging method = root-mean-square');
    case 'rmq'
        HVFUNPAR('averaging method = root-mean-quad');
    case 'sdev'
        HVFUNPAR('averaging method = standard deviation');
    case 'max'
        HVFUNPAR('averaging method = maximum value');
    case 'min'
        HVFUNPAR('averaging method = minimum value');
    case 'median'
        HVFUNPAR('averaging method = median');
    otherwise
        error('averaging method not recognised')
end

HVFUNPAR('increment of input data', xincr, dasIn.xunit);
HVFUNPAR('increment of output data', nincr*xincr, dasIn.xunit);
HVFUNPAR('length of averaging window', nlen*xincr, dasIn.xunit);
HVFUNPAR('averaging window overlap', round(100*(nlen - nincr)/nlen), '%');

nsegments = fix((length(dasIn.x) - nlen + nincr)/nincr);
nstart = 1;
for k = 1:nsegments
    nend = nstart + nlen - 1;
    if dasIn.dtype == 3
        dasOut.y(k,1) = AVERAGE(strmethod, dasIn.y(nstart:nend,1));
        dasOut.y(k,2) = AVERAGE(strmethod, dasIn.y(nstart:nend,2));        
    else
        dasOut.y(k,:) = AVERAGE(strmethod, dasIn.y(nstart:nend));
    end
    dasOut.x(k,:) = (nend - nlen/2) * xincr;
    nstart = nstart + nincr;
end

return
% =========================================================================
% average samples according to method
function [yavrge] = AVERAGE(method, ydata)

switch method
    case 'sum'
        yavrge = sum(ydata')';
    case 'mean'
        yavrge = mean(ydata')';
    case 'rms'
        yavrge = sqrt(mean(ydata'.^2))';
    case 'rmq'
        yavrge = sqrt(sqrt(mean(ydata'.^4)))';
    case 'sdev'
        yavrge = std(ydata', 1)';
    case 'max'
        yavrge = max(ydata')';
    case 'min'
        yavrge = min(ydata')';
    case 'median'
        yavrge = median(ydata')';
    otherwise
        error('Averaging method not recognised')
end
return
