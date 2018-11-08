%hvwrite - issue 2.1 (13/04/10) - HVLab HRV Toolbox
%--------------------------------------------------
%hvwrite('data\s4.das', outdata, description)
%  Writes a workspace data structure array named outdata to a multi-channel data file.
%  The structure array should include the following fields:
%    outdata(n).dxvar	 	= if true, x-axis data is stored as an additional data column
%    outdata(n).dtype		= type of data in channel n (1=real; 2=complex; 3=mod+phase)
%    outdata(n).title       = description of the data in channel n
%    outdata(n).runit       = units of real/modulus part of channel n									
%    outdata(n).iunit       = units of imag/phase part of channel n									
%    outdata(n).xunit       = units of x-axis scale of channel n
%    outdata(n).stats(32)   = statistical information
%    outdata(n).x			= matrix containing channel n x-axis (time/frequency) data
%    outdata(n).y			= matrix containing channel n data

% Written by Chris Lewis, February 2001
% Renamed to hvwritef TPG 6/12/2001
% Renamed to hvwrite CHL 8/01/2007 (v2.0)
% Updated 15/01/2007 (v2.01) by CHL to make "description" default to a null string 
% Updated 16/01/2007 (v2.02) by CHL to correct fault in previous update.
% Modified by CHL 13/04/2010 to force file extension to ".das"

function [] = hvwrite(filename, dastruct, description)
if nargin < 3; description = ''; end

% open target file in 'write' mode
filename = HVFILEXT(filename, '.das');
fid = fopen(filename, 'w');

% Write main header
nchnls = length(dastruct);             	% long integer values
headlen = 532 + nchnls * 920;
status = 0;
precision = 4;										% bytes per data value
startref = 0;
fwrite(fid, [headlen, nchnls, status], 'integer*4');

fprintf(fid, '%512.512s', description); % maintitle string - force to 512 chars

fwrite(fid, startref, 'real*8');			% double real value

%write channel headers by channel
sumstart = 0;
for k = 1:nchnls
   dastruct(k).dchnl = k;
	[dastruct(k).dlen, datacols] = size(dastruct(k).y);
   
   %TODO - check here datacols consistent with .dtype!   
   dastruct(k).dcols = 1;
   if dastruct(k).dtype > 1
      dastruct(k).dcols = 2;	%complex data is stored in two columns
   end
   if dastruct(k).dxvar > 0
      dastruct(k).dcols = dastruct(k).dcols + 1;	%if dxar = 1, values are are stored as extra column
	end 
    
	dastruct(k).dstart = sumstart;
	writeheader(fid, dastruct(k));
	sumstart = sumstart + precision * (dastruct(k).dlen * dastruct(k).dcols + 1); % add 1 for channel number
end 

%write data by channel
for k = 1:nchnls
   writedata(fid, dastruct(k));
end 

%close file
fclose(fid);
return

%=======================================================
%write chnlstruct header to one channel of file
function [] = writeheader (fid, chnlstruct)

% write long integer data
fwrite(fid,[chnlstruct.dchnl, chnlstruct.dxvar, chnlstruct.dtype, ... 
   			chnlstruct.dcols, chnlstruct.dlen, chnlstruct.dstart],'integer*4');

% write string data
fprintf(fid, '%512.512s', chnlstruct.title);
fprintf(fid, '%32.32s', chnlstruct.yunit);
fprintf(fid, '%32.32s', chnlstruct.y2unit);
fprintf(fid, '%32.32s', chnlstruct.xunit);

%write double real data
if chnlstruct.dxvar
   xorig = 0;
   xincr = 1;
else
   xorig = chnlstruct.x(1);
   xincr = chnlstruct.x(2) - chnlstruct.x(1);
end
offset = 0;
scale = 1;
fwrite(fid,[xorig, xincr, offset, scale],'real*8');

%write statistical data
stats = zeros(1,32);
for k = 1:length(chnlstruct.stats), stats(k) = chnlstruct.stats(k); end;
fwrite(fid,[stats],'real*8');

return

%=======================================================
%write chnlstruct data to one channel of file
function [count] = writedata (fid, chnlstruct)

count1 = fwrite(fid, chnlstruct.dchnl, 'real*4');

if chnlstruct.dtype == 2      
   data = [real(chnlstruct.y) imag(chnlstruct.y)]; 	%if dtype = 2 data is complex
else
   data = chnlstruct.y;
end

if chnlstruct.dxvar     
   data = [data chnlstruct.x]; 	%if dxvar = 1 data is variable increment
end

count = fwrite(fid, data', 'real*4');

return
