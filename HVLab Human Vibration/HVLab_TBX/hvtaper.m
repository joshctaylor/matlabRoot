%hvtaper - issue 2.0 (15/04/09) - HVLab HRV Toolbox
%--------------------------------------------------
%[outdata] = hvtaper(indata, tStart, tEnd, mode);
% Applies cosine tapers to the beginning and end of a time history
%
%		outdata	=  new data structure containing tapered time input history
%		indata	=  data structure containing input time history data
%		tStart	=  duration of taper applied to beginning of signal (s)
%		tEnd	=  duration of taper applied to end of signal (s)
%       mode  	=  optional string showing whether 'tStart' and 'tEnd'
%                  are specified in x-axis units (mode = 'units') or as 
%                  sample points (mode = 'points'): if this argument is 
%                  not specified, mode defaults to 'units'.
%Restrictions:
%-------------
% Input data must be a real time history
%

% Written by Chris Lewis, January 2007
% Modified by Chris Lewis, April 2009 to add optional mode
 
function [dasOutarr] = hvtaper(dasInarr, tStart, tEnd, mode)

if nargin < 2; tstart = 1; end;
if nargin < 3; tend = 1; end;
if nargin < 4; mode = 'units'; end;

error(HVFUNSTART(['COSINE TAPER'], dasInarr)); % show header and abort if input is not a valid structure

for k = 1:length(dasInarr)
    if ~HVISEMPTY(k, dasInarr(k)) % return results only for non-empty array elements
        error(HVISVALID(dasInarr(k), {'real', '~hz', '~xvar'})); % abort if input data is not a real TH
        [dasOutarr(k)] = TAPER(dasInarr(k), tStart, tEnd, mode); % apply TAPER
    end
end
return
% =========================================================================
% taper a single workspace data structure
function [dasOut] = TAPER(dasIn, tStart, tEnd, strmode)

global HV; %allow access to global parameter structure

% Create output data structure
% ----------------------------
dscrn = ['Tapered ', dasIn.title];
dasOut	= HVMAKESTRUCT(dscrn, dasIn.yunit, dasIn.xunit, 1, 0, dasIn.stats, dasIn.x);
xincr	= dasIn.x(2) - dasIn.x(1);
if strcmpi(strmode, 'units')
    nStart  = fix(tStart / xincr);
    nEnd    = fix(tEnd / xincr);
else
    nStart  = fix(tStart);
    nEnd    = fix(tEnd);    
end
if (nStart + nEnd) > length(dasIn.y)
    error('Length of data is less than specified taper lengths');
end

HVFUNPAR('sampling rate', 1/xincr, 'Hz');
HVFUNPAR('duration of starting taper', nStart * xincr, 's');
HVFUNPAR('duration of ending taper', nEnd * xincr, 's');

% generate taper functions
taperStart = (-(cos(pi.*([0:nStart-1]./(nStart-1)))-1)./2)';
taperEnd = (-(cos(pi.*([0:nEnd-1]./(nEnd-1)))-1)./2)';

% apply taper functions
dasOut.y = dasIn.y;
dasOut.y(1:nStart) = dasIn.y(1:nStart).*taperStart;
dasOut.y(length(dasOut.y)-nEnd+1:length(dasOut.y)) = dasIn.y(length(dasIn.y)-nEnd+1:length(dasIn.y)).*flipud(taperEnd);

return

