%hvimportsef - issue 1.1 (29/06/10) HVLab HRV Toolbox
%----------------------------------------------------
%[mydata, srate, scales, comments, rpc_data, read_error] = hvimportsef(filename)
% Imports data from a SERVOTEST EXTENSIBLE FILE FORMAT data file. Calls 
% function ReadFile.p supplied by SERVOTEST
%
%  	mydata      = HVLab data structure containing imported data
% 	srate       = sampling rate of the data in samples/s
%   scales      = values read from the "scale" field of the SEF file 
%   comments    = comments string read from the SEF file 
%   rpc_data    = values read from the "rpc_data" field of the SEF file 
%   read_error	= values read from the "read_error" field of the SEF file 
%   filename    = string containing pathname for the SEF file

% Written by Chris Lewis (03/02/10)
% Modified by Chris Lewis (29/06/10) to fix a row/column transposition in output data


function [dasOut, srate, scales, strComments, rpcdata, readerror] = hvimportsef(strFile)

HVFUNPAR('IMPORT SERVOTEST SEF FILE');
strFilename = HVFILEXT(strFile, '.sef');
HVFUNPAR('Input file name', strFilename);
[srate, names, units, strComments, ydata, version, rpcdata, scales, readerror] = ReadFile(strFilename);
if readerror == 1; error('Error reading the SEF data file'); end
[nsamples, nchnls] = size(ydata);
xlimit = ((nsamples - 1) * 1./srate);
HVFUNPAR('Number of channels in data structure', nchnls);
HVFUNPAR('Number of data samples', nsamples);

for k = 1:nchnls
    dasOut(k) = HVMAKESTRUCT(names(k,:), units(k,:), 's', 1);
    dasOut(k).y = ydata(:,k);
    dasOut(k).x = (0: 1/srate: xlimit)';
end

return