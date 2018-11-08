%hvintegrate - issue 1.2 (21/01/10)- HVLab HRV Toolbox	
%-----------------------------------------------------
%[outdata] = hvintegrate (indata, exponent)
% Returns the cumulative integral of a function, or the cumulative VDV or 
% MSDV of an acceleration time history.
%
% outdata 	=	name of new HVLab data structure array containing the 
%               cumulative integral of the input data
% indata	= 	name of workspace data structure array containing the input 
%               data
% exponent	= 	optional exponent applied to the input data (‘1’ returns the 
%               cumulative integral, ‘2’ returns the cumulative MSDV, ‘4’ returns 
%               the cumulative VDV): see notes, below. If this argument is  
%               not supplied the exponent defaults to ‘1’. 
%Example:
%--------
%[msqr] = hvintegrate (psd)
% returns a new HVLab data structure, msqr, containing real data representing 
% the cumulative integral of power spectral density data psd. The last data 
% point in data set msqr is an estimate of the mean-square value of the data 
% from which psd was computed.
% 
%Notes:
%------
% Caution should be exercised when integrating an acceleration time history 
% to estimate velocity, or velocity time history to estimate displacement, 
% because the digitised time-history is not an exact representation of the 
% original continuous data (i.e. the information between the sampling instants 
% is missing). The rectangular integration used by this function provides less 
% attenuation of high frequencies than an ideal integrator, and introduces an 
% additional phase shift (which is proportional to the excitation frequency) 
% because the signal is delayed by T/2 where T is the sampling increment. 
%
% The recommended method for integrating a digitised time-history (e.g. when 
% converting acceleration data to velocity) is to employ the recursive trapezoidal 
% integrator algorithm used by the function hvintegral. 

% Modified CHL 29/01/2007 to bring HELP notes in line with technical manual
% Modified CHL 21/01/2010 to fix error in header

function [dasOutarr]=hvintegrate(dasInarr, strMode)

if nargin < 2; strMode = 'integral'; end

switch strMode
    case 'integral'
        iPwr = 1; 
        dscrn = 'CUMULATIVE INTEGRAL'; 
    case 'msdv'
        iPwr = 2; 
        dscrn = 'CUMULATIVE MSDV'; 
    case 'vdv'
        iPwr = 4; 
        dscrn = 'CUMULATIVE VDV'; 
    otherwise, error('Integration mode not recognised');
end

error(HVFUNSTART(dscrn, dasInarr)); % show header and abort if input is not a valid structure

for k = 1:length(dasInarr)
    if ~HVISEMPTY(k, dasInarr(k)) % return results only for non-empty channels
        error(HVISVALID(dasInarr(k), {'real', '~xvar'})); % abort if input data is not real
        [dasOutarr(k)] = INTEGRATE(dasInarr(k), iPwr); % normalise data in non-empty channel
    end
end
return
% ===========================================
% normalise a single workspace data structure
function [dasOut] = INTEGRATE(dasIn, pwr)

len = length(dasIn.y);
incr = dasIn.x(2) - dasIn.x(1);
s(1) = dasIn.y(1);
for k = 2:length(dasIn.y)
    s(k) = s(k-1) + dasIn.y(k) .^ pwr;
end

if pwr == 1 
    yunit = [dasIn.yunit, '.', dasIn.xunit];
else
    yunit = [dasIn.yunit, '.(', dasIn.xunit, ')^', num2str(1 / pwr)];
end
if or(strcmpi(dasIn.yunit, 'm/s²'), or(strcmpi(dasIn.yunit, 'm/s^2'), strcmpi(dasIn.yunit, 'ms^-^2')))
    if strcmpi(dasIn.xunit, 's') 
        switch pwr
            case 1, yunit = 'ms^-^1';
            case 2, yunit = 'ms^-^1.5';
            case 4, yunit = 'ms^-^1.75';
        end
    end
end
switch pwr
    case 1, title = ['cumulative integral of ', dasIn.title];
    case 2, title = ['cumulative MSDV of ', dasIn.title];
    case 4, title = ['cumulative VDV of ', dasIn.title];
    otherwise
        title = ['cumulative integral of ', dasIn.title];
        HVFUNPAR('exponent of integral', pwr);
end
dasOut = HVMAKESTRUCT(title, yunit, dasIn.xunit, 1, 0, dasIn.stats, dasIn.x);
HVFUNPAR('number of samples', len);
HVFUNPAR('sampling increment', dasIn.x(2) - dasIn.x(1), dasIn.xunit); %end

dasOut.y = (s' .* incr) .^ (1 / pwr);
HVFUNPAR('final value', dasOut.y(len), dasIn.xunit); %end
return
