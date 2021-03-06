function varargout = HVPARAMWIN(varargin)
%hvparameters - issue 1.3 (19/11/2009)-HVLab HRV Toolbox
%-------------------------------------------------------------------------
% HVPARAMWIN M-file for HVPARAMWIN.fig
%      HVPARAMWIN, by itself, creates a new HVPARAMWIN or raises the existing
%      singleton*.
%
%      H = HVPARAMWIN returns the handle to a new HVPARAMWIN or the handle to
%      the existing singleton*.
%
%      HVPARAMWIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HVPARAMWIN.M with the given input arguments.
%
%      HVPARAMWIN('Property','Value',...) creates a new HVPARAMWIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HVPARAMWIN_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HVPARAMWIN_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HVPARAMWIN

% Last Modified by CHL 19-Nov-2009

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HVPARAMWIN_OpeningFcn, ...
                   'gui_OutputFcn',  @HVPARAMWIN_OutputFcn, ...
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

%--------------------------------------------------------------------------
%==========================================================================
% --- Executes just before HVPARAMWIN is made visible.

function HVPARAMWIN_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HVPARAMWIN (see VARARGIN)

% Choose default command line output for HVPARAMWIN
handles.output = hObject;


global HV;       %global parameters variable

%list some handles in order to increment them later in the program.
%N.B.: list of units is found in this function
handles=listhandles(hObject,handles);

%Create list of parameters and description
%createlist(hObject,handles);%Edit this function in order to modify parameters name or order.

%Check if the variable HV exist and is a valid parameter structure
validstruct=hvcheckstruct(HV,1);
if validstruct==0   
    fprintf('\n WARNING: Format of the present parameter structure is not valid');
    fprintf('\n or the parameter structure HV is not present');
    fprintf('\n Default global parameters will be loaded\n');
    hvgetpars('hvdefault',1);
end

DatAcqbutton_Callback(hObject, eventdata, handles)%Load data acquisition window
handles.winflag=1; %Set initial window flag


% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = HVPARAMWIN_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



%--------------------------------------------------------------------------
%==========================================================================
%Following code corresponds to the callbacks of all edit boxes and popup
%menus.
%==========================================================================
%--------------------------------------------------------------------------

%Following code corresponds to the callbacks of all edit boxes and popup
%menus.


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
global HV

switch handles.winflag %switch-case according to the active window on screen
    case 1 %for the data acquisition window
        data=checkedit(hObject,handles,1,11);
        
        if data>16  %to limit the number of input channels      
       st1=('Error with parameter: HV.INCHANNELS');
       st2=('Number of input channels higher than hardware capacity.');
       st3=('Parameters will be set to default value (=1 input channel)');
       st={st1;st2;st3};
       errordlg(st);
       data=1;
       set(hObject,'string',data);
        end
       
       
       nbchnfree=16-data+1;
        
        if HV.FIRSTCHANNEL>nbchnfree %to limit the value if firstchannel is high
       st1=('Error with parameter: HV.FIRSTCHANNEL');
       st2=('Number of input channels higher than hardware capacity.');
       st3=('Parameters will be set to default value (=1)');
       st={st1;st2;st3};
       errordlg(st);
       data=1;
       set(hObject,'string',data);              
            
        end
        
        a=[1:16];
        b=[a(1:HV.FIRSTCHANNEL) a(HV.FIRSTCHANNEL+HV.INCHANNELS)];
                
    case 2 %for the function generation parameters window
        data=checkedit(hObject,handles,1,1);
        set(handles.edit(2),'string',1/data); %set new samplerate
        set(handles.edit(4),'string',HV.DURATION/data); %set new number of samples
        
    %case 3 %for the general parameters window, but editbox 1 not used
            %with this window
end

assignvalue(hObject,handles,1,data); %assign value to its parameter

%--------------------------------------------------------------------------
function edit2_Callback(hObject, eventdata, handles)
global HV

if handles.winflag == 2 %loop to connect this value with HV.TINCREMENT
    
data=checkedit(hObject,handles,2,1);    
set(handles.edit(1),'string',1/data)%set new HV.TINCREMENT
set(handles.edit(4),'string',data*HV.DURATION);%set new number of samples
assignvalue(hObject,handles,1,1/data); %assign value to its parameter

else
    
    switch handles.winflag
        case 1
            
            data=checkedit(hObject,handles,2,11);
        
        if data>16  %to limit the number of input channels      
       st1=('Error with parameter: HV.INCHANNELS');
       st2=('Number of input channels higher than hardware capacity.');
       st3=('Parameters will be set to default value (=1 input channel)');
       st={st1;st2;st3};
       errordlg(st);
       data=1;
       set(hObject,'string',data);
        end
       
       
       nbchnfree=16-data+1;
        
        if HV.FIRSTCHANNEL>nbchnfree %to limit the value if firstchannel is high
       st1=('Error with parameter: HV.FIRSTCHANNEL');
       st2=('Number of input channels higher than hardware capacity.');
       st3=('Parameters will be set to default value (=1)');
       st={st1;st2;st3};
       errordlg(st);
       data=1;
       set(hObject,'string',data);              
            
        end          

        case 3
            data=checkedit(hObject,handles,2,1); 
    end
