function varargout = Voma_Processing(varargin)
% VOMA_PROCESSING MATLAB code for Voma_Processing.fig
%      VOMA_PROCESSING, by itself, creates a new VOMA_PROCESSING or raises the existing
%      singleton*.
%
%      H = VOMA_PROCESSING returns the handle to a new VOMA_PROCESSING or the handle to
%      the existing singleton*.
%
%      VOMA_PROCESSING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VOMA_PROCESSING.M with the given input arguments.
%
%      VOMA_PROCESSING('Property','Value',...) creates a new VOMA_PROCESSING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Voma_Processing_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Voma_Processing_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Voma_Processing

% Last Modified by GUIDE v2.5 27-Jun-2022 15:04:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Voma_Processing_OpeningFcn, ...
    'gui_OutputFcn',  @Voma_Processing_OutputFcn, ...
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
end

% --- Executes just before Voma_Processing is made visible.
function Voma_Processing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Voma_Processing (see VARARGIN)

% Choose default command line output for Voma_Processing
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
handles.yestoallFlag = 0;
handles.LEye.Enable = 'off';
handles.REye.Enable = 'off';

handles.RegVChange = 1;
handles.NystagVChange = 1;

handles.LearImplant.BackgroundColor = [1 0 0];
handles.RearImplant.BackgroundColor = [1 0 0];
% handles.p = pan;
% handles.p.ButtonDownFilter = @mycallback;
% handles.p.Enable = 'on';
% Update handles structure
handles.resultFields.Fs = [];

handles.resultFields.ll_cyc = [];
handles.resultFields.lr_cyc = [];
handles.resultFields.lz_cyc = [];
handles.resultFields.lx_cyc = [];
handles.resultFields.ly_cyc = [];

handles.resultFields.rl_cyc = [];
handles.resultFields.rr_cyc = [];
handles.resultFields.rz_cyc = [];
handles.resultFields.rx_cyc = [];
handles.resultFields.ry_cyc = [];

handles.resultFields.stim = [];

handles.resultFields.ll_cycavg = [];
handles.resultFields.ll_cycstd = [];
handles.resultFields.lr_cycavg = [];
handles.resultFields.lr_cycstd = [];
handles.resultFields.lz_cycavg = [];
handles.resultFields.lz_cycstd = [];
handles.resultFields.lx_cycavg = [];
handles.resultFields.lx_cycstd = [];
handles.resultFields.ly_cycavg = [];
handles.resultFields.ly_cycstd = [];

handles.resultFields.rl_cycavg = [];
handles.resultFields.rl_cycstd = [];
handles.resultFields.rr_cycavg = [];
handles.resultFields.rr_cycstd = [];
handles.resultFields.rz_cycavg = [];
handles.resultFields.rz_cycstd = [];
handles.resultFields.rx_cycavg = [];
handles.resultFields.rx_cycstd = [];
handles.resultFields.ry_cycavg = [];
handles.resultFields.ry_cycstd = [];

handles.resultFields.ll_cyc_NystagCorr = [];
handles.resultFields.lr_cyc_NystagCorr = [];
handles.resultFields.lz_cyc_NystagCorr = [];
handles.resultFields.lx_cyc_NystagCorr = [];
handles.resultFields.ly_cyc_NystagCorr = [];

handles.resultFields.rl_cyc_NystagCorr = [];
handles.resultFields.rr_cyc_NystagCorr = [];
handles.resultFields.rz_cyc_NystagCorr = [];
handles.resultFields.rx_cyc_NystagCorr = [];
handles.resultFields.ry_cyc_NystagCorr = [];

handles.resultFields.stim_NystagCorr = [];

handles.resultFields.ll_cycavg_NystagCorr = [];
handles.resultFields.ll_cycstd_NystagCorr = [];
handles.resultFields.lr_cycavg_NystagCorr = [];
handles.resultFields.lr_cycstd_NystagCorr = [];
handles.resultFields.lz_cycavg_NystagCorr = [];
handles.resultFields.lz_cycstd_NystagCorr = [];
handles.resultFields.lx_cycavg_NystagCorr = [];
handles.resultFields.lx_cycstd_NystagCorr = [];
handles.resultFields.ly_cycavg_NystagCorr = [];
handles.resultFields.ly_cycstd_NystagCorr = [];

handles.resultFields.rl_cycavg_NystagCorr = [];
handles.resultFields.rl_cycstd_NystagCorr = [];
handles.resultFields.rr_cycavg_NystagCorr = [];
handles.resultFields.rr_cycstd_NystagCorr = [];
handles.resultFields.rz_cycavg_NystagCorr = [];
handles.resultFields.rz_cycstd_NystagCorr = [];
handles.resultFields.rx_cycavg_NystagCorr = [];
handles.resultFields.rx_cycstd_NystagCorr = [];
handles.resultFields.ry_cycavg_NystagCorr = [];
handles.resultFields.ry_cycstd_NystagCorr = [];

handles.resultFields.QPparams = [];
handles.resultFields.QPposParam = [];
handles.resultFields.name = [];
handles.resultFields.raw_filename = [];
handles.resultFields.Parameters = [];
handles.resultFields.cyclist = [];
handles.resultFields.cyclist_NystagCorr = [];
handles.resultFields.FacialNerve = [];
handles.resultFields.segmentData = [];
handles.resultFields.NystagCorr = [];

handles.resultFields.allpullIndsL = [];
handles.resultFields.usedpullIndsL = [];
handles.resultFields.allMisalign3DL = [];
handles.resultFields.usedMisalign3DL = [];
handles.resultFields.allMisalignL = [];
handles.resultFields.usedMisalignL = [];
handles.resultFields.allmaxMagL = [];
handles.resultFields.usedmaxMagL = [];

handles.resultFields.allpullIndsL_NystagCorr = [];
handles.resultFields.usedpullIndsL_NystagCorr = [];
handles.resultFields.allMisalign3DL_NystagCorr = [];
handles.resultFields.usedMisalign3DL_NystagCorr = [];
handles.resultFields.allMisalignL_NystagCorr = [];
handles.resultFields.usedMisalignL_NystagCorr = [];
handles.resultFields.allmaxMagL_NystagCorr = [];
handles.resultFields.usedmaxMagL_NystagCorr = [];

handles.resultFields.allpullIndsR = [];
handles.resultFields.usedpullIndsR = [];
handles.resultFields.allMisalign3DR = [];
handles.resultFields.usedMisalign3DR = [];
handles.resultFields.allMisalignR = [];
handles.resultFields.usedMisalignR = [];
handles.resultFields.allmaxMagR = [];
handles.resultFields.usedmaxMagR = [];

handles.resultFields.allpullIndsR_NystagCorr = [];
handles.resultFields.usedpullIndsR_NystagCorr = [];
handles.resultFields.allMisalign3DR_NystagCorr = [];
handles.resultFields.usedMisalign3DR_NystagCorr = [];
handles.resultFields.allMisalignR_NystagCorr = [];
handles.resultFields.usedMisalignR_NystagCorr = [];
handles.resultFields.allmaxMagR_NystagCorr = [];
handles.resultFields.usedmaxMagR_NystagCorr = [];

handles.resultFields.stim_inds = [];
handles.resultFields.cycNum = [];
handles.resultFields.cycNum_NystagCorr = [];

handles.RawDataFilesDir = [];
handles.axes4.Title.String = 'Eye Velocity: Nystagmus Correction';
handles.axes1.Title.String = 'Eye Velocity';
handles.cycles_toSave.Position(1) = 0.42;
handles.cycles_toSave.Position(3) = .05;
handles.cycles_toSave_Nystag.Position(3) = .05;
handles.cycles_toSave_Nystag.Position(1) = .5;
handles.cycles_toSave_Nystag.Position(1) = .48;
handles.cycavg.Title.String = 'Cycle Average';
handles.cycavg_Nystag.Title.String = 'Cycle Average: Nystagmus Correction';

handles.ax1.ClippingStyle = 'rectangle';
handles.ax4.ClippingStyle = 'rectangle';
handles.cycavg.ClippingStyle = 'rectangle';
handles.cycavg_Nystag.ClippingStyle = 'rectangle';

handles.posFiltLeng.String = '3';


%For predicting filter params:
handles.PredictFilt.Noise = [];
handles.PredictFilt.EyeV = [];
handles.PredictFilt.VFO = [];
handles.PredictFilt.PFO = [];
handles.PredictFilt.PFFL = [];

handles.originalGUIPath = matlab.desktop.editor.getActiveFilename;
handles.originalGUIPath = strrep(handles.originalGUIPath,'Voma_Processing.m','');

if isfile([handles.originalGUIPath,'PredictFilt.mat'])
    tempP = load([handles.originalGUIPath,'PredictFilt.mat']);
    handles.PredictFilt = tempP.PredictFilt;
end
if isfile([handles.originalGUIPath,'PredictCycles.mat'])
    load([handles.originalGUIPath,'PredictCycles.mat']);
    handles.PredictCycles = PredictCycles;
end

    handles.linkaxisFlag = true;
    linkaxes([handles.axes4,handles.axes1,handles.angPos])
    
guidata(hObject, handles);

% UIWAIT makes Voma_Processing wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = Voma_Processing_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in new_VOMA_file.
function VOMA_file_Callback(hObject, eventdata, handles)
% hObject    handle to new_VOMA_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.vomaFile,handles.vomaPath] = uigetfile('*.voma','Select the voma you wish to process');
handles.current_filename.String = handles.vomaFile;
temp = load([handles.vomaPath, handles.vomaFile],'-mat');
cd(handles.vomaPath)
RootData = temp.Data_QPR;
handles.RootData = RootData;
handles.avgMag.String = 'NA';
handles.avgMagR.String = 'NA';
handles.magStd.String = 'NA';
handles.magStdR.String = 'NA';
handles.avgMis.String = 'NA';
handles.avgMisR.String = 'NA';
handles.misStd.String = 'NA';
handles.misStdR.String = 'NA';

handles.avgMag_Nystag.String = 'NA';
handles.avgMagR_Nystag.String = 'NA';
handles.magStd_Nystag.String = 'NA';
handles.magStdR_Nystag.String = 'NA';
handles.avgMis_Nystag.String = 'NA';
handles.avgMisR_Nystag.String = 'NA';
handles.misStd_Nystag.String = 'NA';
handles.misStdR_Nystag.String = 'NA';

if all(handles.RootData(1).VOMA_data.Data_RE_Vel_LARP==0)
    handles.REye.Value = 0;
else
    handles.REye.Value = 1;
end
if all(handles.RootData(1).VOMA_data.Data_LE_Vel_LARP==0)
    handles.LEye.Value = 0;
else
    handles.LEye.Value = 1;
end
handles.VOMANames = [];
handles.SegDataDir = [];
tf=cellfun(@(rep) strrep({handles.RootData.name},'.mat',rep),{''}, 'UniformOutput', 0);
handles.VOMANames = tf{1};
handles.total_files.String = num2str(length(handles.RootData));
handles.startVal = handles.startVal +1;
listOfFiles = [];
for i = 1:length(handles.RootData)
    dashes = strfind(handles.RootData(i).name,'-');
    stimInfo = handles.RootData(i).name(dashes(6)+1:end);
    stimInfo = strrep(stimInfo,'.mat','');
    listOfFiles = [listOfFiles; {[stimInfo]}];
end
handles.ecombsList.Value = 1;
handles.ecombsList.String = listOfFiles;
handles.ecombsList.UserData = listOfFiles;
if handles.startVal == 2
    handles.start.Visible = 1;
end
if contains(handles.vomaFile,'LARP')
    handles.pureRot = [1 0 0];
    handles.stimCanal = 1;
    if contains(handles.vomaFile,'Nancy')
        handles.rotSign  = 1;
    elseif contains(handles.vomaFile,'Yoda')
        handles.rotSign  = -1;
    elseif contains(handles.vomaFile,'GiGi')
        handles.rotSign  = 1;
    elseif contains(handles.vomaFile,'Opal')
        handles.rotSign  = 1;
    end
elseif contains(handles.vomaFile,'RALP')
    handles.pureRot = [0 1 0];
    handles.stimCanal = 2';
    if contains(handles.vomaFile,'Nancy')
        handles.rotSign  = 1;
    elseif contains(handles.vomaFile,'Yoda')
        handles.rotSign  = -1;
    elseif contains(handles.vomaFile,'GiGi')
        handles.rotSign  = 1;
    elseif contains(handles.vomaFile,'Opal')
        handles.rotSign  = 1;
    end
elseif contains(handles.vomaFile,'LHRH')
    handles.pureRot = [0 0 1];
    handles.stimCanal = 3;
    if contains(handles.vomaFile,'Nancy')
        handles.rotSign  = -1;
    elseif contains(handles.vomaFile,'Yoda')
        handles.rotSign  = 1;
    elseif contains(handles.vomaFile,'GiGi')
        handles.rotSign  = -1;
    elseif contains(handles.vomaFile,'Opal')
        handles.rotSign  = -1;
    end
end
guidata(hObject, handles);
end

% --- Executes on button press in choose_output_path.
function choose_output_path_Callback(hObject, eventdata, handles)
% hObject    handle to choose_output_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.cycDir = uigetdir(path,'Choose directory of the output files');
handles.output_path.String = handles.cycDir;
handles.startVal = handles.startVal +1;
handles.SegDataDir = [];
if handles.startVal > 1
    handles.start.Visible = 'on';
end
handles.yestoallFlag = 0;
handles.notoallFlag = 0;
handles.yesFlag = 0;
handles.noFlag = 0;
guidata(hObject, handles);
end

% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.LearImplant.BackgroundColor == [0.94 0.94 0.94]
    handles.start.Visible = 'off';

    cd(handles.cycDir)
    handles.segNum = 1;
    cla(handles.axes1)
    cla(handles.axes4)
    cla(handles.angPos)
    cla(handles.cycavg)
    cla(handles.cycavg_Nystag)
    handles.segment = [];
    handles.skip = 1;
    handles.FinishedFiles = [];
    handles.LEye.Enable = 'on';
    handles.REye.Enable = 'on';
    guidata(hObject, handles);
    handles = nextFile(handles);
    while handles.skipFile
        handles = nextFile(handles);
    end

    handles.skip = 0;
    guidata(hObject, handles);
end
end

function handles = nextFile(handles)
%handles.figure1.Visible = 'off';
cla(handles.angPos)
cla(handles.axes1)
cla(handles.axes4)
cla(handles.cycavg)
cla(handles.cycavg_Nystag)
handles.facial_nerve.BackgroundColor = [.94 .94 .94];
handles.rawV.Value = 0;
handles.FacialNerve = 0;
handles.filtFlag = 0;
handles.redoFlag =0;
handles.PosfiltFlag = 0;
handles.PredictCycs = 1;
handles.PredictCycs_Nystag = 1;

handles.segment.PosfiltFlag = 0;
handles.segment.filtFlag = 0;
handles.segment.NystagCorrFlag = 0;

handles.files_remaining.String = num2str(handles.segNum);

handles = UpdateFileList(handles);

handles = CheckExistingFiles(handles);

handles.files_remaining.String = num2str(handles.segNum);
name = strrep(handles.RootData(handles.segNum).name,'.mat','_CycleAvg');

if any(ismember(handles.FinishedFiles,handles.VOMANames(handles.segNum)))
    handles.t = load([name,'.mat']);
    handles.t = handles.t.Results;
    if ~isempty(handles.t.QPparams)
        handles.filterorder.String = strrep(handles.t.QPparams,'filtfilt Order ','');
    end
    if isfield(handles.t,'QPposParam')
        handles.posFiltOrder.String = num2str(handles.t.QPposParam(1));
        handles.posFiltLeng.String = num2str(handles.t.QPposParam(2));
    end

%     if isfield(handles.t,'NystagCorr')
%         handles.nystagCorr.Value = handles.t.NystagCorr;
%     else
%         if isfield(handles.t,'SecondM')
%             if isempty(handles.t.SecondM.ll_cyc) && isempty(handles.t.SecondM.rl_cyc)
%                 handles.nystagCorr.Value = 0;
%             else
%                 handles.nystagCorr.Value = 1;
%             end
%         else
%             handles.nystagCorr.Value = 0;
%         end
%     end

    if ~isempty(handles.cycle_list.String) && ~strcmp(handles.cycle_list.String{1},'')
        handles.cycle_list.String = [''];
    end
    if ~isempty(handles.cycle_list_Nystag.String) && ~strcmp(handles.cycle_list_Nystag.String{1},'')
        handles.cycle_list_Nystag.String = [''];
    end
    if isfield(handles.t,'stim_inds')
        for cycText = 1:length(handles.t.stim_inds)
            handles.cycle_list.String = [handles.cycle_list.String;{['Cycle ',num2str(cycText)]}];
            handles.cycle_list_Nystag.String = [handles.cycle_list_Nystag.String;{['Cycle ',num2str(cycText)]}];
        end
    else
        for cycText = 1:20
            handles.cycle_list.String = [handles.cycle_list.String;{['Cycle ',num2str(cycText)]}];
            handles.cycle_list_Nystag.String = [handles.cycle_list_Nystag.String;{['Cycle ',num2str(cycText)]}];
        end
    end
    handles.cycle_list.String= [handles.cycle_list.String;{'None'}];
    handles.cycle_list_Nystag.String= [handles.cycle_list_Nystag.String;{'None'}];
    handles.cycles_toSave.String = ['20 Cycles to Save'];
    handles.cycles_toSave_Nystag.String = ['20 Cycles to Save'];
    if length(handles.t.cyclist) == 20
        handles.cycle_list.Value = 21;
    else
        if isfield(handles.t,'stim_inds')
            handles.cycle_list.Value = find(~ismember(1:length(handles.t.stim_inds),handles.t.cyclist));
            handles.cycle_list.UserData = handles.t.cyclist;
        else
            temp = 1:20;
            handles.cycle_list.Value = find(~ismember(temp,handles.t.cyclist));
        end
    end
    if isfield(handles.t,'cyclist_NystagCorr')
        if isempty(handles.t.cyclist_NystagCorr)
            if isfield(handles.t,'stim_inds')
                handles.cycle_list_Nystag.Value = find(~ismember(1:length(handles.t.stim_inds),handles.t.cyclist));
                handles.cycle_list_Nystag.UserData = handles.t.cyclist;
            else
                temp = 1:20;
                handles.cycle_list_Nystag.Value = find(~ismember(temp,handles.t.cyclist));
            end
        elseif length(handles.t.cyclist_NystagCorr) == 20
            handles.cycle_list_Nystag.Value = 21;
        else 
            if isfield(handles.t,'stim_inds')
                handles.cycle_list_Nystag.Value = find(~ismember(1:length(handles.t.stim_inds),handles.t.cyclist_NystagCorr));
                handles.cycle_list_Nystag.UserData = handles.t.cyclist_NystagCorr;
            else
                temp = 1:20;
                handles.cycle_list_Nystag.Value = find(~ismember(temp,handles.t.cyclist_NystagCorr));
            end
        end
    else
        if length(handles.t.cyclist) == 20
            handles.cycle_list_Nystag.Value = 21;
        else
            if isfield(handles.t,'stim_inds')
                handles.cycle_list_Nystag.Value = find(~ismember(1:length(handles.t.stim_inds),handles.t.cyclist));
                handles.cycle_list_Nystag.UserData = handles.t.cyclist;
            else
                temp = 1:20;
                handles.cycle_list_Nystag.Value = find(~ismember(temp,handles.t.cyclist));
            end
        end
    end
    if handles.t.FacialNerve
        handles.FacialNerve = 1;
        handles.facial_nerve.BackgroundColor = 'Red';
    end
    handles.t = [];
    newList = 0;
