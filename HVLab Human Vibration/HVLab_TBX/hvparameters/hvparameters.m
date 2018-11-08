%hvparameters - issue 1.3 (11/12/2006)- HVLab HRV Toolbox
%-------------------------------------------------------------------------
%  Script to initialise the global parameters graphic interface 
%  "hvparameters()", display a window with parameters from 
%  the structure 'HV' if it already exists in the Matlab workspace
%  or display global parameters default values if it doesn't.
%  Parameter values can then be modified, saved or loaded from a parameter
%  file with the extension ".pas". Note that running hvparameters will
%  automatically close hvcalibrate.
%
%  Global parameters are named as follows:
%		Data Acquisition Parameters:
%
%           Input Parameters
%    		HV.INCHANNELS                   number of data channels to be acquired
%    		HV.FIRSTCHANNEL                 number of the first acqusition channel
%    		HV.INFILTER                     input band-limit (Hz)
%    		HV.INHIGHPASS                   enable high-pass filter - if supported by hardware
%    		HV.TINCREMENT                   time increment of input time history (s)
%    		HV.DURATION                     duration of data acquisition (s)
%    		HV.INCHANNEL(16).DESCRIPTION 	array of strings describing data in each channel
%           HV.INCHANNEL(16).VOLTAGE        maximum voltage of the input signal
%    		HV.INCHANNEL(16).RANGE          maximum range of input signal
%    		HV.INCHANNEL(16).UNIT           array of strings contining real units of each channel
%
%           Output Parameters
%    		HV.OUTENABLE                    enable analog output
%    		HV.OUTFILTER                    output band limit (Hz)
%    		HV.OUTVOLTAGE                   maximum voltage range of output
%    		HV.DAQTYPE                      analog interace type
%
%		Function Generation Parameters:
%    		HV.TINCREMENT  	        time increment of the generated time history (s)
%    		HV.DURATION	            duration of data acquisition (s)
%    		HV.SAMPLES	            total number of samples
%    		HV.UNIT	                data unit as string variable
%    		HV.AMPLITUDE	        peak amplitude of function
%    		HV.OFFSET	            offset applied to function
%    		HV.FREQUENCY   	        frequency or initial sweep frequency (Hz)
%    		HV.FINALFREQUENCY	    final sweep frequency (Hz)
%    		HV.FINCREMENT	        frequency increment of weighting function
%
%		General Parameters:
%       File arithmetic
%    		HV.CONSTANT             arithmatic constant 
%       Digital filters
%    		HV.HIGHPASS             lower frequency limit (Hz)
%    		HV.LOWPASS              upper frequency limit (Hz)
%    		HV.FILTERPOLES          number of poles in filter
%       Spectral analysis
%    		HV.FINCREMENT           frequency increment of spectrum (Hz)
%       Probability analysis
%    		HV.DISTRIBUTIONSTEPS    number of probability steps
%    		HV.DISTRIBUTIONMIN      lower distribution limit (0=autoscaled)
%    		HV.DISTRIBUTIONMAX      upper distribution limit (0=autoscaled)
%       General
%    		HV.WINDOW               spectral window
%    		HV.MESSAGES             when set to ON allows functions to return descriptive messages


%  written by Pierre HUGUENET, January 2006
%  Modified by PH 05/04/2006 to add new parameters, modify output parameters
%  and put new default values.
%  Modified by PH 19/05/2006 to change window aspect, add calibration
%  buttons, add menu and remove parameters that will appear in hvcalibrate.
%  Modified by NN 11/12/2006 to improve the HELP.

function hvparameters()
global HV;

cml='global HV'; 
evalin('base',cml) %this is used to generate the global variable HV into the workspace

%Check if the variable HV exist and is a valid parameter structure
validstruct=hvcheckstruct(HV,1);
if validstruct==0   
    fprintf('\n WARNING: Format of the present parameter structure is not valid');
    fprintf('\n or the parameter structure HV is not present');
    fprintf('\n Default global parameters will be loaded\n');
    hvgetpars('hvdefault',1);
end

delete(HVCALIBRATEWIN) %Close calibration window
matver=version;
matver=(str2num(matver(1:3))); %taking information about the version of MATLAB

if matver<7 %checking version of Matlab
    c=sprintf('This program requires Matlab 7 or superior version to run. Your actual Matlab version is %g',b);
    errordlg(c);
    fprintf(1,'\nProgram terminated due to inappropriate MATLAB version\n')
    fprintf(1,'\nType "ver" in the Command Window to display the current MATLAB, Simulink and toolbox version information\n')
    clear matver
    close
else
    HVPARAMWIN(matver); %launching the GUI of hvparameters
    clear matver
end

