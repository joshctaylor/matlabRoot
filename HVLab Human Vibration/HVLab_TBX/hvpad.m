%hvpad - issue 2.1 (14/07/2010) - HVLab HRV Toolbox
%--------------------------------------------------
%[outdata] = hvpad(indata, tStart, tEnd, mode);
% Adds zeroes to the beginning and end of a data set
%
%       indata  =   new data structure containing unpadded data
%       outdata	=   data structure containing padded data
%       tStart	=   length of padding added to beginning of data (defaults
%                   to 1)
%       tEnd 	=   length of padding added to end of data (defaults
%                   to 1)
%       mode  	=	optional string showing whether 'tStart' and 'tEnd'
%               	are specified in x-axis units (mode = 'units') or as 
%               	sample points (mode = 'points'): if this argument is 
%                	not specified, mode defaults to 'units'
%Restrictions:
%-------------
% Input data must be real or complex (dtype <= 2), and must have a constant
% sampling increment (dxvar = 0)
%

% written TPG 10/6/2004
% modified by Chris Lewis, April 2009, to make format similar to other HVLab toolbox functions
% modified by Chris Lewis, July 2010, to fix errors in header

function [dasOutarr]=hvpad(dasInarr, tStart, tEnd, strMode)

if nargin < 2; tstart = 1; end;
if nargin < 3; tend = 1; end;
if nargin < 4; strMode = 'units'; end;
if strcmpi(strMode, 'units')
    samplesflag = 0;
else
    samplesflag = 1;
end

error(HVFUNSTART('PAD DATA WITH ZEROES', dasInarr)); % show header and abort if input is not a valid structure

for k = 1:length(dasInarr)
    if ~HVISEMPTY(k, dasInarr(k)) % return results only for non-empty array elements
        error(HVISVALID(dasInarr(k), {'~moph', '~xvar'})); % abort if input data is not a real TH
        [dasOutarr(k)] = PAD(dasInarr(k), tStart, tEnd, samplesflag); % apply PAD
    end
end
return

% =========================================================================
% pad a single workspace data structure with zeroes
function [outdata] = PAD(indata, tstart, tend, samplesflag)

    fs=1/(indata.x(2)-indata.x(1));
    
    % calculate the number of samples to pad at each end
    if samplesflag==0
        samplesstart=zeros(round(fs.*tstart),1);
        samplesend=zeros(round(fs.*tend),1);
    else
        samplesstart=zeros(tstart,1);
        samplesend=zeros(tend,1);
    end
    HVFUNPAR('sampling rate', fs, indata.xunit);
    HVFUNPAR('length of padding at beginning of data', tstart, indata.xunit);
    HVFUNPAR('length of padding at end of data', tend, indata.xunit);

    % pad the data and create a timebase. 
    outdata=indata;
    outdata.y=[samplesstart;tgrow(indata.y)';samplesend];
    outdata.x=[0:length(outdata.y)-1]'./fs+indata.x(1);
return

% =========================================================================
% function written tpg to force vectors of unknown orientation into rows
function [outvect]=tgrow(invect)

sz=size(invect);
if (sz(1)>sz(2))
    outvect=invect';
else
    outvect=invect;
end
return