%hvinitialise - issue 1.1 (02/02/09) - HVLab HRV Toolbox
%-------------------------------------------------------
%[] = hvinitialise()
%  Creates the global parameter structure HV. The values of the individual
%  parameters are read from the parameter file 'hvdefault.pas', if it
%  exists, or initialised to default values if the file does not exist.
%
%Fields in Global Parameter Structure:
%-------------------------------------
%Analogue data acquisition and output
%    HV.INCHANNELS      number of data channels to be acquired
%    HV.FIRSTCHANNEL	number of the first acqusition channel
%    HV.TINCREMENT      sampling increment of input time history (s)
%    HV.DURATION		duration of data acquisition (s)
%    HV.INFILTER        cut-off of anti-aliasing filter (Hz) if supported by hardware
%    HV.INHIGHPASS      enables high-pass filter ('ON' or 'OFF') if supported by hardware
%    HV.INCHANNEL(k).TITLE     string describing data in each of 16 channels
%    HV.INCHANNEL(k).UNIT      string contining real units of each channel
%    HV.INCHANNEL(k).RANGE     maximum range of input signal (m/s²)
%    HV.INCHANNEL(k).VOLTAGE   maximum voltage of the input signal
%    HV.OUTENABLE       enables data output ('ON' or 'OFF')
%    HV.OUTFILTER       cut-off of output filter (Hz) if supported by hardware
%    HV.OUTVOLTAGE      maximum voltage of the output signals
%    HV.DAQTYPE         string describing type of data acquisition hardware
%Creation of data sets	
%    HV.UNIT            units of generated function (string)
%    HV.DURATION        duration of generated time history (s)
%    HV.TINCREMENT      sampling increment of time history (s)
%    HV.FINCREMENT      frequency increment of generated weighting function (Hz)
%    HV.AMPLITUDE       peak amplitude of generated function
%    HV.OFFSET          offset applied to generated function
%    HV.FREQUENCY       frequency or initial frequency of sine function (Hz)
%    HV.FINALFREQUENCY  final frequency of sine function (Hz)
%    HV.HIGHPASS        lower frequency limit (Hz)
%    HV.LOWPASS         upper frequency limit (Hz)
%Spectral analysis	
%    HV.FINCREMENT      target frequency increment (Hz)
%    HV.WINDOW          spectral window (string)
%Digital filters	
%    HV.HIGHPASS        high-pass cut-off (Hz)
%    HV.LOWPASS         low-pass cut-off (Hz) 
%    HV.FILTERPOLES     number of poles in filter
%Programme control
%    HV.MESSAGES	    when set to true ('ON') allows functions to return
%                       descriptive messages%  written by Chris Lewis, April 2001

% Modified by TPG 29/7/2004 to add reference to HV.INCHANNEL(16).VOLTAGE
% modified CHL 02/02/2009 to bring HELP in line with technical manual

global HV;
hvgetpars('hvdefault',1); % Loads parameter values from file 'hvdefault.pas', if it exists, or default values if the file does not exist.

