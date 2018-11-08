%HVFUNPAR
% [] = HVFUNPAR(strDescription, value, strUnits)
% If HV.MESSAGES is set, displays information in the format:
%   strDescription = value strUnits
% value and strUnits are optional, so HVFUNPAR may be used to display messages to the screen by setting strDescription only. 
% Written by CHL. 

% Modified TPG 22-8-2002 to check for the existence of the MESSAGES field
% of the HV global and set this to 1 if it does not exist. 
% Modified TPG 23-12-2003 to remove the 22-8-2002 modification and to check for HV directly

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
