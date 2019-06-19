function varargout = Monkey_Voma_Processing(varargin)
% MONKEY_VOMA_PROCESSING MATLAB code for Monkey_Voma_Processing.fig
%      MONKEY_VOMA_PROCESSING, by itself, creates a new MONKEY_VOMA_PROCESSING or raises the existing
%      singleton*.
%
%      H = MONKEY_VOMA_PROCESSING returns the handle to a new MONKEY_VOMA_PROCESSING or the handle to
%      the existing singleton*.
%
%      MONKEY_VOMA_PROCESSING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MONKEY_VOMA_PROCESSING.M with the given input arguments.
%
%      MONKEY_VOMA_PROCESSING('Property','Value',...) creates a new MONKEY_VOMA_PROCESSING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Monkey_Voma_Processing_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Monkey_Voma_Processing_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Monkey_Voma_Processing

% Last Modified by GUIDE v2.5 28-May-2019 10:51:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Monkey_Voma_Processing_OpeningFcn, ...
                   'gui_OutputFcn',  @Monkey_Voma_Processing_OutputFcn, ...
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


% --- Executes just before Monkey_Voma_Processing is made visible.
function Monkey_Voma_Processing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Monkey_Voma_Processing (see VARARGIN)

% Choose default command line output for Monkey_Voma_Processing
handles.output = hObject;
handles.startVal = 0;
handles.color.l_x = [237,150,33]/255;
handles.color.l_y = [125,46,143]/255;
handles.color.l_z = [1 0 0];
handles.color.l_l = [0,128,0]/255;
handles.color.l_r = [0 0 1];
handles.color.r_x = [237,204,33]/255;
handles.color.r_y = [125,46,230]/255;
handles.color.r_z = [255,0,255]/255;
handles.color.r_l = [0 1 0];
handles.color.r_r = [64,224,208]/255;


handles.segNum = 1;
handles.FacialNerve = 0;
handles.tofilt = 15;
handles.redoFlag = 0;
handles.filtFlag = 0;
handles.PosfiltFlag = 0;
handles.linkaxisFlag = 0;
handles.corrFlag = 0;
handles.prevCyc = [];
handles.skipFile = 0;

handles.LEye.Enable = 'off';
handles.REye.Enable = 'off';
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Monkey_Voma_Processing wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Monkey_Voma_Processing_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in cycle_list.
function cycle_list_Callback(hObject, eventdata, handles)
% hObject    handle to cycle_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
remaining = 0;
for recolor = 1:length(handles.segment(handles.segNum).txt)
    if any(ismember(handles.cycle_list.Value,recolor))
        handles.segment(handles.segNum).txt(recolor).Color = 'Red';
    else
        handles.segment(handles.segNum).txt(recolor).Color = 'Green';
        remaining = remaining +1;
    end
end


    
handles.cycles_toSave.String = [num2str(remaining),' Cycles Will Be Saved'];
guidata(hObject, handles);
handles = calc_cyc_avg(handles);
    plot_cyc_avg(handles);
handles.prevCyc = [handles.cycle_list.Value];
    guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns cycle_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cycle_list


% --- Executes during object creation, after setting all properties.
function cycle_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cycle_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in new_VOMA_file.
function new_VOMA_file_Callback(hObject, eventdata, handles)
% hObject    handle to new_VOMA_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.vomaFile,handles.vomaPath] = uigetfile('*.voma','Select the voma you wish to process');
handles.current_filename.String = handles.vomaFile;
temp = load([handles.vomaPath, handles.vomaFile],'-mat');
RootData = temp.Data_QPR;
handles.RootData = RootData;
handles.total_files.String = num2str(length(handles.RootData));
handles.startVal = handles.startVal +1;
if handles.startVal == 2
    handles.start.Visible = 1;
end
guidata(hObject, handles);

% --- Executes on button press in choose_output_path.
function choose_output_path_Callback(hObject, eventdata, handles)
% hObject    handle to choose_output_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.cycDir = uigetdir(path,'Choose directory of the output files');
handles.output_path.String = handles.cycDir;
handles.startVal = handles.startVal +1;
if handles.startVal > 1
    handles.start.Visible = 'on';
end

guidata(hObject, handles);


% --- Executes on button press in process_file.
function process_file_Callback(hObject, eventdata, handles)
% hObject    handle to process_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.skipFile
    handles.segNum = handles.segNum+1;
guidata(hObject, handles);
else
if handles.redoFlag==0
cycNum = 1;
Results = struct();
Results.ll_cyc = [];
        Results.lr_cyc = [];
        Results.lz_cyc = [];
        Results.lx_cyc = [];
        Results.ly_cyc = [];
        Results.rl_cyc = [];
        Results.rr_cyc = [];
        Results.rz_cyc = [];
        Results.rx_cyc = [];
        Results.ry_cyc = [];
        Results.stim = [];
    
name = strrep(handles.RootData(handles.segNum).name,'.mat','_CycleAvg');
if (handles.filtFlag==1) | (handles.PosfiltFlag==1)
    handles = calc_cyc_avg(handles);
        Results.ll_cyc = handles.Results.ll_cyc;
        Results.lr_cyc = handles.Results.lr_cyc;
        Results.lz_cyc = handles.Results.lz_cyc;
        Results.lx_cyc = handles.Results.lx_cyc;
        Results.ly_cyc = handles.Results.ly_cyc;
        Results.rl_cyc = handles.Results.rl_cyc;
        Results.rr_cyc = handles.Results.rr_cyc;
        Results.rz_cyc = handles.Results.rz_cyc;
        Results.rx_cyc = handles.Results.rx_cyc;
        Results.ry_cyc = handles.Results.ry_cyc;
        Results.stim = handles.Results.stim;
        
    Results.ll_cycavg = handles.Results.ll_cycavg;
Results.ll_cycstd = handles.Results.ll_cycstd;
Results.lr_cycavg = handles.Results.lr_cycavg;
Results.lr_cycstd = handles.Results.lr_cycstd;
Results.lz_cycavg = handles.Results.lz_cycavg;
Results.lz_cycstd = handles.Results.lz_cycstd;
Results.lx_cycavg = handles.Results.lx_cycavg;
Results.lx_cycstd = handles.Results.lx_cycstd;
Results.ly_cycavg = handles.Results.ly_cycavg;
Results.ly_cycstd = handles.Results.ly_cycstd;
Results.rl_cycavg = handles.Results.rl_cycavg;
Results.rl_cycstd = handles.Results.rl_cycstd;
Results.rr_cycavg = handles.Results.rr_cycavg;
Results.rr_cycstd = handles.Results.rr_cycstd;
Results.rz_cycavg = handles.Results.rz_cycavg;
Results.rz_cycstd = handles.Results.rz_cycstd;
Results.rx_cycavg = handles.Results.rx_cycavg;
Results.rx_cycstd = handles.Results.rx_cycstd;
Results.ry_cycavg = handles.Results.ry_cycavg;
Results.ry_cycstd = handles.Results.ry_cycstd;
Results.QPparams = ['filtfilt Order ',handles.filterorder.String];


