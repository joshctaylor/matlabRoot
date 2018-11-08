function varargout = HVCALIBRATEWIN(varargin)
%hvcalibrate - issue 1.1 (17/05/2006)-HVLab HRV Toolbox
%-------------------------------------------------------------------------
% HVCALIBRATEWIN M-file for HVCALIBRATEWIN.fig
%      HVCALIBRATEWIN, by itself, creates a new HVCALIBRATEWIN or raises the existing
%      singleton*.
%
%      H = HVCALIBRATEWIN returns the handle to a new HVCALIBRATEWIN or the handle to
%      the existing singleton*.
%
%      HVCALIBRATEWIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HVCALIBRATEWIN.M with the given input arguments.
%
%      HVCALIBRATEWIN('Property','Value',...) creates a new HVCALIBRATEWIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HVCALIBRATEWIN_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HVCALIBRATEWIN_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HVCALIBRATEWIN

% Last Modified by CHL 20-Nov-2009

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HVCALIBRATEWIN_OpeningFcn, ...
                   'gui_OutputFcn',  @HVCALIBRATEWIN_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before HVCALIBRATEWIN is made visible.
function HVCALIBRATEWIN_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HVCALIBRATEWIN (see VARARGIN)
global HV
global HVAI

% Choose default command line output for HVCALIBRATEWIN
handles.output = hObject;


%list some handles in order to increment them later in the program.
%N.B.: list of units is found in this function
handles=listhandles(hObject,handles);
createlist(hObject,handles);
visiblehandles(hObject, handles);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HVCALIBRATEWIN wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HVCALIBRATEWIN_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;






%==========================================================================
%--------------------------------------------------------------------------
%Following code corresponds to the callback for the Cal. buttons. All
%Cal. buttons have the same callback (pushbuttoncal_Callback), but they are
%called with a variable (a) showing the channel corresponding to the button
%(this is set in the property inspector in the GUI editor properties for
%each button. The variable a take place of eventdata, which will be use in
%future release of MATLAB).
%--------------------------------------------------------------------------
%==========================================================================
% --- Executes on button press in pushbuttoncal.
function pushbuttoncal_Callback(hObject, a, handles)
% hObject    handle to pushbuttoncal1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global HV
global HVAI

calstate=get(handles.pushbuttoncal(a),'string');

%set visible max and min values in status box
set(handles.text89,'visible','on');
set(handles.text90,'visible','on');

%code to check that Target range exist
test1=get(handles.edittarget(a),'string'); %loop to verify that edit box is not empty
test2=str2double(get(handles.edittarget(a),'string'));%or with NaN values

if isempty(test1) || isnan(test2)
   st1=sprintf('Error with Target Range value for channel %d',a);
   st2=('no value entered or wrong type of data. In order to perform the calibration, please enter a correct Target Range');
   st={st1;st2};
   errordlg(st);      
else
   set(handles.edittarget(a),'string',abs(test2));          
        
        switch calstate

        case 'Cal.'

            % get state
            handles.scopestate=get(handles.scopeon,'Value');

            %lock controls for the calibration
            for i=1:16
                set(handles.checkbox(i),'enable','off');
                set(handles.checkbox(i),'value',0);
                set(handles.checkbox(a),'value',1);
                set(handles.checkboxall,'value',0);
                set(handles.checkboxall,'enable','off');
                set(handles.edittarget(i),'enable','off');
                set(handles.edittarget(a),'enable','inactive');                
                set(handles.edittarget(a),'Backgroundcolor',[0,1,0]);
                set(handles.pushbuttoncal(i),'enable','off');
                set(handles.pushbuttoncal(a),'enable','on');
                set(handles.pushbuttoncal(a),'Backgroundcolor',[0,1,0]);
                
                
            end

            set(handles.pushbuttoncal(a),'string','Min.'); %change Cal. button to Min.
            txt=sprintf('Calibration in progress for channel %d. Set transducer to minimum value and then click on ''Min.''',a);
            set(handles.textcalstatus,'string',txt);

            if handles.scopestate == 0
            % Launch the daq if no monitoring
            set(handles.scopeon,'Value',1);          
            scopeon_Callback(hObject, a, handles);
            else %if monitoring already working
            set(handles.scopeon,'enable','off')%the acquisition process cannot be cancelled  
            end      


        case 'Min.'

            m=num2str(handles.mdata(a),'%10.4f');
            set(handles.textcalmin,'string',m);%save Min data 
            set(handles.pushbuttoncal(a),'string','Max.'); %change Min. button to Max.
            txt=sprintf('Calibration in progress for channel %d. Set transducer to maximum value and then click on ''Max.''',a);
            set(handles.textcalstatus,'string',txt);



        case 'Max.'
            m=num2str(handles.mdata(a),'%10.4f');
            set(handles.textcalmax,'string',m);%save Max data 
            set(handles.pushbuttoncal(a),'string','Cal.'); %change Max. button to Cal.

            newrange=str2num(get(handles.edittarget(a),'string'))*str2num(get(handles.range(a),'string'))*1/(str2num(get(handles.textcalmax,'string'))-str2num(get(handles.textcalmin,'string')));

            set(HVAI,'StopFcn','HVCALIBRATEWIN()');  
            stop(HVAI) % stop the object, automatically calling the designated stop function.

            set(handles.scopeon,'Value',0);
            set(handles.scopeon,'enable','on')

            %unlock controls 
            for i=1:16
                set(handles.checkbox(i),'enable','on');
                set(handles.checkboxall,'enable','on');
                set(handles.edittarget(i),'enable','on');               
                set(handles.edittarget(a),'Backgroundcolor',[1,1,1]);
                set(handles.pushbuttoncal(i),'enable','on');
                set(handles.pushbuttoncal(a),'Backgroundcolor',[0.8,0.8,0.8]);
            end

            srange=num2str(newrange,'%10.2f');
            qstring=sprintf('After Auto-calibration, the new range for channel %d will be of %s %s. Accept new range for this channel?',a,srange,HV.INCHANNEL(a).UNIT);
            button = questdlg(qstring,'New range confirmation','Yes','No','Yes');
            
            if strcmp('Yes',button)
                HV.INCHANNEL(a).RANGE=newrange;
                set(handles.range(a),'string',newrange);           
                txt=sprintf('Calibration process finish for channel %d. New range set to %s %s .',a,srange,HV.INCHANNEL(a).UNIT);
                set(handles.textcalstatus,'string',txt);
            else
               txt=sprintf('Calibration process finish for channel %d. New range ignored.',a);
               set(handles.textcalstatus,'string',txt); 
            end
            
        end %switch calstate


