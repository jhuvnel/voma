function varargout = voma__gen_report(varargin)
% VOMA__GEN_REPORT MATLAB code for voma__gen_report.fig
%      VOMA__GEN_REPORT, by itself, creates a new VOMA__GEN_REPORT or raises the existing
%      singleton*.
%
%      H = VOMA__GEN_REPORT returns the handle to a new VOMA__GEN_REPORT or the handle to
%      the existing singleton*.
%
%      VOMA__GEN_REPORT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VOMA__GEN_REPORT.M with the given input arguments.
%
%      VOMA__GEN_REPORT('Property','Value',...) creates a new VOMA__GEN_REPORT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before voma__gen_report_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to voma__gen_report_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help voma__gen_report

% Last Modified by GUIDE v2.5 09-May-2017 11:40:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @voma__gen_report_OpeningFcn, ...
                   'gui_OutputFcn',  @voma__gen_report_OutputFcn, ...
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


% --- Executes just before voma__gen_report is made visible.
function voma__gen_report_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to voma__gen_report (see VARARGIN)

% Choose default command line output for voma__gen_report
handles.output = hObject;

file_param_data = [{'Subject ID'} {'Date'} {'Visit #'} {'Test Name'} {'Test Condition'} {'Raw File Name'} {'Processed File Name'} ...
    {'LE : +LHRH Peak Amp. [deg/s]'} {'LE : +LHRH STD [deg/s]'} {'LE : +LHRH # of cycles'} {'RE : +LHRH Peak Amp. [deg/s]'} {'RE : +LHRH STD [deg/s]'} {'RE : +LHRH # of cycles'} ...
    {'LE : -LHRH Peak Amp. [deg/s]'} {'LE : -LHRH STD [deg/s]'} {'LE : -LHRH # of cycles'} {'RE : -LHRH Peak Amp. [deg/s]'} {'RE : -LHRH STD [deg/s]'} {'RE : -LHRH # of cycles'} ...
    {'LE : +LARP Peak Amp. [deg/s]'} {'LE : +LARP STD [deg/s]'} {'LE : +LARP # of cycles'} {'RE : +LARP Peak Amp. [deg/s]'} {'RE : +LARP STD [deg/s]'} {'RE : +LARP # of cycles'} ...
    {'LE : -LARP Peak Amp. [deg/s]'} {'LE : -LARP STD [deg/s]'} {'LE : -LARP # of cycles'} {'RE : -LARP Peak Amp. [deg/s]'} {'RE : -LARP STD [deg/s]'} {'RE : -LARP # of cycles'} ...
    {'LE : +RALP Peak Amp. [deg/s]'} {'LE : +RALP STD [deg/s]'} {'LE : +RALP # of cycles'} {'RE : +RALP Peak Amp. [deg/s]'} {'RE : +RALP STD [deg/s]'} {'RE : +RALP # of cycles'} ...
    {'LE : -RALP Peak Amp. [deg/s]'} {'LE : -RALP STD [deg/s]'} {'LE : -RALP # of cycles'} {'RE : -RALP Peak Amp. [deg/s]'} {'RE : -RALP STD [deg/s]'} {'RE : -RALP # of cycles'} ...
    {'Examiner(s)'}];


set(handles.file_params,'Data',file_param_data);

handles.params.subj_ID = '';
handles.params.date = '';
handles.params.visitnum = '';
handles.params.testname = '';
handles.params.testcond = '';
handles.params.raw_filename = '';
handles.params.examiner = '';

%Initialize to NO intended canal axis
handles.params.stimaxis = 4;

% Initialize the CycAvg structure
handles.CycAvg = [];

