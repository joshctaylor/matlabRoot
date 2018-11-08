%hvtransient - issue 1.1 (30/07/10) - HVLab HRV Toolbox
%-------------------------------------------------------
%[At, Vt, Dt] = hvtransient(cycles, frequency, accel, increment, title)
% Generates transient sinusoidal test signal in which the acceleration,
% velocity and displacement all integrate to zero.
%
%		At          = new data structure containing acceleration waveform
%		Vt          = new data structure containing velocity waveform
%		Dt          = new data structure containing displacement waveform
%		frequency	= frequency of output waveform
%       cycles      = no. of complete wavelengths in output waveform
%       Apeak       = peak acceleration of output waveform
%       increment   = optional time increment (defaults to HV.TINCREMENT)
%-------------------------------------------------------------------------
%WARNING this function has not yet been formally tested and should be used 
%with caution
%-------------------------------------------------------------------------

% written by Chris Lewis, Dec 2009 
% Untested message added by Chris Lewis, July 2010

function [Aout, Vout, Dout] = hvtransient(cycles, f, A, xincr, title)

error(HVFUNSTART('GENERATE TRANSIENT TEST SIGNAL')); % show header and abort if input is not a valid structure
fprintf(1, '*************************************************************************\n');
fprintf(1, 'WARNING this function has not yet been formally tested and should be used\n');
fprintf(1, 'with caution\n');
fprintf(1, '*************************************************************************\n');

global HV; %allow access to global parameter structure

if nargin < 3; accel = HV.AMPLITUDE; end
if nargin < 4; xincr = HV.TINCREMENT; end
if nargin < 5; title = 'transient'; end

n = fix(cycles) + 0.5;
xlimit = n / f;
t = 0:xincr:xlimit;
HVFUNPAR('sampling increment', xincr, 's');
HVFUNPAR('duration', xlimit, 's');

Aout = HVMAKESTRUCT([title, ' acceleration'], 'm/s^2', 's', 1, 0, [1/xincr, 0, 0, 0, 0, 0], t);
Vout = HVMAKESTRUCT([title, ' velocity'], 'm/s', 's', 1, 0, [1/xincr, 0, 0, 0, 0, 0], t);
Dout = HVMAKESTRUCT([title, ' displacement'], 'm', 's', 1, 0, [1/xincr, 0, 0, 0, 0, 0], t);

%Theoretical acceleration, velocity and displacement for any n number of cycles
Aout.y = A * sin(2*pi*f*t).* sin(pi*f*t/n);
Vout.y = (A *(pi*f/n)/((pi*f/n)^2-(2*pi*f)^2))*(-sin(2*pi*f*t).* cos((pi*f/n)*t)+(2*n)*sin((pi*f/n)*t).* cos(2*pi*f*t));
Dout.y = (A/2)*(((cos((2+(1/n))*pi*f*t)-1)/(((2+(1/n))*pi*f)^2))-((cos((2-(1/n))*pi*f.*t)-1)/(((2-(1/n))*pi*f)^2)));
 
return