else
    newList = 1;
end
handles.segment.LE_LARP=handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_LARP;
handles.segment.LE_RALP=handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_RALP;
handles.segment.LE_Z=handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_Z;
handles.segment.LE_X=handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_X;
handles.segment.LE_Y=handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_Y;
handles.segment.RE_LARP=handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_LARP;
handles.segment.RE_RALP=handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_RALP;
handles.segment.RE_Z=handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_Z;
handles.segment.RE_X=handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_X;
handles.segment.RE_Y=handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_Y;

handles.segment.LE_LARP_Filt=handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_LARP;
handles.segment.LE_RALP_Filt=handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_RALP;
handles.segment.LE_Z_Filt=handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_Z;
handles.segment.LE_X_Filt=handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_X;
handles.segment.LE_Y_Filt=handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_Y;
handles.segment.RE_LARP_Filt=handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_LARP;
handles.segment.RE_RALP_Filt=handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_RALP;
handles.segment.RE_Z_Filt=handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_Z;
handles.segment.RE_X_Filt=handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_X;
handles.segment.RE_Y_Filt=handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_Y;

handles.segment.maxMagL = [];
handles.segment.MisalignL = [];
handles.segment.maxMagL = [];
handles.segment.MisalignL = [];
handles.segment.maxMagR = [];
handles.segment.MisalignR = [];
handles.segment.maxMagR = [];
handles.segment.MisalignR = [];

handles.segment.LE_LARP_NystagCorr=[];
handles.segment.LE_RALP_NystagCorr=[];
handles.segment.LE_Z_NystagCorr=[];
handles.segment.LE_X_NystagCorr=[];
handles.segment.LE_Y_NystagCorr=[];
handles.segment.RE_LARP_NystagCorr=[];
handles.segment.RE_RALP_NystagCorr=[];
handles.segment.RE_Z_NystagCorr=[];
handles.segment.RE_X_NystagCorr=[];
handles.segment.RE_Y_NystagCorr=[];

handles.segment.LE_LARP_NystagCorr_Filt=[];
handles.segment.LE_RALP_NystagCorr_Filt=[];
handles.segment.LE_Z_NystagCorr_Filt=[];
handles.segment.LE_X_NystagCorr_Filt=[];
handles.segment.LE_Y_NystagCorr_Filt=[];
handles.segment.RE_LARP_NystagCorr_Filt=[];
handles.segment.RE_RALP_NystagCorr_Filt=[];
handles.segment.RE_Z_NystagCorr_Filt=[];
handles.segment.RE_X_NystagCorr_Filt=[];
handles.segment.RE_Y_NystagCorr_Filt=[];

handles.segment.maxMagL_NystagCorr = [];
handles.segment.MisalignL_NystagCorr = [];
handles.segment.maxMagL_NystagCorr = [];
handles.segment.MisalignL_NystagCorr = [];
handles.segment.maxMagR_NystagCorr = [];
handles.segment.MisalignR_NystagCorr = [];
handles.segment.maxMagR_NystagCorr = [];
handles.segment.MisalignR_NystagCorr = [];

handles.segment.LEp_X=handles.RootData(handles.segNum).VOMA_data.Data_LE_Pos_X;
handles.segment.LEp_Y=handles.RootData(handles.segNum).VOMA_data.Data_LE_Pos_Y;
handles.segment.LEp_Z=handles.RootData(handles.segNum).VOMA_data.Data_LE_Pos_Z;
handles.segment.REp_X=handles.RootData(handles.segNum).VOMA_data.Data_RE_Pos_X;
handles.segment.REp_Y=handles.RootData(handles.segNum).VOMA_data.Data_RE_Pos_Y;
handles.segment.REp_Z=handles.RootData(handles.segNum).VOMA_data.Data_RE_Pos_Z;

handles.segment.stim=handles.RootData(handles.segNum).VOMA_data.Stim_Trace;
handles.segment.stimT=handles.RootData(handles.segNum).VOMA_data.Stim_t;
handles.segment.t=handles.RootData(handles.segNum).VOMA_data.Eye_t;


if isrow(handles.segment.stimT)
    handles.segment.stimT = handles.segment.stimT';
end
if isrow(handles.segment.stim)
    handles.segment.stim = handles.segment.stim';
end
inds = [1:length(handles.segment.stimT)];
inbtw = find(isnan(handles.segment.stim));
handles.segment.stim(inbtw) = 0;
pos_ind = [false ; diff(handles.segment.stim)>0];

handles.segment.stim_inds = inds(pos_ind > 0 )';
if isempty(handles.segment.stim_inds)
    handles.skipFile = 1;
    handles.segNum = handles.segNum +1;