end

assignvalue(hObject,handles,2,data); %assign value to its parameter

%--------------------------------------------------------------------------
function edit3_Callback(hObject, eventdata, handles)
global HV

switch handles.winflag
    case 1
        
        data=checkedit(hObject,handles,3,11);
        nbchnfree=16-HV.INCHANNELS+1;

            if data>nbchnfree %to limit the value according to the number of input channels
           st1=('Error with parameter: HV.FIRSTCHANNEL');
           st2=('Number of input channels higher than hardware capacity.');
           st3=('Parameters will be set to default value (=1)');
           st={st1;st2;st3};
           errordlg(st);
           data=1;
           set(hObject,'string',data);              

            end
       
    case 2
        data=checkedit(hObject,handles,3,1); 
        set(handles.edit(4),'string',data/HV.TINCREMENT);%set new number of samples 
end

assignvalue(hObject,handles,3,data); %assign value to its parameter


%--------------------------------------------------------------------------
function edit4_Callback(hObject, eventdata, handles)
global HV

switch handles.winflag
    
    case 1
        
        data=checkedit(hObject,handles,4,1);
        assignvalue(hObject,handles,4,data);

    case 2  %loop to connect this value with HV.DURATION
    
        data=checkedit(hObject,handles,4,1);
        set(handles.edit(3),'string',data*HV.TINCREMENT)%set new HV.DURATION
        assignvalue(hObject,handles,3,data*HV.TINCREMENT); %assign value to its parameter
    
    case 3               
         data=checkedit(hObject,handles,4,1); 
         assignvalue(hObject,handles,4,data); %assign value to its parameter
end

%--------------------------------------------------------------------------
function edit5_Callback(hObject, eventdata, handles)
global HV

switch handles.winflag
        
    case 3
        data=checkedit(hObject,handles,5,1); 
end

assignvalue(hObject,handles,5,data); %assign value to its parameter

%--------------------------------------------------------------------------
function edit6_Callback(hObject, eventdata, handles)
global HV

if handles.winflag==1 %loop to connect this value with HV.TINCREMENT
      
        data=checkedit(hObject,handles,6,1);
        set(handles.edit(7),'string',1/data); %set new samplerate
        set(handles.edit(9),'string',HV.DURATION/data); %set new number of samples
    
else
    
    switch handles.winflag       

        case 2
            data=checkedit(hObject,handles,6,1); 

        case 3
            data=checkedit(hObject,handles,6,1); 
    end
end

assignvalue(hObject,handles,6,data); %assign value to its parameter
%--------------------------------------------------------------------------
function edit7_Callback(hObject, eventdata, handles)
global HV

switch handles.winflag
    case 1
        
        data=checkedit(hObject,handles,7,1);
        set(handles.edit(6),'string',1/data)%set new HV.TINCREMENT
        set(handles.edit(9),'string',data*HV.DURATION);%set new number of samples
        assignvalue(hObject,handles,6,1/data); %assign value to its parameter      
                
    case 2
        data=checkedit(hObject,handles,7,1);
        assignvalue(hObject,handles,7,data); %assign value to its parameter
 
end



%--------------------------------------------------------------------------
function edit8_Callback(hObject, eventdata, handles)
global HV


if handles.winflag == 1 %loop to connect this value with HV.DURATION
    
        data=checkedit(hObject,handles,8,1);
        set(handles.edit(9),'string',data/HV.TINCREMENT);%set new number of samples
else
    
    switch handles.winflag
    
        case 2
                data=checkedit(hObject,handles,8,1); 

        case 3
                data=checkedit(hObject,handles,8,1); 
    end
end

assignvalue(hObject,handles,8,data); %assign value to its parameter   


%--------------------------------------------------------------------------
function edit9_Callback(hObject, eventdata, handles)
global HV

switch handles.winflag 
    
    case 1
        data=checkedit(hObject,handles,9,1);
        set(handles.edit(8),'string',data*HV.TINCREMENT)%set new HV.DURATION
        assignvalue(hObject,handles,8,data*HV.TINCREMENT); %assign value to its parameter
    
    case 2
        data=checkedit(hObject,handles,9,1); 
        assignvalue(hObject,handles,9,data); %assign value to its parameter
end



%--------------------------------------------------------------------------
function edit10_Callback(hObject, eventdata, handles)
global HV

switch handles.winflag
    
    case 2
        data=checkedit(hObject,handles,10,1); 
        
    case 3
        data=checkedit(hObject,handles,10,1); 
