%HVDAQ - issue 2.4 (26/01/10) - HVLab HRV Toolbox
%--------------------------------------------------
%[] = HVDAQ(daqmode, trigdelay);
% Set up and launch an acquisition according to the settings in the
% parameter structure HV and the settings derived from functions
% 'hvdatawin' and 'hvcalibrate'. 
%
% daqmode	=  the type of data acquisition: 
%               1 =	a simple monitoring process
%                   launched by 'hvcalibrate' or 'hvdatawin'  
%               2 =	an acquisition process 
%                   launched by 'hvcalibrate' or 'hvdatawin'
%               3 =	a stand-alone acquisition
%                   process launched by 'hvdata'
% trigdelay	=  the type of trigger used to start the data acquisition: 
%               0 = software (start immediately)
%              >0 = software (start after delay given by value of trigdelay 
%                   in s)
%              -1 = hardware (start when digital trigger input goes low)
%
% Settings related to specific data acquisition devices are defined in 
% this function. The data acquisition device is set by by HV.DAQTYPE:
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
%

% Written by Pierre HUGUENET, July 2006
% Modified by Chris LEWIS to revise HV.DAQTYPE definitions, remove controls
%   for abandoned signal conditioning and add hardware triggering, Feb 2009
% Modified by Chris LEWIS to fix problem not allowing < 2 output channels 
%   for and to add more DAQ board types, Nov 2009
% Modified by Chris LEWIS (26/01/2010) to force ChannelSkewMode to Minimum 
%   for software trigger and Equisample for hardware trigger, so as to cure
%   sampling delay problems experienced with MCC under software triggering 
%   and NI under hardware triggering

function HVDAQ(daqmode, trigmode)

    global HV
    global HVAI
    global HVAO
    global HVDATATRANSFER
    
    if nargin < 2; trigmode = 0; end
    if strcmp(HV.DAQTYPE,'none')
      	str = {'DATA ACQUISITION CANCELLED';
               'DAQ device not selected!'};
        errordlg(str);
        return 
    end
   
    % maximum channels and daqtypes for supported interface cards
	daqtype = 'winsound';  % defaults to windows sound card
 	inchannels = 2; 
	outchannels = 0; 
    if strcmp(HV.DAQTYPE, 'NI USB-6211') 
        daqtype = 'ni-daq';
        inchannels = 16;
        outchannels = 2;
    end
    if strcmp(HV.DAQTYPE, 'NI USB-6251') 
        daqtype = 'ni-daq';
        inchannels = 16;
        outchannels = 2;
    end
    if strcmp(HV.DAQTYPE, 'MCC PCMCIA-DAS16/16')
        daqtype = 'mcc'; 
        inchannels = 16;
        outchannels = 0;
        if trigmode < 0
            errordlg('Hardware trigger not supported on DAS16/16 card');
            return 
        end
        if strcmp(HV.OUTENABLE, 'ON')
            errordlg('Outputs are not supported on DAS16/16 card');
            return 
        end
    end
	if strcmp(HV.DAQTYPE, 'MCC PCI-DAS6036')
        daqtype = 'mcc'; 
    	inchannels = 16;
        outchannels = 2;
        if trigmode < 0
            errordlg('Hardware trigger not supported on DAS6036 card');
            return 
        end
  	end
	if strcmp(HV.DAQTYPE, 'MCC PCI-DAS1602')
        daqtype = 'mcc'; 
    	inchannels = 16;
        outchannels = 2;
        if trigmode < 0
            errordlg('Hardware trigger not supported on DAS1602 card');
            return 
        end
  	end
    if strcmp(HV.DAQTYPE, 'Sound Card')
        daqtype = 'winsound';
        inchannels = 2;
        outchannels = 0;
        if trigmode < 0
            errordlg('Hardware trigger not supported on sound cards');
            return 
        end
        if strcmp(HV.OUTENABLE, 'ON')
            errordlg('Outputs are not supported on sound cards');
            return 
        end
    end

    if daqmode > 1; HVFUNPAR(['DATA ACQUISITION using ' daqtype, ' analogue interface']); end

%---------------------PARAMETERS ------------------------------------------
    %Input parameters
    nchans = HV.INCHANNELS;
    fchan = HV.FIRSTCHANNEL;
    targetsrate = 1./HV.TINCREMENT;
    %Output parameters
    if strcmp(HV.OUTENABLE,'ON') && daqmode > 1 % i.e. if output is enabled
        dataoutput = HVDATATRANSFER.dataoutput;
        %nochans = size(dataoutput, 2); 
        outincr = dataoutput(1).x(2) - dataoutput(1).x(1);
        outsrate = 1./outincr;
    end
    
