%hvsum - issue 2.0 (24/05/06) HVLab HRV Toolbox
%----------------------------------------------
% function [outdata] = hvsum(indata1, indata2)
% Return the sum of two data structures, or of a data structure and constant values
%   outdata =	new workspace data structure array containing the results
%               of (indata1+indata2)
%   indata1	= 	input workspace data structure array containing the first data set
%   indata2 = 	input workspace data structure array, numeric value 
%               or a matrix of values having the same length as indata1
%
% HVLab equivalent: FILE+FILE; e.g.: Add file 1 to file 2 and store results 
% in file 3: 1 2 3 FILE+FILE, (where 1 = indata1, 2 = indata2 and 3 = outdata, 
% correspond to the equivalent Matlab data structures).  

% function written CHL 5-9-2002
function [dasOutarr] = hvsum(dasInarr, varInarr)

if isstruct(varInarr)
    error(HVFUNSTART('ADD TWO DATA STRUCTURES', dasInarr, varInarr)); % show header and abort if input is not a valid structure
else
    error(HVFUNSTART('ADD CONSTANT TO DATA STRUCTURE', dasInarr)); % show header and abort if input is not a valid structure
end
dasOutarr = HVARITH('sum', dasInarr, varInarr);
return
