function varargout = generateSubplotFigures(varargin)
% GENERATESUBPLOTFIGURES MATLAB code for generateSubplotFigures.fig
%      GENERATESUBPLOTFIGURES, by itself, creates a new GENERATESUBPLOTFIGURES or raises the existing
%      singleton*.
%
%      H = GENERATESUBPLOTFIGURES returns the handle to a new GENERATESUBPLOTFIGURES or the handle to
%      the existing singleton*.
%
%      GENERATESUBPLOTFIGURES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GENERATESUBPLOTFIGURES.M with the given input arguments.
%
%      GENERATESUBPLOTFIGURES('Property','Value',...) creates a new GENERATESUBPLOTFIGURES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before generateSubplotFigures_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to generateSubplotFigures_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help generateSubplotFigures

% Last Modified by GUIDE v2.5 02-Aug-2019 08:55:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @generateSubplotFigures_OpeningFcn, ...
                   'gui_OutputFcn',  @generateSubplotFigures_OutputFcn, ...
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


% --- Executes just before generateSubplotFigures is made visible.
function generateSubplotFigures_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to generateSubplotFigures (see VARARGIN)

% Choose default command line output for generateSubplotFigures
handles.output = hObject;

handles.colors.l_x = [237,150,33]/255;
handles.colors.l_y = [125,46,143]/255;
handles.colors.l_z = [1 0 0];
handles.colors.l_l = [0,128,0]/255;
handles.colors.l_r = [0 0 1];
handles.colors.r_x = [237,204,33]/255;
handles.colors.r_y = [125,46,230]/255;
handles.colors.r_z = [255,0,255]/255;
handles.colors.r_l = [0 1 0];
handles.colors.r_r = [64,224,208]/255;

handles.colors.hV_l = [54 73 78]/255;
handles.colors.hV_r = [115 119 129]/255;
handles.colors.hV_z = [0 0 0];
handles = changeENum(handles);
handles.LEyeFlag.BackgroundColor = 'r';
handles.REyeFlag.BackgroundColor = 'r';
handles.normNum.Max = length(handles.normNum.String);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes generateSubplotFigures wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = generateSubplotFigures_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in cycledirectory.
function cycledirectory_Callback(hObject, eventdata, handles)
% hObject    handle to cycledirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.cycDir = uigetdir(path,'Choose directory of cycle files');
cd(handles.cycDir)
handles.listing = dir(handles.cycDir);
handles.cycledirectorytext.String = handles.cycDir;
guidata(hObject, handles);

% --- Executes on button press in figurepath.
function figurepath_Callback(hObject, eventdata, handles)
% hObject    handle to figurepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.figDir = uigetdir(path,'Choose directory for saved figures');
handles.figurepathtext.String = handles.figDir;
guidata(hObject, handles);

% --- Executes on selection change in larpelectrodes.
function larpelectrodes_Callback(hObject, eventdata, handles)
% hObject    handle to larpelectrodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns larpelectrodes contents as cell array
%        contents{get(hObject,'Value')} returns selected item from larpelectrodes


% --- Executes during object creation, after setting all properties.
function larpelectrodes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to larpelectrodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ralpelectrodes.
function ralpelectrodes_Callback(hObject, eventdata, handles)
% hObject    handle to ralpelectrodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ralpelectrodes contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ralpelectrodes


% --- Executes during object creation, after setting all properties.
function ralpelectrodes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ralpelectrodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lhrhelectrodes.
function lhrhelectrodes_Callback(hObject, eventdata, handles)
% hObject    handle to lhrhelectrodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lhrhelectrodes contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lhrhelectrodes


% --- Executes during object creation, after setting all properties.
function lhrhelectrodes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lhrhelectrodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in larp.
function larp_Callback(hObject, eventdata, handles)
% hObject    handle to larp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of larp


% --- Executes on button press in ralp.
function ralp_Callback(hObject, eventdata, handles)
% hObject    handle to ralp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ralp


% --- Executes on button press in lhrh.
function lhrh_Callback(hObject, eventdata, handles)
% hObject    handle to lhrh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lhrh


% --- Executes on button press in ahit.
function ahit_Callback(hObject, eventdata, handles)
% hObject    handle to ahit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.coildata.Value = 0;
% Hint: get(hObject,'Value') returns toggle state of ahit


% --- Executes on button press in coildata.
function coildata_Callback(hObject, eventdata, handles)
% hObject    handle to coildata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ahit.Value = 0;
% Hint: get(hObject,'Value') returns toggle state of coildata


