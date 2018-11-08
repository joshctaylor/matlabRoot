%hvsweep - issue 2.0 (20/11/09) - HVLab HRV Toolbox 
%--------------------------------------------------
%[signal] = hvsweep(frequency1, frequency2, duration, magnitude, 
%                                  increment, title, yunit, xunit, taperlen)
%  Creates a swept sinusoidal time history in an HVLab data structure
%    signal		= workspace data structure
%    frequency1 = frequency or initial sweep frequency in Hz (defaults to 1)
%    frequency2 = final sweep frequency in Hz (defaults to sample_rate/5)
%    duration   = optional duration in s (defaults to HV.DURATION)
%    magnitude  = optional r.m.s. magnitude (defaults to HV.AMPLITUDE)
%    increment  = optional time increment (defaults to HV.TINCREMENT)
%    title  	= optional description of the data (string)
%    yunit  	= optional units of y-axis scale (defaults to 'm/s²')									
%    xunit  	= optional units of x-axis scale (defaults to 's')
%    taperlen   = length of optional taper to be applied to each end of
%                 the signal (in x-axis units)

% written by Chris Lewis, October 2002
% modified by CHRG, 10/01/06 to warn users for a too low sampling rate
% modified by CHL, 16/03/06 to give a more specific warning message
% modified by CHL, 20/11/09 to redefine amplitude as r.m.s. magnitude and
%                  add provide optionally tapered start and finish

function [dasNew] = hvsweep(frequency1, frequency2, xlimit, amplitude, xincr, title, yunit, xunit, taperlen)

HVFUNSTART('CREATE SWEPT SINE SIGNAL');
global HV; %allow access to global parameter structure
if nargin < 1; frequency1 = 1; end
if nargin < 3; xlimit = HV.DURATION; end
if nargin < 4; amplitude = HV.AMPLITUDE; end
if nargin < 5; xincr = HV.TINCREMENT; end
if nargin < 2; frequency2 = 1/(xincr.*5); end
if nargin < 6; title = []; end
if nargin < 7; yunit = 'm/s²'; end
if nargin < 8; xunit = 's'; end
if nargin < 9; taperlen = 0; end
if 2*frequency2 >= 1/xincr
    error('sampling rate should be at least 2* the highest output frequency'); 
end
dasNew = HVSIGNAL('sweep', title, yunit, xunit, xlimit, amplitude, xincr, frequency1, frequency2, taperlen);

return