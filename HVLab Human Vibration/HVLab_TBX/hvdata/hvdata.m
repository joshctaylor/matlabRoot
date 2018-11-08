%hvdata - issue 1.3 (23/02/10) - HVLab HRV Toolbox
%-------------------------------------------------
%[indata] = hvdata(trigdelay, outdata, dsync)
% Analogue data acquisition and output according to the settings in the
% global parameter structure HV.
%
%   indata    =  new HVLab data structure containing the acquired data.
%   trigdelay = (optional) trigger mode or delay introduced before the 
%           	 start of the outout and/or acquisition:
%                trigdelay = 0: acquisition starts immediately. 
%                trigdelay > 0: acquisition starts after a delay given 
%         	                    by the value of trigdelay in s.
%                trigdelay =-1: acquisition is triggered by a falling 
%                               signal on the digital hardware trigger 
%                               input of the DAQ board. A timeout error
%                               will be produced if the trigger occurs
%                               more than 30s after launching hvdata.
%   outdata   =  (optional) HVLab data structure containing data to be
%                output. If this argument is present, HV.OUTENABLE is set
%                to 'ON'. If outdata is not present, HV.OUTENABLE is set to 
%                'OFF'. The number of data channels in this structure
%                should not exceed the number of channels available on the
%                current DAQ device (see below).
%   dsync     =  (optional) duration synchronisation flag: 
%                dsync = 0: duration of acquisition is equal to  
%                           HV.DURATION, and is independant of the duration 
%                           of the output signal.   
%                dsync = 1: (default) duration of acquisition is forced to 
%                           the duration of the output signal. 
%
%  The data acquisition device must correspond to HV.DAQTYPE:
%   'MCC PCMCIA-DAS16/16'   Measurement Computing DAQ boards - the
%   'MCC PCI-DAS6036'       active MCC board should be installed
%   'MCC PCI-DAS1602'       and set up as "Board #1" using the INSTACAL
%                           software provided by the manufacturer. The
%                           input configuration must be "16 single-ended
%                           channels."
%   'NI USB-6211'           National Instruments DAQ boards - the
%   'NI USB-6251'           active NI board should be installed and set up
%                           as "Dev1" using the Measurement and Automation
%                           Explorer software provided by the manufacturer.
%   'Sound Card'            Sound cards using MS Windows drivers.
%

% function written by CHL 09/09/2009
% function modified by CHL 19/11/2009 to fix a timeout problem with
%   triggered starts and to add more available DAQ boards
% function modified by CHL 26/01/2010 to provide a workaround for a sample 
%   shift that occurs on the 1st input channel with a hardware trigger
% function modified by CHL 24/02/2010 to provide a default option to force 
%   the input duration to that of the output signal 

function [DasIn] = hvdata(trigdelay, DasOut, dsync)

global HV
global HVDATATRANSFER
global HVAI
global HVAO

hvduration = HV.DURATION;    
if nargin == 0; trigdelay = 0; end;
if nargin < 3; dsync = 1; end; 
if nargin > 1; 
    HVDATATRANSFER.dataoutput = DasOut; 
    HV.OUTENABLE = 'ON';
    if dsync > 0
        HV.DURATION = (DasOut(1).x(2)-DasOut(1).x(1))*(length(DasOut(1).y)-1);
    end
else
    HV.OUTENABLE = 'OFF';
end
nchans = HV.INCHANNELS;
fchan = HV.FIRSTCHANNEL;

HVDAQ(3, trigdelay);    
if trigdelay < 0    
    wait(HVAI, HV.DURATION + 60); % maximum wait is 60s before timeout error
else
    wait(HVAI, HV.DURATION + 1); 
end
HV.DURATION = hvduration;    

xlimit = (HVAI.SamplesAvailable - 1) / HVAI.SampleRate;
xdata = (0: 1/HVAI.SampleRate: xlimit)';
ydata = getdata(HVAI, HVAI.SamplesAvailable);
stats = [HVAI.SampleRate, 0, 0, 0, 0, 0, 0, 0, 0];
for q = 1:nchans
	DasIn(q) = HVMAKESTRUCT([HV.DAQTYPE, ' channel ', num2str(q)], HV.UNIT, 's', 1, 0, stats, xdata);
	DasIn(q).y = ydata(:,q);
end
if trigdelay < 0
    len = length(DasIn(1).y);
    DasIn(1).y = DasIn(1).y(2:len); % drop first sample on chnl 1 to shift data
    DasIn(1).y(len) = DasIn(1).y(len-1); % make up numbers by duplicating last sample
end
return