end

assignvalue(hObject,handles,8,data); %assign value to its parameter

%--------------------------------------------------------------------------
function edit11_Callback(hObject, eventdata, handles)
global HV

switch handles.winflag        
    case 3
        data=checkedit(hObject,handles,11,1); 
end

assignvalue(hObject,handles,11,data); %assign value to its parameter

%--------------------------------------------------------------------------
function edit12_Callback(hObject, eventdata, handles)
global HV

switch handles.winflag        
    case 3
        data=checkedit(hObject,handles,12,1); 
end

assignvalue(hObject,handles,8,data); %assign value to its parameter

%--------------------------------------------------------------------------
function edit13_Callback(hObject, eventdata, handles)
global HV


%--------------------------------------------------------------------------
function edit14_Callback(hObject, eventdata, handles)
global HV



%--------------------------------------------------------------------------
function edit15_Callback(hObject, eventdata, handles)
global HV



%--------------------------------------------------------------------------
function edit16_Callback(hObject, eventdata, handles)
global HV


%end of callbacks for Edit box
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%Callbacks for selection change in all popups:

% --- Executes on selection change in popup1.------------------------------
function popup1_Callback(hObject, eventdata, handles)
% hObject    handle to popup1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%--------------------------------------------------------------------------
% --- Executes on selection change in popup2.
function popup2_Callback(hObject, eventdata, handles)    

%--------------------------------------------------------------------------
% --- Executes on selection change in popup3.
function popup3_Callback(hObject, eventdata, handles)
  

%--------------------------------------------------------------------------
% --- Executes on selection change in popup4.
function popup4_Callback(hObject, eventdata, handles)

%--------------------------------------------------------------------------
% --- Executes on selection change in popup5.
function popup5_Callback(hObject, eventdata, handles)
global HV

switch handles.winflag
    case 1       
        contents = get(hObject,'String'); %returns popup contents as cell array
        HV.INHIGHPASS=contents{get(hObject,'Value')}; %returns selected item from popup1
        set(handles.edit(5),'string',HV.INHIGHPASS);
    case 2
        contents = get(hObject,'String'); %returns popup contents as cell array
        HV.UNIT=contents{get(hObject,'Value')}; %returns selected item from popup1
        set(handles.edit(5),'string',HV.UNIT);
        FunGenbutton_Callback(hObject, eventdata, handles)
end

% Update handles structure
guidata(hObject, handles);    


%--------------------------------------------------------------------------
% --- Executes on selection change in popup6.
function popup6_Callback(hObject, eventdata, handles)
  

%--------------------------------------------------------------------------
% --- Executes on selection change in popup7.
function popup7_Callback(hObject, eventdata, handles)
  

%--------------------------------------------------------------------------
% --- Executes on selection change in popup8.
function popup8_Callback(hObject, eventdata, handles)
  

%--------------------------------------------------------------------------
% --- Executes on selection change in popup9.
function popup9_Callback(hObject, eventdata, handles)
 

%--------------------------------------------------------------------------
% --- Executes on selection change in popup10.
function popup10_Callback(hObject, eventdata, handles)


%--------------------------------------------------------------------------
% --- Executes on selection change in popup11.
function popup11_Callback(hObject, eventdata, handles)


%--------------------------------------------------------------------------
% --- Executes on selection change in popup12.
function popup12_Callback(hObject, eventdata, handles)
global HV

 switch handles.winflag
    case 1
        contents = get(hObject,'String'); %returns popup contents as cell array
        
        HV.OUTENABLE=contents{get(hObject,'Value')}; %returns selected item from popup1
        if strcmp(HV.OUTENABLE,'ON') && strcmp(HV.DAQTYPE,'MCC PCMCIA-DAS16/16')
        HV.OUTENABLE='OFF';
        ST={'Warning: the chosen DAQ card type (MCC PCMCIA-DAS16/16) does not support analog output.';
        'Parameter HV.OUTENABLE will be set back to ''OFF'''};
        errordlg(ST);
        end
        set(handles.edit(12),'string',HV.OUTENABLE);
        
 end
        
%--------------------------------------------------------------------------
% --- Executes on selection change in popup13.
function popup13_Callback(hObject, eventdata, handles)
global HV

switch handles.winflag
    case 1
        contents = get(hObject,'String'); %returns popup contents as cell array
        HV.OUTFILTER=str2num(contents{get(hObject,'Value')}); %returns selected item from popup1
        set(handles.edit(13),'string',HV.OUTFILTER);
end

    
% Update handles structure
guidata(hObject, handles);

%--------------------------------------------------------------------------
% --- Executes on selection change in popup14.
function popup14_Callback(hObject, eventdata, handles)
global HV

