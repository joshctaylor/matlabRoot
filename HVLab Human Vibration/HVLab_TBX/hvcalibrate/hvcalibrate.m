function hvcalibrate()
%
%
%hvcalibrate - issue 1.1 (17/05/2006)- HVLab HRV Toolbox
%-------------------------------------------------------
%  Script to initialise the calibration graphic interface.
%  "hvcalibrate()" display a window with channel parameters from 
%  the structure 'HV' if it already exists in the Matlab workspace,
%  or display global parameters default values if it doesn't.
%  Channel parameters value can then be modified, saved or loaded from 
%  parameter file with the extension ".pas", and range for each channel
%  can be modified via an 'AUTO-CALIBRATION' option or manually using the
%  input channel monitoring.  Note that running hvcalibrate will
%  automatically close hvparameters.
%

%  written by Pierre HUGUENET, May 2006

global HV;

cml='global HV'; 
evalin('base',cml) %this is used to generate the global variable HV into the workspace

delete(HVPARAMWIN)

if strcmp(HV.DAQTYPE,'None')
       st1=('Error: No DAQ card selected.');
       st2=('Function hvcalibrate will stop.');
       st={st1;st2};
       errordlg(st);  
else
       HVCALIBRATEWIN
end




