% hvrealtocmplx - issue 1.1 (23/08/09) - HVLab HRV Toolbox
%--------------------------------------------------------
%[cmplxdata] = hvrealtocmplx(indata1, indata2, mode)
% Combines data from two data structures into real-and-imaginary or 
% modulus-and-phase parts of a new complex data structure
%
% cmplxdata	= name of new HVLab real-and-imagninary or modulus-and-phase 
%             data structure
% indata1	= name of real HVLab data structure array containing real-part
%             or modulus of output data
% indata2	= name of real HVLab data structure array containing imaginary
%             part or phase of output data
% mode  	= mode of output data (defaults to 'moph'):
%             'reim' generates real and imaginary data (dtype = 2)
%             'moph' generates modulus-and-phase data (dtype = 3)
%
%Restrictions:
%-------------
% The input data structures must both contain real data, and must have the 
% same number of samples and sampling increment 
%

% written by Chris Lewis, March 2009
% modified by Chris Lewis, August 2009 to fix problems in initial testing

function [dasOutarr] = hvrealtocmplx(dasRealarr, dasImagarr, strMode)

error(HVFUNSTART('COMBINE COMPONENTS INTO A COMPLEX DATA STRUCTURE', dasRealarr)); % show header and abort if input is not a valid structure
global HV; % allow access to global parameter structure
if nargin < 3, strMode = 'moph'; end % default increment to global setting

for k = 1:min(length(dasRealarr), length(dasImagarr))
    if ~HVISEMPTY(k, dasRealarr(k), dasImagarr(k)) % return results only for non-empty channels
        error(HVISVALID(dasRealarr(k), {'real'})); % abort if input data is not real
        error(HVISVALID(dasImagarr(k), {'real'})); % abort if input data is not real
        [dasOutarr(k)] = REALTOCMPLX(dasRealarr(k), dasImagarr(k), strMode); % combine components
    end
end
return;

%=========================================================
%combine components into a single workspace data structure
function [cmplxOut] = REALTOCMPLX(realIn, imagIn, mode)

if (length(realIn.y)) ~= (length(imagIn.y))
    error('Input data sets must have the same no. of samples'); 
end

switch mode
	case 'reim' % real and imaginary data
		cmplxOut = HVMAKESTRUCT(realIn.title, realIn.yunit, realIn.xunit, 2, 0, realIn.stats, realIn.x);
		cmplxOut.y(:,1) = realIn.y + (i*imagIn.y);
    case 'moph' % modulus and phase data
		cmplxOut = HVMAKESTRUCT(realIn.title, realIn.yunit, realIn.xunit, 3, 0, realIn.stats, realIn.x);
        cmplxOut.y2unit = imagIn.yunit;
		cmplxOut.y(:,1) = realIn.y;
		cmplxOut.y(:,2) = imagIn.y;
    otherwise % dtype not supported
		error('unrecognised mode'); 
end
return;
