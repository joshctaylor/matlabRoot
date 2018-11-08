%hvlobutter - issue 1.1 (22/04/09) - HVLab HRV Toolbox
%-----------------------------------------------------
%[outdata] = hvlobutter(indata, fc, npoles)
% Applies a low-pass Butterworth filter to time histories in HVLab data array 
% using an identical algorithm to the HVLab_DOS function LOBUTTER
%
% outdata 	=	name of new HVLab data structure containing the filtered 
%               data
% indata	= 	name of HVLab data structure containing the unfiltered time 
%               history(s) 
% fc        = 	numeric value representing the cut-off frequency (the -3dB 
%               point) in Hz. If this argument is not present, the cut-off 
%               frequency defaults to the global parameter HV.LOWPASS
% npoles	=	integer value representing the number of poles (i.e. the 
%               order of the filter), which can be an even number between 2
%               and 10. If this argument is not present, the number of
%               poles defaults to the global parameter HV.FILTERPOLES.
%Notes
%-----
% Butterworth filters can also be implemented by the less restrictive
% function hvfilter, which allows either odd or even numbers of poles 
% between 1 and 10
%

% Written by Chris Lewis, February 2004
% Modified by CHL 22/04/09, to reflect renaming of function HVFILTER to HVLABFILTER

function [dasOutarr] = hvlobutter(dasInarr, fFc, iPoles)

[dasOutarr] = HVLABFILTER(dasInarr, 'BUTTERWORTH', 'LOWPASS', fFc, iPoles);

return

