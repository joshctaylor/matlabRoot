% HVDATAGUICALLBACKS - issue 3.0 (16/02/2009) - HVLab HRV Toolbox
%----------------------------------------------------------------
% function [] = HVDATAGUICALLBACKS(index);
%
% Function used to run callbacks for HVDATAGUI, where 'nb' is the index
% referring to the callback. This function is only called from function
% 'hvdatawin' and within the property inspector of HVDATAGUI.fig

% Written by TPG 27/7/2004
% Modified and documented by TPG 12/10/2004
% Modified to Beta 0.3 by TPG 9/11/2004
% Modified to issue 2.0 by PH 12/07/2006
% Modified to issue 3.0 by CHL 16/02/2009

% index:
% 1: nchans / firstchannel
% 2: srate
% 3: scope activemonitoracq
% 5: scope on/off
% 6: START DAQ
% 7: On DAQ STOP
% 8: STOP
% 9: DAQ RUNNING code
% 10 : timebase down
% 11 : timebase up
% 12-16: monitor mean/rms/min/max/abs options (see also 25)
% 17:  START monitors  DAQ
% 18 : ABORT run
% 19 : apply to all
% 20 : display previous dataset
% 21 : save description parameters
% 22 : set parameters
% 23 : lock controls
% 24 : unlock controls
% 25 : monitor abs option
% 26 : SET the DAQ
% 27 : Save the data.
% 28 : Close the popup
% 29 : Scope range to zero click
% 30 : Clear monitors on select click
% 31 : Clear overrange lights
% 32 : Scope range reset
% 33 : Button select output Data
% 34 : Checkbox to select output channel 1/2/3/4 to monitor
% 35 : Button data storage location
% 36 : Checkbox Divide data
% 98 : Opening function
% 99 : Closefcn

%--------------------------------------------------------------------------

function [] = HVDATAGUICALLBACKS(index);

global HVAI
global HVAO
global HV
global HVDATAPANEL
global HVDATAPOPUP
global HVDATASAMPLECOUNTER
global HVDATATRANSFER

% get all child handles
c = allchild(HVDATAPANEL);

