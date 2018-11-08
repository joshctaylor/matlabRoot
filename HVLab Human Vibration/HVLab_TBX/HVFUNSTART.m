%HVFUNSTART - issue 1.2 (27/01/10) - HVLab HRV Toolbox
%----------------------------------------------------- 
%[strError] = HVFUNSTART(description, struct1, struct2, ...structN)
% Display function name in command window and check that inputs are valid
% data structures
%
%   strError            = 	string containing description of any errors (if
%                           there are no errors a null string is returned)
%   description         = 	string containing function name
%   struct1 ... structN	= 	one or more HVLab data structures
%
%Example:
%--------
%error(HVFUNSTART(‘TRANSFER FUNCTION’, in1struct, in2struct))
%

% Written by Chris Lewis
% Modified TPG to suppress blank linefeed if strDescription is not provided and add tab spacing
%
function [strError] = HVFUNSTART(strDescription, varargin)

global HV;  %allow access to global parameter structure
strError = '';
if isempty(HV)
    strError = 'GLOBAL PARAMETER STRUCTURE HV DOES NOT EXIST';
    return;
end
if nargin > 1
    for k = 1:length(varargin)
        strError = checkstruct(varargin{k}, k, strError);
    end
end
if or(HV.MESSAGES, ~isempty(strError))
    if isempty(strDescription)==0
        if length(strDescription)>0
            fprintf(1, '\t%s\n', strDescription);
        end
    end
end
return;
% ============================================================
% check that input variable is a structure and abort otherwise
function [strOut] = checkstruct(dasIn, n, strIn)

if or(isempty(dasIn), ~isstruct(dasIn))
    fprintf(1, '\tinput %d is not a valid data structure array\n', n);
    strOut = 'INVALID INPUT DATA';
else
    strOut = strIn;
    
end
return;