%Initialize Scale Vals
handles.params.pos_y_scale = str2double(get(handles.pos_y_scale,'String'));
handles.params.neg_y_scale = str2double(get(handles.neg_y_scale,'String'));

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes voma__gen_report wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = voma__gen_report_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function file_params_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file_params (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function subj_ID_Callback(hObject, eventdata, handles)
% hObject    handle to subj_ID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

input = get(hObject,'String');


handles.params.subj_ID = input;


% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of subj_ID as text
%        str2double(get(hObject,'String')) returns contents of subj_ID as a double


% --- Executes during object creation, after setting all properties.
function subj_ID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subj_ID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function date_Callback(hObject, eventdata, handles)
% hObject    handle to date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input = get(hObject,'String');



handles.params.date = input;


% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of date as text
%        str2double(get(hObject,'String')) returns contents of date as a double


% --- Executes during object creation, after setting all properties.
function date_CreateFcn(hObject, eventdata, handles)
% hObject    handle to date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function visitnum_Callback(hObject, eventdata, handles)
% hObject    handle to visitnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input = get(hObject,'String');



handles.params.visitnum = input;


% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of visitnum as text
%        str2double(get(hObject,'String')) returns contents of visitnum as a double


% --- Executes during object creation, after setting all properties.
function visitnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to visitnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function testname_Callback(hObject, eventdata, handles)
% hObject    handle to testname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input = get(hObject,'String');

handles.params.testname = input;

% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of testname as text
%        str2double(get(hObject,'String')) returns contents of testname as a double


% --- Executes during object creation, after setting all properties.
function testname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to testname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function testcond_Callback(hObject, eventdata, handles)
% hObject    handle to testcond (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input = get(hObject,'String');


handles.params.testcond = input;


% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of testcond as text
%        str2double(get(hObject,'String')) returns contents of testcond as a double


% --- Executes during object creation, after setting all properties.
function testcond_CreateFcn(hObject, eventdata, handles)
% hObject    handle to testcond (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function raw_filename_Callback(hObject, eventdata, handles)
% hObject    handle to raw_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input = get(hObject,'String');



handles.params.raw_filename = input;


% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of raw_filename as text
%        str2double(get(hObject,'String')) returns contents of raw_filename as a double


% --- Executes during object creation, after setting all properties.
function raw_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to raw_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function examiner_Callback(hObject, eventdata, handles)
% hObject    handle to examiner (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input = get(hObject,'String');


handles.params.examiner = input;

% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of examiner as text
%        str2double(get(hObject,'String')) returns contents of examiner as a double


% --- Executes during object creation, after setting all properties.
function examiner_CreateFcn(hObject, eventdata, handles)
% hObject    handle to examiner (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in add_new_file.
function add_new_file_Callback(hObject, eventdata, handles)
% hObject    handle to add_new_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = length(handles.CycAvg) + 1;


handles.CycAvg(val).Data = handles.temp_CycAvg;

file_params = get(handles.file_params,'Data');

file_params{val+1,1} = handles.params.subj_ID;
file_params{val+1,2} = handles.params.date;
file_params{val+1,3} = handles.params.visitnum;
file_params{val+1,4} = handles.params.testname;
file_params{val+1,5} = handles.params.testcond;
file_params{val+1,6} = handles.params.raw_filename;
file_params{val+1,7} = handles.params.processed_filename;
file_params{val+1,44} = handles.params.examiner;


CycAvg = handles.CycAvg(val).Data;

Fs = CycAvg.Fs;

for cycle_flag=1:2
    
    switch handles.params.stimaxis
        
        case 1 % LHRH
            Trace_l = CycAvg.lz_cycavg;
            Trace_r = CycAvg.rz_cycavg;
        case 2 % LARP
            Trace_l = CycAvg.ll_cycavg;
            Trace_r = CycAvg.rl_cycavg;
        case 3 % RALP
            Trace_l = CycAvg.lr_cycavg;
            Trace_r = CycAvg.rr_cycavg;
    end
    
    Period = length(CycAvg.lr_cycavg)/Fs;
    
    switch cycle_flag
        case 1 % Positive Half-Cycle
            start1 = 1;
            end1 = round((Period/2)*Fs);
        case 2 % Negative Half-Cycle
            start1 = round((Period/2)*Fs) + 1;
            end1 = length(Trace_l);
    end
    
    [max_l,Imax_l] = max(Trace_l(start1:end1));
    Imax_l = Imax_l + start1 - 1; % By restricting the data array that
    % we are using to determine the appropraite value for each cycle,
    % we want to relate this back to the total data array length to
    % properly extract the value for the other components.
    [max_r,Imax_r] = max(Trace_r(start1:end1));
    Imax_r = Imax_r + start1 - 1;
    [min_l,Imin_l] = min(Trace_l(start1:end1));
    Imin_l = Imin_l + start1 - 1;
    [min_r,Imin_r] = min(Trace_r(start1:end1));
    Imin_r = Imin_r + start1 - 1;
    
    switch cycle_flag
        case 1 %+ Half cycle
            % LE, + LHRH
            file_params{val+1,8} = round(CycAvg.lz_cycavg(Imin_l),1);
            file_params{val+1,9} = round(CycAvg.lz_cycstd(Imin_l),1);
            file_params{val+1,10} = size(handles.CycAvg(val).Data.lz_cyc,1);
            % RE, + LHRH
            file_params{val+1,11} = round(CycAvg.rz_cycavg(Imin_r),1);
            file_params{val+1,12} = round(CycAvg.rz_cycstd(Imin_r),1);
            file_params{val+1,13} = size(handles.CycAvg(val).Data.rz_cyc,1);
            
            % LE, + LARP
            file_params{val+1,20} = round(CycAvg.ll_cycavg(Imin_l),1);
            file_params{val+1,21} = round(CycAvg.ll_cycstd(Imin_l),1);
            file_params{val+1,22} = size(handles.CycAvg(val).Data.ll_cyc,1);
            % RE, + LARP
            file_params{val+1,23} = round(CycAvg.rl_cycavg(Imin_r),1);
            file_params{val+1,24} = round(CycAvg.rl_cycstd(Imin_r),1);
            file_params{val+1,25} = size(handles.CycAvg(val).Data.rl_cyc,1);
            
            % LE, + RALP
            file_params{val+1,32} = round(CycAvg.lr_cycavg(Imin_l),1);
            file_params{val+1,33} = round(CycAvg.lr_cycstd(Imin_l),1);
            file_params{val+1,34} = size(handles.CycAvg(val).Data.lr_cyc,1);
            % RE, + RALP
            file_params{val+1,35} = round(CycAvg.rr_cycavg(Imin_r),1);
            file_params{val+1,36} = round(CycAvg.rr_cycstd(Imin_r),1);
            file_params{val+1,37} = size(handles.CycAvg(val).Data.rr_cyc,1);
            
        case 2
            % LE, - LHRH
            file_params{val+1,14} = round(CycAvg.lz_cycavg(Imax_l),1);
            file_params{val+1,15} = round(CycAvg.lz_cycstd(Imax_l),1);
            file_params{val+1,16} = size(handles.CycAvg(val).Data.lz_cyc,1);
            % RE, - LHRH
            file_params{val+1,17} = round(CycAvg.rz_cycavg(Imax_r),1);
            file_params{val+1,18} = round(CycAvg.rz_cycstd(Imax_r),1);
            file_params{val+1,19} = size(handles.CycAvg(val).Data.rz_cyc,1);
            
            % LE, - LARP
            file_params{val+1,26} = round(CycAvg.ll_cycavg(Imax_l),1);
            file_params{val+1,27} = round(CycAvg.ll_cycstd(Imax_l),1);
            file_params{val+1,28} = size(handles.CycAvg(val).Data.ll_cyc,1);
            % RE, - LARP
            file_params{val+1,29} = round(CycAvg.rl_cycavg(Imax_r),1);
            file_params{val+1,30} = round(CycAvg.rl_cycstd(Imax_r),1);
            file_params{val+1,31} = size(handles.CycAvg(val).Data.rl_cyc,1);
            
            % LE, - RALP
            file_params{val+1,38} = round(CycAvg.lr_cycavg(Imax_l),1);
            file_params{val+1,39} = round(CycAvg.lr_cycstd(Imax_l),1);
            file_params{val+1,40} = size(handles.CycAvg(val).Data.lr_cyc,1);
            % RE, - RALP
            file_params{val+1,41} = round(CycAvg.rr_cycavg(Imax_r),1);
            file_params{val+1,42} = round(CycAvg.rr_cycstd(Imax_r),1);
            file_params{val+1,43} = size(handles.CycAvg(val).Data.rr_cyc,1);
    end
    
    
    
    
end

set(handles.file_params,'Data',file_params);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in clear_stack.
function clear_stack_Callback(hObject, eventdata, handles)
% hObject    handle to clear_stack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

file_params = [{'Subject ID'} {'Date'} {'Visit #'} {'Test Name'} {'Test Condition'} {'Raw File Name'} {'Processed File Name'} ...
    {'LE : +LHRH Peak Amp. [deg/s]'} {'LE : +LHRH STD [deg/s]'} {'LE : +LHRH # of cycles'} {'RE : +LHRH Peak Amp. [deg/s]'} {'RE : +LHRH STD [deg/s]'} {'RE : +LHRH # of cycles'} ...
    {'LE : -LHRH Peak Amp. [deg/s]'} {'LE : -LHRH STD [deg/s]'} {'LE : -LHRH # of cycles'} {'RE : -LHRH Peak Amp. [deg/s]'} {'RE : -LHRH STD [deg/s]'} {'RE : -LHRH # of cycles'} ...
    {'LE : +LARP Peak Amp. [deg/s]'} {'LE : +LARP STD [deg/s]'} {'LE : +LARP # of cycles'} {'RE : +LARP Peak Amp. [deg/s]'} {'RE : +LARP STD [deg/s]'} {'RE : +LARP # of cycles'} ...
    {'LE : -LARP Peak Amp. [deg/s]'} {'LE : -LARP STD [deg/s]'} {'LE : -LARP # of cycles'} {'RE : -LARP Peak Amp. [deg/s]'} {'RE : -LARP STD [deg/s]'} {'RE : -LARP # of cycles'} ...
    {'LE : +RALP Peak Amp. [deg/s]'} {'LE : +RALP STD [deg/s]'} {'LE : +RALP # of cycles'} {'RE : +RALP Peak Amp. [deg/s]'} {'RE : +RALP STD [deg/s]'} {'RE : +RALP # of cycles'} ...
    {'LE : -RALP Peak Amp. [deg/s]'} {'LE : -RALP STD [deg/s]'} {'LE : -RALP # of cycles'} {'RE : -RALP Peak Amp. [deg/s]'} {'RE : -RALP STD [deg/s]'} {'RE : -RALP # of cycles'} ...
    {'Examiner(s)'}];
set(handles.file_params,'Data',file_params);

% Initialize the CycAvg structure
handles.CycAvg = [];

% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in load_new_cycavg.
function load_new_cycavg_Callback(hObject, eventdata, handles)
% hObject    handle to load_new_cycavg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[filename, pathname, filterindex] =  uigetfile('*.mat');
handles.filename = filename;
handles.pathname = pathname;

load([handles.pathname '\' handles.filename])

handles.temp_CycAvg = Results;

try
handles.params.subj_ID = Results.SubjectID;
set(handles.subj_ID,'String',handles.params.subj_ID);
catch
end

try
handles.params.date = [Results.Date(1:4) '-' Results.Date(5:6) '-' Results.Date(7:8)];
set(handles.date,'String',handles.params.date);
catch
end

try
handles.params.visitnum = Results.VisitID;
set(handles.visitnum,'String',handles.params.visitnum);
catch
end

try
handles.params.raw_filename = Results.raw_filename;
set(handles.raw_filename,'String',handles.params.raw_filename);
catch
end

try
handles.params.processed_filename = Results.name;
set(handles.processed_filename,'String',handles.params.processed_filename);
catch
end

% Update handles structure
guidata(hObject, handles);

% --- Executes when selected object is changed in stimaxis_uibuttongroup.
function stimaxis_uibuttongroup_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in stimaxis_uibuttongroup 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'lhrh_radbutton'
        handles.params.stimaxis = 1;
    case 'larp_radbutton'
        handles.params.stimaxis = 2;
    case 'ralp_radbutton'
        handles.params.stimaxis = 3;
    case 'na_radbutton'
        handles.params.stimaxis = 4;
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in gen_report.
function gen_report_Callback(hObject, eventdata, handles)
% hObject    handle to gen_report (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

file_params = get(handles.file_params,'Data');

Data = handles.CycAvg;
plotname = [file_params{2,1} ' ' file_params{2,2} ' '  file_params{2,3} ' ' ...
    file_params{2,4}];
save_loc = pwd;
stim_cond =  {file_params{2:end,5}};
for k=1:length(Data)
    Stim_trace(k).Data = handles.CycAvg(k).Data.stim(2,:);
end
legend_flag = false;
SCC = handles.params.stimaxis;

Scale = [handles.params.neg_y_scale handles.params.pos_y_scale];

[hx] = MVI_Gen_Cyc_Avg_Plot__inputdata(Data,plotname,save_loc,stim_cond,Stim_trace,legend_flag,SCC,Scale);

folder_name = uigetdir(pwd,'Choose the folder location to save the report printout');

reportname = [folder_name '\' plotname '_CRF'];
rpt = MVI_Report(reportname,'docx','F:\VNEL-Software-Repo\VOMA\MVI_Experiment_Repord_CRF_Template');
rpt.subj_ID = file_params{2,1};
rpt.date = file_params{2,2};
rpt.visitnum = file_params{2,3};
rpt.testname = file_params{2,4};
% rpt.testcond = file_params{2,5};

temp_rawfilenames = file_params(2:end,6);

raw_names_final = [];

flag = true;
while flag 
    
    raw_names_final{length(raw_names_final) +1} = temp_rawfilenames{1,1};
    
    [temp] = strcmp(temp_rawfilenames{1,1},temp_rawfilenames(:,1));
    temp = ~temp;
    
    flag = false;
    for k=1:length(temp)
        if temp(k) == true
            flag = temp(k);
            
            
            break
        end
        
        
    end
       
    temp_rawfilenames = temp_rawfilenames(temp);
    
end

full_rawname_string = raw_names_final{1};
for k=2:length(raw_names_final)
    full_rawname_string = [full_rawname_string ', ' raw_names_final{k}];
end

rpt.raw_filename = full_rawname_string;
rpt.examiner = handles.params.examiner;

rpt.cyc_avg_plot = [plotname '.png'];
rpt.cyc_avg_legend = 'F:\VNEL-Software-Repo\VOMA\CycAvg_LEGEND_20170509.png';
rpt.lhrh_data_table = file_params(:,[5 8:19]);
rpt.larp_data_table = file_params(:,[5 20:31]);
rpt.ralp_data_table = file_params(:,[5 32:43]);

rpt.file_info_table = file_params(:,[1:7 44]);
% cd(temp)

fill(rpt);

rptview(reportname,'pdf');

save([reportname '.mat'],'file_params');

% Update handles structure
guidata(hObject, handles);



function pos_y_scale_Callback(hObject, eventdata, handles)
% hObject    handle to pos_y_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handles.params.pos_y_scale = str2double(get(hObject,'String'));
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of pos_y_scale as text
%        str2double(get(hObject,'String')) returns contents of pos_y_scale as a double


% --- Executes during object creation, after setting all properties.
function pos_y_scale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pos_y_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function neg_y_scale_Callback(hObject, eventdata, handles)
% hObject    handle to neg_y_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.params.neg_y_scale = str2double(get(hObject,'String'));
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of neg_y_scale as text
%        str2double(get(hObject,'String')) returns contents of neg_y_scale as a double


% --- Executes during object creation, after setting all properties.
function neg_y_scale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to neg_y_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function processed_filename_Callback(hObject, eventdata, handles)
% hObject    handle to processed_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input = get(hObject,'String');


handles.params.processed_filename = input;

% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of processed_filename as text
%        str2double(get(hObject,'String')) returns contents of processed_filename as a double


% --- Executes during object creation, after setting all properties.
function processed_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to processed_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
