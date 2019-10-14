function varargout = scriptMaker(varargin)
% SCRIPTMAKER MATLAB code for scriptMaker.fig
%      SCRIPTMAKER, by itself, creates a new SCRIPTMAKER or raises the existing
%      singleton*.
%
%      H = SCRIPTMAKER returns the handle to a new SCRIPTMAKER or the handle to
%      the existing singleton*.
%
%      SCRIPTMAKER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCRIPTMAKER.M with the given input arguments.
%
%      SCRIPTMAKER('Property','Value',...) creates a new SCRIPTMAKER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before scriptMaker_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to scriptMaker_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help scriptMaker

% Last Modified by GUIDE v2.5 24-Jul-2019 13:17:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @scriptMaker_OpeningFcn, ...
                   'gui_OutputFcn',  @scriptMaker_OutputFcn, ...
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


% --- Executes just before scriptMaker is made visible.
function scriptMaker_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to scriptMaker (see VARARGIN)

% Choose default command line output for scriptMaker
handles.output = hObject;
lbox = {};
vals = [10:10:100]
for i = 1:10
    lbox{i} = num2str(vals(i));
end
handles.currVal.String = lbox'
handles.symmPminF = 0;
handles.symmPmaxF = 0;
handles.symmPsF = 0;
handles.pd1F = 0;
handles.pd2F = 0;
handles.P1minF = 0;
handles.P1maxF = 0;
handles.P2minF = 0;
handles.P2maxF = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes scriptMaker wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = scriptMaker_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in currVal.
function currVal_Callback(hObject, eventdata, handles)
% hObject    handle to currVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns currVal contents as cell array
%        contents{get(hObject,'Value')} returns selected item from currVal
if strcmp(hObject.Parent.SelectionType, 'open')
    temp = handles.currVal.String;
    temp(handles.currVal.Value) = [];
    handles.currVal.String = temp;
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function currVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in currValp1.
function currValp1_Callback(hObject, eventdata, handles)
% hObject    handle to currValp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns currValp1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from currValp1
if strcmp(hObject.Parent.SelectionType, 'open')
    temp1 = handles.currValp1.String;
    temp2 = handles.currValp2.String;
    temp1(handles.currValp1.Value) = [];
    temp2(handles.currValp2.Value) = [];
    handles.currValp1.String = temp1;
    handles.currValp2.String = temp2;
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function currValp1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currValp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in currValp2.
function currValp2_Callback(hObject, eventdata, handles)
% hObject    handle to currValp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns currValp2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from currValp2
if strcmp(hObject.Parent.SelectionType, 'open')
    temp1 = handles.currValp1.String;
    temp2 = handles.currValp2.String;
    temp1(handles.currValp1.Value) = [];
    temp2(handles.currValp2.Value) = [];
    handles.currValp1.String = temp1;
    handles.currValp2.String = temp2;
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function currValp2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currValp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in savepath.
function savepath_Callback(hObject, eventdata, handles)
% hObject    handle to savepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
saveDir = uigetdir(path,'Choose directory to save file');
            cd(saveDir)
            handles.savepath.Text = saveDir;
guidata(hObject, handles);

function filename_Callback(hObject, eventdata, handles)
% hObject    handle to filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filename as text
%        str2double(get(hObject,'String')) returns contents of filename as a double


% --- Executes during object creation, after setting all properties.
function filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in larp.
function larp_Callback(hObject, eventdata, handles)
% hObject    handle to larp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ralp.
function ralp_Callback(hObject, eventdata, handles)
% hObject    handle to ralp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in lhrh.
function lhrh_Callback(hObject, eventdata, handles)
% hObject    handle to lhrh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in ralpe.
function ralpe_Callback(hObject, eventdata, handles)
% hObject    handle to ralpe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ralpe contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ralpe


% --- Executes during object creation, after setting all properties.
function ralpe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ralpe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in larpe.
function larpe_Callback(hObject, eventdata, handles)
% hObject    handle to larpe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns larpe contents as cell array
%        contents{get(hObject,'Value')} returns selected item from larpe


