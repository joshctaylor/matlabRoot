%hvpower - issue 1.0 (18/01/07) HVLab HRV Toolbox
%----------------------------------------------
% function [outdata] = hvpower(indata1, indata2, abs)
% Returns the exponentiation of a data structure with a constant value or
% another data structure.
%   outdata =	HVLab data structure array containing the results of (indata^indata2)
%   indata1	= 	HVLab data structure array containing the first data set
%   indata2 = 	exponent (real value or second HVLab data structure) 
%   abs     = 	optional absolute value flag (when abs <> 0, result = abs[indata]^indata2)

% function written CHL 18/01/07

function [dasOutarr] = hvpower(dasInarr, varInarr, flAbs)

if nargin < 3; flAbs = 0; end

if isstruct(varInarr)
    error(HVFUNSTART('EXPONENTIATION OF TWO DATA STRUCTURES', dasInarr, varInarr)); % show header and abort if input is not a valid structure
else
    error(HVFUNSTART('EXPONENTIATION OF DATA STRUCTURE AND CONSTANT', dasInarr)); % show header and abort if input is not a valid structure
end

dasInarr1 = dasInarr;
if flAbs
    dasInarr1.y = abs(dasInarr.y);
end

dasOutarr = HVARITH('exp', dasInarr1, varInarr);

return
