%hvresample - issue 2.2 (09/06/08) - HVLab HRV Toolbox
%------------------------------------------------------
%[outData] = hvresample(inData, newrate, lpfreq)
% Function to resample the channels of a time history at a new sampling rate
% dataset	= a dataset containing channels to be resampled
% newrate	= the new sampling rate in Hz
% lpfreq	= (optional zero-phase 8-pole Butterworth low-pass filter). 
%             If the new sampling rate is less than the old rate the maximum 
%             cut-off is 0.5 of the new rate. If lpfreq is not specified the 
%             filter defaults to 0.33 of the new rate and is applied before
%             resampling. If the new sampling rate is greater than the old 
%             rate, the filter (if specified) is applied after re-sampling.

% Re-written by Chris Lewis, January 2007, based on code by Tom Gunston
% HELP notes revised by Chris Lewis, February 2008
% Modified by CHL June 2008 to produce columnar, rather than row, data
 
function [dasOutarr] = hvresample(dasInarr, newRate, lpFreq)

error(HVFUNSTART(['RESAMPLE TIME HISTORY'], dasInarr)); % show header and abort if input is not a valid structure
if nargin < 3, lpFreq = 0; end

for k = 1:length(dasInarr)
    if ~HVISEMPTY(k, dasInarr(k)) % return results only for non-empty array elements
        error(HVISVALID(dasInarr(k), {'real', '~hz', '~xvar'})); % abort if input data is not a real TH
        [dasOutarr(k)] = RESAMPLE(dasInarr(k), newRate, lpFreq); % resample
    end
end
return
% =========================================================================
% resample a single workspace data structure
function [dasOut] = RESAMPLE(dasIn, newrate, lpfc)

global HV; %allow access to global parameter structure

% Create output data structure
dscrn   = ['Resampled ', dasIn.title];
dasOut	= HVMAKESTRUCT(dscrn, dasIn.yunit, dasIn.xunit, 1, 0, dasIn.stats, dasIn.x);

oldrate	= 1 / (dasIn.x(2) - dasIn.x(1));

HVFUNPAR('original sampling rate', oldrate, 'Hz');
HVFUNPAR('new sampling rate', newrate, 'Hz');

% generate a new timebase
tstart  = dasIn.x(1);
tend    = dasIn.x(end);
dasOut.x = [tstart: 1./newrate: tend]';

% check for interpolation rather than decimation
if newrate > oldrate
    HVFUNPAR('Data will be resampled by interpolation');
    dasOut.y = interp1(dasIn.x, dasIn.y, dasOut.x);

    if lpfc > 0
        HVFUNPAR('Low pass frequency', lpfc, 'Hz');
        dasOut.y = LOFILTER(dasOut.y, newrate, lpfc);
    end   
else
    HVFUNPAR('Data will be resampled by decimation');

    % check filter frequency and apply
    if lpfc == 0; lpfc = newrate * 0.33; end
    if lpfc > (newrate ./ 2); lpfc = newrate * 0.5; end
    HVFUNPAR('Low pass frequency', lpfc, 'Hz');
    dasIn.y = LOFILTER(dasIn.y, oldrate, lpfc);
    dasOut.y = interp1(dasIn.x, dasIn.y, dasOut.x);
end

return
% =========================================================================
% lowpass filter
function [outdata] = LOFILTER(indata, sr, fc)

[b,a] = butter(4, fc./(sr./2), 'low');
outdata = filtfilt(b, a, indata);

return