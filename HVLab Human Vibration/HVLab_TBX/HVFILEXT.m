%HVFILEXT - issue 1.2 (27/01/10) - HVLab HRV Toolbox
%--------------------------------------------------- 
%[strFile] = HVFILEXT(strName, strExt)
% Add extension to file name (any existing extension is first removed)
%
%   strFile	= filename with extension (in form ‘.ext’)
%   strName	= string containing filename
%   strExt  = string containing file extension
%
%Example:
%--------
%Parameter_filename = HVFILEXT(filename, '.pas')
%

% Written by Chris Lewis August 2002
% Modified CHL February 2006 to fix problem if extension exists
% modified by Chris Lewis (27/01/10) to bring HELP notes in line with
% technical manual


function [strFile] = HVFILEXT(strName, strExt)

sep = findstr(strName, '.');

if ~isempty(sep)
    strNoext = strName(1:min(sep-1));
    if isempty(findstr(strName, strExt))
        HVFUNPAR(['WARNING: files must have the extension ', strExt]);
    end
else
    strNoext = strName;
end
if isempty(findstr(strExt, '.'))
    strExt = strcat('.', strExt);
end
strFile = strcat(strNoext, strExt);
return;