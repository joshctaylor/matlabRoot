%hvimportdat - issue 3.1 (04/02/09) HVLab HRV Toolbox
%----------------------------------------------------
%[mydata] = hvimportdat(filenumbers, pathname);
%  Reads data sets from one or more HVLab_DOS files (with extension .dat) 
%  into an HVLab data structure
%
%    mydata         = HVLab data structure containing imported data
%    filenumbers	= vector of numeric file names
%    pathname       = optional pathname for data files
%
%Examples:
%--------
%[data11] = hvimportdat(11, 'c:\data\') 
%  returns a single-channel data structure, data11, containing data from
%  HVLab_DOS file c:\data\11.dat
%
%[threechnldat] = hvimportdat([11:13]) 
%  returns a data structure, threechnldat, with 3 channels containing data
%  from HVLab_DOS files 11.dat, 12.dat and 13.dat respectively
%
%[mydata] = hvimportdat([11 13 15 17]) 
%  returns a data structure, mydata, with 4 channels containing data from
%  HVLab_DOS files 11.dat, 13.dat, 15.dat and 17.dat respectively 
%

%  Written by Chris Lewis, January 2004
%  Modified TPG May 2004 to accept a vector of input file numbers rather
%  than a single value
%  Modified TPG 19/7/2004 to add an 'fclose' command to prevent Matlab
%  crashing when reading large numbers of files
%  Modified by Chris Lewis, 26 October 2004 to eliminate un-needed "dlen" parameter
%  Modified TPG 1st November 2004 to fix crash from a missing reference to
%  the "dlen" parameter
%  Modified CHL June 2008 to add optional file pathname
%  Modified CHL 04/02/2009 to bring HELP in line with technical manual

function [dastructout] = hvimportdat(filenumbers, path)

HVFUNSTART('READ HVLab_DOS DATA FILE');

if nargin < 2, path = ''; end;

for q=1:length(filenumbers)
    
    % pick the next filenumber to read
    filenumber=filenumbers(q);
    
    %Open file
    filename = [path int2str(filenumber) '.dat'];
    fid = fopen(filename, 'r');
    
    %Read information from file header
    status = fseek(fid, 0, 'bof');
    [rvals, count] = fread(fid, 32, 'real*4');
    [ivals, count] = fread(fid, 8, 'integer*2');
    
    [title, count] = getCstring (fid, 144);
    [xunit, count] = getCstring (fid, 304);
    [yunit, count] = getCstring (fid, 330);
    
    [dastruct] = HVMAKESTRUCT(title, yunit, xunit);   
    
    [dastruct.y2unit, count] = getCstring (fid, 356);
    
    %samples     = rvals(1);
    srate 	    = rvals(2);
    origin 	    = rvals(3);
    increment   = rvals(4);
    mode        = ivals(1);
    if mode < 1; mode = 1; end
    
    %Read data 
    status = fseek(fid, 512, 'bof');
    switch mode
        case 1
            dastruct.dtype = 1;
            [dastruct.y, count] = fread(fid, inf, 'real*4');
            dlen = count;
        case 2
            dastruct.dtype = 2;
            [vals, count] = fread(fid, [2, inf], 'real*4');
            dlen = count / 2;
            vals = vals';
            dastruct.y = vals(:,2) + j*vals(:,1);    
        case 4
            dastruct.dtype = 3;
            [vals, count] = fread(fid, [2, inf], 'real*4');
            dlen = count / 2;
            vals = vals';
            dastruct.y = [vals(:,2) vals(:,1)];    
        case 8
            dastruct.dtype = 1;
            [vals, count] = fread(fid, [2, inf], 'real*4');
            dlen = count / 2;
            vals = vals';
            dastruct.y = vals(:,2); 
            dastruct.x = vals(:,1);    
        otherwise
            error('unrecognised file mode');
    end
    
    if mode < 8
        xlimit = origin + (dlen - 1) * increment;
        dastruct.x = (origin: increment: xlimit)';
    end
    
    % store the data as one channel of the output data structure
    dastructout(q)=dastruct;
    
    % close the file
    fclose(fid);
    
end
return
%===========================================
%Read counted string from file
function [string, len] = getCstring (fid, startbyte)

status = fseek(fid, startbyte, 'bof'); 	
[len, count] = fread(fid, 1, 'uchar');   	% read count byte
if len > 0
    [stringdata, count] = fread(fid, len, 'uchar');  % read data points
    string=char(stringdata');
else
    string = '' ;
end
return

