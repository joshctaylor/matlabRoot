%hvdiv - issue 2.1 (02/02/09) HVLab HRV Toolbox
%----------------------------------------------
%[quotient] = hvdiv (indata1, indata2, invert)
% Computes the quotient between two HVLab data structures and/or constants
%
% quotient 	=	name of new HVLab data structure containing the result(s)
%               of indata1 divided by indata2 
% indata1	= 	name of HVLab data structure containing the data set to be 
%               used as the numerator
% indata2	= 	name of HVLab data structure, or a real value, to be used 
%               as the divisor
% invert	= 	optional inversion flag: 
%               when true, quotient = indata2 / indata1
%
%Examples:
%---------
%[pqratio] = hvdiv (p, q) 
% returns an HVLab data structure, pqratio, containing the quotients of 
% corresponding data points in HVLab data structures p, and q, 
% i.e: pqratio.y(n) = p.y(n) / q.y(n). 
%
%[tenthdata] = hvdiv (mydata, 10) 
% divides each data point in all channels of the HVLab data structure 
% mydata by 10.0.
%
%Notes:
%------
% The input data structures must all contain the same number of data channels 

% function written CHL 5-9-2002
% modified CHL 02/02/2009 to bring HELP in line with technical manual


function [dasOutarr] = hvdiv(dasInarr, varInarr, flInv)

if nargin < 3; flInv = 0; end

if isstruct(varInarr)
    error(HVFUNSTART('DIVIDE TWO DATA STRUCTURES', dasInarr, varInarr)); % show header and abort if input is not a valid structure
elseif flInv
    error(HVFUNSTART('DIVIDE CONSTANT BY DATA STRUCTURE', dasInarr)); % show header and abort if input is not a valid structure
else
    error(HVFUNSTART('DIVIDE DATA STRUCTURE BY CONSTANT', dasInarr)); % show header and abort if input is not a valid structure
end

if flInv
    dasOutarr = HVARITH('-div', dasInarr, varInarr);
else
    dasOutarr = HVARITH('div', dasInarr, varInarr);
end

return
