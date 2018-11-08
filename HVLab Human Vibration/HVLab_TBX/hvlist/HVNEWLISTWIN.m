function varargout = HVNEWLISTWIN(varargin)
% HVNEWLISTWIN - issue 1.0 (20/02/2006)-HVLab HRV Toolbox
%-------------------------------------------------------------------------
% HVNEWLISTWIN M-file for HVNEWLISTWIN.fig
%      HVNEWLISTWIN, by itself, creates a window where parameters for a new
%      data can be enter. Parameters to edit are as follow:
%
%           Name of Data
%           Sample rate in Hz
%           Number of samples
%           Data type
%           X axis unit
%           Y1 axis unit
%           Y2 axis unit
%
% Control buttons are as follow:
%
%           'Exit': Close the window without performing any other action
%           'Create': Create the new data into the active workspace of
%                     MATLAB
%           'Reset Values': Reset edited values

% Written by Pierre HUGUENET, February 2006

% Last Modified by GUIDE v2.5 15-Feb-2006 10:11:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HVNEWLISTWIN_OpeningFcn, ...
                   'gui_OutputFcn',  @HVNEWLISTWIN_OutputFcn, ...
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


% --- Executes just before HVNEWLISTWIN is made visible.
function HVNEWLISTWIN_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HVNEWLISTWIN (see VARARGIN)

% Choose default command line output for HVNEWLISTWIN

handles.output1 = 'part1';
handles.output2 = 'part2';



    set(handles.text5,'string','Real scale unit');
    set(handles.editY2axis,'visible','off');
    set(handles.text6,'visible','off');
    set(handles.editname,'string','Mydata');
    set(handles.editsamprate,'string','1');
    set(handles.editnumofsamp,'string','1');
    set(handles.editY1axis,'string','');
    set(handles.editY2axis,'string','');
    
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HVNEWLISTWIN wait for user response (see UIRESUME)
  uiwait(handles.figure1);
  

% --- Outputs from this function are returned to the command line.
function varargout = HVNEWLISTWIN_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1}=handles.output1; 
varargout{2}=handles.output2;

% The figure can be deleted now
 delete(handles.figure1);


%-------------------------------------------------------------------------
% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

choice=get(hObject,'Value');
switch choice
    case 1
        set(handles.text5,'string','Real scale unit');
        set(handles.editY2axis,'visible','off');
        set(handles.text6,'visible','off');
    case 2
        set(handles.text5,'string','Real scale unit');
        set(handles.editY2axis,'visible','on');
        set(handles.text6,'string','Imaginary scale unit');
        set(handles.text6,'visible','on');
    case 3
        set(handles.text5,'string','Modulus scale unit');
        set(handles.editY2axis,'visible','on');
        set(handles.text6,'string','Phase scale unit');
        %set(handles.editY2axis,'string','rad');
        set(handles.text6,'visible','on');
end


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

choice=get(hObject,'Value');

switch choice
    case 1
        set(handles.text4,'string','Freq. increment (Hz)');
    case 2
        set(handles.text4,'string','Time increment (s)');
end

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%-------------------------------------------------------------------------
%---------EDIT BOXES------------------------------------------------------
function editsamprate_Callback(hObject, eventdata, handles)
% hObject    handle to editsamprate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editsamprate as text
%        str2double(get(hObject,'String')) returns contents of editsamprate as a double

test1=get(hObject,'String'); %loop to verify that edit box is not empty
test2=str2double(get(hObject,'String'));%or with NaN values
a=(abs(str2double(get(hObject,'String'))));%to limit values to positive integers
if isempty(test1) || isnan(test2) || isequal(a,0)
    set(hObject,'String',1);
else
    set(hObject,'String',a)
end

% --- Executes during object creation, after setting all properties.
function editsamprate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editsamprate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editY1axis_Callback(hObject, eventdata, handles)
% hObject    handle to editY1axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editY1axis as text
%        str2double(get(hObject,'String')) returns contents of editY1axis as a double


