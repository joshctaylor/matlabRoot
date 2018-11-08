%hvstats - issue 2.2 (04/12/08) - HVLab HRV Toolbox
%--------------------------------------------------
% Displays statistical information about channels in a data structure array
% [sdev, maximum, minimum, mean, rms, duration] = hvstats(datastruct)
%   sdev	    = row array containing standard deviations of data channels
%   maximum	    = row array containing maxima of data channels
%   minimum	    = row array containing minima of data channels
%   mean	    = row array containing mean values of data channels
%   rms         = row array containing r.m.s. values of data channels
%   duration    = row array containing duration of data (s)
%   datastruct	= name of workspace data structure array

% written by Chris Lewis, September 2002
% modified by Chris Lewis, August 2006 to calculate r.m.s. values
% modified by Chris Lewis, June 2007 to output r.m.s. values
% modified by Chris Lewis, Dec 2008 to change order of outputs

function [sdval, maxval, minval, meanval, rmsval, duration] = hvstats(dasInarr)

error(HVFUNSTART('STATISTICS OF DATA STRUCTURE', dasInarr)); % show header and abort if input is not a valid structure

for k = 1:length(dasInarr)
    if ~HVISEMPTY(k, dasInarr(k)) % return results only for non-empty array elements
        error(HVISVALID(dasInarr(k))); 
        [sdval(k), maxval(k), minval(k), meanval(k), rmsval(k), duration(k)] = STATS(dasInarr(k)); % compute stats
    end
end
return
% =====================================================
% compute statistics of single workspace data structure
function [sdval, maxval, minval, meanval, rmsval, xlen] = STATS(dasIn)

if dasIn.dtype == 1; HVFUNPAR('number of real samples', length(dasIn.y)); end
if dasIn.dtype == 2; HVFUNPAR('number of complex samples', length(dasIn.y)); end
if dasIn.dtype == 3; HVFUNPAR('number of modulus & phase pairs', length(dasIn.y)); end
if dasIn.dxvar == 0 
    HVFUNPAR('sampling increment', dasIn.x(2) - dasIn.x(1), dasIn.xunit); 
    xlen = max(dasIn.x) - min(dasIn.x);
    HVFUNPAR('length of x-axis', max(dasIn.x) - min(dasIn.x), dasIn.xunit);
else
    xlen = max(dasIn.x);
    HVFUNPAR('limit of x-axis', xlen, dasIn.xunit);
end
meanval = mean(dasIn.y);
rmsval = sqrt(mean(dasIn.y .^2));
%rmqval = sqrt(sqrt(mean(dasIn.y .^4)));
sdval = std(dasIn.y,1);
maxval = max(dasIn.y);
minval = min(dasIn.y);
HVFUNPAR('mean value', meanval, dasIn.yunit);
HVFUNPAR('r.m.s. value', rmsval, dasIn.yunit);
HVFUNPAR('standard deviation', sdval, dasIn.yunit);
HVFUNPAR('maximum value', maxval, dasIn.yunit);
HVFUNPAR('minimum value', minval, dasIn.yunit);
if dasIn.dtype == 3
    meanval = meanval(1);
    rmsval = rmsval(1);    
    sdval = sdval(1);
    maxval = maxval(1);
    minval = minval(1);
end
return