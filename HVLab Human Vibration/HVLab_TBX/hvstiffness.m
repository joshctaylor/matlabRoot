%hvstiffness - issue 1.1 (30/07/10) HVLab HRV Toolbox
%----------------------------------------------------
%[dynamic_stiffness, stiffness, damping] = hvstiffness (acceleration, force, increment, fmax)
% Computes dynamic stiffness from acceleration and force measured in an
% indenter test
%
% dynamic_stiffness	=	name of new HVLab data structure containing the
%                       complex dynamic stiffness of the test piece as a 
%                       function of excitation frequency
% coherency         =	name of new HVLab data structure containing the
%                       stiffness (force/displacement) as a function of 
%                       excitation frequency
% damping           =	name of new HVLab data structure containing the
%                       damping (force/velocity) as a function of 
%                       excitation frequency
% acceleration      = 	name of HVLab data structure containing the 
%                       acceleration time history applied to the test piece 
% force             = 	name of HVLab data structure containing the 
%                       indenter force time history 
% fmax              =   upper frequency limit for output data. If this 
%                       argument is not present, fmax defaults to 
%                       half the sampling rate of the input data
% fincr             =   maximum frequency increment. If this argument is 
%                       not present, fincr defaults to the global 
%                       parameter HV.FINCREMENT
%-------------------------------------------------------------------------
%WARNING this function has not yet been formally tested and should be used 
%with caution
%-------------------------------------------------------------------------

% Written by Chris Lewis, August 2009
% Untested message added by Chris Lewis, July 2010

function [dasCDS, dasSTIF, dasDAMP] = hvtransfer(dasAccel, dasForce, fMax, fIncr)

error(HVFUNSTART('DYNAMIC STIFFNESS CALCULATION', dasAccel, dasForce)); % show header and abort if input is not a valid structure
global HV; % allow access to global parameter structure
if nargin < 3, fMax = 0; end % default increment to global setting
if nargin < 4, fIncr = HV.FINCREMENT; end % default increment to global setting
fprintf(1, '*************************************************************************\n');
fprintf(1, 'WARNING this function has not yet been formally tested and should be used\n');
fprintf(1, 'with caution\n');
fprintf(1, '*************************************************************************\n');

for k = 1:length(dasAccel)
    if ~HVISEMPTY(k, dasAccel(k), dasForce(k)) % return results only for non-empty channels
        error(HVISVALID(dasAccel(k), {'real', '~hz', '~xvar'})); % abort if input data is not in correct form
        error(HVISVALID(dasForce(k), {'real', '~hz', '~xvar', 'xaxis', 'length'}, dasAccel(k))); 
	    if nargout == 1
            [dasCDS(k)] = STIFFNESS(dasAccel(k), dasForce(k), fIncr, fMax); % compute transfer function
        elseif  nargout == 2
            [dasCDS(k), dasSTIF(k)] = STIFFNESS(dasAccel(k), dasForce(k), fIncr, fMax); % compute transfer function and coherency
        elseif  nargout == 3
            [dasCDS(k), dasSTIF(k), dasDAMP(k)] = STIFFNESS(dasAccel(k), dasForce(k), fIncr, fMax); % compute transfer function and coherency
        end
    end
end
return;
   
% =========================================================================
% compute psd of single workspace data structure
function [dasOut, dasK, dasC] = STIFFNESS(dasIn1, dasIn2, fIncr, fMax)

global HV; % allow access to global parameter structure

% Create output data structures
% -----------------------------
dasOut = HVMAKESTRUCT('Dynamic stiffness', 'N/m', 'Hz', 2, 0, dasIn2.stats); % dynamic stiffness is complex

% compute and display parameters
% ------------------------------
dlen = length(dasIn1.y);
xincr = dasIn1.x(2) - dasIn1.x(1);
srate = 1 / xincr;
if fIncr == 0
   n = 11; % where fft length (fftlen) = 2**n
else   
   n = fix(log2(srate / fIncr));
   n = min(n,11); % i.e. maximum length = 2048
   n = max(n,4); % i.e. minimum length = 16   
end
fftlen = 2^n; % fft length
outincr = srate / fftlen; % frequency increment of psd
nfft = 2 * ceil(dlen / fftlen); % no. of ffts to be evaluated
skip = fix(dlen / nfft); % samples skipped after start of previous fft window
noverlap = fftlen - skip; % fft overlap
dof = fix(nfft .* 2) ;
dasOut.stats(4) = dof;
strWin = 'hamming'; % default window
if or(strcmpi(HV.WINDOW, 'HANNING'), strcmpi(HV.WINDOW, 'HANN')); strWin = 'hann'; end
if or(strcmpi(HV.WINDOW, 'RECTANGULAR'), strcmpi(HV.WINDOW, 'BOXCAR')); strWin = 'boxcar'; end
if or(strcmpi(HV.WINDOW, 'TRIANGULAR'), strcmpi(HV.WINDOW, 'TRIANG')); strWin = 'triang'; end
if strcmpi(HV.WINDOW, 'BARTLETT'); strWin = 'bartlett'; end

HVFUNPAR('number of input samples', dlen);
HVFUNPAR('sampling rate', srate, 'Hz');
HVFUNPAR('fft length', fftlen);
HVFUNPAR('specified resolution', fIncr, 'Hz');
HVFUNPAR('actual resolution', outincr, 'Hz');
HVFUNPAR('degrees of freedom', dof);
HVFUNPAR(['spectral window = ', strWin]);

% Compute Force/Acceleration Transfer Function
% --------------------------------------------
winhandle = str2func(strWin); % get handle to window function
window = feval(winhandle, fftlen); % generate spectral window
yfa = tfe(dasIn1.y, dasIn2.y, fftlen, srate, window, noverlap);
outlen  = size(yfa, 1); % no. of samples in output
if fMax > 0
    outlen = min(outlen, fix(fMax/outincr));
    yfa = yfa(1:outlen);
end;
outlimit = (outlen - 1) * outincr; % generate x-axis frequency scale
dasOut.x = (0: outincr: outlimit)';
dasOut.stats(4) = dof;

s = dasOut.x .*2 .*pi .*j;
yfv = yfa .* s;         % force/velocity transfer function
dasOut.y = yfv .*s;   % force/displacement transfer function

if nargout > 1
    dasK = HVMAKESTRUCT('Stiffness', 'N/m', 'Hz', 1, 0, dasIn2.stats); 
    dasK.y = abs(real(dasOut.y));
	dasK.x = dasOut.x;
end
if nargout > 2
    dasC = HVMAKESTRUCT('Damping', 'Ns/m', 'Hz', 1, 0, dasIn2.stats);
    dasC.y = abs(real(yfv));
	dasC.x = dasOut.x;
end

return;
