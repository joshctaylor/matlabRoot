function varargout = HVDATAGUI(varargin)
% HVDATAGUICALLBACKS - issue 2.0 (12/07/2006) - HVLab HRV Toolbox
%  ------------------------------------------------------------------------
%  
%      HVDATAGUI, by itself, creates a new HVDATAGUI or raises the existing
%      singleton*.
%
%      H = HVDATAGUI returns the handle to a new HVDATAGUI or the handle to
%      the existing singleton*.
%
%      HVDATAGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HVDATAGUI.M with the given input arguments.
%
%      HVDATAGUI('Property','Value',...) creates a new HVDATAGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HVDATAGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HVDATAGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HVDATAGUI

% Last Modified by GUIDE v2.5 12-Jun-2006 10:53:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HVDATAGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @HVDATAGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before HVDATAGUI is made visible.
function HVDATAGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HVDATAGUI (see VARARGIN)

% Choose default command line output for HVDATAGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HVDATAGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HVDATAGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function ch1title_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch1title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch1title_Callback(hObject, eventdata, handles)
% hObject    handle to ch1title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch1title as text
%        str2double(get(hObject,'String')) returns contents of ch1title as a double


% --- Executes during object creation, after setting all properties.
function ch1range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch1range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch1range_Callback(hObject, eventdata, handles)
% hObject    handle to ch1range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch1range as text
%        str2double(get(hObject,'String')) returns contents of ch1range as a double


% --- Executes during object creation, after setting all properties.
function ch1unit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch1unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch1unit_Callback(hObject, eventdata, handles)
% hObject    handle to ch1unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch1unit as text
%        str2double(get(hObject,'String')) returns contents of ch1unit as a double


% --- Executes during object creation, after setting all properties.
function ch2title_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch2title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch2title_Callback(hObject, eventdata, handles)
% hObject    handle to ch2title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch2title as text
%        str2double(get(hObject,'String')) returns contents of ch2title as a double


% --- Executes during object creation, after setting all properties.
function ch2range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch2range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch2range_Callback(hObject, eventdata, handles)
% hObject    handle to ch2range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch2range as text
%        str2double(get(hObject,'String')) returns contents of ch2range as a double


% --- Executes during object creation, after setting all properties.
function ch2unit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch2unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch2unit_Callback(hObject, eventdata, handles)
% hObject    handle to ch2unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch2unit as text
%        str2double(get(hObject,'String')) returns contents of ch2unit as a double


% --- Executes during object creation, after setting all properties.
function ch3title_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch3title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch3title_Callback(hObject, eventdata, handles)
% hObject    handle to ch3title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch3title as text
%        str2double(get(hObject,'String')) returns contents of ch3title as a double


% --- Executes during object creation, after setting all properties.
function ch3range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch3range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch3range_Callback(hObject, eventdata, handles)
% hObject    handle to ch3range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch3range as text
%        str2double(get(hObject,'String')) returns contents of ch3range as a double


% --- Executes during object creation, after setting all properties.
function ch3unit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch3unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch3unit_Callback(hObject, eventdata, handles)
% hObject    handle to ch3unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch3unit as text
%        str2double(get(hObject,'String')) returns contents of ch3unit as a double


% --- Executes during object creation, after setting all properties.
function ch4title_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch4title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch4title_Callback(hObject, eventdata, handles)
% hObject    handle to ch4title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch4title as text
%        str2double(get(hObject,'String')) returns contents of ch4title as a double


% --- Executes during object creation, after setting all properties.
function ch4range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch4range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch4range_Callback(hObject, eventdata, handles)
% hObject    handle to ch4range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch4range as text
%        str2double(get(hObject,'String')) returns contents of ch4range as a double


% --- Executes during object creation, after setting all properties.
function ch4unit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch4unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch4unit_Callback(hObject, eventdata, handles)
% hObject    handle to ch4unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch4unit as text
%        str2double(get(hObject,'String')) returns contents of ch4unit as a double


% --- Executes during object creation, after setting all properties.
function duration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function duration_Callback(hObject, eventdata, handles)
% hObject    handle to duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of duration as text
%        str2double(get(hObject,'String')) returns contents of duration as a double


% --- Executes during object creation, after setting all properties.
function srate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to srate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function srate_Callback(hObject, eventdata, handles)
% hObject    handle to srate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of srate as text
%        str2double(get(hObject,'String')) returns contents of srate as a double


% --- Executes during object creation, after setting all properties.
function nchans_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nchans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function nchans_Callback(hObject, eventdata, handles)
% hObject    handle to nchans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nchans as text
%        str2double(get(hObject,'String')) returns contents of nchans as a double



% --- Executes during object creation, after setting all properties.
function parfile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function parfile_Callback(hObject, eventdata, handles)
% hObject    handle to parfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of parfile as text
%        str2double(get(hObject,'String')) returns contents of parfile as a double


