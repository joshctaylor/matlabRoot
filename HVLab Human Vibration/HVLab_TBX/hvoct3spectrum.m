%hvoct3spectrum - issue 1.1 (30/07/10) - HVLab HRV Toolbox
%--------------------------------------------------------------------------
%[spectrum]	= hvoct3spectrum(timedata, fmin, fmax, fscale)
% Computes spectrum of signal magnitudes in one-third octave bands from
% time history data
%
% spectrum	 = HVLab data structure containing 3rd-octave spectra
% timedata	 = HVLab data structure containing time-history data
% fmin       = lowest frequency point in output spectrum (defaults to 
%              HV.FINCREMENT)
% fmax       = highest frequency point in output spectrum (defaults to     
%              1/2*HV.FINCREMENT)
% yscale     = optional string specifying the output scaling (defaults to
%              'rms'):
%              'rms' == units / root hz
%              'normalised'
% fscale     = optional string specifying frequency scale (defaults to 
%              'exact'): 
%              'exact' = exact 1/3  octave centre frequencies
%              'preferred' = preferred 1/3 octave centre frequencies
% mode       = optional string specifying averaging method (defaults to 
%              'rms'): 
%              'rms' = root mean square average
%              'rms/rhz' = normalised root mean square average
%              'peak' = maximum of +ve and -ve peak amplitudes
%
%Allowed combinations of data types:
%-----------------------------------
% The input data must be a real (dtype = 1) time-history
%-------------------------------------------------------------------------
%WARNING this function has not yet been formally tested and should be used 
%with caution
%-------------------------------------------------------------------------

% Untested message added by Chris Lewis, July 2010


function [dasOutarr] = hvoct3spectrum(dasInarr, fmin, fmax, fscale, mode)

global HV; % allow access to global parameter structure

error(HVFUNSTART('LOG SPECTRUM', dasInarr)); % show header and abort if input is not a valid structure
fprintf(1, '*************************************************************************\n');
fprintf(1, 'WARNING this function has not yet been formally tested and should be used\n');
fprintf(1, 'with caution\n');
fprintf(1, '*************************************************************************\n');

if nargin < 4; fscale = 'exact'; end
if nargin < 5; mode = 'rms'; end

for k = 1:length(dasInarr)
    if ~HVISEMPTY(k, dasInarr(k)) % return results only for non-empty array elements
        error(HVISVALID(dasInarr(k), {'real', '~hz', '~xvar'})); % abort if input data is not a real TH
        if nargin < 2; fmin = 1/(500 * (dasInarr(k).x(2)-dasInarr(k).x(1))); end
        if nargin < 3; fmax = 1/(5 * (dasInarr(k).x(2)-dasInarr(k).x(1))); end        
        [dasOutarr(k)] = OCT3SPECTRUM(dasInarr(k), fmin, fmax, fscale, mode); % apply weighting
    end
end
return

function [dasOut] = OCT3SPECTRUM(dasIn, fmin, fmax, fscale, mode)

xvar = 1; %variable increment
srate = 1/(dasIn.x(2)-dasIn.x(1));

fmin = max(fmin, 0.015*(srate/2)); %limit to achievable frequency range
fmax = min(fmax, 0.88*(srate/2)); 

dasOut = HVMAKESTRUCT('Log Spectrum', [], 'Hz', 1, xvar);  

switch fscale
    case 'exact'
    	[dasOut.x(:,1), nx] = OCT3SCALE(fmin, fmax);
    	HVFUNPAR('frequency scale = exact third octaves');
    case 'preferred'
     	[dasOut.x(:,1), nx] = NOMOCT3SCALE(fmin, fmax);
    	HVFUNPAR('frequency scale = nominal third octaves');
    otherwise
        error('frequency scale not recognised')
end

global yfilt

