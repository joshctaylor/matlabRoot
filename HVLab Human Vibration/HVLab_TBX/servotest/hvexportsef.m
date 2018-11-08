%hvexportsef - issue 1.4 (11/08/10) - HVLab HRV Toolbox
%------------------------------------------------------
%[] = hvexportsef(filename, mydata, scale, comments)
%Exports data from a single or multi-channel time history in an HVLab data 
% structure to a SERVOTEST EXTENSIBLE FILE FORMAT data file. Calls function 
% WriteFile.p supplied by SERVOTEST.
%
% filename = string containing pathname for the new data file (the 
%            extension will be forced to .sef)
% filetype = string describing format of data to be exported (see below
%            for available values)
% mydata   = name of HVLab data structure containing the data to be 
%            exported. This will normally have either one or six channels.
% scale    = optional values to be written into the "scale" field for 
%            each channel (either a single value or row matrix) - defaults
%            to 100
% comments = optional string to be written into the "comments" field of the
%            .sef file - defaults to 'Exported from HVLab HRV toolbox'
%

% written by Chris Lewis (03/02/10)
% help notes improved by Chris Lewis (16/03/10)
% modified by Chris Lewis (16/03/10) to accept titles and units with
%          different lengths
% modified by Chris Lewis (13/04/10) to allow scales as a single value or
%          row matrix
% modified by Chris Lewis (15/04/10) to prevent error caused by names,  
%          units or comments being nullstrings, which are not accepted by
%          WriteFile.p 
% modified by Chris Lewis (11/08/10) to provide default values for 'scale' 
%          and 'comments'

function [] = hvexportsef(strFile, dasOut, scale, comments)

error(HVFUNSTART('EXPORT TO SERVOTEST DATA FILE', dasOut)); % show header and abort if input is not a valid structure

strFilename = HVFILEXT(strFile, '.sef');
HVFUNPAR('Output file name', strFilename);
if nargin < 3, scale = 100; end
if nargin < 4, comments = 'Exported from HVLab HRV toolbox'; end
if isempty(comments), comments = 'Exported from HVLab HRV toolbox'; end

nchnls = length(dasOut);
increment = dasOut(1).x(2) - dasOut(1).x(1);
srate = 1 / increment;

names = [];
units = [];
ydata = [];
for k = 1:nchnls
    error(HVISVALID(dasOut(k), {'real', '~hz', '~xvar'})); % abort if input data is not in correct form
    ydata(:,k) = dasOut(k).y;
    if isempty(dasOut(k).title), dasOut(k).title = ['chnl ' int2str(k)]; end
    names = strvcat(names, dasOut(k).title);
    if isempty(dasOut(k).yunit), dasOut(k).yunit = 'm/s^2'; end
    units = strvcat(units, dasOut(k).yunit);
    if length(scale) ~= nchnls
        scales(k) = scale(1)';
    else
        scales(k) = scale(k)';
    end
end
HVFUNPAR('Number of channels in data structure', nchnls);
HVFUNPAR('Number of data samples', length(dasOut(1).y));
HVFUNPAR('Sampling rate', srate, 's/s');

% Write the sef file
WriteFile(strFilename, srate, names, scales, units, ydata, comments);

return
    