% --- Executes on button press in parload.
function parload_Callback(hObject, eventdata, handles)
% hObject    handle to parload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in parsave.
function parsave_Callback(hObject, eventdata, handles)
% hObject    handle to parsave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function ch5title_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch5title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch5title_Callback(hObject, eventdata, handles)
% hObject    handle to ch5title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch5title as text
%        str2double(get(hObject,'String')) returns contents of ch5title as a double


% --- Executes during object creation, after setting all properties.
function ch5range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch5range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch5range_Callback(hObject, eventdata, handles)
% hObject    handle to ch5range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch5range as text
%        str2double(get(hObject,'String')) returns contents of ch5range as a double


% --- Executes during object creation, after setting all properties.
function ch5unit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch5unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch5unit_Callback(hObject, eventdata, handles)
% hObject    handle to ch5unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch5unit as text
%        str2double(get(hObject,'String')) returns contents of ch5unit as a double


% --- Executes during object creation, after setting all properties.
function ch6title_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch6title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch6title_Callback(hObject, eventdata, handles)
% hObject    handle to ch6title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch6title as text
%        str2double(get(hObject,'String')) returns contents of ch6title as a double


% --- Executes during object creation, after setting all properties.
function edit36_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit36_Callback(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit36 as text
%        str2double(get(hObject,'String')) returns contents of edit36 as a double


% --- Executes during object creation, after setting all properties.
function ch6unit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch6unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch6unit_Callback(hObject, eventdata, handles)
% hObject    handle to ch6unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch6unit as text
%        str2double(get(hObject,'String')) returns contents of ch6unit as a double


% --- Executes during object creation, after setting all properties.
function ch7title_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch7title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch7title_Callback(hObject, eventdata, handles)
% hObject    handle to ch7title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch7title as text
%        str2double(get(hObject,'String')) returns contents of ch7title as a double


% --- Executes during object creation, after setting all properties.
function ch7range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch7range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch7range_Callback(hObject, eventdata, handles)
% hObject    handle to ch7range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch7range as text
%        str2double(get(hObject,'String')) returns contents of ch7range as a double


% --- Executes during object creation, after setting all properties.
function ch7unit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch7unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch7unit_Callback(hObject, eventdata, handles)
% hObject    handle to ch7unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch7unit as text
%        str2double(get(hObject,'String')) returns contents of ch7unit as a double


% --- Executes during object creation, after setting all properties.
function ch8title_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch8title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch8title_Callback(hObject, eventdata, handles)
% hObject    handle to ch8title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch8title as text
%        str2double(get(hObject,'String')) returns contents of ch8title as a double


% --- Executes during object creation, after setting all properties.
function ch8range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch8range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch8range_Callback(hObject, eventdata, handles)
% hObject    handle to ch8range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch8range as text
%        str2double(get(hObject,'String')) returns contents of ch8range as a double


% --- Executes during object creation, after setting all properties.
function ch8unit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch8unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch8unit_Callback(hObject, eventdata, handles)
% hObject    handle to ch8unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch8unit as text
%        str2double(get(hObject,'String')) returns contents of ch8unit as a double


% --- Executes during object creation, after setting all properties.
function ch9title_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch9title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch9title_Callback(hObject, eventdata, handles)
% hObject    handle to ch9title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch9title as text
%        str2double(get(hObject,'String')) returns contents of ch9title as a double


% --- Executes during object creation, after setting all properties.
function ch9range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch9range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch9range_Callback(hObject, eventdata, handles)
% hObject    handle to ch9range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch9range as text
%        str2double(get(hObject,'String')) returns contents of ch9range as a double


% --- Executes during object creation, after setting all properties.
function edit46_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit46_Callback(hObject, eventdata, handles)
% hObject    handle to edit46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit46 as text
%        str2double(get(hObject,'String')) returns contents of edit46 as a double


% --- Executes during object creation, after setting all properties.
function ch10title_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch10title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch10title_Callback(hObject, eventdata, handles)
% hObject    handle to ch10title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch10title as text
%        str2double(get(hObject,'String')) returns contents of ch10title as a double


% --- Executes during object creation, after setting all properties.
function ch10range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch10range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch10range_Callback(hObject, eventdata, handles)
% hObject    handle to ch10range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch10range as text
%        str2double(get(hObject,'String')) returns contents of ch10range as a double


% --- Executes during object creation, after setting all properties.
function ch10unit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch10unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch10unit_Callback(hObject, eventdata, handles)
% hObject    handle to ch10unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch10unit as text
%        str2double(get(hObject,'String')) returns contents of ch10unit as a double


% --- Executes during object creation, after setting all properties.
function ch11title_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch11title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch11title_Callback(hObject, eventdata, handles)
% hObject    handle to ch11title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch11title as text
%        str2double(get(hObject,'String')) returns contents of ch11title as a double


% --- Executes during object creation, after setting all properties.
function ch11range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch11range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch11range_Callback(hObject, eventdata, handles)
% hObject    handle to ch11range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch11range as text
%        str2double(get(hObject,'String')) returns contents of ch11range as a double


% --- Executes during object creation, after setting all properties.
function edit52_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit52_Callback(hObject, eventdata, handles)
% hObject    handle to edit52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit52 as text
%        str2double(get(hObject,'String')) returns contents of edit52 as a double


% --- Executes during object creation, after setting all properties.
function ch12title_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch12title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch12title_Callback(hObject, eventdata, handles)
% hObject    handle to ch12title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch12title as text
%        str2double(get(hObject,'String')) returns contents of ch12title as a double


% --- Executes during object creation, after setting all properties.
function ch12range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch12range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch12range_Callback(hObject, eventdata, handles)
% hObject    handle to ch12range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch12range as text
%        str2double(get(hObject,'String')) returns contents of ch12range as a double


% --- Executes during object creation, after setting all properties.
function ch12unit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch12unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch12unit_Callback(hObject, eventdata, handles)
% hObject    handle to ch12unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch12unit as text
%        str2double(get(hObject,'String')) returns contents of ch12unit as a double


% --- Executes during object creation, after setting all properties.
function ch13title_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch13title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch13title_Callback(hObject, eventdata, handles)
% hObject    handle to ch13title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch13title as text
%        str2double(get(hObject,'String')) returns contents of ch13title as a double


% --- Executes during object creation, after setting all properties.
function ch13range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch13range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch13range_Callback(hObject, eventdata, handles)
% hObject    handle to ch13range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch13range as text
%        str2double(get(hObject,'String')) returns contents of ch13range as a double


% --- Executes during object creation, after setting all properties.
function ch13unit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch13unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch13unit_Callback(hObject, eventdata, handles)
% hObject    handle to ch13unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch13unit as text
%        str2double(get(hObject,'String')) returns contents of ch13unit as a double


% --- Executes during object creation, after setting all properties.
function edit59_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit59_Callback(hObject, eventdata, handles)
% hObject    handle to edit59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit59 as text
%        str2double(get(hObject,'String')) returns contents of edit59 as a double


% --- Executes during object creation, after setting all properties.
function ch14range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch14range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch14range_Callback(hObject, eventdata, handles)
% hObject    handle to ch14range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch14range as text
%        str2double(get(hObject,'String')) returns contents of ch14range as a double


% --- Executes during object creation, after setting all properties.
function ch14unit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch14unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch14unit_Callback(hObject, eventdata, handles)
% hObject    handle to ch14unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch14unit as text
%        str2double(get(hObject,'String')) returns contents of ch14unit as a double


% --- Executes during object creation, after setting all properties.
function ch15title_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch15title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch15title_Callback(hObject, eventdata, handles)
% hObject    handle to ch15title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch15title as text
%        str2double(get(hObject,'String')) returns contents of ch15title as a double


% --- Executes during object creation, after setting all properties.
function ch15range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch15range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch15range_Callback(hObject, eventdata, handles)
% hObject    handle to ch15range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch15range as text
%        str2double(get(hObject,'String')) returns contents of ch15range as a double


% --- Executes during object creation, after setting all properties.
function edit64_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit64 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit64_Callback(hObject, eventdata, handles)
% hObject    handle to edit64 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit64 as text
%        str2double(get(hObject,'String')) returns contents of edit64 as a double


% --- Executes during object creation, after setting all properties.
function ch16title_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch16title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch16title_Callback(hObject, eventdata, handles)
% hObject    handle to ch16title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch16title as text
%        str2double(get(hObject,'String')) returns contents of ch16title as a double


% --- Executes during object creation, after setting all properties.
function ch16range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch16range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch16range_Callback(hObject, eventdata, handles)
% hObject    handle to ch16range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch16range as text
%        str2double(get(hObject,'String')) returns contents of ch16range as a double


% --- Executes during object creation, after setting all properties.
function ch16unit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch16unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch16unit_Callback(hObject, eventdata, handles)
% hObject    handle to ch16unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch16unit as text
%        str2double(get(hObject,'String')) returns contents of ch16unit as a double


% --- Executes during object creation, after setting all properties.
function ch14title_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch14title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch14title_Callback(hObject, eventdata, handles)
% hObject    handle to ch14title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch14title as text
%        str2double(get(hObject,'String')) returns contents of ch14title as a double


% --- Executes during object creation, after setting all properties.
function ch6range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch6range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch6range_Callback(hObject, eventdata, handles)
% hObject    handle to ch6range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch6range as text
%        str2double(get(hObject,'String')) returns contents of ch6range as a double


% --- Executes during object creation, after setting all properties.
function ch9unit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch9unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch9unit_Callback(hObject, eventdata, handles)
% hObject    handle to ch9unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch9unit as text
%        str2double(get(hObject,'String')) returns contents of ch9unit as a double


% --- Executes during object creation, after setting all properties.
function ch11unit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch11unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch11unit_Callback(hObject, eventdata, handles)
% hObject    handle to ch11unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch11unit as text
%        str2double(get(hObject,'String')) returns contents of ch11unit as a double


% --- Executes during object creation, after setting all properties.
function ch15unit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch15unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch15unit_Callback(hObject, eventdata, handles)
% hObject    handle to ch15unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch15unit as text
%        str2double(get(hObject,'String')) returns contents of ch15unit as a double


% --- Executes during object creation, after setting all properties.
function datfile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to datfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function datfile_Callback(hObject, eventdata, handles)
% hObject    handle to datfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of datfile as text
%        str2double(get(hObject,'String')) returns contents of datfile as a double


% --- Executes during object creation, after setting all properties.
function prevfile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prevfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function prevfile_Callback(hObject, eventdata, handles)
% hObject    handle to prevfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prevfile as text
%        str2double(get(hObject,'String')) returns contents of prevfile as a double


% --- Executes on button press in START.
function START_Callback(hObject, eventdata, handles)
% hObject    handle to START (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in continuous.
function continuous_Callback(hObject, eventdata, handles)
% hObject    handle to continuous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in STOP.
function STOP_Callback(hObject, eventdata, handles)
% hObject    handle to STOP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function ch1mon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch1mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch1mon_Callback(hObject, eventdata, handles)
% hObject    handle to ch1mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch1mon as text
%        str2double(get(hObject,'String')) returns contents of ch1mon as a double


% --- Executes during object creation, after setting all properties.
function ch2mon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch2mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch2mon_Callback(hObject, eventdata, handles)
% hObject    handle to ch2mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch2mon as text
%        str2double(get(hObject,'String')) returns contents of ch2mon as a double


% --- Executes during object creation, after setting all properties.
function ch3mon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch3mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch3mon_Callback(hObject, eventdata, handles)
% hObject    handle to ch3mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch3mon as text
%        str2double(get(hObject,'String')) returns contents of ch3mon as a double


% --- Executes during object creation, after setting all properties.
function ch4mon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch4mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch4mon_Callback(hObject, eventdata, handles)
% hObject    handle to ch4mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch4mon as text
%        str2double(get(hObject,'String')) returns contents of ch4mon as a double


% --- Executes during object creation, after setting all properties.
function edit87_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit87 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit87_Callback(hObject, eventdata, handles)
% hObject    handle to edit87 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit87 as text
%        str2double(get(hObject,'String')) returns contents of edit87 as a double


% --- Executes during object creation, after setting all properties.
function ch6mon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch6mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch6mon_Callback(hObject, eventdata, handles)
% hObject    handle to ch6mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch6mon as text
%        str2double(get(hObject,'String')) returns contents of ch6mon as a double


% --- Executes during object creation, after setting all properties.
function edit89_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit89 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit89_Callback(hObject, eventdata, handles)
% hObject    handle to edit89 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit89 as text
%        str2double(get(hObject,'String')) returns contents of edit89 as a double


% --- Executes during object creation, after setting all properties.
function ch8mon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch8mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch8mon_Callback(hObject, eventdata, handles)
% hObject    handle to ch8mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch8mon as text
%        str2double(get(hObject,'String')) returns contents of ch8mon as a double


% --- Executes during object creation, after setting all properties.
function ch9mon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch9mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch9mon_Callback(hObject, eventdata, handles)
% hObject    handle to ch9mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch9mon as text
%        str2double(get(hObject,'String')) returns contents of ch9mon as a double


% --- Executes during object creation, after setting all properties.
function ch10mon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch10mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch10mon_Callback(hObject, eventdata, handles)
% hObject    handle to ch10mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch10mon as text
%        str2double(get(hObject,'String')) returns contents of ch10mon as a double


% --- Executes during object creation, after setting all properties.
function ch11mon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch11mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch11mon_Callback(hObject, eventdata, handles)
% hObject    handle to ch11mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch11mon as text
%        str2double(get(hObject,'String')) returns contents of ch11mon as a double


% --- Executes during object creation, after setting all properties.
function edit94_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit94 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit94_Callback(hObject, eventdata, handles)
% hObject    handle to edit94 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit94 as text
%        str2double(get(hObject,'String')) returns contents of edit94 as a double


% --- Executes during object creation, after setting all properties.
function ch13mon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch13mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch13mon_Callback(hObject, eventdata, handles)
% hObject    handle to ch13mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch13mon as text
%        str2double(get(hObject,'String')) returns contents of ch13mon as a double


% --- Executes during object creation, after setting all properties.
function ch14mon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch14mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch14mon_Callback(hObject, eventdata, handles)
% hObject    handle to ch14mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch14mon as text
%        str2double(get(hObject,'String')) returns contents of ch14mon as a double


% --- Executes during object creation, after setting all properties.
function ch15mon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch15mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch15mon_Callback(hObject, eventdata, handles)
% hObject    handle to ch15mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch15mon as text
%        str2double(get(hObject,'String')) returns contents of ch15mon as a double


% --- Executes during object creation, after setting all properties.
function ch16mon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch16mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch16mon_Callback(hObject, eventdata, handles)
% hObject    handle to ch16mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch16mon as text
%        str2double(get(hObject,'String')) returns contents of ch16mon as a double


% --- Executes during object creation, after setting all properties.
function ch5mon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch5mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch5mon_Callback(hObject, eventdata, handles)
% hObject    handle to ch5mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch5mon as text
%        str2double(get(hObject,'String')) returns contents of ch5mon as a double


% --- Executes during object creation, after setting all properties.
function ch7mon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch7mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch7mon_Callback(hObject, eventdata, handles)
% hObject    handle to ch7mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch7mon as text
%        str2double(get(hObject,'String')) returns contents of ch7mon as a double


% --- Executes during object creation, after setting all properties.
function ch12mon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch12mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ch12mon_Callback(hObject, eventdata, handles)
% hObject    handle to ch12mon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch12mon as text
%        str2double(get(hObject,'String')) returns contents of ch12mon as a double


% --- Executes on button press in ch1scope.
function ch1scope_Callback(hObject, eventdata, handles)
% hObject    handle to ch1scope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch1scope


% --- Executes on button press in ch2scope.
function ch2scope_Callback(hObject, eventdata, handles)
% hObject    handle to ch2scope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch2scope


% --- Executes on button press in ch3scope.
function ch3scope_Callback(hObject, eventdata, handles)
% hObject    handle to ch3scope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch3scope


% --- Executes on button press in ch4scope.
function ch4scope_Callback(hObject, eventdata, handles)
% hObject    handle to ch4scope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch4scope


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6


% --- Executes on button press in ch6scope.
function ch6scope_Callback(hObject, eventdata, handles)
% hObject    handle to ch6scope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch6scope


% --- Executes on button press in radiobutton8.
function radiobutton8_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton8


% --- Executes on button press in ch8scope.
function ch8scope_Callback(hObject, eventdata, handles)
% hObject    handle to ch8scope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch8scope


% --- Executes on button press in ch9scope.
function ch9scope_Callback(hObject, eventdata, handles)
% hObject    handle to ch9scope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch9scope


% --- Executes on button press in ch10scope.
function ch10scope_Callback(hObject, eventdata, handles)
% hObject    handle to ch10scope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch10scope


% --- Executes on button press in radiobutton12.
function radiobutton12_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton12


% --- Executes on button press in ch12scope.
function ch12scope_Callback(hObject, eventdata, handles)
% hObject    handle to ch12scope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch12scope


% --- Executes on button press in radiobutton14.
function radiobutton14_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton14


% --- Executes on button press in ch14scope.
function ch14scope_Callback(hObject, eventdata, handles)
% hObject    handle to ch14scope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch14scope


% --- Executes on button press in radiobutton16.
function radiobutton16_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton16


% --- Executes on button press in ch16scope.
function ch16scope_Callback(hObject, eventdata, handles)
% hObject    handle to ch16scope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch16scope


% --- Executes on button press in ch5scope.
function ch5scope_Callback(hObject, eventdata, handles)
% hObject    handle to ch5scope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch5scope


% --- Executes on button press in ch7scope.
function ch7scope_Callback(hObject, eventdata, handles)
% hObject    handle to ch7scope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch7scope


% --- Executes on button press in ch11scope.
function ch11scope_Callback(hObject, eventdata, handles)
% hObject    handle to ch11scope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch11scope


% --- Executes on button press in ch13scope.
function ch13scope_Callback(hObject, eventdata, handles)
% hObject    handle to ch13scope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch13scope


% --- Executes on button press in ch15scope.
function ch15scope_Callback(hObject, eventdata, handles)
% hObject    handle to ch15scope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch15scope


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in scopenone.
function scopenone_Callback(hObject, eventdata, handles)
% hObject    handle to scopenone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function time_Callback(hObject, eventdata, handles)
% hObject    handle to time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time as text
%        str2double(get(hObject,'String')) returns contents of time as a double


% --- Executes during object creation, after setting all properties.
function ylim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ylim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ylim_Callback(hObject, eventdata, handles)
% hObject    handle to ylim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ylim as text
%        str2double(get(hObject,'String')) returns contents of ylim as a double


% --- Executes on button press in scopeon.
function scopeon_Callback(hObject, eventdata, handles)
% hObject    handle to scopeon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of scopeon


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in autoinc.
function autoinc_Callback(hObject, eventdata, handles)
% hObject    handle to autoinc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of autoinc


% --- Executes on button press in timedown.
function timedown_Callback(hObject, eventdata, handles)
% hObject    handle to timedown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in timeup.
function timeup_Callback(hObject, eventdata, handles)
% hObject    handle to timeup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in monitoracq.
function monitoracq_Callback(hObject, eventdata, handles)
% hObject    handle to monitoracq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of monitoracq


% --- Executes on button press in smean.
function smean_Callback(hObject, eventdata, handles)
% hObject    handle to smean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in srms.
function srms_Callback(hObject, eventdata, handles)
% hObject    handle to srms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in smax.
function smax_Callback(hObject, eventdata, handles)
% hObject    handle to smax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in smin.
function smin_Callback(hObject, eventdata, handles)
% hObject    handle to smin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in samax.
function samax_Callback(hObject, eventdata, handles)
% hObject    handle to samax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of samax


% --- Executes during object creation, after setting all properties.
function rangeall_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rangeall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function rangeall_Callback(hObject, eventdata, handles)
% hObject    handle to rangeall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rangeall as text
%        str2double(get(hObject,'String')) returns contents of rangeall as a double


% --- Executes during object creation, after setting all properties.
function unitall_CreateFcn(hObject, eventdata, handles)
% hObject    handle to unitall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function unitall_Callback(hObject, eventdata, handles)
% hObject    handle to unitall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of unitall as text
%        str2double(get(hObject,'String')) returns contents of unitall as a double


% --- Executes during object creation, after setting all properties.
function ch1v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch1v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in ch1v.
function ch1v_Callback(hObject, eventdata, handles)
% hObject    handle to ch1v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ch1v contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ch1v


% --- Executes during object creation, after setting all properties.
function ch2v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch2v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in ch2v.
function ch2v_Callback(hObject, eventdata, handles)
% hObject    handle to ch2v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ch2v contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ch2v


% --- Executes during object creation, after setting all properties.
function ch3v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch3v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in ch3v.
function ch3v_Callback(hObject, eventdata, handles)
% hObject    handle to ch3v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ch3v contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ch3v


% --- Executes during object creation, after setting all properties.
function ch4v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch4v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in ch4v.
function ch4v_Callback(hObject, eventdata, handles)
% hObject    handle to ch4v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ch4v contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ch4v


% --- Executes during object creation, after setting all properties.
function ch5v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch5v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in ch5v.
function ch5v_Callback(hObject, eventdata, handles)
% hObject    handle to ch5v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ch5v contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ch5v


% --- Executes during object creation, after setting all properties.
function listbox7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in listbox7.
function listbox7_Callback(hObject, eventdata, handles)
% hObject    handle to listbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox7


% --- Executes during object creation, after setting all properties.
function ch7v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch7v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in ch7v.
function ch7v_Callback(hObject, eventdata, handles)
% hObject    handle to ch7v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ch7v contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ch7v


% --- Executes during object creation, after setting all properties.
function listbox9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in listbox9.
function listbox9_Callback(hObject, eventdata, handles)
% hObject    handle to listbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox9 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox9


% --- Executes during object creation, after setting all properties.
function ch9v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch9v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in ch9v.
function ch9v_Callback(hObject, eventdata, handles)
% hObject    handle to ch9v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ch9v contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ch9v


% --- Executes during object creation, after setting all properties.
function ch10v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch10v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in ch10v.
function ch10v_Callback(hObject, eventdata, handles)
% hObject    handle to ch10v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ch10v contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ch10v


% --- Executes during object creation, after setting all properties.
function ch11v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch11v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in ch11v.
function ch11v_Callback(hObject, eventdata, handles)
% hObject    handle to ch11v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ch11v contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ch11v


% --- Executes during object creation, after setting all properties.
function ch12v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch12v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in ch12v.
function ch12v_Callback(hObject, eventdata, handles)
% hObject    handle to ch12v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ch12v contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ch12v


% --- Executes during object creation, after setting all properties.
function ch13v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch13v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in ch13v.
function ch13v_Callback(hObject, eventdata, handles)
% hObject    handle to ch13v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ch13v contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ch13v


% --- Executes during object creation, after setting all properties.
function ch14v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch14v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in ch14v.
function ch14v_Callback(hObject, eventdata, handles)
% hObject    handle to ch14v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ch14v contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ch14v


% --- Executes during object creation, after setting all properties.
function ch15v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch15v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in ch15v.
function ch15v_Callback(hObject, eventdata, handles)
% hObject    handle to ch15v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ch15v contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ch15v


% --- Executes during object creation, after setting all properties.
function ch16v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch16v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in ch16v.
function ch16v_Callback(hObject, eventdata, handles)
% hObject    handle to ch16v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ch16v contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ch16v


% --- Executes during object creation, after setting all properties.
function ch6v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch6v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in ch6v.
function ch6v_Callback(hObject, eventdata, handles)
% hObject    handle to ch6v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ch6v contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ch6v


% --- Executes during object creation, after setting all properties.
function ch8v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch8v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in ch8v.
function ch8v_Callback(hObject, eventdata, handles)
% hObject    handle to ch8v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ch8v contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ch8v


% --- Executes during object creation, after setting all properties.
function edit106_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit106 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit106_Callback(hObject, eventdata, handles)
% hObject    handle to edit106 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit106 as text
%        str2double(get(hObject,'String')) returns contents of edit106 as a double


% --- Executes during object creation, after setting all properties.
function edit107_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit107 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit107_Callback(hObject, eventdata, handles)
% hObject    handle to edit107 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit107 as text
%        str2double(get(hObject,'String')) returns contents of edit107 as a double


% --- Executes during object creation, after setting all properties.
function edit108_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit108 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit108_Callback(hObject, eventdata, handles)
% hObject    handle to edit108 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit108 as text
%        str2double(get(hObject,'String')) returns contents of edit108 as a double


% --- Executes during object creation, after setting all properties.
function edit109_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit109 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit109_Callback(hObject, eventdata, handles)
% hObject    handle to edit109 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit109 as text
%        str2double(get(hObject,'String')) returns contents of edit109 as a double


% --- Executes during object creation, after setting all properties.
function edit110_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit110 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit110_Callback(hObject, eventdata, handles)
% hObject    handle to edit110 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit110 as text
%        str2double(get(hObject,'String')) returns contents of edit110 as a double


% --- Executes during object creation, after setting all properties.
function edit111_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit111 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit111_Callback(hObject, eventdata, handles)
% hObject    handle to edit111 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit111 as text
%        str2double(get(hObject,'String')) returns contents of edit111 as a double


% --- Executes during object creation, after setting all properties.
function edit112_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit112 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit112_Callback(hObject, eventdata, handles)
% hObject    handle to edit112 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit112 as text
%        str2double(get(hObject,'String')) returns contents of edit112 as a double


% --- Executes during object creation, after setting all properties.
function edit113_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit113 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit113_Callback(hObject, eventdata, handles)
% hObject    handle to edit113 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit113 as text
%        str2double(get(hObject,'String')) returns contents of edit113 as a double


% --- Executes during object creation, after setting all properties.
function edit114_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit114 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit114_Callback(hObject, eventdata, handles)
% hObject    handle to edit114 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit114 as text
%        str2double(get(hObject,'String')) returns contents of edit114 as a double


% --- Executes during object creation, after setting all properties.
function edit115_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit115 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit115_Callback(hObject, eventdata, handles)
% hObject    handle to edit115 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit115 as text
%        str2double(get(hObject,'String')) returns contents of edit115 as a double


% --- Executes during object creation, after setting all properties.
function edit116_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit116 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit116_Callback(hObject, eventdata, handles)
% hObject    handle to edit116 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit116 as text
%        str2double(get(hObject,'String')) returns contents of edit116 as a double


% --- Executes during object creation, after setting all properties.
function edit117_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit117 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit117_Callback(hObject, eventdata, handles)
% hObject    handle to edit117 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit117 as text
%        str2double(get(hObject,'String')) returns contents of edit117 as a double


% --- Executes during object creation, after setting all properties.
function edit118_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit118 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit118_Callback(hObject, eventdata, handles)
% hObject    handle to edit118 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit118 as text
%        str2double(get(hObject,'String')) returns contents of edit118 as a double


% --- Executes during object creation, after setting all properties.
function edit119_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit119 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit119_Callback(hObject, eventdata, handles)
% hObject    handle to edit119 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit119 as text
%        str2double(get(hObject,'String')) returns contents of edit119 as a double


% --- Executes during object creation, after setting all properties.
function edit120_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit120 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit120_Callback(hObject, eventdata, handles)
% hObject    handle to edit120 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit120 as text
%        str2double(get(hObject,'String')) returns contents of edit120 as a double


% --- Executes during object creation, after setting all properties.
function edit121_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit121 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit121_Callback(hObject, eventdata, handles)
% hObject    handle to edit121 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit121 as text
%        str2double(get(hObject,'String')) returns contents of edit121 as a double


% --- Executes during object creation, after setting all properties.
function edit122_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit122 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit122_Callback(hObject, eventdata, handles)
% hObject    handle to edit122 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit122 as text
%        str2double(get(hObject,'String')) returns contents of edit122 as a double


% --- Executes during object creation, after setting all properties.
function edit123_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit123 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit123_Callback(hObject, eventdata, handles)
% hObject    handle to edit123 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit123 as text
%        str2double(get(hObject,'String')) returns contents of edit123 as a double


% --- Executes during object creation, after setting all properties.
function ffreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ffreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ffreq_Callback(hObject, eventdata, handles)
% hObject    handle to ffreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ffreq as text
%        str2double(get(hObject,'String')) returns contents of ffreq as a double


% --- Executes during object creation, after setting all properties.
function edit125_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit125 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit125_Callback(hObject, eventdata, handles)
% hObject    handle to edit125 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit125 as text
%        str2double(get(hObject,'String')) returns contents of edit125 as a double


% --- Executes during object creation, after setting all properties.
function directory_CreateFcn(hObject, eventdata, handles)
% hObject    handle to directory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function directory_Callback(hObject, eventdata, handles)
% hObject    handle to directory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of directory as text
%        str2double(get(hObject,'String')) returns contents of directory as a double


% --- Executes during object creation, after setting all properties.
function vall_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in vall.
function vall_Callback(hObject, eventdata, handles)
% hObject    handle to vall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns vall contents as cell array
%        contents{get(hObject,'Value')} returns selected item from vall


% --- Executes on button press in dispprev.
function dispprev_Callback(hObject, eventdata, handles)
% hObject    handle to dispprev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ch1or_Callback(hObject, eventdata, handles)
% hObject    handle to ch1or (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ch2or_Callback(hObject, eventdata, handles)
% hObject    handle to ch2or (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ch4or_Callback(hObject, eventdata, handles)
% hObject    handle to ch4or (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ch6or_Callback(hObject, eventdata, handles)
% hObject    handle to ch6or (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ch8or_Callback(hObject, eventdata, handles)
% hObject    handle to ch8or (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ch9or_Callback(hObject, eventdata, handles)
% hObject    handle to ch9or (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function checkbox10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ch11or_Callback(hObject, eventdata, handles)
% hObject    handle to ch11or (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ch12or_Callback(hObject, eventdata, handles)
% hObject    handle to ch12or (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function checkbox13_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ch14or_Callback(hObject, eventdata, handles)
% hObject    handle to ch14or (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function checkbox15_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ch16or_Callback(hObject, eventdata, handles)
% hObject    handle to ch16or (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in lockor.
function lockor_Callback(hObject, eventdata, handles)
% hObject    handle to lockor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lockor


% --- Executes on button press in checkor.
function checkor_Callback(hObject, eventdata, handles)
% hObject    handle to checkor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkor


% --------------------------------------------------------------------
function ch3or_Callback(hObject, eventdata, handles)
% hObject    handle to ch3or (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ch5or_Callback(hObject, eventdata, handles)
% hObject    handle to ch5or (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ch7or_Callback(hObject, eventdata, handles)
% hObject    handle to ch7or (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ch10or_Callback(hObject, eventdata, handles)
% hObject    handle to ch10or (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ch13or_Callback(hObject, eventdata, handles)
% hObject    handle to ch13or (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ch15or_Callback(hObject, eventdata, handles)
% hObject    handle to ch15or (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in sabs.
function sabs_Callback(hObject, eventdata, handles)
% hObject    handle to sabs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sabs


% --- Executes on button press in logtodisk.
function logtodisk_Callback(hObject, eventdata, handles)
% hObject    handle to logtodisk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of logtodisk


% --- Executes on button press in OPERATE.
function OPERATE_Callback(hObject, eventdata, handles)
% hObject    handle to OPERATE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in autostart.
function autostart_Callback(hObject, eventdata, handles)
% hObject    handle to autostart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of autostart


% --- Executes on button press in overwrite.
function overwrite_Callback(hObject, eventdata, handles)
% hObject    handle to overwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of overwrite


% --- Executes on button press in savestop.
function savestop_Callback(hObject, eventdata, handles)
% hObject    handle to savestop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of savestop


% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function chlen_Callback(hObject, eventdata, handles)
% hObject    handle to chlen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of chlen as text
%        str2double(get(hObject,'String')) returns contents of chlen as a double


% --- Executes during object creation, after setting all properties.
function chlen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chlen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function delay_Callback(hObject, eventdata, handles)
% hObject    handle to delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of delay as text
%        str2double(get(hObject,'String')) returns contents of delay as a double


% --- Executes during object creation, after setting all properties.
function delay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in fileinc.
function fileinc_Callback(hObject, eventdata, handles)
% hObject    handle to fileinc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fileinc


% --- Executes on selection change in fchan.
function fchan_Callback(hObject, eventdata, handles)
% hObject    handle to fchan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns fchan contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fchan


% --- Executes during object creation, after setting all properties.
function fchan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fchan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in lockzero.
function lockzero_Callback(hObject, eventdata, handles)
% hObject    handle to lockzero (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lockzero


