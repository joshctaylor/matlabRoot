%hvnormalise - issue 1.2 (02/02/09) - HVLab HRV Toolbox
%------------------------------------------------------
%[outdata] = hvnormalise (indata, mode, N)
% Subtracts the mean value from a data set
%
%   outdata =	name of new workspace data structure array containing the
%               normalised input data set(s) 
%   indata	= 	name of workspace data structure array containing real data
%   mode	=	normalisation mode (see below): defaults to 'mean'
%   N       = 	if N > 0 the dataset is normalised to the mean or mean and 
%               standard deviation of only the first N points: defaults to 
%               0 (i.e. normalised to the whole dataset)  
%
%Available modes
%---------------
%   'mean': 	y = y-mean      where  is the mean value of the data
%   'mean/sd': 	y =(y-mean)/sd  where sd is the standard deviation of the
%                               data

% function written TPG 17-12-2001
% modified by CHL to include standard exception handling, September 2002
% modified TPG to add functionality to average over the first N datapoints 
%          and stop display of mean/max/min (possibly misleading) 27/7/2004 
% Modified by Chris Lewis, April 2009 to standardise HELP header format and
%          add 'mean/sd' normaisation mode

function [dasOutarr]=hvnormalise(dasInarr, strMode, N)

error(HVFUNSTART('NORMALISE DATA', dasInarr)); % show header and abort if input is not a valid structure
if nargin < 2, strMode = 'mean'; end
if nargin < 3, N = 0; end

for k = 1:length(dasInarr)
    if ~HVISEMPTY(k, dasInarr(k)) % return results only for non-empty channels
        error(HVISVALID(dasInarr(k), {'real'})); % abort if input data is not real
        [dasOutarr(k)] = NORMALISE(dasInarr(k), strMode, N); % normalise data in non-empty channel
    end
end
return

% ===========================================
% normalise a single workspace data structure
function [dasOut] = NORMALISE(dasIn, mode, points)

dasOut = HVMAKESTRUCT(dasIn.title, dasIn.yunit, dasIn.xunit, 1, 0, dasIn.stats, dasIn.x);

HVFUNPAR('number of samples', length(dasIn.y));
if dasIn.dxvar == 0; HVFUNPAR('sampling increment', dasIn.x(2) - dasIn.x(1), dasIn.xunit); end

if points == 0
    meanval = mean(dasIn.y);
    sdval = std(dasIn.y,1);
else
    points = min(points, length(dasIn.x));
    meanval = mean(dasIn.y(1:points));
    sdval = std(dasIn.y(1:points),1);
end

HVFUNPAR('mean value of input signal', meanval, dasIn.yunit);
if strcmpi(mode, 'mean')
	dasOut.y(:,1) = dasIn.y - meanval;
else
	HVFUNPAR('standard deviation of input signal', sdval, dasIn.yunit);
	dasOut.y(:,1) = (dasIn.y - meanval) / sdval;
end

return
