%hvread - issue 3.1 (13/04/10) - HVLab HRV Toolbox
%-------------------------------------------------
%[indata, inchnls, indescript] = hvread('data\s4.das');
%  Reads a multi-channel data file into a workspace data structure 
%  array named indata.
%    inchnls           	= no. of channels of data in structure array
%    description      	= overall description of the data set
%  Parameters and data are written to the following fields:
%    indata(n).dxvar    = if true, x-axis data is stored as an additional data column
%    indata(n).dtype    = type of data in channel n (1=real; 2=complex; 3=modphase)
%    indata(n).title  	= description of the data in channel n
%    indata(n).runit  	= units of real part of channel n									
%    indata(n).xunit  	= units of x-axis scale of channel n
%    indata(n).stats(32)= additional statistical information
%    indata(n).x	    = column matrix containing x-axis (time/frequency) values
%    indata(n).y	    = column matrix containing channel n data

% written by Chris Lewis, November 2000
% noted by CHL, 16/03/06: need to remove unwanted fields in output structure
% renamed to hvread CHL 8/01/2007 (v2.0)
% modified so as to eliminate unwanted fields in output strcture CHL 10/01/2007 (v3.0)
% modified by CHL 13/04/2010 to force file extension to ".das"

function [dastruct, nchnls, description] = hvread(filename)

%Open file
filename = HVFILEXT(filename, '.das');
fid = fopen(filename, 'r');

%Read information from main header
status = fseek(fid, 0, 'bof');
[ivals, count] = fread(fid, 3, 'integer*4');
[cvals, count] = fread(fid, 512, 'uchar');
[rvals, count] = fread(fid, 1, 'real*8');
	headlen = ivals(1);  
	nchnls = ivals(2);  
    status = ivals(3); 
    description = deblank(fliplr(deblank(fliplr(setstr(cvals)'))));
	startref = rvals;  

%Read information from channel headers
status = fseek(fid, 532, 'bof');
for k = 1:nchnls
    tmpstruct(k) = GETHEADER(fid);
end

%Read data 
for k = 1:nchnls
 	status = fseek(fid, tmpstruct(k).dstart + headlen, 'bof');
	[tmpstruct(k).dchnl, tmpstruct(k).y] = getdata(fid, tmpstruct(k).dcols, tmpstruct(k).dlen);
	%If variable increment, create xscale
	if tmpstruct(k).dxvar > 0
   	if tmpstruct(k).dtype == 1
      	tmpstruct(k).x = tmpstruct(k).y(:,2);
      	tmpstruct(k).y(:,2) = [];
		else
      	tmpstruct(k).x = tmpstruct(k).y(:,3);
      	tmpstruct(k).y(:,3) = [];
     end
   else  
		xlimit = tmpstruct(k).orig + (tmpstruct(k).dlen - 1) * tmpstruct(k).incr;
		tmpstruct(k).x = (tmpstruct(k).orig: tmpstruct(k).incr: xlimit)';
	end
  
	%If complex, create complex data from pairs of data points
	if tmpstruct(k).dtype == 2
   	tmpstruct(k).y = tmpstruct(k).y(:,1) + j*tmpstruct(k).y(:,2); 
	end
end

%Close file
fclose(fid);

%Create output data structure
for k = 1:nchnls
    dastruct(k) = HVMAKESTRUCT(tmpstruct(k).title, tmpstruct(k).yunit, tmpstruct(k).xunit, tmpstruct(k).dtype, tmpstruct(k).dxvar, tmpstruct(k).stats);
	dastruct(k).x = tmpstruct(k).x;
	dastruct(k).y = tmpstruct(k).y;
    dastruct(k).y2unit = tmpstruct(k).y2unit;
end

return

%============================================
%Read header for one channel
function [chnlstruct] = GETHEADER (fid)

[ivals, count] = fread(fid, 6, 'integer*4');
   chnlstruct.dchnl 	= ivals(1);
   chnlstruct.dxvar 	= ivals(2);
   chnlstruct.dtype 	= ivals(3);
   chnlstruct.dcols 	= ivals(4);
   chnlstruct.dlen		= ivals(5);
   chnlstruct.dstart 	= ivals(6);

% change following to use the "count" byte - need to define the offsets into 'cvals'
[cvals, count] = fread(fid, 608, 'uchar');
	chnlstruct.title = deblank(fliplr(deblank(fliplr(setstr(cvals(1:512)')))));
	chnlstruct.yunit = deblank(fliplr(deblank(fliplr(setstr(cvals(513:544)')))));
	chnlstruct.y2unit = deblank(fliplr(deblank(fliplr(setstr(cvals(545:576)')))));
	chnlstruct.xunit = deblank(fliplr(deblank(fliplr(setstr(cvals(577:608)')))));

[rvals, count] = fread(fid, 36, 'real*8');
   chnlstruct.orig = rvals(1);
   chnlstruct.incr = rvals(2);
   chnlstruct.offset = rvals(3);
   chnlstruct.scale = rvals(4);
   chnlstruct.stats = rvals(5:36);
   chnlstruct.stats = chnlstruct.stats'; %make into a row matrix
   
return

%===========================================
%Read data for one channel
function [dchnl, data] = getdata (fid, dcols, dlen)

	[dchnl, count] = fread(fid, 1, 'real*4');   	% read channel number
	[data, count] = fread(fid, [dcols, dlen], 'real*4'); % read data points
	data = data'; % convert back to column format
   
return