% --- Executes during object creation, after setting all properties.
function editY1axis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editY1axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editY2axis_Callback(hObject, eventdata, handles)
% hObject    handle to editY2axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editY2axis as text
%        str2double(get(hObject,'String')) returns contents of editY2axis as a double


% --- Executes during object creation, after setting all properties.
function editY2axis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editY2axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editnumofsamp_Callback(hObject, eventdata, handles)
% hObject    handle to editnumofsamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editnumofsamp as text
%        str2double(get(hObject,'String')) returns contents of editnumofsamp as a double

test1=get(hObject,'String'); %loop to verify that edit box is not empty
test2=str2double(get(hObject,'String'));%or with NaN values
a=floor(abs(str2double(get(hObject,'String'))));%to limit values to positive integers
if isempty(test1) || isnan(test2) || isequal(a,0)
    set(hObject,'String',1);
else
    set(hObject,'String',a)
end

% --- Executes during object creation, after setting all properties.
function editnumofsamp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editnumofsamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editname_Callback(hObject, eventdata, handles)
% hObject    handle to editname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editname as text
%        str2double(get(hObject,'String')) returns contents of editname as a double

name = get(hObject,'String');
newstr = genvarname(name, who);%Code to make sure the given name is a valid variable name
set(hObject,'String',newstr);

% --- Executes during object creation, after setting all properties.
function editname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------------------------------------------------------------------
%------------PUSH BUTTONS-------------------------------------------------

% --- Executes on button press in pushbuttonexit.
function pushbuttonexit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonexit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(handles.figure1, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, use UIRESUME
    uiresume(handles.figure1);
else
    % The GUI is no longer waiting, just close it
    delete(handles.figure1);
end


% --- Executes on button press in pushbuttonreset.
function pushbuttonreset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonreset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    set(handles.editname,'string','Mydata');
    set(handles.editsamprate,'string','1');
    set(handles.editnumofsamp,'string','1');
    set(handles.popupmenu2,'value',1);
    set(handles.editY1axis,'string','');
    set(handles.editY2axis,'string','');

% --- Executes on button press in pushbuttoncreate.
function pushbuttoncreate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttoncreate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

indic=0;
dataname=get(handles.editname,'String');

if any(ismember(evalin('base','who'),dataname))  % see name matches a variable name
   button = questdlg('Overwrite variable?','Variable name already in Workspace');
   if strcmp(button,'Yes')
       indic=1;
   else
       indic=0;
   end
   
else
    indic=1;
end
  
   if indic==1  %assigning values for the data structure
        datasamprate=str2double(get(handles.editsamprate,'String'));
        increment=1/datasamprate;
        datanumofsamp=str2double(get(handles.editnumofsamp,'String'));
        a=(1:datanumofsamp)';
        b=a.*increment;
        %creating data with appropriate structure type using HVMAKESTRUCT
        title='';
        yunit=(get(handles.editY1axis,'String'));
        
        contents = get(handles.popupmenu2,'Value'); 
        switch contents
            case 1
                xunit='Hz';
            case 2
                xunit='s';
        end
        
        dtype=get(handles.popupmenu1,'Value');
        dxvar=0;
        stats=[1 0 0 0];
        xvals=b;
        
        [data] = HVMAKESTRUCT(title, yunit, xunit, dtype, dxvar, stats, xvals);
        
        data.y2unit=(get(handles.editY2axis,'String'));
  
        switch data.dtype
            case 1
        data.y=b.*0;
            case 2
        data.y(:,1)=b.*0;        
        data.y(:,2)=b.*0;
            case 3
        data.y(:,1)=b.*0;        
        data.y(:,2)=b.*0;
        end
        assignin('base',dataname,data); 
        handles.output1 = data;
        handles.output2 = dataname;
        guidata(hObject, handles)
        uiresume(handles.figure1);
   end
   





