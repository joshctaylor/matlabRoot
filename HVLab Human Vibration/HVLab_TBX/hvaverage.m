%hvaverage - issue 1.2 (02/02/09) - HVLab HRV Toolbox
%----------------------------------------------------
%[outdata] = hvaverage(method, indata1, indata2 ... indataN)
%Average data across one or more workspace data structure arrays
%
% outdata           = HVLab data structure containing the averaged data
% method            = string defining type of operation ('sum', 'mean', 
%                     'median', 'rms', 'rmq', 'sdev', 'max', 'min')
% indata1...indataN = one or more HVLab data structures containing data
%                     to be averaged
%
%Available methods:
%------------------
% ‘sum’	(sum total), ‘mean’	(mean value), ‘sdev’ (standard deviation), 
% ‘rms’	(root-mean-square), ‘rmq’ (root-mean-quad), ‘min’ (minimum value),
% ‘max’	(maximum value), ‘median’ (median value)
%
%Examples:
%---------
%[maxdata] = hvaverage (‘max’, mydata) 
%            returns an HVLab data structure, maxdata, containing the 
%            maximum values of corresponding data points in separate 
%            channels of HVLab data structure mydata
%
%[pqrbar]  = hvaverage (‘mean’, p, q, r) returns an HVLab data structure, 
%            pqrbar, containing the means of corresponding data points in 
%            HVLab data structures p, q and r 
%            (i.e: pqrbar.y(n) = (p.y(n) + q.y(n) +r.y(n)) / 3) 
%
%Notes:
%------
% If the input consists of a single (multi-channel) data structure array, the output is a
% single-channel data structure containing the average values across the input channels.
% If the input consists of several data structure arrays, the output is a
% data structure array with the same number of channels as the inputs.

% function written CHL 5/9/2002
% error fixed CHL 10/01/07
% modified CHL 02/02/2009 to bring HELP in line with technical manual

function [dasOutarr] = hvaverage(strMethod, varargin)

error(HVFUNSTART('AVERAGE ACROSS DATA SETS', varargin{1})); % show header and abort if input is not a valid structure

nstructs = length(varargin); % number of input data structures
allchnls = length(varargin{1}); % total number of channels in the first data structure
% find the non-empty channels in the first data structure
nchnls = 0;
for k = 1:allchnls
   if not(isempty(varargin{1}(k).y))
      nchnls = nchnls + 1;
      chnl(nchnls) = k; % chnl is an array containing the index numbers of the non-empty channels in the first input array
   end
end

if nstructs == 1
    HVFUNPAR('input is a single data structure')
    HVFUNPAR('number of channels averaged', nchnls)
    for k = 1:nchnls
        if k == 1
            error(HVISVALID(varargin{1}(chnl(1)))); % check integrity of data structure
            y = varargin{1}(chnl(1)).y; % y now contains a column of data from the first channel
        else
            error(HVISVALID(varargin{1}(chnl(k)), {'xaxis', 'length'}, varargin{1}(chnl(1)))); % make sure all data is same length
            y = [y, varargin{1}(chnl(k)).y]; % data from each channel is added as a new column
        end
    end
    % matrix y now contains all data, with each channel in a separate column 
    title = [strMethod, ' of ', varargin{1}(1).title];
    dasOutarr = HVMAKESTRUCT(title, varargin{1}(1).yunit, varargin{1}(1).xunit, varargin{1}(1).dtype, varargin{1}(1).dxvar, varargin{1}(1).stats, varargin{1}(1).x);
    dasOutarr.y = AVERAGE(strMethod, y, 1);
else    
    HVFUNPAR('number of data structures averaged', nstructs);
    for k = 1:nchnls
        for m = 1:nstructs
            if m == 1
                error(HVISVALID(varargin{1}(chnl(k)))); % check integrity of first data structure
                y = varargin{1}(chnl(k)).y;
            elseif ~HVISEMPTY(0, varargin{m}(chnl(k))) % make sure any non-empty channels are skipped
                error(HVISVALID(varargin{m}(chnl(k)), {'xaxis', 'length'}, varargin{m}(chnl(1)))); % make sure all data is same length
                y = [y, varargin{m}(chnl(k)).y];
            end
        end
        % matrix y now contains data from channel k of all the data structure arrays, in separate columns 
        title = [strMethod, ' of ', varargin{1}(k).title];
        dasOutarr(chnl(k)) = HVMAKESTRUCT(varargin{1}(chnl(k)).title, varargin{1}(chnl(k)).yunit, varargin{1}(chnl(k)).xunit, varargin{1}(chnl(k)).dtype, varargin{1}(chnl(k)).dxvar, varargin{1}(chnl(k)).stats, varargin{1}(chnl(k)).x);
        dasOutarr(chnl(k)).y = AVERAGE(strMethod, y, k == 1); 
    end
end
return
% ================================================
% compute statistics of data matrix across columns
function [yavrge] = AVERAGE(strMethod, ydata, msg)

switch strMethod
    case 'sum'
        if msg; HVFUNPAR('averaging method = sum total'); end
        yavrge = sum(ydata')';
    case 'mean'
        if msg; HVFUNPAR('averaging method = mean value'); end
        yavrge = mean(ydata')';
    case 'rms'
        if msg; HVFUNPAR('averaging method = root-mean-square'); end
        yavrge = sqrt(mean(ydata'.^2))';
    case 'rmq'
        if msg; HVFUNPAR('averaging method = root-mean-quad'); end
        yavrge = sqrt(sqrt(mean(ydata' .^4)))';
    case 'sdev'
        if msg; HVFUNPAR('averaging method = standard deviation'); end
        yavrge = std(ydata', 1)';
    case 'max'
        if msg; HVFUNPAR('averaging method = maximum value'); end
        yavrge = max(ydata')';
    case 'min'
        if msg; HVFUNPAR('averaging method = minimum value'); end
        yavrge = min(ydata')';
    case 'median'
        if msg; HVFUNPAR('averaging method = median'); end
        yavrge = median(ydata')';
%    case 'q1'
%        if msg; HVFUNPAR('averaging method = lower quartile'); end
%        yavrge = todo;
%    case 'q2'
%        if msg; HVFUNPAR('averaging method = upper quartile'); end
%        yavrge = todo;
    otherwise
        error('Averaging method not recognised')
end
return