% --- Executes on button press in light.
function light_Callback(hObject, eventdata, handles)
% hObject    handle to light (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of light


% --- Executes on button press in dark.
function dark_Callback(hObject, eventdata, handles)
% hObject    handle to dark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dark


% --- Executes on button press in stimulatingE.
function stimulatingE_Callback(hObject, eventdata, handles)
% hObject    handle to stimulatingE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.referenceE.Value = 0;
% Hint: get(hObject,'Value') returns toggle state of stimulatingE


% --- Executes on button press in referenceE.
function referenceE_Callback(hObject, eventdata, handles)
% hObject    handle to referenceE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.stimulatingE.Value = 0;
% Hint: get(hObject,'Value') returns toggle state of referenceE


% --- Executes on button press in bipolarstim.
function bipolarstim_Callback(hObject, eventdata, handles)
% hObject    handle to bipolarstim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bipolarstim


% --- Executes on button press in ccstim.
function ccstim_Callback(hObject, eventdata, handles)
% hObject    handle to ccstim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ccstim


% --- Executes on button press in distantstim.
function distantstim_Callback(hObject, eventdata, handles)
% hObject    handle to distantstim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of distantstim


% --- Executes on selection change in commoncrus.
function commoncrus_Callback(hObject, eventdata, handles)
% hObject    handle to commoncrus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns commoncrus contents as cell array
%        contents{get(hObject,'Value')} returns selected item from commoncrus


% --- Executes during object creation, after setting all properties.
function commoncrus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to commoncrus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in distant.
function distant_Callback(hObject, eventdata, handles)
% hObject    handle to distant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns distant contents as cell array
%        contents{get(hObject,'Value')} returns selected item from distant


% --- Executes during object creation, after setting all properties.
function distant_CreateFcn(hObject, eventdata, handles)
% hObject    handle to distant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in process.
function process_Callback(hObject, eventdata, handles)
% hObject    handle to process (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.process.BackgroundColor = 'y';
handles.params = [];
handles.avgMisalignPlot3DP2 = [];
handles.avgMisalignPlot3Dipg = [];
handles.savePos = 1;
if handles.coildata.Value
    handles = plotCond(handles);
    handles.allInds = [];
    for i = 1:sum(handles.LRZ) %L vs R vs Z
        handles = getfigE(handles,i);
        for j = 1:length(handles.figE)
            handles = getaxE(handles,i,j);
            for k = 1:length(handles.axE)
                if handles.stimulatingE.Value
                    handles.currmaxNorm = handles.allCombs(ismember(handles.allCombs(:,1:2),[handles.figE(j) handles.axE(k)],'rows'),3);
                elseif handles.referenceE.Value
                    handles.currmaxNorm = handles.allCombs(ismember(handles.allCombs(:,1:2),[handles.axE(k) handles.figE(j)],'rows'),3);
                end
                for l = 1:handles.currmaxNorm
                    switch handles.directions(i)
                        
                    end
                    if handles.curr.Value
                        %handles = plotCurrentAsX(handles,i,j,k,l);
                        %handles = plotCurrentAsXAllOnOne(handles,i,j,k,l);
                        handles = plotCurrentAsXSaveComp(handles,i,j,k,l);
                    elseif handles.p1d.Value
                    elseif handles.p2d.Value && handles.ipg.Value
                        handles = plotP2dIPGasX_new(handles,i,j,k,l);
                    end
                end
            end
        end
    end
elseif handles.ahit.Value
end
if isfile('Plots.mat')
    load('Plots.mat')
    for q = 1:length(handles.saved)
        eqA = [];
        for q2 = 1:length(Plots.saved)
            if isequal(handles.saved(q),Plots.saved(q2))
                eqA = [eqA 1];
            else
                eqA = [eqA 0];
            end
        end
        if ~(any(eqA))
            a = handles.saved(q).animal;
            d = handles.saved(q).date;
            fd = handles.saved(q).dir;
            s = handles.saved(q).stim;
            r = handles.saved(q).ref;
            e = handles.saved(q).ePlot;
            Plots.(a).(d).(fd).(s).(r).(e) = handles.(a).(d).(fd).(s).(r).(e);
            Plots.saved = [Plots.saved handles.saved(q)];
            if q == length(handles.saved)
                save('Plots.mat','Plots')
            end
        end
        
    end
else
    animal = handles.configByAnimal.String{handles.configByAnimal.Value};
    Plots = struct();
    Plots.(animal) = handles.(animal);
    Plots.saved = handles.saved;
    save('Plots.mat','Plots')
end
close(handles.fBar)
close(handles.avgMisalignPlot3D)
    close(handles.avgMagPlot)
    close(handles.avgMisalignPlot)
handles.process.BackgroundColor = 'g';
pause(1)
handles.process.BackgroundColor = [.94 .94 .94];

% --- Executes on selection change in configByAnimal.
function configByAnimal_Callback(hObject, eventdata, handles)
% hObject    handle to configByAnimal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns configByAnimal contents as cell array
%        contents{get(hObject,'Value')} returns selected item from configByAnimal
handles = changeENum(handles);
guidata(hObject, handles);

function handles = changeENum(handles)
switch handles.configByAnimal.Value
    case 1 %GiGi Left Ear
        handles.larpelectrodes.Value = [4 5 6];
        handles.ralpelectrodes.Value = [1 2 3];
        handles.lhrhelectrodes.Value = [7 8 9];
        handles.commoncrus.Value = [11];
        handles.distant.Value = [10];
    case 2 %MoMo Left Ear
        handles.larpelectrodes.Value = [7 8 9];
        handles.ralpelectrodes.Value = [1 2 3];
        handles.lhrhelectrodes.Value = [4 5 6];
        handles.commoncrus.Value = [11];
        handles.distant.Value = [10];
    case 3 %Nancy Left Ear
         handles.larpelectrodes.Value = [4 5 6 14];
        handles.ralpelectrodes.Value = [1 2 3];
       handles.lhrhelectrodes.Value = [7 8 9 15];
         handles.commoncrus.Value = [11 12 13];
          handles.distant.Value = [10];
    case 4 %Yoda Right Ear
        handles.larpelectrodes.Value = [1 2 3];
        handles.ralpelectrodes.Value = [4 5 6 14];
        handles.lhrhelectrodes.Value = [7 8 9 15];
        handles.commoncrus.Value = [11 12 13];
        handles.distant.Value = [10];
end

function [avgMisalign, maxMag, w] = maxMagThreshR(s,handles,Results)
    [mag, imag] = max(sqrt((Results.rl_cyc(s,1:(100))).^2+(Results.rr_cyc(s,1:(100))).^2+(Results.rz_cyc(s,1:(100))).^2));
    if mag>40
          [mag, imag] = max(sqrt((Results.rl_cyc(s,1:(30))).^2+(Results.rr_cyc(s,1:(30))).^2+(Results.rz_cyc(s,1:(30))).^2));
    [~,maj]=min([mag-max(abs(Results.rl_cyc(s,1:(30)))) mag-max(abs(Results.rr_cyc(s,1:(30)))) mag-max(abs(Results.rz_cyc(s,1:(30))))]);
   
    switch maj
        case 1
            if (Results.rl_cyc(s,20)-Results.rl_cyc(s,1))>0
                
                if ~isempty(find(Results.rl_cyc(s,20:100)<0,1))
                    cutOff = find(Results.rl_cyc(s,20:100)<0,1)+19;
                else
                    cutOff = 100;
                end
            elseif (Results.rl_cyc(s,20)-Results.rl_cyc(s,1))<0
                if ~isempty(find(Results.rl_cyc(s,20:100)>0,1))
                    cutOff = find(Results.rl_cyc(s,20:100)>0,1)+19;
                else
                    cutOff = 100;
                end
            end
        case 2
            if (Results.rr_cyc(s,20)-Results.rr_cyc(s,1))>0
                if ~isempty(find(Results.rr_cyc(s,20:100)<0,1))
                    cutOff = find(Results.rr_cyc(s,20:100)<0,1)+19;
                else
                    cutOff = 100;
                end
            elseif (Results.rr_cyc(s,20)-Results.rr_cyc(s,1))<0
                if ~isempty(find(Results.rr_cyc(s,20:100)>0,1))
                    cutOff = find(Results.rr_cyc(s,20:100)>0,1)+19;
                else
                    cutOff = 100;
                end
            end
        case 3
            if (Results.rz_cyc(s,20)-Results.rz_cyc(s,1))>0
                if ~isempty(find(Results.rz_cyc(s,20:100)<0,1))
                    cutOff = find(Results.rz_cyc(s,20:100)<0,1)+19;
                else
                    cutOff = 100;
                end
            elseif (Results.rz_cyc(s,20)-Results.rz_cyc(s,1))<0
                if ~isempty(find(Results.rz_cyc(s,20:100)>0,1))
                    cutOff = find(Results.rz_cyc(s,20:100)>0,1)+19;
                else
                    cutOff = 100;
                end
            end
    end
        [mag, imag] = max(sqrt((Results.rl_cyc(s,1:(cutOff))).^2+(Results.rr_cyc(s,1:(cutOff))).^2+(Results.rz_cyc(s,1:(cutOff))).^2));

    end
    w = [Results.rl_cyc(s,imag) Results.rr_cyc(s,imag) Results.rz_cyc(s,imag)];
    cosT = dot(handles.pureRot,w)/(norm(handles.pureRot)*norm(w));
    avgMisalign = acosd(cosT);
    maxMag = mag;

    function [avgMisalign, maxMag, w] = maxMagThreshL(s,handles,Results)
    [mag, imag] = max(sqrt((Results.ll_cyc(s,1:(100))).^2+(Results.lr_cyc(s,1:(100))).^2+(Results.lz_cyc(s,1:(100))).^2));
    if mag>40
          [mag, imag] = max(sqrt((Results.ll_cyc(s,1:(30))).^2+(Results.lr_cyc(s,1:(30))).^2+(Results.lz_cyc(s,1:(30))).^2));
    [~,maj]=min([mag-max(abs(Results.ll_cyc(s,1:(30)))) mag-max(abs(Results.lr_cyc(s,1:(30)))) mag-max(abs(Results.lz_cyc(s,1:(30))))]);
   
    switch maj
        case 1
            if (Results.ll_cyc(s,20)-Results.ll_cyc(s,1))>0
                
                if ~isempty(find(Results.ll_cyc(s,20:100)<0,1))
                    cutOff = find(Results.ll_cyc(s,20:100)<0,1)+19;
                else
                    cutOff = 100;
                end
            elseif (Results.ll_cyc(s,20)-Results.ll_cyc(s,1))<0
                if ~isempty(find(Results.ll_cyc(s,20:100)>0,1))
                    cutOff = find(Results.ll_cyc(s,20:100)>0,1)+19;
                else
                    cutOff = 100;
                end
            end
        case 2
            if (Results.lr_cyc(s,20)-Results.lr_cyc(s,1))>0
                if ~isempty(find(Results.lr_cyc(s,20:100)<0,1))
                    cutOff = find(Results.lr_cyc(s,20:100)<0,1)+19;
                else
                    cutOff = 100;
                end
            elseif (Results.lr_cyc(s,20)-Results.lr_cyc(s,1))<0
                if ~isempty(find(Results.lr_cyc(s,20:100)>0,1))
                    cutOff = find(Results.lr_cyc(s,20:100)>0,1)+19;
                else
                    cutOff = 100;
                end
            end
        case 3
            if (Results.lz_cyc(s,20)-Results.lz_cyc(s,1))>0
                if ~isempty(find(Results.lz_cyc(s,20:100)<0,1))
                    cutOff = find(Results.lz_cyc(s,20:100)<0,1)+19;
                else
                    cutOff = 100;
                end
            elseif (Results.lz_cyc(s,20)-Results.lz_cyc(s,1))<0
                if ~isempty(find(Results.lz_cyc(s,20:100)>0,1))
                    cutOff = find(Results.lz_cyc(s,20:100)>0,1)+19;
                else
                    cutOff = 100;
                end
            end
    end
        [mag, imag] = max(sqrt((Results.ll_cyc(s,1:(cutOff))).^2+(Results.lr_cyc(s,1:(cutOff))).^2+(Results.lz_cyc(s,1:(cutOff))).^2));

    end
    w = [Results.ll_cyc(s,imag) Results.lr_cyc(s,imag) Results.lz_cyc(s,imag)];
    cosT = dot(handles.pureRot,w)/(norm(handles.pureRot)*norm(w));
    avgMisalign = acosd(cosT);
    maxMag = mag;

% --- Executes during object creation, after setting all properties.
function configByAnimal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to configByAnimal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in LEyeFlag.
function LEyeFlag_Callback(hObject, eventdata, handles)
% hObject    handle to LEyeFlag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.LEyeFlag.BackgroundColor = [0.94 0.94 0.94];
handles.REyeFlag.BackgroundColor = [0.94 0.94 0.94];

% Hint: get(hObject,'Value') returns toggle state of LEyeFlag


% --- Executes on button press in REyeFlag.
function REyeFlag_Callback(hObject, eventdata, handles)
% hObject    handle to REyeFlag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.LEyeFlag.BackgroundColor = [0.94 0.94 0.94];
handles.REyeFlag.BackgroundColor = [0.94 0.94 0.94];
% Hint: get(hObject,'Value') returns toggle state of REyeFlag


% --- Executes on button press in curr.
function curr_Callback(hObject, eventdata, handles)
% hObject    handle to curr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of curr
if hObject.Value
    handles.p1d.Value = 0;
    handles.p2d.Value = 0;
    handles.ipg.Value = 0;
end
guidata(hObject, handles);
% --- Executes on button press in p1d.
function p1d_Callback(hObject, eventdata, handles)
% hObject    handle to p1d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of p1d
if hObject.Value
    handles.curr.Value = 0;
    handles.p2d.Value = 0;
end
guidata(hObject, handles);

% --- Executes on button press in p2d.
function p2d_Callback(hObject, eventdata, handles)
% hObject    handle to p2d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of p2d
if hObject.Value
    handles.p1d.Value = 0;
    handles.curr.Value = 0;
end
guidata(hObject, handles);

% --- Executes on button press in ipg.
function ipg_Callback(hObject, eventdata, handles)
% hObject    handle to ipg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ipg
if hObject.Value
    if handles.p1d.Value
    handles.p2d.Value = 0;
    elseif handles.p2d.Value
        handles.p1d.Value = 0;
    end
    handles.curr.Value = 0;
end
guidata(hObject, handles);

% function plotCurrentAsX(handles)
%         handles.figtomake = [handles.larp.Value handles.ralp.Value handles.lhrh.Value];
%     handles.directions = find(handles.figtomake);
%     for i = 1:sum(handles.figtomake)
%         handles.returnNum = [];
%         if handles.stimulatingE.Value
%             switch handles.directions(i)
%                 case 1
%                     handles.stimNum = handles.larpelectrodes.Value;
%                     handles.figdir = 'LARP';
%                     handles.pureRot = [1 0 0];
%                 case 2
%                     handles.stimNum = handles.ralpelectrodes.Value;
%                     handles.figdir = 'RALP';
%                     handles.pureRot = [0 1 0];
%                 case 3
%                     handles.stimNum = handles.lhrhelectrodes.Value;
%                     handles.figdir = 'LHRH';
%                     handles.pureRot = [0 0 1];
%             end
%             if handles.bipolarstim.Value
%                 handles.returnNum = [handles.returnNum handles.stimNum];
%             end
%             if handles.distantstim.Value
%                 handles.returnNum = [handles.returnNum handles.distant.Value];
%             end
%             if handles.ccstim.Value
%                 handles.returnNum = [handles.returnNum handles.commoncrus.Value];
%             end
%             
%             oneInds = [];
%                 otherInds = [];
% 
%                     if any(handles.returnNum==1)
%                         oneInds = find(contains({handles.listing.name},['ref',num2str(1)]));
%                         if ~isempty(find(contains({handles.listing.name},['ref',num2str(10)])))
%                             otherInds = [otherInds find(contains({handles.listing.name},['ref',num2str(10)]))];
%                         end
%                         if ~isempty(find(contains({handles.listing.name},['ref',num2str(11)])))
%                             otherInds = [otherInds find(contains({handles.listing.name},['ref',num2str(11)]))];
%                         end
%                         if ~isempty(find(contains({handles.listing.name},['ref',num2str(12)])))
%                             otherInds = [otherInds find(contains({handles.listing.name},['ref',num2str(12)]))];
%                         end
%                         if ~isempty(find(contains({handles.listing.name},['ref',num2str(13)])))
%                             otherInds = [otherInds find(contains({handles.listing.name},['ref',num2str(13)]))];
%                         end
%                         if ~isempty(find(contains({handles.listing.name},['ref',num2str(14)])))
%                             otherInds = [otherInds find(contains({handles.listing.name},['ref',num2str(14)]))];
%                         end
%                         if ~isempty(find(contains({handles.listing.name},['ref',num2str(15)])))
%                             otherInds = [otherInds find(contains({handles.listing.name},['ref',num2str(15)]))];
%                         end
%                         if isequal(oneInds,sort(otherInds,'ascend'))
%                             handles.returnNum(handles.returnNum==1) = [];
%                         end
%                     end
%                     go = 1;
%                     checkReturn = 1;
%                     while go
%                         if isempty(find(contains({handles.listing.name},['ref',num2str(handles.returnNum(checkReturn))])))
%                             handles.returnNum(checkReturn) = [];
%                             checkReturn = checkReturn - 1;
%                         end
%                         if checkReturn == length(handles.returnNum)
%                             go = 0;
%                         end
%                         checkReturn = checkReturn + 1;
%                     end
%             
%             handles.origreturnNum = handles.returnNum;
%             ldgNames = {};
%             lines = zeros(1,length(handles.origreturnNum));
%             for rN = 1:length(handles.origreturnNum)
%                 ldgNames{rN} = ' ';
%             end
%             handles.avgMagPlot(i) = figure('units','normalized','outerposition',[0 0 1 1]);
%             handles.avgMisalignPlot(i) = figure('units','normalized','outerposition',[0 0 1 1]);
%             a = sgtitle(handles.avgMagPlot(i),{['Average Eye Velocity Magnitude, ',handles.figdir] ; ' '},'FontSize', 22, 'FontWeight', 'Bold');
%             sgtitle(handles.avgMisalignPlot(i),{['Angle of Misalignment, ',handles.figdir]; ' '},'FontSize', 22, 'FontWeight', 'Bold');
%             for j = 1:length(handles.stimNum)
%                 handles.returnNum = handles.origreturnNum;
%                 handles.avgMisalignPlot3D(j) = figure('units','normalized','outerposition',[0 0 1 1]);
%                 sgtitle(handles.avgMisalignPlot3D(j),{['3D Angle of Misalignment, Stim ',num2str(handles.stimNum(j)),', ',handles.figdir]; ' '},'FontSize', 22, 'FontWeight', 'Bold');
%                 
%                 
%                 if handles.LEyeFlag.Value + handles.REyeFlag.Value == 2
%                     
%                     handles.fig(i,j).avgMagaxL = subtightplot(2,length(handles.stimNum),j,[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMagPlot(i));
%                     handles.fig(i,j).avgMagaxR = subtightplot(2,length(handles.stimNum),j+length(handles.stimNum),[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMagPlot(i));
%                     
%                     handles.fig(i,j).avgMisalignaxL = subtightplot(2,length(handles.stimNum),j,[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot(i));
%                     handles.fig(i,j).avgMisalignaxR = subtightplot(2,length(handles.stimNum),j+length(handles.stimNum),[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot(i));
%                     
%                     handles.fig(i,j).avgMagaxL.XTickLabel = [];
%                     handles.fig(i,j).avgMagaxR.XTick = [0:50:300];
%                     handles.fig(i,j).avgMisalignaxL.XTickLabel = [];
%                     handles.fig(i,j).avgMisalignaxR.XTick = [0:50:300];
%                     handles.fig(i,j).avgMagaxL.XGrid = 'on';
%                     handles.fig(i,j).avgMagaxR.XGrid = 'on';
%                     handles.fig(i,j).avgMagaxL.YGrid = 'on';
%                     handles.fig(i,j).avgMagaxR.YGrid = 'on';
%                     handles.fig(i,j).avgMisalignaxL.XGrid = 'on';
%                     handles.fig(i,j).avgMisalignaxR.XGrid = 'on';
%                     handles.fig(i,j).avgMisalignaxL.YGrid = 'on';
%                     handles.fig(i,j).avgMisalignaxR.YGrid = 'on';
%                     handles.fig(i,j).avgMagaxR.XLim = [0 350];
%                     handles.fig(i,j).avgMagaxL.XLim = [0 350];
%                     handles.fig(i,j).avgMisalignaxR.XLim = [0 350];
%                     handles.fig(i,j).avgMisalignaxL.XLim = [0 350];
%                     handles.fig(i,j).avgMagaxR.XTick = [0:50:300];
%                     handles.fig(i,j).avgMisalignaxR.XTick = [0:50:300];
%                     
%                     
%                     
%                     handles.fig(i,j).avgMisalign3D.R = subtightplot(1,2,1,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot3D(j));
%                     handles.fig(i,j).avgMisalign3D.L = subtightplot(1,2,2,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot3D(j));
%                     handles.fig(i,j).avgMisalign3D.R.XGrid = 'on';
%                     handles.fig(i,j).avgMisalign3D.R.YGrid = 'on';
%                     handles.fig(i,j).avgMisalign3D.L.XGrid = 'on';
%                     handles.fig(i,j).avgMisalign3D.L.YGrid = 'on';
%                     handles.fig(i,j).avgMisalign3D.L.Title.String = 'Left Eye 3D Misalignment';
%                     handles.fig(i,j).avgMisalign3D.L.FontSize = 13.5;
%                     handles.fig(i,j).avgMisalign3D.R.Title.String = 'Right Eye 3D Misalignment';
%                     handles.fig(i,j).avgMisalign3D.R.FontSize = 13.5;
%                 elseif handles.LEyeFlag.Value
%                     
%                     handles.fig(i,j).avgMagaxL = subtightplot(1,length(handles.stimNum),j,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMagPlot(i));
%                     handles.fig(i,j).avgMisalignaxL = subtightplot(1,length(handles.stimNum),j,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot(i));
%                     handles.fig(i,j).avgMagaxL.XTick = [0:50:300];
%                     handles.fig(i,j).avgMisalignaxL.XTick = [0:50:300];
%                     handles.fig(i,j).avgMagaxL.XGrid = 'on';
%                     handles.fig(i,j).avgMagaxL.YGrid = 'on';
%                     handles.fig(i,j).avgMisalignaxL.XGrid = 'on';
%                     handles.fig(i,j).avgMisalignaxL.YGrid = 'on';
%                     handles.fig(i,j).avgMagaxL.XLim = [0 350];
%                     handles.fig(i,j).avgMisalignaxL.XLim = [0 350];
%                     handles.fig(i,j).avgMagaxL.XTick = [0:50:300];
%                     handles.fig(i,j).avgMisalignaxL.XTick = [0:50:300];
%                     
%                     
%                     handles.fig(i,j).avgMisalign3D.L = axes('Parent', handles.avgMisalignPlot3D(j));
%                     handles.fig(i,j).avgMisalign3D.L.XGrid = 'on';
%                     handles.fig(i,j).avgMisalign3D.L.YGrid = 'on';
%                     handles.fig(i,j).avgMisalign3D.L.Title.String = 'Left Eye 3D Misalignment';
%                     handles.fig(i,j).avgMisalign3D.L.FontSize = 13.5;
%                 elseif handles.REyeFlag.Value
%                     
%                     handles.fig(i,j).avgMagaxR = subtightplot(1,length(handles.stimNum),j,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMagPlot(i));
%                     handles.fig(i,j).avgMisalignaxR = subtightplot(1,length(handles.stimNum),j,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot(i));
%                     handles.fig(i,j).avgMagaxR.XTick = [0:50:300];
%                     handles.fig(i,j).avgMisalignaxR.XTick = [0:50:300];
%                     handles.fig(i,j).avgMagaxR.XGrid = 'on';
%                     handles.fig(i,j).avgMagaxR.YGrid = 'on';
%                     handles.fig(i,j).avgMisalignaxR.XGrid = 'on';
%                     handles.fig(i,j).avgMisalignaxR.YGrid = 'on';
%                     handles.fig(i,j).avgMagaxR.XLim = [0 350];
%                     handles.fig(i,j).avgMisalignaxR.XLim = [0 350];
%                     handles.fig(i,j).avgMagaxR.XTick = [0:50:300];
%                     handles.fig(i,j).avgMisalignaxR.XTick = [0:50:300];
%                     
%                     
%                     handles.fig(i,j).avgMisalign3D.R = axes('Parent', handles.avgMisalignPlot3D(j));
%                     handles.fig(i,j).avgMisalign3D.R.XGrid = 'on';
%                     handles.fig(i,j).avgMisalign3D.R.YGrid = 'on';
%                     handles.fig(i,j).avgMisalign3D.R.Title.String = 'Right Eye 3D Misalignment';
%                     handles.fig(i,j).avgMisalign3D.R.FontSize = 13.5;
%                 end
%                 
%                 handles.ldg3D.lines = {};
%                 handles.ldg3D.AP = {};
%                 
%                 if handles.LEyeFlag.Value
%                     set( handles.avgMisalignPlot3D(j),'CurrentAxes',handles.fig(i,j).avgMisalign3D.L)
%                     hold(handles.fig(i,j).avgMisalign3D.L,'on');
%                     h=plot3vect([1/sqrt(2);-1/sqrt(2);0],'LARP Axis',[0 1 0],2);
%                     set(h,'LineStyle','--','Marker','o');
%                     h=plot3vect([1/sqrt(2);1/sqrt(2);0],'RALP Axis',[0 1 1],2);
%                     set(h,'LineStyle','--','Marker','o');
%                     h=plot3vect([0;0;1],'Yaw Axis',[0.68 0 0],2);
%                     set(h,'LineStyle','--','Marker','o');
%                     
%                     [x,y,z]=sphere();
%                     h=surf(0.5*x,0.5*y,0.5*z);
%                     set(h,'FaceColor','white')
%                     handles.fig(i,j).avgMisalign3D.L.View = [90 -0.5];
%                     axis vis3d
%                     axis equal
%                     box on;
%                     xlim([-1 1])
%                     ylim([-1 1])
%                     zlim([-1 1])
%                     hold(handles.fig(i,j).avgMisalign3D.L,'off');
%                     
%                     if j>1
%                         handles.fig(i,j).avgMagaxL.YTickLabel = [];
%                         handles.fig(i,j).avgMisalignaxL.YTickLabel = [];
%                     end
%                 end
%                 
%                 if handles.REyeFlag.Value
%                     set( handles.avgMisalignPlot3D(j),'CurrentAxes',handles.fig(i,j).avgMisalign3D.R)
%                     hold(handles.fig(i,j).avgMisalign3D.R,'on');
%                     h=plot3vect([1/sqrt(2);-1/sqrt(2);0],'LARP Axis',[0 1 0],2);
%                     set(h,'LineStyle','--','Marker','o');
%                     h=plot3vect([1/sqrt(2);1/sqrt(2);0],'RALP Axis',[0 1 1],2);
%                     set(h,'LineStyle','--','Marker','o');
%                     h=plot3vect([0;0;1],'Yaw Axis',[0.68 0 0],2);
%                     set(h,'LineStyle','--','Marker','o');
%                     
%                     [x,y,z]=sphere();
%                     h=surf(0.5*x,0.5*y,0.5*z);
%                     set(h,'FaceColor','white')
%                     handles.fig(i,j).avgMisalign3D.R.View = [90 -0.5];
%                     axis vis3d
%                     axis equal
%                     box on;
%                     xlim([-1 1])
%                     ylim([-1 1])
%                     zlim([-1 1])
%                     hold(handles.fig(i,j).avgMisalign3D.R,'off');
%                     if j>1
%                         handles.fig(i,j).avgMagaxR.YTickLabel = [];
%                         handles.fig(i,j).avgMisalignaxR.YTickLabel = [];
%                     end
%                 end
%                 
%                 
%                 
%                 if handles.bipolarstim.Value
%                     handles.returnNum = handles.returnNum(~(handles.returnNum==handles.stimNum(j)));
%                 end
%                 go = 1;
%                 returnTest = 1;
%                 oneInds = [];
%                 otherInds = [];
% 
%                 while go
%                     if handles.returnNum(returnTest)==1
%                         oneInds = find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(handles.returnNum(returnTest))]));
%                         if ~isempty(find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(10)])))
%                             otherInds = [otherInds find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(10)]))];
%                         end
%                         if ~isempty(find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(11)])))
%                             otherInds = [otherInds find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(11)]))];
%                         end
%                         if ~isempty(find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(12)])))
%                             otherInds = [otherInds find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(11)]))];
%                         end
%                         if ~isempty(find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(13)])))
%                             otherInds = [otherInds find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(11)]))];
%                         end
%                         if ~isempty(find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(14)])))
%                             otherInds = [otherInds find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(11)]))];
%                         end
%                         if ~isempty(find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(15)])))
%                             otherInds = [otherInds find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(11)]))];
%                         end
%                         if isequal(oneInds,otherInds)
%                             handles.returnNum(returnTest) = [];
%                             returnTest = returnTest - 1;
%                         else
%                             oneInds = oneInds(~ismember(oneInds,otherInds));
%                         end
%                     else
%                         if ~isempty(find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(handles.returnNum(returnTest))])))
%                             
%                         else
%                             handles.returnNum(returnTest) = [];
%                             returnTest = returnTest - 1;
%                         end
%                     end
%                     
%                     if returnTest == length(handles.returnNum)
%                         go = 0;
%                     end
%                     returnTest = returnTest + 1;
%                 end
%                 for k = 1:length(handles.returnNum)
%                     switch handles.returnNum(k)
%                         case 1
%                             colorPlot = [65 82 31]/255;
%                         case 2
%                             colorPlot = [72 169 60]/255;
%                         case 3
%                             colorPlot = [40 82 56]/255;
%                         case 4
%                             colorPlot = [13 0 164]/255;
%                         case 5
%                             colorPlot = [18 53 91]/255;
%                         case 6
%                             colorPlot = [3 157 201]/255;
%                         case 7
%                             colorPlot = [215 38 56]/255;
%                         case 8
%                             colorPlot = [158 43 37]/255;
%                         case 9
%                             colorPlot = [219 108 35]/255;
%                         case 10
%                             colorPlot = [57 61 63]/255;
%                         case 11
%                             colorPlot = [246 189 96]/255;
%                         case 12
%                             colorPlot = [115 98 138]/255;
%                         case 13
%                             colorPlot = [135 142 136]/255;
%                         case 14
%                             colorPlot = [51 92 103]/255;
%                         case 15
%                             colorPlot = [107 15 26]/255;
%                     end
%                     
%                     
%                     if isempty(handles.ldg3D.lines)
%                         handles.ldg3D.lines = {['Return ',num2str(handles.returnNum(k))]};
%                     elseif strcmp(handles.ldg3D.lines,['Return ',num2str(handles.returnNum(k))])
%                     else
%                         handles.ldg3D.lines = [handles.ldg3D.lines,{['Return ',num2str(handles.returnNum(k))]}];
%                     end
%                     notOneInds = [];
%                     if handles.returnNum(k) == 1
%                         toplotInds = oneInds;
%                     else
%                         toplotInds = find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(handles.returnNum(k))]));
%                     end
%                         
%                     for l = 1:length(toplotInds)
%                         load(handles.listing(toplotInds(l)).name)
%                         filename = handles.listing(toplotInds(l)).name;
%                         dotF = find(filename=='.');
%                         amp = strfind(filename,'amp');
%                         underS = find(filename=='_');
%                         dash = find(filename=='-');
%                         delin = sort([underS dash],'ascend');
%                         handles.fig(i,j).cycles(l,k).stim = handles.stimNum(j);
%                         handles.fig(i,j).cycles(l,k).ref = handles.returnNum(k);
%                         handles.fig(i,j).cycles(l,k).axis = handles.figdir;
%                         nextD = find(delin>amp,1);
%                         handles.fig(i,j).cycles(l,k).amp = str2num(filename(amp(1)+3:delin(nextD)-1));
%                         handles.fig(i,j).cycles(l,k).twitch = Results.FacialNerve;
%                         
%                         if handles.LEyeFlag.Value
%                             handles.fig(i,j).cycles(l,k).cycavgL = [Results.ll_cycavg' Results.lr_cycavg' Results.lz_cycavg'];
%                             tL = 1/Results.Fs:1/Results.Fs:length(Results.ll_cycavg)/Results.Fs;
%                             handles.fig(i,j).cycles(l,k).timeL = [tL' tL' tL'];
%                             handles.fig(i,j).cycles(l,k).stdL = [Results.ll_cycstd' Results.lr_cycstd' Results.lz_cycstd'];
%                             
%                             d = diff(Results.ll_cyc');
%                             
%                             maxMagL = [];
%                             avgMisalignL = [];
%                             misalign3DL = [];
%                             for s = 1:size(d,2)
%                                 [avgMisalignCycL, maxMagCycL, wL] = maxMagThreshL(s,handles,Results);
%                                 avgMisalignL = [avgMisalignL; avgMisalignCycL];
%                                 maxMagL = [maxMagL; maxMagCycL];
%                                 misalign3DL = [misalign3DL; wL];
%                             end
%                             
%                             handles.fig(i,j).cycles(l,k).maxMagL = maxMagL;
%                             handles.fig(i,j).cycles(l,k).avgMisalignL = avgMisalignL;
%                             meanM = mean(misalign3DL);
%                             handles.fig(i,j).cycles(l,k).avgmisalign3DL = meanM/norm(meanM);
%                             rot = [cosd(-45) -sind(-45) 0;...
%                                 sind(-45) cosd(-45) 0;...
%                                 0 0 1];
%                             mis3DPlot = (rot*handles.fig(i,j).cycles(l,k).avgmisalign3DL')';
%                             
%                             set( handles.avgMisalignPlot3D(j),'CurrentAxes',handles.fig(i,j).avgMisalign3D.L);
%                             hold(handles.fig(i,j).avgMisalign3D.L,'on');
%                             handles.fig(i,j).mis3D(l,k).lPlotL = plot3([0 mis3DPlot(1)]',[0 mis3DPlot(2)]',[0 mis3DPlot(3)]');
%                             set(handles.fig(i,j).mis3D(l,k).lPlotL,'LineWidth',2,'DisplayName','','Color',colorPlot)
%                             switch handles.fig(i,j).cycles(l,k).amp
%                                 case 20
%                                     markerToUse = 'o';
%                                 case 50
%                                     markerToUse = '+';
%                                 case 75
%                                     markerToUse = '*';
%                                 case 100
%                                     markerToUse = '^';
%                                 case 125
%                                     markerToUse = 's';
%                                 case 150
%                                     markerToUse = 'd';
%                                 case 200
%                                     markerToUse = '<';
%                                 case 250
%                                     markerToUse = 'p';
%                                 case 300
%                                     markerToUse = 'h';
%                             end
%                             if l==1
%                                 handles.fig(i,j).mis3D(l,k).lPlotFakeL = plot3([0 .01]',[0 .01]',[0 .01]');
%                                 set(handles.fig(i,j).mis3D(l,k).lPlotFakeL,'LineWidth',2,'DisplayName','','Color',colorPlot)
%                             end
%                             if isempty(handles.ldg3D.AP)
%                                 handles.ldg3D.AP = {[num2str(handles.fig(i,j).cycles(l,k).amp),' uA']};
%                                 handles.fig(i,j).mis3D(l,k).pPlotFakeL = plot3(0,0,0,'Marker',markerToUse,'MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2,'Linestyle', 'none');
%                             elseif any(strcmp(handles.ldg3D.AP,[num2str(handles.fig(i,j).cycles(l,k).amp),' uA']))
%                             else
%                                 handles.ldg3D.AP = [handles.ldg3D.AP,{[num2str(handles.fig(i,j).cycles(l,k).amp),' uA']}];
%                                 handles.fig(i,j).mis3D(l,k).pPlotFakeL = plot3(0,0,0,'Marker',markerToUse,'MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2,'Linestyle', 'none');
%                             end
%                             
%                             handles.fig(i,j).mis3D(l,k).pPlotL = plot3(mis3DPlot(1),mis3DPlot(2),mis3DPlot(3),'o');
%                             set(handles.fig(i,j).mis3D(l,k).pPlotL,'LineWidth',2,'DisplayName','','Marker',markerToUse,'MarkerSize',10,'MarkerEdgeColor',colorPlot)
%                             
%                             if any(handles.fig(i,j).cycles(l,k).twitch)
%                                 twitchPlotL = plot3(mis3DPlot(1),mis3DPlot(2),mis3DPlot(3),'rx','MarkerSize', 20,'LineWidth',3,'Linestyle', 'none');
%                             end
%                             hold(handles.fig(i,j).avgMisalign3D.L,'off');
%                             
%                             set( handles.avgMagPlot(i),'CurrentAxes',handles.fig(i,j).avgMagaxL);
%                             hold(handles.fig(i,j).avgMagaxL,'on');
%                             handles.fig(i,j).p(k).ptL(l) = plot(handles.fig(i,j).avgMagaxL,handles.fig(i,j).cycles(l,k).amp,mean(handles.fig(i,j).cycles(l,k).maxMagL),'color',colorPlot,'marker','o','MarkerSize',10,'LineWidth',2);
%                             handles.fig(i,j).cycles(l,k).VstdevL =  std(handles.fig(i,j).cycles(l,k).maxMagL);
%                             errorbar(handles.fig(i,j).avgMagaxL,handles.fig(i,j).cycles(l,k).amp,mean(handles.fig(i,j).cycles(l,k).maxMagL),handles.fig(i,j).cycles(l,k).VstdevL,'color',colorPlot,'LineWidth',2.5);
%                             handles.fig(i,j).avgMagaxL.LineWidth = 2.5;
%                             hold(handles.fig(i,j).avgMagaxL,'off');
%                             
%                             set( handles.avgMisalignPlot(i),'CurrentAxes',handles.fig(i,j).avgMisalignaxL);
%                             hold(handles.fig(i,j).avgMisalignaxL,'on');
%                             handles.fig(i,j).q(k).ptL(l) = plot(handles.fig(i,j).avgMisalignaxL,handles.fig(i,j).cycles(l,k).amp,mean(handles.fig(i,j).cycles(l,k).avgMisalignL),'color',colorPlot,'marker','o','MarkerSize',10,'LineWidth',2);
%                             
%                             handles.fig(i,j).cycles(l,k).MstdevL =  std(handles.fig(i,j).cycles(l,k).avgMisalignL);
%                             errorbar(handles.fig(i,j).avgMisalignaxL,handles.fig(i,j).cycles(l,k).amp,mean(handles.fig(i,j).cycles(l,k).avgMisalignL),handles.fig(i,j).cycles(l,k).MstdevL,'color',colorPlot,'LineWidth',2.5);
%                             
%                             handles.fig(i,j).avgMisalignaxL.LineWidth = 2.5;
%                             hold(handles.fig(i,j).avgMisalignaxL,'off');
%                             
%                         end
%                         
%                         if handles.REyeFlag.Value
%                             
%                             maxMagR = [];
%                             avgMisalignR = [];
%                             misalign3DR = [];
%                             
%                             for s = 1:size(d,2)
%                                 [avgMisalignCycR, maxMagCycR, wR] = maxMagThreshR(s,handles,Results);
%                                 avgMisalignR = [avgMisalignR; avgMisalignCycR];
%                                 maxMagR = [maxMagR; maxMagCycR];
%                                 misalign3DR = [misalign3DR; wR];
%                             end
%                             
%                             handles.fig(i,j).cycles(l,k).maxMagR = maxMagR;
%                             handles.fig(i,j).cycles(l,k).avgMisalignR = avgMisalignR;
%                             meanM = mean(misalign3DR);
%                             handles.fig(i,j).cycles(l,k).avgmisalign3DR = meanM/norm(meanM);
%                             rot = [cosd(-45) -sind(-45) 0;...
%                                 sind(-45) cosd(-45) 0;...
%                                 0 0 1];
%                             mis3DPlot = (rot*handles.fig(i,j).cycles(l,k).avgmisalign3DR')';
%                             
%                             set( handles.avgMisalignPlot3D(j),'CurrentAxes',handles.fig(i,j).avgMisalign3D.R);
%                             hold(handles.fig(i,j).avgMisalign3D.R,'on');
%                             handles.fig(i,j).mis3D(l,k).lPlotR = plot3([0 mis3DPlot(1)]',[0 mis3DPlot(2)]',[0 mis3DPlot(3)]');
%                             set(handles.fig(i,j).mis3D(l,k).lPlotR,'LineWidth',2,'DisplayName','','Color',colorPlot)
%                             switch handles.fig(i,j).cycles(l,k).amp
%                                 case 20
%                                     markerToUse = 'o';
%                                 case 50
%                                     markerToUse = '+';
%                                 case 75
%                                     markerToUse = '*';
%                                 case 100
%                                     markerToUse = '^';
%                                 case 125
%                                     markerToUse = 's';
%                                 case 150
%                                     markerToUse = 'd';
%                                 case 200
%                                     markerToUse = '<';
%                                 case 250
%                                     markerToUse = 'p';
%                                 case 300
%                                     markerToUse = 'h';
%                             end
%                             if l==1
%                                 handles.fig(i,j).mis3D(l,k).lPlotFakeR = plot3([0 .01]',[0 .01]',[0 .01]');
%                                 set(handles.fig(i,j).mis3D(l,k).lPlotFakeR,'LineWidth',2,'DisplayName','','Color',colorPlot)
%                             end
%                             if isempty(handles.ldg3D.AP)
%                                 handles.ldg3D.AP = {[num2str(handles.fig(i,j).cycles(l,k).amp),' uA']};
%                                 handles.fig(i,j).mis3D(l,k).pPlotFakeR = plot3(0,0,0,'Marker',markerToUse,'MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2,'Linestyle', 'none');
%                             elseif any(strcmp(handles.ldg3D.AP,[num2str(handles.fig(i,j).cycles(l,k).amp),' uA']))
%                             else
%                                 handles.ldg3D.AP = [handles.ldg3D.AP,{[num2str(handles.fig(i,j).cycles(l,k).amp),' uA']}];
%                                 handles.fig(i,j).mis3D(l,k).pPlotFakeR = plot3(0,0,0,'Marker',markerToUse,'MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2,'Linestyle', 'none');
%                             end
%                             
%                             handles.fig(i,j).mis3D(l,k).pPlotR = plot3(mis3DPlot(1),mis3DPlot(2),mis3DPlot(3),'o');
%                             set(handles.fig(i,j).mis3D(l,k).pPlotR,'LineWidth',2,'DisplayName','','Marker',markerToUse,'MarkerSize',10,'MarkerEdgeColor',colorPlot)
%                             
%                             if any(handles.fig(i,j).cycles(l,k).twitch)
%                                 twitchPlotR = plot3(mis3DPlot(1),mis3DPlot(2),mis3DPlot(3),'rx','MarkerSize', 20,'LineWidth',3,'Linestyle', 'none');
%                             end
%                             hold(handles.fig(i,j).avgMisalign3D.R,'off');
%                             
%                             set( handles.avgMagPlot(i),'CurrentAxes',handles.fig(i,j).avgMagaxR);
%                             hold(handles.fig(i,j).avgMagaxR,'on');
%                             handles.fig(i,j).p(k).ptR(l) = plot(handles.fig(i,j).avgMagaxR,handles.fig(i,j).cycles(l,k).amp,mean(handles.fig(i,j).cycles(l,k).maxMagR),'color',colorPlot,'marker','o','MarkerSize',10,'LineWidth',2);
%                             handles.fig(i,j).cycles(l,k).VstdevR =  std(handles.fig(i,j).cycles(l,k).maxMagR);
%                             errorbar(handles.fig(i,j).avgMagaxR,handles.fig(i,j).cycles(l,k).amp,mean(handles.fig(i,j).cycles(l,k).maxMagR),handles.fig(i,j).cycles(l,k).VstdevR,'color',colorPlot,'LineWidth',2.5);
%                             handles.fig(i,j).avgMagaxR.LineWidth = 2.5;
%                             hold(handles.fig(i,j).avgMagaxR,'off');
%                             
%                             set( handles.avgMisalignPlot(i),'CurrentAxes',handles.fig(i,j).avgMisalignaxR);
%                             hold(handles.fig(i,j).avgMisalignaxR,'on');
%                             handles.fig(i,j).q(k).ptR(l) = plot(handles.fig(i,j).avgMisalignaxR,handles.fig(i,j).cycles(l,k).amp,mean(handles.fig(i,j).cycles(l,k).avgMisalignR),'color',colorPlot,'marker','o','MarkerSize',10,'LineWidth',2);
%                             
%                             handles.fig(i,j).cycles(l,k).MstdevR =  std(handles.fig(i,j).cycles(l,k).avgMisalignR);
%                             errorbar(handles.fig(i,j).avgMisalignaxR,handles.fig(i,j).cycles(l,k).amp,mean(handles.fig(i,j).cycles(l,k).avgMisalignR),handles.fig(i,j).cycles(l,k).MstdevR,'color',colorPlot,'LineWidth',2.5);
%                             
%                             handles.fig(i,j).avgMisalignaxR.LineWidth = 2.5;
%                             hold(handles.fig(i,j).avgMisalignaxR,'off');
%                             
%                             
%                             
%                         end
%                         
%                         
%                         
%                     end
%                     if handles.LEyeFlag.Value
%                         set( handles.avgMagPlot(i),'CurrentAxes',handles.fig(i,j).avgMagaxL);
%                         hold(handles.fig(i,j).avgMagaxL,'on');
%                         line(handles.fig(i,j).avgMagaxL,[handles.fig(i,j).p(k).ptL.XData],[handles.fig(i,j).p(k).ptL.YData],'color',colorPlot,'LineWidth',4)
%                         hold(handles.fig(i,j).avgMagaxL,'off');
%                         handles.fig(i,j).avgMagaxL.XLabel.String = {'Current (uA)'};
%                         handles.fig(i,j).avgMagaxL.XLabel.FontSize = 22;
%                         
%                         set( handles.avgMisalignPlot(i),'CurrentAxes',handles.fig(i,j).avgMisalignaxL);
%                         hold(handles.fig(i,j).avgMisalignaxL,'on');
%                         line(handles.fig(i,j).avgMisalignaxL,[handles.fig(i,j).q(k).ptL.XData],[handles.fig(i,j).q(k).ptL.YData],'color',colorPlot,'LineWidth',4)
%                         hold(handles.fig(i,j).avgMisalignaxL,'off');
%                         handles.fig(i,j).avgMisalignaxL.XLabel.String = {'Current (uA)'};
%                         handles.fig(i,j).avgMisalignaxL.XLabel.FontSize = 22;
%                     end
%                     if handles.REyeFlag.Value
%                         set( handles.avgMagPlot(i),'CurrentAxes',handles.fig(i,j).avgMagaxR);
%                         hold(handles.fig(i,j).avgMagaxR,'on');
%                         line(handles.fig(i,j).avgMagaxR,[handles.fig(i,j).p(k).ptR.XData],[handles.fig(i,j).p(k).ptR.YData],'color',colorPlot,'LineWidth',4)
%                         hold(handles.fig(i,j).avgMagaxR,'off');
%                         handles.fig(i,j).avgMagaxR.XLabel.String = {'Current (uA)'};
%                         handles.fig(i,j).avgMagaxR.XLabel.FontSize = 22;
%                         
%                         set( handles.avgMisalignPlot(i),'CurrentAxes',handles.fig(i,j).avgMisalignaxR);
%                         hold(handles.fig(i,j).avgMisalignaxR,'on');
%                         line(handles.fig(i,j).avgMisalignaxR,[handles.fig(i,j).q(k).ptR.XData],[handles.fig(i,j).q(k).ptR.YData],'color',colorPlot,'LineWidth',4)
%                         hold(handles.fig(i,j).avgMisalignaxR,'off');
%                         handles.fig(i,j).avgMisalignaxR.XLabel.String = {'Current (uA)'};
%                         handles.fig(i,j).avgMisalignaxR.XLabel.FontSize = 22;
%                     end
%                     if handles.REyeFlag.Value && handles.LEyeFlag.Value
%                         handles.fig(i,j).avgMagaxL.XLabel.String = '';
%                         handles.fig(i,j).avgMisalignaxL.XLabel.String = '';
%                     end
% 
%                     
%                     
%                     
%                 end
%                 
%                 
%                 
%                 
%                 twitchLDG = 0;
%                 sourceLab = 0;
%                 if handles.LEyeFlag.Value
%                     if any(handles.fig(i,j).cycles(l,k).twitch) && ~twitchLDG
%                         ldg3D = legend(handles.fig(i,j).avgMisalign3D.L,[handles.fig(i,j).mis3D.lPlotFakeL handles.fig(i,j).mis3D.pPlotFakeL twitchPlotL],[handles.ldg3D.lines handles.ldg3D.AP {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
%                         twitchLDG = 1;
%                     else
%                         ldg3D = legend(handles.fig(i,j).avgMisalign3D.L,[handles.fig(i,j).mis3D.lPlotFakeL handles.fig(i,j).mis3D.pPlotFakeL],[handles.ldg3D.lines handles.ldg3D.AP],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
%                         twitchLDG = 1;
%                     end
%                     
%                     if j ==1
%                         ylabel(handles.fig(i,j).avgMagaxL,'Left Eye Velocity Magnitude (dps)','FontSize',22);
%                         handles.fig(i,j).avgMagaxL.FontSize = 13.5;
%                         ylabel(handles.fig(i,j).avgMisalignaxL,'Left Eye Velocity Misalignment (degrees)','FontSize',22);
%                         handles.fig(i,j).avgMisalignaxL.FontSize = 13.5;
%                     end
%                     handles.fig(i,j).avgMagaxL.Title.String = ['Source ', num2str(handles.stimNum(j))];
%                     handles.fig(i,j).avgMisalignaxL.Title.String = ['Source ', num2str(handles.stimNum(j))];
%                     sourceLab = 1;
%                     sameaxes([], [handles.fig(i,:).avgMagaxL]);
%                     sameaxes([], [handles.fig(i,:).avgMisalignaxL]);
%                     handles.fig(i,j).avgMagaxL.FontSize = 13.5;
%                     handles.fig(i,j).avgMisalignaxL.FontSize = 13.5;
%                     for rN = 1:length(handles.returnNum)
%                         ldgPos = find(handles.origreturnNum == handles.returnNum(rN));
%                         if ldgNames{ldgPos} == ' '
%                             ldgNames{ldgPos} = ['Return ',num2str(handles.returnNum(rN))];
%                             lines(ldgPos) = [handles.fig(i,j).p(rN).ptL(1)];
%                         end
%                     end
%                     
%                     all = size(handles.fig(i,j).cycles);
%                     for m = 1:all(2)
%                         for n = 1:all(1)
%                             if any([handles.fig(i,j).cycles(n,m).twitch])
%                                 
%                                 set( handles.avgMisalignPlot(i),'CurrentAxes',handles.fig(i,j).avgMisalignaxL);
%                                 hold(handles.fig(i,j).avgMisalignaxL,'on') %%%% Do red triangles instead of lines
%                                 cutOff1 = plot(handles.fig(i,j).avgMisalignaxL,handles.fig(i,j).cycles(n,m).amp,mean(handles.fig(i,j).cycles(n,m).avgMisalignL),'rx','MarkerSize', 20,'LineWidth',3);
%                                 hold(handles.fig(i,j).avgMisalignaxL,'off')
%                                 
%                                 set( handles.avgMagPlot(i),'CurrentAxes',handles.fig(i,j).avgMagaxL);
%                                 hold(handles.fig(i,j).avgMagaxL,'on')
%                                 cutOff2 = plot(handles.fig(i,j).avgMagaxL,handles.fig(i,j).cycles(n,m).amp,mean(handles.fig(i,j).cycles(n,m).maxMagL),'rx','MarkerSize', 20,'LineWidth',3);
%                                 hold(handles.fig(i,j).avgMagaxL,'off')
%                             end
%                         end
%                     end
%                 end
%                 if handles.REyeFlag.Value
%                     if (twitchLDG==0)
%                         if any(handles.fig(i,j).cycles(l,k).twitch)
%                             ldg3D = legend(handles.fig(i,j).avgMisalign3D.R,[handles.fig(i,j).mis3D.lPlotFakeR handles.fig(i,j).mis3D.pPlotFakeR twitchPlotR],[handles.ldg3D.lines handles.ldg3D.AP {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
%                         else
%                             ldg3D = legend(handles.fig(i,j).avgMisalign3D.R,[handles.fig(i,j).mis3D.lPlotFakeR handles.fig(i,j).mis3D.pPlotFakeR],[handles.ldg3D.lines handles.ldg3D.AP],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
%                         end
%                     end
%                     if j ==1
%                         ylabel(handles.fig(i,j).avgMagaxR,'Right Eye Velocity Magnitude (dps)','FontSize',22);
%                         handles.fig(i,j).avgMagaxR.FontSize = 13.5;
%                         ylabel(handles.fig(i,j).avgMisalignaxR,'Right Eye Velocity Misalignment (degrees)','FontSize',22);
%                         handles.fig(i,j).avgMisalignaxR.FontSize = 13.5;
%                     end
%                     if sourceLab == 0
%                         handles.fig(i,j).avgMagaxR.Title.String = ['Source ', num2str(handles.stimNum(j))];
%                         handles.fig(i,j).avgMisalignaxR.Title.String = ['Source ', num2str(handles.stimNum(j))];
%                     end
%                     sameaxes([], [handles.fig(i,:).avgMagaxR]);
%                     sameaxes([], [handles.fig(i,:).avgMisalignaxR]);
%                     handles.fig(i,j).avgMagaxR.FontSize = 13.5;
%                     handles.fig(i,j).avgMisalignaxR.FontSize = 13.5;
%                     for rN = 1:length(handles.returnNum)
%                         ldgPos = find(handles.origreturnNum == handles.returnNum(rN));
%                         if ldgNames{ldgPos} == ' '
%                             ldgNames{ldgPos} = ['Return ',num2str(handles.returnNum(rN))];
%                             lines(ldgPos) = [handles.fig(i,j).p(rN).ptR(1)];
%                         end
%                     end
%                     all = size(handles.fig(i,j).cycles);
%                     for m = 1:all(2)
%                         for n = 1:all(1)
%                             if any([handles.fig(i,j).cycles(n,m).twitch])
%                                 
%                                 set( handles.avgMisalignPlot(i),'CurrentAxes',handles.fig(i,j).avgMisalignaxR);
%                                 hold(handles.fig(i,j).avgMisalignaxR,'on') %%%% Do red triangles instead of lines
%                                 cutOff1 = plot(handles.fig(i,j).avgMisalignaxR,handles.fig(i,j).cycles(n,m).amp,mean(handles.fig(i,j).cycles(n,m).avgMisalignR),'rx','MarkerSize', 20,'LineWidth',3);
%                                 hold(handles.fig(i,j).avgMisalignaxR,'off')
%                                 
%                                 set( handles.avgMagPlot(i),'CurrentAxes',handles.fig(i,j).avgMagaxR);
%                                 hold(handles.fig(i,j).avgMagaxR,'on')
%                                 cutOff2 = plot(handles.fig(i,j).avgMagaxR,handles.fig(i,j).cycles(n,m).amp,mean(handles.fig(i,j).cycles(n,m).maxMagR),'rx','MarkerSize', 20,'LineWidth',3);
%                                 hold(handles.fig(i,j).avgMagaxR,'off')
%                             end
%                         end
%                     end
%                 end
%                 if handles.LEyeFlag.Value + handles.REyeFlag.Value == 2
%                     sameaxes([], [handles.fig(i,:).avgMagaxR handles.fig(i,:).avgMagaxL]);
%                     sameaxes([], [handles.fig(i,:).avgMisalignaxR handles.fig(i,:).avgMisalignaxL]);
%                 end
%                 
%                 if handles.LEyeFlag.Value && handles.REyeFlag.Value
%                     if handles.stimulatingE.Value
%                         misalgn3DName = [handles.figDir,'\eyeMisalignment3D_ByStimE_R&Leye_Stim',num2str(handles.stimNum(j)),'_',handles.figdir];
%                     elseif handles.referenceE.Value
%                         misalgn3DName = [handles.figDir,'\eyeMisalignment3D_ByRefE_R&Leye_Ref',num2str(handles.returnNum(j)),'_',handles.figdir];
%                     end
%                     
%                 elseif handles.LEyeFlag.Value
%                     if handles.stimulatingE.Value
%                         misalgn3DName = [handles.figDir,'\eyeMisalignment3D_ByStimE_Leye_Stim',num2str(handles.stimNum(j)),'_',handles.figdir];
%                     elseif handles.referenceE.Value
%                         misalgn3DName = [handles.figDir,'\eyeMisalignment3D_ByRefE_Leye_Ref',num2str(handles.returnNum(j)),'_',handles.figdir];
%                     end
%                 elseif handles.REyeFlag.Value
%                     if handles.stimulatingE.Value
%                         misalgn3DName = [handles.figDir,'\eyeMisalignment3D_ByStimE_Reye_Stim',num2str(handles.stimNum(j)),'_',handles.figdir];
%                     elseif handles.referenceE.Value
%                         misalgn3DName = [handles.figDir,'\eyeMisalignment3D_ByRefE_Reye_Ref',num2str(handles.returnNum(j)),'_',handles.figdir];
%                     end
%                 end
%                 saveas(handles.avgMisalignPlot3D(j),[misalgn3DName,'.svg']);
%                 saveas(handles.avgMisalignPlot3D(j),[misalgn3DName,'.jpg']);
%                 saveas(handles.avgMisalignPlot3D(j),[misalgn3DName,'.fig']);
%                 close(handles.avgMisalignPlot3D(j));
%                 
%                 
%             end
%             
%             
%             
%             
%             
%         elseif handles.referenceE.Value
%             handles.returnNum = [];
%             switch handles.directions(i)
%                 case 1
%                     handles.stimNum = handles.larpelectrodes.Value;
%                     handles.figdir = 'LARP';
%                     handles.pureRot = [1 0 0];
%                 case 2
%                     handles.stimNum = handles.ralpelectrodes.Value;
%                     handles.figdir = 'RALP';
%                     handles.pureRot = [0 1 0];
%                 case 3
%                     handles.stimNum = handles.lhrhelectrodes.Value;
%                     handles.figdir = 'LHRH';
%                     handles.pureRot = [0 0 1];
%             end
%             if handles.bipolarstim.Value
%                 handles.returnNum = [handles.returnNum handles.stimNum];
%             end
%             if handles.distantstim.Value
%                 handles.returnNum = [handles.returnNum handles.distant.Value];
%             end
%             if handles.ccstim.Value
%                 handles.returnNum = [handles.returnNum handles.commoncrus.Value];
%             end
%             handles.origstimNum = handles.stimNum;
%             ldgNames = {};
%             lines = zeros(1,length(handles.origstimNum));
%             for rN = 1:length(handles.origstimNum)
%                 ldgNames{rN} = ' ';
%             end
%             handles.avgMagPlot(i) = figure('units','normalized','outerposition',[0 0 1 1]);
%             handles.avgMisalignPlot(i) = figure('units','normalized','outerposition',[0 0 1 1]);
%             a = sgtitle(handles.avgMagPlot(i),{['Average Eye Velocity Magnitude, ',handles.figdir] ; ' '},'FontSize', 22, 'FontWeight', 'Bold');
%             sgtitle(handles.avgMisalignPlot(i),{['Angle of Misalignment, ',handles.figdir]; ' '},'FontSize', 22, 'FontWeight', 'Bold');
%             
% 
%                 oneInds = [];
%                 otherInds = [];
% 
%                     if any(handles.returnNum==1)
%                         oneInds = find(contains({handles.listing.name},['ref',num2str(1)]));
%                         if ~isempty(find(contains({handles.listing.name},['ref',num2str(10)])))
%                             otherInds = [otherInds find(contains({handles.listing.name},['ref',num2str(10)]))];
%                         end
%                         if ~isempty(find(contains({handles.listing.name},['ref',num2str(11)])))
%                             otherInds = [otherInds find(contains({handles.listing.name},['ref',num2str(11)]))];
%                         end
%                         if ~isempty(find(contains({handles.listing.name},['ref',num2str(12)])))
%                             otherInds = [otherInds find(contains({handles.listing.name},['ref',num2str(12)]))];
%                         end
%                         if ~isempty(find(contains({handles.listing.name},['ref',num2str(13)])))
%                             otherInds = [otherInds find(contains({handles.listing.name},['ref',num2str(13)]))];
%                         end
%                         if ~isempty(find(contains({handles.listing.name},['ref',num2str(14)])))
%                             otherInds = [otherInds find(contains({handles.listing.name},['ref',num2str(14)]))];
%                         end
%                         if ~isempty(find(contains({handles.listing.name},['ref',num2str(15)])))
%                             otherInds = [otherInds find(contains({handles.listing.name},['ref',num2str(15)]))];
%                         end
%                         if isequal(oneInds,sort(otherInds,'ascend'))
%                             handles.returnNum(handles.returnNum==1) = [];
%                         end
%                     end
%                     go = 1;
%                     checkReturn = 1;
%                     while go
%                         if isempty(find(contains({handles.listing.name},['ref',num2str(handles.returnNum(checkReturn))])))
%                             handles.returnNum(checkReturn) = [];
%                             checkReturn = checkReturn - 1;
%                         end
%                         if checkReturn == length(handles.returnNum)
%                             go = 0;
%                         end
%                         checkReturn = checkReturn + 1;
%                     end
%                     
%             for j = 1:length(handles.returnNum)
%                 handles.stimNum = handles.origstimNum;
%                 handles.avgMisalignPlot3D(j) = figure('units','normalized','outerposition',[0 0 1 1]);
%                 sgtitle(handles.avgMisalignPlot3D(j),{['3D Angle of Misalignment, Return ',num2str(handles.returnNum(j)),', ',handles.figdir]; ' '},'FontSize', 22, 'FontWeight', 'Bold');
%                     
%                 
%                 if handles.LEyeFlag.Value + handles.REyeFlag.Value == 2
%                     
%                     handles.fig(i,j).avgMagaxL = subtightplot(2,length(handles.returnNum),j,[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMagPlot(i));
%                     handles.fig(i,j).avgMagaxR = subtightplot(2,length(handles.returnNum),j+length(handles.returnNum),[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMagPlot(i));
%                     
%                     handles.fig(i,j).avgMisalignaxL = subtightplot(2,length(handles.returnNum),j,[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot(i));
%                     handles.fig(i,j).avgMisalignaxR = subtightplot(2,length(handles.returnNum),j+length(handles.returnNum),[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot(i));
%                     
%                     handles.fig(i,j).avgMagaxL.XTickLabel = [];
%                     handles.fig(i,j).avgMagaxR.XTick = [0:50:300];
%                     handles.fig(i,j).avgMisalignaxL.XTickLabel = [];
%                     handles.fig(i,j).avgMisalignaxR.XTick = [0:50:300];
%                     handles.fig(i,j).avgMagaxL.XGrid = 'on';
%                     handles.fig(i,j).avgMagaxR.XGrid = 'on';
%                     handles.fig(i,j).avgMagaxL.YGrid = 'on';
%                     handles.fig(i,j).avgMagaxR.YGrid = 'on';
%                     handles.fig(i,j).avgMisalignaxL.XGrid = 'on';
%                     handles.fig(i,j).avgMisalignaxR.XGrid = 'on';
%                     handles.fig(i,j).avgMisalignaxL.YGrid = 'on';
%                     handles.fig(i,j).avgMisalignaxR.YGrid = 'on';
%                     handles.fig(i,j).avgMagaxR.XLim = [0 350];
%                     handles.fig(i,j).avgMagaxL.XLim = [0 350];
%                     handles.fig(i,j).avgMisalignaxR.XLim = [0 350];
%                     handles.fig(i,j).avgMisalignaxL.XLim = [0 350];
%                     handles.fig(i,j).avgMagaxR.XTick = [0:50:300];
%                     handles.fig(i,j).avgMisalignaxR.XTick = [0:50:300];
%                     
%                     handles.fig(i,j).avgMisalign3D.R = subtightplot(1,2,1,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot3D(j));
%                     handles.fig(i,j).avgMisalign3D.L = subtightplot(1,2,2,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot3D(j));
%                     handles.fig(i,j).avgMisalign3D.R.XGrid = 'on';
%                     handles.fig(i,j).avgMisalign3D.R.YGrid = 'on';
%                     handles.fig(i,j).avgMisalign3D.L.XGrid = 'on';
%                     handles.fig(i,j).avgMisalign3D.L.YGrid = 'on';
%                     handles.fig(i,j).avgMisalign3D.L.Title.String = 'Left Eye 3D Misalignment';
%                     handles.fig(i,j).avgMisalign3D.L.FontSize = 13.5;
%                     handles.fig(i,j).avgMisalign3D.R.Title.String = 'Right Eye 3D Misalignment';
%                     handles.fig(i,j).avgMisalign3D.R.FontSize = 13.5;
%                 elseif handles.LEyeFlag.Value
%                     
%                     handles.fig(i,j).avgMagaxL = subtightplot(1,length(handles.returnNum),j,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMagPlot(i));
%                     handles.fig(i,j).avgMisalignaxL = subtightplot(1,length(handles.returnNum),j,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot(i));
%                     handles.fig(i,j).avgMagaxL.XTick = [0:50:300];
%                     handles.fig(i,j).avgMisalignaxL.XTick = [0:50:300];
%                     handles.fig(i,j).avgMagaxL.XGrid = 'on';
%                     handles.fig(i,j).avgMagaxL.YGrid = 'on';
%                     handles.fig(i,j).avgMisalignaxL.XGrid = 'on';
%                     handles.fig(i,j).avgMisalignaxL.YGrid = 'on';
%                     handles.fig(i,j).avgMagaxL.XLim = [0 350];
%                     handles.fig(i,j).avgMisalignaxL.XLim = [0 350];
%                     handles.fig(i,j).avgMagaxL.XTick = [0:50:300];
%                     handles.fig(i,j).avgMisalignaxL.XTick = [0:50:300];
%                     
%                     
%                     handles.fig(i,j).avgMisalign3D.L = axes('Parent', handles.avgMisalignPlot3D(j));
%                     handles.fig(i,j).avgMisalign3D.L.XGrid = 'on';
%                     handles.fig(i,j).avgMisalign3D.L.YGrid = 'on';
%                     handles.fig(i,j).avgMisalign3D.L.Title.String = 'Left Eye 3D Misalignment';
%                     handles.fig(i,j).avgMisalign3D.L.FontSize = 13.5;
%                 elseif handles.REyeFlag.Value
%                     
%                     handles.fig(i,j).avgMagaxR = subtightplot(1,length(handles.returnNum),j,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMagPlot(i));
%                     handles.fig(i,j).avgMisalignaxR = subtightplot(1,length(handles.returnNum),j,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot(i));
%                     handles.fig(i,j).avgMagaxR.XTick = [0:50:300];
%                     handles.fig(i,j).avgMisalignaxR.XTick = [0:50:300];
%                     handles.fig(i,j).avgMagaxR.XGrid = 'on';
%                     handles.fig(i,j).avgMagaxR.YGrid = 'on';
%                     handles.fig(i,j).avgMisalignaxR.XGrid = 'on';
%                     handles.fig(i,j).avgMisalignaxR.YGrid = 'on';
%                     handles.fig(i,j).avgMagaxR.XLim = [0 350];
%                     handles.fig(i,j).avgMisalignaxR.XLim = [0 350];
%                     handles.fig(i,j).avgMagaxR.XTick = [0:50:300];
%                     handles.fig(i,j).avgMisalignaxR.XTick = [0:50:300];
%                     
%                     
%                     handles.fig(i,j).avgMisalign3D.R = axes('Parent', handles.avgMisalignPlot3D(j));
%                     handles.fig(i,j).avgMisalign3D.R.XGrid = 'on';
%                     handles.fig(i,j).avgMisalign3D.R.YGrid = 'on';
%                     handles.fig(i,j).avgMisalign3D.R.Title.String = 'Right Eye 3D Misalignment';
%                     handles.fig(i,j).avgMisalign3D.R.FontSize = 13.5;
%                 end
%                 
%                 handles.ldg3D.lines = {};
%                 handles.ldg3D.AP = {};
%                 
%                 if handles.LEyeFlag.Value
%                     set( handles.avgMisalignPlot3D(j),'CurrentAxes',handles.fig(i,j).avgMisalign3D.L)
%                     hold(handles.fig(i,j).avgMisalign3D.L,'on');
%                     h=plot3vect([1/sqrt(2);-1/sqrt(2);0],'LARP Axis',[0 1 0],2);
%                     set(h,'LineStyle','--','Marker','o');
%                     h=plot3vect([1/sqrt(2);1/sqrt(2);0],'RALP Axis',[0 1 1],2);
%                     set(h,'LineStyle','--','Marker','o');
%                     h=plot3vect([0;0;1],'Yaw Axis',[0.68 0 0],2);
%                     set(h,'LineStyle','--','Marker','o');
%                     
%                     [x,y,z]=sphere();
%                     h=surf(0.5*x,0.5*y,0.5*z);
%                     set(h,'FaceColor','white')
%                     handles.fig(i,j).avgMisalign3D.L.View = [90 -0.5];
%                     axis vis3d
%                     axis equal
%                     box on;
%                     xlim([-1 1])
%                     ylim([-1 1])
%                     zlim([-1 1])
%                     hold(handles.fig(i,j).avgMisalign3D.L,'off');
%                     
%                     if j>1
%                         handles.fig(i,j).avgMagaxL.YTickLabel = [];
%                         handles.fig(i,j).avgMisalignaxL.YTickLabel = [];
%                     end
%                 end
%                 if handles.REyeFlag.Value
%                     set( handles.avgMisalignPlot3D(j),'CurrentAxes',handles.fig(i,j).avgMisalign3D.R)
%                     hold(handles.fig(i,j).avgMisalign3D.R,'on');
%                     h=plot3vect([1/sqrt(2);-1/sqrt(2);0],'LARP Axis',[0 1 0],2);
%                     set(h,'LineStyle','--','Marker','o');
%                     h=plot3vect([1/sqrt(2);1/sqrt(2);0],'RALP Axis',[0 1 1],2);
%                     set(h,'LineStyle','--','Marker','o');
%                     h=plot3vect([0;0;1],'Yaw Axis',[0.68 0 0],2);
%                     set(h,'LineStyle','--','Marker','o');
%                     
%                     [x,y,z]=sphere();
%                     h=surf(0.5*x,0.5*y,0.5*z);
%                     set(h,'FaceColor','white')
%                     handles.fig(i,j).avgMisalign3D.R.View = [90 -0.5];
%                     axis vis3d
%                     axis equal
%                     box on;
%                     xlim([-1 1])
%                     ylim([-1 1])
%                     zlim([-1 1])
%                     hold(handles.fig(i,j).avgMisalign3D.R,'off');
%                     if j>1
%                         handles.fig(i,j).avgMagaxR.YTickLabel = [];
%                         handles.fig(i,j).avgMisalignaxR.YTickLabel = [];
%                     end
%                 end
%                 if handles.bipolarstim.Value
%                     handles.stimNum = handles.stimNum(~(handles.stimNum==handles.returnNum(j)));
%                 end
%                 
%                
%                 go = 1;
%                 stimTest = 1;
%                 while go
%                         if ~isempty(find(contains({handles.listing.name},['stim',num2str(handles.stimNum(stimTest)),'ref',num2str(handles.returnNum(j))])))
%                             
%                         else
%                             handles.stimNum(stimTest) = [];
%                             stimTest = stimTest - 1;
%                         end
%                     
%                     if stimTest == length(handles.stimNum)
%                         go = 0;
%                     end
%                     stimTest = stimTest + 1;
%                 end
%                 for k = 1:length(handles.stimNum)
%                     switch handles.stimNum(k)
%                         case 1
%                             colorPlot = [65 82 31]/255;
%                         case 2
%                             colorPlot = [72 169 60]/255;
%                         case 3
%                             colorPlot = [40 82 56]/255;
%                         case 4
%                             colorPlot = [13 0 164]/255;
%                         case 5
%                             colorPlot = [18 53 91]/255;
%                         case 6
%                             colorPlot = [3 157 201]/255;
%                         case 7
%                             colorPlot = [215 38 56]/255;
%                         case 8
%                             colorPlot = [158 43 37]/255;
%                         case 9
%                             colorPlot = [219 108 35]/255;
%                         case 10
%                             colorPlot = [57 61 63]/255;
%                         case 11
%                             colorPlot = [246 189 96]/255;
%                         case 12
%                             colorPlot = [115 98 138]/255;
%                         case 13
%                             colorPlot = [135 142 136]/255;
%                         case 14
%                             colorPlot = [51 92 103]/255;
%                         case 15
%                             colorPlot = [107 15 26]/255;
%                     end
%                     
%                     if isempty(handles.ldg3D.lines)
%                         handles.ldg3D.lines = {['Stim ',num2str(handles.stimNum(k))]};
%                     elseif strcmp(handles.ldg3D.lines,['Stim ',num2str(handles.stimNum(k))])
%                     else
%                         handles.ldg3D.lines = [handles.ldg3D.lines,{['Stim ',num2str(handles.stimNum(k))]}];
%                     end
%                     
% 
%                         toplotInds = find(contains({handles.listing.name},['stim',num2str(handles.stimNum(k)),'ref',num2str(handles.returnNum(j))]));
%                     for l = 1:length(toplotInds)
%                         load(handles.listing(toplotInds(l)).name)
%                         filename = handles.listing(toplotInds(l)).name;
%                         dotF = find(filename=='.');
%                         amp = strfind(filename,'amp');
%                         underS = find(filename=='_');
%                         dash = find(filename=='-');
%                         delin = sort([underS dash],'ascend');
%                         handles.fig(i,j).cycles(l,k).stim = handles.stimNum(k);
%                         handles.fig(i,j).cycles(l,k).ref = handles.returnNum(j);
%                         handles.fig(i,j).cycles(l,k).axis = handles.figdir;
%                         nextD = find(delin>amp,1);
%                         if any(strfind(filename,'rate'))
%                             ratePos = strfind(filename,'rate');
%                             handles.fig(i,j).cycles(l,k).amp = str2num(filename(amp(1)+3:ratePos-1));
%                         else
%                         handles.fig(i,j).cycles(l,k).amp = str2num(filename(amp(1)+3:delin(nextD)-1));
%                         end
%                         handles.fig(i,j).cycles(l,k).twitch = Results.FacialNerve;
%                         
%                         if handles.LEyeFlag.Value
%                             handles.fig(i,j).cycles(l,k).cycavgL = [Results.ll_cycavg' Results.lr_cycavg' Results.lz_cycavg'];
%                             tL = 1/Results.Fs:1/Results.Fs:length(Results.ll_cycavg)/Results.Fs;
%                             handles.fig(i,j).cycles(l,k).timeL = [tL' tL' tL'];
%                             handles.fig(i,j).cycles(l,k).stdL = [Results.ll_cycstd' Results.lr_cycstd' Results.lz_cycstd'];
%                             
%                             d = diff(Results.ll_cyc');
%                             
%                             maxMagL = [];
%                             avgMisalignL = [];
%                             misalign3DL = [];
%                             for s = 1:size(d,2)
%                                 [avgMisalignCycL, maxMagCycL, wL] = maxMagThreshL(s,handles,Results);
%                                 avgMisalignL = [avgMisalignL; avgMisalignCycL];
%                                 maxMagL = [maxMagL; maxMagCycL];
%                                 misalign3DL = [misalign3DL; wL];
%                             end
%                             
%                             handles.fig(i,j).cycles(l,k).maxMagL = maxMagL;
%                             handles.fig(i,j).cycles(l,k).avgMisalignL = avgMisalignL;
%                             meanM = mean(misalign3DL);
%                             handles.fig(i,j).cycles(l,k).avgmisalign3DL = meanM/norm(meanM);
%                             rot = [cosd(-45) -sind(-45) 0;...
%                                 sind(-45) cosd(-45) 0;...
%                                 0 0 1];
%                             mis3DPlot = (rot*handles.fig(i,j).cycles(l,k).avgmisalign3DL')';
%                             
%                             set( handles.avgMisalignPlot3D(j),'CurrentAxes',handles.fig(i,j).avgMisalign3D.L);
%                             hold(handles.fig(i,j).avgMisalign3D.L,'on');
%                             handles.fig(i,j).mis3D(l,k).lPlotL = plot3([0 mis3DPlot(1)]',[0 mis3DPlot(2)]',[0 mis3DPlot(3)]');
%                             set(handles.fig(i,j).mis3D(l,k).lPlotL,'LineWidth',2,'DisplayName','','Color',colorPlot)
%                             switch handles.fig(i,j).cycles(l,k).amp
%                                 case 20
%                                     markerToUse = 'o';
%                                 case 50
%                                     markerToUse = '+';
%                                 case 75
%                                     markerToUse = '*';
%                                 case 100
%                                     markerToUse = '^';
%                                 case 125
%                                     markerToUse = 's';
%                                 case 150
%                                     markerToUse = 'd';
%                                 case 200
%                                     markerToUse = '<';
%                                 case 250
%                                     markerToUse = 'p';
%                                 case 300
%                                     markerToUse = 'h';
%                             end
%                             if l==1
%                                 handles.fig(i,j).mis3D(l,k).lPlotFakeL = plot3([0 .01]',[0 .01]',[0 .01]');
%                                 set(handles.fig(i,j).mis3D(l,k).lPlotFakeL,'LineWidth',2,'DisplayName','','Color',colorPlot)
%                             end
%                             if isempty(handles.ldg3D.AP)
%                                 handles.ldg3D.AP = {[num2str(handles.fig(i,j).cycles(l,k).amp),' uA']};
%                                 handles.fig(i,j).mis3D(l,k).pPlotFakeL = plot3(0,0,0,'Marker',markerToUse,'MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2,'Linestyle', 'none');
%                             elseif any(strcmp(handles.ldg3D.AP,[num2str(handles.fig(i,j).cycles(l,k).amp),' uA']))
%                             else
%                                 handles.ldg3D.AP = [handles.ldg3D.AP,{[num2str(handles.fig(i,j).cycles(l,k).amp),' uA']}];
%                                 handles.fig(i,j).mis3D(l,k).pPlotFakeL = plot3(0,0,0,'Marker',markerToUse,'MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2,'Linestyle', 'none');
%                             end
%                             
%                             handles.fig(i,j).mis3D(l,k).pPlotL = plot3(mis3DPlot(1),mis3DPlot(2),mis3DPlot(3),'o');
%                             set(handles.fig(i,j).mis3D(l,k).pPlotL,'LineWidth',2,'DisplayName','','Marker',markerToUse,'MarkerSize',10,'MarkerEdgeColor',colorPlot)
%                             
%                             if any(handles.fig(i,j).cycles(l,k).twitch)
%                                 twitchPlotL = plot3(mis3DPlot(1),mis3DPlot(2),mis3DPlot(3),'rx','MarkerSize', 20,'LineWidth',3,'Linestyle', 'none');
%                             end
%                             hold(handles.fig(i,j).avgMisalign3D.L,'off');
%                             
%                             set( handles.avgMagPlot(i),'CurrentAxes',handles.fig(i,j).avgMagaxL);
%                             hold(handles.fig(i,j).avgMagaxL,'on');
%                             handles.fig(i,j).p(k).ptL(l) = plot(handles.fig(i,j).avgMagaxL,handles.fig(i,j).cycles(l,k).amp,mean(handles.fig(i,j).cycles(l,k).maxMagL),'color',colorPlot,'marker','o','MarkerSize',10,'LineWidth',2);
%                             handles.fig(i,j).cycles(l,k).VstdevL =  std(handles.fig(i,j).cycles(l,k).maxMagL);
%                             errorbar(handles.fig(i,j).avgMagaxL,handles.fig(i,j).cycles(l,k).amp,mean(handles.fig(i,j).cycles(l,k).maxMagL),handles.fig(i,j).cycles(l,k).VstdevL,'color',colorPlot,'LineWidth',2.5);
%                             handles.fig(i,j).avgMagaxL.LineWidth = 2.5;
%                             hold(handles.fig(i,j).avgMagaxL,'off');
%                             
%                             set( handles.avgMisalignPlot(i),'CurrentAxes',handles.fig(i,j).avgMisalignaxL);
%                             hold(handles.fig(i,j).avgMisalignaxL,'on');
%                             handles.fig(i,j).q(k).ptL(l) = plot(handles.fig(i,j).avgMisalignaxL,handles.fig(i,j).cycles(l,k).amp,mean(handles.fig(i,j).cycles(l,k).avgMisalignL),'color',colorPlot,'marker','o','MarkerSize',10,'LineWidth',2);
%                             
%                             handles.fig(i,j).cycles(l,k).MstdevL =  std(handles.fig(i,j).cycles(l,k).avgMisalignL);
%                             errorbar(handles.fig(i,j).avgMisalignaxL,handles.fig(i,j).cycles(l,k).amp,mean(handles.fig(i,j).cycles(l,k).avgMisalignL),handles.fig(i,j).cycles(l,k).MstdevL,'color',colorPlot,'LineWidth',2.5);
%                             
%                             handles.fig(i,j).avgMisalignaxL.LineWidth = 2.5;
%                             hold(handles.fig(i,j).avgMisalignaxL,'off');
%                             
%                         end
%                         
%                         if handles.REyeFlag.Value
%                             
%                             maxMagR = [];
%                             avgMisalignR = [];
%                             misalign3DR = [];
%                             
%                             for s = 1:size(d,2)
%                                 [avgMisalignCycR, maxMagCycR, wR] = maxMagThreshR(s,handles,Results);
%                                 avgMisalignR = [avgMisalignR; avgMisalignCycR];
%                                 maxMagR = [maxMagR; maxMagCycR];
%                                 misalign3DR = [misalign3DR; wR];
%                             end
%                             
%                             handles.fig(i,j).cycles(l,k).maxMagR = maxMagR;
%                             handles.fig(i,j).cycles(l,k).avgMisalignR = avgMisalignR;
%                             meanM = mean(misalign3DR);
%                             handles.fig(i,j).cycles(l,k).avgmisalign3DR = meanM/norm(meanM);
%                             rot = [cosd(-45) -sind(-45) 0;...
%                                 sind(-45) cosd(-45) 0;...
%                                 0 0 1];
%                             mis3DPlot = (rot*handles.fig(i,j).cycles(l,k).avgmisalign3DR')';
%                             
%                             set( handles.avgMisalignPlot3D(j),'CurrentAxes',handles.fig(i,j).avgMisalign3D.R);
%                             hold(handles.fig(i,j).avgMisalign3D.R,'on');
%                             handles.fig(i,j).mis3D(l,k).lPlotR = plot3([0 mis3DPlot(1)]',[0 mis3DPlot(2)]',[0 mis3DPlot(3)]');
%                             set(handles.fig(i,j).mis3D(l,k).lPlotR,'LineWidth',2,'DisplayName','','Color',colorPlot)
%                             switch handles.fig(i,j).cycles(l,k).amp
%                                 case 20
%                                     markerToUse = 'o';
%                                 case 50
%                                     markerToUse = '+';
%                                 case 75
%                                     markerToUse = '*';
%                                 case 100
%                                     markerToUse = '^';
%                                 case 125
%                                     markerToUse = 's';
%                                 case 150
%                                     markerToUse = 'd';
%                                 case 200
%                                     markerToUse = '<';
%                                 case 250
%                                     markerToUse = 'p';
%                                 case 300
%                                     markerToUse = 'h';
%                             end
%                             if l==1
%                                 handles.fig(i,j).mis3D(l,k).lPlotFakeR = plot3([0 .01]',[0 .01]',[0 .01]');
%                                 set(handles.fig(i,j).mis3D(l,k).lPlotFakeR,'LineWidth',2,'DisplayName','','Color',colorPlot)
%                             end
%                             if isempty(handles.ldg3D.AP)
%                                 handles.ldg3D.AP = {[num2str(handles.fig(i,j).cycles(l,k).amp),' uA']};
%                                 handles.fig(i,j).mis3D(l,k).pPlotFakeR = plot3(0,0,0,'Marker',markerToUse,'MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2,'Linestyle', 'none');
%                             elseif any(strcmp(handles.ldg3D.AP,[num2str(handles.fig(i,j).cycles(l,k).amp),' uA']))
%                             else
%                                 handles.ldg3D.AP = [handles.ldg3D.AP,{[num2str(handles.fig(i,j).cycles(l,k).amp),' uA']}];
%                                 handles.fig(i,j).mis3D(l,k).pPlotFakeR = plot3(0,0,0,'Marker',markerToUse,'MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2,'Linestyle', 'none');
%                             end
%                             
%                             handles.fig(i,j).mis3D(l,k).pPlotR = plot3(mis3DPlot(1),mis3DPlot(2),mis3DPlot(3),'o');
%                             set(handles.fig(i,j).mis3D(l,k).pPlotR,'LineWidth',2,'DisplayName','','Marker',markerToUse,'MarkerSize',10,'MarkerEdgeColor',colorPlot)
%                             
%                             if any(handles.fig(i,j).cycles(l,k).twitch)
%                                 twitchPlotR = plot3(mis3DPlot(1),mis3DPlot(2),mis3DPlot(3),'rx','MarkerSize', 20,'LineWidth',3,'Linestyle', 'none');
%                             end
%                             hold(handles.fig(i,j).avgMisalign3D.R,'off');
%                             
%                             set( handles.avgMagPlot(i),'CurrentAxes',handles.fig(i,j).avgMagaxR);
%                             hold(handles.fig(i,j).avgMagaxR,'on');
%                             handles.fig(i,j).p(k).ptR(l) = plot(handles.fig(i,j).avgMagaxR,handles.fig(i,j).cycles(l,k).amp,mean(handles.fig(i,j).cycles(l,k).maxMagR),'color',colorPlot,'marker','o','MarkerSize',10,'LineWidth',2);
%                             handles.fig(i,j).cycles(l,k).VstdevR =  std(handles.fig(i,j).cycles(l,k).maxMagR);
%                             errorbar(handles.fig(i,j).avgMagaxR,handles.fig(i,j).cycles(l,k).amp,mean(handles.fig(i,j).cycles(l,k).maxMagR),handles.fig(i,j).cycles(l,k).VstdevR,'color',colorPlot,'LineWidth',2.5);
%                             handles.fig(i,j).avgMagaxR.LineWidth = 2.5;
%                             hold(handles.fig(i,j).avgMagaxR,'off');
%                             
%                             set( handles.avgMisalignPlot(i),'CurrentAxes',handles.fig(i,j).avgMisalignaxR);
%                             hold(handles.fig(i,j).avgMisalignaxR,'on');
%                             handles.fig(i,j).q(k).ptR(l) = plot(handles.fig(i,j).avgMisalignaxR,handles.fig(i,j).cycles(l,k).amp,mean(handles.fig(i,j).cycles(l,k).avgMisalignR),'color',colorPlot,'marker','o','MarkerSize',10,'LineWidth',2);
%                             
%                             handles.fig(i,j).cycles(l,k).MstdevR =  std(handles.fig(i,j).cycles(l,k).avgMisalignR);
%                             errorbar(handles.fig(i,j).avgMisalignaxR,handles.fig(i,j).cycles(l,k).amp,mean(handles.fig(i,j).cycles(l,k).avgMisalignR),handles.fig(i,j).cycles(l,k).MstdevR,'color',colorPlot,'LineWidth',2.5);
%                             
%                             handles.fig(i,j).avgMisalignaxR.LineWidth = 2.5;
%                             hold(handles.fig(i,j).avgMisalignaxR,'off');
%                             
%                             
%                             
%                         end
%                         
%                         
%                     end
%                     if handles.LEyeFlag.Value
%                         set( handles.avgMagPlot(i),'CurrentAxes',handles.fig(i,j).avgMagaxL);
%                         hold(handles.fig(i,j).avgMagaxL,'on');
%                         line(handles.fig(i,j).avgMagaxL,[handles.fig(i,j).p(k).ptL.XData],[handles.fig(i,j).p(k).ptL.YData],'color',colorPlot,'LineWidth',4)
%                         hold(handles.fig(i,j).avgMagaxL,'off');
%                         handles.fig(i,j).avgMagaxL.XLabel.String = {'Current (uA)'};
%                         handles.fig(i,j).avgMagaxL.XLabel.FontSize = 22;
%                         
%                         set( handles.avgMisalignPlot(i),'CurrentAxes',handles.fig(i,j).avgMisalignaxL);
%                         hold(handles.fig(i,j).avgMisalignaxL,'on');
%                         line(handles.fig(i,j).avgMisalignaxL,[handles.fig(i,j).q(k).ptL.XData],[handles.fig(i,j).q(k).ptL.YData],'color',colorPlot,'LineWidth',4)
%                         hold(handles.fig(i,j).avgMisalignaxL,'off');
%                         handles.fig(i,j).avgMisalignaxL.XLabel.String = {'Current (uA)'};
%                         handles.fig(i,j).avgMisalignaxL.XLabel.FontSize = 22;
%                     end
%                     if handles.REyeFlag.Value
%                         set( handles.avgMagPlot(i),'CurrentAxes',handles.fig(i,j).avgMagaxR);
%                         hold(handles.fig(i,j).avgMagaxR,'on');
%                         line(handles.fig(i,j).avgMagaxR,[handles.fig(i,j).p(k).ptR.XData],[handles.fig(i,j).p(k).ptR.YData],'color',colorPlot,'LineWidth',4)
%                         hold(handles.fig(i,j).avgMagaxR,'off');
%                         handles.fig(i,j).avgMagaxR.XLabel.String = {'Current (uA)'};
%                         handles.fig(i,j).avgMagaxR.XLabel.FontSize = 22;
%                         
%                         set( handles.avgMisalignPlot(i),'CurrentAxes',handles.fig(i,j).avgMisalignaxR);
%                         hold(handles.fig(i,j).avgMisalignaxR,'on');
%                         line(handles.fig(i,j).avgMisalignaxR,[handles.fig(i,j).q(k).ptR.XData],[handles.fig(i,j).q(k).ptR.YData],'color',colorPlot,'LineWidth',4)
%                         hold(handles.fig(i,j).avgMisalignaxR,'off');
%                         handles.fig(i,j).avgMisalignaxR.XLabel.String = {'Current (uA)'};
%                         handles.fig(i,j).avgMisalignaxR.XLabel.FontSize = 22;
%                     end
%                     if handles.REyeFlag.Value && handles.LEyeFlag.Value
%                         handles.fig(i,j).avgMagaxL.XLabel.String = '';
%                         handles.fig(i,j).avgMisalignaxL.XLabel.String = '';
%                     end
%                 end
%                 twitchLDG = 0;
%                 returnLab = 0;
%                 if handles.LEyeFlag.Value
%                     if any(handles.fig(i,j).cycles(l,k).twitch) && ~twitchLDG
%                         ldg3D = legend(handles.fig(i,j).avgMisalign3D.L,[handles.fig(i,j).mis3D.lPlotFakeL handles.fig(i,j).mis3D.pPlotFakeL twitchPlotL],[handles.ldg3D.lines handles.ldg3D.AP {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
%                         twitchLDG = 1;
%                     else
%                         ldg3D = legend(handles.fig(i,j).avgMisalign3D.L,[handles.fig(i,j).mis3D.lPlotFakeL handles.fig(i,j).mis3D.pPlotFakeL],[handles.ldg3D.lines handles.ldg3D.AP],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
%                         twitchLDG = 1;
%                     end
%                     if j ==1
%                         ylabel(handles.fig(i,j).avgMagaxL,'Left Eye Velocity Magnitude (dps)','FontSize',22);
%                         handles.fig(i,j).avgMagaxL.FontSize = 13.5;
%                         ylabel(handles.fig(i,j).avgMisalignaxL,'Left Eye Velocity Misalignment (degrees)','FontSize',22);
%                         handles.fig(i,j).avgMisalignaxL.FontSize = 13.5;
%                     end
%                     
%                     handles.fig(i,j).avgMagaxL.Title.String = ['Return ', num2str(handles.returnNum(j))];
%                     handles.fig(i,j).avgMisalignaxL.Title.String = ['Return ', num2str(handles.returnNum(j))];
%                     returnLab = 1;
%                     sameaxes([], [handles.fig(i,:).avgMagaxL]);
%                     sameaxes([], [handles.fig(i,:).avgMisalignaxL]);
%                     handles.fig(i,j).avgMagaxL.FontSize = 13.5;
%                     handles.fig(i,j).avgMisalignaxL.FontSize = 13.5;
%                     
%                     for rN = 1:length(handles.stimNum)
%                         ldgPos = find(handles.origstimNum == handles.stimNum(rN));
%                         if ldgNames{ldgPos} == ' '
%                             ldgNames{ldgPos} = ['Source ',num2str(handles.stimNum(rN))];
%                             lines(ldgPos) = [handles.fig(i,j).p(rN).ptL(1)];
%                         end
%                     end
%                     
%                     all = size(handles.fig(i,j).cycles);
%                     for m = 1:all(2)
%                         for n = 1:all(1)
%                             if any([handles.fig(i,j).cycles(n,m).twitch])
%                                 set( handles.avgMisalignPlot(i),'CurrentAxes',handles.fig(i,j).avgMisalignaxL);
%                                 hold(handles.fig(i,j).avgMisalignaxL,'on') %%%% Do red triangles instead of lines
%                                 cutOff1 = plot(handles.fig(i,j).avgMisalignaxL,handles.fig(i,j).cycles(n,m).amp,mean(handles.fig(i,j).cycles(n,m).avgMisalignL),'rx','MarkerSize', 20,'LineWidth',3);
%                                 hold(handles.fig(i,j).avgMisalignaxL,'off')
%                                 
%                                 set( handles.avgMagPlot(i),'CurrentAxes',handles.fig(i,j).avgMagaxL);
%                                 hold(handles.fig(i,j).avgMagaxL,'on')
%                                 cutOff2 = plot(handles.fig(i,j).avgMagaxL,handles.fig(i,j).cycles(n,m).amp,mean(handles.fig(i,j).cycles(n,m).maxMagL),'rx','MarkerSize', 20,'LineWidth',3);
%                                 hold(handles.fig(i,j).avgMagaxL,'off')
%                             end
%                         end
%                     end
%                 end
%                 
%                 if handles.REyeFlag.Value
%                     if (twitchLDG==0)
%                         if any(handles.fig(i,j).cycles(l,k).twitch)
%                             ldg3D = legend(handles.fig(i,j).avgMisalign3D.R,[handles.fig(i,j).mis3D.lPlotFakeR handles.fig(i,j).mis3D.pPlotFakeR twitchPlotR],[handles.ldg3D.lines handles.ldg3D.AP {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
%                         else
%                             ldg3D = legend(handles.fig(i,j).avgMisalign3D.R,[handles.fig(i,j).mis3D.lPlotFakeR handles.fig(i,j).mis3D.pPlotFakeR],[handles.ldg3D.lines handles.ldg3D.AP],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
%                         end
%                     end
%                     if j ==1
%                         ylabel(handles.fig(i,j).avgMagaxR,'Right Eye Velocity Magnitude (dps)','FontSize',22);
%                         handles.fig(i,j).avgMagaxR.FontSize = 13.5;
%                         ylabel(handles.fig(i,j).avgMisalignaxR,'Right Eye Velocity Misalignment (degrees)','FontSize',22);
%                         handles.fig(i,j).avgMisalignaxR.FontSize = 13.5;
%                     end
%                     if returnLab == 0
%                         handles.fig(i,j).avgMagaxR.Title.String = ['Return ', num2str(handles.returnNum(j))];
%                         handles.fig(i,j).avgMisalignaxR.Title.String = ['Return ', num2str(handles.returnNum(j))];
%                     end
%                     sameaxes([], [handles.fig(i,:).avgMagaxR]);
%                     sameaxes([], [handles.fig(i,:).avgMisalignaxR]);
%                     handles.fig(i,j).avgMagaxR.FontSize = 13.5;
%                     handles.fig(i,j).avgMisalignaxR.FontSize = 13.5;
%                     
%                     for rN = 1:length(handles.stimNum)
%                         ldgPos = find(handles.origstimNum == handles.stimNum(rN));
%                         if ldgNames{ldgPos} == ' '
%                             ldgNames{ldgPos} = ['Source ',num2str(handles.stimNum(rN))];
%                             lines(ldgPos) = [handles.fig(i,j).p(rN).ptR(1)];
%                         end
%                     end
%                     
%                     all = size(handles.fig(i,j).cycles);
%                     for m = 1:all(2)
%                         for n = 1:all(1)
%                             if any([handles.fig(i,j).cycles(n,m).twitch])
%                                 
%                                 set( handles.avgMisalignPlot(i),'CurrentAxes',handles.fig(i,j).avgMisalignaxR);
%                                 hold(handles.fig(i,j).avgMisalignaxR,'on') %%%% Do red triangles instead of lines
%                                 cutOff1 = plot(handles.fig(i,j).avgMisalignaxR,handles.fig(i,j).cycles(n,m).amp,mean(handles.fig(i,j).cycles(n,m).avgMisalignR),'rx','MarkerSize', 20,'LineWidth',3);
%                                 hold(handles.fig(i,j).avgMisalignaxR,'off')
%                                 
%                                 set( handles.avgMagPlot(i),'CurrentAxes',handles.fig(i,j).avgMagaxR);
%                                 hold(handles.fig(i,j).avgMagaxR,'on')
%                                 cutOff2 = plot(handles.fig(i,j).avgMagaxR,handles.fig(i,j).cycles(n,m).amp,mean(handles.fig(i,j).cycles(n,m).maxMagR),'rx','MarkerSize', 20,'LineWidth',3);
%                                 hold(handles.fig(i,j).avgMagaxR,'off')
%                             end
%                         end
%                     end
%                 end
%                 if handles.LEyeFlag.Value + handles.REyeFlag.Value == 2
%                     sameaxes([], [handles.fig(i,:).avgMagaxR handles.fig(i,:).avgMagaxL]);
%                     sameaxes([], [handles.fig(i,:).avgMisalignaxR handles.fig(i,:).avgMisalignaxL]);
%                 end
%                 
%                 if handles.LEyeFlag.Value && handles.REyeFlag.Value
%                     if handles.stimulatingE.Value
%                         misalgn3DName = [handles.figDir,'\eyeMisalignment3D_ByStimE_R&Leye_Stim',num2str(handles.stimNum(j)),'_',handles.figdir];
%                     elseif handles.referenceE.Value
%                         misalgn3DName = [handles.figDir,'\eyeMisalignment3D_ByRefE_R&Leye_Ref',num2str(handles.returnNum(j)),'_',handles.figdir];
%                     end
%                     
%                 elseif handles.LEyeFlag.Value
%                     if handles.stimulatingE.Value
%                         misalgn3DName = [handles.figDir,'\eyeMisalignment3D_ByStimE_Leye_Stim',num2str(handles.stimNum(j)),'_',handles.figdir];
%                     elseif handles.referenceE.Value
%                         misalgn3DName = [handles.figDir,'\eyeMisalignment3D_ByRefE_Leye_Ref',num2str(handles.returnNum(j)),'_',handles.figdir];
%                     end
%                 elseif handles.REyeFlag.Value
%                     if handles.stimulatingE.Value
%                         misalgn3DName = [handles.figDir,'\eyeMisalignment3D_ByStimE_Reye_Stim',num2str(handles.stimNum(j)),'_',handles.figdir];
%                     elseif handles.referenceE.Value
%                         misalgn3DName = [handles.figDir,'\eyeMisalignment3D_ByRefE_Reye_Ref',num2str(handles.returnNum(j)),'_',handles.figdir];
%                     end
%                 end
%                 saveas(handles.avgMisalignPlot3D(j),[misalgn3DName,'.svg']);
%                 saveas(handles.avgMisalignPlot3D(j),[misalgn3DName,'.jpg']);
%                 saveas(handles.avgMisalignPlot3D(j),[misalgn3DName,'.fig']);
%                 close(handles.avgMisalignPlot3D(j));
%                 
%                 
%             end
%             
%         end
%         
%         if handles.LEyeFlag.Value + handles.REyeFlag.Value == 2
%             t=[];
%             for tpts = 1:length(handles.fig)
%                 t = [t [handles.fig(tpts).cycles(:).twitch]];
%             end
%             if any(t)
%                 ldg1 = legend(handles.fig(i,j).avgMagaxR,[lines cutOff1],[ldgNames {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','horizontal');
%                 ldg2 = legend(handles.fig(i,j).avgMisalignaxR,[lines cutOff1],[ldgNames {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','horizontal');
%                 ldg1.Position = [0.4 0.01 0.1308 0.0192];
%                 ldg2.Position = [0.4 0.01 0.1308 0.0192];
%                 ldg1.FontSize = 13.5;
%                 ldg2.FontSize = 13.5;
%             else
%                 ldg1 = legend(handles.fig(i,j).avgMagaxR,lines,ldgNames,'Orientation','horizontal');
%                 ldg2 = legend(handles.fig(i,j).avgMisalignaxR,lines,ldgNames,'Orientation','horizontal');
%                 ldg1.Position = [0.4 0.01 0.1308 0.0192];
%                 ldg2.Position = [0.4 0.01 0.1308 0.0192];
%                 ldg1.FontSize = 13.5;
%                 ldg2.FontSize = 13.5;
%             end
%             
%             
%             %*[0.7940    0.0297    0.1153;-0.8296    0.0283   -0.1883;0.7940    0.0297    0.1153]
%             if handles.stimulatingE.Value
%                 misalgnName = [handles.figDir,'\eyeMisalignment_ByStimE_R&Leye_',handles.figdir];
%                 velName = [handles.figDir,'\eyeVelocity_ByStimeE_R&Leye_',handles.figdir];
%             elseif handles.referenceE.Value
%                 misalgnName = [handles.figDir,'\eyeMisalignment_ByRefE_R&Leye_',handles.figdir];
%                 velName = [handles.figDir,'\eyeVelocity_ByRefE_R&Leye_',handles.figdir];
%             end
%             saveas(handles.avgMisalignPlot(i),[misalgnName,'.svg']);
%             saveas(handles.avgMisalignPlot(i),[misalgnName,'.jpg']);
%             saveas(handles.avgMisalignPlot(i),[misalgnName,'.fig']);
%             saveas(handles.avgMagPlot(i),[velName,'.svg']);
%             saveas(handles.avgMagPlot(i),[velName,'.jpg']);
%             saveas(handles.avgMagPlot(i),[velName,'.fig']);
%             close(handles.avgMisalignPlot(i));
%             close(handles.avgMagPlot(i));
%         elseif handles.LEyeFlag.Value
%             t=[];
%             for tpts = 1:length(handles.fig)
%                 t = [t [handles.fig(tpts).cycles(:).twitch]];
%             end
%             if any(t)
%                 ldg1 = legend(handles.fig(i,j).avgMagaxL,[lines cutOff1],[ldgNames {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','horizontal');
%                 ldg2 = legend(handles.fig(i,j).avgMisalignaxL,[lines cutOff1],[ldgNames {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','horizontal');
%                 ldg1.Position = [0.4 0.01 0.1308 0.0192];
%                 ldg2.Position = [0.4 0.01 0.1308 0.0192];
%                 ldg1.FontSize = 13.5;
%                 ldg2.FontSize = 13.5;
%             else
%                 ldg1 = legend(handles.fig(i,j).avgMagaxL,lines,ldgNames,'Orientation','horizontal');
%                 ldg2 = legend(handles.fig(i,j).avgMisalignaxL,lines,ldgNames,'Orientation','horizontal');
%                 ldg1.Position = [0.4 0.01 0.1308 0.0192];
%                 ldg2.Position = [0.4 0.01 0.1308 0.0192];
%                 ldg1.FontSize = 13.5;
%                 ldg2.FontSize = 13.5;
%             end
%             
%             
%             %*[0.7940    0.0297    0.1153;-0.8296    0.0283   -0.1883;0.7940    0.0297    0.1153]
%             if handles.stimulatingE.Value
%                 misalgnName = [handles.figDir,'\eyeMisalignment_ByStimE_Leye_',handles.figdir];
%                 velName = [handles.figDir,'\eyeVelocity_ByStimeE_Leye_',handles.figdir];
%             elseif handles.referenceE.Value
%                 misalgnName = [handles.figDir,'\eyeMisalignment_ByRefE_Leye_',handles.figdir];
%                 velName = [handles.figDir,'\eyeVelocity_ByRefE_Leye_',handles.figdir];
%             end
%             saveas(handles.avgMisalignPlot(i),[misalgnName,'.svg']);
%             saveas(handles.avgMisalignPlot(i),[misalgnName,'.jpg']);
%             saveas(handles.avgMisalignPlot(i),[misalgnName,'.fig']);
%             saveas(handles.avgMagPlot(i),[velName,'.svg']);
%             saveas(handles.avgMagPlot(i),[velName,'.jpg']);
%             saveas(handles.avgMagPlot(i),[velName,'.fig']);
%             close(handles.avgMisalignPlot(i));
%             close(handles.avgMagPlot(i));
%         elseif handles.REyeFlag.Value
%             t=[];
%             for tpts = 1:length(handles.fig)
%                 t = [t [handles.fig(tpts).cycles(:).twitch]];
%             end
%             if any(t)
%                 ldg1 = legend(handles.fig(i,j).avgMagaxR,[lines cutOff1],[ldgNames {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','horizontal');
%                 ldg2 = legend(handles.fig(i,j).avgMisalignaxR,[lines cutOff1],[ldgNames {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','horizontal');
%                 ldg1.Position = [0.4 0.01 0.1308 0.0192];
%                 ldg2.Position = [0.4 0.01 0.1308 0.0192];
%                 ldg1.FontSize = 13.5;
%                 ldg2.FontSize = 13.5;
%             else
%                 ldg1 = legend(handles.fig(i,j).avgMagaxR,lines,ldgNames,'Orientation','horizontal');
%                 ldg2 = legend(handles.fig(i,j).avgMisalignaxR,lines,ldgNames,'Orientation','horizontal');
%                 ldg1.Position = [0.4 0.01 0.1308 0.0192];
%                 ldg2.Position = [0.4 0.01 0.1308 0.0192];
%                 ldg1.FontSize = 13.5;
%                 ldg2.FontSize = 13.5;
%             end
%             
%             
%             %*[0.7940    0.0297    0.1153;-0.8296    0.0283   -0.1883;0.7940    0.0297    0.1153]
%             if handles.stimulatingE.Value
%                 misalgnName = [handles.figDir,'\eyeMisalignment_ByStimE_Reye_',handles.figdir];
%                 velName = [handles.figDir,'\eyeVelocity_ByStimeE_Reye_',handles.figdir];
%             elseif handles.referenceE.Value
%                 misalgnName = [handles.figDir,'\eyeMisalignment_ByRefE_Reye_',handles.figdir];
%                 velName = [handles.figDir,'\eyeVelocity_ByRefE_Reye_',handles.figdir];
%             end
%             saveas(handles.avgMisalignPlot(i),[misalgnName,'.svg']);
%             saveas(handles.avgMisalignPlot(i),[misalgnName,'.jpg']);
%             saveas(handles.avgMisalignPlot(i),[misalgnName,'.fig']);
%             saveas(handles.avgMagPlot(i),[velName,'.svg']);
%             saveas(handles.avgMagPlot(i),[velName,'.jpg']);
%             saveas(handles.avgMagPlot(i),[velName,'.fig']);
%             close(handles.avgMisalignPlot(i));
%             close(handles.avgMagPlot(i));
%         end
%         
% 
%                                           
%     end


% --- Executes on button press in norm.
function norm_Callback(hObject, eventdata, handles)
% hObject    handle to norm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of norm


% --- Executes on selection change in normNum.
function normNum_Callback(hObject, eventdata, handles)
% hObject    handle to normNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns normNum contents as cell array
%        contents{get(hObject,'Value')} returns selected item from normNum


% --- Executes during object creation, after setting all properties.
function normNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to normNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