% --- Executes during object creation, after setting all properties.
function larpe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to larpe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lhrhe.
function lhrhe_Callback(hObject, eventdata, handles)
% hObject    handle to lhrhe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lhrhe contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lhrhe


% --- Executes during object creation, after setting all properties.
function lhrhe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lhrhe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in cce.
function cce_Callback(hObject, eventdata, handles)
% hObject    handle to cce (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cce contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cce


% --- Executes during object creation, after setting all properties.
function cce_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cce (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in dise.
function dise_Callback(hObject, eventdata, handles)
% hObject    handle to dise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dise contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dise


% --- Executes during object creation, after setting all properties.
function dise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in animal.
function animal_Callback(hObject, eventdata, handles)
% hObject    handle to animal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns animal contents as cell array
%        contents{get(hObject,'Value')} returns selected item from animal
switch hObject.Value
    case 1 %GiGi Left Ear
        handles.larpe.Value = [4 5 6];
        handles.ralpe.Value = [1 2 3];
        handles.lhrhe.Value = [7 8 9];
    case 2 %MoMo Left Ear
        handles.larpe.Value = [7 8 9];
        handles.ralpe.Value = [1 2 3];
        handles.lhrhe.Value = [4 5 6];
    case 3 %Nancy
    case 4 %Yoda Right Ear
        handles.larpe.Value = [1 2 3];
        handles.ralpe.Value = [4 5 6 14];
        handles.larpe.Value = [7 8 9 15];
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function animal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to animal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function teensycom_Callback(hObject, eventdata, handles)
% hObject    handle to teensycom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of teensycom as text
%        str2double(get(hObject,'String')) returns contents of teensycom as a double


% --- Executes during object creation, after setting all properties.
function teensycom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to teensycom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function keithlycom_Callback(hObject, eventdata, handles)
% hObject    handle to keithlycom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of keithlycom as text
%        str2double(get(hObject,'String')) returns contents of keithlycom as a double


% --- Executes during object creation, after setting all properties.
function keithlycom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to keithlycom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
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
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in symPT.
function symPT_Callback(hObject, eventdata, handles)
% hObject    handle to symPT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of symPT
if hObject.Value
    handles.symmPTBox.Visible = 1;
    handles.currVal.Visible = 1;
    handles.currValsT.Visible = 1;
    handles.asymmPTBox.Visible = 0;
    handles.currValP1T.Visible = 0;
    handels.currValP2T.Visible = 0;
    handles.currValp1.Visible = 0;
    handles.currValp2.Visible = 0;
end
guidata(hObject, handles);

% --- Executes on button press in asymmPT.
function asymmPT_Callback(hObject, eventdata, handles)
% hObject    handle to asymmPT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of asymmPT
if hObject.Value
    handles.symmPTBox.Visible = 0;
    handles.currVal.Visible = 0;
    handles.currValsT.Visible = 0;
    handles.asymmPTBox.Visible = 1;
    handles.currValP1T.Visible = 1;
    handels.currValP2T.Visible = 1;
    handles.currValp1.Visible = 1;
    handles.currValp2.Visible = 1;
end
guidata(hObject, handles);

% --- Executes on button press in sin.
function sin_Callback(hObject, eventdata, handles)
% hObject    handle to sin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sin


% --- Executes on button press in motionmod.
function motionmod_Callback(hObject, eventdata, handles)
% hObject    handle to motionmod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of motionmod


% --- Executes on button press in bipolar.
function bipolar_Callback(hObject, eventdata, handles)
% hObject    handle to bipolar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bipolar


% --- Executes on button press in cccheck.
function cccheck_Callback(hObject, eventdata, handles)
% hObject    handle to cccheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cccheck


% --- Executes on button press in distantcheck.
function distantcheck_Callback(hObject, eventdata, handles)
% hObject    handle to distantcheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of distantcheck


% --- Executes on button press in digitalcoil.
function digitalcoil_Callback(hObject, eventdata, handles)
% hObject    handle to digitalcoil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of digitalcoil


% --- Executes on button press in cedspike2.
function cedspike2_Callback(hObject, eventdata, handles)
% hObject    handle to cedspike2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cedspike2



function p1d_Callback(hObject, eventdata, handles)
% hObject    handle to p1d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p1d as text
%        str2double(get(hObject,'String')) returns contents of p1d as a double
handles.pd1F = 1;
if handles.pd1F && handles.pd2F && ((handles.P1minF && handles.P1maxF && handles.symmPsF) || (handles.P2minF && handles.P2maxF && handles.symmPsF))
p1d = str2num(handles.p1d.String);
p2d = str2num(handles.p2d.String);
steps = str2num(handles.currstep2.String);
factor = p1d/p2d;
if handles.P1minF
    p1min = str2num(handles.p1min.String);
p1max = str2num(handles.p1max.String);
p1 = p1min:steps:pimax;
p2 = p1.*factor;
elseif handles.P2minF
    p2min = str2num(handles.p1min.String);
p2max = str2num(handles.p1max.String);
p2 = p2min:steps:p2max;
p1 = p2.*factor;
end

lbox1 = {};
lbox2 = {};
for i = 1:length(p2)
    lbox1{i} = num2str(p1(i));
    lbox2{i} = num2str(p2(i));
end
handles.currValp1.String = lbox1'
handles.currValp2.String = lbox2'


end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function p1d_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p1d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function p1min_Callback(hObject, eventdata, handles)
% hObject    handle to p1min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p1min as text
%        str2double(get(hObject,'String')) returns contents of p1min as a double
handles.P1minF = 1;
if handles.pd1F && handles.pd2F && ((handles.P1minF && handles.P1maxF && handles.symmPsF) || (handles.P2minF && handles.P2maxF && handles.symmPsF))
p1d = str2num(handles.p1d.String);
p2d = str2num(handles.p2d.String);
steps = str2num(handles.currstep2.String);
factor = p1d/p2d;
if handles.P1minF
    p1min = str2num(handles.p1min.String);
p1max = str2num(handles.p1max.String);
p1 = p1min:steps:pimax;
p2 = p1.*factor;
elseif handles.P2minF
    p2min = str2num(handles.p1min.String);
p2max = str2num(handles.p1max.String);
p2 = p2min:steps:p2max;
p1 = p2.*factor;
end

lbox1 = {};
lbox2 = {};
for i = 1:length(p2)
    lbox1{i} = num2str(p1(i));
    lbox2{i} = num2str(p2(i));
end
handles.currValp1.String = lbox1'
handles.currValp2.String = lbox2'


end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function p1min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p1min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function p1max_Callback(hObject, eventdata, handles)
% hObject    handle to p1max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p1max as text
%        str2double(get(hObject,'String')) returns contents of p1max as a double
handles.P1maxF = 1;
if handles.pd1F && handles.pd2F && ((handles.P1minF && handles.P1maxF && handles.symmPsF) || (handles.P2minF && handles.P2maxF && handles.symmPsF))
p1d = str2num(handles.p1d.String);
p2d = str2num(handles.p2d.String);
steps = str2num(handles.currstep2.String);
factor = p1d/p2d;
if handles.P1minF
    p1min = str2num(handles.p1min.String);
p1max = str2num(handles.p1max.String);
p1 = p1min:steps:pimax;
p2 = p1.*factor;
elseif handles.P2minF
    p2min = str2num(handles.p1min.String);
p2max = str2num(handles.p1max.String);
p2 = p2min:steps:p2max;
p1 = p2.*factor;
end

lbox1 = {};
lbox2 = {};
for i = 1:length(p2)
    lbox1{i} = num2str(p1(i));
    lbox2{i} = num2str(p2(i));
end
handles.currValp1.String = lbox1'
handles.currValp2.String = lbox2'


end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function p1max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p1max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function p2d_Callback(hObject, eventdata, handles)
% hObject    handle to p2d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p2d as text
%        str2double(get(hObject,'String')) returns contents of p2d as a double
handles.pd2F = 1;
if handles.pd1F && handles.pd2F && ((handles.P1minF && handles.P1maxF && handles.symmPsF) || (handles.P2minF && handles.P2maxF && handles.symmPsF))
p1d = str2num(handles.p1d.String);
p2d = str2num(handles.p2d.String);
steps = str2num(handles.currstep2.String);
factor = p1d/p2d;
if handles.P1minF
    p1min = str2num(handles.p1min.String);
p1max = str2num(handles.p1max.String);
p1 = p1min:steps:pimax;
p2 = p1.*factor;
elseif handles.P2minF
    p2min = str2num(handles.p1min.String);
p2max = str2num(handles.p1max.String);
p2 = p2min:steps:p2max;
p1 = p2.*factor;
end

lbox1 = {};
lbox2 = {};
for i = 1:length(p2)
    lbox1{i} = num2str(p1(i));
    lbox2{i} = num2str(p2(i));
end
handles.currValp1.String = lbox1'
handles.currValp2.String = lbox2'


end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function p2d_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p2d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function p2min_Callback(hObject, eventdata, handles)
% hObject    handle to p2min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p2min as text
%        str2double(get(hObject,'String')) returns contents of p2min as a double
handles.P2minF = 1;
if handles.pd1F && handles.pd2F && ((handles.P1minF && handles.P1maxF && handles.symmPsF) || (handles.P2minF && handles.P2maxF && handles.symmPsF))
p1d = str2num(handles.p1d.String);
p2d = str2num(handles.p2d.String);
steps = str2num(handles.currstep2.String);
factor = p1d/p2d;
if handles.P1minF
    p1min = str2num(handles.p1min.String);
p1max = str2num(handles.p1max.String);
p1 = p1min:steps:pimax;
p2 = p1.*factor;
elseif handles.P2minF
    p2min = str2num(handles.p1min.String);
p2max = str2num(handles.p1max.String);
p2 = p2min:steps:p2max;
p1 = p2.*factor;
end

lbox1 = {};
lbox2 = {};
for i = 1:length(p2)
    lbox1{i} = num2str(p1(i));
    lbox2{i} = num2str(p2(i));
end
handles.currValp1.String = lbox1'
handles.currValp2.String = lbox2'


end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function p2min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p2min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function p2max_Callback(hObject, eventdata, handles)
% hObject    handle to p2max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p2max as text
%        str2double(get(hObject,'String')) returns contents of p2max as a double
handles.P2maxF = 1;
if handles.pd1F && handles.pd2F && ((handles.P1minF && handles.P1maxF && handles.symmPsF) || (handles.P2minF && handles.P2maxF && handles.symmPsF))
p1d = str2num(handles.p1d.String);
p2d = str2num(handles.p2d.String);
steps = str2num(handles.currstep2.String);
factor = p1d/p2d;
if handles.P1minF
    p1min = str2num(handles.p1min.String);
p1max = str2num(handles.p1max.String);
p1 = p1min:steps:pimax;
p2 = p1.*factor;
elseif handles.P2minF
    p2min = str2num(handles.p1min.String);
p2max = str2num(handles.p1max.String);
p2 = p2min:steps:p2max;
p1 = p2.*factor;
end

lbox1 = {};
lbox2 = {};
for i = 1:length(p2)
    lbox1{i} = num2str(p1(i));
    lbox2{i} = num2str(p2(i));
end
handles.currValp1.String = lbox1'
handles.currValp2.String = lbox2'


end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function p2max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p2max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function currstep2_Callback(hObject, eventdata, handles)
% hObject    handle to currstep2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of currstep2 as text
%        str2double(get(hObject,'String')) returns contents of currstep2 as a double
handles.symmPsF = 1;

if handles.pd1F && handles.pd2F && ((handles.P1minF && handles.P1maxF && handles.symmPsF) || (handles.P2minF && handles.P2maxF && handles.symmPsF))
p1d = str2num(handles.p1d.String);
p2d = str2num(handles.p2d.String);
steps = str2num(handles.currstep2.String2);
factor = p1d/p2d;
if handles.P1minF
    p1min = str2num(handles.p1min.String);
p1max = str2num(handles.p1max.String);
p1 = p1min:steps:pimax;
p2 = p1.*factor;
elseif handles.P2minF
    p2min = str2num(handles.p1min.String);
p2max = str2num(handles.p1max.String);
p2 = p2min:steps:p2max;
p1 = p2.*factor;
end

lbox1 = {};
lbox2 = {};
for i = 1:length(p2)
    lbox1{i} = num2str(p1(i));
    lbox2{i} = num2str(p2(i));
end
handles.currValp1.String = lbox1';
handles.currValp2.String = lbox2';


end

guidata(hObject, handles);


function currstep_Callback(hObject, eventdata, handles)
handles.symmPsF = 1;

if handles.symmPminF+handles.symmPmaxF+handles.symmPsF ==3
    vals = [str2num(handles.cam.String):str2num(handles.currstep.String):str2num(handles.camax.String)];
    lbox = {};
handles.currVal.String = {};
for i = 1:length(vals)
    lbox{i} = num2str(vals(i));
end
handles.currVal.String = lbox'
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function currstep2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currstep2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dur_Callback(hObject, eventdata, handles)
% hObject    handle to dur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dur as text
%        str2double(get(hObject,'String')) returns contents of dur as a double


% --- Executes during object creation, after setting all properties.
function dur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rate_Callback(hObject, eventdata, handles)
% hObject    handle to rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rate as text
%        str2double(get(hObject,'String')) returns contents of rate as a double


% --- Executes during object creation, after setting all properties.
function rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gap_Callback(hObject, eventdata, handles)
% hObject    handle to gap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gap as text
%        str2double(get(hObject,'String')) returns contents of gap as a double


% --- Executes during object creation, after setting all properties.
function gap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cyc_Callback(hObject, eventdata, handles)
% hObject    handle to cyc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cyc as text
%        str2double(get(hObject,'String')) returns contents of cyc as a double


% --- Executes during object creation, after setting all properties.
function cyc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cyc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ipg_Callback(hObject, eventdata, handles)
% hObject    handle to ipg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ipg as text
%        str2double(get(hObject,'String')) returns contents of ipg as a double


% --- Executes during object creation, after setting all properties.
function ipg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ipg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function camax_Callback(hObject, eventdata, handles)
% hObject    handle to camax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of camax as text
%        str2double(get(hObject,'String')) returns contents of camax as a double
handles.symmPmaxF = 1;
if handles.symmPminF+handles.symmPmaxF+handles.symmPsF ==3
    vals = [str2num(handles.cam.String):str2num(handles.currstep2.String):str2num(handles.camax.String)];
    lbox = {};
handles.currVal.String = {};
for i = 1:length(vals)
    lbox{i} = num2str(vals(i));
end
handles.currVal.String = lbox'
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function camax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to camax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pd_Callback(hObject, eventdata, handles)
% hObject    handle to pd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pd as text
%        str2double(get(hObject,'String')) returns contents of pd as a double


% --- Executes during object creation, after setting all properties.
function pd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cam_Callback(hObject, eventdata, handles)
% hObject    handle to cam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cam as text
%        str2double(get(hObject,'String')) returns contents of cam as a double
handles.symmPminF = 1;
if handles.symmPminF+handles.symmPmaxF+handles.symmPsF ==3
    vals = [str2num(handles.cam.String):str2num(handles.currstep2.String):str2num(handles.camax.String)];
    lbox = {};
handles.currVal.String = {};
for i = 1:length(vals)
    lbox{i} = num2str(vals(i));
end
handles.currVal.String = lbox'
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function cam_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
