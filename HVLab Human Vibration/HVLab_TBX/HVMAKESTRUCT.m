%HVMAKESTRUCT - issue 1.1 (27/01/10) - HVLab HRV Toolbox
%------------------------------------------------------- 
%[newtruct] = HVMAKESTRUCT(title, yunit, xunit, dtype, dxvar, stats, xvals)
% Creates a new empty workspace data structure array with fields in the 
% required order
%
%    newtruct	= new workspace data structure array
%    title  	= description of the data (string)
%    yunit  	= units of y-axis scale (string)									
%    xunit  	= units of x-axis scale (string)
%    dtype  	= type of data (1=real; 2=cmplx; 3=angular)									
%    dxvar  	= flag indicating variable increment if true
%    stats  	= array of statistical information
%    xvals  	= column matrix of x-axis data points
%

% written by Chris Lewis, September 2002
% written by Chris Lewis (27/01/10) to bring HELP notes in line with
% technical manual

function [dasNew] = HVMAKESTRUCT(title, yunit, xunit, dtype, dxvar, stats, xvals)

dasNew.dxvar 	= 0;	%default to fixed increment
dasNew.dtype 	= 1;	%default to real
dasNew.title   	= '';	%description of data
dasNew.yunit   	= '';	%units of data
dasNew.y2unit   = '';	%units of phase data (for dtype = 3)
dasNew.xunit	= '';	%units of x-axis scale
dasNew.stats(1) = 0;	%sampling rate (0 = not set)
dasNew.stats(2) = 0;	%high-pass cut-off frequency
dasNew.stats(3) = 0;	%low-pass cut-off frequency (0 = not set)
dasNew.stats(4) = 0;	%statistical degrees of freedom
dasNew.x	    = [];   %x-axis values
dasNew.y 	    = [];	%data values

if nargin > 6, dasNew.x = xvals;	end;
if nargin > 5, dasNew.stats = stats;	end;
if nargin > 4, dasNew.dxvar = dxvar;	end;
if nargin > 3, dasNew.dtype = dtype;	end;
if nargin > 2, dasNew.xunit = xunit;	end;
if nargin > 1, dasNew.yunit = yunit;	end;
if nargin > 0, dasNew.title = title;	end;

return