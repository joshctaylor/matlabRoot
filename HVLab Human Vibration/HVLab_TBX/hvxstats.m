%hvxstats - issue 1.0 (31/03/09) - HVLab HRV Toolbox
%---------------------------------------------------
%[xincrement, xlimit, xorigin, nsamples] = hvxstats(datastruct)
% Returns x-axis parameters of channels in a data structure array
%   increment	= row array containing sampling increment of data channels:
%                 returns zero for variable increment data (dxvar=1)
%   xlimit	    = row array containing the maximum x-axis values
%   xorigin	    = row array containing the minimum x-axis values
%   nsamples    = row array containing the number of samples in the data
%                 sets
%

% written by Chris Lewis, March 2009


function [xincrement, xlimit, xorigin, nsamples] = hvxstats(dasInarr)

error(HVFUNSTART('X-AXIS PARAMETERS OF DATA STRUCTURE', dasInarr)); % show header and abort if input is not a valid structure

for k = 1:length(dasInarr)
    if ~HVISEMPTY(k, dasInarr(k)) % return results only for non-empty array elements
        error(HVISVALID(dasInarr(k))); 
        [xincrement(k), xlimit(k), xorigin(k), nsamples(k)] = XSTATS(dasInarr(k)); % compute stats
    end
end
return
% =====================================================
% compute statistics of single workspace data structure
function [xincr, xlimit, xorigin, nsamples] = XSTATS(dasIn)

nsamples = length(dasIn.x);
HVFUNPAR('number of data samples', nsamples);
if dasIn.dxvar == 0 
    xincr = mean(diff(dasIn.x));
    HVFUNPAR('sampling increment', xincr, dasIn.xunit); 
else
    xincr = 0;
    HVFUNPAR('data has a variable sampling increment'); 
end

xorigin = min(dasIn.x);
HVFUNPAR('origin of x-axis', xorigin, dasIn.xunit);
xlimit = max(dasIn.x);
HVFUNPAR('limit of x-axis', xlimit, dasIn.xunit);
return