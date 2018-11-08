%hvprod - issue 2.0 (16/01/06) - HVLab HRV toolbox
%-------------------------------------------------
% function [outdata] = hvprod(indata1, indata2)
% Return the product of two data structures, or of a data structure and constant values
%   outdata =	new workspace data structure array containing the results
%               of (indata1*indata2)
%   indata1	= 	input workspace data structure array containing the first data set
%   indata2 = 	input workspace data structure array, numeric value 
%               or a matrix of values having the same length as indata1
% 
% HVLab_DOS equivalent: FILE*FILE; e.g.: Multiply file 1 by file 2 and store results in 
% file 3: 1 2 3 FILE*FILE, (where 1 = indata1, 2 = indata2 and 3 = outdata, correspond 
% to the equivalent Matlab data structures).

% function written by CHL 5-9-2002

function [dasOutarr] = hvprod(dasInarr, varInarr)

if isstruct(varInarr)
    error(HVFUNSTART('MULTIPLY TWO DATA STRUCTURES', dasInarr, varInarr)); % show header and abort if input is not a valid structure
else
    error(HVFUNSTART('MULTIPLY DATA STRUCTURE BY CONSTANT', dasInarr)); % show header and abort if input is not a valid structure
end
dasOutarr = HVARITH('prod', dasInarr, varInarr);
return
