%HVSINE - issue 2.0 (20/11/09) - HVLab HRV Toolbox 
%-------------------------------------------------
%[signal] = hvsine(frequency, duration, magnitude, increment, title, yunit, 
%                                                          xunit, taperlen)
%  Creates a sinusoidal time history in a single HVLab data structure
%    signal		= workspace data structure
%    frequency  = frequency in Hz (defaults to 1 Hz)
%    duration   = optional duration in s (defaults to HV.DURATION)
%    magnitude  = optional r.m.s. magnitude (defaults to HV.AMPLITUDE)
%    increment  = optional time increment (defaults to HV.TINCREMENT)
%    title  	= optional description of the data (string)
%    yunit  	= optional units of y-axis scale (defaults to 'm/s^2')									
%    xunit  	= optional units of x-axis scale (defaults to 's')
%    taperlen   = length of optional taper to be applied to each end of
%                 the signal (in x-axis units)

% written by Chris Lewis, October 2002
% modified by CHRG, 10/01/06 to take warn users for a too low sampling rate
% modified by CHL, 16/03/06 to give a more specific warning message
% modified by CHL, 20/11/09 to redefine amplitude as r.m.s. magnitude and
%                  add provide optionally tapered start and finish

function [dasNew] = HVSINE(frequency, xlimit, amplitude, xincr, title, yunit, xunit, taperlen)

HVFUNSTART('CREATE SINUSOIDAL SIGNAL');
global HV; %allow access to global parameter structure
if nargin < 1; frequency = 1; end
if nargin < 2; xlimit = HV.DURATION; end
if nargin < 3; amplitude = HV.AMPLITUDE; end
if nargin < 4; xincr = HV.TINCREMENT; end
if nargin < 5; title = []; end
if nargin < 6; yunit = 'm/s^2'; end
if nargin < 7; xunit = 's'; end
if nargin < 8; taperlen = 0; end
if 2*frequency >= 1/xincr; error('sampling rate should be at least 2* the output frequency'); end

dasNew = HVSIGNAL('sine', title, yunit, xunit, xlimit, amplitude, xincr, frequency, 0, taperlen);

return