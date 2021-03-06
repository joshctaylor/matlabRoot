%hvdatawin - issue 2.2 (20/11/2009) - HVLab HRV Toolbox
%------------------------------------------------------
%function [] = hvdatawin()
% Analogue data acquisition and output according to the settings in the
% global parameter structure HV, using a graphical user interface (GUI).
% Data are written to and from HVLab data files, which can be accessed
% using the functions hvread and hvwrite.
%
% The data acquisition device is set by by HV.DAQTYPE:
%   'MCC PCMCIA-DAS16/16'   Measurement Computing DAQ boards - the
%   'MCC PCI-DAS6036'       active MCC board should be installed
%   'MCC PCI-DAS1602'       and set up as "Board #1" using the INSTACAL
%                           software provided by the manufacturer. The
%                           input configuration must be "16 single-ended
%                           channels."
%   'NI USB-6211'           National Instruments DAQ boards - the
%   'NI USB-6251'           active MCC board should be installed and set up
%                           as "Dev1" using the Measurement and Automation
%                           Explorer software provided by the manufacturer.
%   'Sound Card'            Sound cards using MS Windows drivers.

% Written by TPG 27/7/2004
% Modified by PH 12/07/2006 to take into account parameter HVDAQTYPE
% Revision of HELP notes by CHL 16/02/2009
% Revision of HELP notes by CHL 20/11/2009

function [] = hvdatawin ()

global HV
global HVAI
global HVDATAPANEL

delete(HVPARAMWIN)
delete(HVCALIBRATEWIN)

if strcmp(HV.DAQTYPE,'None') %check if the acq card is selected.
       st1=('Error: No DAQ card selected (HVDAQTYPE=''None'').');
       st2=('Function hvdatawin will be aborted');
       str={st1;st2};
       errordlg(str);  
else
% open the GUI
HVDATAPANEL=HVDATAGUI;

%set the initial variables
HVDATAGUICALLBACKS(98)
        
% load parameters
HVDATAGUICALLBACKS(22); % press the 'load parameters' button

% press the set all active channels to monitor button
HVDATAGUICALLBACKS(3); 

end