else
    handles.skipFile = 0;
    if isfield(handles,'segment')
        if isfield(handles.segment,'txt')
            rmfield(handles.segment,'txt');
        end
    end
    if newList
        if ~isempty(handles.cycle_list.String) && ~strcmp(handles.cycle_list.String{1},'')
            handles.cycle_list.String = [''];
        end
        for cycText = 1:length(handles.segment.stim_inds)
            handles.cycle_list.String = [handles.cycle_list.String;{['Cycle ',num2str(cycText)]}];
        end
        handles.cycle_list.String= [handles.cycle_list.String;{'None'}];
        handles.cycles_toSave.String = [num2str(length(handles.segment.stim_inds)),' Cycles to Save'];
        handles.output_filename.String = name;
        handles.cycle_list.Value = length(handles.segment.stim_inds)+1;

        if ~isempty(handles.cycle_list_Nystag.String) && ~strcmp(handles.cycle_list_Nystag.String{1},'')
            handles.cycle_list_Nystag.String = [''];
        end
        for cycText = 1:length(handles.segment.stim_inds)
            handles.cycle_list_Nystag.String = [handles.cycle_list_Nystag.String;{['Cycle ',num2str(cycText)]}];
        end
        handles.cycle_list_Nystag.String= [handles.cycle_list_Nystag.String;{'None'}];
        handles.cycles_toSave_Nystag.String = [num2str(length(handles.segment.stim_inds)),' Cycles to Save'];
        handles.cycle_list_Nystag.Value = length(handles.segment.stim_inds)+1;
    end
    handles = check_stim(handles);
    handles = filter_Plot_Pos(handles);

    pMaxmag = polyfit([handles.PredictCycles.avgMag],[handles.PredictCycles.MaxMag],1);
    pMinmag = polyfit([handles.PredictCycles.avgMag],[handles.PredictCycles.MinMag],1);

    pMaxmis = polyfit([handles.PredictCycles.avgMis],[handles.PredictCycles.MaxMis],1);
    pMinmis = polyfit([handles.PredictCycles.avgMis],[handles.PredictCycles.MinMis],1);

    uVFO = unique(handles.PredictFilt.VFO)';
    bnds = [];
    for ii = uVFO
        ids = handles.PredictFilt.VFO == ii;
        minv = min([handles.PredictFilt.EyeV(ids)' ]);
        maxv = max([handles.PredictFilt.EyeV(ids)']);
        bnds = [bnds [maxv; minv]];
    end

    if all(handles.segment.maxMagL==0)
        io = isoutlier(handles.segment.maxMagR_NystagCorr,'percentiles',[35 65]);
        mr = mean(handles.segment.maxMagR_NystagCorr(~io));
        
        if mr < 40
            multM = 1.15;
            mult1 = .85;
        else
            multM = 1;
            mult1 = 1;
        end
        p1 = polyval(pMaxmag,mr)*multM;
        p1b = polyval(pMinmag,mr)*mult1;
        
        io = isoutlier(handles.segment.MisalignR_NystagCorr,'percentiles',[15 85]);
        mrm = mean(handles.segment.MisalignR_NystagCorr(~io));

        p2 = polyval(pMaxmis,mrm);
        p2b = polyval(pMinmis,mrm);

        tooBig = handles.segment.maxMagR_NystagCorr>p1;
        tooSmall = handles.segment.maxMagR_NystagCorr<p1b;
        toob = handles.segment.MisalignR_NystagCorr>p2;
        toos = handles.segment.MisalignR_NystagCorr<p2b;
        fin = tooBig+tooSmall+toob+toos>0;

        io = isoutlier(handles.segment.maxMagR,'percentiles',[35 65]);
        mr2 = mean(handles.segment.maxMagR(~io));

        p1 = polyval(pMaxmag,mr2)*multM;
        p1b = polyval(pMinmag,mr2)*mult1;
        
        io = isoutlier(handles.segment.MisalignR,'percentiles',[15 85]);
        mrm2 = mean(handles.segment.MisalignR(~io));

        p2 = polyval(pMaxmis,mrm2);
        p2b = polyval(pMinmis,mrm2);

        tooBig = handles.segment.maxMagR>p1;
        tooSmall = handles.segment.maxMagR<p1b;
        toob = handles.segment.MisalignR>p2;
        toos = handles.segment.MisalignR<p2b;
        fin2 = tooBig+tooSmall+toob+toos>0;

        for i = 1:length(handles.cycle_list.String)-1
            if fin(i)
                handles.cycle_list_Nystag.String(i) = {['<html><font color="red">',handles.cycle_list_Nystag.String{i},'</font></html>']};
            end

            if fin2(i)
                handles.cycle_list.String(i) = {['<html><font color="red">',handles.cycle_list.String{i},'</font></html>']};
            end
        end

        mrP = find(bnds(1,:)-mr>0);
        mrP2 = find(mr - bnds(2,:)>0);
        mrP = find(ismember(mrP,mrP2));
        if isempty(mrP)
            if mr>max(max(bnds))
                toU = 1;
            else
                toU = 19;
            end
        else
            toU = uVFO(min(mrP));
        end
    elseif all(handles.segment.maxMagR==0)
        io = isoutlier(handles.segment.maxMagL_NystagCorr,'percentiles',[35 65]);
        ml = mean(handles.segment.maxMagL_NystagCorr(~io));

        if ml < 40
            multM = 1.15;
            mult1 = .85;
        else
            multM = 1;
            mult1 = 1;
        end
        p1 = polyval(pMaxmag,ml)*multM;
        p1b = polyval(pMinmag,ml)*mult1;
        
        io = isoutlier(handles.segment.MisalignL_NystagCorr,'percentiles',[15 85]);
        mlm = mean(handles.segment.MisalignL_NystagCorr(~io));

        p2 = polyval(pMaxmis,mlm);
        p2b = polyval(pMinmis,mlm);

        tooBig = handles.segment.maxMagL_NystagCorr>p1;
        tooSmall = handles.segment.maxMagL_NystagCorr<p1b;
        toob = handles.segment.MisalignL_NystagCorr>p2;
        toos = handles.segment.MisalignL_NystagCorr<p2b;
        fin = tooBig+tooSmall+toob+toos>0;

        io = isoutlier(handles.segment.maxMagL,'percentiles',[35 65]);
        ml2 = mean(handles.segment.maxMagL(~io));

        p1 = polyval(pMaxmag,ml2)*multM;
        p1b = polyval(pMinmag,ml2)*mult1;
        
        io = isoutlier(handles.segment.MisalignL,'percentiles',[15 85]);
        mlm2 = mean(handles.segment.MisalignL(~io));

        p2 = polyval(pMaxmis,mlm2);
        p2b = polyval(pMinmis,mlm2);

        tooBig = handles.segment.maxMagL>p1;
        tooSmall = handles.segment.maxMagL<p1b;
        toob = handles.segment.MisalignL>p2;
        toos = handles.segment.MisalignL<p2b;
        fin2 = tooBig+tooSmall+toob+toos>0;

        for i = 1:length(handles.cycle_list.String)-1
            if fin(i)
                handles.cycle_list_Nystag.String(i) = {['<html><font color="red">',handles.cycle_list_Nystag.String{i},'</font></html>']};
            end

            if fin2(i)
                handles.cycle_list.String(i) = {['<html><font color="red">',handles.cycle_list.String{i},'</font></html>']};
            end
        end

        mlP = find(bnds(1,:)-ml>0);
        mlP2 = find(ml - bnds(2,:)>0);
        mlP = find(ismember(mlP,mlP2));
        if isempty(mlP)
            if ml>max(max(bnds))
                toU = 1;
            else
                toU = 19;
            end
        else
            toU = uVFO(min(mlP));
        end
    else
        io = isoutlier(handles.segment.maxMagR_NystagCorr,'percentiles',[15 85]);
        mr = mean(handles.segment.maxMagR_NystagCorr(~io));
        io = isoutlier(handles.segment.maxMagL_NystagCorr,'percentiles',[15 85]);
        ml = mean(handles.segment.maxMagL_NystagCorr(~io));

        if mr < 40
            multM = 1.15;
            mult1 = .85;
        else
            multM = 1;
            mult1 = 1;
        end
        p1 = polyval(pMaxmag,mr)*multM;
        p1b = polyval(pMinmag,mr)*mult1;

        p1L = polyval(pMaxmag,ml)*multM;
        p1bL = polyval(pMinmag,ml)*mult1;
        
        io = isoutlier(handles.segment.MisalignR_NystagCorr,'percentiles',[15 85]);
        mrm = mean(handles.segment.MisalignR_NystagCorr(~io));
        io = isoutlier(handles.segment.MisalignL_NystagCorr,'percentiles',[15 85]);
        mlm = mean(handles.segment.MisalignL_NystagCorr(~io));

        p2 = polyval(pMaxmis,mrm);
        p2b = polyval(pMinmis,mrm);
        p2L = polyval(pMaxmis,mlm);
        p2bL = polyval(pMinmis,mlm);

        tooBig = handles.segment.maxMagR_NystagCorr>p1;
        tooSmall = handles.segment.maxMagR_NystagCorr<p1b;
        toob = handles.segment.MisalignR_NystagCorr>p2;
        toos = handles.segment.MisalignR_NystagCorr<p2b;

        tooBigL = handles.segment.maxMagL_NystagCorr>p1L;
        tooSmallL = handles.segment.maxMagL_NystagCorr<p1bL;
        toobL = handles.segment.MisalignL_NystagCorr>p2L;
        toosL = handles.segment.MisalignL_NystagCorr<p2bL;
        fin = tooBig+tooSmall+toob+toos+tooBigL+tooSmallL+toobL+toosL>0;

        io = isoutlier(handles.segment.maxMagR,'percentiles',[35 65]);
        mr2 = mean(handles.segment.maxMagR(~io));
        io = isoutlier(handles.segment.maxMagL,'percentiles',[35 65]);
        ml2 = mean(handles.segment.maxMagL(~io));

        p1 = polyval(pMaxmag,mr2)*multM;
        p1b = polyval(pMinmag,mr2)*mult1;
        p1L = polyval(pMaxmag,ml2)*multM;
        p1bL = polyval(pMinmag,ml2)*mult1;

        io = isoutlier(handles.segment.MisalignR,'percentiles',[15 85]);
        mrm2 = mean(handles.segment.MisalignR(~io));
        io = isoutlier(handles.segment.MisalignL,'percentiles',[15 85]);
        mlm2 = mean(handles.segment.MisalignL(~io));

        p2 = polyval(pMaxmis,mrm2);
        p2b = polyval(pMinmis,mrm2);
        p2L = polyval(pMaxmis,mlm2);
        p2bL = polyval(pMinmis,mlm2);

        tooBig = handles.segment.maxMagR>p1;
        tooSmall = handles.segment.maxMagR<p1b;
        toob = handles.segment.MisalignR>p2;
        toos = handles.segment.MisalignR<p2b;
        tooBigL = handles.segment.maxMagL>p1;
        tooSmallL = handles.segment.maxMagL<p1b;
        toobL = handles.segment.MisalignL>p2;
        toosL = handles.segment.MisalignL<p2b;

        fin2 = tooBig+tooSmall+toob+toos+tooBigL+tooSmallL+toobL+toosL>0;

        for i = 1:length(handles.cycle_list.String)-1
            if fin(i)
                handles.cycle_list_Nystag.String(i) = {['<html><font color="red">',handles.cycle_list_Nystag.String{i},'</font></html>']};
            end

            if fin2(i)
                handles.cycle_list.String(i) = {['<html><font color="red">',handles.cycle_list.String{i},'</font></html>']};
            end
        end


        mlP = find(bnds(1,:)-ml>0);
        mlP2 = find(ml - bnds(2,:)>0);
        mlP = find(ismember(mlP,mlP2));

        mrP = find(bnds(1,:)-mr>0);
        mrP2 = find(mr - bnds(2,:)>0);
        mrP = find(ismember(mrP,mrP2));
        if isempty(mrP) && isempty(mlP)
            if ml>max(max(bnds))
                toU = 1;
            else
                toU = 19;
            end
        else
            toU = uVFO(min([mlP mrP]));
        end
        
    end
    if str2num(handles.posFiltLeng.String) == 3
        if toU ~= handles.tofilt
            handles.tofilt = toU;
            handles.filterorder.String = num2str(toU);
            handles = filterVel(handles);
        end
    else
        handles.posFiltLeng.String = '3';
        handles.tofilt = toU;
        handles.filterorder.String = num2str(toU);
        handles = filter_Plot_Pos(handles);
    end


end
end

function handles = UpdateFileList(handles)
handles.listing = dir(handles.cycDir);
handles.listing([handles.listing.isdir]) = [];
if any(ismember({handles.listing.name},'Plots.mat'))
    handles.listing(ismember({handles.listing.name},'Plots.mat')) = [];
end
if any(ismember({handles.listing.name},'CycleParams.mat'))
    handles.listing(ismember({handles.listing.name},'CycleParams.mat')) = [];
end
t = {handles.listing.name};
tf=cellfun(@(rep) strrep(t,'_CycleAvg.mat',rep),{''}, 'UniformOutput', 0);
tf=tf{1};
handles.FinishedFiles = tf;
handles.ecombsList.String=handles.ecombsList.UserData;
for q = 1:length(handles.VOMANames)
    if any(ismember(handles.FinishedFiles,handles.VOMANames(q)))
        handles.ecombsList.String(q) = {['<html><font color="red">',handles.ecombsList.String{q},'</font></html>']};
    end
end
handles.ecombsList.Value = handles.segNum;
end

function handles = CheckExistingFiles(handles)
go = 1;
while go
    handles.ecombsList.Value = handles.segNum;
    name = strrep(handles.RootData(handles.segNum).name,'.mat','_CycleAvg');
    handles.output_filename.String = name;
    if any(ismember(handles.FinishedFiles,handles.VOMANames(handles.segNum))) && ~handles.yestoallFlag
        handles.Results = load([name,'.mat']);
        handles.Results = handles.Results.Results;
        skipQ = 0;
        if isfield(handles.Results,'NystagCorr')
            if handles.Results.NystagCorr == 0
                handles.yesFlag = 1;
                go = 0;
                skipQ = 1;
                message = {'Cycle average file structure out of date!','Please re-analyze','(Message will close automatically)'};
                alle = warndlg(message);
                pause(2)
                delete(alle)
            elseif isfield(handles.Results,'ll_cyc_NystagCorr')
                if isempty(handles.Results.ll_cyc_NystagCorr)
                    handles.yesFlag = 1;
                    go = 0;
                    skipQ = 1;
                    message = {'Cycle average file structure out of date!','Please re-analyze','(Message will close automatically)'};
                    alle = warndlg(message);
                    pause(2)
                    delete(alle)
                elseif isempty(handles.Results.ll_cyc)
                    handles.yesFlag = 1;
                    go = 0;
                    skipQ = 1;
                    message = {'Cycle average file structure out of date!','Please re-analyze','(Message will close automatically)'};
                    alle = warndlg(message);
                    pause(2)
                    delete(alle)
                end
            end
        else
            handles.yesFlag = 1;
            go = 0;
            skipQ = 1;
            message = {'Cycle average file structure out of date!','Please re-analyze','(Message will close automatically)'};
            alle = warndlg(message);
            pause(2)
            delete(alle)
        end

        if ~skipQ
            f1 = fields(handles.resultFields);
            f2 = fields(handles.Results);
            if ~isequal(f1,f2)
                handles = updateCycFile(handles);
                Results = handles.resT;
                save([name,'.mat'],'Results')
                handles.Results = Results;

            end
            plot_cyc_avg(handles)
            handles.cycavg.YLim = [-100 100];
            handles.cycavg.XLim = [0 0.11];
            handles.cycavg_Nystag.YLim = [-100 100];
            handles.cycavg_Nystag.XLim = [0 0.11];
            handles.Results = [];
            handles.yesFlag = 0;
            handles.noFlag = 0;
            if ~handles.notoallFlag
                answer = nbuttondlg([{name};{'This file already exsits, would you like to overwrite it?'}],{'Yes','No','Yes To All','No To All'},'DefaultButton',2,'PromptTextHeight',50);
            else
                answer = 'No To All';
            end
            switch answer
                case 'Yes'
                    handles.yesFlag = 1;
                    go = 0;
                case 'No'
                    handles.noFlag = 1;
                    handles.segNum = handles.segNum +1;
                    handles.files_remaining.String = num2str(handles.segNum);
                    if handles.segNum<length(handles.RootData)+1
                        name = strrep(handles.RootData(handles.segNum).name,'.mat','_CycleAvg');
                    else
                        go = 0;
                    end
                case 'Yes To All'
                    handles.yestoallFlag = 1;
                    go = 0;
                case 'No To All'
                    handles.notoallFlag = 1;
                    handles.segNum = handles.segNum +1;
                    handles.files_remaining.String = num2str(handles.segNum);
                    if handles.segNum<length(handles.RootData)+1
                        name = strrep(handles.RootData(handles.segNum).name,'.mat','_CycleAvg');
                    else
                        go = 0;
                    end
            end
        end
    else
        handles.notoallFlag = 0;
        go = 0;

    end
end
end

function handles = updateCycFile(handles)
    Results = handles.resultFields;
    f1 = fields(handles.resultFields);
    f2 = fields(handles.Results);
    for ii = 1:length(f2)
        if any(ismember(f1,f2(ii)))
            fil = ismember(f1,f2(ii));
            Results.(f1{fil}) = handles.Results.(f2{ii});
        else
            if ismember(f2(ii),{'SecondM'})
                f2b = fields(handles.Results.SecondM);
                for ij = 1:length(f2b)
                    if any(ismember(f1,{[f2b{ij},'_NystagCorr']}))
                        fil = ismember(f1,{[f2b{ij},'_NystagCorr']});
                        Results.(f1{fil}) = handles.Results.SecondM.(f2b{ij});
                        if ij == 1
                            if ~isempty(handles.Results.SecondM.(f2b{ij}))
                                Results.NystagCorr = 1;
                            else
                                Results.NystagCorr = 0;
                            end
                        end
                    end
                end
            end
        end
    end
    handles.resT = Results;
end

function handles = check_stim(handles)
if length(handles.segment.stim_inds)>20
    list = handles.segment.stim_inds;
    if isrow(handles.segment.stim)
        handles.segment.stim = handles.segment.stim';
    end
    dec = find([diff(handles.segment.stim)<0;0]);
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
    handles.segment.stim_inds = [];
    handles.segment.stim_inds = list;

end
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
        handles = filter_Plot_Pos(handles);
    end
end
guidata(hObject, handles);
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
        handles = filter_Plot_Pos(handles);
    end
end
guidata(hObject, handles);
end

function handles = filter_Plot_Pos(handles)
if mod(str2num(handles.posFiltLeng.String),2)
else
    handles.posFiltLeng.String = num2str(round((str2num(handles.posFiltLeng.String)-1)/2)*2+1);
end
handles.PosfiltFlag = 1;
handles.segment.PosfiltFlag = 1;
handles.segment.LEp_X = sgolayfilt(handles.RootData(handles.segNum).VOMA_data.Data_LE_Pos_X,str2num(handles.posFiltOrder.String),str2num(handles.posFiltLeng.String));
handles.segment.LEp_Y = sgolayfilt(handles.RootData(handles.segNum).VOMA_data.Data_LE_Pos_Y,str2num(handles.posFiltOrder.String),str2num(handles.posFiltLeng.String));
handles.segment.LEp_Z = sgolayfilt(handles.RootData(handles.segNum).VOMA_data.Data_LE_Pos_Z,str2num(handles.posFiltOrder.String),str2num(handles.posFiltLeng.String));
handles.segment.REp_X = sgolayfilt(handles.RootData(handles.segNum).VOMA_data.Data_RE_Pos_X,str2num(handles.posFiltOrder.String),str2num(handles.posFiltLeng.String));
handles.segment.REp_Y = sgolayfilt(handles.RootData(handles.segNum).VOMA_data.Data_RE_Pos_Y,str2num(handles.posFiltOrder.String),str2num(handles.posFiltLeng.String));
handles.segment.REp_Z = sgolayfilt(handles.RootData(handles.segNum).VOMA_data.Data_RE_Pos_Z,str2num(handles.posFiltOrder.String),str2num(handles.posFiltLeng.String));

set(handles.figure1,'CurrentAxes',handles.angPos)
cla(handles.angPos)
hold(handles.angPos,'on')
if handles.LEye.Value
    patchline(handles.segment.t',handles.RootData(handles.segNum).VOMA_data.Data_LE_Pos_X,'edgecolor',handles.color.l_x,'LineWidth',0.05,'edgealpha',0.5);

    patchline(handles.segment.t',handles.RootData(handles.segNum).VOMA_data.Data_LE_Pos_Y,'edgecolor',handles.color.l_y,'LineWidth',0.05,'edgealpha',0.5);
    patchline(handles.segment.t',handles.RootData(handles.segNum).VOMA_data.Data_LE_Pos_Z,'edgecolor',handles.color.l_z,'LineWidth',0.05,'edgealpha',0.5);
    plot(handles.angPos,handles.segment.t,handles.segment.LEp_X,'Color',handles.color.l_x);
    plot(handles.angPos,handles.segment.t,handles.segment.LEp_Y,'Color',handles.color.l_y);
    plot(handles.angPos,handles.segment.t,handles.segment.LEp_Z,'r','Color',handles.color.l_z);
end
if handles.REye.Value
    patchline(handles.segment.t',handles.RootData(handles.segNum).VOMA_data.Data_RE_Pos_X,'edgecolor',handles.color.r_x,'LineWidth',0.05,'edgealpha',0.5);
    patchline(handles.segment.t',handles.RootData(handles.segNum).VOMA_data.Data_RE_Pos_Y,'edgecolor',handles.color.r_y,'LineWidth',0.05,'edgealpha',0.5);
    patchline(handles.segment.t',handles.RootData(handles.segNum).VOMA_data.Data_RE_Pos_Z,'edgecolor',handles.color.r_z,'LineWidth',0.05,'edgealpha',0.5);
    plot(handles.angPos,handles.segment.t,handles.segment.REp_X,'Color',handles.color.r_x);
    plot(handles.angPos,handles.segment.t,handles.segment.REp_Y,'Color',handles.color.r_y);
    plot(handles.angPos,handles.segment.t,handles.segment.REp_Z,'r','Color',handles.color.r_z);
end

plot(handles.angPos,handles.segment.stimT,handles.segment.stim,'k');
plot(handles.angPos,handles.segment.stimT(handles.segment.stim_inds),handles.segment.stim(handles.segment.stim_inds),'m*');
plot(handles.angPos,repmat(handles.segment.stimT(handles.segment.stim_inds+100),1,2),[-100 100],'k');
plot(handles.angPos,repmat(handles.segment.stimT(handles.segment.stim_inds+30),1,2),[-100 100],'r--');
plot(handles.angPos,handles.segment.stimT([1 end]),[40 40],'Color',[.94 .94 .94],'LineStyle','--');
handles.angPos.YLim = [-100 100];
hold(handles.angPos,'off')
DAQ_code = handles.RootData(handles.segNum).VOMA_data.Parameters.DAQ_code;

Data_In.Data_LE_Pos_X = handles.segment.LEp_X;
Data_In.Data_LE_Pos_Y = handles.segment.LEp_Y;
Data_In.Data_LE_Pos_Z = handles.segment.LEp_Z;

Data_In.Data_RE_Pos_X = handles.segment.REp_X;
Data_In.Data_RE_Pos_Y = handles.segment.REp_Y;
Data_In.Data_RE_Pos_Z = handles.segment.REp_Z;

Data_In.Fs = handles.RootData(handles.segNum).VOMA_data.Fs;
data_rot = 1;
OutputFormat = [];
DAQ_code = 7;
[New_Ang_Vel] = voma__processeyemovements([],[],[],[],0,data_rot,DAQ_code,OutputFormat,Data_In);

handles.segment.LE_LARP = New_Ang_Vel.LE_Vel_LARP;
handles.segment.LE_RALP = New_Ang_Vel.LE_Vel_RALP;
handles.segment.LE_Z = New_Ang_Vel.LE_Vel_Z;
handles.segment.LE_X = New_Ang_Vel.LE_Vel_X;
handles.segment.LE_Y = New_Ang_Vel.LE_Vel_Y;

handles.segment.RE_LARP = New_Ang_Vel.RE_Vel_LARP;
handles.segment.RE_RALP = New_Ang_Vel.RE_Vel_RALP;
handles.segment.RE_Z = New_Ang_Vel.RE_Vel_Z;
handles.segment.RE_X = New_Ang_Vel.RE_Vel_X;
handles.segment.RE_Y = New_Ang_Vel.RE_Vel_Y;

handles.segment.LE_LARP_NystagCorr = [];
handles.segment.LE_RALP_NystagCorr = [];
handles.segment.LE_Z_NystagCorr = [];
handles.segment.LE_X_NystagCorr = [];
handles.segment.LE_Y_NystagCorr = [];

handles.segment.RE_LARP_NystagCorr = [];
handles.segment.RE_RALP_NystagCorr = [];
handles.segment.RE_Z_NystagCorr = [];
handles.segment.RE_X_NystagCorr = [];
handles.segment.RE_Y_NystagCorr = [];

handles = filterVel(handles);
end

function filterorder_Callback(hObject, eventdata, handles)
% hObject    handle to filterorder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filterorder as text
%        str2double(get(hObject,'String')) returns contents of filterorder as a double
handles = filterVel(handles);
guidata(hObject, handles);
end

function handles = filterVel(handles)
handles.tofilt = str2num(handles.filterorder.String);
if handles.tofilt<1
    handles.tofilt = 1;
    handles.filterorder.String = '1';
end
handles.filtFlag = 1;
handles.segment.filtFlag = 1;

% magL = sqrt((handles.segment.LE_LARP).^2+(handles.segment.LE_RALP).^2+(handles.segment.LE_Z).^2);
% magR = sqrt((handles.segment.RE_LARP).^2+(handles.segment.RE_RALP).^2+(handles.segment.RE_Z).^2);
% mmL = movmax(magL,175);
% mmR = movmax(magR,175);
% segIDBNDS = [];
% for iii = 1:length(handles.segment.stim_inds)
%     segIDBNDS = [segIDBNDS handles.segment.stim_inds(iii):handles.segment.stim_inds(iii)+250];
% end
% ml = mean(mmL(segIDBNDS));
% mr = mean(mmR(segIDBNDS));
% 
% uVFO = unique(handles.PredictFilt.VFO)';
% bnds = [];
% for ii = uVFO
%     ids = handles.PredictFilt.VFO == ii;
%     minv = min([handles.PredictFilt.LEyeV(ids)' handles.PredictFilt.REyeV(ids)' handles.PredictFilt.LEyeV_NystagCorr(ids)' handles.PredictFilt.REyeV_NystagCorr(ids)']);
%     maxv = max([handles.PredictFilt.LEyeV(ids)' handles.PredictFilt.REyeV(ids)' handles.PredictFilt.LEyeV_NystagCorr(ids)' handles.PredictFilt.REyeV_NystagCorr(ids)']);
%     bnds = [bnds [maxv; minv]];
% end
% 
% if mr == 0
%     mlP = find(bnds(1,:)-ml>0);
%     if isempty(mlP)
%         if ml>max(max(bnds))
%             toU = 1;
%         else
%             toU = 19;
%         end
%     else
%         toU = uVFO(min(mlP));
%     end
%     handles.tofilt = toU;
%     handles.filterorder.String = num2str(toU);
% elseif ml == 0
%     mrP = find(bnds(1,:)-mr>0);
%     if isempty(mrP)
%         if ml>max(max(bnds))
%             toU = 1;
%         else
%             toU = 19;
%         end
%     else
%         toU = uVFO(min(mrP));
%     end
%     handles.tofilt = toU;
%     handles.filterorder.String = num2str(toU);
% elseif all([mr ml]>0)
%     mlP = find(bnds(1,:)-ml>0);
%     mrP = find(bnds(1,:)-mr>0);
%     if isempty(mrP) && isempty(mlP)
%         if ml>max(max(bnds))
%             toU = 1;
%         else
%             toU = 19;
%         end
%     else
%         toU = uVFO(min([mlP mrp]));
%     end
%     handles.tofilt = toU;
%     handles.filterorder.String = num2str(toU);
% end



handles.segment.LE_LARP_Filt = filtfilt(ones(1,handles.tofilt)/handles.tofilt,1,handles.segment.LE_LARP);
handles.segment.LE_Z_Filt = filtfilt(ones(1,handles.tofilt)/handles.tofilt,1,handles.segment.LE_Z);
handles.segment.LE_RALP_Filt = filtfilt(ones(1,handles.tofilt)/handles.tofilt,1,handles.segment.LE_RALP);
handles.segment.LE_X_Filt = filtfilt(ones(1,handles.tofilt)/handles.tofilt,1,handles.segment.LE_X);
handles.segment.LE_Y_Filt = filtfilt(ones(1,handles.tofilt)/handles.tofilt,1,handles.segment.LE_Y);
handles.segment.RE_LARP_Filt = filtfilt(ones(1,handles.tofilt)/handles.tofilt,1,handles.segment.RE_LARP);
handles.segment.RE_Z_Filt = filtfilt(ones(1,handles.tofilt)/handles.tofilt,1,handles.segment.RE_Z);
handles.segment.RE_RALP_Filt = filtfilt(ones(1,handles.tofilt)/handles.tofilt,1,handles.segment.RE_RALP);
handles.segment.RE_X_Filt = filtfilt(ones(1,handles.tofilt)/handles.tofilt,1,handles.segment.RE_X);
handles.segment.RE_Y_Filt = filtfilt(ones(1,handles.tofilt)/handles.tofilt,1,handles.segment.RE_Y);
handles = correction(handles);
handles = plotVel(handles);
end

function handles = plotVel(handles)

handles.NystagVChange = 1;

if handles.RegVChange
    ldgLines = [];
    ldgNames = [];
    if isfield(handles.segment,'txt') && ~isempty(handles.segment.txt)
        if isfield(handles.segment.txt,'Color')
            currColor = {handles.segment.txt(:).Color};
            currColorFlag = 1;
        else
            currColorFlag = 0;
        end
    else
        currColorFlag = 0;
    end

    if isfield(handles.segment,'txt')
    if length(handles.segment.stim_inds) ~= length(handles.segment.txt)
        handles.segment = rmfield(handles.segment,'txt');
        currColorFlag = 0;
    end
    end

    cla(handles.axes1)
    if ~isempty(handles.axes1.Legend)
        delete(handles.axes1.Legend)
    end
    set(handles.figure1,'CurrentAxes',handles.axes1)
    hold(handles.axes1,'on')
    switch handles.rawV.Value
        case 1
            if handles.LEye.Value
                a = patchline(handles.segment.t',handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_LARP,'edgecolor',handles.color.l_l,'LineWidth',0.05,'edgealpha',0.5);
                b = patchline(handles.segment.t',handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_RALP,'edgecolor',handles.color.l_r,'LineWidth',0.05,'edgealpha',0.5);
                c = patchline(handles.segment.t',handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_Z,'edgecolor',handles.color.l_z,'LineWidth',0.05,'edgealpha',0.5);
                ldgLines = [ldgLines a b c];
                ldgNames = [ldgNames {'Raw-LE-LARP'} {'Raw-LE-RALP'} {'Raw-LE-Z'}];
            end
            if handles.REye.Value
                a = patchline(handles.segment.t',handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_LARP,'edgecolor',handles.color.r_l,'LineWidth',0.05,'edgealpha',0.5);
                b = patchline(handles.segment.t',handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_RALP,'edgecolor',handles.color.r_r,'LineWidth',0.05,'edgealpha',0.5);
                c = patchline(handles.segment.t',handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_Z,'edgecolor',handles.color.r_z,'LineWidth',0.05,'edgealpha',0.5);
                ldgLines = [ldgLines a b c];
                ldgNames = [ldgNames {'Raw-RE-LARP'} {'Raw-RE-RALP'} {'Raw-RE-Z'}];
            end
            handles.rawV.BackgroundColor = 'g';
        case 0
            handles.rawV.BackgroundColor = [0.94 0.94 0.94];
    end

    if handles.filtFlag
        handles.toUseLELARP = handles.segment.LE_LARP_Filt;
        handles.toUseLERALP = handles.segment.LE_RALP_Filt;
        handles.toUseLEZ = handles.segment.LE_Z_Filt;
        handles.toUseLEX = handles.segment.LE_X_Filt;
        handles.toUseLEY = handles.segment.LE_Y_Filt;
        handles.toUseRELARP = handles.segment.RE_LARP_Filt;
        handles.toUseRERALP = handles.segment.RE_RALP_Filt;
        handles.toUseREZ = handles.segment.RE_Z_Filt;
        handles.toUseREX = handles.segment.RE_X_Filt;
        handles.toUseREY = handles.segment.RE_Y_Filt;

        handles = MagThreshL(handles,[]);
        handles.segment.maxMagL = handles.s.maxMagL;
        handles.segment.MisalignL = handles.s.MisalignL;
        handles.segment.pullIndsL = handles.s.pullIndsL;
        handles.segment.Misalign3DL = handles.s.Misalign3DL;

        handles = MagThreshR(handles,[]);
        handles.segment.maxMagR = handles.s.maxMagR;
        handles.segment.MisalignR = handles.s.MisalignR;
        handles.segment.pullIndsR = handles.s.pullIndsR;
        handles.segment.Misalign3DR = handles.s.Misalign3DR;

        if handles.LEye.Value
            a = plot(handles.axes1,handles.segment.t,handles.segment.LE_LARP_Filt,'Color',handles.color.l_l);
            b = plot(handles.axes1,handles.segment.t,handles.segment.LE_RALP_Filt,'Color',handles.color.l_r);
            c = plot(handles.axes1,handles.segment.t,handles.segment.LE_Z_Filt,'r','Color',handles.color.l_z);
            ldgLines = [ldgLines a b c];
            ldgNames = [ldgNames {'LE-LARP'} {'LE-RALP'} {'LE-Z'}];

            plot(handles.axes1,handles.segment.t(handles.segment.pullIndsL),handles.segment.LE_LARP_Filt(handles.segment.pullIndsL),'k*','MarkerSize',8);
            plot(handles.axes1,handles.segment.t(handles.segment.pullIndsL),handles.segment.LE_RALP_Filt(handles.segment.pullIndsL),'k*','MarkerSize',8);
            plot(handles.axes1,handles.segment.t(handles.segment.pullIndsL),handles.segment.LE_Z_Filt(handles.segment.pullIndsL),'k*','MarkerSize',8);

        end
        if handles.REye.Value
            a = plot(handles.axes1,handles.segment.t,handles.segment.RE_LARP_Filt,'Color',handles.color.r_l);
            b = plot(handles.axes1,handles.segment.t,handles.segment.RE_RALP_Filt,'Color',handles.color.r_r);
            c = plot(handles.axes1,handles.segment.t,handles.segment.RE_Z_Filt,'r','Color',handles.color.r_z);
            ldgLines = [ldgLines a b c];
            ldgNames = [ldgNames {'RE-LARP'} {'RE-RALP'} {'RE-Z'}];

            plot(handles.axes1,handles.segment.t(handles.segment.pullIndsR),handles.segment.RE_LARP_Filt(handles.segment.pullIndsR),'k*','MarkerSize',8);
            plot(handles.axes1,handles.segment.t(handles.segment.pullIndsR),handles.segment.RE_RALP_Filt(handles.segment.pullIndsR),'k*','MarkerSize',8);
            plot(handles.axes1,handles.segment.t(handles.segment.pullIndsR),handles.segment.RE_Z_Filt(handles.segment.pullIndsR),'k*','MarkerSize',8);

        end
    else
        handles.toUseLELARP = handles.segment.LE_LARP;
        handles.toUseLERALP = handles.segment.LE_RALP;
        handles.toUseLEZ = handles.segment.LE_Z;
        handles.toUseLEX = handles.segment.LE_X;
        handles.toUseLEY = handles.segment.LE_Y;
        handles.toUseRELARP = handles.segment.RE_LARP;
        handles.toUseRERALP = handles.segment.RE_RALP;
        handles.toUseREZ = handles.segment.RE_Z;
        handles.toUseREX = handles.segment.RE_X;
        handles.toUseREY = handles.segment.RE_Y;

        handles = MagThreshL(handles,[]);
        handles.segment.maxMagL = handles.s.maxMagL;
        handles.segment.MisalignL = handles.s.MisalignL;
        handles.segment.pullIndsL = handles.s.pullIndsL;
        handles.segment.Misalign3DL = handles.s.Misalign3DL;

        handles = MagThreshR(handles,[]);
        handles.segment.maxMagR = handles.s.maxMagR;
        handles.segment.MisalignR = handles.s.MisalignR;
        handles.segment.pullIndsR = handles.s.pullIndsR;
        handles.segment.Misalign3DR = handles.s.Misalign3DR;

        if handles.LEye.Value
            handles.segment.NystagCorrFlag = 0;
            a = plot(handles.axes1,handles.segment.t,handles.segment.LE_LARP,'Color',handles.color.l_l);
            b = plot(handles.axes1,handles.segment.t,handles.segment.LE_RALP,'Color',handles.color.l_r);
            c = plot(handles.axes1,handles.segment.t,handles.segment.LE_Z,'r','Color',handles.color.l_z);
            ldgLines = [ldgLines a b c];
            ldgNames = [ldgNames {'LE-LARP'} {'LE-RALP'} {'LE-Z'}];

            plot(handles.axes1,handles.segment.t(handles.segment.pullIndsL),handles.segment.LE_LARP(handles.segment.pullIndsL),'k*','MarkerSize',8);
            plot(handles.axes1,handles.segment.t(handles.segment.pullIndsL),handles.segment.LE_RALP(handles.segment.pullIndsL),'k*','MarkerSize',8);
            plot(handles.axes1,handles.segment.t(handles.segment.pullIndsL),handles.segment.LE_Z(handles.segment.pullIndsL),'k*','MarkerSize',8);
        end
        if handles.REye.Value
            a = plot(handles.axes1,handles.segment.t,handles.segment.RE_LARP,'Color',handles.color.r_l);
            b = plot(handles.axes1,handles.segment.t,handles.segment.RE_RALP,'Color',handles.color.r_r);
            c = plot(handles.axes1,handles.segment.t,handles.segment.RE_Z,'r','Color',handles.color.r_z);
            ldgLines = [ldgLines a b c];
            ldgNames = [ldgNames {'RE-LARP'} {'RE-RALP'} {'RE-Z'}];

            plot(handles.axes1,handles.segment.t(handles.segment.pullIndsR),handles.segment.RE_LARP(handles.segment.pullIndsR),'k*','MarkerSize',8);
            plot(handles.axes1,handles.segment.t(handles.segment.pullIndsR),handles.segment.RE_RALP(handles.segment.pullIndsR),'k*','MarkerSize',8);
            plot(handles.axes1,handles.segment.t(handles.segment.pullIndsR),handles.segment.RE_Z(handles.segment.pullIndsR),'k*','MarkerSize',8);
        end

    end

    plot(handles.axes1,handles.segment.stimT,handles.segment.stim,'k');
    plot(handles.axes1,handles.segment.stimT(handles.segment.stim_inds),handles.segment.stim(handles.segment.stim_inds),'m*');
    plot(handles.axes1,repmat(handles.segment.stimT(handles.segment.stim_inds+100),1,2),[-350 350],'k');
    plot(handles.axes1,repmat(handles.segment.stimT(handles.segment.stim_inds+30),1,2),[-350 350],'r--');

    if currColorFlag
        for cycText = 1:length(handles.segment.stim_inds)
            handles.segment.txt(cycText) = text(handles.axes1,handles.segment.stimT(handles.segment.stim_inds(cycText))-.05,40,[num2str(cycText)],'Color',currColor{cycText},'FontSize',10,'HorizontalAlignment','right','FontWeight','bold','Clipping','on');
        end
    else
        for cycText = 1:length(handles.segment.stim_inds)
            handles.segment.txt(cycText) = text(handles.axes1,handles.segment.stimT(handles.segment.stim_inds(cycText))-.05,40,[num2str(cycText)],'Color','Green','FontSize',10,'HorizontalAlignment','right','FontWeight','bold','Clipping','on');
        end
    end
    remaining = 0;
    for recolor = 1:length(handles.segment.txt)
        if any(ismember(handles.cycle_list.Value,recolor))
            handles.segment.txt(recolor).Color = 'Red';
        else
            handles.segment.txt(recolor).Color = 'Green';
            remaining = remaining +1;
        end
    end

    handles.cycles_toSave.String = [num2str(remaining),' Cycles Will Be Saved'];
    handles.axes1.YLim = [-150 150];
    handles.axes1.XLim = [handles.segment.stimT(handles.segment.stim_inds(1))-.5 handles.segment.stimT(handles.segment.stim_inds(4))+.75];
    if any([handles.LEye.Value handles.REye.Value])
        l=legend(handles.axes1,ldgLines,ldgNames);
        l.FontSize = 4;
        l.Position(1) = .38;
        if length(ldgLines) == 3
            l.Position(2) = .635;
        else
            l.Position(2) = .605;
        end
        drawnow
    end
    hold(handles.axes1,'off')
end



if handles.NystagVChange
    ldgLines = [];
    ldgNames = [];
    if isfield(handles.segment,'txt_Nystag') && ~isempty(handles.segment.txt_Nystag)
        if isfield(handles.segment.txt_Nystag,'Color')
            currColorFlag_Nystag = {handles.segment.txt_Nystag(:).Color};
            currColorFlag_Nystag = 1;
        else
            currColorFlag_Nystag = 0;
        end
    else
        currColorFlag_Nystag = 0;
    end

    if isfield(handles.segment,'txt_Nystag')
    if length(handles.segment.stim_inds) ~= length(handles.segment.txt_Nystag)
        handles.segment = rmfield(handles.segment,'txt_Nystag');
        currColorFlag = 0;
    end
    end

    cla(handles.axes4)
    if ~isempty(handles.axes4.Legend)
        delete(handles.axes4.Legend)
    end
    set(handles.figure1,'CurrentAxes',handles.axes4)
    hold(handles.axes4,'on')
    switch handles.rawV.Value
        case 1
            if handles.LEye.Value
                a = patchline(handles.segment.t',handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_LARP,'edgecolor',handles.color.l_l,'LineWidth',0.05,'edgealpha',0.5);
                b = patchline(handles.segment.t',handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_RALP,'edgecolor',handles.color.l_r,'LineWidth',0.05,'edgealpha',0.5);
                c = patchline(handles.segment.t',handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_Z,'edgecolor',handles.color.l_z,'LineWidth',0.05,'edgealpha',0.5);
                ldgLines = [ldgLines a b c];
                ldgNames = [ldgNames {'Raw-LE-LARP'} {'Raw-LE-RALP'} {'Raw-LE-Z'}];
            end
            if handles.REye.Value
                a = patchline(handles.segment.t',handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_LARP,'edgecolor',handles.color.r_l,'LineWidth',0.05,'edgealpha',0.5);
                b = patchline(handles.segment.t',handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_RALP,'edgecolor',handles.color.r_r,'LineWidth',0.05,'edgealpha',0.5);
                c = patchline(handles.segment.t',handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_Z,'edgecolor',handles.color.r_z,'LineWidth',0.05,'edgealpha',0.5);
                ldgLines = [ldgLines a b c];
                ldgNames = [ldgNames {'Raw-RE-LARP'} {'Raw-RE-RALP'} {'Raw-RE-Z'}];
            end
            handles.rawV.BackgroundColor = 'g';
        case 0
            handles.rawV.BackgroundColor = [0.94 0.94 0.94];
    end

    if handles.filtFlag
        handles.toUseLELARP = handles.segment.LE_LARP_NystagCorr_Filt;
        handles.toUseLERALP = handles.segment.LE_RALP_NystagCorr_Filt;
        handles.toUseLEZ = handles.segment.LE_Z_NystagCorr_Filt;
        handles.toUseLEX = handles.segment.LE_X_NystagCorr_Filt;
        handles.toUseLEY = handles.segment.LE_Y_NystagCorr_Filt;
        handles.toUseRELARP = handles.segment.RE_LARP_NystagCorr_Filt;
        handles.toUseRERALP = handles.segment.RE_RALP_NystagCorr_Filt;
        handles.toUseREZ = handles.segment.RE_Z_NystagCorr_Filt;
        handles.toUseREX = handles.segment.RE_X_NystagCorr_Filt;
        handles.toUseREY = handles.segment.RE_Y_NystagCorr_Filt;

        handles = MagThreshL(handles,[]);
        handles.segment.maxMagL_NystagCorr = handles.s.maxMagL;
        handles.segment.MisalignL_NystagCorr = handles.s.MisalignL;
        handles.segment.pullIndsL_NystagCorr = handles.s.pullIndsL;
        handles.segment.Misalign3DL_NystagCorr = handles.s.Misalign3DL;

        handles = MagThreshR(handles,[]);
        handles.segment.maxMagR_NystagCorr = handles.s.maxMagR;
        handles.segment.MisalignR_NystagCorr = handles.s.MisalignR;
        handles.segment.pullIndsR_NystagCorr = handles.s.pullIndsR;
        handles.segment.Misalign3DR_NystagCorr = handles.s.Misalign3DR;

        if handles.LEye.Value
            a = plot(handles.axes4,handles.segment.t,handles.segment.LE_LARP_NystagCorr_Filt,'Color',handles.color.l_l);
            b = plot(handles.axes4,handles.segment.t,handles.segment.LE_RALP_NystagCorr_Filt,'Color',handles.color.l_r);
            c = plot(handles.axes4,handles.segment.t,handles.segment.LE_Z_NystagCorr_Filt,'r','Color',handles.color.l_z);
            ldgLines = [ldgLines a b c];
            ldgNames = [ldgNames {'LE-LARP'} {'LE-RALP'} {'LE-Z'}];

            plot(handles.axes4,handles.segment.t(handles.segment.pullIndsL_NystagCorr),handles.segment.LE_LARP_NystagCorr_Filt(handles.segment.pullIndsL_NystagCorr),'k*','MarkerSize',8);
            plot(handles.axes4,handles.segment.t(handles.segment.pullIndsL_NystagCorr),handles.segment.LE_RALP_NystagCorr_Filt(handles.segment.pullIndsL_NystagCorr),'k*','MarkerSize',8);
            plot(handles.axes4,handles.segment.t(handles.segment.pullIndsL_NystagCorr),handles.segment.LE_Z_NystagCorr_Filt(handles.segment.pullIndsL_NystagCorr),'k*','MarkerSize',8);
        end
        if handles.REye.Value
            a = plot(handles.axes4,handles.segment.t,handles.segment.RE_LARP_NystagCorr_Filt,'Color',handles.color.r_l);
            b = plot(handles.axes4,handles.segment.t,handles.segment.RE_RALP_NystagCorr_Filt,'Color',handles.color.r_r);
            c = plot(handles.axes4,handles.segment.t,handles.segment.RE_Z_NystagCorr_Filt,'r','Color',handles.color.r_z);
            ldgLines = [ldgLines a b c];
            ldgNames = [ldgNames {'RE-LARP'} {'RE-RALP'} {'RE-Z'}];
            plot(handles.axes4,handles.segment.t(handles.segment.pullIndsR_NystagCorr),handles.segment.RE_LARP_NystagCorr_Filt(handles.segment.pullIndsR_NystagCorr),'k*','MarkerSize',8);
            plot(handles.axes4,handles.segment.t(handles.segment.pullIndsR_NystagCorr),handles.segment.RE_RALP_NystagCorr_Filt(handles.segment.pullIndsR_NystagCorr),'k*','MarkerSize',8);
            plot(handles.axes4,handles.segment.t(handles.segment.pullIndsR_NystagCorr),handles.segment.RE_Z_NystagCorr_Filt(handles.segment.pullIndsR_NystagCorr),'k*','MarkerSize',8);
        end
    else
        handles.toUseLELARP = handles.segment.LE_LARP_NystagCorr;
        handles.toUseLERALP = handles.segment.LE_RALP_NystagCorr;
        handles.toUseLEZ = handles.segment.LE_Z_NystagCorr;
        handles.toUseLEX = handles.segment.LE_X_NystagCorr;
        handles.toUseLEY = handles.segment.LE_Y_NystagCorr;
        handles.toUseRELARP = handles.segment.RE_LARP_NystagCorr;
        handles.toUseRERALP = handles.segment.RE_RALP_NystagCorr;
        handles.toUseREZ = handles.segment.RE_Z_NystagCorr;
        handles.toUseREX = handles.segment.RE_X_NystagCorr;
        handles.toUseREY = handles.segment.RE_Y_NystagCorr;

        handles = MagThreshL(handles,[]);
        handles.segment.maxMagL_NystagCorr = handles.s.maxMagL;
        handles.segment.MisalignL_NystagCorr = handles.s.MisalignL;
        handles.segment.pullIndsL_NystagCorr = handles.s.pullIndsL;
        handles.segment.Misalign3DL_NystagCorr = handles.s.Misalign3DL;

        handles = MagThreshR(handles,[]);
        handles.segment.maxMagR_NystagCorr = handles.s.maxMagR;
        handles.segment.MisalignR_NystagCorr = handles.s.MisalignR;
        handles.segment.pullIndsR_NystagCorr = handles.s.pullIndsR;
        handles.segment.Misalign3DR_NystagCorr = handles.s.Misalign3DR;

        if handles.LEye.Value
            a = plot(handles.axes4,handles.segment.t,handles.segment.LE_LARP_NystagCorr,'Color',handles.color.l_l);
            b = plot(handles.axes4,handles.segment.t,handles.segment.LE_RALP_NystagCorr,'Color',handles.color.l_r);
            c = plot(handles.axes4,handles.segment.t,handles.segment.LE_Z_NystagCorr,'r','Color',handles.color.l_z);
            ldgLines = [ldgLines a b c];
            ldgNames = [ldgNames {'LE-LARP'} {'LE-RALP'} {'LE-Z'}];
            plot(handles.axes4,handles.segment.t(handles.segment.pullIndsL_NystagCorr),handles.segment.LE_LARP_NystagCorr(handles.segment.pullIndsL_NystagCorr),'k*','MarkerSize',8);
            plot(handles.axes4,handles.segment.t(handles.segment.pullIndsL_NystagCorr),handles.segment.LE_RALP_NystagCorr(handles.segment.pullIndsL_NystagCorr),'k*','MarkerSize',8);
            plot(handles.axes4,handles.segment.t(handles.segment.pullIndsL_NystagCorr),handles.segment.LE_Z_NystagCorr(handles.segment.pullIndsL_NystagCorr),'k*','MarkerSize',8);
        end
        if handles.REye.Value
            a = plot(handles.axes4,handles.segment.t,handles.segment.RE_LARP_NystagCorr,'Color',handles.color.r_l);
            b = plot(handles.axes4,handles.segment.t,handles.segment.RE_RALP_NystagCorr,'Color',handles.color.r_r);
            c = plot(handles.axes4,handles.segment.t,handles.segment.RE_Z_NystagCorr,'r','Color',handles.color.r_z);
            ldgLines = [ldgLines a b c];
            ldgNames = [ldgNames {'RE-LARP'} {'RE-RALP'} {'RE-Z'}];
            plot(handles.axes4,handles.segment.t(handles.segment.pullIndsR_NystagCorr),handles.segment.RE_LARP_NystagCorr(handles.segment.pullIndsR_NystagCorr),'k*','MarkerSize',8);
            plot(handles.axes4,handles.segment.t(handles.segment.pullIndsR_NystagCorr),handles.segment.RE_RALP_NystagCorr(handles.segment.pullIndsR_NystagCorr),'k*','MarkerSize',8);
            plot(handles.axes4,handles.segment.t(handles.segment.pullIndsR_NystagCorr),handles.segment.RE_Z_NystagCorr(handles.segment.pullIndsR_NystagCorr),'k*','MarkerSize',8);
        end

    end


    plot(handles.axes4,handles.segment.stimT,handles.segment.stim,'k');
    plot(handles.axes4,handles.segment.stimT(handles.segment.stim_inds),handles.segment.stim(handles.segment.stim_inds),'m*');
    plot(handles.axes4,repmat(handles.segment.stimT(handles.segment.stim_inds+100),1,2),[-350 350],'k');
    plot(handles.axes4,repmat(handles.segment.stimT(handles.segment.stim_inds+30),1,2),[-350 350],'r--');

    if currColorFlag_Nystag
        for cycText = 1:length(handles.segment.stim_inds)
            handles.segment.txt_Nystag(cycText) = text(handles.axes4,handles.segment.stimT(handles.segment.stim_inds(cycText))-.05,40,[num2str(cycText)],'Color',currColor{cycText},'FontSize',10,'HorizontalAlignment','right','FontWeight','bold','Clipping','on');
        end
    else
        for cycText = 1:length(handles.segment.stim_inds)
            handles.segment.txt_Nystag(cycText) = text(handles.axes4,handles.segment.stimT(handles.segment.stim_inds(cycText))-.05,40,[num2str(cycText)],'Color','Green','FontSize',10,'HorizontalAlignment','right','FontWeight','bold','Clipping','on');
        end
    end
    remaining = 0;
    for recolor = 1:length(handles.segment.txt_Nystag)
        if any(ismember(handles.cycle_list_Nystag.Value,recolor))
            handles.segment.txt_Nystag(recolor).Color = 'Red';
        else
            handles.segment.txt_Nystag(recolor).Color = 'Green';
            remaining = remaining +1;
        end
    end

    handles.cycles_toSave_Nystag.String = [num2str(remaining),' Cycles Will Be Saved'];
    handles.axes4.YLim = [-150 150];
    handles.axes4.XLim = [handles.segment.stimT(handles.segment.stim_inds(1))-.5 handles.segment.stimT(handles.segment.stim_inds(4))+.75];
    if any([handles.LEye.Value handles.REye.Value])
        l=legend(handles.axes4,ldgLines,ldgNames);
        l.FontSize = 4;
        l.Position(1) = .38;
        if length(ldgLines) == 3
            l.Position(2) = .345;
        else
            l.Position(2) = .32;
        end
        drawnow
    end
    hold(handles.axes4,'off')
end

handles = calc_cyc_avg(handles);
end

function handles = calc_cyc_avg(handles)
if iscell(handles.RootData(handles.segNum).VOMA_data.Fs)
    handles.Results.Fs = handles.RootData(handles.segNum).VOMA_data.Fs{1};
else
    handles.Results.Fs = handles.RootData(handles.segNum).VOMA_data.Fs;
end

if handles.RegVChange
    if handles.PredictCycs == 1
        if handles.LEye.Value && handles.REye.Value
        elseif handles.LEye.Value
%             rm = [];
%             m = handles.segment.maxMagL;
%             m2 = handles.segment.MisalignL;
%             go = 1;
%             passes = 0;
%             while go
%                 ol=abs(m-mean(m,'omitnan'))> 1.5*std(m,'omitnan');
%                 ol2=abs(m2-mean(m2,'omitnan'))> 1.5*std(m2,'omitnan');
%                 rm = [rm find(ol+ol2>0)];
%                 m(rm) = NaN;
%                 m2(rm) = NaN;
%                 passes = passes +1;
%                 if (passes == 2) && (mean(m,'omitnan') > 15)
%                     go = 0;
%                 elseif passes == 3
%                     go = 0;
%                 end
% 
%             end
%             handles.cycle_list.Value = rm;
%             ol = isoutlier(handles.segment.maxMagL,'percentiles',[5 88]);
%             ol2 = isoutlier(handles.segment.MisalignL,'percentiles',[0 85]);
%             mL = mean(handles.segment.maxMagL(~((ol+ol2)>0)));
%             sL = std(handles.segment.maxMagL(~((ol+ol2)>0)));
%             toUse = (ol+ol2)>0;
% %             if sL/mL > 0.11
% %                 nvs = handles.segment.maxMagL;
% %                 nvs((ol+ol2)>0) = NaN;
% %                 ol3 = isoutlier(nvs,'percentiles',[10 90]);
% %                 toUse = (ol+ol2+ol3)>0;
% %             end
%             handles.cycle_list.Value = find(toUse);

        else
        end
%         remaining = 0;
%         for recolor = 1:length(handles.segment.txt)
%             if any(ismember(handles.cycle_list.Value,recolor))
%                 handles.segment.txt(recolor).Color = 'Red';
%             else
%                 handles.segment.txt(recolor).Color = 'Green';
%                 remaining = remaining +1;
%             end
%         end

%         handles.cycles_toSave.String = [num2str(remaining),' Cycles Will Be Saved'];
        handles.PredictCycs = 0;
    end
    handles.cycle_list.UserData = find(~ismember([1:length(handles.segment.txt)],[handles.cycle_list.Value]));
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
    for processing = 1:length(handles.segment.txt)
        if (handles.filtFlag == 0) && (handles.PosfiltFlag == 0)
            if any(ismember(handles.cycle_list.Value,processing))

            else
                l = min(diff(handles.segment.stim_inds));
                bound = [handles.segment.stim_inds(processing):handles.segment.stim_inds(processing)+l-50];
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

            end
        else
            if any(ismember(handles.cycle_list.Value,processing))

            else
                l = min(diff(handles.segment.stim_inds));
                bound = [handles.segment.stim_inds(processing):handles.segment.stim_inds(processing)+l-50];
                if handles.filtFlag
                    handles.Results.ll_cyc = [handles.Results.ll_cyc; handles.segment.LE_LARP_Filt(bound)'];
                    handles.Results.lr_cyc = [handles.Results.lr_cyc; handles.segment.LE_RALP_Filt(bound)'];
                    handles.Results.lz_cyc = [handles.Results.lz_cyc; handles.segment.LE_Z_Filt(bound)'];
                    handles.Results.lx_cyc = [handles.Results.lx_cyc; handles.segment.LE_X_Filt(bound)'];
                    handles.Results.ly_cyc = [handles.Results.ly_cyc; handles.segment.LE_Y_Filt(bound)'];

                    handles.Results.rl_cyc = [handles.Results.rl_cyc; handles.segment.RE_LARP_Filt(bound)'];
                    handles.Results.rr_cyc = [handles.Results.rr_cyc; handles.segment.RE_RALP_Filt(bound)'];
                    handles.Results.rz_cyc = [handles.Results.rz_cyc; handles.segment.RE_Z_Filt(bound)'];
                    handles.Results.rx_cyc = [handles.Results.rx_cyc; handles.segment.RE_X_Filt(bound)'];
                    handles.Results.ry_cyc = [handles.Results.ry_cyc; handles.segment.RE_Y_Filt(bound)'];
                else
                    handles.Results.ll_cyc = [handles.Results.ll_cyc; handles.segment.LE_LARP(bound)'];
                    handles.Results.lr_cyc = [handles.Results.lr_cyc; handles.segment.LE_RALP(bound)'];
                    handles.Results.lz_cyc = [handles.Results.lz_cyc; handles.segment.LE_Z(bound)'];
                    handles.Results.lx_cyc = [handles.Results.lx_cyc; handles.segment.LE_X(bound)'];
                    handles.Results.ly_cyc = [handles.Results.ly_cyc; handles.segment.LE_Y(bound)'];

                    handles.Results.rl_cyc = [handles.Results.rl_cyc; handles.segment.RE_LARP(bound)'];
                    handles.Results.rr_cyc = [handles.Results.rr_cyc; handles.segment.RE_RALP(bound)'];
                    handles.Results.rz_cyc = [handles.Results.rz_cyc; handles.segment.RE_Z(bound)'];
                    handles.Results.rx_cyc = [handles.Results.rx_cyc; handles.segment.RE_X(bound)'];
                    handles.Results.ry_cyc = [handles.Results.ry_cyc; handles.segment.RE_Y(bound)'];
                end
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
end

if handles.NystagVChange
    if handles.PredictCycs_Nystag == 1
        if handles.LEye.Value && handles.REye.Value
        elseif handles.LEye.Value
%             rm = [];
%             m = handles.segment.maxMagL_NystagCorr;
%             m2 = handles.segment.MisalignL_NystagCorr;
%             go = 1;
%             passes = 0;
%             while go
%                 ol=abs(m-mean(m,'omitnan'))> 1.5*std(m,'omitnan');
%                 ol2=abs(m2-mean(m2,'omitnan'))> 1.5*std(m2,'omitnan');
%                 rm = [rm find(ol+ol2>0)];
%                 m(rm) = NaN;
%                 m2(rm) = NaN;
%                 passes = passes +1;
%                 if (passes == 2) && (mean(m,'omitnan') > 15)
%                     go = 0;
%                 elseif passes == 3
%                     go = 0;
%                 end
%             end
%             handles.cycle_list_Nystag.Value = rm;
%             ol = isoutlier(handles.segment.maxMagL_NystagCorr,'percentiles',[5 88]);
%             ol2 = isoutlier(handles.segment.MisalignL_NystagCorr,'percentiles',[0 85]);
%             mL = mean(handles.segment.maxMagL_NystagCorr(~((ol+ol2)>0)));
%             sL = std(handles.segment.maxMagL_NystagCorr(~((ol+ol2)>0)));
%             toUse = (ol+ol2)>0;
% %             if sL/mL > 0.11
% %                 nvs = handles.segment.maxMagL_NystagCorr;
% %                 nvs((ol+ol2)>0) = NaN;
% %                 ol3 = isoutlier(nvs,'percentiles',[7.5 92.5]);
% %                 toUse = (ol+ol2+ol3)>0;
% %             end
%             handles.cycle_list_Nystag.Value = find(toUse);
        else
        end
%         remaining = 0;
%         for recolor = 1:length(handles.segment.txt_Nystag)
%             if any(ismember(handles.cycle_list_Nystag.Value,recolor))
%                 handles.segment.txt_Nystag(recolor).Color = 'Red';
%             else
%                 handles.segment.txt_Nystag(recolor).Color = 'Green';
%                 remaining = remaining +1;
%             end
%         end
% 
%         handles.cycles_toSave_Nystag.String = [num2str(remaining),' Cycles Will Be Saved'];
        handles.PredictCycs_Nystag = 0;
    end
    handles.cycle_list_Nystag.UserData = find(~ismember([1:length(handles.segment.txt_Nystag)],[handles.cycle_list_Nystag.Value]));
    handles.Results.ll_cyc_NystagCorr = [];
    handles.Results.lr_cyc_NystagCorr = [];
    handles.Results.lz_cyc_NystagCorr = [];
    handles.Results.lx_cyc_NystagCorr = [];
    handles.Results.ly_cyc_NystagCorr = [];
    handles.Results.rl_cyc_NystagCorr = [];
    handles.Results.rr_cyc_NystagCorr = [];
    handles.Results.rz_cyc_NystagCorr = [];
    handles.Results.rx_cyc_NystagCorr = [];
    handles.Results.ry_cyc_NystagCorr = [];
    handles.Results.stim_NystagCorr = [];
    for processing = 1:length(handles.segment.txt_Nystag)
        if (handles.filtFlag == 0) && (handles.PosfiltFlag == 0)

        else
            if any(ismember(handles.cycle_list_Nystag.Value,processing))

            else
                l = min(diff(handles.segment.stim_inds));
                bound = [handles.segment.stim_inds(processing):handles.segment.stim_inds(processing)+l-50];
                if handles.filtFlag
                    handles.Results.ll_cyc_NystagCorr = [handles.Results.ll_cyc_NystagCorr; handles.segment.LE_LARP_NystagCorr_Filt(bound)'];
                    handles.Results.lr_cyc_NystagCorr = [handles.Results.lr_cyc_NystagCorr; handles.segment.LE_RALP_NystagCorr_Filt(bound)'];
                    handles.Results.lz_cyc_NystagCorr = [handles.Results.lz_cyc_NystagCorr; handles.segment.LE_Z_NystagCorr_Filt(bound)'];
                    handles.Results.lx_cyc_NystagCorr = [handles.Results.lx_cyc_NystagCorr; handles.segment.LE_X_NystagCorr_Filt(bound)'];
                    handles.Results.ly_cyc_NystagCorr = [handles.Results.ly_cyc_NystagCorr; handles.segment.LE_Y_NystagCorr_Filt(bound)'];

                    handles.Results.rl_cyc_NystagCorr = [handles.Results.rl_cyc_NystagCorr; handles.segment.RE_LARP_NystagCorr_Filt(bound)'];
                    handles.Results.rr_cyc_NystagCorr = [handles.Results.rr_cyc_NystagCorr; handles.segment.RE_RALP_NystagCorr_Filt(bound)'];
                    handles.Results.rz_cyc_NystagCorr = [handles.Results.rz_cyc_NystagCorr; handles.segment.RE_Z_NystagCorr_Filt(bound)'];
                    handles.Results.rx_cyc_NystagCorr = [handles.Results.rx_cyc_NystagCorr; handles.segment.RE_X_NystagCorr_Filt(bound)'];
                    handles.Results.ry_cyc_NystagCorr = [handles.Results.ry_cyc_NystagCorr; handles.segment.RE_Y_NystagCorr_Filt(bound)'];
                else
                    handles.Results.ll_cyc_NystagCorr = [handles.Results.ll_cyc_NystagCorr; handles.segment.LE_LARP_NystagCorr(bound)'];
                    handles.Results.lr_cyc_NystagCorr = [handles.Results.lr_cyc_NystagCorr; handles.segment.LE_RALP_NystagCorr(bound)'];
                    handles.Results.lz_cyc_NystagCorr = [handles.Results.lz_cyc_NystagCorr; handles.segment.LE_Z_NystagCorr(bound)'];
                    handles.Results.lx_cyc_NystagCorr = [handles.Results.lx_cyc_NystagCorr; handles.segment.LE_X_NystagCorr(bound)'];
                    handles.Results.ly_cyc_NystagCorr = [handles.Results.ly_cyc_NystagCorr; handles.segment.LE_Y_NystagCorr(bound)'];

                    handles.Results.rl_cyc_NystagCorr = [handles.Results.rl_cyc_NystagCorr; handles.segment.RE_LARP_NystagCorr(bound)'];
                    handles.Results.rr_cyc_NystagCorr = [handles.Results.rr_cyc_NystagCorr; handles.segment.RE_RALP_NystagCorr(bound)'];
                    handles.Results.rz_cyc_NystagCorr = [handles.Results.rz_cyc_NystagCorr; handles.segment.RE_Z_NystagCorr(bound)'];
                    handles.Results.rx_cyc_NystagCorr = [handles.Results.rx_cyc_NystagCorr; handles.segment.RE_X_NystagCorr(bound)'];
                    handles.Results.ry_cyc_NystagCorr = [handles.Results.ry_cyc_NystagCorr; handles.segment.RE_Y_NystagCorr(bound)'];
                end
                handles.Results.stim_NystagCorr = [handles.Results.stim_NystagCorr; handles.RootData(handles.segNum).VOMA_data.Stim_Trace(bound)];
            end
        end
    end
    handles.Results.ll_cycavg_NystagCorr = mean(handles.Results.ll_cyc_NystagCorr);
    handles.Results.ll_cycstd_NystagCorr = std(handles.Results.ll_cyc_NystagCorr);
    handles.Results.lr_cycavg_NystagCorr = mean(handles.Results.lr_cyc_NystagCorr);
    handles.Results.lr_cycstd_NystagCorr = std(handles.Results.lr_cyc_NystagCorr);
    handles.Results.lz_cycavg_NystagCorr = mean(handles.Results.lz_cyc_NystagCorr);
    handles.Results.lz_cycstd_NystagCorr = std(handles.Results.lz_cyc_NystagCorr);
    handles.Results.lx_cycavg_NystagCorr = mean(handles.Results.lx_cyc_NystagCorr);
    handles.Results.lx_cycstd_NystagCorr = std(handles.Results.lx_cyc_NystagCorr);
    handles.Results.ly_cycavg_NystagCorr = mean(handles.Results.ly_cyc_NystagCorr);
    handles.Results.ly_cycstd_NystagCorr = std(handles.Results.ly_cyc_NystagCorr);
    handles.Results.rl_cycavg_NystagCorr = mean(handles.Results.rl_cyc_NystagCorr);
    handles.Results.rl_cycstd_NystagCorr = std(handles.Results.rl_cyc_NystagCorr);
    handles.Results.rr_cycavg_NystagCorr = mean(handles.Results.rr_cyc_NystagCorr);
    handles.Results.rr_cycstd_NystagCorr = std(handles.Results.rr_cyc_NystagCorr);
    handles.Results.rz_cycavg_NystagCorr = mean(handles.Results.rz_cyc_NystagCorr);
    handles.Results.rz_cycstd_NystagCorr = std(handles.Results.rz_cyc_NystagCorr);
    handles.Results.rx_cycavg_NystagCorr = mean(handles.Results.rx_cyc_NystagCorr);
    handles.Results.rx_cycstd_NystagCorr = std(handles.Results.rx_cyc_NystagCorr);
    handles.Results.ry_cycavg_NystagCorr = mean(handles.Results.ry_cyc_NystagCorr);
    handles.Results.ry_cycstd_NystagCorr = std(handles.Results.ry_cyc_NystagCorr);
end
plot_cyc_avg(handles)
end

function plot_cyc_avg(handles)
lower = [];
upper = [];
if handles.RegVChange
    set(handles.figure1,'CurrentAxes',handles.cycavg)
    lstyle = '-';
    cla(handles.cycavg)
    hold(handles.cycavg,'on')
    cyc2Use = handles.cycle_list.UserData;
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
        
        magsL = [];
        if isfield(handles.segment,'pullIndsL')
            if handles.segNum<= str2num(handles.total_files.String)
                cycLength = length(handles.segment.pullIndsL);
                for qt = 1:cycLength
                    if ~any(qt == handles.cycle_list.Value)
                        x = (handles.segment.pullIndsL(qt)-handles.segment.stim_inds(qt))/handles.Results.Fs;
                        yL = handles.segment.Misalign3DL(qt,1);
                        yR = handles.segment.Misalign3DL(qt,2);
                        yZ = handles.segment.Misalign3DL(qt,3);
                        text(x,yL,num2str(qt),'Color',handles.color.l_l,'Fontsize',14,'Clipping','on')
                        text(x,yR,num2str(qt),'Color',handles.color.l_r,'Fontsize',14,'Clipping','on')
                        text(x,yZ,num2str(qt),'Color',handles.color.l_z,'Fontsize',14,'Clipping','on')
                        text(0.105,handles.rotSign*handles.segment.maxMagL(qt),num2str(qt),'Color','k','Fontsize',14,'Clipping','on')
                        magsL = [magsL handles.rotSign*handles.segment.maxMagL(qt)];
                    end
                end
                handles.avgMag.String = num2str(mean(handles.segment.maxMagL(cyc2Use)));
                handles.avgMis.String = num2str(mean(handles.segment.MisalignL(cyc2Use)));
                handles.magStd.String = num2str(std(handles.segment.maxMagL(cyc2Use)));
                handles.misStd.String = num2str(std(handles.segment.MisalignL(cyc2Use)));
            end
        end
        if ~handles.REye.Value
            lns = isgraphics(handles.cycavg.Children,'line');
            vs=cell2mat({handles.cycavg.Children(lns).YData}');
            upper = max([max(vs(:,1:40)) magsL]);
            lower = min([min(vs(:,1:40)) magsL]);
            text(0.105,lower-30,'L','Color','k','Fontsize',14,'Clipping','on')
        end
    end
    if handles.REye.Value
        p.rl = shadedErrorBar([1:length(handles.Results.rl_cycavg)]/handles.Results.Fs,handles.Results.rl_cycavg,...
            handles.Results.rl_cycstd,'lineprops',{'r-','MarkerFaceColor',handles.color.r_l});
        set(p.rl.edge,'LineWidth',1.5,'color',handles.color.r_l)
        set(p.rl.patch,'facecolor',handles.color.r_l)
        set(p.rl.mainLine,'LineWidth',2.5,'color',handles.color.r_l)
        set(p.rl.edge,'LineStyle',lstyle)
        set(p.rl.mainLine,'LineStyle',lstyle)

        p.rr = shadedErrorBar([1:length(handles.Results.rr_cycavg)]/handles.Results.Fs,handles.Results.rr_cycavg,...
            handles.Results.rr_cycstd,'lineprops',{'r-','MarkerFaceColor',handles.color.r_r});
        set(p.rr.edge,'LineWidth',1.5,'color',handles.color.r_r)
        set(p.rr.patch,'facecolor',handles.color.r_r)
        set(p.rr.mainLine,'LineWidth',2.5,'color',handles.color.r_r)
        set(p.rr.edge,'LineStyle',lstyle)
        set(p.rr.mainLine,'LineStyle',lstyle)

        p.rz = shadedErrorBar([1:length(handles.Results.rz_cycavg)]/handles.Results.Fs,handles.Results.rz_cycavg,...
            handles.Results.rz_cycstd,'lineprops',{'r-','MarkerFaceColor',handles.color.r_z});
        set(p.rz.edge,'LineWidth',1.5,'color',handles.color.r_z)
        set(p.rz.patch,'facecolor',handles.color.r_z)
        set(p.rz.mainLine,'LineWidth',2.5,'color',handles.color.r_z)
        set(p.rz.edge,'LineStyle',lstyle)
        set(p.rz.mainLine,'LineStyle',lstyle)
        
        magsR = [];
        if isfield(handles.segment,'pullIndsR')
            if handles.segNum<= str2num(handles.total_files.String)
                cycLength = length(handles.segment.pullIndsR);
                for qt = 1:cycLength
                    if ~any(qt == handles.cycle_list.Value)
                        x = (handles.segment.pullIndsR(qt)-handles.segment.stim_inds(qt))/handles.Results.Fs;
                        yL = handles.segment.Misalign3DR(qt,1);
                        yR = handles.segment.Misalign3DR(qt,2);
                        yZ = handles.segment.Misalign3DR(qt,3);
                        text(x,yL,num2str(qt),'Color',handles.color.r_l,'Fontsize',14,'Clipping','on')
                        text(x,yR,num2str(qt),'Color',handles.color.r_r,'Fontsize',14,'Clipping','on')
                        text(x,yZ,num2str(qt),'Color',handles.color.r_z,'Fontsize',14,'Clipping','on')
                        text(0.115,handles.rotSign*handles.segment.maxMagR(qt),num2str(qt),'Color','k','Fontsize',14,'Clipping','on')
                        magsR = [magsR handles.rotSign*handles.segment.maxMagR(qt)];
                    end
                end
                handles.avgMagR.String = num2str(mean(handles.segment.maxMagR(cyc2Use)));
                handles.avgMisR.String = num2str(mean(handles.segment.MisalignR(cyc2Use)));
                handles.magStdR.String = num2str(std(handles.segment.maxMagR(cyc2Use)));
                handles.misStdR.String = num2str(std(handles.segment.MisalignR(cyc2Use)));
            end
        end

        if ~handles.LEye.Value
            lns = isgraphics(handles.cycavg.Children,'line');
            vs=cell2mat({handles.cycavg.Children(lns).YData}');
            upper = max([max(vs(:,1:40)) magsR]);
            lower = min([min(vs(:,1:40)) magsR]);
            text(0.115,lower-30,'R','Color','k','Fontsize',14,'Clipping','on')
        end
    end
    if handles.LEye.Value && handles.REye.Value
        lns = isgraphics(handles.cycavg.Children,'line');
        vs=cell2mat({handles.cycavg.Children(lns).YData}');
        upper = max([max(vs(:,1:40)) magsL magsR]);
        lower = min([min(vs(:,1:40)) magsL magsR]);
        text(0.105,lower-30,'L','Color','k','Fontsize',14,'Clipping','on')
        text(0.115,lower-30,'R','Color','k','Fontsize',14,'Clipping','on')
    end
    if isempty(lower)
        lower = 0;
        upper = 0;
    end
    handles.cycavg.YLim = [lower-40 upper+40];
    handles.cycavg.XLim = [0 .12];
    plot([0.1 0.1],[lower-40 upper+40],'Color','k','LineWidt',2.5)
    plot([0.03 0.03],[lower-40 upper+40],'Color','r','LineStyle','--','LineWidt',2.5)
    hold(handles.cycavg,'off')

end

lower = [];
upper = [];
if handles.NystagVChange
    set(handles.figure1,'CurrentAxes',handles.cycavg_Nystag)
    lstyle = '-';
    cla(handles.cycavg_Nystag)
    hold(handles.cycavg_Nystag,'on')
    cyc2Use = handles.cycle_list_Nystag.UserData;
    if handles.LEye.Value
        p.ll = shadedErrorBar([1:length(handles.Results.ll_cycavg_NystagCorr)]/handles.Results.Fs,handles.Results.ll_cycavg_NystagCorr,...
            handles.Results.ll_cycstd_NystagCorr,'lineprops',{'r-','MarkerFaceColor',handles.color.l_l});
        set(p.ll.edge,'LineWidth',1.5,'color',handles.color.l_l)
        set(p.ll.patch,'facecolor',handles.color.l_l)
        set(p.ll.mainLine,'LineWidth',2.5,'color',handles.color.l_l)
        set(p.ll.edge,'LineStyle',lstyle)
        set(p.ll.mainLine,'LineStyle',lstyle)


        p.lr = shadedErrorBar([1:length(handles.Results.lr_cycavg_NystagCorr)]/handles.Results.Fs,handles.Results.lr_cycavg_NystagCorr,...
            handles.Results.lr_cycstd_NystagCorr,'lineprops',{'r-','MarkerFaceColor',handles.color.l_r});
        set(p.lr.edge,'LineWidth',1.5,'color',handles.color.l_r)
        set(p.lr.patch,'facecolor',handles.color.l_r)
        set(p.lr.mainLine,'LineWidth',2.5,'color',handles.color.l_r)
        set(p.lr.edge,'LineStyle',lstyle)
        set(p.lr.mainLine,'LineStyle',lstyle)

        p.lz = shadedErrorBar([1:length(handles.Results.lz_cycavg_NystagCorr)]/handles.Results.Fs,handles.Results.lz_cycavg_NystagCorr,...
            handles.Results.lz_cycstd_NystagCorr,'lineprops',{'r-','MarkerFaceColor',handles.color.l_z});
        set(p.lz.edge,'LineWidth',1.5,'color',handles.color.l_z)
        set(p.lz.patch,'facecolor',handles.color.l_z)
        set(p.lz.mainLine,'LineWidth',2.5,'color',handles.color.l_z)
        set(p.lz.edge,'LineStyle',lstyle)
        set(p.lz.mainLine,'LineStyle',lstyle)
        
        magsL = [];
        if isfield(handles.segment,'pullIndsL_NystagCorr')
            if handles.segNum<= str2num(handles.total_files.String)
                cycLength = length(handles.segment.pullIndsL_NystagCorr);
                for qt = 1:cycLength
                    if ~any(qt == handles.cycle_list_Nystag.Value)
                        x = (handles.segment.pullIndsL_NystagCorr(qt)-handles.segment.stim_inds(qt))/handles.Results.Fs;
                        yL = handles.segment.Misalign3DL_NystagCorr(qt,1);
                        yR = handles.segment.Misalign3DL_NystagCorr(qt,2);
                        yZ = handles.segment.Misalign3DL_NystagCorr(qt,3);
                        text(x,yL,num2str(qt),'Color',handles.color.l_l,'Fontsize',14,'Clipping','on')
                        text(x,yR,num2str(qt),'Color',handles.color.l_r,'Fontsize',14,'Clipping','on')
                        text(x,yZ,num2str(qt),'Color',handles.color.l_z,'Fontsize',14,'Clipping','on')
                        text(0.105,handles.rotSign*handles.segment.maxMagL_NystagCorr(qt),num2str(qt),'Color','black','Fontsize',14,'Clipping','on')
                        magsL = [magsL handles.rotSign*handles.segment.maxMagL_NystagCorr(qt)];
                    end
                end
                handles.avgMag_Nystag.String = num2str(mean(handles.segment.maxMagL_NystagCorr(cyc2Use)));
                handles.avgMis_Nystag.String = num2str(mean(handles.segment.MisalignL_NystagCorr(cyc2Use)));
                handles.magStd_Nystag.String = num2str(std(handles.segment.maxMagL_NystagCorr(cyc2Use)));
                handles.misStd_Nystag.String = num2str(std(handles.segment.MisalignL_NystagCorr(cyc2Use)));
            end
        end

        if ~handles.REye.Value
            lns = isgraphics(handles.cycavg_Nystag.Children,'line');
            vs=cell2mat({handles.cycavg_Nystag.Children(lns).YData}');
            upper = max([max(vs(:,1:40)) magsL]);
            lower = min([min(vs(:,1:40)) magsL]);
            text(0.105,lower-30,'L','Color','k','Fontsize',14,'Clipping','on')
        end
    end

    if handles.REye.Value
        p.rl = shadedErrorBar([1:length(handles.Results.rl_cycavg_NystagCorr)]/handles.Results.Fs,handles.Results.rl_cycavg_NystagCorr,...
            handles.Results.rl_cycstd_NystagCorr,'lineprops',{'r-','MarkerFaceColor',handles.color.r_l});
        set(p.rl.edge,'LineWidth',1.5,'color',handles.color.r_l)
        set(p.rl.patch,'facecolor',handles.color.r_l)
        set(p.rl.mainLine,'LineWidth',2.5,'color',handles.color.r_l)
        set(p.rl.edge,'LineStyle',lstyle)
        set(p.rl.mainLine,'LineStyle',lstyle)

        p.rr = shadedErrorBar([1:length(handles.Results.rr_cycavg_NystagCorr)]/handles.Results.Fs,handles.Results.rr_cycavg_NystagCorr,...
            handles.Results.rr_cycstd_NystagCorr,'lineprops',{'r-','MarkerFaceColor',handles.color.r_r});
        set(p.rr.edge,'LineWidth',1.5,'color',handles.color.r_r)
        set(p.rr.patch,'facecolor',handles.color.r_r)
        set(p.rr.mainLine,'LineWidth',2.5,'color',handles.color.r_r)
        set(p.rr.edge,'LineStyle',lstyle)
        set(p.rr.mainLine,'LineStyle',lstyle)

        p.rz = shadedErrorBar([1:length(handles.Results.rz_cycavg_NystagCorr)]/handles.Results.Fs,handles.Results.rz_cycavg_NystagCorr,...
            handles.Results.rz_cycstd_NystagCorr,'lineprops',{'r-','MarkerFaceColor',handles.color.r_z});
        set(p.rz.edge,'LineWidth',1.5,'color',handles.color.r_z)
        set(p.rz.patch,'facecolor',handles.color.r_z)
        set(p.rz.mainLine,'LineWidth',2.5,'color',handles.color.r_z)
        set(p.rz.edge,'LineStyle',lstyle)
        set(p.rz.mainLine,'LineStyle',lstyle)
        
        magsR = [];
        if isfield(handles.segment,'pullIndsR_NystagCorr')
            if handles.segNum<= str2num(handles.total_files.String)
                cycLength = length(handles.segment.pullIndsR_NystagCorr);
                for qt = 1:cycLength
                    if ~any(qt == handles.cycle_list_Nystag.Value)
                        x = (handles.segment.pullIndsR_NystagCorr(qt)-handles.segment.stim_inds(qt))/handles.Results.Fs;
                        yL = handles.segment.Misalign3DR_NystagCorr(qt,1);
                        yR = handles.segment.Misalign3DR_NystagCorr(qt,2);
                        yZ = handles.segment.Misalign3DR_NystagCorr(qt,3);
                        text(x,yL,num2str(qt),'Color',handles.color.r_l,'Fontsize',14,'Clipping','on')
                        text(x,yR,num2str(qt),'Color',handles.color.r_r,'Fontsize',14,'Clipping','on')
                        text(x,yZ,num2str(qt),'Color',handles.color.r_z,'Fontsize',14,'Clipping','on')
                        text(0.115,handles.rotSign*handles.segment.maxMagR_NystagCorr(qt),num2str(qt),'Color','black','Fontsize',14,'Clipping','on')
                        magsR = [magsR handles.rotSign*handles.segment.maxMagR_NystagCorr(qt)];
                    end
                end
                handles.avgMagR_Nystag.String = num2str(mean(handles.segment.maxMagR_NystagCorr(cyc2Use)));
                handles.avgMisR_Nystag.String = num2str(mean(handles.segment.MisalignR_NystagCorr(cyc2Use)));
                handles.magStdR_Nystag.String = num2str(std(handles.segment.maxMagR_NystagCorr(cyc2Use)));
                handles.misStdR_Nystag.String = num2str(std(handles.segment.MisalignR_NystagCorr(cyc2Use)));
            end
        end
        if ~handles.LEye.Value
            lns = isgraphics(handles.cycavg_Nystag.Children,'line');
            vs=cell2mat({handles.cycavg_Nystag.Children(lns).YData}');
            upper = max([max(vs(:,1:40)) magsR]);
            lower = min([min(vs(:,1:40)) magsR]);
            text(0.115,lower-30,'R','Color','k','Fontsize',14,'Clipping','on')
        end
    end
    if handles.LEye.Value && handles.REye.Value
        lns = isgraphics(handles.cycavg_Nystag.Children,'line');
        vs=cell2mat({handles.cycavg_Nystag.Children(lns).YData}');
        upper = max([max(vs(:,1:40)) magsL magsR]);
        lower = min([min(vs(:,1:40)) magsL magsR]);
        text(0.105,lower-30,'L','Color','k','Fontsize',14,'Clipping','on')
        text(0.115,lower-30,'R','Color','k','Fontsize',14,'Clipping','on')
    end
     if isempty(lower)
        lower = 0;
        upper = 0;
    end
    handles.cycavg_Nystag.YLim = [lower-40 upper+40];
    handles.cycavg_Nystag.XLim = [0 .12];
    plot([0.1 0.1],[lower-40 upper+40],'Color','k','LineWidt',2.5)
    plot([0.03 0.03],[lower-40 upper+40],'Color','r','LineStyle','--','LineWidt',2.5)
    hold(handles.cycavg_Nystag,'off')
end
end

% --- Executes on selection change in cycle_list.
function handles = cycle_list_Callback(hObject, eventdata, handles)
% hObject    handle to cycle_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.cycle_list.Value)
    handles.cycle_list.Value = length(handles.cycle_list.String);
elseif (length(handles.cycle_list.Value) > 1) && any(ismember(handles.cycle_list.Value,length(handles.cycle_list.String)))
    a = (handles.cycle_list.Value ~= length(handles.cycle_list.String));
    handles.cycle_list.Value = handles.cycle_list.Value(a);
end
remaining = 0;
handles.NystagVChange = 0;
for recolor = 1:length(handles.segment.txt)
    if any(ismember(handles.cycle_list.Value,recolor))
        handles.segment.txt(recolor).Color = 'Red';
    else
        handles.segment.txt(recolor).Color = 'Green';
        remaining = remaining +1;
    end
end

handles.cycles_toSave.String = [num2str(remaining),' Cycles Will Be Saved'];
guidata(hObject, handles);
handles = calc_cyc_avg(handles);
 handles.NystagVChange = 1;
guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns cycle_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cycle_list
end

% --- Executes on selection change in cycle_list_Nystag.
function cycle_list_Nystag_Callback(hObject, eventdata, handles)
% hObject    handle to cycle_list_Nystag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.cycle_list_Nystag.Value)
    handles.cycle_list_Nystag.Value = length(handles.cycle_list_Nystag.String);
elseif (length(handles.cycle_list_Nystag.Value) > 1) && any(ismember(handles.cycle_list_Nystag.Value,length(handles.cycle_list_Nystag.String)))
    a = (handles.cycle_list_Nystag.Value ~= length(handles.cycle_list_Nystag.String));
    handles.cycle_list_Nystag.Value = handles.cycle_list_Nystag.Value(a);
end
remaining = 0;
handles.RegVChange = 0;
for recolor = 1:length(handles.segment.txt_Nystag)
    if any(ismember(handles.cycle_list_Nystag.Value,recolor))
        handles.segment.txt_Nystag(recolor).Color = 'Red';
    else
        handles.segment.txt_Nystag(recolor).Color = 'Green';
        remaining = remaining +1;
    end
end

handles.cycles_toSave_Nystag.String = [num2str(remaining),' Cycles Will Be Saved'];
guidata(hObject, handles);
handles = calc_cyc_avg(handles);
handles.RegVChange = 1;
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns cycle_list_Nystag contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cycle_list_Nystag
end

% --- Executes on button press in nystagCorr.
function handles = nystagCorr_Callback(hObject, eventdata, handles)
% hObject    handle to nystagCorr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = plotVel(handles);
% handles = cycle_list_Callback(handles.cycle_list, [], handles);
guidata(hObject, handles);
end

function handles = correction(handles)
        handles.segment.LE_LARP_NystagCorr_Filt = handles.segment.LE_LARP_Filt;
        handles.segment.LE_RALP_NystagCorr_Filt = handles.segment.LE_RALP_Filt;
        handles.segment.LE_Z_NystagCorr_Filt = handles.segment.LE_Z_Filt;
        handles.segment.LE_X_NystagCorr_Filt = handles.segment.LE_X_Filt;
        handles.segment.LE_Y_NystagCorr_Filt = handles.segment.LE_Y_Filt;
        handles.segment.RE_LARP_NystagCorr_Filt = handles.segment.RE_LARP_Filt;
        handles.segment.RE_RALP_NystagCorr_Filt = handles.segment.RE_RALP_Filt;
        handles.segment.RE_Z_NystagCorr_Filt = handles.segment.RE_Z_Filt;
        handles.segment.RE_X_NystagCorr_Filt = handles.segment.RE_X_Filt;
        handles.segment.RE_Y_NystagCorr_Filt = handles.segment.RE_Y_Filt;

        handles.segment.LE_LARP_NystagCorr = handles.segment.LE_LARP;
        handles.segment.LE_RALP_NystagCorr = handles.segment.LE_RALP;
        handles.segment.LE_Z_NystagCorr = handles.segment.LE_Z;
        handles.segment.LE_X_NystagCorr = handles.segment.LE_X;
        handles.segment.LE_Y_NystagCorr = handles.segment.LE_Y;
        handles.segment.RE_LARP_NystagCorr = handles.segment.RE_LARP;
        handles.segment.RE_RALP_NystagCorr = handles.segment.RE_RALP;
        handles.segment.RE_Z_NystagCorr = handles.segment.RE_Z;
        handles.segment.RE_X_NystagCorr = handles.segment.RE_X;
        handles.segment.RE_Y_NystagCorr = handles.segment.RE_Y;
    for i = 1:length(handles.segment.stim_inds)

            ind = handles.segment.stim_inds(i);
            preL = handles.segment.LE_LARP_Filt(ind-101:ind-1);
            preR = handles.segment.LE_RALP_Filt(ind-101:ind-1);
            preZ = handles.segment.LE_Z_Filt(ind-101:ind-1);
            preX = handles.segment.LE_X_Filt(ind-101:ind-1);
            preY = handles.segment.LE_Y_Filt(ind-101:ind-1);
            preRL = handles.segment.RE_LARP_Filt(ind-101:ind-1);
            preRR = handles.segment.RE_RALP_Filt(ind-101:ind-1);
            preRZ = handles.segment.RE_Z_Filt(ind-101:ind-1);
            preRX = handles.segment.RE_X_Filt(ind-101:ind-1);
            preRY = handles.segment.RE_Y_Filt(ind-101:ind-1);

            switch handles.stimCanal
                case 1
                    if handles.rotSign > 0
                        [~,imagL] = max(preL);
                        [~,imagR] = max(preRL);
                    else
                        [~,imagL] = min(preL);
                        [~,imagR] = min(preRL);
                    end
                case 2
                    if handles.rotSign > 0
                        [~,imagL] = max(preR);
                        [~,imagR] = max(preRR);
                    else
                        [~,imagL] = min(preR);
                        [~,imagR] = min(preRR);
                    end
                case 3
                    if handles.rotSign > 0
                        [~,imagL] = max(preZ);
                        [~,imagR] = max(preRZ);
                    else
                        [~,imagL] = min(preZ);
                        [~,imagR] = min(preRZ);
                    end
            end


            if imagL-20 < 1
                bndL = 1:imagL+10;
            else
                bndL = imagL-20:imagL;

            end
            if imagR-20 < 1
                bndR = 1:imagR+10;
            else
                bndR = imagR-20:imagR;
            end
            handles.segment.LE_LARP_NystagCorr_Filt(ind-1:ind+100) = handles.segment.LE_LARP_Filt(ind-1:ind+100)-mean(preL(bndL));
            handles.segment.LE_RALP_NystagCorr_Filt(ind-1:ind+100) = handles.segment.LE_RALP_Filt(ind-1:ind+100)-mean(preR(bndL));
            handles.segment.LE_Z_NystagCorr_Filt(ind-1:ind+100) = handles.segment.LE_Z_Filt(ind-1:ind+100)-mean(preZ(bndL));
            handles.segment.LE_X_NystagCorr_Filt(ind-1:ind+100) = handles.segment.LE_X_Filt(ind-1:ind+100)-mean(preX(bndL));
            handles.segment.LE_Y_NystagCorr_Filt(ind-1:ind+100) = handles.segment.LE_Y_Filt(ind-1:ind+100)-mean(preY(bndL));
            
            handles.segment.RE_LARP_NystagCorr_Filt(ind-1:ind+100) = handles.segment.RE_LARP_Filt(ind-1:ind+100)-mean(preRL(bndR));
            handles.segment.RE_RALP_NystagCorr_Filt(ind-1:ind+100) = handles.segment.RE_RALP_Filt(ind-1:ind+100)-mean(preRR(bndR));
            handles.segment.RE_Z_NystagCorr_Filt(ind-1:ind+100) = handles.segment.RE_Z_Filt(ind-1:ind+100)-mean(preRZ(bndR));
            handles.segment.RE_X_NystagCorr_Filt(ind-1:ind+100) = handles.segment.RE_X_Filt(ind-1:ind+100)-mean(preRX(bndR));
            handles.segment.RE_Y_NystagCorr_Filt(ind-1:ind+100) = handles.segment.RE_Y_Filt(ind-1:ind+100)-mean(preRY(bndR));


            ind = handles.segment.stim_inds(i);
            preL = handles.segment.LE_LARP(ind-101:ind-1);
            preR = handles.segment.LE_RALP(ind-101:ind-1);
            preZ = handles.segment.LE_Z(ind-101:ind-1);
            preX = handles.segment.LE_X(ind-101:ind-1);
            preY = handles.segment.LE_Y(ind-101:ind-1);
            preRL = handles.segment.RE_LARP(ind-101:ind-1);
            preRR = handles.segment.RE_RALP(ind-101:ind-1);
            preRZ = handles.segment.RE_Z(ind-101:ind-1);
            preRX = handles.segment.RE_X(ind-101:ind-1);
            preRY = handles.segment.RE_Y(ind-101:ind-1);

             switch handles.stimCanal
                case 1
                    if handles.rotSign > 0
                        [~,imagL] = max(preL);
                        [~,imagR] = max(preRL);
                    else
                        [~,imagL] = min(preL);
                        [~,imagR] = min(preRL);
                    end
                case 2
                    if handles.rotSign > 0
                        [~,imagL] = max(preR);
                        [~,imagR] = max(preRR);
                    else
                        [~,imagL] = min(preR);
                        [~,imagR] = min(preRR);
                    end
                case 3
                    if handles.rotSign > 0
                        [~,imagL] = max(preZ);
                        [~,imagR] = max(preRZ);
                    else
                        [~,imagL] = min(preZ);
                        [~,imagR] = min(preRZ);
                    end
            end


            if imagL-20 < 1
                bndL = 1:imagL+10;
            else
                bndL = imagL-20:imagL;

            end
            if imagR-20 < 1
                bndR = 1:imagR+10;
            else
                bndR = imagR-20:imagR;
            end
            handles.segment.LE_LARP_NystagCorr(ind-1:ind+100) = handles.segment.LE_LARP(ind-1:ind+100)-mean(preL(bndL));
            handles.segment.LE_RALP_NystagCorr(ind-1:ind+100) = handles.segment.LE_RALP(ind-1:ind+100)-mean(preR(bndL));
            handles.segment.LE_Z_NystagCorr(ind-1:ind+100) = handles.segment.LE_Z(ind-1:ind+100)-mean(preZ(bndL));
            handles.segment.LE_X_NystagCorr(ind-1:ind+100) = handles.segment.LE_X(ind-1:ind+100)-mean(preX(bndL));
            handles.segment.LE_Y_NystagCorr(ind-1:ind+100) = handles.segment.LE_Y(ind-1:ind+100)-mean(preY(bndL));
            
            handles.segment.RE_LARP_NystagCorr(ind-1:ind+100) = handles.segment.RE_LARP(ind-1:ind+100)-mean(preRL(bndR));
            handles.segment.RE_RALP_NystagCorr(ind-1:ind+100) = handles.segment.RE_RALP(ind-1:ind+100)-mean(preRR(bndR));
            handles.segment.RE_Z_NystagCorr(ind-1:ind+100) = handles.segment.RE_Z(ind-1:ind+100)-mean(preRZ(bndR));
            handles.segment.RE_X_NystagCorr(ind-1:ind+100) = handles.segment.RE_X(ind-1:ind+100)-mean(preRX(bndR));
            handles.segment.RE_Y_NystagCorr(ind-1:ind+100) = handles.segment.RE_Y(ind-1:ind+100)-mean(preRY(bndR));
    end
end

% --- Executes on button press in process_file.
function process_file_Callback(hObject, eventdata, handles)
% hObject    handle to process_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
usedInd = handles.cycle_list.UserData;
usedIndN = handles.cycle_list_Nystag.UserData;
%Save Filter and cycle Prediction Values
if handles.LEye.Value && handles.REye.Value
    tt = handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_LARP(1:2200);
    tt2 = handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_RALP(1:2200);
    tt3 = handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_Z(1:2200);
    tt4 = handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_LARP(1:2200);
    tt5 = handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_RALP(1:2200);
    tt6 = handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_Z(1:2200);
    m = movmax([tt tt2 tt3 tt4 tt5 tt6],5);
    m2 = movmax(-[tt tt2 tt3 tt4 tt5 tt6],5);
    handles.PredictFilt.Noise = [handles.PredictFilt.Noise; repmat(mean(mean(m)-mean(-m2)),4,1)];

    handles.PredictFilt.EyeV = [handles.PredictFilt.EyeV; str2num(handles.avgMag_Nystag.String)];
    handles.PredictFilt.EyeV = [handles.PredictFilt.EyeV; str2num(handles.avgMagR_Nystag.String)];
    handles.PredictFilt.EyeV = [handles.PredictFilt.EyeV; str2num(handles.avgMag.String)];
    handles.PredictFilt.EyeV = [handles.PredictFilt.EyeV; str2num(handles.avgMagR.String)];
    
    handles.PredictFilt.VFO = [handles.PredictFilt.VFO; repmat(str2num(handles.filterorder.String),4,1)];
    handles.PredictFilt.PFO = [handles.PredictFilt.PFO; repmat(str2num(handles.posFiltOrder.String),4,1)];
    handles.PredictFilt.PFFL = [handles.PredictFilt.PFFL; repmat(str2num(handles.posFiltLeng.String),4,1)];

    vM = [[handles.PredictCycles.avgMag] mean(handles.segment.maxMagR(usedInd)) mean(handles.segment.maxMagR_NystagCorr(usedIndN)) mean(handles.segment.maxMagL(usedInd)) mean(handles.segment.maxMagL_NystagCorr(usedIndN))];
    [vM,I] = sort(vM);
    vM1 = [[handles.PredictCycles.MaxMag] max(handles.segment.maxMagR(usedInd)) max(handles.segment.maxMagR_NystagCorr(usedIndN)) max(handles.segment.maxMagL(usedInd)) max(handles.segment.maxMagL_NystagCorr(usedIndN))];
    vM2 = [[handles.PredictCycles.MinMag] min(handles.segment.maxMagR(usedInd)) min(handles.segment.maxMagR_NystagCorr(usedIndN)) min(handles.segment.maxMagL(usedInd)) min(handles.segment.maxMagL_NystagCorr(usedIndN))];
    vM1 = vM1(I);
    vM2 = vM2(I);

    mM = [[handles.PredictCycles.avgMis] mean(handles.segment.MisalignR(usedInd)) mean(handles.segment.MisalignR_NystagCorr(usedIndN)) mean(handles.segment.MisalignL(usedInd)) mean(handles.segment.MisalignL_NystagCorr(usedIndN))];
    [mM,I] = sort(mM);
    mM1 = [[handles.PredictCycles.MaxMis] max(handles.segment.MisalignR(usedInd)) max(handles.segment.MisalignR_NystagCorr(usedIndN)) max(handles.segment.MisalignL(usedInd)) max(handles.segment.MisalignL_NystagCorr(usedIndN))];
    mM2 = [[handles.PredictCycles.MinMis] min(handles.segment.MisalignR(usedInd)) min(handles.segment.MisalignR_NystagCorr(usedIndN)) min(handles.segment.MisalignL(usedInd)) min(handles.segment.MisalignL_NystagCorr(usedIndN))];
    mM1 = mM1(I);
    mM2 = mM2(I);

    for iii = 1:length(vM)
        handles.PredictCycles(iii).avgMag = vM(iii);
        handles.PredictCycles(iii).MaxMag = vM1(iii);
        handles.PredictCycles(iii).MinMag = vM2(iii);

        handles.PredictCycles(iii).avgMis = mM(iii);
        handles.PredictCycles(iii).MaxMis = mM1(iii);
        handles.PredictCycles(iii).MinMis = mM2(iii);
    end
elseif handles.LEye.Value
    tt = handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_LARP(1:2200);
    tt2 = handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_RALP(1:2200);
    tt3 = handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_Z(1:2200);
    m = movmax([tt tt2 tt3],5);
    m2 = movmax(-[tt tt2 tt3],5);
    handles.PredictFilt.Noise = [handles.PredictFilt.Noise; repmat(mean(mean(m)-mean(-m2)),2,1)];
    handles.PredictFilt.EyeV = [handles.PredictFilt.EyeV; str2num(handles.avgMag_Nystag.String)];
    handles.PredictFilt.EyeV = [handles.PredictFilt.EyeV; str2num(handles.avgMag.String)];

    handles.PredictFilt.VFO = [handles.PredictFilt.VFO; repmat(str2num(handles.filterorder.String),2,1)];
    handles.PredictFilt.PFO = [handles.PredictFilt.PFO; repmat(str2num(handles.posFiltOrder.String),2,1)];
    handles.PredictFilt.PFFL = [handles.PredictFilt.PFFL; repmat(str2num(handles.posFiltLeng.String),2,1)];
    
    vM = [[handles.PredictCycles.avgMag] mean(handles.segment.maxMagL(usedInd)) mean(handles.segment.maxMagL_NystagCorr(usedIndN))];
    [vM,I] = sort(vM);
    vM1 = [[handles.PredictCycles.MaxMag] max(handles.segment.maxMagL(usedInd)) max(handles.segment.maxMagL_NystagCorr(usedIndN))];
    vM2 = [[handles.PredictCycles.MinMag] min(handles.segment.maxMagL(usedInd)) min(handles.segment.maxMagL_NystagCorr(usedIndN))];
    vM1 = vM1(I);
    vM2 = vM2(I);

    mM = [[handles.PredictCycles.avgMis] mean(handles.segment.MisalignL(usedInd)) mean(handles.segment.MisalignL_NystagCorr(usedIndN))];
    [mM,I] = sort(mM);
    mM1 = [[handles.PredictCycles.MaxMis] max(handles.segment.MisalignL(usedInd)) max(handles.segment.MisalignL_NystagCorr(usedIndN))];
    mM2 = [[handles.PredictCycles.MinMis] min(handles.segment.MisalignL(usedInd)) min(handles.segment.MisalignL_NystagCorr(usedIndN))];
    mM1 = mM1(I);
    mM2 = mM2(I);

    for iii = 1:length(vM)
        handles.PredictCycles(iii).avgMag = vM(iii);
        handles.PredictCycles(iii).MaxMag = vM1(iii);
        handles.PredictCycles(iii).MinMag = vM2(iii);

        handles.PredictCycles(iii).avgMis = mM(iii);
        handles.PredictCycles(iii).MaxMis = mM1(iii);
        handles.PredictCycles(iii).MinMis = mM2(iii);
    end
else
    tt4 = handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_LARP(1:2200);
    tt5 = handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_RALP(1:2200);
    tt6 = handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_Z(1:2200);
    m = movmax([tt4 tt5 tt6],5);
    m2 = movmax(-[tt4 tt5 tt6],5);
    handles.PredictFilt.Noise = [handles.PredictFilt.Noise; repmat(mean(mean(m)-mean(-m2)),2,1)];
    handles.PredictFilt.EyeV = [handles.PredictFilt.EyeV; str2num(handles.avgMagR_Nystag.String)];
    handles.PredictFilt.EyeV = [handles.PredictFilt.EyeV; str2num(handles.avgMagR.String)];

    handles.PredictFilt.VFO = [handles.PredictFilt.VFO; repmat(str2num(handles.filterorder.String),2,1)];
    handles.PredictFilt.PFO = [handles.PredictFilt.PFO; repmat(str2num(handles.posFiltOrder.String),2,1)];
    handles.PredictFilt.PFFL = [handles.PredictFilt.PFFL; repmat(str2num(handles.posFiltLeng.String),2,1)];
    
    vM = [[handles.PredictCycles.avgMag] mean(handles.segment.maxMagR(usedInd)) mean(handles.segment.maxMagR_NystagCorr(usedIndN))];
    [vM,I] = sort(vM);
    vM1 = [[handles.PredictCycles.MaxMag] max(handles.segment.maxMagR(usedInd)) max(handles.segment.maxMagR_NystagCorr(usedIndN))];
    vM2 = [[handles.PredictCycles.MinMag] min(handles.segment.maxMagR(usedInd)) min(handles.segment.maxMagR_NystagCorr(usedIndN))];
    vM1 = vM1(I);
    vM2 = vM2(I);

    mM = [[handles.PredictCycles.avgMis] mean(handles.segment.MisalignR(usedInd)) mean(handles.segment.MisalignR_NystagCorr(usedIndN))];
    [mM,I] = sort(mM);
    mM1 = [[handles.PredictCycles.MaxMis] max(handles.segment.MisalignR(usedInd)) max(handles.segment.MisalignR_NystagCorr(usedIndN))];
    mM2 = [[handles.PredictCycles.MinMis] min(handles.segment.MisalignR(usedInd)) min(handles.segment.MisalignR_NystagCorr(usedIndN))];
    mM1 = mM1(I);
    mM2 = mM2(I);

    for iii = 1:length(vM)
        handles.PredictCycles(iii).avgMag = vM(iii);
        handles.PredictCycles(iii).MaxMag = vM1(iii);
        handles.PredictCycles(iii).MinMag = vM2(iii);

        handles.PredictCycles(iii).avgMis = mM(iii);
        handles.PredictCycles(iii).MaxMis = mM1(iii);
        handles.PredictCycles(iii).MinMis = mM2(iii);
    end
    
end



PredictFilt = handles.PredictFilt;
if isempty(PredictFilt)
    keyboard
    ph = 1;
elseif isempty(PredictFilt.VFO)
    keyboard
    ph = 1;
else
    save([handles.originalGUIPath,'PredictFilt.mat'],'PredictFilt')
end

PredictCycles = handles.PredictCycles;
if isempty(PredictCycles)
    keyboard
    ph = 1;
else
    save([handles.originalGUIPath,'PredictCycles.mat'],'PredictCycles')
end

cycNum = 1;
Results = struct();
Results = handles.Results;
name = strrep(handles.RootData(handles.segNum).name,'.mat','_CycleAvg');
if (handles.filtFlag==1) | (handles.PosfiltFlag==1)
    Results.QPparams = ['filtfilt Order ',handles.filterorder.String];
    Results.QPposParam = [str2num(handles.posFiltOrder.String),str2num(handles.posFiltLeng.String)];

else
    Results.QPparams = [];
    Results.QPposParam = [];
end
Results.name = handles.RootData(handles.segNum).name;
Results.raw_filename =  handles.RootData(handles.segNum).RawFileName;
Results.Parameters = handles.RootData(handles.segNum).VOMA_data.Parameters;
Results.Fs =  handles.RootData(handles.segNum).VOMA_data.Fs;

Results.cyclist = handles.cycle_list.UserData';
Results.cyclist_NystagCorr = handles.cycle_list_Nystag.UserData';
Results.FacialNerve = handles.FacialNerve;
if isfield(handles.RootData(handles.segNum).VOMA_data.Parameters.Stim_Info,'Seg_Directory')
    if iscell(handles.RootData(handles.segNum).VOMA_data.Parameters.Stim_Info.Stim_Type)
        touse = handles.RootData(handles.segNum).VOMA_data.Parameters.Stim_Info.Stim_Type{1};
    else
        touse = handles.RootData(handles.segNum).VOMA_data.Parameters.Stim_Info.Stim_Type;

    end
    if isfolder(handles.RootData(handles.segNum).VOMA_data.Parameters.Stim_Info.Seg_Directory)
        load([handles.RootData(handles.segNum).VOMA_data.Parameters.Stim_Info.Seg_Directory touse])
        if ~isfolder(Data.directory)
            if isempty(handles.RawDataFilesDir)
                handles.RawDataFilesDir = uigetdir(path,'Choose directory of the RAW DATA files');
                Data.directory = handles.RawDataFilesDir;
                save([handles.RootData(handles.segNum).VOMA_data.Parameters.Stim_Info.Seg_Directory touse],'Data')
            else
                Data.directory = handles.RawDataFilesDir;
                save([handles.RootData(handles.segNum).VOMA_data.Parameters.Stim_Info.Seg_Directory touse],'Data')
            end
        end
        Results.segmentData = Data;
    else
        if isempty(handles.SegDataDir)
            handles.SegDataDir = uigetdir(path,'Choose directory of the SEGMENT files');
        end
        for iii = 1:length(handles.RootData)
            handles.RootData(iii).VOMA_data.Parameters.Stim_Info.Seg_Directory = [handles.SegDataDir,'\'];
        end
        Data_QPR = handles.RootData;
        save([handles.vomaPath, handles.vomaFile],'Data_QPR')
        load([handles.RootData(handles.segNum).VOMA_data.Parameters.Stim_Info.Seg_Directory touse])
        if ~isfolder(Data.directory)
            if isempty(handles.RawDataFilesDir)
                handles.RawDataFilesDir = uigetdir(path,'Choose directory of the RAW DATA files');
                Data.directory = handles.RawDataFilesDir;
                save([handles.RootData(handles.segNum).VOMA_data.Parameters.Stim_Info.Seg_Directory touse],'Data')
            else
                                Data.directory = handles.RawDataFilesDir;
                save([handles.RootData(handles.segNum).VOMA_data.Parameters.Stim_Info.Seg_Directory touse],'Data')
            end
        end
        Results.segmentData = Data;
    end
else
    if isempty(handles.SegDataDir)
        handles.SegDataDir = uigetdir(path,'Choose directory of the SEGMENT files');
        if isfile([handles.SegDataDir,'\',Results.name])
            load([handles.SegDataDir,'\',Results.name]);
            Results.segmentData = Data;

        end
    else
        if isfile([handles.SegDataDir,'\',Results.name])
            load([handles.SegDataDir,'\',Results.name]);
            Results.segmentData = Data;
            slashS = find(handles.SegDataDir=='\');
            Results.segmentData.directory = handles.SegDataDir(1:slashS(end));
        end
    end
end
Results.NystagCorr = handles.nystagCorr.Value;

usedInd = handles.cycle_list.UserData;
usedIndN = handles.cycle_list_Nystag.UserData;
if handles.LEye.Value
    Results.allpullIndsL = handles.segment.pullIndsL;
    Results.usedpullIndsL = handles.segment.pullIndsL(usedInd);
    Results.allMisalign3DL = handles.segment.Misalign3DL;
    Results.usedMisalign3DL = handles.segment.Misalign3DL(usedInd,:);
    Results.allMisalignL = handles.segment.MisalignL;
    Results.usedMisalignL = handles.segment.MisalignL(usedInd);
    Results.allmaxMagL = handles.segment.maxMagL;
    Results.usedmaxMagL = handles.segment.maxMagL(usedInd);

    Results.allpullIndsL_NystagCorr = handles.segment.pullIndsL_NystagCorr;
    Results.usedpullIndsL_NystagCorr = handles.segment.pullIndsL_NystagCorr(usedIndN);
    Results.allMisalign3DL_NystagCorr = handles.segment.Misalign3DL_NystagCorr;
    Results.usedMisalign3DL_NystagCorr = handles.segment.Misalign3DL_NystagCorr(usedIndN,:);
    Results.allMisalignL_NystagCorr = handles.segment.MisalignL_NystagCorr;
    Results.usedMisalignL_NystagCorr = handles.segment.MisalignL_NystagCorr(usedIndN);
    Results.allmaxMagL_NystagCorr = handles.segment.maxMagL_NystagCorr;
    Results.usedmaxMagL_NystagCorr = handles.segment.maxMagL_NystagCorr(usedIndN);
else
    Results.allpullIndsL = [];
    Results.usedpullIndsL = [];
    Results.allMisalign3DL = [];
    Results.usedMisalign3DL = [];
    Results.allMisalignL = [];
    Results.usedMisalignL = [];
    Results.allmaxMagL = [];
    Results.usedmaxMagL = [];

    Results.allpullIndsL_NystagCorr = [];
    Results.usedpullIndsL_NystagCorr = [];
    Results.allMisalign3DL_NystagCorr = [];
    Results.usedMisalign3DL_NystagCorr = [];
    Results.allMisalignL_NystagCorr = [];
    Results.usedMisalignL_NystagCorr = [];
    Results.allmaxMagL_NystagCorr = [];
    Results.usedmaxMagL_NystagCorr = [];
end
if handles.REye.Value
    Results.allpullIndsR = handles.segment.pullIndsR;
    Results.usedpullIndsR = handles.segment.pullIndsR(usedInd);
    Results.allMisalign3DR = handles.segment.Misalign3DR;
    Results.usedMisalign3DR = handles.segment.Misalign3DR(usedInd,:);
    Results.allMisalignR = handles.segment.MisalignR;
    Results.usedMisalignR = handles.segment.MisalignR(usedInd);
    Results.allmaxMagR = handles.segment.maxMagR;
    Results.usedmaxMagR = handles.segment.maxMagR(usedInd);

    Results.allpullIndsR_NystagCorr = handles.segment.pullIndsR_NystagCorr;
    Results.usedpullIndsR_NystagCorr = handles.segment.pullIndsR_NystagCorr(usedIndN);
    Results.allMisalign3DR_NystagCorr = handles.segment.Misalign3DR_NystagCorr;
    Results.usedMisalign3DR_NystagCorr = handles.segment.Misalign3DR_NystagCorr(usedIndN,:);
    Results.allMisalignR_NystagCorr = handles.segment.MisalignR_NystagCorr;
    Results.usedMisalignR_NystagCorr = handles.segment.MisalignR_NystagCorr(usedIndN);
    Results.allmaxMagR_NystagCorr = handles.segment.maxMagR_NystagCorr;
    Results.usedmaxMagR_NystagCorr = handles.segment.maxMagR_NystagCorr(usedIndN);
else
    Results.allpullIndsR = [];
    Results.usedpullIndsR = [];
    Results.allMisalign3DR = [];
    Results.usedMisalign3DR = [];
    Results.allMisalignR = [];
    Results.usedMisalignR = [];
    Results.allmaxMagR = [];
    Results.usedmaxMagR = [];

    Results.allpullIndsR_NystagCorr = [];
    Results.usedpullIndsR_NystagCorr = [];
    Results.allMisalign3DR_NystagCorr = [];
    Results.usedMisalign3DR_NystagCorr = [];
    Results.allMisalignR_NystagCorr = [];
    Results.usedMisalignR_NystagCorr = [];
    Results.allmaxMagR_NystagCorr = [];
    Results.usedmaxMagR_NystagCorr = [];
end
Results.stim_inds = handles.segment.stim_inds;
Results.cycNum = usedInd;
Results.cycNum_NystagCorr = usedIndN;

cd(handles.output_path.String)
save([name, '.mat'],'Results')

handles.segNum = handles.segNum+1;
handles.t = [];
guidata(hObject, handles);

if handles.segNum<length(handles.RootData)+1
    handles = nextFile(handles);
else
    cla(handles.angPos)
    cla(handles.axes1)
    cla(handles.axes4)
    cla(handles.cycavg)
    cla(handles.cycavg_Nystag)
end

guidata(hObject, handles);
end

% --- Executes on button press in facial_nerve.
function facial_nerve_Callback(hObject, eventdata, handles)
% hObject    handle to facial_nerve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.FacialNerve
    handles.FacialNerve = 0;
    handles.facial_nerve.BackgroundColor = [0.94 0.94 0.94];
else
    handles.FacialNerve = 1;
    handles.facial_nerve.BackgroundColor = 'Red';
end
guidata(hObject, handles);
end

% --- Executes on button press in redo.
function redo_Callback(hObject, eventdata, handles)
% hObject    handle to redo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.segNum>1
    handles.segNum = handles.segNum-1;
    handles = nextFile(handles);
    guidata(hObject, handles);
end
end

% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.posFiltLeng.String = '3';
handles.posFiltOrder.String = '1';
handles.filterorder.String = '9';
handles.nystagCorr.Value = 0;

handles.segment.PosfiltFlag = 0;
handles.segment.filtFlag = 0;
handles.segment.NystagCorrFlag = 0;
handles.segment.LE_LARP=handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_LARP;
handles.segment.LE_RALP=handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_RALP;
handles.segment.LE_Z=handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_Z;
handles.segment.LE_X=handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_X;
handles.segment.LE_Y=handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_Y;
handles.segment.RE_LARP=handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_LARP;
handles.segment.RE_RALP=handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_RALP;
handles.segment.RE_Z=handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_Z;
handles.segment.RE_X=handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_X;
handles.segment.RE_Y=handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_Y;

handles.segment.LE_LARP_Filt=handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_LARP;
handles.segment.LE_RALP_Filt=handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_RALP;
handles.segment.LE_Z_Filt=handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_Z;
handles.segment.LE_X_Filt=handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_X;
handles.segment.LE_Y_Filt=handles.RootData(handles.segNum).VOMA_data.Data_LE_Vel_Y;
handles.segment.RE_LARP_Filt=handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_LARP;
handles.segment.RE_RALP_Filt=handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_RALP;
handles.segment.RE_Z_Filt=handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_Z;
handles.segment.RE_X_Filt=handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_X;
handles.segment.RE_Y_Filt=handles.RootData(handles.segNum).VOMA_data.Data_RE_Vel_Y;

handles.segment.maxMagL = [];
handles.segment.MisalignL = [];
handles.segment.maxMagL = [];
handles.segment.MisalignL = [];
handles.segment.maxMagR = [];
handles.segment.MisalignR = [];
handles.segment.maxMagR = [];
handles.segment.MisalignR = [];

handles.segment.LE_LARP_NystagCorr=[];
handles.segment.LE_RALP_NystagCorr=[];
handles.segment.LE_Z_NystagCorr=[];
handles.segment.LE_X_NystagCorr=[];
handles.segment.LE_Y_NystagCorr=[];
handles.segment.RE_LARP_NystagCorr=[];
handles.segment.RE_RALP_NystagCorr=[];
handles.segment.RE_Z_NystagCorr=[];
handles.segment.RE_X_NystagCorr=[];
handles.segment.RE_Y_NystagCorr=[];

handles.segment.LE_LARP_NystagCorr_Filt=[];
handles.segment.LE_RALP_NystagCorr_Filt=[];
handles.segment.LE_Z_NystagCorr_Filt=[];
handles.segment.LE_X_NystagCorr_Filt=[];
handles.segment.LE_Y_NystagCorr_Filt=[];
handles.segment.RE_LARP_NystagCorr_Filt=[];
handles.segment.RE_RALP_NystagCorr_Filt=[];
handles.segment.RE_Z_NystagCorr_Filt=[];
handles.segment.RE_X_NystagCorr_Filt=[];
handles.segment.RE_Y_NystagCorr_Filt=[];

handles.segment.maxMagL_NystagCorr = [];
handles.segment.MisalignL_NystagCorr = [];
handles.segment.maxMagL_NystagCorr = [];
handles.segment.MisalignL_NystagCorr = [];
handles.segment.maxMagR_NystagCorr = [];
handles.segment.MisalignR_NystagCorr = [];
handles.segment.maxMagR_NystagCorr = [];
handles.segment.MisalignR_NystagCorr = [];

handles.segment.LEp_X=handles.RootData(handles.segNum).VOMA_data.Data_LE_Pos_X;
handles.segment.LEp_Y=handles.RootData(handles.segNum).VOMA_data.Data_LE_Pos_Y;
handles.segment.LEp_Z=handles.RootData(handles.segNum).VOMA_data.Data_LE_Pos_Z;
handles.segment.REp_X=handles.RootData(handles.segNum).VOMA_data.Data_RE_Pos_X;
handles.segment.REp_Y=handles.RootData(handles.segNum).VOMA_data.Data_RE_Pos_Y;
handles.segment.REp_Z=handles.RootData(handles.segNum).VOMA_data.Data_RE_Pos_Z;

handles.segment.stim=handles.RootData(handles.segNum).VOMA_data.Stim_Trace;
handles.segment.stimT=handles.RootData(handles.segNum).VOMA_data.Stim_t;
handles.segment.t=handles.RootData(handles.segNum).VOMA_data.Eye_t;

guidata(hObject, handles);
handles = filter_Plot_Pos(handles);
guidata(hObject, handles);
end

% --- Executes on button press in rawV.
function rawV_Callback(hObject, eventdata, handles)
% hObject    handle to rawV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = plotVel(handles);
guidata(hObject, handles);
end

% --- Executes on button press in link_x_axis_plots.
function link_x_axis_plots_Callback(hObject, eventdata, handles)
% hObject    handle to link_x_axis_plots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.linkaxisFlag = true;
    linkaxes([handles.axes4,handles.axes1,handles.angPos])
else
    handles.linkaxisFlag = false;
    linkaxes([handles.axes4,handles.axes1,handles.angPos],'off')
end
    handles.axes4.YLim = [-150 150];
    handles.axes4.XLim = [handles.segment.stimT(handles.segment.stim_inds(1))-.5 handles.segment.stimT(handles.segment.stim_inds(4))+.75];
    handles.axes1.YLim = [-150 150];
    handles.axes1.XLim = [handles.segment.stimT(handles.segment.stim_inds(1))-.5 handles.segment.stimT(handles.segment.stim_inds(4))+.75];
% Hint: get(hObject,'Value') returns toggle state of link_x_axis_plots
end

% --- Executes on button press in LEye.
function LEye_Callback(hObject, eventdata, handles)
% hObject    handle to LEye (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~hObject.Value
    handles.avgMag.String = 'NA';
    handles.magStd.String = 'NA';
    handles.avgMis.String = 'NA';
    handles.misStd.String = 'NA';

    handles.avgMag_Nystag.String = 'NA';
    handles.magStd_Nystag.String = 'NA';
    handles.avgMis_Nystag.String = 'NA';
    handles.misStd_Nystag.String = 'NA';
end
handles = filter_Plot_Pos(handles);
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of LEye

end

% --- Executes on button press in REye.
function REye_Callback(hObject, eventdata, handles)
% hObject    handle to REye (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~hObject.Value
    handles.avgMagR.String = 'NA';
    handles.magStdR.String = 'NA';
    handles.avgMisR.String = 'NA';
    handles.misStdR.String = 'NA';

    handles.avgMagR_Nystag.String = 'NA';
    handles.magStdR_Nystag.String = 'NA';
    handles.avgMisR_Nystag.String = 'NA';
    handles.misStdR_Nystag.String = 'NA';
end
handles = filter_Plot_Pos(handles);
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of REye
end

% --- Executes on button press in skip.
function skip_Callback(hObject, eventdata, handles)
% hObject    handle to skip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.segNum = handles.segNum+1;
handles = nextFile(handles);
guidata(hObject, handles);
end

% --- Executes on button press in RearImplant.
function RearImplant_Callback(hObject, eventdata, handles)
% hObject    handle to RearImplant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RearImplant
if handles.LearImplant.Value
    handles.RearImplant.Value = 0;
end
handles.LearImplant.BackgroundColor = [0.94 0.94 0.94];
handles.RearImplant.BackgroundColor = [0.94 0.94 0.94];
guidata(hObject, handles);
end

% --- Executes on button press in LearImplant.
function LearImplant_Callback(hObject, eventdata, handles)
% hObject    handle to LearImplant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LearImplant
if handles.RearImplant.Value
    handles.LearImplant.Value = 0;
end
handles.LearImplant.BackgroundColor = [0.94 0.94 0.94];
handles.RearImplant.BackgroundColor = [0.94 0.94 0.94];
guidata(hObject, handles);
end

% --- Executes on selection change in ecombsList.
function ecombsList_Callback(hObject, eventdata, handles)
% hObject    handle to ecombsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.segNum = handles.ecombsList.Value;
handles = nextFile(handles);
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns ecombsList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ecombsList
end


% --- Executes on button press in updateCycAvgNames.
function updateCycAvgNames_Callback(hObject, eventdata, handles)
% hObject    handle to updateCycAvgNames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.updateCycAvgNames.BackgroundColor = 'y';
drawnow
for ii = 1:length(handles.listing)
    rr = load([handles.listing(ii).folder,'\',handles.listing(ii).name]);
    match1 = find(ismember({handles.RootData.RawFileName},{rr.Results.raw_filename}));
    if ~isempty(match1)
        if ~isequal(handles.VOMANames(match1),{strrep(handles.listing(ii).name,'_CycleAvg.mat','')})
            delete([handles.listing(ii).folder,'\',handles.listing(ii).name]);
            Results = rr.Results;
            Results.name = [handles.VOMANames{match1},'.mat'];
            Results.Parameters.Stim_Info.Stim_Type = [handles.VOMANames{match1},'.mat'];
            Results.segmentData.seg_filename = handles.VOMANames{match1};
            save([handles.listing(ii).folder,'\',handles.VOMANames{match1},'_CycleAvg.mat'],'Results');
        end
    end
end
handles.updateCycAvgNames.BackgroundColor = 'g';
drawnow
pause(0.5);
handles.updateCycAvgNames.BackgroundColor = [0.94 0.94 0.94];
handles = UpdateFileList(handles);

handles = CheckExistingFiles(handles);
guidata(hObject, handles);
end

