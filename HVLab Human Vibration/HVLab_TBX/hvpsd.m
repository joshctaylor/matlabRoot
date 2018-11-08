%hvpsd - issue 2.1 (29/01/07) - HVLab HRV Toolbox
%------------------------------------------------ 
%[psd] = hvpsd(timedata, increment)
% Computes the power spectral density of a time history in an HVLab data structure
%
% psd       = name of new data structure array containing the power 
%             spectral density function
% timedata	= name of HVLab data structure containing the input 
%             time-history data
% increment	= maximum frequency increment. If this argument is not present, 
%             the increment defaults to the global parameter HV.FINCREMENT
%Example:
%--------
%[Gx] = hvpsd(x) 
% returns a new data structure, Gx, containing real data (dtype = 1) 
% representing the power spectral densities of the input time histories in 
% HVLab data structure x as a function frequency. The frequency increment 
% of Gx is the nearest possible value <= HV.FINCREMENT (see notes below).
%
%[Gx] = hvpsd(x, 0.5) 
% The frequency increment of Gx is the nearest possible value <= 0.5 Hz.
%
%Notes:
%------
% The power  spectral density of an input data file is  calculated from the 
% relationship:   
%                                         X(f) X'(f) 
%                         G(f) = Lim    2 ----------      
%                                T->          T 
% 
% where X(f) is the Fourier Transform of input signal x(t),  with duration 
% T, and X'(f) is the complex conjugate of X(f).  Direct use of this equation 
% is statistically unreliable, as  the estimate has only two degrees of freedom. 
% The statistical accuracy is improved by ensemble averaging from overlapping 
% time slices of the signal.  The length of each time slice (n) is determined 
% by the sampling rate and the frequency increment  of the  PSD (which can be 
% set in the parameter table by the user) according to the relationship: 
% 
%                                     sample rate 
%                               n  =  -----------      
%                                      increment 
% 
% and is rounded down to the nearest power of 2.  n cannot be less than 16 or 
% greater than 4096.  The output data file contains (n/2)+1 points,  covering 
% the frequency range from 0 to (sample rate)/2. By default, the Hamming window  
% is used by the PSD routine.  This may be changed, if required, by using the 
% word WINDOW (see separate notes) before PSD. The number of degrees of freedom 
% is obtained from the relationship: 
% 
%                           degrees of freedom = 4N/n
% 
% where N is the number of samples in the input file. The units of the output 
% file are automatically adjusted from the units of the input file. Degrees of 
% freedom necessary for given accuracy and confidence levels: 
% 
% Accuracy of Power Spectral Estimate 
% -----------------------------------                                                
% CONFIDENCE LEVEL       5 dB          2 dB           1 dB          0.5 dB  
%        40%               -              3              11            42 
%        60%               2              5              28           105
%        80%               4             11              63           250
%        90%               5             18             104           410
%        96%               8             27             161           640
%        98%              10             34             207           820 

% written by Chris Lewis, October 2001
% Modified CHL August 2002 to include standard exception handling
% Modified CHL 3/9/2002 to use HVMAKESTRUCT to ensure correct field order
% Modified CHL 5/5/2005 to default resolution as in DOS HVLab
% Modified CHL 29/1/2007 to bring HELP in line with technical manual

function [dasPSD] = hvpsd(dasTH, fIncr)

error(HVFUNSTART('POWER SPECTRAL DENSITY', dasTH)); % show header and abort if input is not a valid structure
global HV; % allow access to global parameter structure
if nargin < 2, fIncr = HV.FINCREMENT; end % default increment to global setting

for k = 1:length(dasTH)
    if ~HVISEMPTY(k, dasTH(k)) % return results only for non-empty array elements
        error(HVISVALID(dasTH(k), {'real', '~hz', '~xvar'})); % abort if input data is not in correct form
        [dasPSD(k)] = DOPSD(dasTH(k), fIncr); % compute PSD
    end
end
return;

% ====================================
% compute psd of single data structure
function [dasOut] = DOPSD(dasIn, fIncr)

global HV; % allow access to global parameter structure

% Create output data structure
% ----------------------------
title = [];
xunit = [];
yunit = [];

if ~isempty(dasIn.title); title = ['PSD of ' dasIn.title]; end

if strcmpi(dasIn.xunit, 's')
   if ~isempty(dasIn.yunit); yunit = ['(', dasIn.yunit, ')²/Hz']; end;
   xunit = 'Hz';
else
   if ~isempty(dasIn.yunit); yunit = ['(', dasIn.yunit, ')²', dasIn.xunit]; end;
   if ~isempty(dasIn.xunit); xunit = ['1/', dasIn.xunit]; end;
end

dasOut = HVMAKESTRUCT(title, yunit, xunit, 1, 0, dasIn.stats);

% compute and display parameters
% ------------------------------
dlen = length(dasIn.y);
xincr = dasIn.x(2) - dasIn.x(1);
srate = 1 / xincr;

if fIncr == 0
   n = 11;			% where fft length (fftlen) = 2**n
else   
   n = fix(log2(srate / fIncr));
   n = min(n,11);   % i.e. maximum length = 2048
   n = max(n,4);    % i.e. minimum length = 16   
end
fftlen = 2^n; % fft length
outincr = srate / fftlen; % frequency increment of psd
nfft = 2 * ceil(dlen / fftlen); % no. of ffts to be evaluated
skip = fix(dlen / nfft); % samples skipped after start of previous fft window
noverlap = fftlen - skip; % fft overlap
dof = fix(nfft .* 2);
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

% Compute PSD
% -----------
winhandle = str2func(strWin); % get handle to window function
window = feval(winhandle, fftlen); % generate spectral window
dasOut.y = psd(dasIn.y, fftlen, srate, window, noverlap); % run PSD
outlen = size(dasOut.y, 1); % return no. of data points in the PSD
outlimit = (outlen - 1) * outincr; % highest frequency
dasOut.x = (0: outincr: outlimit)'; % generate x-axis frequency scale
dasOut.y = dasOut.y ./ outlimit; % scale output to units**2/Hz
dasOut.stats(4) = dof;

return;
