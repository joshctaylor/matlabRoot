%hvextract - issue 2.4 (15/10/09) - HVLab HRV Toolbox
%----------------------------------------------------
%[outdata] = hvextract (indata, length, start, mode, xorigin);
% Copies part of a data set to a new data structure 
%
%       outdata     = 	data structure array containing extracted data
%       indata      =	data structure array containing the whole data set
%       length      = 	length of data to copy from indata to outdata 
%       start       =	beginning of the data to be copied. If this argument 
%                       is not specified this will default to the beginning
%                       of the input data set
%       mode        =	optional string showing whether 'length' and 'start'
%                       are specified in x-axis units (mode = 'units') or as 
%                       sample points (mode = 'points'). If this argument is 
%                       not specified, mode defaults to 'units'.
%       xorigin     =	optional string indicating whether the x-axis of
%                       the extracted data is unchanged (xorigin = 'start')
%                       or normalised to start at 0 (xorigin = 'zero'): if 
%                       this argument is not specified xorigin defaults to
%                       'zero'
%                       

% Written by Chris Lewis, February 2008
% Updated by CHL to optionally define 'start' and 'length' in time units, May 2008 
% Updated by CHL to avoid warnings when result of sample calculations is non-integer, Dec 2008 
% Updated by CHL to optionally start the x-axis at an arbitrary value (e.g. zero), Feb 2009 
% Updated by CHL to fix problem with 'xstart' when mode = 'points', June 2009 
% Updated by CHL to enable complex outputs (dtype > 1), October 2009 
 
function [dasOutarr] = hvextract(dasInarr, xlength, xstart, strMode, strOrigin)

if nargin < 3; start = 0;           end;
if nargin < 4; strMode = 'units';   end;
if nargin < 5; strOrigin = 'zero';  end;

error(HVFUNSTART(['EXTRACT DATA POINTS'], dasInarr)); % show header and abort if input is not a valid structure

for k = 1:length(dasInarr)
    if ~HVISEMPTY(k, dasInarr(k)) % return results only for non-empty array elements
        error(HVISVALID(dasInarr(k), {'~xvar'})); % abort if input data is variable increment
        [dasOutarr(k)] = EXTRACT(dasInarr(k), xlength, xstart, strMode, strOrigin); % EXTRACT data
    end
end
return
% =========================================================================
% extract data from a single workspace data structure
function [dasOut] = EXTRACT(dasIn, xlen, xorig, strmode, strorig)

global HV; %allow access to global parameter structure

% Create output data structure
% ----------------------------
dscrn = ['extract from ', dasIn.title];
dasOut	= HVMAKESTRUCT(dscrn, dasIn.yunit, dasIn.xunit, dasIn.dtype, 0);
xincr	= dasIn.x(2) - dasIn.x(1);
nsamples  = length(dasIn.x);

switch strmode
    case 'points'
        if xorig < 1; xorig = 1; end
        nlen = xlen;
        nstart = xorig;
        xlen = nlen * xincr;
        xstart = (xorig - 1) * xincr;
    case 'samples'
        if xorig < 1; xorig = 1; end
        nlen = xlen;
        nstart = xorig;
        xlen = nlen * xincr;
        xstart = (xorig - 1) * xincr;
    case 'units'
        nlen = round(xlen / xincr); 
        nstart = 1 + round(xorig / xincr); 
        xstart = xorig;    
    otherwise
        error('mode not recognised')
end

nend = (nstart + nlen);
if nend > nsamples
    nend = nsamples;
end

HVFUNPAR('sampling increment', xincr, dasIn.xunit);
HVFUNPAR('start of extracted data', xstart, dasIn.xunit);
HVFUNPAR('length of extracted data', xlen, dasIn.xunit);

if dasIn.dtype == 3
    dasOut.y(:,1) = dasIn.y(nstart:nend,1);
    dasOut.y(:,2) = dasIn.y(nstart:nend,2);
else
    dasOut.y = dasIn.y(nstart:nend);
end
    dasOut.x(:,1) = dasIn.x(nstart:nend);

if strcmp(strorig, 'zero'); dasOut.x = dasOut.x - dasOut.x(1); end;

return