for k = 1:nx
	[B, A] = OCT3DSGN(dasOut.x(k), srate, 3);
	yfilt = filter(B, A, dasIn.y);
    switch mode
        case 'rms'
            dasOut.y(k,1) = sqrt(mean(yfilt.^2));
            dasOut.yunit = dasIn.yunit;
        case 'rms/rhz'
            dasOut.y(k,1) = sqrt(mean(yfilt.^2)./(0.23077 .* dasOut.x(k)'));
            dasOut.yunit = [dasIn.yunit '/Hz^0.5'];
        case 'peak'
            dasOut.y(k,1) = max(max(yfilt), -min(yfilt));
            dasOut.yunit = dasIn.yunit;
        otherwise
            error('frequency scale not recognised')
    end
end

HVFUNPAR(['averaging method = ' mode]);
HVFUNPAR('data sampling rate', srate, 'Hz');      
HVFUNPAR('minimum centre frequency', dasOut.x(1), 'Hz');
HVFUNPAR('maximum centre frequency', dasOut.x(nx), 'Hz');
return

%=========================================
%generate exact 1/3-octave frequency scale
function [f, n] = OCT3SCALE(fmin, flimit)

omin = round(10.0 .* log10(fmin));
omax = round(10.5 .* log10(flimit));
n = omax - omin;			% n is the no. of frequency points							
for k = 1:n
   no = omin + k - 1;		% no is the octave number (1 Hz is '0')
   f(k) = 10.^(no./10);  
end
return

%===========================================
%generate nominal 1/3 octave frequency scale
function [f, n] = NOMOCT3SCALE(fmin, flimit)

fnom = [0.01    0.0125  0.016   0.02    0.025   0.0315  0.04    0.05    0.063   0.08    ... %fnom(1)  to fnom(10)
   		0.1     0.125   0.16    0.2	    0.25    0.315   0.4     0.5     0.63    0.8	    ...	%fnom(11) to fnom(20)
   		1       1.25    1.6		2 		2.5		3.15    4 		5 		6.3     8		...	%fnom(21) to fnom(30)
   		10      12.5    16      20      25      31.5    40      50      63 		80		...	%fnom(31) to fnom(40)
   		100     125		160		200 	250		315     400 	500 	630     800	    ...	%fnom(41) to fnom(50)
   		1000    1250    1600    2000	2500    3150    4000	5000	6300    8000	...	%fnom(51) to fnom(60)
   		10000   12500	16000   20000   25000   31500   40000   50000];		                %fnom(61) to fnom(67)
  
omin = round(10 * log10(fmin));
omax = round(10.5 * log10(flimit));
n = omax - omin;			% n is the no. of frequency points							
for k = 1:n
   no = omin + k - 1;		% no is the octave number (1 Hz is '0')
   f(k) = fnom(no + 21);  
end
f = f';
return

%============================================
%OCT3DSGN Design of a one-third-octave filter
function [B, A] = OCT3DSGN(Fc, Fs, N); 
%    designs a digital 1/3-octave filter with 
%    center frequency Fc for sampling frequency Fs. 
%    The filter is designed according to the Order-N specification 
%    of the ANSI S1.1-1986 standard. Default value for N is 3. 
%    Warning: for meaningful design results, center frequency used
%    should preferably be in range Fs/200 < Fc < Fs/5.
%    Usage of the filter: Y = FILTER(B,A,X). 
% Author: Christophe Couvreur, Faculte Polytechnique de Mons (Belgium)
%         couvreur@thor.fpms.ac.be
% Last modification: Aug. 25, 1997, 2:00pm.

if (nargin > 3) | (nargin < 2)
  error('Invalid number of arguments.');
end
if (nargin == 2)
  N = 3; 
end
if (Fc > 0.88*(Fs/2))
  error('filter design not possible - centre frequency too high');
end
if (Fc < 0.015*(Fs/2))
  error('filter design not possible - centre frequency too low');
end
  
% Design Butterworth 2Nth-order one-third-octave filter 
% Note: BUTTER is based on a bilinear transformation, as suggested in [1]. 
pi = 3.14159265358979;
f1 = Fc/(2^(1/6)); 
f2 = Fc*(2^(1/6)); 
Qr = Fc/(f2-f1); 
Qd = (pi/2/N)/(sin(pi/2/N))*Qr;
alpha = (1 + sqrt(1+4*Qd^2))/2/Qd; 
W1 = Fc/(Fs/2)/alpha; 
W2 = Fc/(Fs/2)*alpha;
[B, A] = butter(N,[W1,W2]); 
return