else
for processing = 1:length(handles.segment(handles.segNum).txt)
    if any(ismember(handles.cycle_list.Value,processing))
        
    else
        l = min(diff(handles.segment(handles.segNum).stim_inds));
        bound = [handles.segment(handles.segNum).stim_inds(processing):handles.segment(handles.segNum).stim_inds(processing)+l];
        Results.ll_cyc = [Results.ll_cyc; handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_LARP(bound)'];
        Results.lr_cyc = [Results.lr_cyc; handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_RALP(bound)'];
        Results.lz_cyc = [Results.lz_cyc; handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_Z(bound)'];
        Results.lx_cyc = [Results.lx_cyc; handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_X(bound)'];
        Results.ly_cyc = [Results.ly_cyc; handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_Y(bound)'];
        Results.rl_cyc = [Results.rl_cyc; handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_LARP(bound)'];
        Results.rr_cyc = [Results.rr_cyc; handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_RALP(bound)'];
        Results.rz_cyc = [Results.rz_cyc; handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_Z(bound)'];
        Results.rx_cyc = [Results.rx_cyc; handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_X(bound)'];
        Results.ry_cyc = [Results.ry_cyc; handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_Y(bound)'];
        Results.stim = [Results.stim; handles.RootData(handles.segNum).VOMA_data.Stim_Trace(bound)];
    
    end
    
end
Results.ll_cycavg = mean(Results.ll_cyc);
Results.ll_cycstd = std(Results.ll_cyc);
Results.lr_cycavg = mean(Results.lr_cyc);
Results.lr_cycstd = std(Results.lr_cyc);
Results.lz_cycavg = mean(Results.lz_cyc);
Results.lz_cycstd = std(Results.lz_cyc);
Results.lx_cycavg = mean(Results.lx_cyc);
Results.lx_cycstd = std(Results.lx_cyc);
Results.ly_cycavg = mean(Results.ly_cyc);
Results.ly_cycstd = std(Results.ly_cyc);
Results.rl_cycavg = mean(Results.rl_cyc);
Results.rl_cycstd = std(Results.rl_cyc);
Results.rr_cycavg = mean(Results.rr_cyc);
Results.rr_cycstd = std(Results.rr_cyc);
Results.rz_cycavg = mean(Results.rz_cyc);
Results.rz_cycstd = std(Results.rz_cyc);
Results.rx_cycavg = mean(Results.rx_cyc);
Results.rx_cycstd = std(Results.rx_cyc);
Results.ry_cycavg = mean(Results.ry_cyc);
Results.ry_cycstd = std(Results.ry_cyc);
Results.QPparams = [];
end
Results.name = handles.RootData(handles.segNum).name;
Results.raw_filename =  handles.RootData(handles.segNum).RawFileName;
Results.Parameters = handles.RootData(handles.segNum).VOMA_data.Parameters;
Results.Fs =  handles.RootData(handles.segNum).VOMA_data.Fs;

Results.cyclist = find(~ismember(1:20,handles.cycle_list.Value))';
Results.FacialNerve = handles.FacialNerve;
cd(handles.output_path.String)
save([name, '.mat'],'Results')

handles.segNum = handles.segNum+1;
guidata(hObject, handles);
end
end
% cla(handles.axes1);
cla(handles.cycavg)
if handles.segNum<length(handles.RootData)+1
handles = nextFile(handles);
end

    guidata(hObject, handles);


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.start.Visible = 'off';
cd(handles.cycDir)
handles.segNum = 1;
cla(handles.axes1)
cla(handles.angPos)
cla(handles.cycavg)
handles.segment = [];
handles.skip = 1;
handles = nextFile(handles);
while handles.skipFile
    handles = nextFile(handles);
end
handles.LEye.Enable = 'on';
handles.REye.Enable = 'on';
handles.skip = 0;
    guidata(hObject, handles);


    % --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on button press in facial_nerve.
function facial_nerve_Callback(hObject, eventdata, handles)
% hObject    handle to facial_nerve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.FacialNerve = 1;
handles.facial_nerve.BackgroundColor = 'Red';
guidata(hObject, handles);


                      

function filterorder_Callback(hObject, eventdata, handles)
% hObject    handle to filterorder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filterorder as text
%        str2double(get(hObject,'String')) returns contents of filterorder as a double
handles.tofilt = str2num(handles.filterorder.String);
if handles.tofilt<1
    handles.tofilt = 1;
    handles.filterorder.String = '1';
end
handles.filtFlag = 1;
 handles.filtLELARP=filtfilt(ones(1,handles.tofilt)/handles.tofilt,1,handles.segment(handles.segNum).LE_LARP);
  handles.filtLEZ=filtfilt(ones(1,handles.tofilt)/handles.tofilt,1,handles.segment(handles.segNum).LE_Z);
   handles.filtLERALP=filtfilt(ones(1,handles.tofilt)/handles.tofilt,1,handles.segment(handles.segNum).LE_RALP);
 handles.filtLEX = filtfilt(ones(1,handles.tofilt)/handles.tofilt,1,handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_X);
  handles.filtLEY = filtfilt(ones(1,handles.tofilt)/handles.tofilt,1,handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_Y);  
 handles.filtRELARP=filtfilt(ones(1,handles.tofilt)/handles.tofilt,1,handles.segment(handles.segNum).RE_LARP);
  handles.filtREZ=filtfilt(ones(1,handles.tofilt)/handles.tofilt,1,handles.segment(handles.segNum).RE_Z);
   handles.filtRERALP=filtfilt(ones(1,handles.tofilt)/handles.tofilt,1,handles.segment(handles.segNum).RE_RALP);
    handles.filtREX = filtfilt(ones(1,handles.tofilt)/handles.tofilt,1,handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_X);
  handles.filtREY = filtfilt(ones(1,handles.tofilt)/handles.tofilt,1,handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_Y);
   handles = plotVel(handles)
    guidata(hObject, handles);
    handles = calc_cyc_avg(handles);
    plot_cyc_avg(handles);
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function filterorder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filterorder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in redo.
function redo_Callback(hObject, eventdata, handles)
% hObject    handle to redo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.segNum>1
handles.segNum = handles.segNum-1;
handles.redoFlag = 1;
guidata(hObject, handles);
process_file_Callback(hObject, eventdata, handles)
end

function handles = nextFile(handles)
cla(handles.cycavg)
handles.facial_nerve.BackgroundColor = [.94 .94 .94];
handles.rawV.Value = 0;
handles.FacialNerve = 0;
handles.filtFlag = 0;
handles.redoFlag =0;
handles.PosfiltFlag = 0;

handles.files_remaining.String = num2str(handles.segNum);
listing = dir(handles.cycDir);
makeFile = 1;
handles.files_remaining.String = num2str(handles.segNum);
    name = strrep(handles.RootData(handles.segNum).name,'.mat','_CycleAvg');
    go = 1;
    while go
        handles.output_filename.String = name;
    if any(find(contains({listing.name},{name})))
        handles.Results = load(name);
        handles.Results = handles.Results.Results;
        plot_cyc_avg(handles)
        handles = plotVel(handles)
        handles.cycavg.YLim = [-100 100];
        handles.cycavg.XLim = [0 0.04];
        handles.Results = [];
        answer = questdlg([{name};{'This file already exsits, would you like to overwrite it?'}],'Overwrite files','Yes','No','No');
        switch answer
            case 'Yes'
                makeFile = 1;
                go = 0;
            case 'No'
                makeFile = 1;
                handles.segNum = handles.segNum +1;
                if handles.segNum<length(handles.RootData)+1
                name = strrep(handles.RootData(handles.segNum).name,'.mat','_CycleAvg');
                else
                    go = 0;
                end
        end
    else
        go = 0;
                
    end
    end
   if makeFile
    handles.segment(handles.segNum).LE_LARP=handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_LARP;
    handles.segment(handles.segNum).LE_RALP=handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_RALP;
    handles.segment(handles.segNum).LE_Z=handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_Z;
    handles.segment(handles.segNum).RE_LARP=handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_LARP;
    handles.segment(handles.segNum).RE_RALP=handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_RALP;
    handles.segment(handles.segNum).RE_Z=handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_Z;
    
    handles.segment(handles.segNum).LEp_X=handles.RootData(handles.segNum).VOMA_data.Data_LE_Pos_X;
    handles.segment(handles.segNum).LEp_Y=handles.RootData(handles.segNum).VOMA_data.Data_LE_Pos_Y;
    handles.segment(handles.segNum).LEp_Z=handles.RootData(handles.segNum).VOMA_data.Data_LE_Pos_Z;
    handles.segment(handles.segNum).REp_X=handles.RootData(handles.segNum).VOMA_data.Data_RE_Pos_X;
    handles.segment(handles.segNum).REp_Y=handles.RootData(handles.segNum).VOMA_data.Data_RE_Pos_Y;
    handles.segment(handles.segNum).REp_Z=handles.RootData(handles.segNum).VOMA_data.Data_RE_Pos_Z;
    
    handles.segment(handles.segNum).stim=handles.RootData(handles.segNum).VOMA_data.Stim_Trace;
    handles.segment(handles.segNum).stimT=handles.RootData(handles.segNum).VOMA_data.Stim_t;
    handles.segment(handles.segNum).t=handles.RootData(handles.segNum).VOMA_data.Eye_t;
    

    if isrow(handles.segment(handles.segNum).stimT)
        handles.segment(handles.segNum).stimT = handles.segment(handles.segNum).stimT';
    end
    if isrow(handles.segment(handles.segNum).stim)
        handles.segment(handles.segNum).stim = handles.segment(handles.segNum).stim';
    end
    inds = [1:length(handles.segment(handles.segNum).stimT)];
    inbtw = find(isnan(handles.segment(handles.segNum).stim));
    handles.segment(handles.segNum).stim(inbtw) = 0;
    pos_ind = [false ; diff(handles.segment(handles.segNum).stim)>0];
    
    handles.segment(handles.segNum).stim_inds = inds(pos_ind > 0 )';
    if isempty(handles.segment(handles.segNum).stim_inds)
        handles.skipFile = 1;
        handles.segNum = handles.segNum +1;

    else
        handles.skipFile = 0;
    handles = check_stim(handles)    
    hold(handles.angPos,'on')
    if handles.LEye.Value
     plot(handles.angPos,handles.segment(handles.segNum).t,handles.segment(handles.segNum).LEp_X,'Color',handles.color.l_x);
    plot(handles.angPos,handles.segment(handles.segNum).t,handles.segment(handles.segNum).LEp_Y,'Color',handles.color.l_y);
    plot(handles.angPos,handles.segment(handles.segNum).t,handles.segment(handles.segNum).LEp_Z,'r','Color',handles.color.l_z);
    end
    if handles.REye.Value
     plot(handles.angPos,handles.segment(handles.segNum).t,handles.segment(handles.segNum).REp_X,'Color',handles.color.r_x);
    plot(handles.angPos,handles.segment(handles.segNum).t,handles.segment(handles.segNum).REp_Y,'Color',handles.color.r_y);
    plot(handles.angPos,handles.segment(handles.segNum).t,handles.segment(handles.segNum).REp_Z,'r','Color',handles.color.r_z);
    end
    plot(handles.angPos,handles.segment(handles.segNum).stimT,handles.segment(handles.segNum).stim,'k');
    plot(handles.angPos,handles.segment(handles.segNum).stimT(handles.segment(handles.segNum).stim_inds),handles.segment(handles.segNum).stim(handles.segment(handles.segNum).stim_inds),'m*');
    plot(handles.angPos,repmat(handles.segment(handles.segNum).stimT(handles.segment(handles.segNum).stim_inds+100),1,2),[-100 100],'k');
    handles.angPos.YLim = [-100 100];
    hold(handles.angPos,'off')
    if isfield(handles,'segment')
        if isfield(handles.segment(handles.segNum),'txt')
    rmfield(handles.segment(handles.segNum),'txt');
        end
    end
    handles = plotVel(handles)
    
    if ~isempty(handles.cycle_list.String) && ~strcmp(handles.cycle_list.String{1},'')
    handles.cycle_list.String = [''];
    end
    for cycText = 1:length(handles.segment(handles.segNum).stim_inds)
        handles.cycle_list.String = [handles.cycle_list.String;{['Cycle ',num2str(cycText)]}];
    end
handles.cycle_list.String= [handles.cycle_list.String;{'None'}];
    handles.cycles_toSave.String = ['20 Cycles to Save'];
    handles.output_filename.String = name;
    handles.cycle_list.Value = 21;
    
    handles.redoFlag = 0;
    handles = plotVel(handles)
handles = calc_cyc_avg(handles);
    plot_cyc_avg(handles)
    end
   end
   
function handles = calc_cyc_avg(handles)
        handles.Results.ll_cyc = [];
        handles.Results.lr_cyc = [];
        handles.Results.lz_cyc = [];
        handles.Results.lx_cyc = [];
        handles.Results.ly_cyc = [];
        handles.Results.rl_cyc = [];
        handles.Results.rr_cyc = [];
        handles.Results.rz_cyc = [];
        handles.Results.rx_cyc = [];
        handles.Results.ry_cyc = [];
        handles.Results.stim = [];
    
for processing = 1:length(handles.segment(handles.segNum).txt)
    if (handles.filtFlag == 0) && (handles.PosfiltFlag == 0) 
    if any(ismember(handles.cycle_list.Value,processing))
        
    else
        l = min(diff(handles.segment(handles.segNum).stim_inds));
        bound = [handles.segment(handles.segNum).stim_inds(processing):handles.segment(handles.segNum).stim_inds(processing)+l-50];
        if bound(end)>length(handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_LARP)
            bound=bound(1):1:length(handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_LARP);
        end
        if isrow(handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_RALP(bound))
        else
            handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_LARP = handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_LARP';
            handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_RALP = handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_RALP';
            handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_Z = handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_Z';
        handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_X = handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_X';
        handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_Y = handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_Y';
        handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_LARP = handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_LARP';
            handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_RALP = handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_RALP';
            handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_Z = handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_Z';
        handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_X = handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_X';
        handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_Y = handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_Y';
        end
        handles.Results.ll_cyc = [handles.Results.ll_cyc; handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_LARP(bound)];
        handles.Results.lr_cyc = [handles.Results.lr_cyc; handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_RALP(bound)];
        handles.Results.lz_cyc = [handles.Results.lz_cyc; handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_Z(bound)];
        handles.Results.lx_cyc = [handles.Results.lx_cyc; handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_X(bound)];
        handles.Results.ly_cyc = [handles.Results.ly_cyc; handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_Y(bound)];
        handles.Results.rl_cyc = [handles.Results.rl_cyc; handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_LARP(bound)];
        handles.Results.rr_cyc = [handles.Results.rr_cyc; handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_RALP(bound)];
        handles.Results.rz_cyc = [handles.Results.rz_cyc; handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_Z(bound)];
        handles.Results.rx_cyc = [handles.Results.rx_cyc; handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_X(bound)];
        handles.Results.ry_cyc = [handles.Results.ry_cyc; handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_Y(bound)];
        handles.Results.stim = [handles.Results.stim; handles.RootData(handles.segNum).VOMA_data.Stim_Trace(bound)];
    
    end
    else
        if any(ismember(handles.cycle_list.Value,processing))
        
    else
        l = min(diff(handles.segment(handles.segNum).stim_inds));
        bound = [handles.segment(handles.segNum).stim_inds(processing):handles.segment(handles.segNum).stim_inds(processing)+l-50];
        if handles.filtFlag
            if handles.nystagCorr.Value
                handles = correction(handles);
                toUseLELARP = handles.corLELARP;
                toUseLERALP = handles.corLERALP;
                toUseLEZ = handles.corLEZ;
            else
                toUseLELARP = handles.filtLELARP;
                toUseLERALP = handles.filtLERALP;
                toUseLEZ = handles.filtLEZ;
            end
        else
            toUseLELARP = handles.segment(handles.segNum).LE_LARP;
            toUseLERALP = handles.segment(handles.segNum).LE_RALP;
            toUseLEZ = handles.segment(handles.segNum).LE_Z;
            
        end
        handles.Results.ll_cyc = [handles.Results.ll_cyc; toUseLELARP(bound)'];
        handles.Results.lr_cyc = [handles.Results.lr_cyc; toUseLERALP(bound)'];
        handles.Results.lz_cyc = [handles.Results.lz_cyc; toUseLEZ(bound)'];
        handles.Results.lx_cyc = [handles.Results.lx_cyc; handles.filtLEX(bound)'];
        handles.Results.ly_cyc = [handles.Results.ly_cyc; handles.filtLEY(bound)'];
        handles.Results.rl_cyc = [handles.Results.rl_cyc; handles.filtRELARP(bound)'];
        handles.Results.rr_cyc = [handles.Results.rr_cyc; handles.filtRERALP(bound)'];
        handles.Results.rz_cyc = [handles.Results.rz_cyc; handles.filtREZ(bound)'];
        handles.Results.rx_cyc = [handles.Results.rx_cyc; handles.filtREX(bound)'];
        handles.Results.ry_cyc = [handles.Results.ry_cyc; handles.filtREY(bound)'];
        handles.Results.stim = [handles.Results.stim; handles.RootData(handles.segNum).VOMA_data.Stim_Trace(bound)];
        end
    end
    
end
handles.Results.ll_cycavg = mean(handles.Results.ll_cyc);
handles.Results.ll_cycstd = std(handles.Results.ll_cyc);
handles.Results.lr_cycavg = mean(handles.Results.lr_cyc);
handles.Results.lr_cycstd = std(handles.Results.lr_cyc);
handles.Results.lz_cycavg = mean(handles.Results.lz_cyc);
handles.Results.lz_cycstd = std(handles.Results.lz_cyc);
handles.Results.lx_cycavg = mean(handles.Results.lx_cyc);
handles.Results.lx_cycstd = std(handles.Results.lx_cyc);
handles.Results.ly_cycavg = mean(handles.Results.ly_cyc);
handles.Results.ly_cycstd = std(handles.Results.ly_cyc);
handles.Results.rl_cycavg = mean(handles.Results.rl_cyc);
handles.Results.rl_cycstd = std(handles.Results.rl_cyc);
handles.Results.rr_cycavg = mean(handles.Results.rr_cyc);
handles.Results.rr_cycstd = std(handles.Results.rr_cyc);
handles.Results.rz_cycavg = mean(handles.Results.rz_cyc);
handles.Results.rz_cycstd = std(handles.Results.rz_cyc);
handles.Results.rx_cycavg = mean(handles.Results.rx_cyc);
handles.Results.rx_cycstd = std(handles.Results.rx_cyc);
handles.Results.ry_cycavg = mean(handles.Results.ry_cyc);
handles.Results.ry_cycstd = std(handles.Results.ry_cyc);
handles.Results.Fs =  handles.RootData(handles.segNum).VOMA_data.Fs;

function plot_cyc_avg(handles)
axes(handles.cycavg)
lstyle = '-';
cla(handles.cycavg)        
hold(handles.cycavg,'on')
if handles.LEye.Value
p.ll = shadedErrorBar([1:length(handles.Results.ll_cycavg)]/handles.Results.Fs,handles.Results.ll_cycavg,...
            handles.Results.ll_cycstd,'lineprops',{'r-','MarkerFaceColor',handles.color.l_l});
        set(p.ll.edge,'LineWidth',1.5,'color',handles.color.l_l)
        set(p.ll.patch,'facecolor',handles.color.l_l)
        set(p.ll.mainLine,'LineWidth',2.5,'color',handles.color.l_l)
        set(p.ll.edge,'LineStyle',lstyle)
        set(p.ll.mainLine,'LineStyle',lstyle)
        

        p.lr = shadedErrorBar([1:length(handles.Results.lr_cycavg)]/handles.Results.Fs,handles.Results.lr_cycavg,...
            handles.Results.lr_cycstd,'lineprops',{'r-','MarkerFaceColor',handles.color.l_r});
        set(p.lr.edge,'LineWidth',1.5,'color',handles.color.l_r)
        set(p.lr.patch,'facecolor',handles.color.l_r)
        set(p.lr.mainLine,'LineWidth',2.5,'color',handles.color.l_r)
        set(p.lr.edge,'LineStyle',lstyle)
        set(p.lr.mainLine,'LineStyle',lstyle)
        
        p.lz = shadedErrorBar([1:length(handles.Results.lz_cycavg)]/handles.Results.Fs,handles.Results.lz_cycavg,...
            handles.Results.lz_cycstd,'lineprops',{'r-','MarkerFaceColor',handles.color.l_z});
        set(p.lz.edge,'LineWidth',1.5,'color',handles.color.l_z)
        set(p.lz.patch,'facecolor',handles.color.l_z)
        set(p.lz.mainLine,'LineWidth',2.5,'color',handles.color.l_z)
        set(p.lz.edge,'LineStyle',lstyle)
        set(p.lz.mainLine,'LineStyle',lstyle)
        if ~handles.REye.Value
        vals = [handles.cycavg.Children(2).YData(1:40) handles.cycavg.Children(3).YData(1:40)...
            handles.cycavg.Children(6).YData(1:40) handles.cycavg.Children(7).YData(1:40)...
            handles.cycavg.Children(10).YData(1:40) handles.cycavg.Children(11).YData(1:40)];
        upper = max(vals);
        lower = min(vals);
        end
end
if handles.REye.Value
        p.rl = shadedErrorBar([1:length(handles.Results.rl_cycavg)]/handles.Results.Fs,handles.Results.rl_cycavg,...
                    handles.Results.rl_cycstd,'lineprops',{'r-','MarkerFaceColor',handles.color.r_l})
                set(p.rl.edge,'LineWidth',1.5,'color',handles.color.r_l)
                set(p.rl.patch,'facecolor',handles.color.r_l)
                set(p.rl.mainLine,'LineWidth',2.5,'color',handles.color.r_l)
                set(p.rl.edge,'LineStyle',lstyle)
                set(p.rl.mainLine,'LineStyle',lstyle)
                
                p.rr = shadedErrorBar([1:length(handles.Results.rr_cycavg)]/handles.Results.Fs,handles.Results.rr_cycavg,...
                    handles.Results.rr_cycstd,'lineprops',{'r-','MarkerFaceColor',handles.color.r_r})
                set(p.rr.edge,'LineWidth',1.5,'color',handles.color.r_r)
                set(p.rr.patch,'facecolor',handles.color.r_r)
                set(p.rr.mainLine,'LineWidth',2.5,'color',handles.color.r_r)
                set(p.rr.edge,'LineStyle',lstyle)
                set(p.rr.mainLine,'LineStyle',lstyle)
                
                p.rz = shadedErrorBar([1:length(handles.Results.rz_cycavg)]/handles.Results.Fs,handles.Results.rz_cycavg,...
                    handles.Results.rz_cycstd,'lineprops',{'r-','MarkerFaceColor',handles.color.r_z})
                set(p.rz.edge,'LineWidth',1.5,'color',handles.color.r_z)
                set(p.rz.patch,'facecolor',handles.color.r_z)
                set(p.rz.mainLine,'LineWidth',2.5,'color',handles.color.r_z)
                set(p.rz.edge,'LineStyle',lstyle)
                set(p.rz.mainLine,'LineStyle',lstyle)
                if ~handles.LEye.Value
        vals = [handles.cycavg.Children(2).YData(1:40) handles.cycavg.Children(3).YData(1:40)...
            handles.cycavg.Children(6).YData(1:40) handles.cycavg.Children(7).YData(1:40)...
            handles.cycavg.Children(10).YData(1:40) handles.cycavg.Children(11).YData(1:40)];
        upper = max(vals);
        lower = min(vals);
                end
end
if handles.LEye.Value && handles.REye.Value
            vals = [handles.cycavg.Children(2).YData(1:40) handles.cycavg.Children(3).YData(1:40)...
            handles.cycavg.Children(6).YData(1:40) handles.cycavg.Children(7).YData(1:40)...
            handles.cycavg.Children(10).YData(1:40) handles.cycavg.Children(11).YData(1:40)...
            handles.cycavg.Children(14).YData(1:40) handles.cycavg.Children(15).YData(1:40)...
            handles.cycavg.Children(18).YData(1:40) handles.cycavg.Children(19).YData(1:40)...
            handles.cycavg.Children(22).YData(1:40) handles.cycavg.Children(23).YData(1:40)];
        upper = max(vals);
        lower = min(vals);
end
handles.cycavg.YLim = [lower-40 upper+40];
        plot([0.1 0.1],[lower-40 upper+40],'Color','k','LineWidt',2.5)
                hold(handles.cycavg,'off')
                

function handles = check_stim(handles)
if length(handles.segment(handles.segNum).stim_inds)>20
    list = handles.segment(handles.segNum).stim_inds;
    if isrow(handles.segment(handles.segNum).stim)
        handles.segment(handles.segNum).stim = handles.segment(handles.segNum).stim'
    end
    dec = find([diff(handles.segment(handles.segNum).stim)<0;0]);
    pulseW = dec-list;
    toAvg = mean(pulseW(pulseW>150));
    wrong = find(pulseW<toAvg-17);
    pos = 1;
    indtoLook = 1;
    while length(wrong)>0
        if abs(toAvg-pulseW(pos))>50
            if pulseW(wrong(indtoLook))>100
                if pulseW(wrong(indtoLook+1))<100
                    dec(wrong(indtoLook)) = [];
                    list(wrong(indtoLook)+1) = [];
                elseif pulseW(wrong(indtoLook+1))>100
                    A = abs(list(pos)-list(pos-1));
                    B = abs(list(pos+1)-list(pos-1));
                    if A>530
                    elseif B>530
                        dec(pos+1) = [];
                    list(pos+1) = [];
                    end
                end
            elseif pulseW(wrong(indtoLook))<100
                if pulseW(wrong(indtoLook+1))>100
                    dec(wrong(indtoLook)) = [];
                    list(wrong(indtoLook+1)) = [];
                end
                
            end
            pulseW = dec-list;
            toAvg = mean(pulseW(pulseW>150));
            wrong = find(pulseW<toAvg-17);
            indtoLook = indtoLook+1;
        end
        
        pos = pos+1;
    if length(list)==20
        wrong = [];
    end
    end
    handles.segment(handles.segNum).stim_inds = [];
    handles.segment(handles.segNum).stim_inds = list;
    
end



               



function posFiltOrder_Callback(hObject, eventdata, handles)
% hObject    handle to posFiltOrder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of posFiltOrder as text
%        str2double(get(hObject,'String')) returns contents of posFiltOrder as a double
if isempty(handles.posFiltLeng.String)
else
if str2num(handles.posFiltOrder.String)>0 && str2num(handles.posFiltLeng.String)>0
    handles = filterPos(handles)
end
handles = plotVel(handles)
handles = calc_cyc_avg(handles)
plot_cyc_avg(handles)
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function posFiltOrder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to posFiltOrder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function posFiltLeng_Callback(hObject, eventdata, handles)
% hObject    handle to posFiltLeng (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of posFiltLeng as text
%        str2double(get(hObject,'String')) returns contents of posFiltLeng as a double
if isempty(handles.posFiltOrder.String)
else
if str2num(handles.posFiltOrder.String)>0 && str2num(handles.posFiltLeng.String)>0
    handles = filterPos(handles)
end
handles = plotVel(handles)
handles = calc_cyc_avg(handles)
plot_cyc_avg(handles)
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function posFiltLeng_CreateFcn(hObject, eventdata, handles)
% hObject    handle to posFiltLeng (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in lefteye.
function lefteye_Callback(hObject, eventdata, handles)
% hObject    handle to lefteye (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lefteye


% --- Executes on button press in righteye.
function righteye_Callback(hObject, eventdata, handles)
% hObject    handle to righteye (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of righteye

function handles = filterPos(handles)
if mod(str2num(handles.posFiltLeng.String),2)
else
        handles.posFiltLeng.String = num2str(round((str2num(handles.posFiltLeng.String)-1)/2)*2+1)
end
handles.PosfiltFlag = 1;
handles.segment(handles.segNum).LEp_X = sgolayfilt(handles.RootData(handles.segNum).VOMA_data.Data_LE_Pos_X,str2num(handles.posFiltOrder.String),str2num(handles.posFiltLeng.String));
handles.segment(handles.segNum).LEp_Y = sgolayfilt(handles.RootData(handles.segNum).VOMA_data.Data_LE_Pos_Y,str2num(handles.posFiltOrder.String),str2num(handles.posFiltLeng.String));
handles.segment(handles.segNum).LEp_Z = sgolayfilt(handles.RootData(handles.segNum).VOMA_data.Data_LE_Pos_Z,str2num(handles.posFiltOrder.String),str2num(handles.posFiltLeng.String));
handles.segment(handles.segNum).REp_X = sgolayfilt(handles.RootData(handles.segNum).VOMA_data.Data_RE_Pos_X,str2num(handles.posFiltOrder.String),str2num(handles.posFiltLeng.String));
handles.segment(handles.segNum).REp_Y = sgolayfilt(handles.RootData(handles.segNum).VOMA_data.Data_RE_Pos_Y,str2num(handles.posFiltOrder.String),str2num(handles.posFiltLeng.String));
handles.segment(handles.segNum).REp_Z = sgolayfilt(handles.RootData(handles.segNum).VOMA_data.Data_RE_Pos_Z,str2num(handles.posFiltOrder.String),str2num(handles.posFiltLeng.String));

axes(handles.angPos)
cla(handles.angPos)
hold(handles.angPos,'on')
if handles.LEye.Value
    patchline(handles.segment(handles.segNum).t',handles.RootData(handles.segNum).VOMA_data.Data_LE_Pos_X,'edgecolor',handles.color.l_x,'LineWidth',0.05,'edgealpha',0.5);

    patchline(handles.segment(handles.segNum).t',handles.RootData(handles.segNum).VOMA_data.Data_LE_Pos_Y,'edgecolor',handles.color.l_y,'LineWidth',0.05,'edgealpha',0.5);
    patchline(handles.segment(handles.segNum).t',handles.RootData(handles.segNum).VOMA_data.Data_LE_Pos_Z,'edgecolor',handles.color.l_z,'LineWidth',0.05,'edgealpha',0.5);
plot(handles.angPos,handles.segment(handles.segNum).t,handles.segment(handles.segNum).LEp_X,'Color',handles.color.l_x);
    plot(handles.angPos,handles.segment(handles.segNum).t,handles.segment(handles.segNum).LEp_Y,'Color',handles.color.l_y);
    plot(handles.angPos,handles.segment(handles.segNum).t,handles.segment(handles.segNum).LEp_Z,'r','Color',handles.color.l_z);
end
if handles.REye.Value
        patchline(handles.segment(handles.segNum).t',handles.RootData(handles.segNum).VOMA_data.Data_RE_Pos_X,'edgecolor',handles.color.r_x,'LineWidth',0.05,'edgealpha',0.5);
    patchline(handles.segment(handles.segNum).t',handles.RootData(handles.segNum).VOMA_data.Data_RE_Pos_Y,'edgecolor',handles.color.r_y,'LineWidth',0.05,'edgealpha',0.5);
    patchline(handles.segment(handles.segNum).t',handles.RootData(handles.segNum).VOMA_data.Data_RE_Pos_Z,'edgecolor',handles.color.r_z,'LineWidth',0.05,'edgealpha',0.5);
plot(handles.angPos,handles.segment(handles.segNum).t,handles.segment(handles.segNum).REp_X,'Color',handles.color.r_x);
    plot(handles.angPos,handles.segment(handles.segNum).t,handles.segment(handles.segNum).REp_Y,'Color',handles.color.r_y);
    plot(handles.angPos,handles.segment(handles.segNum).t,handles.segment(handles.segNum).REp_Z,'r','Color',handles.color.r_z);


end
plot(handles.angPos,handles.segment(handles.segNum).stimT,handles.segment(handles.segNum).stim,'k');
    plot(handles.angPos,handles.segment(handles.segNum).stimT(handles.segment(handles.segNum).stim_inds),handles.segment(handles.segNum).stim(handles.segment(handles.segNum).stim_inds),'m*');
    plot(handles.angPos,repmat(handles.segment(handles.segNum).stimT(handles.segment(handles.segNum).stim_inds+100),1,2),[-100 100],'k');
    handles.angPos.YLim = [-100 100];
    hold(handles.angPos,'off')
    DAQ_code = handles.RootData(handles.segNum).VOMA_data.Parameters.DAQ_code;
    
    Data_In.Data_LE_Pos_X = handles.segment(handles.segNum).LEp_X;
Data_In.Data_LE_Pos_Y = handles.segment(handles.segNum).LEp_Y;
Data_In.Data_LE_Pos_Z = handles.segment(handles.segNum).LEp_Z;

Data_In.Data_RE_Pos_X = handles.segment(handles.segNum).REp_X;
Data_In.Data_RE_Pos_Y = handles.segment(handles.segNum).REp_Y;
Data_In.Data_RE_Pos_Z = handles.segment(handles.segNum).REp_Z;

Data_In.Fs = handles.RootData(handles.segNum).VOMA_data.Fs;
data_rot = 1;
OutputFormat = [];
[New_Ang_Vel] = voma__processeyemovements([],[],[],[],0,data_rot,DAQ_code,OutputFormat,Data_In);

handles.segment(handles.segNum).LE_LARP = New_Ang_Vel.LE_Vel_LARP;
handles.segment(handles.segNum).LE_RALP = New_Ang_Vel.LE_Vel_RALP;
handles.segment(handles.segNum).LE_Z = New_Ang_Vel.LE_Vel_Z;
handles.segment(handles.segNum).LE_X = New_Ang_Vel.LE_Vel_X;
handles.segment(handles.segNum).LE_Y = New_Ang_Vel.LE_Vel_Y;

handles.segment(handles.segNum).RE_LARP = New_Ang_Vel.RE_Vel_LARP;
handles.segment(handles.segNum).RE_RALP = New_Ang_Vel.RE_Vel_RALP;
handles.segment(handles.segNum).RE_Z = New_Ang_Vel.RE_Vel_Z;
handles.segment(handles.segNum).RE_X = New_Ang_Vel.RE_Vel_X;
handles.segment(handles.segNum).RE_Y = New_Ang_Vel.RE_Vel_Y;

handles.filtLELARP = handles.segment(handles.segNum).LE_LARP;
handles.filtLERALP = handles.segment(handles.segNum).LE_RALP;
handles.filtLEZ = handles.segment(handles.segNum).LE_Z;
handles.filtLEX = handles.segment(handles.segNum).LE_X;
handles.filtLEY = handles.segment(handles.segNum).LE_Y;

handles.filtRELARP = handles.segment(handles.segNum).RE_LARP;
handles.filtRERALP = handles.segment(handles.segNum).RE_RALP;
handles.filtREZ = handles.segment(handles.segNum).RE_Z;
handles.filtREX = handles.segment(handles.segNum).RE_X;
handles.filtREY = handles.segment(handles.segNum).RE_Y;


handles = plotVel(handles)

% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.segment(handles.segNum).LE_LARP=handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_LARP;
    handles.segment(handles.segNum).LE_RALP=handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_RALP;
    handles.segment(handles.segNum).LE_Z=handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_Z;
    handles.segment(handles.segNum).LEp_X=handles.RootData(handles.segNum).VOMA_data.Data_LE_Pos_X;
    handles.segment(handles.segNum).LEp_Y=handles.RootData(handles.segNum).VOMA_data.Data_LE_Pos_Y;
    handles.segment(handles.segNum).LEp_Z=handles.RootData(handles.segNum).VOMA_data.Data_LE_Pos_Z;
    handles.segment(handles.segNum).RE_LARP=handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_LARP;
    handles.segment(handles.segNum).RE_RALP=handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_RALP;
    handles.segment(handles.segNum).RE_Z=handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_Z;
    handles.segment(handles.segNum).REp_X=handles.RootData(handles.segNum).VOMA_data.Data_RE_Pos_X;
    handles.segment(handles.segNum).REp_Y=handles.RootData(handles.segNum).VOMA_data.Data_RE_Pos_Y;
    handles.segment(handles.segNum).REp_Z=handles.RootData(handles.segNum).VOMA_data.Data_RE_Pos_Z;
    handles.filtFlag = 0;
    handles.PosfiltFlag = 0;
    
    cla(handles.angPos)    
    hold(handles.angPos,'on')
    if handles.LEye.Value
    plot(handles.angPos,handles.segment(handles.segNum).t,handles.segment(handles.segNum).LEp_X,'Color',handles.color.l_x);

    plot(handles.angPos,handles.segment(handles.segNum).t,handles.segment(handles.segNum).LEp_Y,'Color',handles.color.l_y);
    plot(handles.angPos,handles.segment(handles.segNum).t,handles.segment(handles.segNum).LEp_Z,'r','Color',handles.color.l_z);
    end
    if handles.REye.Value
    plot(handles.angPos,handles.segment(handles.segNum).t,handles.segment(handles.segNum).REp_X,'Color',handles.color.r_x);
    plot(handles.angPos,handles.segment(handles.segNum).t,handles.segment(handles.segNum).REp_Y,'Color',handles.color.r_y);
    plot(handles.angPos,handles.segment(handles.segNum).t,handles.segment(handles.segNum).REp_Z,'r','Color',handles.color.r_z);
    end
    plot(handles.angPos,handles.segment(handles.segNum).stimT,handles.segment(handles.segNum).stim,'k');
    plot(handles.angPos,handles.segment(handles.segNum).stimT(handles.segment(handles.segNum).stim_inds),handles.segment(handles.segNum).stim(handles.segment(handles.segNum).stim_inds),'m*');
    plot(handles.angPos,repmat(handles.segment(handles.segNum).stimT(handles.segment(handles.segNum).stim_inds+100),1,2),[-100 100],'k');
    handles.angPos.YLim = [-100 100];
    hold(handles.angPos,'off')
guidata(hObject, handles);
handles = plotVel(handles)
handles = calc_cyc_avg(handles)
plot_cyc_avg(handles)
guidata(hObject, handles);


% --- Executes on button press in rawV.
function rawV_Callback(hObject, eventdata, handles)
% hObject    handle to rawV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = plotVel(handles)
guidata(hObject, handles);

function handles = plotVel(handles)


if isfield(handles.segment(handles.segNum),'txt') && ~isempty(handles.segment(handles.segNum).txt)
    if isfield(handles.segment(handles.segNum).txt,'Color')
    currColor = {handles.segment(handles.segNum).txt(:).Color};
    currColorFlag = 1;
    else
        currColorFlag = 0;
    end
else
    currColorFlag = 0;
end
cla(handles.axes1)
reset(handles.axes1);
axes(handles.axes1)
hold(handles.axes1,'on')
    switch handles.rawV.Value
    case 1
if handles.LEye.Value
    patchline(handles.segment(handles.segNum).t',handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_LARP,'edgecolor',handles.color.l_l,'LineWidth',0.05,'edgealpha',0.5);
    patchline(handles.segment(handles.segNum).t',handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_RALP,'edgecolor',handles.color.l_r,'LineWidth',0.05,'edgealpha',0.5);
    patchline(handles.segment(handles.segNum).t',handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_Z,'edgecolor',handles.color.l_z,'LineWidth',0.05,'edgealpha',0.5);
end
if handles.REye.Value
    patchline(handles.segment(handles.segNum).t',handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_LARP,'edgecolor',handles.color.r_l,'LineWidth',0.05,'edgealpha',0.5);
    patchline(handles.segment(handles.segNum).t',handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_RALP,'edgecolor',handles.color.r_r,'LineWidth',0.05,'edgealpha',0.5);
    patchline(handles.segment(handles.segNum).t',handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_Z,'edgecolor',handles.color.r_z,'LineWidth',0.05,'edgealpha',0.5);
end
handles.rawV.BackgroundColor = 'g';
    case 0
        handles.rawV.BackgroundColor = [0.94 0.94 0.94];
    end
    
if handles.filtFlag
    if handles.nystagCorr.Value
            handles = correction(handles);
            toUseLELARP = handles.corLELARP;
            toUseLERALP = handles.corLERALP;
            toUseLEZ = handles.corLEZ;
    else
        toUseLELARP = handles.filtLELARP;
        toUseLERALP = handles.filtLERALP;
        toUseLEZ = handles.filtLEZ;
        toUseRELARP = handles.filtRELARP;
        toUseRERALP = handles.filtRERALP;
        toUseREZ = handles.filtREZ;
    end
else
           toUseLELARP = handles.segment(handles.segNum).LE_LARP;
           toUseLERALP = handles.segment(handles.segNum).LE_RALP;
            toUseLEZ = handles.segment(handles.segNum).LE_Z;
            toUseRELARP = handles.segment(handles.segNum).RE_LARP;
           toUseRERALP = handles.segment(handles.segNum).RE_RALP;
            toUseREZ = handles.segment(handles.segNum).RE_Z;
    
end
if handles.LEye.Value
        plot(handles.axes1,handles.segment(handles.segNum).t,toUseLELARP,'Color',handles.color.l_l);
    plot(handles.axes1,handles.segment(handles.segNum).t,toUseLERALP,'Color',handles.color.l_r);
    plot(handles.axes1,handles.segment(handles.segNum).t,toUseLEZ,'r','Color',handles.color.l_z);
end
    if handles.REye.Value
        plot(handles.axes1,handles.segment(handles.segNum).t,toUseRELARP,'Color',handles.color.r_l);
    plot(handles.axes1,handles.segment(handles.segNum).t,toUseRERALP,'Color',handles.color.r_r);
    plot(handles.axes1,handles.segment(handles.segNum).t,toUseREZ,'r','Color',handles.color.r_z);
end
plot(handles.axes1,handles.segment(handles.segNum).stimT,handles.segment(handles.segNum).stim,'k');
    plot(handles.axes1,handles.segment(handles.segNum).stimT(handles.segment(handles.segNum).stim_inds),handles.segment(handles.segNum).stim(handles.segment(handles.segNum).stim_inds),'m*');
    plot(handles.axes1,repmat(handles.segment(handles.segNum).stimT(handles.segment(handles.segNum).stim_inds+100),1,2),[-350 350],'k');

    if currColorFlag
        for cycText = 1:length(handles.segment(handles.segNum).stim_inds)
        handles.segment(handles.segNum).txt(cycText) = text(handles.axes1,handles.segment(handles.segNum).stimT(handles.segment(handles.segNum).stim_inds(cycText)),40,[num2str(cycText)],'Color',currColor{cycText});
        end
else
    for cycText = 1:length(handles.segment(handles.segNum).stim_inds)
        handles.segment(handles.segNum).txt(cycText) = text(handles.axes1,handles.segment(handles.segNum).stimT(handles.segment(handles.segNum).stim_inds(cycText)),40,[num2str(cycText)],'Color','Green');
        end
end

    handles.axes1.YLim = [-350 350];
    hold(handles.axes1,'off')


% --- Executes on button press in link_x_axis_plots.
function link_x_axis_plots_Callback(hObject, eventdata, handles)
% hObject    handle to link_x_axis_plots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.linkaxisFlag = true;
    
    linkaxes([handles.axes1,handles.angPos],'x')
    
else
    handles.linkaxisFlag = false;
    
    
    linkaxes([handles.axes1,handles.angPos],'off')
    
    
end

% Hint: get(hObject,'Value') returns toggle state of link_x_axis_plots


% --- Executes on button press in nystagCorr.
function handles = nystagCorr_Callback(hObject, eventdata, handles)
% hObject    handle to nystagCorr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles = plotVel(handles);
handles = calc_cyc_avg(handles);
plot_cyc_avg(handles);
guidata(hObject, handles);

function handles = correction(handles)
if handles.nystagCorr.Value
    handles.corLELARP = [];
handles.corLERALP = [];
handles.corLEZ = [];
if handles.filtFlag
    handles.corLELARP = handles.filtLELARP;
            handles.corLERALP = handles.filtLERALP;
            handles.corLEZ = handles.filtLEZ;
else
    handles.corLELARP = handles.segment(handles.segNum).LE_LARP;
            handles.corLERALP = handles.segment(handles.segNum).LE_RALP;
            handles.corLEZ = handles.segment(handles.segNum).LE_Z;
end
    for i = 1:length(handles.segment(handles.segNum).stim_inds)
        if handles.filtFlag
            
            ind = handles.segment(handles.segNum).stim_inds(i);
            preL = handles.filtLELARP(ind-31:ind-1);
            preR = handles.filtLERALP(ind-31:ind-1);
            preZ = handles.filtLEZ(ind-31:ind-1);
            [mag, imag] = max(sqrt((preL).^2+(preR).^2+(preZ).^2));
            handles.corLELARP(ind:ind+100) = handles.filtLELARP(ind:ind+100)-preL(imag);
            handles.corLERALP(ind:ind+100) = handles.filtLERALP(ind:ind+100)-preR(imag);
            handles.corLEZ(ind:ind+100) = handles.filtLEZ(ind:ind+100)-preZ(imag);
        else
            
            ind = handles.segment(handles.segNum).stim_inds(i);
            preL = handles.segment(handles.segNum).LE_LARP(ind-31:ind-1);
            preR = handles.segment(handles.segNum).LE_RALP(ind-31:ind-1);
            preZ = handles.segment(handles.segNum).LE_Z(ind-31:ind-1);
            [mag, imag] = max(sqrt((preL).^2+(preR).^2+(preZ).^2));
            handles.corLELARP(ind:ind+100) = handles.segment(handles.segNum).LE_LARP(ind:ind+100)-preL(imag);
            handles.corLERALP(ind:ind+100) = handles.segment(handles.segNum).LE_RALP(ind:ind+100)-preR(imag);
            handles.corLEZ(ind:ind+100) = handles.segment(handles.segNum).LE_Z(ind:ind+100)-preZ(imag);

        end
 
    end
else
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over cycle_list.
function cycle_list_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to cycle_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in LEye.
function LEye_Callback(hObject, eventdata, handles)
% hObject    handle to LEye (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.angPos)    
    hold(handles.angPos,'on')
    if handles.LEye.Value
    plot(handles.angPos,handles.segment(handles.segNum).t,handles.segment(handles.segNum).LEp_X,'Color',handles.color.l_x);

    plot(handles.angPos,handles.segment(handles.segNum).t,handles.segment(handles.segNum).LEp_Y,'Color',handles.color.l_y);
    plot(handles.angPos,handles.segment(handles.segNum).t,handles.segment(handles.segNum).LEp_Z,'r','Color',handles.color.l_z);
    end
    if handles.REye.Value
    plot(handles.angPos,handles.segment(handles.segNum).t,handles.segment(handles.segNum).REp_X,'Color',handles.color.r_x);
    plot(handles.angPos,handles.segment(handles.segNum).t,handles.segment(handles.segNum).REp_Y,'Color',handles.color.r_y);
    plot(handles.angPos,handles.segment(handles.segNum).t,handles.segment(handles.segNum).REp_Z,'r','Color',handles.color.r_z);
    end
    plot(handles.angPos,handles.segment(handles.segNum).stimT,handles.segment(handles.segNum).stim,'k');
    plot(handles.angPos,handles.segment(handles.segNum).stimT(handles.segment(handles.segNum).stim_inds),handles.segment(handles.segNum).stim(handles.segment(handles.segNum).stim_inds),'m*');
    plot(handles.angPos,repmat(handles.segment(handles.segNum).stimT(handles.segment(handles.segNum).stim_inds+100),1,2),[-100 100],'k');
    handles.angPos.YLim = [-100 100];
    hold(handles.angPos,'off')
guidata(hObject, handles);
    handles = plotVel(handles);
handles = calc_cyc_avg(handles);
plot_cyc_avg(handles);
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of LEye


% --- Executes on button press in REye.
function REye_Callback(hObject, eventdata, handles)
% hObject    handle to REye (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.angPos)    
    hold(handles.angPos,'on')
    if handles.LEye.Value
    plot(handles.angPos,handles.segment(handles.segNum).t,handles.segment(handles.segNum).LEp_X,'Color',handles.color.l_x);

    plot(handles.angPos,handles.segment(handles.segNum).t,handles.segment(handles.segNum).LEp_Y,'Color',handles.color.l_y);
    plot(handles.angPos,handles.segment(handles.segNum).t,handles.segment(handles.segNum).LEp_Z,'r','Color',handles.color.l_z);
    end
    if handles.REye.Value
    plot(handles.angPos,handles.segment(handles.segNum).t,handles.segment(handles.segNum).REp_X,'Color',handles.color.r_x);
    plot(handles.angPos,handles.segment(handles.segNum).t,handles.segment(handles.segNum).REp_Y,'Color',handles.color.r_y);
    plot(handles.angPos,handles.segment(handles.segNum).t,handles.segment(handles.segNum).REp_Z,'r','Color',handles.color.r_z);
    end
    plot(handles.angPos,handles.segment(handles.segNum).stimT,handles.segment(handles.segNum).stim,'k');
    plot(handles.angPos,handles.segment(handles.segNum).stimT(handles.segment(handles.segNum).stim_inds),handles.segment(handles.segNum).stim(handles.segment(handles.segNum).stim_inds),'m*');
    plot(handles.angPos,repmat(handles.segment(handles.segNum).stimT(handles.segment(handles.segNum).stim_inds+100),1,2),[-100 100],'k');
    handles.angPos.YLim = [-100 100];
    hold(handles.angPos,'off')
guidata(hObject, handles);
    handles = plotVel(handles);
handles = calc_cyc_avg(handles);
plot_cyc_avg(handles);
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of REye