%---------------------ANALOG INPUT/OUTPUT Object Creation -----------------
    errdaqtype = 1;      
    if strcmp(daqtype,'mcc') 
        HVAI = analoginput('mcc',1); % creating analog input object
        flushdata(HVAI);
        if strcmp(HV.OUTENABLE,'ON'); HVAO = analogoutput('mcc',1); end % creating analog output object
        errdaqtype = 0;  
    end        
    if strcmp(daqtype,'ni-daq')            
      	HVAI = analoginput('nidaq','Dev1'); % creating analog input object
       	HVAI.InputType = 'SingleEnded';
      	flushdata(HVAI);           
      	if strcmp(HV.OUTENABLE,'ON'); HVAO = analogoutput('nidaq','Dev1'); end % creating analog output object
      	errdaqtype = 0;  
    end   
    if strcmp(daqtype,'winsound')
        HVAI = analoginput('winsound'); % creating analog input object
      	flushdata(HVAI);
       	errdaqtype = 0;
    end
    if errdaqtype == 1
    	HVFUNPAR('Indicated DAQ device is not yet supported');
      	HVFUNPAR('DATA ACQUISITION CANCELLED'); 
        if daqmode < 3
            str = {'Warning: inappropriate DAQ device settings for this operation';
                   'DATA ACQUISITION CANCELLED'};
            errordlg(str);
        end
        return         
    end
            
%---------------------ACQUISITION (ANALOG INPUT) SETTINGS------------------
    if daqmode == 1 %for monitoring
    
        % set for a maximum of 512*2048 samples
        duration=512.*2048./(nchans.*targetsrate);
        % set the 'STOP' function to repeat continuously
        set(HVAI,'StopFcn','HVDAQ(1)');
        % set the HVAI.userdata property to indicate that the data should
        % NOT be stored
        userdata=HVAI.userdata;
        userdata.store=0;
        HVAI.userdata=userdata;
            for q=1:16
             addchannel(HVAI,q-1,HV.INCHANNEL(q).DESCRIPTION);
            end
        % set the channel units, range and voltage
        %hwchan=1:16;
            for q=1:16
                HVAI.channel(q).units=HV.INCHANNEL(q).UNIT;
                rng=HV.INCHANNEL(q).RANGE;
                HVAI.channel(q).unitsrange=[-rng,rng];
                vrng=HV.INCHANNEL(q).VOLTAGE;
                HVAI.channel(q).inputrange=[-vrng,vrng];
                HVAI.channel(q).sensorrange=[-vrng,vrng];
            end

    else %for an acquisition
    
        duration=HV.DURATION;   
        % set the 'STOP' function
        if daqmode == 2; 
            set(HVAI,'StopFcn','HVDATAGUICALLBACKS(7)'); %set callback for "hvdatawin"
        end
        % set the HVAI.userdata property to indicate that the data should be stored
        userdata=HVAI.userdata;
        userdata.store=1; % store the data on STOP
        userdata.break=0; % allow continuous running
        HVAI.userdata=userdata;
        %create the number of input channels specified in HV.INCHANNELS                       
            for q=fchan:(fchan+nchans-1)
                 addchannel(HVAI,q-1,HV.INCHANNEL(q).DESCRIPTION);
            end 
        %set the channel units, range and voltage
        %hwchan=fchan:(fchan+nchans-1);
            for q=1:nchans
                HVAI.channel(q).units = HV.INCHANNEL(q).UNIT;
                rng = HV.INCHANNEL(q).RANGE;
                HVAI.channel(q).unitsrange = [-rng,rng];
                vrng = HV.INCHANNEL(q).VOLTAGE;
                HVAI.channel(q).inputrange = [-vrng,vrng];
                HVAI.channel(q).sensorrange = [-vrng,vrng];
            end
    end 

    HVAI.BufferingMode = 'auto';  % set the buffering configuration
    HVAI.LoggingMode = 'Memory';  % set the logging mode
    HVAI.ChannelSkewMode = 'Minimum'; 

    HVAI.SampleRate = targetsrate; % set the sampling rate
    insrate = HVAI.SampleRate;
    if daqmode > 1; 
        HVFUNPAR('no. of input channels', nchans);
        HVFUNPAR('input sample rate', insrate, 'Hz');
        HVFUNPAR('input duration', duration, 's');
        %if insrate ~= targetsrate
        %	HVFUNPAR('WARNING: actual input rate differs from target rate');
        %end
    end

%---------------WAVEFORM GENERATION (ANALOG OUTPUT) SETTINGS---------------

    if strcmp(HV.OUTENABLE,'ON') && daqmode > 1 
        
        if outchannels == 0
            errordlg('Outputs are not supported on this device');
            return;
        end
            
        nochans = min(length(dataoutput), outchannels);
        HVFUNPAR('no. of output channels', nochans);
        for q = 1:nochans
            chan = addchannel(HVAO, q-1, dataoutput(1,q).title);
            data(:,q) = dataoutput(q).y;
            outsamples(q) = length(dataoutput(q).y);
        end
   
        set(chan,'OutputRange',[-10 10])
        set(chan,'UnitsRange',[-10 10])
        HVAO.SampleRate = outsrate;
        HVFUNPAR('output sample rate', HVAO.SampleRate, 'Hz');
        HVFUNPAR('output duration', (max(outsamples)-1)/HVAO.SampleRate, 's');

        %Queue the data with one call to putdata. 
        putdata(HVAO,data);
        
    end

