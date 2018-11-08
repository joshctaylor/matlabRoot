% hvlist - issue 1.1 (20/03/2006) - HVLab HRV Toolbox
%-------------------------------------------------------------------------
% hvlist(Mydata) or hvlist();
%
% hvlist(Mydata) load the structure 'Mydata' and list its values into 
% a window called "Data Listing Window". 
% hvlist() without input arguments will open the "Data Listing Window" and 
% another window called "new data parameters" which will allow the user to 
% create a new set of data.
%
% When present, 'Mydata' is a structure which requires to have the 
% appropriate elements, as listed in 'hvcheckstruct' for the mode 2. 
% If 'Mydata' has a different structure type, the "Data Listing Window" will
% not be opened.
%
% The "Data Listing Window" will allow the user to:
% -List data present in the workspace with appropriate structure type
% -Display a list of data from the workspace which have an appropriate 
% structure type
% -List another data by directly choosing one given in the list displayed
% within the "Data Listing Window"
% -Directly Modify the data at anypoint and create new points
% -Create a new data by using another window called "New data parameters",
% where a number of parameters are then required.

% Written by Pierre HUGUENET, February 2006

% Modified and updated by PH on 20/03/2006 in order to have more
% flexibility when exporting data in excel format (choice of directory,
% overwritting of previous filenames) and to remove extra warning messages.
% Modified by PH on 12/07/2006 to import data from .das file and take into
% account multichannel data structures.
%-------------------------------------------------------------------------
function hvlist(var2list)

if nargin<1
   HVLISTWIN()
else
    varname=inputname(1);
    validstruct=hvcheckstruct(var2list,2);
        if validstruct==0 
            fprintf('\n                WARNING\n')
            fprintf('\n    Impossible to list variable called: %s \n',varname)
            fprintf('    Input data is not a valid data structure for HVLab\n')
            fprintf('    Type "help hvlist" or "help hvcheckstruct" for more details\n\n')
            close
        else
            HVLISTWIN(varname)
        end
end