end %if NAN etc...

guidata(hObject, handles);




%--------------------------------------------------------------------------
%==========================================================================
%Following code corresponds to the callback for the radio buttons
%corresponding to the average method.
%a is used as an input variable to this callback with the radiobutton
%number. Inputs of this function are set in the property inspector window,
%in the 'Callback function' setting for each radiobutton.
%--------------------------------------------------------------------------
%==========================================================================
% --- Executes on button press in radiobutton.
function radiobutton_Callback(hObject, a, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


switch a
    
    case 1
    set(handles.radiobutton1,'value',1);
    set(handles.radiobutton2,'value',0);
    set(handles.radiobutton3,'value',0);
    set(handles.radiobutton4,'value',0);
    set(handles.radiobutton5,'value',0);
    set(handles.radiobutton6,'value',0);
    case 2
    set(handles.radiobutton1,'value',0);
    set(handles.radiobutton2,'value',1);
    set(handles.radiobutton3,'value',0);
    set(handles.radiobutton4,'value',0);
    set(handles.radiobutton5,'value',0);
    set(handles.radiobutton6,'value',0);
    case 3
    set(handles.radiobutton1,'value',0);
    set(handles.radiobutton2,'value',0);
    set(handles.radiobutton3,'value',1);
    set(handles.radiobutton4,'value',0);
    set(handles.radiobutton5,'value',0);
    set(handles.radiobutton6,'value',0);
    case 4
    set(handles.radiobutton1,'value',0);
    set(handles.radiobutton2,'value',0);
    set(handles.radiobutton3,'value',0);
    set(handles.radiobutton4,'value',1);
    set(handles.radiobutton5,'value',0);
    set(handles.radiobutton6,'value',0);
    case 5
    set(handles.radiobutton1,'value',0);
    set(handles.radiobutton2,'value',0);
    set(handles.radiobutton3,'value',0);
    set(handles.radiobutton4,'value',0);
    set(handles.radiobutton5,'value',1);
    set(handles.radiobutton6,'value',0);
    case 6
    set(handles.radiobutton1,'value',0);
    set(handles.radiobutton2,'value',0);
    set(handles.radiobutton3,'value',0);
    set(handles.radiobutton4,'value',0);
    set(handles.radiobutton5,'value',0);
    set(handles.radiobutton6,'value',1);
end

guidata(hObject, handles);


%--------------------------------------------------------------------------
% --- Executes on button press in buttontimedown.
function buttontimedown_Callback(hObject, eventdata, handles)
% hObject    handle to buttontimedown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global HV

        % get the current timebase
        ctimestr=get(handles.time,'string');
        ctime=str2num(ctimestr);

        % minimum rate is just above the time increment
        srate=1./HV.TINCREMENT;
        minrate=2.5.*(1./srate);

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
            set(handles.time,'string',num2str(ctime));
        end % if ctime>0.0001;


guidata(hObject, handles);


%--------------------------------------------------------------------------
% --- Executes on button press in buttontimeup.
function buttontimeup_Callback(hObject, eventdata, handles)
% hObject    handle to buttontimeup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get the current timebase
        ctimestr=get(handles.time,'string');
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
            set(handles.time,'string',num2str(ctime));
        end % if ctime<10;

guidata(hObject, handles);

%--------------------------------------------------------------------------
% --- Executes on button press in buttonrescale.
function buttonrescale_Callback(hObject, eventdata, handles)
% hObject    handle to buttonrescale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

        scopeuserdata=get(handles.scope,'userdata');
        scopeuserdata.reset=1;
        set(handles.scope,'userdata',scopeuserdata);

%--------------------------------------------------------------------------
% --- Executes on selection change in voltagepopupmenuall.
function voltagepopupmenuall_Callback(hObject, eventdata, handles)
% hObject    handle to voltagepopupmenuall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on typing a range for all channels -------------------------
function rangechall_Callback(hObject, eventdata, handles)
% hObject    handle to voltagepopupmenuall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global HV

        test1=get(hObject,'string'); %loop to verify that edit box is not empty
        test2=str2double(get(hObject,'string'));%or with NaN values
        
        if isempty(test1)
        %used in order to idle the callback, so when no value is entered 
        %and the button 'apply to all' is pushed, no value is entered for Range.    
        elseif isnan(test2)
           st1=sprintf('Error with Range value');
           st2=('no value entered or wrong type of data. Parameters will be set to default value');
           st={st1;st2};
           errordlg(st);
           set(hObject,'string',25);          
        else
           set(hObject,'string',abs(test2));           
        end
guidata(hObject, handles);

% --- Executes on selection change in popupunitall.------------------------
function popupunitall_Callback(hObject, eventdata, handles)
% hObject    handle to popupunitall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 contents = get(hObject,'String'); 

 set(handles.unitchall,'string',contents{get(hObject,'Value')}) ;

guidata(hObject, handles);

        
% --- Executes on button press in pushbuttonall.---------------------------
function pushbuttonall_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global HV

contentsvolt = get(handles.voltagepopupmenuall,'String');
unitall=get(handles.unitchall,'string');


if ~isequal(unitall,'') %no update if no unit is chosen
   for i=1:16    
    HV.INCHANNEL(i).UNIT=unitall;
   end
end

if ~isempty(get(handles.rangechall,'string'))%no update if no range is chosen
   for i=1:16    
    HV.INCHANNEL(i).RANGE=str2num(get(handles.rangechall,'string'));
   end 
end

for i=1:16 %update the voltage for each channel   
    HV.INCHANNEL(i).VOLTAGE=str2num(contentsvolt{get(handles.voltagepopupmenuall,'Value')});      
end 
  
guidata(hObject, handles);
createlist(hObject,handles) %reload the list to see the changes

%--------------------------------------------------------------------------
% --- Executes on button press in checkboxall.
function checkboxall_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxall

a=get(handles.checkboxall,'Value');

if isequal(a,0) %if the checkbox is already used, then remove all monitors    
   for i=1:16
        set(handles.checkbox(i),'Value',0);
   end     
else
    for i=1:16 %if the checkbox is not used, then active all monitors
        set(handles.checkbox(i),'Value',1);
    end    
end


guidata(hObject, handles);
%--------------------------------------------------------------------------
function checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1

%  % clear monitors on select click
        for i=1:16
            set(handles.editvalue(i),'String','');
        end
        
guidata(hObject, handles);

%--------------------------------------------------------------------------
%==========================================================================
%Following function is used to list all the handles with an increment
%number. This will allow to easily use these handles in for loops in order
%to quickly change properties. Handles names with increment cannot be
%created under the GUi editor when creating an object, hence this function.
%Creating handles with increment names might be available in futur release
%of MATLAB.
%Other external functions are listed here.
%PS: List of units can be edited in this function
%==========================================================================
%--------------------------------------------------------------------------

function handles=listhandles(hObject, handles)
 
handles.des(1)=handles.chnameedit1;
handles.des(2)=handles.chnameedit2;
handles.des(3)=handles.chnameedit3;
handles.des(4)=handles.chnameedit4;
handles.des(5)=handles.chnameedit5;
handles.des(6)=handles.chnameedit6;
handles.des(7)=handles.chnameedit7;
handles.des(8)=handles.chnameedit8;
handles.des(9)=handles.chnameedit9;
handles.des(10)=handles.chnameedit10;
handles.des(11)=handles.chnameedit11;
handles.des(12)=handles.chnameedit12;
handles.des(13)=handles.chnameedit13;
handles.des(14)=handles.chnameedit14;
handles.des(15)=handles.chnameedit15;
handles.des(16)=handles.chnameedit16;


handles.voltage(1)=handles.voltagepopupmenu1;
handles.voltage(2)=handles.voltagepopupmenu2;
handles.voltage(3)=handles.voltagepopupmenu3;
handles.voltage(4)=handles.voltagepopupmenu4;
handles.voltage(5)=handles.voltagepopupmenu5;
handles.voltage(6)=handles.voltagepopupmenu6;
handles.voltage(7)=handles.voltagepopupmenu7;
handles.voltage(8)=handles.voltagepopupmenu8;
handles.voltage(9)=handles.voltagepopupmenu9;
handles.voltage(10)=handles.voltagepopupmenu10;
handles.voltage(11)=handles.voltagepopupmenu11;
handles.voltage(12)=handles.voltagepopupmenu12;
handles.voltage(13)=handles.voltagepopupmenu13;
handles.voltage(14)=handles.voltagepopupmenu14;
handles.voltage(15)=handles.voltagepopupmenu15;
handles.voltage(16)=handles.voltagepopupmenu16;

handles.range(1)=handles.rangech1;
handles.range(2)=handles.rangech2;
handles.range(3)=handles.rangech3;
handles.range(4)=handles.rangech4;
handles.range(5)=handles.rangech5;
handles.range(6)=handles.rangech6;
handles.range(7)=handles.rangech7;
handles.range(8)=handles.rangech8;
handles.range(9)=handles.rangech9;
handles.range(10)=handles.rangech10;
handles.range(11)=handles.rangech11;
handles.range(12)=handles.rangech12;
handles.range(13)=handles.rangech13;
handles.range(14)=handles.rangech14;
handles.range(15)=handles.rangech15;
handles.range(16)=handles.rangech16;

handles.unit(1)=handles.unitch1;
handles.unit(2)=handles.unitch2;
handles.unit(3)=handles.unitch3;
handles.unit(4)=handles.unitch4;
handles.unit(5)=handles.unitch5;
handles.unit(6)=handles.unitch6;
handles.unit(7)=handles.unitch7;
handles.unit(8)=handles.unitch8;
handles.unit(9)=handles.unitch9;
handles.unit(10)=handles.unitch10;
handles.unit(11)=handles.unitch11;
handles.unit(12)=handles.unitch12;
handles.unit(13)=handles.unitch13;
handles.unit(14)=handles.unitch14;
handles.unit(15)=handles.unitch15;
handles.unit(16)=handles.unitch16;

handles.popupunit(1)=handles.popupunit1;
handles.popupunit(2)=handles.popupunit2;
handles.popupunit(3)=handles.popupunit3;
handles.popupunit(4)=handles.popupunit4;
handles.popupunit(5)=handles.popupunit5;
handles.popupunit(6)=handles.popupunit6;
handles.popupunit(7)=handles.popupunit7;
handles.popupunit(8)=handles.popupunit8;
handles.popupunit(9)=handles.popupunit9;
handles.popupunit(10)=handles.popupunit10;
handles.popupunit(11)=handles.popupunit11;
handles.popupunit(12)=handles.popupunit12;
handles.popupunit(13)=handles.popupunit13;
handles.popupunit(14)=handles.popupunit14;
handles.popupunit(15)=handles.popupunit15;
handles.popupunit(16)=handles.popupunit16;

handles.textch(1)=handles.ch1;
handles.textch(1)=handles.ch1;
handles.textch(2)=handles.ch2;
handles.textch(3)=handles.ch3;
handles.textch(4)=handles.ch4;
handles.textch(5)=handles.ch5;
handles.textch(6)=handles.ch6;
handles.textch(7)=handles.ch7;
handles.textch(8)=handles.ch8;
handles.textch(9)=handles.ch9;
handles.textch(10)=handles.ch10;
handles.textch(11)=handles.ch11;
handles.textch(12)=handles.ch12;
handles.textch(13)=handles.ch13;
handles.textch(14)=handles.ch14;
handles.textch(15)=handles.ch15;
handles.textch(16)=handles.ch16;

handles.editvalue(1)=handles.editvalue1;
handles.editvalue(2)=handles.editvalue2;
handles.editvalue(3)=handles.editvalue3;
handles.editvalue(4)=handles.editvalue4;
handles.editvalue(5)=handles.editvalue5;
handles.editvalue(6)=handles.editvalue6;
handles.editvalue(7)=handles.editvalue7;
handles.editvalue(8)=handles.editvalue8;
handles.editvalue(9)=handles.editvalue9;
handles.editvalue(10)=handles.editvalue10;
handles.editvalue(11)=handles.editvalue11;
handles.editvalue(12)=handles.editvalue12;
handles.editvalue(13)=handles.editvalue13;
handles.editvalue(14)=handles.editvalue14;
handles.editvalue(15)=handles.editvalue15;
handles.editvalue(16)=handles.editvalue16;

handles.edittarget(1)=handles.edittarget1;
handles.edittarget(2)=handles.edittarget2;
handles.edittarget(3)=handles.edittarget3;
handles.edittarget(4)=handles.edittarget4;
handles.edittarget(5)=handles.edittarget5;
handles.edittarget(6)=handles.edittarget6;
handles.edittarget(7)=handles.edittarget7;
handles.edittarget(8)=handles.edittarget8;
handles.edittarget(9)=handles.edittarget9;
handles.edittarget(10)=handles.edittarget10;
handles.edittarget(11)=handles.edittarget11;
handles.edittarget(12)=handles.edittarget12;
handles.edittarget(13)=handles.edittarget13;
handles.edittarget(14)=handles.edittarget14;
handles.edittarget(15)=handles.edittarget15;
handles.edittarget(16)=handles.edittarget16;

handles.checkbox(1)=handles.checkbox1;
handles.checkbox(2)=handles.checkbox2;
handles.checkbox(3)=handles.checkbox3;
handles.checkbox(4)=handles.checkbox4;
handles.checkbox(5)=handles.checkbox5;
handles.checkbox(6)=handles.checkbox6;
handles.checkbox(7)=handles.checkbox7;
handles.checkbox(8)=handles.checkbox8;
handles.checkbox(9)=handles.checkbox9;
handles.checkbox(10)=handles.checkbox10;
handles.checkbox(11)=handles.checkbox11;
handles.checkbox(12)=handles.checkbox12;
handles.checkbox(13)=handles.checkbox13;
handles.checkbox(14)=handles.checkbox14;
handles.checkbox(15)=handles.checkbox15;
handles.checkbox(16)=handles.checkbox16;

handles.pushbuttoncal(1)=handles.pushbuttoncal1;
handles.pushbuttoncal(2)=handles.pushbuttoncal2;
handles.pushbuttoncal(3)=handles.pushbuttoncal3;
handles.pushbuttoncal(4)=handles.pushbuttoncal4;
handles.pushbuttoncal(5)=handles.pushbuttoncal5;
handles.pushbuttoncal(6)=handles.pushbuttoncal6;
handles.pushbuttoncal(7)=handles.pushbuttoncal7;
handles.pushbuttoncal(8)=handles.pushbuttoncal8;
handles.pushbuttoncal(9)=handles.pushbuttoncal9;
handles.pushbuttoncal(10)=handles.pushbuttoncal10;
handles.pushbuttoncal(11)=handles.pushbuttoncal11;
handles.pushbuttoncal(12)=handles.pushbuttoncal12;
handles.pushbuttoncal(13)=handles.pushbuttoncal13;
handles.pushbuttoncal(14)=handles.pushbuttoncal14;
handles.pushbuttoncal(15)=handles.pushbuttoncal15;
handles.pushbuttoncal(16)=handles.pushbuttoncal16;

handles.units={'';'m/s^2';'m/s';'mm';'N';'rad/s';'rad';'V'};
for i=1:16
    set(handles.popupunit(i),'string',handles.units);
    set(handles.popupunitall,'string',handles.units);
end

global HV
if strcmp(HV.DAQTYPE, 'NI USB-6211') 
    handles.voltages={10;5;1;0.2};
elseif strcmp(HV.DAQTYPE, 'NI USB-6251') 
    handles.voltages={10;5;2;1;0.5;0.2;0.1};
elseif strcmp(HV.DAQTYPE, 'MCC PCMCIA-DAS16/16')
    handles.voltages={10;5;2.5;1.25};
elseif strcmp(HV.DAQTYPE, 'MCC PCI-DAS6036')
    handles.voltages={10;5;0.5;0.05};
elseif strcmp(HV.DAQTYPE, 'MCC PCI-DAS1602')
    handles.voltages={10;5;2.5;1.25};
elseif strcmp(HV.DAQTYPE, 'Sound Card')
    handles.voltages={5;2;1;0.5};
else    
    handles.voltages={10;5;2.5;2;1.25;1;0.5;0.2;0.1};
end
set(handles.voltagepopupmenuall,'string',handles.voltages);

% Update handles structure
guidata(hObject, handles);

%--------------------------------------------------------------------------
%Following function set the strings to show parameters for all channels.
function createlist(hObject,handles)

global HV
        for i=1:16            
            set(handles.des(i),'string',HV.INCHANNEL(i).DESCRIPTION);
            set(handles.voltage(i),'string',HV.INCHANNEL(i).VOLTAGE);
            set(handles.range(i),'string',HV.INCHANNEL(i).RANGE);
            set(handles.unit(i),'string',HV.INCHANNEL(i).UNIT);
        end       
        txtsmpl=sprintf('Sampling rate: %d smpl/s',1/HV.TINCREMENT);
        set(handles.textsamplingrate,'string',txtsmpl);
        txtband=sprintf('Input band-limit: %d Hz',HV.INFILTER);
        set(handles.textbandlimit,'string',txtband);
        txtpass=sprintf('High-pass filter: %s',HV.INHIGHPASS);
        set(handles.texthighpass,'string',txtpass);
                
% Update handles structure
guidata(hObject, handles);

%--------------------------------------------------------------------------  
%Following function sets visibility of some handles in the window
function visiblehandles(hObject, handles)

global HV

for i=1:16
    
            set(handles.des(i),'Enable','On');
            %set(handles.voltage(i),'Enable','On');
            set(handles.range(i),'Enable','On');
            set(handles.unit(i),'Enable','On');
            
end

        for i=HV.FIRSTCHANNEL:HV.FIRSTCHANNEL+HV.INCHANNELS-1
            set(handles.textch(i),'Enable','On');
            set(handles.textch(i),'Backgroundcolor',[0,1,0]);
        end

        

        
% Update handles structure
guidata(hObject, handles);


%--------------------------------------------------------------------------
%==========================================================================
%The following functions are used as a general callback for all the edit
%boxes corresponding to the channel description, range and units. This is 
%use to reduce the number of callback functions, as only this function is 
%called as a callback for each edit box. 
%The input parameter 'a' is used to know which edit box has been modified.
%(N.B.: here, 'a' takes the place of the variable called 'eventdata'. 
%'eventdata' name was not used as it might be used in later versions of MATLAB.) 
%The value of 'a' is then entered in the callback parameters of the 
%property inspector corresponding to each edit box in the figure file
%(.fig).
%==========================================================================
%--------------------------------------------------------------------------
%Callback function for the channel description edit boxes
function chnameedit_Callback(hObject, a, handles)
global HV

HV.INCHANNEL(a).DESCRIPTION=get(handles.des(a),'string');

%--------------------------------------------------------------------------
%Callback function for the channel range edit boxes
function rangeedit_Callback(hObject, a, handles)
global HV

        test1=get(handles.range(a),'string'); %loop to verify that edit box is not empty
        test2=str2double(get(handles.range(a),'string'));%or with NaN values
        if isempty(test1) || isnan(test2)
           st1=sprintf('Error with channel %d',a);
           st2=('no value entered or wrong type of data. Parameters will be set to default value');
           st={st1;st2};
           errordlg(st);
           HV.INCHANNEL(a).RANGE=25;
           set(handles.range(a),'string',25);
           
        else
           set(handles.range(a),'string',abs(test2)); 
           HV.INCHANNEL(a).RANGE=abs(test2);
           
        end
 % Update handles structure
guidata(hObject, handles);       
%--------------------------------------------------------------------------        
%Callback function for the channel unit edit boxes
function unitch_Callback(hObject, a, handles)
global HV

HV.INCHANNEL(a).UNIT=get(handles.unit(a),'string');

% Update handles structure
guidata(hObject, handles);
%--------------------------------------------------------------------------        
%Callback function for the channel unit popup menus
function popupunit_Callback(hObject, a, handles)
global HV

contents = get(handles.popupunit(a),'String'); %returns popup contents as cell array
HV.INCHANNEL(a).UNIT=contents{get(hObject,'Value')}; %returns selected item from popup
set(handles.unit(a),'string',HV.INCHANNEL(a).UNIT);

% Update handles structure
guidata(hObject, handles);


%--------------------------------------------------------------------------
%==========================================================================
%Following code corresponds to the coding of the acquisition parameters and
%the creation of the analog input object. 
%==========================================================================
%--------------------------------------------------------------------------
% --- Executes on button press in scopeon.
function scopeon_Callback(hObject, a, handles)
% hObject    handle to scopeon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global HV
global HVAI

% get acquisition state
handles.scopestate=get(handles.scopeon,'Value');

% get calibration state
calstate=get(handles.pushbuttoncal(a),'string');
if isequal(calstate,'Min.') %block the scopeon button during calibration so
set(handles.scopeon,'enable','off')%the acquisition process cannot be cancelled                                     %until it finishes calibration   
end
    
if handles.scopestate == 0
    % ABORT the DAQ.       
    set(HVAI,'StopFcn','HVCALIBRATEWIN()');
    userdata=HVAI.userdata;
    userdata.store=0; % flag to store the data
    userdata.break=1; % flag to stop continuous running if necessary
    HVAI.userdata=userdata;   
    stop(HVAI) % stop the object, automatically calling the designated stop function.
    
elseif handles.scopestate == 1
    %clear the monitor boxes
    for i=1:16
        set(handles.editvalue(i),'String','');
    end
    
    % start the DAQ      
        while get(handles.scopeon,'value');
          
            delete(HVAI);            

            % set overrange warning lights
%             for i=1:16
%                 set(handles.editvalue(i),'Backgroundcolor',[0.8,0.8,0.8]);
%             end

            % reset the scope range
            %set(findobj(c,'Tag','scope'),'ylim',[-1,1]);
            scopeuserdata.reset=1;
            set(handles.scope,'userdata',scopeuserdata);
            
            %function that lauches the acquisition. Edit this function for
            %adding new acquisition cards.
            HVDAQ(1)

            % run the scope and monitor controls
            scopefctn(hObject, handles)


        end % while get(handles.scopeon,'value');


end% end of loop 'scopestate' 

% Update handles structure
guidata(hObject, handles);


%--------------------------------------------------------------------------
 % this function run the scope and monitors if desired and store measured
 % data in order to be used for the calibration and to plot.
function scopefctn(hObject, handles)
global HV
global HVAI



        % Run the scope while data is being acquired
        runstate=HVAI.logging;
        while lower(runstate(1:2))=='on'

            % check if 'run while acquiring' is enabled or scope is
            % switched on.
            if get(handles.scopeon,'value');
                % get the sampling rate, number of channels and time range
                
                nchans=HV.INCHANNELS;
                fchan=HV.FIRSTCHANNEL;
                srate=1./HV.TINCREMENT;
                duration=HV.DURATION;  
                ptime=str2num(get(handles.time,'String'));


                % the number of samples available to get, up to the user specified limit
                sampstoget=floor(srate.*ptime);
                [nsamps,nind]=min([sampstoget,HVAI.SamplesAvailable]);

                % display the actual time used for the averaging
                set(handles.atime,'string',['(',num2str(nsamps./srate),')']);
                switch nind
                    case 1
                        set(handles.buttontimedown,'backgroundcolor',[0,1,0]);
                        set(handles.buttontimeup,'backgroundcolor',[0,1,0]);
                    case 2
                        set(handles.buttontimedown,'backgroundcolor',[1,1,0]);
                        set(handles.buttontimeup,'backgroundcolor',[1,1,0]);
                end


                % get the data
                scopedata=peekdata(HVAI,nsamps);

                % select the axis, clear it and set the time axis range
                axes(handles.scope);
                cla;
                set(handles.scope,'xlim',[0,ptime]);
                set(get(handles.scope,'xlabel'),'string','Time (s)')

                hwchan=1:16;

                % counter used to cycle the line colours
                colcount=1;
                for q=1:16
                    % check if line is set to be plotted
                    if get(handles.checkbox(hwchan(q)),'value');
                        % check if there is any data to display
                        if length(scopedata(:,q))>0;
                            % extract the data for each line
                            linedata=scopedata(:,q);
                            % calculate the mean/rms/max/min/absmax
                            if get(handles.radiobutton1,'value');
                                mdata=mean(linedata);
                            elseif get(handles.radiobutton2,'value');
                                mdata=std(linedata);
                            elseif get(handles.radiobutton3,'value');
                                mdata=max(linedata);
                            elseif get(handles.radiobutton4,'value');
                                mdata=min(linedata);
                            elseif get(handles.radiobutton5,'value');
                                mdata=max(linedata)-min(linedata);
                            elseif get(handles.radiobutton6,'value');
                                mdata=max(abs(linedata));
                            end

                            % check for overrange
                        global HV
                        if strcmp(HV.DAQTYPE, 'NI USB-6211') 
                            switch get(handles.voltagepopupmenuall,'Value');
                                case 4
                                    vrng=0.2;
                                case 3
                                    vrng=1;
                                case 2
                                    vrng=5;
                                case 1
                                    vrng=10;
                            end
                        elseif strcmp(HV.DAQTYPE, 'NI USB-6251') 
                            switch get(handles.voltagepopupmenuall,'Value');
                                case 7
                                    vrng=0.1;
                                case 6
                                    vrng=0.2;
                                case 5
                                    vrng=1;
                                case 4
                                    vrng=0.2;
                                case 3
                                    vrng=1;
                                case 2
                                    vrng=5;
                                case 1
                                    vrng=10;
                            end
                        elseif strcmp(HV.DAQTYPE, 'MCC PCMCIA-DAS16/16')
                            switch get(handles.voltagepopupmenuall,'Value');
                                case 4
                                    vrng=1.25;
                                case 3
                                    vrng=2.5;
                                case 2
                                    vrng=5;
                                case 1
                                    vrng=10;
                            end
                        elseif strcmp(HV.DAQTYPE, 'MCC PCI-DAS6036')
                            switch get(handles.voltagepopupmenuall,'Value');
                                case 4
                                    vrng=0.05;
                                case 3
                                    vrng=0.5;
                                case 2
                                    vrng=5;
                                case 1
                                    vrng=10;
                            end
                        elseif strcmp(HV.DAQTYPE, 'MCC PCI-DAS1602')
                            switch get(handles.voltagepopupmenuall,'Value');
                                case 4
                                    vrng=1.25;
                                case 3
                                    vrng=2.5;
                                case 2
                                    vrng=5;
                                case 1
                                    vrng=10;
                            end
                        elseif strcmp(HV.DAQTYPE, 'Sound Card')
                            switch get(handles.voltagepopupmenuall,'Value');
                                case 3
                                    vrng=1;
                                case 2
                                    vrng=2;
                                case 1
                                    vrng=5;
                            end
                        end
                           range=str2num(get(handles.range(q),'String'));
%                             if(max(abs(linedata./range.*vrng)))>=vrng;
%                                 set(findobj(c,'Tag',['ch',num2str(hwchan(q)),'or']),'Backgroundcolor',[1,0,0]);
%                             else
%                                 % lock the warning light if this is an
%                                 % acquisition rather than a monitor
%                                 %if get(findobj(c,'Tag','scopeon'),'Value');
%                                 %    set(findobj(c,'Tag',['ch',num2str(hwchan(q)),'or']),'Backgroundcolor',[0.8,0.8,0.8]);
%                                 %end
%                             end


                            % display the mean/rms/max/min/absmax                            
                            set(handles.editvalue(hwchan(q)),'string',num2str(mdata));
                            %save the value so it can be used for calibration
                            handles.mdata(hwchan(q))=mdata;
                            % Update handles structure
                            guidata(hObject, handles);
                            
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
                            scopeuserdata=get(handles.scope,'userdata');
                            % if this is the first line, set to the line range
                            if scopeuserdata.reset==1;
                                ylims(1)=min(linedata);
                                ylims(2)=max(linedata);

                                % limit about zero.
%                                 if get(findobj(c,'Tag','lockzero'),'value');
%                                     if ylims(1)>0
%                                         ylims(1)=0;
%                                     end
%                                     if ylims(2)<0
%                                         ylims(2)=0;
%                                     end
%                                 end

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
                                set(handles.scope,'userdata',scopeuserdata);
                                % otherwise adjust ranges if necessary
                            else
                                ylims=get(handles.scope,'ylim');
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
                            set(handles.scope,'ylim',ylims);

                            % plot the line
                            lineh=line(tbase,linedata);

                            % set line color
                            switch colcount
                                case 1
                                    set(lineh,'color',[0,0,0]);
                                    set(handles.editvalue(hwchan(q)),'ForegroundColor',[0,0,0]);
                                case 2
                                    set(lineh,'color',[1,0,0]);
                                    set(handles.editvalue(hwchan(q)),'ForegroundColor',[1,0,0]);
                                case 3
                                    set(lineh,'color',[0,0,1]);
                                    set(handles.editvalue(hwchan(q)),'ForegroundColor',[0,0,1]);
                                case 4
                                    set(lineh,'color',[0,0.7,0]);
                                    set(handles.editvalue(hwchan(q)),'ForegroundColor',[0,0.7,0]);
                                    colcount=0;
                            end % case colcount
                            colcount=colcount+1;

                        end
                    end
                end %  for q=fchan:

                % display clock
                ttoc=toc;
                set(handles.clock,'string',[num2str(round(ttoc)),' s']);
                drawnow

            end %     if get(handles.scopeon,'value');


            % keep checking if data is being acquired
            runstate=HVAI.logging;

            % SCREEN UPDATE DELAY
            pause(0.35);
            guidata(hObject, handles);
        end %while lower(runstate(1:2))=='on'


% Update handles structure
guidata(hObject, handles);



%--------------------------------------------------------------------------
%==========================================================================
%Following code corresponds to the coding of the menu and close function
%==========================================================================
% -------------------------------------------------------------------------

% --- Executes on button press in buttonpara.
function buttonpara_Callback(hObject, eventdata, handles)
% hObject    handle to buttonpara (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
acqstate=get(handles.scopeon,'Value');

switch acqstate

    case 0 %if no acq or cal is running, then close window
          hvparameters()        
    case 1 %if an acq or cal is running, then print appropriate warning      
          ST={'Warning: calibration or monitoring still running.';
          'Turn off the monitoring or finish the calibration process before exit'};
          errordlg(ST);
          uiwait          
end



% -------------------------------------------------------------------------
%function used to load parameters from a .pas file
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global HV;

[filename, pathname] = uigetfile('*.pas', 'Select a parameter file .pas');

 if isequal(filename,0)
    %disp('User selected Cancel')
 else
    sep = findstr(filename, '.');
    
    if filename(min(sep+1):min(sep+3))~='pas' 
    ST={'Wrong file extension.';
    'All parameters files must have the extension ".pas"'};
    errordlg(ST);
    uiwait
    load_Callback(hObject, eventdata, handles)
    else             

     fprintf(1, '\nLOADING GLOBAL PARAMETERS\n');
     currentdirectory=cd;
     cd(pathname);
     load('-mat', filename);
     cd(currentdirectory);
     HVFUNPAR(['Parameters loaded from file ', filename]);
     
    validstruct=hvcheckstruct(HV,1);
        if validstruct==0   %Check if the struct HV is a valid structure
        fprintf('WARNING: Format of the chosen parameter structure is not valid');
        fprintf('\nDefault global parameters will be loaded\n');
        hvgetpars('hvdefault',1);
        end
    end
    
 end

createlist(hObject,handles)
% --------------------------------------------------------------------
%function used to load default parameters 
function loaddefault_Callback(hObject, eventdata, handles)
% hObject    handle to loaddefault (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global HV;

hvgetpars('hvdefault',1);
createlist(hObject,handles)
% --------------------------------------------------------------------
%function used to save the parameters into a .pas file
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global HV

[filename, pathname] = uiputfile('*.pas', 'Save the parameter file');
  
  
 if isequal(filename,0)
 %disp('User selected Cancel')
 else
     
 sep = findstr(filename, '.');
 ext = filename(min(sep+1):size(filename,2));
 next = 'pas';
 
    if size(ext,2) == 3
        
        if ~strcmp(ext,next)
        ST={'Wrong file extension.';
        'All parameters files must have the extension ".pas"'};
        errordlg(ST);
        uiwait
        save_Callback(hObject, eventdata, handles)
        else            
            chemin=cd;     
            cd(pathname);
            save(filename,'HV');
            cd(chemin)
        end
    else
        ST={'Wrong file extension.';
        'All parameters files must have the extension ".pas"'};
        errordlg(ST);
        uiwait
        save_Callback(hObject, eventdata, handles)  
    end
end

% --------------------------------------------------------------------
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
closefcn(hObject, 1, handles)

% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%put here a link to the help file in .pdf or .doc
%winopen('help.doc')

% --------------------------------------------------------------------
%function to be called when closing the window (via 'exit' or by closing
%using the top right windows buttons)
function closefcn(hObject, a, handles)
% hObject    handle to help1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

acqstate=get(handles.scopeon,'Value');

switch acqstate

    case 0 %if no acq or cal is running, then close window

         if a == 1

            button = questdlg('Save parameters before exit?','Exit Parameters Table');
                    if strcmp(button,'Yes')
                        save_Callback()
                        closefcn(hObject, 0, handles)
                    elseif strcmp(button,'No')
                        delete(get(0,'CurrentFigure'))
                    elseif strcmp(button,'Cancel')
                        HVCALIBRATEWIN()              
                    end
         elseif a == 0
             delete(get(0,'CurrentFigure'))
         end
  
         
    case 1 %if an acq or cal is running, then print appropriate warning
        
          ST={'Warning: calibration or monitoring still running.';
          'Turn off the monitoring or finish the calibration process before exit'};
          errordlg(ST);
          uiwait
          
end
        
