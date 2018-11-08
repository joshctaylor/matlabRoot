%hvcsd - issue 2.1 (30/01/07) HVLab HRV Toolbox
%----------------------------------------------
%[csd] = hvcsd (timedata1, timedata2, resolution)
% Computes the cross spectral density of time histories in two HVLab data structures
%
% csd       = name of HVLab data structure containing the cross spectral density function
% timedata1	= name of HVLab data structure containing the first input time history 
% timedata2	= name of HVLab data structure containing the second input time history 
% increment = desired frequency increment
%
%Example:
%--------
%[Gxy] = hvcsd (x, y) 
% returns a new HVLab data structure, Gxy, containing complex data (dtype = 2) 
% representing the cross-spectral densities of the input time history(s) in HVLab 
% data structures x and y as a function frequency. The frequency increment is 
% the nearest possible value <= HV.FINCREMENT (see notes below). 
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

% Written by CHL, 13-9-2002
% Modified CHL 5/5/2005 to default resolution as in DOS HVLab
% Modified CHL 29/1/2007 to bring HELP notes in line with technical manual

function [dasCSD] = hvcsd(dasTH1, dasTH2, fIncr)

error(HVFUNSTART('CROSS SPECTRAL DENSITY', dasTH1, dasTH2)); % show header and abort if input is not a valid structure
global HV; % allow access to global parameter structure
if nargin < 3, fIncr = HV.FINCREMENT; end % default increment to global setting

for k = 1:length(dasTH1)
    if ~HVISEMPTY(k, dasTH1(k), dasTH2(k)) % return results only for non-empty channels
        error(HVISVALID(dasTH1(k), {'real', '~hz', '~xvar'})); % abort if input data is not in correct form
        error(HVISVALID(dasTH2(k), {'real', '~hz', '~xvar', 'xaxis', 'length'}, dasTH1(k))); 
        [dasCSD(k)] = DOCSD(dasTH1(k), dasTH2(k), fIncr); % compute transfer function
    end
end
return;
   
% =========================================================================
% compute psd of single workspace data structure
function [dasOut] = DOCSD(dasIn1, dasIn2, fIncr)

global HV; % allow access to global parameter structure

% Create output data structures
% -----------------------------
if and(~isempty(dasIn1.title), ~isempty(dasIn2.title))
    title = ['CSD of ', dasIn1.title, ' and ', dasIn2.title]; 
else
    title = [];
end

yunit = [];
xunit = [];
if and(~isempty(dasIn1.yunit), ~isempty(dasIn2.yunit))
    if strcmpi(dasIn1.yunit, dasIn2.yunit)
        yunit = ['(', dasIn1.yunit, ')²'];
    else
        yunit = [dasIn1.yunit, '.', dasIn2.yunit];
    end
end
if strcmpi(dasIn1.xunit, 's')
    xunit = 'Hz';
    if ~isempty(yunit)
        yunit = [yunit, '/Hz'];
    else
        yunit = '1/Hz';
    end    
else        
    if ~isempty(dasIn1.xunit)
        yunit = [yunit, '.', dasIn.xunit];
        xunit = ['1/', dasIn1.xunit];
    end
end

dasOut = HVMAKESTRUCT(title, yunit, xunit, 2, 0, dasIn2.stats); % transfer function is complex

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

% Compute Tranfer Function
% ------------------------
winhandle = str2func(strWin); % get handle to window function
window = feval(winhandle, fftlen); % generate spectral window
dasOut.y = csd(dasIn1.y, dasIn2.y, fftlen, srate, window, noverlap);
outlen  = size(dasOut.y, 1); % return no. of samples in transfer function
outlimit = (outlen - 1) * outincr; % generate x-axis frequency scale
dasOut.x = (0: outincr: outlimit)';
dasOut.y = dasOut.y ./ outlimit; % scale output to units**2/Hz
dasOut.stats(4) = dof;

return
