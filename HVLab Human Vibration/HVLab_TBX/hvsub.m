%hvsub - issue 2.0 (16/01/06) - HVLab HRV toolbox
%------------------------------------------------
% function [outdata] = hvsub(indata1, indata2, invert)
% Return the difference between two data structures, or of a data structure and constant values
%   outdata =	new workspace data structure array containing the results of (indata1 - indata2)
%   indata1	= 	input workspace data structure array containing the first data set
%   indata2 = 	input workspace data structure array, numeric value 
%               or a matrix of values having the same length as indata1
%   invert	= 	optional inversion flag (when invert = 1, difference = indata2 - indata1)
%
% HVLab equivalent: FILE-FILE; e.g.: Subtract file 2 from file 1 and store results 
% in file 3: 1 2 3 FILE-FILE, (where 1 = indata1, 2 = indata2 and 3 = outdata, 
% correspond to the equivalent Matlab data structures).  

% function written CHL 5-9-2002
function [dasOutarr] = hvsub(dasInarr, varInarr, flInv)

if nargin < 3; flInv = 0; end

if isstruct(varInarr)
    error(HVFUNSTART('SUBTRACT TWO DATA STRUCTURES', dasInarr, varInarr)); % show header and abort if input is not a valid structure
elseif flInv
    error(HVFUNSTART('SUBTRACT DATA STRUCTURE FROM CONSTANT', dasInarr)); % show header and abort if input is not a valid structure
else
    error(HVFUNSTART('SUBTRACT CONSTANT FROM DATA STRUCTURE', dasInarr)); % show header and abort if input is not a valid structure
end

if flInv
    dasOutarr = HVARITH('-sub', dasInarr, varInarr);
else
    dasOutarr = HVARITH('sub', dasInarr, varInarr);
end

return