switch handles.winflag
    case 1
        contents = get(hObject,'String'); %returns popup contents as cell array
        HV.OUTVOLTAGE=str2num(contents{get(hObject,'Value')}); %returns selected item from popup1
        set(handles.edit(14),'string',HV.OUTVOLTAGE);
    case 3
        contents = get(hObject,'String'); %returns popup1 contents as cell array
        HV.WINDOW=contents{get(hObject,'Value')}; %returns selected item from popup1
        set(handles.edit(14),'string',HV.WINDOW);
end

% Update handles structure
guidata(hObject, handles);    

%--------------------------------------------------------------------------
% --- Executes on selection change in popup15.
function popup15_Callback(hObject, eventdata, handles)
global HV
switch handles.winflag
    case 1        
        contents = get(hObject,'String'); %returns popup1 contents as cell array
        HV.DAQTYPE=contents{get(hObject,'Value')}; %returns selected item from popup1
        set(handles.edit(15),'string',HV.DAQTYPE);
        if strcmp(HV.DAQTYPE,'MCC PCMCIA-DAS16/16')
            set(handles.edit(12),'string','OFF');
            HV.OUTENABLE='OFF';
        end
    case 3
        contents = get(hObject,'String'); %returns popup contents as cell array
        HV.MESSAGES=contents{get(hObject,'Value')}; %returns selected item from popup1
        set(handles.edit(15),'string',HV.MESSAGES);
end

    % Update handles structure
guidata(hObject, handles);

%--------------------------------------------------------------------------
% --- Executes on selection change in popup16.
function popup16_Callback(hObject, eventdata, handles)
% Hints: contents = get(hObject,'String') returns popup1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup1



%--------------------------------------------------------------------------
%==========================================================================
%Following code corresponds to the callback of all buttons present in the
%interface
%==========================================================================
%--------------------------------------------------------------------------


% --- Executes on button press in DatAcqbutton.----------------------------
function DatAcqbutton_Callback(hObject, eventdata, handles)
global HV

handles.winflag=1; %set the flag indicating which window is active

handles=visiblehandles(hObject, handles,16,16,16,0);%set desired fields visible

set(handles.textpagetitle,'string','Data Acquisition Parameters');
set(handles.buttondetails,'visible','on');
    %Loop to remove unwanted fields
    a=[1 11 16];%position of empty fields
    for i=1:3 
    b=a(i); 
    %set(handles.textname(b),'visible','off');
    set(handles.textname(b),'BackgroundColor',[0.831,0.816,0.784]);
    set(handles.edit(b),'visible','off');
    set(handles.textdes(b),'FontWeight','bold');
    set(handles.textdes(b),'BackgroundColor',[0.831,0.816,0.784]);
    end

%Set the different popupmenu present in this window:
onoff={'ON';'OFF'};
set(handles.popup(5),'visible','on');set(handles.popup(5),'string',onoff);
set(handles.edit(5),'enable','inactive');

set(handles.popup(12),'visible','on');set(handles.popup(12),'string',onoff);
set(handles.edit(12),'enable','inactive');

outfilter={5;50;1250;20000};
set(handles.popup(13),'visible','on');set(handles.popup(13),'string',outfilter);
set(handles.edit(13),'enable','inactive');

volt={10;5;2.5};
set(handles.popup(14),'visible','on');set(handles.popup(14),'string',volt);
set(handles.edit(14),'enable','inactive');

daqt={'NI USB-6211';'NI USB-6251';'MCC PCMCIA-DAS16/16';'MCC PCI-DAS6036';'MCC PCI-DAS1602';'Sound Card';'None'};
set(handles.popup(15),'visible','on');set(handles.popup(15),'string',daqt);
set(handles.edit(15),'enable','inactive');

createlist(hObject,handles)

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in FunGenbutton.----------------------------
function FunGenbutton_Callback(hObject, eventdata, handles)
global HV

handles.winflag=2; %set the flag indicating which window is active

handles=visiblehandles(hObject, handles,10,10,10,0);%set desired fields visible

set(handles.textpagetitle,'string','Function Generation Parameters');

%Set the different popupmenu present in this window:
 set(handles.popup(5),'visible','on');
 set(handles.popup(5),'string',handles.units);
 set(handles.edit(5),'enable','inactive');

createlist(hObject,handles)
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in Genbutton.-------------------------------
function Genbutton_Callback(hObject, eventdata, handles)
global HV

handles.winflag=3; %set the flag indicating which window is active

handles=visiblehandles(hObject, handles,15,15,15,0);%set desired fields visible
set(handles.textpagetitle,'string','General Parameters');

    %Loop to remove unwanted fields
    a=[1 3 7 9 13];%position of empty fields
    for i=1:5 
    b=a(i)   ; 
    set(handles.textname(b),'visible','off');
    set(handles.edit(b),'visible','off');
    set(handles.textdes(b),'FontWeight','bold');
    set(handles.textdes(b),'BackgroundColor',[0.831,0.816,0.784]);
    end

