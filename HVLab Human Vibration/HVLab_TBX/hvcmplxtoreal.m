% hvcmplxtoreal - issue 1.0 (25/03/09) - HVLab HRV Toolbox
%--------------------------------------------------------
%[realdata, imagdata] = hvcmplxtoreal(indata)
% Splits a real-and-imaginary or modulus-and-phase parts of a data set into 
% two separate real data structures
%
% realdata	= name of HVLab data structure array containing real-part
%             or modulus of input data
% imagdata 	= name of HVLab data structure array containing imaginary-part
%             or phase of input data
% indata  	= name of HVLab data structure array containing complex
%             (dtype = 2) or modulus-and-phase input (dtype = 3) data
%

% written by Chris Lewis, March 2009

function [dasRealarr, dasImagarr] = hvcmplxtoreal(dasInarr);

error(HVFUNSTART('SPLIT COMPLEX DATA INTO COMPONENTS', dasInarr)); % show header and abort if input is not a valid structure

for k = 1:length(dasInarr)
    if ~HVISEMPTY(k, dasInarr(k)) % return results only for non-empty array elements
        error(HVISVALID(dasInarr(k), {'~real'})); % abort if input data is real
        [dasRealarr(k), dasImagarr(k)] = CMPLXTOREAL(dasInarr(k)); % seperate components
    end
end
return;

%========================================================
%seperate components of a single workspace data structure
function [realOut, imagOut] = CMPLXTOREAL(dasIn);

switch dasIn.dtype
	case 2    % real and imaginary data
		realOut = HVMAKESTRUCT(dasIn.title, dasIn.yunit, dasIn.xunit, 1, 0, dasIn.stats, dasIn.x);
		imagOut = HVMAKESTRUCT(dasIn.title, dasIn.yunit, dasIn.xunit, 1, 0, dasIn.stats, dasIn.x);
		realOut.y(:,1) = real(dasIn.y);
		imagOut.y(:,1) = imag(dasIn.y);
    case 3    % modulus and phase data
		realOut = HVMAKESTRUCT(dasIn.title, dasIn.yunit, dasIn.xunit, 1, 0, dasIn.stats, dasIn.x);
		imagOut = HVMAKESTRUCT(dasIn.title, dasIn.y2unit, dasIn.xunit, 1, 0, dasIn.stats, dasIn.x);
		realOut.y(:,1) = dasIn.y(:,1);
		imagOut.y(:,1) = dasIn.y(:,2);
    otherwise % dtype not supported
		error('Invalid data'); 
end

return;
