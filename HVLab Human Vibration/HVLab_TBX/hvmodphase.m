%hvmodphase - issue 2.0 (23/02/10) - HVLab HRV Toolbox
%-----------------------------------------------------
%[outdata] = hvmodphase(indata, mode, prange)
%  Returns modulus and phase of complex data in an HVLab data structure
%      outdata = name of new HVLab data structure
%      indata  = name of HVLab data structure array containing complex 
%                (i.e. real and imaginary) data
%      mode    = type of output: 1 (default) returns the modulus and phase,
%                2 returns the modulus only, 3 returns the phase only
%      prange  = range of phase values: 0 (default) returns phase values
%                constrained to +/-pi, 1 returns unconstrained phase values 

% written by Chris Lewis, October 2001
% Modified CHL, 03-09-2002 to use HVMAKESTRUCT to ensure correct field order
% Modified CHL, 19-02-2010 to return correct y-units of 'rad' in mode 3
% Modified CHL, 23-02-2010 to provide option of unwrapping phase values
%
function [dasOutarr] = hvmodphase(dasInarr, iMode, uFlag);

error(HVFUNSTART('MODULUS AND PHASE OF COMPLEX DATA', dasInarr)); % show header and abort if input is not a valid structure
if nargin < 2, iMode = 1; end % return modulus and phase by default
if nargin < 3, uFlag = 0; end % constrain phase to +/-pi by default

for k = 1:length(dasInarr)
    if ~HVISEMPTY(k, dasInarr(k)) % return results only for non-empty array elements
        error(HVISVALID(dasInarr(k), {'cmplx'})); % abort if input data is not complex
        [dasOutarr(k)] = MODPHASE(dasInarr(k), iMode, uFlag); % compute modulus and/or phase
    end
end
return;

%========================================================
%Compute modulus/phase of single workspace data structure
function [dasOut] = MODPHASE(dasIn, m, flg);

global HV; %allow access to global parameter structure
HVFUNPAR('number of samples', length(dasIn.y));

title = [];
switch m
	case 1  % mode 1 = return modulus and phase
		if ~isempty(dasIn.title); title = ['Modulus & phase of ' dasIn.title]; end;
		dasOut = HVMAKESTRUCT(title, dasIn.yunit, dasIn.xunit, 3, 0, dasIn.stats, dasIn.x);
        dasOut.y2unit = 'rad';
		dasOut.y(:,1) = abs(dasIn.y);
        if flg ~= 0
            dasOut.y(:,2) = unwrap(angle(dasIn.y));
        else
            dasOut.y(:,2) = angle(dasIn.y);
        end
   case 2   % mode 2 = return modulus only
		if ~isempty(dasIn.title); title	= ['Modulus of ' dasIn.title]; end;
		dasOut = HVMAKESTRUCT(title, dasIn.yunit, dasIn.xunit, 1, 0, dasIn.stats, dasIn.x);
		dasOut.y = abs(dasIn.y);
  case 3    % mode 3 = return phase only
		if ~isempty(dasIn.title); title	= ['Phase of ' dasIn.title]; end;
		dasOut = HVMAKESTRUCT(title, 'rad', dasIn.xunit, 1, 0, dasIn.stats, dasIn.x);
        dasOut.yunit = 'rad';
        if flg ~= 0
            dasOut.y = unwrap(angle(dasIn.y));
        else
            dasOut.y = angle(dasIn.y);
        end
end

return;
