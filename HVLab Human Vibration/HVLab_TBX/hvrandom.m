%hvrandom - issue 2.0 (20/11/09) - HVLab HRV Toolbox
%---------------------------------------------------
%[signal] = hvrandom(duration, magnitude, increment, title, yunit, xunit, 
%                                           lowerfreq, upperfreq, taperlen)
%  Creates a random time history in a single HVLab data structure
%    signal		= workspace data structure
%    duration   = optional duration in s (defaults to HV.DURATION)
%    magnitude  = optional r.m.s. magnitude (defaults to HV.AMPLITUDE)
%    increment  = optional time increment (defaults to HV.TINCREMENT)
%    title  	= optional description of the data (string)
%    yunit  	= optional units of y-axis scale (defaults to 'm/s^2')									
%    xunit  	= optional units of x-axis scale (defaults to 's')
%    lowerfreq  = lower band-limit in Hz (defaults to 0)
%    upperfreq  = upper band-limit in Hz (defaults to no band-limit)
%    taperlen   = length of optional taper to be applied to each end of
%                 the signal (in x-axis units)

% written by Chris Lewis, October 2002
% modified by CHL, 20/11/09 to redefine amplitude as r.m.s. magnitude and
%                  add provide optionally tapered start and finish

function [dasNew] = hvrandom(xlimit, amplitude, xincr, title, yunit, xunit, hpfc, lpfc, taperlen)

HVFUNSTART('CREATE RANDOM SIGNAL');
global HV; %allow access to global parameter structure
if nargin < 1; xlimit = HV.DURATION; end
if nargin < 2; amplitude = HV.AMPLITUDE; end
if nargin < 3; xincr = HV.TINCREMENT; end
if nargin < 4; title = []; end
if nargin < 5; yunit = 'm/s^2'; end
if nargin < 6; xunit = 's'; end
if nargin < 7; hpfc = 0; end
if nargin < 8; lpfc = 0; end
if nargin < 9; taperlen = 0; end
dasNew = HVSIGNAL('random', title, yunit, xunit, xlimit, amplitude, xincr, hpfc, lpfc, taperlen);

return