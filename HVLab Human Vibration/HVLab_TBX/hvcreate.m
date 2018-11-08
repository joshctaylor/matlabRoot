%hvcreate - issue 1.3 (03/08/09) - HVLab HRV Toolbox
%---------------------------------------------------
% [dastruct] = hvcreate(ydata, xdata/xincr, title, yunit, xunit)
% Creates an HVLab data structure from constant increment data
%
%    mydata      =   new HVLab data structure
%    ydata       =   input data (row or column matrix)
%    xdata/xincr =   time/frequency increment (single value) or time/frequency 
%                    data points (matrix with same length as ydata)
%    title       =   description of the data (string: defaults to '')
%    yunit	     =   units of y-scale data (string: defaults to 'm/s²')										
%    xunit       =   units of x-axis scale (string: defaults to 's')
%
%Notes:
%------
% The input, ydata, may comprise a single column (or row) of real or
% complex values, or two columns (or two rows) of real values. If the input
% contains two rows or columns, the data will be interpreted as modulus and
% phase (i.e. the dtype of mydata will be set to 3)

% written by Chris Lewis, December 2001
% modified TPG 19/7/2002 to correct the detection of dtype 2 data
% modified CHL 3/9/2002 to use HVMAKESTRUCT 
% modified CHL 02/02/2009 to bring HELP in line with technical manual
% modified CHL 01/07/2009 to add 'xdata' parameter
% modified CHL 03/08/2009 to force x and y vectors to rows

function [dasNew] = hvcreate(ydata, xincr, title, yunit, xunit)

HVFUNSTART('CREATE NEW DATA STRUCTURE');

if nargin < 5; xunit = 's'; end
if nargin < 4; yunit = 'm/s²'; end
if nargin < 3; title = []; end

dasNew = HVMAKESTRUCT(title, yunit, xunit);

dasNew.y = forcetocols(ydata);				   
[dlen, dcols] = size(dasNew.y);
if dcols == 1
   if abs(sum(imag(ydata))) > 0, dasNew.dtype = 2; end;
else 
   dasNew.dtype = 3;
end

if nargin < 2, xincr = 1;	end;

if length(xincr) == 1 
    xlimit = (dlen - 1) * xincr;
    dasNew.x = (0: xincr: xlimit)';
else
    if length(xincr) == length(dasNew.y)
        dasNew.x = forcetocols(xincr);
        xincr = dasNew.x(2) - dasNew.x(1);
    else
        error('xdata must be the same length as ydata')
    end
end

if strcmp(dasNew.xunit, 's'), dasNew.stats(1) 	= 1/xincr;		end;
if strcmp(dasNew.xunit, 'Hz'), dasNew.stats(1)	= xlimit/(2);	end;

return

%===============================================
% force vectors of unknown orientation into rows
function [outvect] = forcetocols(invect);

[r, c] = size(invect);
if (c > r)
    outvect=invect';
else
    outvect=invect;
end

return