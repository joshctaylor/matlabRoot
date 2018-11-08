%hvimportwav - issue 1.2 (30/07/10) HVLab HRV Toolbox
%----------------------------------------------------
%[wavdata, srate, nbits] = hvimportwav(filename, CF, title);
% Reads a WAV audio file into an HVLab data structure
%
%	wavdata    = HVLab data structure containing imported data
%	srate      = sampling rate
%	nbits      = number of bits per sample used to encode the data
%	filename   = name of WAV audio file (string)
% 	CF         = Calibration factor (dB), defined as the sound pressure 
%                level that a sine wave would have if its peak amplitude 
%                in the file was 50% of digital full scale. If the value of
%                CF is zero, the data will not be scaled (i.e. the data
%                will be ranged between -1 and +1)
% 	title      = optional description of the data (string)
%
%Notes:
%------
% Calibration factors (CF) for WAV files recorded on a RION NA-28 
% sound-level meter are:
% 	86  for the 80dB measurement range 
%	96  for the 90dB measurement range 
%	106 for the 100dB measurement range 
%	116 for the 110dB measurement range 
% The CF is 9dB (i.e. 2*sqrt(2)) below than the maximum peak range of 
% the signal.
%-------------------------------------------------------------------------
%WARNING this function has not yet been formally tested and should be used 
%with caution
%-------------------------------------------------------------------------

% Written by Chris Lewis, August 2009
% Modified by CHL 13/04/2010 to force file extension to ".wav"
% Untested message added by Chris Lewis, July 2010

function [dasOut, srate, nbits] = hvimportwav(filename, CF, title)

HVFUNSTART('IMPORT WAVE AUDIO FILE');
fprintf(1, '*************************************************************************\n');
fprintf(1, 'WARNING this function has not yet been formally tested and should be used\n');
fprintf(1, 'with caution\n');
fprintf(1, '*************************************************************************\n');

if nargin < 2, CF = 0; end;
if nargin < 3, title = 'WAVE SPL'; end;

filename = HVFILEXT(filename, '.wav');
[ydata, srate, nbits] = wavread(filename);

    [xlen, nchans] = size(ydata); % no. of samples in output
    xlimit = (xlen - 1) / srate; % generate x-axis frequency scale

    for k = 1:nchans
        dasOut(k) = HVMAKESTRUCT([title ' channel ' num2str(k)], 'Pa', 's');   
        dasOut(k).x = (0: 1/srate: xlimit)';
        if CF == 0
            dasOut(k).y = ydata(:,k);
        else
            dBscale = CF - 20*log10(0.5/(0.00002*sqrt(2))); % RE Sinewave with -6dB peak
            dasOut(k).y = ydata(:,k) .* 10^(dBscale/20);
        end
    end
    HVFUNPAR('duration', xlimit, 's');
    HVFUNPAR('sampling rate', srate, 's/s');
    HVFUNPAR('bits per sample', nbits);
        
return

