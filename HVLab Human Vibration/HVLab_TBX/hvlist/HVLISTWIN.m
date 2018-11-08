function varargout = HVLISTWIN(varargin)
% HVLISTWIN - issue 1.0 (20/02/2006)-HVLab HRV Toolbox
%-------------------------------------------------------------------------
% HVLISTWIN M-file for HVLISTWIN.fig
%      HVLISTWIN, by itself, creates a new HVLISTWIN or raises the existing
%      singleton*.
%
%      H = HVLISTWIN returns the handle to a new HVLISTWIN or the handle to
%      the existing singleton*.
%
%      HVLISTWIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HVLISTWIN.M with the given input arguments.
%
%      HVLISTWIN('Property','Value',...) creates a new HVLISTWIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HVLISTWIN_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HVLISTWIN_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Written by Pierre HUGUENET, February 2006

% Last Modified by GUIDE v2.5 16-Jun-2006 14:30:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HVLISTWIN_OpeningFcn, ...
                   'gui_OutputFcn',  @HVLISTWIN_OutputFcn, ...
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


% --- Executes just before HVLISTWIN is made visible.-----------------------
function HVLISTWIN_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HVLISTWIN (see VARARGIN)

% Choose default command line output for HVLISTWIN
handles.output = hObject;

set(handles.text6,'visible','off');
set(handles.text1,'visible','off');

%set initial value for "indicdatalist", indicator variable used to know if a
%data is actually listed in the window
handles.indicdatalist=0;

%check for data input
if isempty(varargin)
    %hvnewlistWin() %to un-comment if the created data window needs to be
    %opened automatically when launching hvlist()
    set(handles.textstatus,'string','Choose or create a data file to list');
    %update the listbox2 workspace
    update_listbox2(handles)
    
else

%update the listbox2 workspace
update_listbox2(handles)

%if data is present, display it in listbox1
%note: here there is no need to use hvcheckstruct to test the data as it is
%already tested by hvlist(), and user should normally use hvlist to launch
%this GUI.
    var=varargin{1};
    var2list=evalin('base',var);
    handles.var2list=var2list;
    handles.actvar=var;
    handles.indicdatalist=1;
    guidata(hObject, handles);
    set(handles.edit1,'string',1);
    set(handles.edit2,'string',0);
    set(handles.edit3,'string',0);
    set(handles.edit4,'string',0);
    update_listbox1(var2list,handles)
end

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = HVLISTWIN_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);

% Get default command line output from handles structure
varargout{1} = handles.output;


%--------------------------------------------------------------------------
%code for selection changes in listbox1 and 2
%--------------------------------------------------------------------------
% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)

if handles.indicdatalist~=0 %if data is listed
list=handles.var2list;
contents = get(hObject,'String') ;
liststr=str2num(contents{get(hObject,'Value')});
pointn=liststr(1);
%set the chosen values into the edit boxes
set(handles.edit1,'string',pointn);
set(handles.editfrom,'string',pointn);
set(handles.editto,'string',size(list.x,1));
set(handles.edit2,'string',list.x(pointn));
set(handles.edit3,'string',list.y(pointn,1));

switch list.dtype   
    case 1
set(handles.edit4,'visible','off');
    case 2
set(handles.edit4,'string',list.y(pointn,2));      
    case 3
set(handles.edit4,'string',list.y(pointn,2));
end
end

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%-------------------------------------------------------------------------
%following code set property of all 4 edit boxes to update listed data
%-------------------------------------------------------------------------
function edit1_Callback(hObject, eventdata, handles)

if handles.indicdatalist ~= 0 %if data is listed
    
test1=get(hObject,'String'); %loop to verify that edit box is not empty
test2=str2double(get(hObject,'String'));%or with NaN values
a=floor(abs(str2double(get(hObject,'String'))));%to limit values to positive integers
if isempty(test1) || isnan(test2) || isequal(a,0)
    set(hObject,'String',1);
else
    set(hObject,'String',a)
end


pointn=str2double(get(hObject,'String'));
list=handles.var2list;