%----------------------TRIGGERING/STARTING THE ACQUISITION-----------------
	
    if daqmode == 1 %for monitoring

        HVAI.TriggerType = 'Immediate';
        HVAI.SamplesPerTrigger = fix(duration.*insrate);
        start(HVAI)
        tic; % launch the clock        

    else % for data acquisition and/or output
            
        if strcmp(daqtype,'mcc')
            HVAI.SamplesPerTrigger = fix(duration.*insrate);
            if trigmode >= 0
                if strcmp(HV.OUTENABLE,'OFF')
                    set(HVAI, 'TriggerType', 'Immediate');
                    if trigmode > 0
                        HVFUNPAR('waiting: start delay', trigmode, 's')
                        pause(trigmode)
                        HVFUNPAR('data acquisition in progress')
                    end
                    start(HVAI);
                else
                    set([HVAI HVAO], 'TriggerType', 'Manual');
                    start([HVAI HVAO]);
                    if trigmode > 0
                        HVFUNPAR('waiting: start delay', trigmode, 's')
                        pause(trigmode)
                        HVFUNPAR('data acquisition in progress')
                    end
                    trigger([HVAI HVAO]);
                end
            else
                if strcmp(HV.OUTENABLE,'OFF')
                    set(HVAI, 'TriggerType', 'HwDigital'); % set MCC hardware trigger
                    set(HVAI, 'TriggerCondition', 'TrigNegEdge'); %alt setting is 'TrigPosEdge'
                    start(HVAI);
                else
                    HVFUNPAR('output trigger not supported on MCC devices');
                    HVFUNPAR('DATA ACQUISITION CANCELLED');
                	errdaqtype = 0;
                 end
            end
        end

        if strcmp(daqtype,'ni-daq')
            HVAI.SamplesPerTrigger = fix(duration.*insrate);
            if trigmode >= 0
                if strcmp(HV.OUTENABLE,'OFF')
                    set(HVAI, 'TriggerType', 'Immediate');
                    if trigmode > 0
                        HVFUNPAR('waiting: start delay', trigmode, 's')
                        pause(trigmode)
                        HVFUNPAR('data acquisition in progress')
                    end
                    start(HVAI);
                else
                    set([HVAI HVAO], 'TriggerType', 'Manual');
                    start([HVAI HVAO]);
                    if trigmode > 0
                        HVFUNPAR('waiting: start delay', trigmode, 's')
                        pause(trigmode)
                        HVFUNPAR('data acquisition in progress')
                    end
                    trigger([HVAI HVAO]);
                end
            else
                if strcmp(HV.OUTENABLE,'OFF')
                    set(HVAI, 'TriggerType', 'HwDigital'); % set NI hardware trigger
                    set(HVAI, 'TriggerCondition', 'NegativeEdge'); % alt 'PositiveEdge'
                    set(HVAI, 'HwDigitalTriggerSource', 'PFI0'); % alt 'PFI0' to 'PFI15'
                    start(HVAI);
                else
                    HVAI.ChannelSkewMode = 'Equisample'; % needed for flat TF between input channels! 
                    set([HVAI HVAO], 'TriggerType', 'HwDigital'); % to set NI hardware trigger
                    set([HVAI HVAO], 'TriggerCondition', 'NegativeEdge'); % alt 'PositiveEdge'
                    set([HVAI HVAO], 'HwDigitalTriggerSource', 'PFI0'); % alt 'PFI0' to 'PFI15'
                    start([HVAI HVAO]);
                end
            end
        end

        if strcmp(daqtype,'winsound')
            HVAI.SamplesPerTrigger = fix(duration.*insrate);
        	if trigmode >= 0
               	if strcmp(HV.OUTENABLE,'OFF')
                  	set(HVAI, 'TriggerType', 'Immediate');
                    if trigmode > 0
                        HVFUNPAR('waiting: start delay', trigmode, 's')
                        pause(trigmode)
                        HVFUNPAR('data acquisition in progress')
                    end
                 	start(HVAI);
                else
                  	HVFUNPAR('Outputs not supported on sound cards');
                  	HVFUNPAR('DATA ACQUISITION CANCELLED');
                    errdaqtype = 0;
                end
            else
                    HVFUNPAR('Hardware trigger not supported on sound cards');
                    HVFUNPAR('DATA ACQUISITION CANCELLED');
                    errdaqtype = 0;
            end
        end
        
  	tic; %launch the clock
    end
    
    if errdaqtype == 1
        if daqmode < 3
            str = {'Warning: inappropriate DAQ device settings for this operation';
                   'DATA ACQUISITION CANCELLED'};
            errordlg(str);
        end
        return
    end
return
    
