%HVARITH - issue 3.0 (16/01/06) - HVLab HRV Toolbox
%--------------------------------------------------
% [outdata] = HVARITH(mode, indata1, indata2)
% Perform arithmetic operations on workspace data structure arrays
%   outdata =	new workspace data structure array containing the results of the arithmetic operation
%   mode    =   string defining type of operation ('sum', 'sub', '-sub', 'prod', 'div', '-div', 'exp')
%   indata1	= 	input workspace data structure array containing the first data set
%   indata2 = 	input workspace data structure array, single real value 
%               or a matrix of real values having the same length as indata1

% function written CHL 5-9-2002
% modified by Cedric Gallais January 2006
% modified by Chris Lewis 18-01-07 to add an exponentiation operation ('exp')

function [dasOutarr] = HVARITH(strMethod, dasInarr, varInarr)

%error(HVFUNSTART('DATA STRUCTURE ARITHMETIC', dasInarr)); % show header and abort if input is not a valid structure

for k = 1:length(dasInarr)
    if isstruct(varInarr)
        if ~HVISEMPTY(k, dasInarr(k), varInarr(k)) % return results only for non-empty channels
            error(HVISVALID(dasInarr(k))); 
            error(HVISVALID(varInarr(k), {'~moph', 'yunit', 'xaxis', 'length'}, varInarr(k))); 
            [dasOutarr(k)] = ARITH(strMethod, dasInarr(k), varInarr(k)); 
        end
    else
        if ~HVISEMPTY(k, dasInarr(k)) % return results only for non-empty channels
            error(HVISVALID(dasInarr(k)));
            if and(abs(sum(imag(varInarr))) > 0, dasInarr(k).dtype == 3); error('Combination of complex and angular data not allowed'); end
            switch length(varInarr)
            case 1
                [dasOutarr(k)] = ARITH(strMethod, dasInarr(k), varInarr); 
            case length(dasInarr)
                [dasOutarr(k)] = ARITH(strMethod, dasInarr(k), varInarr(k));
            otherwise 
                error('Unexpected number of elements in input array'); 
            end    
        end 
    end
end
return
% =======================================================
% perform arithmetic on a single workspace data structure
function [dasOut] = ARITH(strMethod, dasIn, varIn)

if dasIn.dtype == 3
    in1 = dasIn.y(:,1);
else
    in1 = dasIn.y;
end    
if isstruct(varIn)
    in2 = varIn.y;
else
    in2 = varIn; % varIn should be a single value or 1 dimension array
end    

switch strMethod
case 'sum'
    op = in1 + in2;
case 'sub'
    op = in1 - in2;
case '-sub'
    op = in2 - in1;
case 'prod'
    op = in1 .* in2;
case 'div'
    op = in1 ./ in2;
case '-div'
    op = in2 ./ in1;
case 'exp'
    op = in1 .^ in2;
otherwise
    error('Arithmetic method not recognised');
end    

dasOut = HVMAKESTRUCT(dasIn.title, dasIn.yunit, dasIn.xunit, dasIn.dtype, 0, dasIn.stats, dasIn.x);
HVFUNPAR('number of samples', length(dasIn.y));
if dasIn.dtype == 3
    dasOut.y = [op, dasIn.y(:,2);]
else
    dasOut.y = op;
end    
if abs(sum(imag(op))) > 0, dasOut.dtype = 2; end % adjust dtype if varIn is cmplx
return