if pointn <= size(list.x,1) %loop to set visible corresponding boxes
    set(handles.edit2,'string',list.x(pointn));
    set(handles.edit3,'string',list.y(pointn,1));
    switch list.dtype 
        case 1
    set(handles.edit4,'visible','off');
        case 2
    set(handles.edit4,'string',list.y(pointn,2));      
        case 3
    set(handles.edit4,'string',list.y(pointn,2));
    end
    set(handles.listbox1,'value',pointn)
else   
    set(handles.edit2,'string',0);
    set(handles.edit3,'string',0);
    switch list.dtype 
        case 1
    set(handles.edit4,'visible','off');
        case 2
    set(handles.edit4,'string',0);      
        case 3
    set(handles.edit4,'string',0);
    
    end
end
else
    set(hObject,'string',1);
end

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit2_Callback(hObject, eventdata, handles)

test1=get(hObject,'String'); %loop to verify that edit box is not empty
test2=str2double(get(hObject,'String'));%or with NaN values
if isempty(test1) || isnan(test2)
    set(hObject,'String',1);
end

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit3_Callback(hObject, eventdata, handles)

test1=get(hObject,'String'); %loop to verify that edit box is not empty
test2=str2double(get(hObject,'String'));%or with NaN values
if isempty(test1) || isnan(test2)
    set(hObject,'String',1);
end

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit4_Callback(hObject, eventdata, handles)

test1=get(hObject,'String'); %loop to verify that edit box is not empty
test2=str2double(get(hObject,'String'));%or with NaN values
if isempty(test1) || isnan(test2)
    set(hObject,'String',1);
end

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%-------------------------------------------------------------------------
%Following code corresponds to the programming of pushbuttons
%-------------------------------------------------------------------------

% --- Executes on button press in pushbuttonDispdata
function pushbuttonDispdata_Callback(hObject, eventdata, handles)

set(handles.listbox1,'value',1)
contents = get(handles.listbox2,'String');
a='workspace is empty';

if ~isempty(contents) && ~isequal(contents,a)
    var=contents{get(handles.listbox2,'Value')};
    var2list=evalin('base',var);
    handles.var2list=var2list;
    handles.actvar=var;
    handles.indicdatalist=1;
    guidata(hObject, handles);
    set(handles.edit1,'string',1);
    set(handles.edit2,'string',0);
    set(handles.edit3,'string',0);
    set(handles.edit4,'string',0);
    update_listbox1(var2list,handles)
end

%--------------------------------------------------------------------------
% --- Executes on button press in push button "create".
function pushbutton3_Callback(hObject, eventdata, handles)

[handles.var2list, handles.actvar]=HVNEWLISTWIN(); %calling for the window 'hvnewlistWin'

if isstruct(handles.var2list)
    
    update_listbox2(handles)
    
    v=get(handles.listbox2,'string');
    s = size(v,1);
 
     for i=1:s %loop created in order to know at which position is 
               %the new created variable in the list  
         C = strcmp(v(i),handles.actvar); %logical string comparison variable 
         
         if C == 1 %if the data name is found in the list
             set(handles.listbox2,'value',i) %choose this data
             guidata(hObject, handles); %update the handles structure
             pushbuttonDispdata_Callback(hObject, eventdata, handles) %display this data
         end
     end

else
    set(handles.textstatus,'string','Choose or create a data file to list');
end

%--------------------------------------------------------------------------
% --- Executes on button press in pushbuttondeletedata.
function pushbuttondeletedata_Callback(hObject, eventdata, handles)

set(handles.listbox1,'value',1);
contents = get(handles.listbox2,'String');
a='workspace is empty';

