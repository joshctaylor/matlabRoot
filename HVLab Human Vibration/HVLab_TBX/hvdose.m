%hvdose - issue 2.0 (17/03/09) - HVLab HRV Toolbox
%-------------------------------------------------
%[dose, time_to_value] = hvdose(datastruct, mode, value)
% Calculates the vibration dose value, motion sickness dose value or
% equivalent 8 hour acceleration magnitude from an acceleration time
% history, and the estimated exposure time to attain a specified value
%
%   dose	        =   row array containing dose values of data channels
%   time_to_value   =   row array containing estimated times (in h) to 
%                       reach the given "value"
%   datastruct	    =   name of workspace data structure array
%   mode	        =   type of dose calculation ('vdv', 'msdv', 'a8')
%   value           =   optional VDV, MSDV or A8 used to estimate
%                       "time_to_value" - if this argument is not specified, 
%                       value will default to 15.0 (for VDV), 30 (for MSDV) 
%                       or 2.8 (for A(8)) 
%
%Allowed combinations of data types:
%-----------------------------------
% The input data must all be a real (dtype = 1) time history
%

% written by Chris Lewis, October 2002
% modified CHL 02/02/2009 to bring HELP in line with technical manual
% modified CHL 17/03/2009 to fix problem with time to A(8) and include no.
%  of operations needed to reach VDV and A(8) values

function [dose, time] = hvdose(dasInarr, strMode, fValue)

switch strMode
    case 'vdv'
        dscrn = 'VIBRATION DOSE VALUE';
        if nargin < 3; fValue = 15; end
    case 'msdv'
        dscrn = 'MOTION SICKNESS DOSE VALUE';
        if nargin < 3; fValue = 30; end
    case 'a8'
        dscrn = 'EQUIVALENT 8-h ACCELERATION DOSE';
        if nargin < 3; fValue = 2.8; end
    otherwise, error('Unrecognised dose calculation');
end
error(HVFUNSTART(dscrn, dasInarr)); % show header and abort if input is not a valid structure

for k = 1:length(dasInarr)
    if ~HVISEMPTY(k, dasInarr(k)) % return results only for non-empty array elements
        error(HVISVALID(dasInarr(k), {'real', '~hz', '~xvar'})); % input must be a uniformly sampled time history 
        [dose(k), time(k)] = DOSE(dasInarr(k), strMode, fValue); % compute vdv
    end
end
return

% ===============================================================
% compute dose value of single workspace data structure
function [dose, time] = DOSE(dasIn, mode, value)

samples = length(dasIn.y);
increment = dasIn.x(2) - dasIn.x(1);
duration = max(dasIn.x) - min(dasIn.x);
HVFUNPAR('duration of input signal', duration, dasIn.xunit);

doseunit = [];
timeunit = [];
if strcmpi(dasIn.xunit, 's')
    timeunit = 'hours';
    if or(strcmpi(dasIn.yunit, 'm/s²'), or(strcmpi(dasIn.yunit, 'm/s^2'), strcmpi(dasIn.yunit, 'ms^-^2')))
        switch mode
            case 'vdv'; doseunit = 'ms^-^1.75';
            case 'msdv'; doseunit = 'ms^-^1.5';
            case 'a8'; doseunit = 'ms^-^2';
        end
    else
        HVFUNPAR('WARNING: unexpected units'); 
    end
else
    HVFUNPAR('WARNING: unexpected x-axis units'); 
end

switch mode
    case 'vdv'
        dose = (increment .* sum(dasIn.y .^4)).^0.25;
        time = (duration * (value / dose).^4) / 3600;
        nops = fix((value / dose)^4);
        HVFUNPAR('vibration dose value (VDV)', dose, doseunit);
        HVFUNPAR(['time to reach VDV of ', num2str(value)], time, timeunit);
        HVFUNPAR(['no. of similar operations to reach VDV of ', num2str(value)], nops);
    case 'msdv'
        dose = (increment .* sum(dasIn.y .^2)).^0.5;
        time = (duration * (value / dose).^2) / 3600;
        HVFUNPAR('motion sickness dose value (MSDV)', dose, doseunit);
        HVFUNPAR(['time to reach MSDV of ', num2str(value)], time, timeunit);
    case 'a8'
        rmsval = sqrt(mean(dasIn.y .^2));
        dose = rmsval * (duration / 28800).^0.5;
        time = (duration * (value / dose).^2) / 3600;
        nops = fix((value / dose).^2);
        HVFUNPAR('rms magnitude', rmsval, dasIn.yunit);
        HVFUNPAR('A(8)', dose, doseunit);
        HVFUNPAR(['time to reach A(8) of ', num2str(value)], time, timeunit);
        HVFUNPAR(['no. of similar operations to reach A(8) of ', num2str(value)], nops);
end
return;