%Set the different popupmenu present in this window:
 win={'HAMMING';'HANNING';'RECTANGULAR';'TRIANGULAR';'BARTLETT'};
 set(handles.popup(14),'visible','on');set(handles.popup(14),'string',win);
 set(handles.edit(14),'enable','inactive');
 onoff={'ON';'OFF'};
 set(handles.popup(15),'visible','on');set(handles.popup(15),'string',onoff);
 set(handles.edit(15),'enable','inactive');
    
createlist(hObject,handles)
 
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in buttoncal---------------------------
function buttoncal_Callback(hObject, eventdata, handles)
% hObject    handle to buttondetails (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global HV

if strcmp(HV.DAQTYPE,'None')
       st1=('Error: No DAQ card selected.');
       st2=('Function hvcalibrate will stop.');
       st={st1;st2};
       errordlg(st);  
else
       hvcalibrate()
end

%--------------------------------------------------------------------------
%==========================================================================
%Following code corresponds to the external functions used throughout 
%the program
%==========================================================================
%--------------------------------------------------------------------------

function handles=listhandles(hObject, handles)
%function used to rename some handles with an increment which will allow
%the user to use them and increment them in loops, resulting in significant
%reduction of coding lines.
%N.B.: the actual version of Property inspector in GUI do not allow to
%directly tag object with an increment (such as 'handles.name(1)'), hence
%this function.
%List of unit can be edited at the end of this function

handles.textname(1)=handles.textname1;
handles.textname(2)=handles.textname2;
handles.textname(3)=handles.textname3;
handles.textname(4)=handles.textname4;
handles.textname(5)=handles.textname5;
handles.textname(6)=handles.textname6;
handles.textname(7)=handles.textname7;
handles.textname(8)=handles.textname8;
handles.textname(9)=handles.textname9;
handles.textname(10)=handles.textname10;
handles.textname(11)=handles.textname11;
handles.textname(12)=handles.textname12;
handles.textname(13)=handles.textname13;
handles.textname(14)=handles.textname14;
handles.textname(15)=handles.textname15;
handles.textname(16)=handles.textname16;

handles.textdes(1)=handles.textdes1;
handles.textdes(2)=handles.textdes2;
handles.textdes(3)=handles.textdes3;
handles.textdes(4)=handles.textdes4;
handles.textdes(5)=handles.textdes5;
handles.textdes(6)=handles.textdes6;
handles.textdes(7)=handles.textdes7;
handles.textdes(8)=handles.textdes8;
handles.textdes(9)=handles.textdes9;
handles.textdes(10)=handles.textdes10;
handles.textdes(11)=handles.textdes11;
handles.textdes(12)=handles.textdes12;
handles.textdes(13)=handles.textdes13;
handles.textdes(14)=handles.textdes14;
handles.textdes(15)=handles.textdes15;
handles.textdes(16)=handles.textdes16;

handles.edit(1)=handles.edit1;
handles.edit(2)=handles.edit2;
handles.edit(3)=handles.edit3;
handles.edit(4)=handles.edit4;
handles.edit(5)=handles.edit5;
handles.edit(6)=handles.edit6;
handles.edit(7)=handles.edit7;
handles.edit(8)=handles.edit8;
handles.edit(9)=handles.edit9;
handles.edit(10)=handles.edit10;
handles.edit(11)=handles.edit11;
handles.edit(12)=handles.edit12;
handles.edit(13)=handles.edit13;
handles.edit(14)=handles.edit14;
handles.edit(15)=handles.edit15;
handles.edit(16)=handles.edit16;

handles.popup(1)=handles.popup1;
handles.popup(2)=handles.popup2;
handles.popup(3)=handles.popup3;
handles.popup(4)=handles.popup4;
handles.popup(5)=handles.popup5;
handles.popup(6)=handles.popup6;
handles.popup(7)=handles.popup7;
handles.popup(8)=handles.popup8;
handles.popup(9)=handles.popup9;
handles.popup(10)=handles.popup10;
handles.popup(11)=handles.popup11;
handles.popup(12)=handles.popup12;
handles.popup(13)=handles.popup13;
handles.popup(14)=handles.popup14;
handles.popup(15)=handles.popup15;
handles.popup(16)=handles.popup16;

handles.units={'m/s^2';'m/s';'mm';'N';'rad/s';'rad';'V'};

% Update handles structure
guidata(hObject, handles);

%==========================================================================
%-------------------------------------------------------------------------
function handles=visiblehandles(hObject, handles,a,b,c,d)
%This function is used to make visible text, edit boxes and popupmenu 
%according to the active window.
%a=number of 'textname' to show, b=nb of 'textdes', c=nb of edit, d=nb of popup.
global HV

for i=1:16 
    set(handles.buttondetails,'visible','off');
    set(handles.textname(i),'visible','on');%set visible all fields
    set(handles.textname(i),'string','');%reset text
    set(handles.textname(i),'FontWeight','normal'); %reset field to standard aspect
    set(handles.textname(i),'BackgroundColor',[0.753,0.753,0.753]);%reset field to standard color
    set(handles.textdes(i),'visible','on');
    set(handles.textdes(i),'string','');
    set(handles.textdes(i),'FontWeight','normal'); %reset field to standard aspect
    set(handles.textdes(i),'BackgroundColor',[0.753,0.753,0.753]);%reset field to standard color
    set(handles.edit(i),'visible','on');
    set(handles.edit(i),'enable','on');
    set(handles.edit(i),'string','');
    set(handles.popup(i),'visible','on');
    set(handles.popup(i),'string',' ');
    set(handles.popup(i),'value',1);%1 is chosen in order to avoid Matlab error
                                    %which appear with empty popupmenu
     
    if i>a %Remove unwanted fields from the window
       set(handles.textname(i),'visible','off');
    end
    if i>b
       set(handles.textdes(i),'visible','off');
    end
    if i>c
       set(handles.edit(i),'visible','off');
    end
    if i>d
       set(handles.popup(i),'visible','off');
    end          
end

% Update handles structure
guidata(hObject, handles);

%==========================================================================
%--------------------------------------------------------------------------

function createlist(hObject,handles)
%This function create the list of parameters, descriptions and value that
%are to be shown in the corresponding window. This list is loaded everytime
%the active window is changed. Using this function allow to have clearer
%code within the callbacks of buttons.

global HV

switch handles.winflag
    case 1 %if the data acquisition window is activated
        name={'';'HV.INCHANNELS';'HV.FIRSTCHANNEL';'HV.INFILTER';'HV.INHIGHPASS';
              'HV.TINCREMENT';'';'HV.DURATION';'';'HV.INCHANNEL(k).~';
              '';'HV.OUTENABLE';'HV.OUTFILTER';'HV.OUTVOLTAGE';'HV.DAQTYPE';''};
          
        des={'Input parameters';'Number of channels';'First channel';
              'Low pass filter (Hz)';'High-pass filter';'Sampling increment (s)';
              'Sampling rate (samples per s)';'Duration (s)';'Number of samples';
              'Channel Parameters (Name, Unit, Range & Voltage)';'Output parameters';'Enable analog output';
              'Output band-limit (hz)';'Voltage range of output';
              'Analog interface type';''};
          
        val={0;HV.INCHANNELS;HV.FIRSTCHANNEL;HV.INFILTER;HV.INHIGHPASS;
              HV.TINCREMENT;1/HV.TINCREMENT;HV.DURATION;HV.DURATION/HV.TINCREMENT;
              0;0;HV.OUTENABLE;HV.OUTFILTER;HV.OUTVOLTAGE;HV.DAQTYPE;0};
          
          for i=1:16
              set(handles.textname(i),'string',name(i));
              set(handles.textdes(i),'string',des(i));
              set(handles.edit(i),'string',cell2mat(val(i)));
          end
          
                                 
    case 2
        
        name={'HV.TINCREMENT';'';'HV.DURATION';'';'HV.UNIT';
              'HV.AMPLITUDE';'HV.OFFSET';'HV.FREQUENCY';'HV.FINALFREQUENCY';'HV.FINCREMENT'};
          
          
        peak=sprintf('Peak amplitude of function (%s)',HV.UNIT);
        offset=sprintf('Offset applied to function (%s)',HV.UNIT);
        des={'Time increment (s)';'Sampling rate (samples per s)';
             'Duration (s)';'Number of samples';
             'Data unit';peak;offset;
             'Frequency or initial sweep frequency (Hz)';'Final sweep frequency (Hz)';
             'Increment of weighting function (Hz, 0=smallest)'};
        
         val={HV.TINCREMENT;1/HV.TINCREMENT;HV.DURATION;HV.DURATION/HV.TINCREMENT;HV.UNIT;
              HV.AMPLITUDE;HV.OFFSET;HV.FREQUENCY;HV.FINALFREQUENCY;HV.FINCREMENT};         
         
          for i=1:10
              set(handles.textname(i),'string',name(i));
              set(handles.textdes(i),'string',des(i));
              set(handles.edit(i),'string',cell2mat(val(i)));
          end
         
    case 3
        
        name={'';'HV.CONSTANT';'';'HV.HIGHPASS';'HV.LOWPASS';
              'HV.FILTERPOLES';'';'HV.FINCREMENT';'';'HV.DISTRIBUTIONSTEPS';
              'HV.DISTRIBUTIONMIN';'HV.DISTRIBUTIONMAX';'';'HV.WINDOW';'HV.MESSAGES'};
          
        des={'FILE ARITHMETIC';'Arithmetic constant';'DIGITAL FILTERS';
            'High pass cut-off frequency (Hz)';'Low pass cut-off frequency (Hz)';
            'Number of poles';'SPECTRAL ANALYSIS';'Frequency increment of spectrum (Hz, 0=smallest)';
            'PROBABILITY ANALYSIS';'Number of probability steps';'Lower distribution limit (0=autoscaled)';
            'Upper distribution limit (0=autoscaled)';'GENERAL';'Spectral window';
            'Enables reporting of statistical information'};
        
        val={'';HV.CONSTANT;'';HV.HIGHPASS;HV.LOWPASS;HV.FILTERPOLES;'';HV.FINCREMENT;'';
            HV.DISTRIBUTIONSTEPS;HV.DISTRIBUTIONMIN;HV.DISTRIBUTIONMAX;
            '';HV.WINDOW;HV.MESSAGES};
        
          for i=1:15
              set(handles.textname(i),'string',name(i));
              set(handles.textdes(i),'string',des(i));
              set(handles.edit(i),'string',cell2mat(val(i)));
          end
end

% Update handles structure
guidata(hObject, handles);


%==========================================================================
%--------------------------------------------------------------------------

function editdata=checkedit(hObject,handles,editnumber,edittype)
%This function is used to check that the input data from the edit box is 
%in correct format (edittype: 1=double;11=integer;2=string). An external
%function is used in order to prevent from typing this code under each 
%edit-box callbacks.

switch edittype
    case 1
        test1=get(handles.edit(editnumber),'string'); %loop to verify that edit box is not empty
        test2=str2double(get(handles.edit(editnumber),'string'));%or with NaN values
        if isempty(test1) || isnan(test2)
           txt=cell2mat(get(handles.textname(editnumber),'string'));
           st1=sprintf('Error with parameter: %s',txt);
           st2=('no value entered or wrong type of data. Parameters will be set to default value');
           st={st1;st2};
           errordlg(st);
           
           HVDEFAULT=defaultval(); %loading default value
           assignin('caller','HVDEFAULT',HVDEFAULT);
           p=strfind(txt,'.');
           g=size(txt,2);
           name=txt(p:g);
           defaultname=sprintf('HVDEFAULT%s',name); %associating the parameter name with
                                                    %its default value
           editdata=evalin('caller',defaultname);
           
           clear HVDEFAULT;
        else
           editdata=abs(test2); 
        end
           
     case 11
        test1=get(handles.edit(editnumber),'String'); %loop to verify that edit box is not empty
        test2=str2double(get(handles.edit(editnumber),'string'));%or with NaN values
        if isempty(test1) || isnan(test2)
           txt=cell2mat(get(handles.textname(editnumber),'string'));
           st1=sprintf('Error with parameter: %s',txt);
           st2=('no value entered or wrong type of data. Parameters will be set to default value');
           st={st1;st2};
           errordlg(st);
           
           HVDEFAULT=defaultval(); %loading default value
           assignin('caller','HVDEFAULT',HVDEFAULT);
           p=strfind(txt,'.');
           g=size(txt,2);
           name=txt(p:g);
           defaultname=sprintf('HVDEFAULT%s',name); %associating the parameter name with
                                                    %its default value
           editdata=evalin('caller',defaultname);
           
           clear HVDEFAULT;
        else
           editdata=(floor(abs(test2)));  
        end
        
    case 2
        test1=get(handles.edit(editnumber),'String'); %loop to verify that edit box is not empty
        if isempty(test1)
           txt=cell2mat(get(handles.textname(editnumber),'string'));
           st1=sprintf('Error with parameter: %s',txt);
           st2=('no value entered or wrong type of data. Parameters will be set to default value');
           st={st1;st2};
           errordlg(st);
           
           HVDEFAULT=defaultval(); %loading default value
           assignin('caller','HVDEFAULT',HVDEFAULT);
           p=strfind(txt,'.');
           g=size(txt,2);
           name=txt(p:g);
           defaultname=sprintf('HVDEFAULT%s',name); %associating the parameter name with
                                                    %its default value
           editdata=evalin('caller',defaultname);
           
           clear HVDEFAULT;
        else
           editdata=test1;  
        end             
end

set(handles.edit(editnumber),'string',editdata);

%==========================================================================
% --------------------------------------------------------------------
function assignvalue(hObject,handles,editnumber,value)
%This function assign the value entered in the edit box into the
%corresponding parameter. It is used as a function because these lines have
%to be repeated for each callback of the edit boxes.
global HV

txt=cell2mat(get(handles.textname(editnumber),'string'));
    if ~ischar(value)
    val=num2str(value);
    li=sprintf('%s=%s;',txt,val);
    eval(li);
    else
    li=sprintf('%s=''%s'';',txt,value);
    eval(li);
    end


%==========================================================================
%--------------------------------------------------------------------------
function val=defaultval()
%This function create a structure called HVDEFAULT where default values of
%parameters will be saved. This structure will then be used if an error
%occur while entering a data into an edit box: the parameter window will
%then directly load the default value of the parameter.If default values
%have to be changed, they will be changed in this function.

    HVDEFAULT.INCHANNELS   = 1;
    HVDEFAULT.FIRSTCHANNEL = 1;
    HVDEFAULT.SAMPLERATE   = 400;
    HVDEFAULT.INFILTER     = HVDEFAULT.SAMPLERATE/4;
    HVDEFAULT.INHIGHPASS   = 'OFF';
    HVDEFAULT.TINCREMENT   = 0.0025;   % i.e. 400 samples per second  
    HVDEFAULT.DURATION     = 60;
    HVDEFAULT.SAMPLES      = HVDEFAULT.DURATION*HVDEFAULT.SAMPLERATE;
    
for k = 1:16
    HVDEFAULT.INCHANNEL(k).DESCRIPTION = ['channel ', int2str(k)];
    HVDEFAULT.INCHANNEL(k).RANGE       = 25;
    HVDEFAULT.INCHANNEL(k).UNIT        = 'm/s^2';        
    HVDEFAULT.INCHANNEL(k).VOLTAGE     =5;  
end
    HVDEFAULT.OUTENABLE      = 'OFF';
    HVDEFAULT.OUTFILTER      = 1250;
    HVDEFAULT.OUTVOLTAGE     = 10;
    HVDEFAULT.DAQTYPE        = 'None';

    HVDEFAULT.UNIT           = 'm/s^2';
    HVDEFAULT.AMPLITUDE      = 1.0;
    HVDEFAULT.OFFSET         = 0;
    HVDEFAULT.FREQUENCY      = 1;
    HVDEFAULT.FINALFREQUENCY = 100;
    HVDEFAULT.FINCREMENT     = 0.0;      % i.e. defaults to finest
    
    HVDEFAULT.CONSTANT          = 1;
    HVDEFAULT.HIGHPASS          = 0.1;   
    HVDEFAULT.LOWPASS           = 100.0;       
    HVDEFAULT.FILTERPOLES       = 4.0;
    HVDEFAULT.DISTRIBUTIONSTEPS = 50;
    HVDEFAULT.DISTRIBUTIONMIN   = 0;
    HVDEFAULT.DISTRIBUTIONMAX   = 0;
    HVDEFAULT.MESSAGES          = 'ON';        % i.e. messages on
    HVDEFAULT.WINDOW            = 'HAMMING';
    
val=HVDEFAULT;





%--------------------------------------------------------------------------
%==========================================================================
%Following code corresponds to menu on top of the interface window
%==========================================================================
%--------------------------------------------------------------------------

%function used to load parameters from a .pas file
function loadpara_Callback(hObject, eventdata, handles)
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
    loadpara_Callback(hObject, eventdata, handles)
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
 
 
switch handles.winflag
    
    case 1
        DatAcqbutton_Callback(hObject, eventdata, handles);
    case 2
        FunGenbutton_Callback(hObject, eventdata, handles);
    case 3
        Genbutton_Callback(hObject, eventdata, handles);

end

% --------------------------------------------------------------------
%function used to load default parameters 
function loaddefaultpara_Callback(hObject, eventdata, handles)
global HV;

hvgetpars('hvdefault',1);
 
switch handles.winflag
    
    case 1
        DatAcqbutton_Callback(hObject, eventdata, handles);
    case 2
        FunGenbutton_Callback(hObject, eventdata, handles);
    case 3
        Genbutton_Callback(hObject, eventdata, handles);

end

% --------------------------------------------------------------------
%function used to save the parameters into a .pas file
function savepara_Callback(hObject, eventdata, handles)
global HV;


 [filename, pathname] = uiputfile('*.pas', 'Save the parameter file','hvdefault.pas');
  
  
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
        savepara_Callback(hObject, eventdata, handles)
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
        savepara_Callback(hObject, eventdata, handles)  
    end
end

% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

closefcn(hObject, 1, handles)


% --------------------------------------------------------------------
function help1_Callback(hObject, eventdata, handles)
% hObject    handle to help1 (see GCBO)
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

 if a == 1

    button = questdlg('Save parameters before exit?','Exit Parameters Table');
            if strcmp(button,'Yes')
                savepara_Callback()
                closefcn(hObject, 0, handles)
            elseif strcmp(button,'No')
                delete(get(0,'CurrentFigure'))
            elseif strcmp(button,'Cancel')
                HVPARAMWIN()              
            end
 elseif a == 0
     delete(get(0,'CurrentFigure'))
 end