%loop for deleting chosen data in the workspace
if ~isempty(contents) && ~isequal(contents,a)
    var=contents{get(handles.listbox2,'Value')};
    
    if strfind(var,'(') %loop to ask if multichannel data is to be deleted
    txt=sprintf('''%s'' is part of a multichannel data structure. By deleting it, you will also delete all the data from other channels. Do you want to continue?',var);
    button = questdlg(txt,'Delete confirmation');    
    else    
    txt=sprintf('Deleting ''%s''. Do you want to continue?',var);
    button = questdlg(txt,'Delete confirmation');
    end
    
    if strcmp(button,'Yes') %delete confirmed by the user
        
        if strfind(var,'(') %loop to delete multichannel data
        k=strfind(var,'(');
        var=var(1:k-1);
        end
        
        exp=sprintf('clear %s',var);
        evalin('base',exp)
        fprintf('\n   ''%s''  deleted\n',var);
        set(handles.listbox2,'value',1);
        update_listbox2(handles) %update the workspace

            if handles.indicdatalist ~= 0 %if data is listed

                C = strcmp(var,handles.actvar); %logical string comparison variable  

                    if C == 1 %if the data deleted is the one which is listed  
                    set(handles.listbox1,'string','');
                    handles.indicdatalist=0;
                    txt=sprintf('''%s'' deleted. Select or create a data to list',var);
                    set(handles.textstatus,'string',txt);
                    end
            else
                txt=sprintf('''%s'' deleted. Select or create a data to list',var);
                set(handles.textstatus,'string',txt);
                handles.indicdatalist=0;

            end
    end 
end

guidata(hObject, handles);

%-------------------------------------------------------------------------
% --- Executes on button press in Update list.
function pushbuttonUpdvarlist_Callback(hObject, eventdata, handles)

update_listbox2(handles)

%-------------------------------------------------------------------------
% --- Executes on button press in pushbuttonExit.
function pushbuttonExit_Callback(hObject, eventdata, handles)

close

%------------------------------------------------------------------------
% --- Executes on button press in pushbuttonUpdata.
function pushbuttonUpdata_Callback(hObject, eventdata, handles)

if handles.indicdatalist ~= 0;

list=handles.var2list;

    pointindic=str2double(get(handles.edit1,'string'));
    newx=str2double(get(handles.edit2,'string'));
    newy1=str2double(get(handles.edit3,'string'));
    
%assign the new values to the corresponding row in the data
    list.x(pointindic,1)=newx; 
    list.y(pointindic,1)=newy1;
 
if list.dtype==2 || list.dtype==3
   newy2=str2double(get(handles.edit4,'string'));
   list.y(pointindic,1)=newy1;
   list.y(pointindic,2)=newy2;
end

handles.var2list=list;
var=handles.actvar;
assignin('base',var,list); %save the new variable in the workspace
guidata(hObject, handles);
update_listbox1(list,handles)

if pointindic>1 %set the cursor of listbox1 into the chosen line
set(handles.listbox1,'value',pointindic) 
end
else
     set(handles.textstatus,'string','Choose or create a data file to list');
end


%-------------------------------------------------------------------------
%Following code corresponds to the delete panel (1 button and 2 edit boxes)
%-------------------------------------------------------------------------

%set property of edit box editfrom-----------------------------------------
function editfrom_Callback(hObject, eventdata, handles)

if handles.indicdatalist == 1 %test if data is listed
    
test1=get(hObject,'String'); %loop to verify that edit box is not empty
test2=str2double(get(hObject,'String'));%or with NaN values
list=handles.var2list;
a=floor(abs(str2double(get(hObject,'String'))));%to limit values to positive integers

if isempty(test1) || isnan(test2) || isequal(a,0)
    set(hObject,'String',1);
elseif a > size(list.x,1)
    a=size(list.x,1);
    set(hObject,'String',a);
else
    set(hObject,'String',a);
end
else
    set(hObject,'string',1);
end

% --- Executes during object creation, after setting all properties.
function editfrom_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%set property of edit box editto-----------------------------------------
function editto_Callback(hObject, eventdata, handles)

if handles.indicdatalist == 1 %test if data is listed
    
test1=get(hObject,'String'); %loop to verify that edit box is not empty
test2=str2double(get(hObject,'String'));%or with NaN values
from=str2double(get(handles.editfrom,'string'));
list=handles.var2list;
a=floor(abs(str2double(get(hObject,'String'))));%to limit values to positive integers

if isempty(test1) || isnan(test2) || isequal(a,0)
    set(hObject,'String',1);
elseif a > size(list.x,1) 
    a=size(list.x,1);
    set(hObject,'String',a);
elseif a < from
    a=from;
    set(hObject,'String',a);
else
    set(hObject,'String',a);
end
else
    set(hObject,'string',1);
end
% --- Executes during object creation, after setting all properties.
function editto_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbuttondelete.-----------------------
function pushbuttondelete_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttondelete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.indicdatalist ~= 0 %if data is listed
    
list=handles.var2list;
var=handles.actvar;
leng=size(list.x,1);
set(handles.listbox1,'value',1);

from=str2double(get(handles.editfrom,'string'));
to=str2double(get(handles.editto,'string'));

if from == 1 && to == leng

    txt=sprintf('Deleting all the rows in %s. Do you want to continue?',var);
    button = questdlg(txt,'Delete confirmation');
    if strcmp(button,'Yes')
        
    [data] = HVMAKESTRUCT(list.title, list.yunit, list.xunit, list.dtype, list.dxvar, list.stats);

        data.x=0;
        if list.dtype==2 || list.dtype==3
           data.y(1,1:2)=0;
        else
           data.y=0;
        end
        list=data;
    end

elseif from == to
    txt=sprintf('Deleting row %d in %s. Do you want to continue?',from,var);
    button = questdlg(txt,'Delete confirmation');
    if strcmp(button,'Yes')
    
        list.x(from:to)=[];
        newy1=list.y(:,1);
        newy1(from:to)=[];
        if list.dtype==2 || list.dtype==3
           newy2=list.y(:,2);
           newy2(from:to)=[];
           list.y=[newy1,newy2];
        else
           list.y=[newy1];
        end
    end
else
    txt=sprintf('Deleting from row %d to row %d in %s. Do you want to continue?',from,to,var);
    button = questdlg(txt,'Delete confirmation');
    if strcmp(button,'Yes')
    
        list.x(from:to)=[];
        newy1=list.y(:,1);
        newy1(from:to)=[];
        if list.dtype==2 || list.dtype==3
           newy2=list.y(:,2);
           newy2(from:to)=[];
           list.y=[newy1,newy2];
        else
           list.y=[newy1];
        end
    end
end


handles.var2list=list;
assignin('base',var,list); %save the new data into the workspace
guidata(hObject, handles);
update_listbox1(list,handles)
else
     set(handles.textstatus,'string','Choose or create a data file to list');
end

set(handles.editfrom,'string',1);
set(handles.editto,'string',1);

%-------------------------------------------------------------------------
%following code corresponds to the functions required to update listbox 1
%and 2. Position of data in listbox 1 can be modified here
%-------------------------------------------------------------------------

%Assign corresponding string to list in listbox 1-------------------------
function update_listbox1(list,handles)

if handles.indicdatalist~=0 %if data is listed

set(handles.text6,'visible','on');
set(handles.text1,'visible','on');
txt=sprintf('Data listed: %s',handles.actvar);
set(handles.textstatus,'string',txt);
handles.indicdatalist=0;  
    switch list.dtype
        
    case 1
    %set appropriate names for the columns in the list according to the type
    %of data
    set(handles.text2,'visible','on');
    txt2=sprintf('x-scale: %s',list.xunit);
    set(handles.text2,'string',txt2);
    set(handles.text7,'visible','on');
    set(handles.text7,'string',txt2);
    set(handles.text3,'visible','on');
    txt3=sprintf('real (%s)',list.yunit);
    set(handles.text3,'string',txt3);
    set(handles.text8,'visible','on');
    set(handles.text8,'string',txt3);
    set(handles.text4,'visible','off');
    set(handles.text9,'visible','off');
    set(handles.edit4,'visible','off');
    
    length=size(list.x,1);
    lx=(round(list.x*10^5))/(10^5);%Create round values with 10^5 precision
    ly=(round(list.y*10^5))/(10^5);
    slx=num2str(lx,'%-10.7f');%Create corresponding string
    slx=slx(:,1:8); %Restict the value to print the firsts 8 numbers
    sly=num2str(ly,'%-10.7f');
    sly=sly(:,1:8);
    space1(1:length,1:18)=' '; %Create the space between values
    space2(1:length,1:20)=' '; %Create the space between values
    point(1:length)=1:length;
    point=point'; %create the counters
    p=num2str(point,'%g');
    widthp=size(p);widthp=widthp(2);
    p=p(:,1:widthp);
    
    listr={[p,space1,slx,space2,sly]}; %Create the list cell
    set(handles.listbox1,'string',listr)
    
    
    case 2
    %set appropriate names for the columns in the list according to the type
    %of data
    set(handles.text2,'visible','on');
    txt2=sprintf('x-scale: %s',list.xunit);
    set(handles.text2,'string',txt2);
    set(handles.text7,'visible','on');
    set(handles.text7,'string',txt2);
    set(handles.text3,'visible','on');
    txt3=sprintf('real (%s)',list.yunit);
    set(handles.text3,'string',txt3);
    set(handles.text8,'visible','on');
    set(handles.text8,'string',txt3);
    set(handles.text4,'visible','on');
    txt4=sprintf('imaginary (%s)',list.yunit);
    set(handles.text4,'string',txt4);
    set(handles.text9,'visible','on');
    set(handles.text9,'string',txt4);
    set(handles.edit4,'visible','on');
    
    length=size(list.x);length=length(1);
    lx=(round(list.x*10^5))/(10^5);%Create round values with 10^5 precision
    ly=(round(list.y*10^5))/(10^5);
    slx=num2str(lx,'%-10.7f');%Create corresponding string
    slx=slx(:,1:8); %Restict the value to print the firsts 8 numbers
    sly1=num2str(ly(:,1),'%-10.7f');
    sly1=sly1(:,1:8);
    sly2=num2str(ly(:,2),'%-10.7f');
    sly2=sly2(:,1:8);
    space1(1:length,1:18)=' '; %Create the space between values
    space2(1:length,1:20)=' '; %Create the space between values
    point(1:length)=1:length;
    point=point'; %create the counters
    p=num2str(point,'%g');
    widthp=size(p);widthp=widthp(2);
    p=p(:,1:widthp);
    
    listr={[p,space1,slx,space2,sly1,space2,sly2]}; %Create the list cell

    set(handles.listbox1,'string',listr)
    
    
    case 3
    %set appropriate names for the columns in the list according to the type
    %of data
    set(handles.text2,'visible','on');
    txt2=sprintf('x-scale: %s',list.xunit);
    set(handles.text2,'string',txt2);
    set(handles.text7,'visible','on');
    set(handles.text7,'string',txt2);
    set(handles.text3,'visible','on');
    txt3=sprintf('Modulus (%s)',list.yunit);
    set(handles.text3,'string',txt3);
    set(handles.text8,'visible','on');
    set(handles.text8,'string',txt3);
    set(handles.text4,'visible','on');
    txt4='phase (rad)';
    set(handles.text4,'string',txt4);
    set(handles.text9,'visible','on');
    set(handles.text9,'string',txt4);
    set(handles.edit4,'visible','on');
    
    length=size(list.x,1);
    lx=(round(list.x*10^5))/(10^5);%Create round values with 10^5 precision
    ly=(round(list.y*10^5))/(10^5);
    slx=num2str(lx,'%-10.7f');%Create corresponding string
    slx=slx(:,1:8); %Restict the value to print the firsts 8 numbers
    sly1=num2str(ly(:,1),'%-10.7f');
    sly1=sly1(:,1:8);
    sly2=num2str(ly(:,2),'%-10.7f');
    sly2=sly2(:,1:8);
    space1(1:length,1:18)=' '; %Create the space between values
    space2(1:length,1:20)=' '; %Create the space between values
    point(1:length)=1:length;
    point=point'; %create the counters
    p=num2str(point,'%g');
    widthp=size(p);widthp=widthp(2);
    p=p(:,1:widthp);
    
    listr={[p,space1,slx,space2,sly1,space2,sly2]}; %Create the list cell

    set(handles.listbox1,'string',listr)
    end
end

%-------------------------------------------------------------------------
%Populate the listbox 2 with only appropriate 'struct' data
%using 'hvcheckstruct' to remove incorrect data types.
function update_listbox2(handles)
vars = evalin('base','whos'); %Reading variables from workspace
s=size(vars,1);
if s==0
    set(handles.listbox2,'string','workspace is empty') %if workspace is empty
else
    m=0;
    for i=1:s %loop to read all variables and test them
        var2test=evalin('base',vars(i).name);
        validstruct=hvcheckstruct(var2test,2);
        
        if isequal(validstruct,1)       
           if size(var2test,2) > 1
               for j=1:size(var2test,2)
                   m=m+1;
                   name=sprintf('%s(%d)',vars(i).name,j);
                   var(m)={[name]};
               end
           else
               m=m+1;
               var(m)={[vars(i).name]};
           end
        end
    end
    
    if m==0
     txt=sprintf('No valid data structure to list \n Create a data file to list');
     set(handles.textstatus,'string',txt)
     set(handles.listbox2,'string','')
    else       
     set(handles.listbox2,'string',var) %update listbox 2
    end
    
end
set(handles.listbox2,'value',1) 

%-------------------------------------------------------------------------
%Following code corresponds to the coding of the menu
%-------------------------------------------------------------------------

% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
%function to export data file into excel .xls file
function export_Callback(hObject, eventdata, handles)
% hObject    handle to export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentdir=cd;

if handles.indicdatalist == 1 %test if data is listed
        list=(handles.var2list);
        switch list.dtype
            case 1
                xtxt=sprintf('X in (%s)',list.xunit);
                ytxt=sprintf('Real part in (%s)',list.yunit);
                dat1={xtxt, ytxt};
                dat2=[list.x,list.y(:,1)];
            case 2
                xtxt=sprintf('X in (%s)',list.xunit);
                y1txt=sprintf('Real part in (%s)',list.yunit);
                y2txt=sprintf('Imaginary part in (%s)',list.y2unit);
                dat1={xtxt, y1txt, y2txt};
                dat2=[list.x,list.y(:,1),list.y(:,2)];
            case 3
                xtxt=sprintf('X in (%s)',list.xunit);
                y1txt=sprintf('Modulus in (%s)',list.yunit);
                y2txt=sprintf('Phase in (%s)',list.y2unit);
                dat1={xtxt, y1txt, y2txt};
                dat2=[list.x,list.y(:,1),list.y(:,2)];  
        end
   
        [filename, pathname] = uiputfile('*.xls', 'Save the data as an excel file  (.xls)');
  
        if ~isequal(filename,0) %if user hasnt choose "cancel"          
        existfiles=dir;
        filename=handles.actvar;
        filename=sprintf('%s.xls',filename);
        directory1=pathname;
        eval(['cd ''',directory1,'''']);
             
               for q=1:length(existfiles)                 %loop to remove file  
                  if isequal(existfiles(q).name,filename) %when user accepted 
                      delete(filename)                    %to overwritte data
                  end
               end

        h = waitbar(0,'Please wait, exporting selected data to excel file');
        waitbar(1/3)
        xlswrite(filename, dat1, 'HVLab DATA ', 'B2');
        waitbar(2/3)
        xlswrite(filename, dat2, 'HVLab DATA ', 'B3');
        waitbar(3/3)
        txt=sprintf('Excel file %s created in %s',filename,directory1);
        set(handles.textstatus,'string',txt);
        close(h)         
         end
         
         eval(['cd ''',currentdir,'''']);
         
else %if no data is selected
    set(handles.textstatus,'string','No data selected for export');
end

% --------------------------------------------------------------------
function closewindow_Callback(hObject, eventdata, handles)

close

% --------------------------------------------------------------------
function createnew_Callback(hObject, eventdata, handles)

pushbutton3_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function about_Callback(hObject, eventdata, handles)

msg={'hvparameters edit window';'Version 1.0';'Written by Pierre HUGUENET, February 2006'};
msgbox(msg);




% --------------------------------------------------------------------
function import_Callback(hObject, eventdata, handles)
% hObject    handle to import (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Import data structure from a .das file

[filename, pathname] = uigetfile('*.das', 'Select a data file .das');

 if isequal(filename,0)
    %disp('User selected Cancel')
 else
    currentdirectory=cd;
    cd(pathname);
   txt=sprintf('%s=hvreadf(''%s'');',filename(1:size(filename,2)-4),filename);
    evalin('base',txt);
    update_listbox2(handles)
 end






