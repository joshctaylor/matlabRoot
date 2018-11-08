%HVFUNPAR - issue 1.2 (27/01/10) - HVLab HRV Toolbox
%--------------------------------------------------- 
%[] = HVFUNPAR(strDescription, value, strUnits)
% If HV.MESSAGES is set, displays a parameter value in command window
%
%   strDescription  = string containing parameter name
%   value           = optional numeric value for parameter 
%   strUnits        = optional string containing units of parameter
%
%Examples:
%--------
%HVFUNPAR(‘Origin of data’, struct.x(1), struct.xunit)
%HVFUNPAR(‘WARNING: sampling rate is too low')
%

% Modified TPG 22-8-2002 to check for the existence of the MESSAGES field
% of the HV global and set this to 1 if it does not exist. 
% Modified TPG 23-12-2003 to remove the 22-8-2002 modification and to check for HV directly
% modified CHL (27/01/10) to bring HELP notes in line with technical manual

function [] = HVFUNPAR(strName, value, strUnits);

global HV;  %allow access to global parameter structure
if isempty(HV)
    fprintf(1, '\t%s', 'GLOBAL PARAMETER STRUCTURE HV DOES NOT EXIST');
    return;
end


% display the message or the error. 
if HV.MESSAGES
    fprintf(1, '\t%s', strName);
    if nargin > 1
        fprintf(1, ' = %s', num2str(value));
    end
    if nargin > 2
        fprintf(1, ' %s', strUnits);
    end
  fprintf(1, '\n');
end

return;
