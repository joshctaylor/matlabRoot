%hvmerge - issue 1.2 (21/04/2009) - HVLab HRV Toolbox
%----------------------------------------------------
%[outdata] = hvmerge (data1, data2, … dataN)
% Merge two or more data sets end-to-end
% outdata 	=	name of new HVLab data structure containing the merged data. 
% data1     = 	name of HVLab data structure containing the first data set 
%               to be merged. If only one input argument is present and data1 
%               contains more than one data channel, outdata will contain a 
%               single data channel comprising data from each of the individual 
%               channels of data1 merged end-to-end.
% data2, …dataN	= names of HVLab data structures to be merged end-to-end with data1.
%
%Example:
%--------
%[data123] = hvmerge (data1, data2, data3) 
% returns an HVLab data structure, data123, containing three data sets, 
% data1, data2 and data3, merged end-on-end. 
%[alldata] = hvmerge (chnldata) 
% returns a single-channel HVLab data structure, alldata, containing the 
% data from each channel in multi-channel data structure chnldata, merged end-on-end.
%
%Notes:
%------
%The input data structures must all contain the same number of data channels 
% (or rows if they comprise row arrays). 
%The input data sets must not be variable increment (i.e. dxvar = 0) and must 
% all be the same type (as indicated by dtype).  


% Written by Chris Lewis, February 2007
% Modified by CHL June 2007 to fix problem with x-axis values
% Modified by CHL November 2008 to fix problem with recognising channels in input structs
% Modified by CHL April 2009 to cope with input data incorrectly formatted as row vectors

function [dasOut] = hvmerge(varargin)

error(HVFUNSTART(['MERGE DATA SETS END-TO-END'], varargin{1})); % show header and abort if input 1 is not a valid structure

if length(varargin) == 1

    dasIn   = varargin{1}(1);
    nc = length(dasIn);     % number of channels
    HVFUNPAR(['Combining ',num2str(nc),' channels into one data structure'])
 
    dscrn   = ['Merged ', dasIn(1).title];
    dasOut	= HVMAKESTRUCT(dscrn, dasIn(1).yunit, dasIn(1).xunit, 1, 0, dasIn(1).stats);
    incr1	= (dasIn(1).x(2) - dasIn(1).x(1));
    
    dasOut.x = [];
    dasOut.y = [];
    for k = 1:nc
        error(HVISVALID(dasIn(k), {'real', '~xvar'})); % abort if input data is not real
        incr     = (dasIn(k).x(2) - dasIn(k).x(1));
        if incr ~= incr1; HVFUNPAR('WARNING: data increments are unequal'); end 
        dasOut.y = [dasOut.y; COLS(dasIn(k).y)];
    end
    xlen = length(dasOut.y);
    xlimit = (xlen -1) * incr;
    dasOut.x =(0: incr: xlimit)';
end

if length(varargin) > 1

    dasIn = varargin{1};
    nc = length(dasIn);     % number of channels in first struct
    ns = length(varargin);  % number of input structs
    HVFUNPAR(['Combining ',num2str(ns),' data structures'])
    
    for k = 1:nc
        dscrn   = ['Merged ', dasIn(k).title];
        dasOut(k)	= HVMAKESTRUCT(dscrn, dasIn(k).yunit, dasIn(k).xunit, 1, 0, dasIn(k).stats);
        incr1(k)	= (dasIn(k).x(2) - dasIn(k).x(1));
    
        dasOut(k).x = [];
        dasOut(k).y = [];
        for j = 1:ns
            dasIn(k)= varargin{j}(k);
            error(HVISVALID(dasIn(k), {'real', '~xvar'})); % abort if input data is not real
            incr = (dasIn(k).x(2) - dasIn(k).x(1));
            if incr ~= incr1(k); HVFUNPAR('WARNING: data increments are unequal'); end 
            dasOut(k).y = [dasOut(k).y; COLS(dasIn(k).y)];
        end
        xlen = length(dasOut(k).y);
        xlimit = (xlen -1) * incr;
        dasOut(k).x =(0: incr: xlimit)';
    end
end
return

% =============================================================
% function to force vectors of unknown orientation into columns
function [outvect]=COLS(invect)

sz=size(invect);
if (sz(2)>sz(1))
    outvect=invect';
else
    outvect=invect;
end
return