switch index
%--------------------------------------------------------------------------
    case 1 % nchans box and firstchannel list

        nchans = HV.INCHANNELS;
        fchan = HV.FIRSTCHANNEL;

        % check for maximum number of channels and limit nchans
        if fchan+nchans > 17
            nchans = 16-fchan+1;
            set(findobj(c,'Tag','nchans'),'Value',nchans);
        end

        % set enable flags
        for q=1:16
            if sum(q==(fchan:(fchan+nchans-1)));
                %  set(findobj(c,'Tag',['ch',num2str(q),'enable']),'String','
                %  ON');
                set(findobj(c,'Tag',['ch',num2str(q),'enable']),'Backgroundcolor',[0,1,0]);
            else
                % set(findobj(c,'Tag',['ch',num2str(q),'enable']),'String','OFF');
                set(findobj(c,'Tag',['ch',num2str(q),'enable']),'Backgroundcolor',[0.8,0.8,0.8]);
            end
        end % for q


        % set the scope channel flags
        HVDATAGUICALLBACKS(3);
%--------------------------------------------------------------------------
    case 2 % sampling rate

        % reset monitor timebase to 1 second
        set(findobj(c,'Tag','time'),'string','1');
        bcol=get(findobj(c,'Tag','time'),'backgroundcolor');
        set(findobj(c,'Tag','time'),'backgroundcolor',[1,0,0]);
        pause(0.1)
        set(findobj(c,'Tag','time'),'backgroundcolor',bcol);
%--------------------------------------------------------------------------
    case 3 % scope active
        
        nchans=HV.INCHANNELS;
        fchan=HV.FIRSTCHANNEL;

        % set scope flags
        for q=1:16
            if sum(q==fchan:(fchan+nchans-1))
                set(findobj(c,'Tag',['ch',num2str(q),'scope']),'Value',1);
            else
                set(findobj(c,'Tag',['ch',num2str(q),'scope']),'Value',0);
            end
            set(findobj(c,'Tag',['ch',num2str(q),'mon']),'String','');
        end % for q
%--------------------------------------------------------------------------
    case 4 % scope none

        % turn on scope flags
        for q=1:16
            set(findobj(c,'Tag',['ch',num2str(q),'scope']),'Value',0);
            set(findobj(c,'Tag',['ch',num2str(q),'mon']),'String','');
        end % for q
%--------------------------------------------------------------------------
    case 5 % scope on/off

        % set state
        scopestate=get(findobj(c,'Tag','scopeon'),'Value');
        if scopestate==0
            % ABORT the DAQ.
            set(HVAI,'StopFcn','HVDATAGUICALLBACKS(7)');
            userdata=HVAI.userdata;
            userdata.store=0; % flag to store the data
            userdata.break=1; % flag to stop continuous running if necessary
            HVAI.userdata=userdata;
            stop(HVAI) % stop the object, automatically calling the designated stop function.

        elseif scopestate==1
            %clear the monitor boxes
            for q=1:16
                set(findobj(c,'Tag',['ch',num2str(q),'mon']),'String','');
            end
            % start the DAQ
            HVDATAGUICALLBACKS(17)
        end
%--------------------------------------------------------------------------
    case 26 % set the DAQ

 if isequal(HVDATATRANSFER.saveflag,1) && isequal(HVDATATRANSFER.outflag,1)  %if a file has been selected for saving data     
        set(findobj(c,'Tag','status'),'string','Preparing to input/output data');

        % press stop if the scope is running
        if exist('HVAI.Running')
            %if size(HVAI)>0
                runstate=HVAI.Running;
                if lower(runstate(1:2))=='on'
                    set(findobj(c,'Tag','scopeon'),'Value',0);
                    HVDATAGUICALLBACKS(5)
                end
            %end
        end

        % check for the filename
        fileinuse=0;
        currdir=cd;
        directory1=HVDATATRANSFER.savedirectory;
        eval(['cd ''',directory1,'''']);
        existfiles=dir;
        eval(['cd ''',currdir,'''']);

        posdot=strfind(HVDATATRANSFER.savefilename,'.');
        datfile=HVDATATRANSFER.savefilename(1:posdot-1);
        datraw=datfile;
        filext='.das';
        if iscell(datraw)
            datfile=[cell2mat(get(findobj(c,'Tag','datfile'),'String')),filext];
        else
            datfile=[datraw,filext];
        end

        % check filename
        fileinuse=0; % initialise flags
        warnstring={};
        warnstrindex=1;

        % check if segment syntax has been used for the filename
        if strfind(datfile,'__')>0;
            warnstring(warnstrindex)={['TEST ABORTED: The use of ''__'' is reserverd for file segment names. Please use a different file name.']};
            warnstrindex=warnstrindex+1;
            fileinuse=1; % flag to abort the test
            set(findobj(c,'Tag','status'),'string','Input/output not running');
        else
            % check for incrementing filename and initialise if appropriate
            if get(findobj(c,'Tag','fileinc'),'value')
                incsep=strfind(datfile,'ACQ');
                if length(incsep)==0
                    % assemble the new filename
                    datfile=[datfile(1:end-4),'ACQ1.das'];
                    % add to the GUI excluding the extension
                    namedatasave=sprintf('%s%s',HVDATATRANSFER.savedirectory,datfile);
                    set(findobj(c,'Tag','datfile'),'String',namedatasave)
                    % display filename in the warning window
                    warnstring(warnstrindex)={['WARNING: The data will be saved to ''',datfile,''' and the filename will be incremented when the data is saved.']};
                    warnstrindex=warnstrindex+1;
                elseif length(incsep)>1; % check if ACQ is used more than once
                    warnstring(warnstrindex)={['TEST ABORTED: The use of ''ACQ'' is reserverd for incrementing the file name. Please use a different file name or change the case.']};
                    warnstrindex=warnstrindex+1;
                    fileinuse=1; % flag to abort the test
                    set(findobj(c,'Tag','status'),'string','Input/output not running');
                else % check if the correct syntax is in use
                    incfilenum=str2num(datfile(incsep+3:end-4))
                    if length(incfilenum)==0
                        warnstring(warnstrindex)={['TEST ABORTED: The use of ''ACQ'' is reserverd for incrementing the file name. Please use a different file name or change the case.']};
                        warnstrindex=warnstrindex+1;
                        fileinuse=1; % flag to abort the test
                        set(findobj(c,'Tag','status'),'string','Input/output not running');
                    else % check for redundant zeros and remove
                        rawnum=datfile(incsep+3:end-4);
                        strippednum=num2str(str2num(rawnum));
                        if length(rawnum)~=length(strippednum)
                            % assemble the new filename
                            datfile=[datfile(1:incsep+2),num2str(str2num(datfile(incsep+3:end-4))),'.das'];
                            % add to the GUI excluding the extension                      
                            namedatasave=sprintf('%s%s',HVDATATRANSFER.savedirectory,datfile);
                            set(findobj(c,'Tag','datfile'),'String',namedatasave)
                            % display filename in the warning window
                            warnstring(warnstrindex)={['WARNING: Redundant zeros removed. The data will be saved to ''',datfile,'''']};
                            warnstrindex=warnstrindex+1;
                        end % if length(datfile...
                    end % if length(incfilenum)==0
                end % if length(incsep)=1
            end % if get(findobj(c,'Tag','fileinc'),'value')


            
            % check if the file already exists and warn appropriately
            for q=1:length(existfiles)
                switch datfile
                    case deblank(existfiles(q).name)
                        if get(findobj(c,'Tag','overwrite'),'Value');
                            warnstring(warnstrindex)={['WARNING: The file ''',datfile,''' will be overwritten.']};
                            warnstrindex=warnstrindex+1;
                        else % if 'overwrite'
                            warnstring(warnstrindex)={['TEST ABORTED: The file ''',datfile,''' already exists.']};
                            warnstrindex=warnstrindex+1;
                            set(findobj(c,'Tag','status'),'string','Input/output not running');
                            fileinuse=1; % flag to abort the test
                            %set(findobj(c,'Tag','datfile'),'Enable','On');
                        end % if 'overwrite'

                end % switch datfile
            end % for q
        end % if strfind(datfile,'__')>0;


        % check for segmented file use, set the 'filename increment' flag if necessary and generate warnings
        if fileinuse==0;
            if length(get(findobj(c,'Tag','chlen'),'String'))>0
                if str2num(get(findobj(c,'Tag','chlen'),'String'))>0
                    if strfind(datfile,'__')>0;
                        datstr=datfile(1:strfind(datfile,'__')-1);
                        
                    else
                        datstr=datfile(1:end-4);
                        
                    end
                    if get(findobj(c,'Tag','overwrite'),'Value');
                        warnstring(warnstrindex)={['WARNING: Files ''',datstr,'__nn'' may be overwritten']};
                        warnstrindex=warnstrindex+1;
                    else % if 'overwrite'
                        warnstring(warnstrindex)={['WARNING: Tests may stop if a file ''',datstr,'__nn'' already exists']};
                        warnstrindex=warnstrindex+1;
                    end % if 'overwrite
                end % if str2num(get(findobj(c,'Tag','chlen'),'String'))>0
            end % if length(get(findobj(c,'Tag','chlen'),'String'))>0
        end % if fileinuse



          if length(warnstring)>0;
          ST=sprintf('%c',char(warnstring));
          errordlg(ST);
          uiwait
          end
          
        if fileinuse==0;

            set(findobj(c,'Tag','OPERATE'),'Enable','Off');
            drawnow

            duration = HV.DURATION;

            % display the effective buffer size. This is the actal buffer
            % size or the segment length if segmented file storing is in
            % use.
            if and (length(get(findobj(c,'Tag','chlen'),'String'))>0, str2num(get(findobj(c,'Tag','chlen'),'String'))>0)
                set(findobj(c,'Tag','buffersize'),'String',[get(findobj(c,'Tag','chlen'),'String'),' s']);
            else
                set(findobj(c,'Tag','buffersize'),'String',[num2str(duration),' s']);
            end


            % clear overrange warning lights

            for q=1:16%fchan:(fchan+nchans-1)
                set(findobj(c,'Tag',['ch',num2str(q),'or']),'Backgroundcolor',[0.8,0.8,0.8]);
            end

            % lock controls
            HVDATAGUICALLBACKS(23)
            set(findobj(c,'Tag','scopeon'),'value',0);
            set(findobj(c,'Tag','scopeon'),'Enable','inactive');
            set(findobj(c,'Tag','scopeon'),'Callback','');
            drawnow

            % wait for the system to settle
            pause(1)

            set(findobj(c,'Tag','status'),'string','Ready to start');
            set(findobj(c,'Tag','OPERATE'),'String','START');
            set(findobj(c,'Tag','OPERATE'),'Enable','On');
            set(findobj(c,'Tag','OPERATE'),'Value',0);
            set(findobj(c,'Tag','STOP'),'String','ABORT');
            set(findobj(c,'Tag','STOP'),'Enable','On');
            drawnow
            set(findobj(c,'Tag','OPERATE'),'Callback','HVDATAGUICALLBACKS(6)');
            set(findobj(c,'Tag','STOP'),'Callback','HVDATAGUICALLBACKS(18)');

        end % if fileinuse
        
    HVDATATRANSFER.savefilename=datfile;

 elseif isequal(HVDATATRANSFER.saveflag,0) %if HVDATATRANSFER.saveflag == 1  if no file has been selected for saving data
      ST={'Warning: no file selected to save the data.';
      'Please select a save file in ''Data storage location'' '};
      errordlg(ST);
      uiwait
 elseif isequal(HVDATATRANSFER.outflag,0)
      ST={'Warning: no file selected for data output.';
      'Please select an output file in ''Output Channels'' '};
      errordlg(ST);
      uiwait     
     
 end %if HVDATATRANSFER.saveflag == 1
%--------------------------------------------------------------------------
    case 6 % START

        % wait if a delay is defined

        if length(get(findobj(c,'Tag','delay'),'String'))>0 %check something is in the box
            if str2num(get(findobj(c,'Tag','delay'),'String'))>0 %check it is a positive value
                set(findobj(c,'Tag','OPERATE'),'String','DELAYING');
                set(findobj(c,'Tag','OPERATE'),'Enable','Off');
                set(findobj(c,'Tag','STOP'),'String','DELAYING');
                set(findobj(c,'Tag','STOP'),'Enable','Off');
                pause(str2num(get(findobj(c,'Tag','delay'),'String')));
            end
        end

        % reset the scope range
        %set(findobj(c,'Tag','scope'),'ylim',[-1,1]);
        scopeuserdata.reset=1;
        set(findobj(c,'Tag','scope'),'userdata',scopeuserdata);


        %launch the acquisition
        HVDAQ(2)

        set(findobj(c,'Tag','status'),'string','Input/output running');

        % reset the sample counter
        HVDATASAMPLECOUNTER=0;

        % close the pop up window if it is open
        HVDATAPOPUP=HVDATA_WARNING;
        close(HVDATAPOPUP);
        HVDATAPOPUP=[];

        % toggle the operate, stop and scope buttons
        set(findobj(c,'Tag','OPERATE'),'String','RUNNING');
        set(findobj(c,'Tag','OPERATE'),'Value',1);
        set(findobj(c,'Tag','OPERATE'),'Enable','Off');
        set(findobj(c,'Tag','STOP'),'String','STOP');
        set(findobj(c,'Tag','STOP'),'Enable','On');
        set(findobj(c,'Tag','STOP'),'Callback','HVDATAGUICALLBACKS(8)');
        set(findobj(c,'Tag','scopeon'),'Enable','Inactive');
        set(findobj(c,'Tag','scopeon'),'value',1);
        drawnow

        % run the scope and monitor controls
        %  if get(findobj(c,'Tag','scopeon'),'value');
        HVDATAGUICALLBACKS(9)
        % end

%--------------------------------------------------------------------------
    case 7

        % store the data: runs on analogue input STOP.

        % unlock the controls
        userdata=HVAI.userdata;
        HVDATAGUICALLBACKS(24)
        set(findobj(c,'Tag','status'),'string','Input/output not running');
        set(findobj(c,'Tag','OPERATE'),'String','INITIALISE');
        set(findobj(c,'Tag','OPERATE'),'Enable','On');
        set(findobj(c,'Tag','OPERATE'),'Value',0);
        set(findobj(c,'Tag','OPERATE'),'Callback','HVDATAGUICALLBACKS(26)');
        set(findobj(c,'Tag','STOP'),'Enable','Off');
        set(findobj(c,'Tag','scopeon'),'Enable','on');
        set(findobj(c,'Tag','scopeon'),'Callback','HVDATAGUICALLBACKS(5)');
        set(findobj(c,'Tag','scopeon'),'Value',0);

        % check if data is to be stored
        if userdata.store
            userdata.chunk=-1; % flag to store the data
            HVAI.userdata=userdata;
            HVDATAGUICALLBACKS(27)
        end % if userdata.store
%--------------------------------------------------------------------------
    case 8 % STOP
        % toggle the OPERATE button
        %         set(findobj(c,'Tag','OPERATE'),'String','INITIALISE');
        %         set(findobj(c,'Tag','OPERATE'),'Value',0);
        %         set(findobj(c,'Tag','OPERATE'),'Foregroundcolor',[0,0.5,0]);
        %         set(findobj(c,'Tag','OPERATE'),'Enable','On');
        %         set(findobj(c,'Tag','STOP'),'Enable','Off');
        %         drawnow
        %         set(findobj(c,'Tag','OPERATE'),'Callback','HVDATAGUICALLBACKS(26)');

        % set the HVAI 'stop' function
        set(HVAI,'StopFcn','HVDATAGUICALLBACKS(7)');
        set(findobj(c,'Tag','datfile'),'Enable','inactive');
        userdata=HVAI.userdata;
        userdata.store=1;
        %get(findobj(c,'Tag','savestop'),'Value');; % flag to store the data
        userdata.break=1; % flag to stop continuous running if necessary
        HVAI.userdata=userdata;
        stop(HVAI) % stop the object, automatically calling the designated stop function.
        
        if strcmp(HV.OUTENABLE,'ON') 
        stop(HVAO)
        end

%--------------------------------------------------------------------------
    case 9 % scope, monitors and call store segment data

        % run the scope and monitors if desired

        % Run the scope while data is being acquired
        runstate = HVAI.logging;
        while lower(runstate(1:2))=='on'

            % check if 'run while acquiring' is enabled or scope is
            % switched on.
            if get(findobj(c,'Tag','scopeon'),'value');
                % get the sampling rate, number of channels and time range
                
                nchans = HV.INCHANNELS;
                fchan = HV.FIRSTCHANNEL;
                srate = 1./HV.TINCREMENT;
                duration = HV.DURATION;  
                ptime = str2num(get(findobj(c,'Tag','time'),'String'));


                % the number of samples available to get, up to the user specified limit
                sampstoget = floor(srate.*ptime);
                [nsamps,nind] = min([sampstoget,HVAI.SamplesAvailable]);

                % display the actual time used for the averaging
                set(findobj(c,'Tag','atime'),'string',['(',num2str(nsamps./srate),')']);
                switch nind
                    case 1
                        set(findobj(c,'Tag','timedown'),'backgroundcolor',[0,1,0]);
                        set(findobj(c,'Tag','timeup'),'backgroundcolor',[0,1,0]);
                    case 2
                        set(findobj(c,'Tag','timedown'),'backgroundcolor',[1,1,0]);
                        set(findobj(c,'Tag','timeup'),'backgroundcolor',[1,1,0]);
                end


                % get the data
                scopedata=peekdata(HVAI,nsamps);

                % select the axis, clear it and set the time axis range
                 axes(findobj(c,'Tag','scope'));
                 cla;
                %set(HVDATAGUI,'CurrentAxes',findobj(c,'Tag','scope'));
                set(findobj(c,'Tag','scope'),'xlim',[0,ptime]);
                set(get(findobj(c,'Tag','scope'),'xlabel'),'string','Time (s)')
                HVDATATRANSFER.axesflag = 1;
            
            
                hwchan=fchan:(fchan+nchans-1);

                % counter used to cycle the line colours
                colcount=1;
                for q=1:nchans
                    % check if line is set to be plotted
                    if get(findobj(c,'Tag',['ch',num2str(hwchan(q)),'scope']),'value');
                        % check if there is any data to display
                        if length(scopedata(:,q))>0;
                            % extract the data for each line
                            linedata=scopedata(:,q);
                            % calculate the mean/rms/max/min/absmax
                            if get(findobj(c,'Tag','smean'),'value');
                                mdata=mean(linedata);
                            elseif get(findobj(c,'Tag','srms'),'value');
                                mdata=std(linedata);
                            elseif get(findobj(c,'Tag','smax'),'value');
                                mdata=max(linedata);
                            elseif get(findobj(c,'Tag','smin'),'value');
                                mdata=min(linedata);
                            elseif get(findobj(c,'Tag','samax'),'value');
                                mdata=max(linedata)-min(linedata);
                            elseif get(findobj(c,'Tag','sabs'),'value');
                                mdata=max(abs(linedata));
                            end

                            % check for overrange
                            switch get(findobj(c,'Tag',['ch',num2str(hwchan(q)),'v']),'Value');
                                case 4
                                    vrng=1.25;
                                case 3
                                    vrng=2.5;
                                case 2
                                    vrng=5;
                                case 1
                                    vrng=10;
                            end
                            range=str2num(get(findobj(c,'Tag',['ch',num2str(hwchan(q)),'range']),'String'));
                            if(max(abs(linedata./range.*vrng)))>=vrng;
                                set(findobj(c,'Tag',['ch',num2str(hwchan(q)),'or']),'Backgroundcolor',[1,0,0]);
                            else
                                % lock the warning light if this is an
                                % acquisition rather than a monitor
                                %if get(findobj(c,'Tag','scopeon'),'Value');
                                %    set(findobj(c,'Tag',['ch',num2str(hwchan(q)),'or']),'Backgroundcolor',[0.8,0.8,0.8]);
                                %end
                            end


                            % display the mean/rms/max/min/absmax
                            set(findobj(c,'Tag',['ch',num2str(hwchan(q)),'mon']),'string',num2str(mdata));


                            % decimate the data if necessary to get a
                            % maximum of 2000 displayed samples
                            maxsamples=2000;
                            samplestodisplay=length(linedata);
                            if samplestodisplay>maxsamples
                                dfact=round(samplestodisplay./maxsamples);
                                linedata=decimate(linedata,dfact);
                            else
                                dfact=1;
                            end % if samplestodisplay>maxsamples

                            % generate a timebase
                            tbase=([1:length(linedata(:,1))]./(srate./dfact))';

                            % check the y-axis limits
                            scopeuserdata=get(findobj(c,'Tag','scope'),'userdata');
                            % if this is the first line, set to the line range
                            if scopeuserdata.reset==1;
                                ylims(1)=min(linedata);
                                ylims(2)=max(linedata);

                                % limit about zero.
                                if get(findobj(c,'Tag','lockzero'),'value');
                                    if ylims(1)>0
                                        ylims(1)=0;
                                    end
                                    if ylims(2)<0
                                        ylims(2)=0;
                                    end
                                end

                                % check for zero axis ranges
                                if ylims(1)==ylims(2)
                                    if abs(ylims(1))>0
                                        trimval=ylims(1).*0.1;
                                    else
                                        trimval=0.1;
                                    end
                                else
                                    trimval=(ylims(2)-ylims(1)).*0.1;
                                end

                                % set an extra bit on the visible range
                                ylims(1)=ylims(1)-trimval;
                                ylims(2)=ylims(2)+trimval;

                                scopeuserdata.reset=0;
                                set(findobj(c,'Tag','scope'),'userdata',scopeuserdata);
                                % otherwise adjust ranges if necessary
                            else
                                ylims=get(findobj(c,'Tag','scope'),'ylim');
                                trimrange=0;
                                if max(linedata)>ylims(2)
                                    ylims(2)=max(linedata);
                                    trimrange=1;
                                end
                                if min(linedata)<ylims(1)
                                    ylims(1)=min(linedata);
                                    trimrange=1;
                                end
                                if trimrange==1
                                    trimval=(ylims(2)-ylims(1)).*0.1;
                                    ylims(1)=ylims(1)-trimval;
                                    ylims(2)=ylims(2)+trimval;
                                end
                            end
                            set(findobj(c,'Tag','scope'),'ylim',ylims);

                            % plot the line
                            lineh=line(tbase,linedata);

                            % set line color
                            switch colcount
                                case 1
                                    set(lineh,'color',[0,0,0]);
                                    set(findobj(c,'Tag',['ch',num2str(hwchan(q)),'mon']),'ForegroundColor',[0,0,0]);
                                case 2
                                    set(lineh,'color',[1,0,0]);
                                    set(findobj(c,'Tag',['ch',num2str(hwchan(q)),'mon']),'ForegroundColor',[1,0,0]);
                                case 3
                                    set(lineh,'color',[0,0,1]);
                                    set(findobj(c,'Tag',['ch',num2str(hwchan(q)),'mon']),'ForegroundColor',[0,0,1]);
                                case 4
                                    set(lineh,'color',[0,0.7,0]);
                                    set(findobj(c,'Tag',['ch',num2str(hwchan(q)),'mon']),'ForegroundColor',[0,0.7,0]);
                                    colcount=0;
                            end % case colcount
                            colcount=colcount+1;

                        end
                    end
                end %  for q=fchan:

                % display clock
                ttoc=toc;
                set(findobj(c,'Tag','clock'),'string',[num2str(round(ttoc)),' s']);
                drawnow

            end %     if get(findobj(c,'Tag','scopeon'),'value');


            % keep checking if data is being acquired
            runstate=HVAI.logging;


            % if an acheck for available samples and store segments of data as
            % appropriate
            if get(findobj(c,'Tag','OPERATE'),'value')
                % get the number of samples to chunk
                if length(get(findobj(c,'Tag','chlen'),'String'))>0
                    if str2num(get(findobj(c,'Tag','chlen'),'String'))>0
                        nchunk=str2num(get(findobj(c,'Tag','chlen'),'String')).*srate;
                        if HVAI.SamplesAvailable>nchunk;
                            userdata=HVAI.userdata;
                            userdata.chunk=nchunk; % flag to store the data
                            HVAI.userdata=userdata;
                            HVDATAGUICALLBACKS(27)
                        end
                    end % if str2num(get(findobj(c,'Tag','chlen'),'String'))>0
                end % if length(get(findobj(c,'Tag','chlen'),'String'))>0
            end %  if get(findobj(c,'Tag','OPERATE'),'value')

            % SCREEN UPDATE DELAY
            pause(0.35);

        end %while lower(runstate(1:2))=='on'

        % enable the operate button if not already enabled
        opstate=get(findobj(c,'Tag','OPERATE'),'Enable');
        if lower(opstate(1:2))=='of'
            set(findobj(c,'Tag','OPERATE'),'Enable','On');
            set(findobj(c,'Tag','OPERATE'),'Value',0);
            drawnow           
        end

%--------------------------------------------------------------------------
    case 10; % timebase down

        % get the current timebase
        ctimestr=get(findobj(c,'Tag','time'),'string');
        ctime=str2num(ctimestr);

        % minimum rate is just above the time increment
        srate = 1./HV.TINCREMENT;
        minrate = 2.5.*(1./srate);

        if ctime>minrate;
            % use sequence 1 2 5 10 20...
            % check if  the last digit is a zero
            if ctimestr(end) =='0' % must be >=10
                % check if  the second-last digit is a zero
                if ctimestr(end-1) =='0' % must be 100-500
                    lastsf=ctimestr(end-2) ;
                else % must be 10-50
                    lastsf=ctimestr(end-1) ;
                end
            else % must be < '10'
                lastsf=ctimestr(end) ;
            end

            % switch using the last significant figure
            switch lastsf
                case '0'
                    ctime=ctime./2;
                case '1'
                    ctime=ctime./2;
                case '2'
                    ctime=ctime./2;
                case '5'
                    ctime=ctime./2.5;

            end % switch ctimestr(end)
            set(findobj(c,'Tag','time'),'string',num2str(ctime));
        end % if ctime>0.0001;
%--------------------------------------------------------------------------
    case 11; % timebase up

        % get the current timebase
        ctimestr=get(findobj(c,'Tag','time'),'string');
        ctime=str2num(ctimestr);

        % minimum value is 500 seconds
        if ctime<500;

            % use sequence 1 2 5 10 20...
            % check if  the last digit is a zero
            if ctimestr(end) =='0' % must be >=10
                % check if  the second-last digit is a zero
                if ctimestr(end-1) =='0' % must be 100-500
                    lastsf=ctimestr(end-2) ;
                else % must be 10-50
                    lastsf=ctimestr(end-1) ;
                end
            else % must be < '10'
                lastsf=ctimestr(end) ;
            end


            % use sequence 1 2 5 10 20...
            switch lastsf
                case '1'
                    ctime=ctime.*2;
                case '2'
                    ctime=ctime.*2.5;
                case '5'
                    ctime=ctime.*2;
            end % switch ctimestr(end)
            set(findobj(c,'Tag','time'),'string',num2str(ctime));
        end % if ctime<10;
%--------------------------------------------------------------------------
    case 12 % monitor mean
        set(findobj(c,'Tag','smean'),'value',1);
        set(findobj(c,'Tag','srms'),'value',0);
        set(findobj(c,'Tag','smax'),'value',0);
        set(findobj(c,'Tag','smin'),'value',0);
        set(findobj(c,'Tag','samax'),'value',0);
        set(findobj(c,'Tag','sabs'),'value',0);
%--------------------------------------------------------------------------
    case 13 % monitor rms
        set(findobj(c,'Tag','smean'),'value',0);
        set(findobj(c,'Tag','srms'),'value',1);
        set(findobj(c,'Tag','smax'),'value',0);
        set(findobj(c,'Tag','smin'),'value',0);
        set(findobj(c,'Tag','samax'),'value',0);
        set(findobj(c,'Tag','sabs'),'value',0);
%--------------------------------------------------------------------------
    case 14 % monitor max
        set(findobj(c,'Tag','smean'),'value',0);
        set(findobj(c,'Tag','srms'),'value',0);
        set(findobj(c,'Tag','smax'),'value',1);
        set(findobj(c,'Tag','smin'),'value',0);
        set(findobj(c,'Tag','samax'),'value',0);
        set(findobj(c,'Tag','sabs'),'value',0);
%--------------------------------------------------------------------------
    case 15 % monitor min
        set(findobj(c,'Tag','smean'),'value',0);
        set(findobj(c,'Tag','srms'),'value',0);
        set(findobj(c,'Tag','smax'),'value',0);
        set(findobj(c,'Tag','smin'),'value',1);
        set(findobj(c,'Tag','samax'),'value',0);
        set(findobj(c,'Tag','sabs'),'value',0);
%--------------------------------------------------------------------------
    case 16 % monitor pk-pk
        set(findobj(c,'Tag','smean'),'value',0);
        set(findobj(c,'Tag','srms'),'value',0);
        set(findobj(c,'Tag','smax'),'value',0);
        set(findobj(c,'Tag','smin'),'value',0);
        set(findobj(c,'Tag','samax'),'value',1);
        set(findobj(c,'Tag','sabs'),'value',0);
%--------------------------------------------------------------------------
    case 17% Start the DAQ when using the monitors

        while get(findobj(c,'Tag','scopeon'),'value');
            delete(HVAI);
            
            % lock controls
            HVDATAGUICALLBACKS(23)

            % set overrange warning lights
            for q=1:16%fchan:(fchan+nchans-1)
                set(findobj(c,'Tag',['ch',num2str(q),'or']),'Backgroundcolor',[0.8,0.8,0.8]);
            end

            % reset the scope range
            %set(findobj(c,'Tag','scope'),'ylim',[-1,1]);
            scopeuserdata.reset=1;
            set(findobj(c,'Tag','scope'),'userdata',scopeuserdata);

            HVDAQ(1)

            % run the scope and monitor controls
            %  if get(findobj(c,'Tag','scopeon'),'value');
            HVDATAGUICALLBACKS(9)
            % end

        end % while get(findobj(c,'Tag','scopeon'),'value');

%--------------------------------------------------------------------------
    case 18 % ABORT

        % close the pop up window if it is open
        HVDATAPOPUP=HVDATA_WARNING;
        close(HVDATAPOPUP);
        HVDATAPOPUP=[];

        % toggle the OPERATE button and unlock the controls
        set(findobj(c,'Tag','status'),'string','Input/output not running');
        set(findobj(c,'Tag','OPERATE'),'String','INITIALISE');
        set(findobj(c,'Tag','OPERATE'),'Enable','On');
        set(findobj(c,'Tag','OPERATE'),'Value',0);
        set(findobj(c,'Tag','STOP'),'String','STOP');
        set(findobj(c,'Tag','STOP'),'Enable','Off');
        set(findobj(c,'Tag','scopeon'),'Enable','On');
        set(findobj(c,'Tag','scopeon'),'Callback','HVDATAGUICALLBACKS(5)');
        set(findobj(c,'Tag','scopeon'),'Value',0);
        HVDATAGUICALLBACKS(24)
        drawnow
        set(findobj(c,'Tag','OPERATE'),'Callback','HVDATAGUICALLBACKS(26)');
        set(findobj(c,'Tag','STOP'),'Callback','HVDATAGUICALLBACKS(8)');
        set(findobj(c,'Tag','datfile'),'Enable','inactive');

%--------------------------------------------------------------------------
    case 19 % set all ranges, units and voltages
        arng=get(findobj(c,'Tag','rangeall'),'string');
        aunit=get(findobj(c,'Tag','unitall'),'string');
        avolts=get(findobj(c,'Tag','vall'),'value')
        for q=1:16
            if length(arng)>0;
                set(findobj(c,'Tag',['ch',num2str(q),'range']),'String',arng);
            end
            if length(aunit)>0;
                set(findobj(c,'Tag',['ch',num2str(q),'unit']),'String',aunit);
            end
            if avolts>1;
                set(findobj(c,'Tag',['ch',num2str(q),'v']),'value',avolts-1);
            end
        end

%--------------------------------------------------------------------------
    case 20 % display das file

        currdir=cd;
                
        pdata=get(findobj(c,'Tag','datfile'),'string');
        
        
        fulldirectory=pdata
       
               
        if length(pdata)>0
            displaydata=hvread(fulldirectory)
            hvgraph(displaydata);
        end
        
        
%--------------------------------------------------------------------------
    case 21 % save description parameters file
 
         for q=1:16
             HV.INCHANNEL(q).DESCRIPTION = get(findobj(c,'Tag',['ch',num2str(q),'title']),'String');
         end

%--------------------------------------------------------------------------
    case 22 % SET PARAMETERS

        % A/D channels
        for q = 1:16
            set(findobj(c,'Tag',['ch',num2str(q),'title']),'String',HV.INCHANNEL(q).DESCRIPTION);
            set(findobj(c,'Tag',['ch',num2str(q),'range']),'String',num2str(HV.INCHANNEL(q).RANGE));
            set(findobj(c,'Tag',['ch',num2str(q),'unit']),'String',HV.INCHANNEL(q).UNIT);
            set(findobj(c,'Tag',['ch',num2str(q),'v']),'String',HV.INCHANNEL(q).VOLTAGE);

%             switch HV.INCHANNEL(q).VOLTAGE
%                 case 1.25
%                     set(findobj(c,'Tag',['ch',num2str(q),'v']),'Value',4);
%                 case 2.5
%                     set(findobj(c,'Tag',['ch',num2str(q),'v']),'Value',3);
%                 case 5
%                     set(findobj(c,'Tag',['ch',num2str(q),'v']),'Value',2);
%                 case 10
%                     set(findobj(c,'Tag',['ch',num2str(q),'v']),'Value',1);
%             end

        end % for q=1:16
% 
        set(findobj(c,'Tag','textduration'),'String',num2str(HV.DURATION));
        set(findobj(c,'Tag','textinputsamprate'),'String',num2str(1./HV.TINCREMENT));
        HVDATAGUICALLBACKS(2);
        set(findobj(c,'Tag','textninputchan'),'String',HV.INCHANNELS);
        HVDATAGUICALLBACKS(1);


        
        
%--------------------------------------------------------------------------
    case 23 % lock controls
        set(findobj(c,'Tag','srate'),'Enable','Off');
        set(findobj(c,'Tag','nchans'),'Enable','Off');
        set(findobj(c,'Tag','fchan'),'Enable','Off');
        set(findobj(c,'Tag','duration'),'Enable','Off');
        set(findobj(c,'Tag','apptoall'),'Enable','Off');
        set(findobj(c,'Tag','vall'),'Enable','Off');
        set(findobj(c,'Tag','rangeall'),'Enable','Off');
        set(findobj(c,'Tag','unitall'),'Enable','Off');
        set(findobj(c,'Tag','directory'),'Enable','Off');
        set(findobj(c,'Tag','datfile'),'Enable','Off');
        set(findobj(c,'Tag','overwrite'),'Enable','Off');
        set(findobj(c,'Tag','chlen'),'Enable','Off');
        set(findobj(c,'Tag','chlenlabel'),'Enable','Off');
        set(findobj(c,'Tag','delay'),'Enable','Off');
        set(findobj(c,'Tag','delaylabel'),'Enable','Off');
        set(findobj(c,'Tag','fileinc'),'Enable','Off');
        set(findobj(c,'Tag','checkboxdivide'),'Enable','Off');


        for q=1:16
            set(findobj(c,'Tag',['ch',num2str(q),'title']),'Enable','Off');
            set(findobj(c,'Tag',['ch',num2str(q),'range']),'Enable','Off');
            set(findobj(c,'Tag',['ch',num2str(q),'unit']),'Enable','Off');
        end
%--------------------------------------------------------------------------
    case 24 % unlock controls

        set(findobj(c,'Tag','srate'),'Enable','On');
        set(findobj(c,'Tag','nchans'),'Enable','On');
        set(findobj(c,'Tag','fchan'),'Enable','On');
        set(findobj(c,'Tag','duration'),'Enable','On');
        set(findobj(c,'Tag','apptoall'),'Enable','On');
        set(findobj(c,'Tag','vall'),'Enable','On');
        set(findobj(c,'Tag','rangeall'),'Enable','On');
        set(findobj(c,'Tag','unitall'),'Enable','On');
        set(findobj(c,'Tag','datfile'),'Enable','inactive');
        set(findobj(c,'Tag','overwrite'),'Enable','On');
        set(findobj(c,'Tag','chlen'),'Enable','On');
        set(findobj(c,'Tag','chlenlabel'),'Enable','On');
        set(findobj(c,'Tag','delay'),'Enable','On');
        set(findobj(c,'Tag','delaylabel'),'Enable','On');
        set(findobj(c,'Tag','fileinc'),'Enable','On');
        set(findobj(c,'Tag','checkboxdivide'),'Enable','On');


        for q=1:16
            set(findobj(c,'Tag',['ch',num2str(q),'title']),'Enable','Inactive');
            set(findobj(c,'Tag',['ch',num2str(q),'range']),'Enable','Inactive');
            set(findobj(c,'Tag',['ch',num2str(q),'unit']),'Enable','Inactive');
        end
%--------------------------------------------------------------------------
    case 25 % monitor abs
        set(findobj(c,'Tag','smean'),'value',0);
        set(findobj(c,'Tag','srms'),'value',0);
        set(findobj(c,'Tag','smax'),'value',0);
        set(findobj(c,'Tag','smin'),'value',0);
        set(findobj(c,'Tag','samax'),'value',0);
        set(findobj(c,'Tag','sabs'),'value',1);
%--------------------------------------------------------------------------
    case 27 % Save the data


        posdot=strfind(HVDATATRANSFER.savefilename,'.');
        datfile=HVDATATRANSFER.savefilename(1:posdot-1);
        fullsavename=get(findobj(c,'Tag','datfile'),'String');
       
                
        % get the available data
        userdata=HVAI.userdata;
        
        if userdata.chunk<0;
            newdata=getdata(HVAI,HVAI.SamplesAvailable);
        else
            newdata=getdata(HVAI,userdata.chunk);
        end

        % check for overranging
        %if get(findobj(c,'Tag','checkor'),'Value');
            nchans = HV.INCHANNELS;
            fchan = HV.FIRSTCHANNEL;
            hwchan = fchan:(fchan+nchans-1);
            for q = 1:size(newdata,2);
                switch get(findobj(c,'Tag',['ch',num2str(hwchan(q)),'v']),'Value');
                    case 4
                        vrng=1.25;
                    case 3
                        vrng=2.5;
                    case 2
                        vrng=5;
                    case 1
                        vrng=10;
                end
                range = str2num(get(findobj(c,'Tag',['ch',num2str(hwchan(q)),'range']),'String'));
                if(max(abs(newdata(:,q)./range.*vrng)))>=vrng;
                    set(findobj(c,'Tag',['ch',num2str(hwchan(q)),'or']),'Backgroundcolor',[1,0,0]);
                else
                    % if this is a continuous run, hold the warning
                    % light on
                    bc=get(findobj(c,'Tag',['ch',num2str(hwchan(q)),'or']),'Backgroundcolor');
                    if bc(1)~=1;
                        set(findobj(c,'Tag',['ch',num2str(hwchan(q)),'or']),'Backgroundcolor',[0,1,0]);
                    end
                end
            end
        %end 

        % format the data
        for q = 1:size(newdata,2);
            acquireddata(q) = HVCREATE(newdata(:,q), 1./HVAI.Samplerate, HVAI.channel(q).Channelname, HVAI.channel(q).units, 's');
            % add a time offset if appropriate
            acquireddata(q).x=acquireddata(q).x+(HVDATASAMPLECOUNTER./HVAI.Samplerate);
        end

        % save the data
        hvwrite(fullsavename,acquireddata,['Data acquired ',datestr(now)]);
        set(findobj(c,'Tag','prevfile'),'String',datfile);


        % increment the filename if a segmented acquisition is in progress,
        % otherwise strip the suffix. Also increment the samples acquired
        % counter
        if userdata.chunk>0;
            if length(strfind(datfile,'__'))==1
                indnum=str2num(datfile(strfind(datfile,'__')+2:end));
                indnum=indnum+1;
                datfile=[datfile(1:strfind(datfile,'__')+1),num2str(indnum)];
                
            else
                datfile=[datfile,'__1'];
                
            end % if length(strfind(fname,'__'))==1

            % get the directory listing
            existfiles=dir;

            % get the new filename
            datfilestr=[datfile,'.das'];
            HVDATATRANSFER.savefilename=datfilestr;
            
            
            for q=1:length(existfiles)
                switch datfilestr
                    case deblank(existfiles(q).name)
                        if get(findobj(c,'Tag','overwrite'),'Value')==0;
                            HVDATAPOPUP=HVDATA_WARNING;0
                            cpop=allchild(HVDATAPOPUP);
                            set(findobj(cpop,'Tag','popuptext'),'string',['TEST ABORTED: File ''''',datfilestr,''' already exists']);
                            drawnow
                            % set the HVAI 'stop' function
                            set(HVAI,'StopFcn','HVDATAGUICALLBACKS(7)');
                            userdata=HVAI.userdata;
                            userdata.store=0; % do not save the data on stop
                            userdata.break=1; % flag to stop continuous running if necessary
                            HVAI.userdata=userdata;
                            stop(HVAI) % stop the object, automatically calling the designated stop function.
                            stop(HVAO)
                        end % if 'overwrite'
                end % switch datfile
            end % for q
            

                 namedatasave=sprintf('%s%s',HVDATATRANSFER.savedirectory,datfilestr)
                 set(findobj(c,'Tag','datfile'),'String',namedatasave)

            % incremment the sample counter
            HVDATASAMPLECOUNTER=HVDATASAMPLECOUNTER+length(newdata);
        else
            if length(strfind(datfile,'__'))==1
                datfile=[datfile(1:strfind(datfile,'__')-1)];
                namedatasave=sprintf('%s%s',HVDATATRANSFER.savedirectory,datfile);
                set(findobj(c,'Tag','datfile'),'String',namedatasave)                
            end 

            % check if the filename is due to increment
            if get(findobj(c,'Tag','fileinc'),'value');
                % extract the current file number and increment it
                
                incsep=strfind(datfile,'ACQ');
                incfilenum=str2num(datfile(incsep+3:end));
                incfilenum=incfilenum+1;
                filenumstr=num2str(incfilenum);
                % assemble the new filename
                datfile=[datfile(1:incsep+2),filenumstr];
                % add to the GUI excluding the extension
                datfile=sprintf('%s.das',datfile);
                HVDATATRANSFER.savefilename=datfile;
                namedatasave=sprintf('%s%s',HVDATATRANSFER.savedirectory,datfile);
                set(findobj(c,'Tag','datfile'),'String',namedatasave)
            end 

        end 
%--------------------------------------------------------------------------
    case 28 % close the popup
        close(HVDATAPOPUP)
        HVDATAPOPUP=[];
%--------------------------------------------------------------------------
    case 29 % range to zero
        scopeuserdata.reset=1;
        set(findobj(c,'Tag','scope'),'userdata',scopeuserdata);
%--------------------------------------------------------------------------
    case 30 % clear monitors on select click
        for q=1:16
            set(findobj(c,'Tag',['ch',num2str(q),'mon']),'String','');
        end
%--------------------------------------------------------------------------
    case 31 % clear overrange lights
        for q=0:15
            set(findobj(c,'Tag',['ch',num2str(q),'or']),'Backgroundcolor',[0.8,0.8,0.8]);
        end
%--------------------------------------------------------------------------
    case 32 % scope range reset
        scopeuserdata=get(findobj(c,'Tag','scope'),'userdata');
        scopeuserdata.reset=1;
        set(findobj(c,'Tag','scope'),'userdata',scopeuserdata);
%--------------------------------------------------------------------------
    case 33 % Button select output data

        [filename, pathname] = uigetfile('*.das', 'Select a data file for output (.das)');
  
 if isequal(filename,0)
     
    disp('User selected Cancel')
    HVDATATRANSFER.outflag=0;
 else
        
        namedataoutput=sprintf('%s%s',pathname,filename);
        set(findobj(c,'Tag','directoryoutput'),'String',namedataoutput);
        HVDATATRANSFER.dataoutput=hvread(namedataoutput);
        
        nbchnout=size(HVDATATRANSFER.dataoutput,2); %number of channels to output
         
        for q=1:4   %set active the corresponding output channels properties
            if q <= nbchnout
           set(findobj(c,'Tag',['chout',num2str(q),'enable']),'Backgroundcolor',[0,1,0]);
           set(findobj(c,'Tag',['chout',num2str(q),'enable']),'Enable','on');
           set(findobj(c,'Tag',['checkboxout',num2str(q)]),'Enable','on');
           set(findobj(c,'Tag',['chout',num2str(q),'title']),'Enable','on');
           set(findobj(c,'Tag',['chout',num2str(q),'title']),'String',HVDATATRANSFER.dataoutput(q).title);
           set(findobj(c,'Tag',['chout',num2str(q),'voltage']),'Enable','on');
            else
           set(findobj(c,'Tag',['chout',num2str(q),'enable']),'Backgroundcolor',[0.8,0.8,0.8]);     
           set(findobj(c,'Tag',['chout',num2str(q),'enable']),'Enable','off');
           set(findobj(c,'Tag',['checkboxout',num2str(q)]),'Enable','off');
           set(findobj(c,'Tag',['chout',num2str(q),'title']),'Enable','off');
           set(findobj(c,'Tag',['chout',num2str(q),'voltage']),'Enable','off'); 
            end
        end         
         
         HVDATATRANSFER.outflag=1;
         
         for q=1:size(HVDATATRANSFER.dataoutput,2);
            %Output parameters
            outincr=HVDATATRANSFER.dataoutput(q).x(2) - HVDATATRANSFER.dataoutput(q).x(1);
            outsrate(q)=1./outincr;           
            outduration(q)=HVDATATRANSFER.dataoutput(q).x(size(HVDATATRANSFER.dataoutput(q).x,1));
            set(findobj(c,'Tag','textoutputsamprate'),'String',outsrate(1));
            set(findobj(c,'Tag','textnoutputchan'),'String',size(HVDATATRANSFER.dataoutput,2));
            set(findobj(c,'Tag','textoutputduration'),'String',outduration(1));
            
            
            %Check if the output data has a valid format
            if ~isequal(outsrate(1),outsrate(q)) || ~isequal(outduration(1),outduration(q))
                    ST='The selected output file must have similar duration and sampling rate for each channel Please select a valid data file for output';
                    errordlg(ST);
                    HVDATAGUICALLBACKS(33)
            end
                       
         end
       HVDATAGUICALLBACKS(34)                                          
 end

 
             
 
%--------------------------------------------------------------------------
    case 34 % checkbox to select output channel 1/2/3/4 to monitor
       

           axes(findobj(c,'Tag','scopeout'));

        if HVDATATRANSFER.outflag == 1
              cla        
            if get(findobj(c,'Tag','checkboxout1'),'value');            
              line1=line(HVDATATRANSFER.dataoutput(1,1).x,HVDATATRANSFER.dataoutput(1,1).y);
              set(line1,'color',[0,0,0]);
            end
            if get(findobj(c,'Tag','checkboxout2'),'value');            
              line2=line(HVDATATRANSFER.dataoutput(1,2).x,HVDATATRANSFER.dataoutput(1,2).y);
              set(line2,'color',[1,0,0]);
            end
            if get(findobj(c,'Tag','checkboxout3'),'value');            
              line3=line(HVDATATRANSFER.dataoutput(1,3).x,HVDATATRANSFER.dataoutput(1,3).y);
              set(line3,'color',[0,0,1]);
            end
            if get(findobj(c,'Tag','checkboxout4'),'value');            
              line4=line(HVDATATRANSFER.dataoutput(1,4).x,HVDATATRANSFER.dataoutput(1,4).y);
              set(line4,'color',[0,0.7,0]);
            end
                       
        else
        ST='No output file selected. Please select a data file for output';
        errordlg(ST);
        end
        

        
%--------------------------------------------------------------------------
    case 35 % Button data storage location
        
[filename, pathname] = uiputfile('*.das', 'Select a folder and a name where the acquired data will be saved(.das)');
 
HVDATATRANSFER.savefilename=filename;
HVDATATRANSFER.savedirectory=pathname;


 if isequal(filename,0)
     
    disp('User selected Cancel')
    HVDATATRANSFER.saveflag=0;
    set(findobj(c,'Tag','datfile'),'String','');
    set(findobj(c,'Tag','datfile'),'Enable','inactive');
    
 else      
     namedatasave=sprintf('%s%s',pathname,filename);
     set(findobj(c,'Tag','datfile'),'String',namedatasave);
     HVDATATRANSFER.saveflag=1;
 end
 
      
%--------------------------------------------------------------------------
    case 36 % Checkbox Divide data

set(findobj(c,'Tag','chlen'),'String','')        
        
if get(findobj(c,'Tag','checkboxdivide'),'value')

    set(findobj(c,'Tag','chlen'),'enable','on')
    set(findobj(c,'Tag','chlenlabel'),'enable','on')
else
    set(findobj(c,'Tag','chlen'),'enable','off')
    set(findobj(c,'Tag','chlenlabel'),'enable','off')
end

%--------------------------------------------------------------------------
%case 37 ...
%.
%.
%.







%--------------------------------------------------------------------------
    case 98 %opening function
        
        HVDATATRANSFER.saveflag = 0;
        HVDATATRANSFER.axesflag = 1;
 
%Remove output panel if output not enable
if strcmp(HV.OUTENABLE,'OFF') 
            
        set(findobj(c,'Tag','text211'),'Visible','On');
        set(findobj(c,'Tag','text187'),'Enable','Off');
        set(findobj(c,'Tag','text188'),'Enable','Off');
        set(findobj(c,'Tag','text197'),'Enable','Off');
        set(findobj(c,'Tag','text202'),'Enable','Off');
        set(findobj(c,'Tag','text198'),'Enable','Off');
        set(findobj(c,'Tag','text199'),'Enable','Off');
        set(findobj(c,'Tag','text200'),'Enable','Off');
        set(findobj(c,'Tag','text201'),'Enable','Off');
        set(findobj(c,'Tag','directoryoutput'),'Enable','Off');
        set(findobj(c,'Tag','pushbutton27'),'Enable','Off');
        set(findobj(c,'Tag','scopeout'),'Color',[0.8 0.8 0.8]);
        HVDATATRANSFER.axesflag = 1;

            for q=1:4
            set(findobj(c,'Tag',['chout',num2str(q),'enable']),'Enable','Off');
            set(findobj(c,'Tag',['chout',num2str(q),'title']),'Enable','Off');
            set(findobj(c,'Tag',['chout',num2str(q),'voltage']),'Enable','Off');
            set(findobj(c,'Tag',['checkboxout',num2str(q)]),'Enable','Off');
            end
        HVDATATRANSFER.outflag=1;           
else    %re-instore the output panel 
        set(findobj(c,'Tag','text211'),'Visible','Off');
        HVDATATRANSFER.outflag=0;
        set(findobj(c,'Tag','text187'),'Enable','On');
        set(findobj(c,'Tag','text188'),'Enable','On');
        set(findobj(c,'Tag','text197'),'Enable','On');
        set(findobj(c,'Tag','text202'),'Enable','On');
        set(findobj(c,'Tag','text198'),'Enable','On');
        set(findobj(c,'Tag','text199'),'Enable','On');
        set(findobj(c,'Tag','text200'),'Enable','On');
        set(findobj(c,'Tag','text201'),'Enable','On');
        set(findobj(c,'Tag','directoryoutput'),'Enable','On');
        set(findobj(c,'Tag','directoryoutput'),'Enable','Inactive');
        set(findobj(c,'Tag','pushbutton27'),'Enable','On');
        set(findobj(c,'Tag','scopeout'),'Color',[1 1 1]);
                        
end
       
        
%--------------------------------------------------------------------------
    case 99 %closefcn

acqstate=get(findobj(c,'Tag','scopeon'),'value');

switch acqstate

    case 0 %if no acq or cal is running, then close window

             delete(get(0,'CurrentFigure'))

    case 1 %if an acq or cal is running, then print appropriate warning

          ST={'Warning: calibration or monitoring still running.';
          'Turn off the monitoring or finish the calibration process before exit'};
          errordlg(ST);
          uiwait

end
%--------------------------------------------------------------------------             
                                
end % switch main index of HVDATAGUICALLBACKS

function [dasNew] = HVCREATE(ydata, xincr, title, yunit, xunit)

dasNew = HVMAKESTRUCT(title, yunit, xunit);

[dlen, dcols] = size(ydata);
if dcols > dlen, 
    ydata = ydata'; 
    [dlen, dcols] = size(ydata);
end
dasNew.y = ydata;				   

if nargin < 2, xincr = 1;	end;
xlimit = (dlen - 1) * xincr;
dasNew.x = (0: xincr: xlimit)';

if strcmp(dasNew.xunit, 's'), dasNew.stats(1) 	= 1/xincr;		end;
if strcmp(dasNew.xunit, 'Hz'), dasNew.stats(1)	= xlimit/(2);	end;

return





