%hvimportwdc - issue 2.3 (30/07/10) HVLab HRV Toolbox
%----------------------------------------------------
%[mydata, inchnls, srate, samples, gains] = 
%                   hvimportwdc(filename, title, start, duration, chnlsens)
%  Reads a DATAQ DI-710 multi-channel data file into an HVLab data
%  structure
%
%    mydata     = HVLab data structure containing imported data
%    inchnls	= no. of channels of data in the data logger file
%    srate      = sampling rate of the data in samples/s
%    samples    = no. of samples per channel in the output data structure
%    gain       = array of gains of consecutive channels of the DI-710
%    filename   = name of the data logger file (string), with extension .wdc
%    title      = optional description of the data (string)
%    start      = optional start time relative to beginning of file (s)
%    duration   = optional length of data to import: 0=all samples (s)
%    chnlsens   = optional cell array of sensitivity (units/volt) and 
%                 units (string) for each channel in turn
%
%Example:
%--------
%chnlinf = {2.4; 'ms-2'; 2.8; 'ms-2'; 2.3; 'ms-2'; 10.9; 'degs-2'; 10.1; 'degs-2'; 10.3; 'degs-2'};  
%[shipdata, nchnls, srate] = hvimportwdc ('D4A7006B.wdc', 'condition 1', 0, 0, chnlinf)
%  returns a data structure, shipdata, containing 6 channels of data
%  recorded by a DATAQ DI-710 logger in multi-channel data file
%  D4A7006B.wdc. The scaling is adjusted according to the values in the
%  cell array chnlinf.
%-------------------------------------------------------------------------
%WARNING this function has not yet been formally tested and should be used 
%with caution
%-------------------------------------------------------------------------

% Written by CHL, January 2008
% Modified by CHL 04/02/2009 to bring HELP in line with technical manual
% Modified by CHL 13/04/2010 to force file extension to ".wdc"
% Untested message added by Chris Lewis, July 2010


function [dastruct, channels, srate, nsamples, gain] = hvimportwdc(filename, description, start, duration, chnlsens)

if nargin < 2, description = 'DI-710'; end;
if nargin < 3, start = 0; end;
if nargin < 4, duration = 0; end;
if nargin < 5, sensmode = 0; else sensmode = 1; end;
    
%Open file
filename = HVFILEXT(filename, '.wdc');
fid = fopen(filename, 'r');

%Read information from CODAS header
status = fseek(fid, 0, 'bof'); %element 1, bytes 0-1 
    channels    = fread(fid, 1, 'uint16');
status = fseek(fid, 6, 'bof'); %element 5, bytes 6-7
    headerbytes = fread(fid, 1, 'int16');
status = fseek(fid, 28, 'bof'); %element 13, bytes 28-35
    increment   = fread(fid, 1, 'double');
status = fseek(fid, 36, 'bof'); %elements 14/15, bytes 36-53
    times       = fread(fid, 2, 'long');
offset = 110 + 32; %element 34, bytes 110-
    for k = 1:channels
        status = fseek(fid, offset, 'bof');
        chnlinf(k,:) = fread(fid, 2, 'uchar');
        offset = offset + 36;
    end
    chnlno = chnlinf(:,1); %physical channel number of DI710
    chnlgn = bitand(chnlinf(:,2), bin2dec('00001111')); %code indicating the voltage gain of each channel
    chnlpk = bitand(chnlinf(:,2), bin2dec('11110000')); %code indicating the FSV of each channel
status = fseek(fid, headerbytes-2, 'bof');
    checknum    = fread(fid, 1, 'int16');
    if checknum ~= -32767; error('error detected in DI-710 file header'); end;   
    srate       = 1 / increment;
    interchnlag = increment / channels; 
    ts          = datestr((times(1)+3600)/(24*3600) - 10956);
    te          = datestr((times(2)+3600)/(24*3600) - 10956);

%Read the data
firstsample = start / increment;
offset = headerbytes + 2*(channels * firstsample);
status = fseek(fid, offset, 'bof'); 
    if duration == 0    
        [idata, count] = fread(fid, [channels, inf], 'int16'); %read all data to matrix with rows = channels
    else
        samples = duration / increment;
        [idata, count] = fread(fid, [channels, samples], 'int16'); %read spec data to matrix with rows = channels
    end
    nsamples = count / channels;

HVFUNPAR('IMPORT DI-710 DATA LOGGER FILE');
fprintf(1, '*************************************************************************\n');
fprintf(1, 'WARNING this function has not yet been formally tested and should be used\n');
fprintf(1, 'with caution\n');
fprintf(1, '*************************************************************************\n');
HVFUNPAR(['acquistion started on ', ts]);
HVFUNPAR(['acquistion finished on ', te]);
HVFUNPAR('no. of channels', channels);
HVFUNPAR('sampling rate', srate, 'samples/s');
HVFUNPAR('no. of samples imported per channel', nsamples);
HVFUNPAR('no. of samples skipped per channel', firstsample);

%Create output data structure
sens = 1;
unit = 'V';
origin = start; % make optional!!!
origin = 0;
for k = 1:channels
    switch chnlgn(k)
        case 0; gain(k) = 1;
        case 1; gain(k) = 2;
        case 2; gain(k) = 5;
        case 3; gain(k) = 10;
        %case 3; gain(k) = 2; %necessary for HMS Nottingham files - OK for later REC1 output
        case 4; gain(k) = 50;
        case 5; gain(k) = 100;
        case 6; gain(k) = 500;
        case 7; gain(k) = 1000;
        case 8; gain(k) = 4;
        case 9; gain(k) = 8;
        case 10; gain(k) = 20;
        case 11; gain(k) = 200;
        case 12; gain(k) = 10000;
        case 13; gain(k) = 100000;
        case 14; gain(k) = 40;
        case 15; gain(k) = 80;
    end
    if sensmode ~= 0
        sens = chnlsens{k * 2 - 1}; %cells 1, 3, 5, etc.
        unit = chnlsens{k * 2}; %cells 2, 4, 6, etc.
    end
    dastruct(k) = HVMAKESTRUCT([description, ': DI710 channel ', num2str(chnlno(k))], unit, 's', 1);
    dastruct(k).y = idata(k,:)' * (sens * 10)/(32768 * gain(k));
    xlimit = (origin + (nsamples - 1) * increment);
    dastruct(k).x = (origin: increment: xlimit)';
    origin = origin + interchnlag;
end
gain;

% close the file
fclose(fid);