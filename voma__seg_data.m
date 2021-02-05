function varargout = voma__seg_data(varargin)
% VOMA__SEG_DATA MATLAB code for voma__seg_data.fig
%      VOMA__SEG_DATA, by itself, creates a new VOMA__SEG_DATA or raises the existing
%      singleton*.
%
%      H = VOMA__SEG_DATA returns the handle to a new VOMA__SEG_DATA or the handle to
%      the existing singleton*.
%
%      VOMA__SEG_DATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VOMA__SEG_DATA.M with the given input arguments.
%
%      VOMA__SEG_DATA('Property','Value',...) creates a new VOMA__SEG_DATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before voma__seg_data_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to voma__seg_data_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
%       The VOMA version of 'seg_data' was adapted from
%       'seg_data_v5'
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help voma__seg_data

% Last Modified by GUIDE v2.5 12-Jul-2019 11:15:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @voma__seg_data_OpeningFcn, ...
    'gui_OutputFcn',  @voma__seg_data_OutputFcn, ...
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

% --- Executes just before voma__seg_data is made visible.
function voma__seg_data_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to voma__seg_data (see VARARGIN)

% Initialize Operating system flag
if ispc
    handles.ispc.flag = true;
    handles.ispc.slash = '\';
else
    handles.ispc.flag = false;
    handles.ispc.slash = '/';
end

% Choose default command line output for voma__seg_data
handles.output = hObject;


% The following from subj_id to stim_intensity will be used to save the
% values entered in the boxes to make the file name
handles.params.subj_id = '';
handles.params.visit_number = '';
handles.params.date = '';
handles.params.exp_type = '';
handles.params.exp_condition = '';
handles.params.function_type = '';
handles.params.stim_axis = '';
handles.params.stim_type = '';
handles.params.stim_frequency = '';
handles.params.stim_intensity = '';
handles.folder_name = '';
handles.params.suffix = '';
handles.exportCond = 0;
handles.timesExported = 0;
handles.whereToStartExp = 1;
handles.load_spread_sheet.BackgroundColor = 'y';
handles.load_spread_sheet.Enable = 'off';

handles.right_extra = 300;
handles.left_extra = 300;

handles.experimentdata = {};
setappdata(handles.export_data,'data',handles.experimentdata);
handles.params.system_code = 1;

handles.params.plot_MPUGyroData = 1;
handles.params.plot_MPUAccelData = 1;
handles.params.plot_IPR_flag = 1;
handles.params.plot_TrigLine = 1;
handles.params.plot_LEData = 1;
handles.params.plot_REData = 1;
handles.prevExportSize = 0;
handles.deletedInds.locs = [];
handles.deletedInds.startInds = [];
handles.rmvInds = 1;
handles.totalSegment = 0;
handles.params.reloadflag = 0;

handles.params.trig_mult = 1;

handles.params.goggleID = 1;

handles.params.vog_data_acq_version = 1;

handles.params.Lasker_param1 = 1;
handles.params.Lasker_param2 = 1;

handles.savedStart = [];
handles.savedEnd = [];

handles.params.threshold_val = '';
handles.params.threshold_plot = '';

handles.Yaxis_MPU_Rot_theta = str2double(get(handles.Yaxis_Rot_Theta,'String'));

handles.params.gpio_trig_opt = 1;

% ARound 2018-04, PJB noticed that the LD VOG system appeared to record the
% PCU trigger LATE relative to the collected eye movement data. PJB, MR,
% and NV performed some experiments outlined here:
% https://docs.google.com/document/d/16EppbHOlsSabjR61xbDi798p7ldrqqTV6tOXjH1KZbI/edit#heading=h.xh2azhw75tvn
% These experiments resulted in the following trigger recording delay in
% samples (where positive values indicate the trigger was recorded AFTER
% the eye movement).
handles.TriggerDelay.G1 = 3;
handles.TriggerDelay.G2 = 5;
handles.TriggerDelay.G3 = 2;

handles.AdjustTrig_flag = false;
handles.AdjustTrig = handles.TriggerDelay.G1;
set(handles.AdjustTrig_Control,'String',num2str(handles.TriggerDelay.G1));


set(handles.LaskerSystPanel,'Visible','Off')

set(handles.mpuoffsetpanel,'Visible','On')
handles.params.upper_trigLev = str2double(get(handles.upper_trigLev,'String'));
handles.params.lower_trigLev = str2double(get(handles.lower_trigLev,'String'));
%[handles] = update_seg_filename(hObject, eventdata, handles);

temp_path = mfilename('fullpath');
temp_pth_ind = [strfind(temp_path,'\') strfind(temp_path,'/')];

if exist([temp_path(1:temp_pth_ind(end)) 'initialize.mat'],'file')
    
    handles.initialize = load([temp_path(1:temp_pth_ind(end)) 'initialize.mat']);
    handles.initializePathName = temp_path(1:temp_pth_ind(end));
    
else
    
    [FileName,PathName,FilterIndex] = uigetfile([temp_path(1:temp_pth_ind(end)) '*.mat'],'Please choose the initialization file containing the information for the experiment parameters.');
    handles.initializePathName = PathName;
    cd(handles.initializePathName)
    handles.initialize = load('initialize.mat');
    
end


handles.initialize = handles.initialize.initialize;
handles.subj_id.String = handles.initialize.ID;
handles.visit_number.String = handles.initialize.visit;
handles.exp_type.String = handles.initialize.expType;
handles.exp_condition.String = handles.initialize.expCond;
handles.stim_axis.String = handles.initialize.stimAxis;
handles.stim_type.String = handles.initialize.stimType;
handles.stim_frequency.String = handles.initialize.stimFreq;
handles.stim_intensity.String = handles.initialize.stimInt;
handles.implant.String = handles.initialize.implant;
handles.eye_rec.String = handles.initialize.eye;
handles.paramvals.initialize = handles.initialize;
setappdata(handles.paramList,'handles',handles.paramvals);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes voma__seg_data wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = voma__seg_data_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


% --- Executes on button press in new_segment.
function [handles] = new_segment_Callback(hObject, eventdata, handles,user_seg_flag)
% hObject    handle to new_segment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% if user_seg_flag

set(handles.save_indicator,'String','UNSAVED')
set(handles.save_indicator,'BackgroundColor','r')

if user_seg_flag
    % Ask user to choose segmentation points
    uiwait(msgbox('Please align the vertical line of the crosshair with the starting point of the stimulus','Segment Eye Movement Data'));
    [x1,y1] = ginput(1);
    uiwait(msgbox('Please align the vertical line of the crosshair with the ending point of the stimulus','Segment Eye Movement Data'));
    [x2,y2] = ginput(1);
    time_cutout_s = [x1 ; x2];
    
    [a1,i_start_eye] = min(abs(handles.Segment.Time_Eye - time_cutout_s(1,1)));
    [a2,i_end_eye] = min(abs(handles.Segment.Time_Eye - time_cutout_s(2,1)));
    
    if isvector(handles.Segment.Time_Stim())
        
        [b1,i_start_stim] = min(abs(handles.Segment.Time_Stim - time_cutout_s(1,1)));
        [b2,i_end_stim] = min(abs(handles.Segment.Time_Stim - time_cutout_s(2,1)));
        
    else
        
        
        [b1,i_start_stim] = min(abs(handles.Segment.Time_Stim(:,1) - time_cutout_s(1,1)));
        [b2,i_end_stim] = min(abs(handles.Segment.Time_Stim(:,1) - time_cutout_s(2,1)));
        
        
    end
    
    handles.i_start_eye = i_start_eye;
    handles.i_end_eye = i_end_eye;
    handles.i_start_stim = i_start_stim;
    handles.i_end_stim = i_end_stim;
    
    handles.Segment.start_t = time_cutout_s(1);
    handles.Segment.end_t = time_cutout_s(2);
else
    i_start_eye = handles.i_start_eye;
    i_end_eye = handles.i_end_eye;
    i_start_stim = handles.i_start_stim;
    i_end_stim = handles.i_end_stim;
    
    time_cutout_s(1) =  handles.Segment.start_t;
    time_cutout_s(2) =  handles.Segment.end_t;
end
%


Segment.segment_code_version = mfilename;
Segment.raw_filename = handles.Segment.raw_filename;
Segment.start_t = time_cutout_s(1);
Segment.end_t = time_cutout_s(2);
Segment.LE_Position_X = handles.Segment.LE_Position_X(i_start_eye:i_end_eye);
Segment.LE_Position_Y = handles.Segment.LE_Position_Y(i_start_eye:i_end_eye);
Segment.LE_Position_Z = handles.Segment.LE_Position_Z(i_start_eye:i_end_eye);

Segment.RE_Position_X = handles.Segment.RE_Position_X(i_start_eye:i_end_eye);
Segment.RE_Position_Y = handles.Segment.RE_Position_Y(i_start_eye:i_end_eye);
Segment.RE_Position_Z = handles.Segment.RE_Position_Z(i_start_eye:i_end_eye);

Segment.LE_Velocity_X = handles.Segment.LE_Velocity_X(i_start_eye:i_end_eye);
Segment.LE_Velocity_Y = handles.Segment.LE_Velocity_Y(i_start_eye:i_end_eye);
Segment.LE_Velocity_LARP = handles.Segment.LE_Velocity_LARP(i_start_eye:i_end_eye);
Segment.LE_Velocity_RALP = handles.Segment.LE_Velocity_RALP(i_start_eye:i_end_eye);
Segment.LE_Velocity_Z = handles.Segment.LE_Velocity_Z(i_start_eye:i_end_eye);

Segment.RE_Velocity_X = handles.Segment.RE_Velocity_X(i_start_eye:i_end_eye);
Segment.RE_Velocity_Y = handles.Segment.RE_Velocity_Y(i_start_eye:i_end_eye);
Segment.RE_Velocity_LARP = handles.Segment.RE_Velocity_LARP(i_start_eye:i_end_eye);
Segment.RE_Velocity_RALP = handles.Segment.RE_Velocity_RALP(i_start_eye:i_end_eye);
Segment.RE_Velocity_Z = handles.Segment.RE_Velocity_Z(i_start_eye:i_end_eye);

Segment.Fs = handles.Segment.Fs;

Segment.Time_Eye = handles.Segment.Time_Eye(i_start_eye:i_end_eye);
if isvector(handles.Segment.Time_Stim) % This is kludge to process either MVI LD VOG files, or PJB Lasker system elec. stime data. This needs to be rewritten
    Segment.Time_Stim = handles.Segment.Time_Stim(i_start_stim:i_end_stim);
else
    Segment.Time_Stim = handles.Segment.Time_Stim(i_start_stim:i_end_stim,:);
end


switch handles.params.system_code
    case 1
        Segment.Stim_Trig = handles.Segment.Stim_Trig(i_start_eye:i_end_eye);
    case 2
        
        if isempty(handles.Segment.Stim_Trig)
            Segment.Stim_Trig = [];
        else
            Segment.Stim_Trig = handles.Segment.Stim_Trig(i_start_stim:i_end_stim);
        end
end

if length(handles.Segment.HeadMPUVel_X)==length(handles.Segment.Stim_Trig)
    Segment.HeadMPUVel_X = handles.Segment.HeadMPUVel_X(i_start_stim:i_end_stim);
    Segment.HeadMPUVel_Y = handles.Segment.HeadMPUVel_Y(i_start_stim:i_end_stim);
    Segment.HeadMPUVel_Z = handles.Segment.HeadMPUVel_Z(i_start_stim:i_end_stim);
    
    Segment.HeadMPUAccel_X = handles.Segment.HeadMPUAccel_X(i_start_stim:i_end_stim);
    Segment.HeadMPUAccel_Y = handles.Segment.HeadMPUAccel_Y(i_start_stim:i_end_stim);
    Segment.HeadMPUAccel_Z = handles.Segment.HeadMPUAccel_Z(i_start_stim:i_end_stim);
else
    Segment.HeadMPUVel_X = interp1(Segment.Time_Eye,handles.Segment.HeadMPUVel_X(i_start_eye:i_end_eye),Segment.Time_Stim,'spline');
    Segment.HeadMPUVel_Y = interp1(Segment.Time_Eye,handles.Segment.HeadMPUVel_Y(i_start_eye:i_end_eye),Segment.Time_Stim,'spline');
    Segment.HeadMPUVel_Z = interp1(Segment.Time_Eye,handles.Segment.HeadMPUVel_Z(i_start_eye:i_end_eye),Segment.Time_Stim,'spline');
    
    Segment.HeadMPUAccel_X = interp1(Segment.Time_Eye,handles.Segment.HeadMPUAccel_X(i_start_eye:i_end_eye),Segment.Time_Stim,'spline');
    Segment.HeadMPUAccel_Y = interp1(Segment.Time_Eye,handles.Segment.HeadMPUAccel_Y(i_start_eye:i_end_eye),Segment.Time_Stim,'spline');
    Segment.HeadMPUAccel_Z = interp1(Segment.Time_Eye,handles.Segment.HeadMPUAccel_Z(i_start_eye:i_end_eye),Segment.Time_Stim,'spline');
end




handles.Segment = Segment;

% Update plots!
keep_plot_limit = false; % We do not want to keep the same plot limits

plot_segment_data(hObject, eventdata, handles,keep_plot_limit)

if ~isfield(handles,'string_addon')
    handles.string_addon='';
end

guidata(hObject,handles)
end


function plot_segment_data(hObject, eventdata, handles,keep_plot_limit)

if keep_plot_limit
    xLimits = get(gca,'XLim');  %# Get the range of the x axis
    yLimits = get(gca,'YLim');  %# Get the range of the y axis
end


% Reset and plot segment
axes(handles.data_plot)

cla reset

hold on


if handles.params.plot_MPUGyroData == 1
    try
        plot(handles.data_plot,handles.Segment.Time_Stim(:,1),handles.Segment.HeadMPUVel_X,'color',[1 0.65 0],'LineStyle',':','DisplayName','MPU-GYRO-X')
        plot(handles.data_plot,handles.Segment.Time_Stim(:,1),handles.Segment.HeadMPUVel_Y,'color',[0.55 0.27 0.07],'LineStyle',':','DisplayName','MPU-GYRO-Y')
        plot(handles.data_plot,handles.Segment.Time_Stim(:,1),handles.Segment.HeadMPUVel_Z,'color','r','LineStyle',':','DisplayName','MPU-GYRO-Z')
        
    catch
        
        plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.HeadMPUVel_X,'color',[1 0.65 0],'LineStyle',':','DisplayName','MPU-GYRO-X')
        plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.HeadMPUVel_Y,'color',[0.55 0.27 0.07],'LineStyle',':','DisplayName','MPU-GYRO-Y')
        plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.HeadMPUVel_Z,'color','r','LineStyle',':','DisplayName','MPU-GYRO-Z')
    end
end

if handles.params.plot_MPUAccelData == 1
    try
        plot(handles.data_plot,handles.Segment.Time_Stim(:,1),handles.Segment.HeadMPUAccel_X,'color',[1 0.65 0],'LineStyle','--','DisplayName','MPU-ACCEL-X')
        plot(handles.data_plot,handles.Segment.Time_Stim(:,1),handles.Segment.HeadMPUAccel_Y,'color',[0.55 0.27 0.07],'LineStyle','--','DisplayName','MPU-ACCEL-Y')
        plot(handles.data_plot,handles.Segment.Time_Stim(:,1),handles.Segment.HeadMPUAccel_Z,'color','r','LineStyle','--','DisplayName','MPU-ACCEL-Z')
    catch
        plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.HeadMPUAccel_X,'color',[1 0.65 0],'LineStyle','--','DisplayName','MPU-ACCEL-X')
        plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.HeadMPUAccel_Y,'color',[0.55 0.27 0.07],'LineStyle','--','DisplayName','MPU-ACCEL-Y')
        plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.HeadMPUAccel_Z,'color','r','LineStyle','--','DisplayName','MPU-ACCEL-Z')
    end
end

if handles.params.plot_TrigLine == 1
    switch handles.params.system_code
        
        case 1 %NOTE: For the LD VOG system, we plot the GPIO line as a function of the EYE time stamps, since the GPIO line is sampled with the eye data
            plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.Stim_Trig*handles.params.trig_mult,'color','k','DisplayName','Stim - Trig')
        case 2
            
            if isempty(handles.Segment.Stim_Trig)
                %                 Stim = [];
            else
                
                if handles.params.plot_IPR_flag == 1
                    plot(handles.data_plot,handles.Segment.Time_Stim(:,1),handles.Segment.Stim_Trig,'color','k','Marker','*','DisplayName','Stim - Trig')
                else
                    Stim = handles.Segment.Time_Stim(:,1);
                    plot(handles.data_plot,Stim,ones(1,length(Stim))*handles.params.trig_mult,'color','k','Marker','*','DisplayName','Stim - Trig')
                end
            end
    end
end

if handles.params.plot_LEData == 1
    plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.LE_Position_X,'color',[255 140 0]/255,'DisplayName','LE-X')
    plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.LE_Position_Y,'color',[128 0 128]/255,'DisplayName','LE-Y')
    plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.LE_Position_Z,'color','r','DisplayName','LE-Z')
end

if handles.params.plot_REData == 1
    plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.RE_Position_X,'color',[255 255 0]/255,'DisplayName','RE-X')
    plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.RE_Position_Y,'color',[138 43 226]/255,'DisplayName','RE-Y')
    plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.RE_Position_Z,'color',[255,0,255]/255,'DisplayName','RE-Z')
end

xlabel('Time [s]')
ylabel('Stimulus Amplitude')

legend('show')

if keep_plot_limit
    set(gca,'XLim',xLimits);
    set(gca,'YLim',yLimits);
end

end

% --- Executes on button press in save_segment.
function [handles]=save_segment_Callback(hObject, eventdata, handles)
% hObject    handle to save_segment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.params.segment_filename = handles.seg_filename.String;
segments = str2num(handles.segment_number.String);

%PJB edit. If the user chooses to segment a file manually BEFORE running
%the 'mechancial auto' segment function, there is no 'foldername' saved in
%the handles. This small piece of code checks and asks the user for a
%folder to save segmented files. Note, we may want to display the 'save'
%folder on the front panel and allow the user to update the save location.
if isempty(getappdata(handles.save_segment,'foldername')) || (numel(getappdata(handles.save_segment,'foldername'))==1 && (getappdata(handles.save_segment,'foldername')==0))
    folder_name = {uigetdir('','Select Directory to Save the Segmented Data')};
    setappdata(handles.save_segment,'foldername',folder_name{1});
    cd(folder_name{1})
else
    
    cd(getappdata(handles.save_segment,'foldername'))
end

Data = handles.Segment;


% Note, there is an error in matlab if the first character of a file name
% is: '-'.
% This can happen if the user decides not to inlcude an input for the
% 'SubjectID' filename input.
if strcmp(handles.params.segment_filename(1),'-')
    uiwait(msgbox('You have attempted to save a file segment which has a filename leading with a ''-'' character. This will cause an error saving the file, so we are adding a ''_'' character infront of the filename.','Segment Eye Movement Data'));
    
    handles.params.segment_filename = ['_' handles.params.segment_filename];
    set(handles.seg_filename,'String',handles.params.segment_filename);
else
end

save([handles.params.segment_filename handles.string_addon '.mat'],'Data')



if ~isfield(handles,'skip_excel_fill_flag')
    
    segments = segments + 1;
    handles.experimentdata = getappdata(handles.export_data,'data');
    set(handles.worksheet_name,'String',[handles.stim_axis.String{handles.stim_axis.Value},'-',handles.visit_number.String{handles.visit_number.Value},'-',handles.date.String,'-',handles.exp_type.String{handles.exp_type.Value}]);
    handles.experimentdata{segments,1} = [handles.seg_filename.String handles.string_addon];
    handles.experimentdata{segments,2} = [handles.date.String(5:6),'/',handles.date.String(7:8),'/',handles.date.String(1:4)];
    handles.experimentdata{segments,3} = handles.subj_id.String{handles.subj_id.Value};
    handles.experimentdata{segments,4} = handles.implant.String{handles.implant.Value};
    handles.experimentdata{segments,5} = handles.eye_rec.String{handles.eye_rec.Value};
    handles.experimentdata{segments,9} = [handles.exp_type.String{handles.exp_type.Value},'-',handles.exp_condition.String{handles.exp_condition.Value},'-',handles.stim_type.String{handles.stim_type.Value}];
    handles.experimentdata{segments,10} = handles.stim_axis.String{handles.stim_axis.Value};
    stim_freq = handles.stim_frequency.String{handles.stim_frequency.Value};
    hs = [find(stim_freq == 'H') find(stim_freq == 'h')];
    stim_freq(hs:end) = [];
    pt = find(stim_freq == 'p');
    stim_freq(pt) = '.';
    handles.experimentdata{segments,12} = str2double(stim_freq);
    stim_int = handles.stim_intensity.String{handles.stim_intensity.Value};
    dps = find(handles.stim_intensity.String{handles.stim_intensity.Value} == 'd');
    stim_int(dps:end) = [];
    handles.experimentdata{segments,13} = str2num(stim_int);
    handles.experimentdata{segments,14} = [];
    handles.experimentdata{segments,15} = [];
    handles.experimentdata{segments,16} = [];
    handles.experimentdata{segments,17} = [];
    setappdata(handles.export_data,'data',handles.experimentdata);
    handles.segment_number.String = num2str(segments);
    set(handles.save_indicator,'String','SAVED!')
    set(handles.save_indicator,'BackgroundColor','g')
    pause(1);
end


guidata(hObject,handles)
end

% --- Executes on button press in load_raw.
function [handles] = load_raw_Callback(hObject, eventdata, handles)
% hObject    handle to load_raw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Prompt user for raw data file

set(handles.save_indicator,'String','UNSAVED')
set(handles.save_indicator,'BackgroundColor','r')

if handles.params.reloadflag == 0
    handles.segment_number.String = '0';
    handles.exp_spread_sheet_name.String = '';
    handles.worksheet_name.String = '';
    handles.experimentdata = {};
    setappdata(handles.export_data,'data','')
    handles.timesExported = 0;
    handles.whereToStartExp = 1;
    
else
    
end

if strcmp(eventdata.Source.String,'Load New Raw Data File')
    handles.params.reloadflag = 0;
end

switch handles.params.system_code
    
    case 1 % Labyrinth Devices 3D VOG
        
        % Check if the user requested to start segmenting a new file, or a
        % 'reload' of the same file.
        if handles.params.reloadflag == 0
            % If requesting a new file, prompt the user to choose the file.
            [FileName,PathName,FilterIndex] = uigetfile('*.txt','Please choose the data file for analysis');
            
            handles.raw_PathName = PathName;
            handles.raw_FileName = FileName;
            
        else
            % If we are reloading a file, don't prompt the user and reset
            % the 'reload' flag.
            FileName = handles.raw_FileName;
            PathName = handles.raw_PathName;
            handles.params.reloadflag = 0;
        end
        
        set(handles.raw_name,'String',FileName);
        
        switch handles.params.vog_data_acq_version
            
            case {1,2}
                HLeftIndex = 40;
                VLeftIndex = 41;
                TLeftIndex = 42;
                HRightIndex = 43;
                VRightIndex = 44;
                TRightIndex = 45;
                
            case {3}
                
                % These are the column indices of the relevant parameters saved to file
                % NOTE! MVI001R019 Pre-Op data was acquired without the GPIO line,
                % and thus all of the data indices are decremented by 1.
                HLeftIndex = 39;
                VLeftIndex = 40;
                TLeftIndex = 41;
                HRightIndex = 42;
                VRightIndex = 43;
                TRightIndex = 44;
            case{4}
                HLeftIndex = 47;
                VLeftIndex = 48;
                TLeftIndex = 49;
                HRightIndex = 50;
                VRightIndex = 51;
                TRightIndex = 52;
                
        end
        % Note we need to be careful with coordinate systems when analyzing
        % the VOG data collected with the Labyrinth Devices VOG system.
        
        % Based on the orientation of the MPU9250 module relative to the
        % patients head, a passive (coordinate system) -150deg rotation is
        % necesary to align the coordinate system of MPU to the coordinate
        % system of the patient's head with the VOG goggles on.
        
        % When the patient is tested with the Automatic Head Impulse Test
        % (aHIT) device, the individual's head is pitched down 20deg to
        % (roughly) align the patient's +LHRH SCC axis with the +Z 'world'
        % axis that the aHIT rotates about. This means we need to apply a
        % (-150deg + -20deg) to orient the +Z axis of the MPU9250 seated in
        % the VOG goggles with the +LHRH axis of SCC ccoordinate system.
        
        % Instead of hardcoding this rotation into this analysis code, we
        % have added a user input for the Y-axis rotation needed to correct
        % the MPU coordinates.
        if handles.params.vog_data_acq_version==4
        else
            phi = handles.Yaxis_MPU_Rot_theta;
            Rotation_Head = [
                cosd(phi) 0   sind(phi);
                0   1   0;
                -sind(phi)    0   cosd(phi)
                ];
        end
        
        
        
        % Load Data
        data = dlmread([handles.raw_PathName handles.raw_FileName],' ',1,0);
        handles.raw_data = data;
        
        % Generate Time_Eye vector
        Time = data(:,2);
        % The time vector recorded by the VOG goggles resets after it
        % reaches a value of 128. We will find those transitions, and
        % correct the time value.
        inds =[1:length(Time)];
        overrun_inds = inds([false ; (diff(Time) < -20)]);
        Time_Eye = Time;
        % Loop over each Time vector reset and add '128' to all data points
        % following each transition.
        if handles.params.vog_data_acq_version==4
        else
            for k =1:length(overrun_inds)
                Time_Eye(overrun_inds(k):end) = Time_Eye(overrun_inds(k):end)+128;
            end
        end
        % Subtract the first time point
        Time_Eye = Time_Eye - Time_Eye(1);
        
        % Generate the time vector for the MPU9250 Data
        Head_Sensor_Latency = 0.047; % From Mehdi Rahman bench tests, the data acquisition of the MPU9250 leads the LD VOG Goggles by 47ms
        if handles.params.vog_data_acq_version == 4
            Head_Sensor_Latency = 0;
        else
            Head_Sensor_Latency = 0.047;
        end
        Time_Stim = Time_Eye - Head_Sensor_Latency;
        
        
        
        % Load raw eye position data in Fick coordinates [degrees]
        Horizontal_LE_Position = data(:,HLeftIndex);
        Vertical_LE_Position = data(:,VLeftIndex);
        Torsion_LE_Position = data(:,TLeftIndex);
        Horizontal_RE_Position = data(:,HRightIndex);
        Vertical_RE_Position = data(:,VRightIndex);
        Torsion_RE_Position = data(:,TRightIndex);
        
        handles.set.mag = zeros(length(Horizontal_LE_Position),1);
        handles.set.mag(find(isnan(Horizontal_LE_Position))) = 3000;
        Horizontal_LE_Position(isnan(Horizontal_LE_Position)) = 0;
        Vertical_LE_Position(isnan(Vertical_LE_Position)) = 0;
        Torsion_LE_Position(isnan(Torsion_LE_Position)) = 0;
        Horizontal_RE_Position(isnan(Horizontal_RE_Position)) = 0;
        Vertical_RE_Position(isnan(Vertical_RE_Position)) = 0;
        Torsion_RE_Position(isnan(Torsion_RE_Position)) = 0;
        
        % We will use PJB's 'processeyemovements' routine to process the RAW
        % position data into 3D angular velocities. Note that this will be
        % an angular velocity calculation with NO filtering.
        
        FieldGains = []; % Input parameter for processing coil signals
        coilzeros = []; % Input parameter for processing coil signals
        ref = 0; % Input parameter for processing rotation vectors
        system_code = 1; % System code, in this case it tells the routine
        % NOT to apply and additional coordinate system trasnformation
        if handles.params.vog_data_acq_version==4
            DAQ_code = 9;
        else
            DAQ_code = 5; % Indicates we are processing Labyrinth Devices VOG Data
        end
        guidata(hObject,handles)
        [EyeVel] = voma__processeyemovements(PathName,FileName,FieldGains,coilzeros,ref,system_code,DAQ_code);
        
        
        switch handles.params.vog_data_acq_version
            
            case {1,2}
                % Index for the VOG GPIO line
                
                switch handles.params.gpio_trig_opt
                    
                    case 1 % The user has chosen to use the hardware trigger from the MVI PCU
                        
                        StimIndex = 35;
                        
                        
                        
                    case 2 % The user has chosen to use the software trigger from the MVI fitting software (toggled by the operator
                        
                        
                        StimIndex = 46;
                        
                end
                
                Stim = data(1:length(Time_Eye),StimIndex);
                
                
                % Check if the user wants to adjust the trigger
                if handles.AdjustTrig_flag
                    
                    
                    
                    if handles.AdjustTrig>0
                        
                        Stim = [Stim(handles.AdjustTrig + 1:end) ; Stim(end)*ones(handles.AdjustTrig,1)];
                        direction = 'Earlier';
                    else
                        
                        Stim = [Stim(1)*ones(abs(handles.AdjustTrig),1) ; Stim(1:end-handles.AdjustTrig) ];
                        
                        direction = 'Later';
                    end
                    
                    
                    handles.string_addon = ['_UpdatedLDVOGTrigger_Shifted' num2str(handles.AdjustTrig) 'Samples' direction '__UpdatedOn' datestr(now,'yyyy-mm-dd')];
                    
                    answer = questdlg('Would you like to save the raw data as a new .txt file?', ...
                        'Save Updated File', ...
                        'Yes','No thank you','No thank you');
                    % Handle response
                    switch answer
                        case 'Yes'
                            data(1:length(Time_Eye),StimIndex) = Stim;
                            
                            dlmwrite([PathName FileName(1:end-4) '_UpdatedLDVOGTrigger_Shifted' num2str(handles.AdjustTrig) 'Samples' direction '__UpdatedOn' datestr(now,'yyyy-mm-dd') '.txt'], data, 'delimiter',' ','precision','%.4f');
                            
                            
                        case 'No thank you'
                            
                    end
                    
                else
                    
                    handles.string_addon = [];
                    
                end
                
            case {3,4}%%%%%
                
                Stim = zeros(1,length(Time_Eye));
                
        end
        
        
        gyroscale = 1;
        
        switch handles.params.vog_data_acq_version
            
            case {1,4}
                accelscale = 1;
                
            case {2,3}
                accelscale = 16384;
        end
        if handles.params.vog_data_acq_version==4
        else
            XvelHeadIndex = 30;
            YvelHeadIndex = 29;
            ZvelHeadIndex = 28;
            
            XaccelHeadIndex = 27;
            YaccelHeadIndex = 26;
            ZaccelHeadIndex = 25;
        end
        
        % We need to correct each gyroscope signal by subtracting the
        % correct device-specifc MPU9250 gyroscope offset. Each offset for
        % each VOG goggle ID was measured by Mehdi Rahman and posted on the
        % Google Doc located here: https://docs.google.com/a/labyrinthdevices.com/document/d/1UlZpovNkwer608aswJWdkLhF0gF-frajAdu1qgMJt9Y/edit?usp=sharing
        switch handles.params.goggleID
            
            case {1}
                XvelHeadOffset = 2.7084;
                YvelHeadOffset = -0.5595;
                ZvelHeadOffset = 0.7228;
                
                
            case {2}
                XvelHeadOffset = 2.3185;
                YvelHeadOffset = -1.5181;
                ZvelHeadOffset = -1.0424;
                
                
            case {3}
                XvelHeadOffset = 1.9796;
                YvelHeadOffset = 0.1524;
                ZvelHeadOffset = -0.5258;
                
            case {4}
                XvelHeadOffset = 0;
                YvelHeadOffset = 0;
                ZvelHeadOffset = 0;
                
        end
        
        set(handles.Xoffset_txt,'String',num2str(XvelHeadOffset))
        set(handles.Yoffset_txt,'String',num2str(YvelHeadOffset))
        set(handles.Zoffset_txt,'String',num2str(ZvelHeadOffset))
        if handles.params.vog_data_acq_version==4
            Data.segment_code_version = mfilename;
            Data.raw_filename = handles.raw_FileName;
            
            dataImp = struct();
            [FileNamePL,PathNamePL,FilterIndexPL] = uigetfile('*.csv',['Please choose the exported Pupil Labs Gaze .csv data file for analysis']);
            answerType = questdlg('What type of recording was this?','Stim Trace','aHIT','eeVOR','aHIT');
            switch answerType
                case 'aHIT'
                    stimType = 0;
                case 'eeVOR'
                    stimType = 1;
            end
            if stimType
                handles.load_raw.BackgroundColor = [1    1    0];
                pause(0.1);
                gazeset1 = importdata([PathNamePL,FileNamePL]);
                indsToUse = length(gazeset1.textdata(2:end,1))-length(data)+1
                pupillabsTime = str2double(gazeset1.textdata(indsToUse+1:end,1))-str2double(gazeset1.textdata(2));
                realFrame = (1/mean(diff(pupillabsTime)));
                dataImp.set.plTime = pupillabsTime;
                handles.load_raw.BackgroundColor = [0.9400    0.9400    0.9400];
                dataImp.set.plInterpTime = 0:1/1100:dataImp.set.plTime(end);
                dataImp.set.shimmerInterpTime = dataImp.set.plInterpTime;
                dataImp.final.shimmerX = zeros(1,length(dataImp.set.shimmerInterpTime));
                dataImp.final.shimmerY = zeros(1,length(dataImp.set.shimmerInterpTime));
                dataImp.final.shimmerZ = zeros(1,length(dataImp.set.shimmerInterpTime));
                dataImp.final.plangZ = interp1(dataImp.set.plTime,EyeVel.LE_Pos_Z,dataImp.set.plInterpTime,'spline');
                dataImp.final.plangY = interp1(dataImp.set.plTime,EyeVel.LE_Pos_Y,dataImp.set.plInterpTime,'spline');
                dataImp.final.plangX = interp1(dataImp.set.plTime,EyeVel.LE_Pos_X,dataImp.set.plInterpTime,'spline');
                
            else
                [FileNameShimmer,PathNameShimmer,FilterIndexShimmer] = uigetfile('*.csv',['Please choose the exported Shimmer .csv data file for analysis of set']);
                handles.load_raw.BackgroundColor = [1    1    0];
                pause(0.1);
                gazeset1 = importdata([PathNamePL,FileNamePL]);
                shimmerset1 = importdata([PathNameShimmer,FileNameShimmer]);
                handles.shimmer.time1 = ((shimmerset1.data(:,1)-shimmerset1.data(1,1))/1000);
                indsToUse = length(gazeset1.textdata(2:end,1))-length(data)+1
                pupillabsTime = str2double(gazeset1.textdata(indsToUse+1:end,1))-str2double(gazeset1.textdata(2));
                realFrame = (1/mean(diff(pupillabsTime)));
                
                
                
                handles.shimmer.gyroX1 = shimmerset1.data(:,3);
                handles.shimmer.gyroY1 = shimmerset1.data(:,4);
                handles.shimmer.gyroZ1 = shimmerset1.data(:,5);
                handles.shimmer.trig = (shimmerset1.data(:,2)-3000)*-1;
                
                
                
                dataImp.set.plTime = pupillabsTime;
                dataImp.set.shimmerTime = handles.shimmer.time1;
                dataImp.set.shimmerTrig = handles.shimmer.trig;
                
                handles.load_raw.BackgroundColor = [0.9400    0.9400    0.9400];
                answer3 = questdlg('Which orientation was the shimmer placed?','Shimmer Orientation','Connector facing up toward the top of the head','Connector facing down toward the neck','Connector facing down toward the neck');
                switch answer3
                    case 'Connector facing down toward the neck'
                        rotationx = rotx(-90);
                        rotationz = rotz(90);
                    case 'Connector facing up toward the top of the head'
                        rotationx = rotx(90);
                        %                 rotationx = [
                        %                     1 0 0;
                        %                     0 cosd(90) -sind(90);
                        %                     0 sind(90) cosd(90);
                        %                     ];
                        rotationz = rotz(-90);
                        %                 rotationz = [
                        %                     cosd(-90) -sind(-90) 0;
                        %                     sind(-90) cosd(-90) 0;
                        %                     0 0 1;
                        %                     ];
                end
                
                rgyroX1 = rotationx'*[handles.shimmer.gyroX1' ; handles.shimmer.gyroY1' ; handles.shimmer.gyroZ1'];
                rgyroZ1 = rotationz'*rgyroX1;
                
                dataImp.set.shimmerX = rgyroZ1(1,:)';
                dataImp.set.shimmerY = rgyroZ1(2,:)';
                dataImp.set.shimmerZ = rgyroZ1(3,:)';
                
                dataImp.set.plInterpTime = 0:1/1100:dataImp.set.plTime(end);
                dataImp.set.shimmerInterpTime = 0:1/1100:dataImp.set.shimmerTime(end);
                
                dataImp.final.plangZ = interp1(dataImp.set.plTime,EyeVel.LE_Pos_Z,dataImp.set.plInterpTime,'spline');
                dataImp.final.plangY = interp1(dataImp.set.plTime,EyeVel.LE_Pos_Y,dataImp.set.plInterpTime,'spline');
                dataImp.final.plangX = interp1(dataImp.set.plTime,EyeVel.LE_Pos_X,dataImp.set.plInterpTime,'spline');
                
                dataImp.final.shimmerX = interp1(dataImp.set.shimmerTime,dataImp.set.shimmerX,dataImp.set.shimmerInterpTime,'spline');
                dataImp.final.shimmerY = interp1(dataImp.set.shimmerTime,dataImp.set.shimmerY,dataImp.set.shimmerInterpTime,'spline');
                dataImp.final.shimmerZ = interp1(dataImp.set.shimmerTime,dataImp.set.shimmerZ,dataImp.set.shimmerInterpTime,'spline');
                
                
                
                
                
                trace = handles.set.mag;
                
                
                %         mask = zeros(length(trace),1);
                %
                %         window = 500;
                %         b = (1/window)*ones(1,window);
                %         a = 1;
                %         x = filter(b,a,dataImp.set.mag);
                %         threshPTx = find(abs(gradient(x)<0.02));
                %         xVal =  round(mean(x(threshPTx)));
                %
                %
                %         saved_thresh = xVal+40;
                %
                %         mask(trace > saved_thresh) = ones(length(find(trace > saved_thresh)),1); % All of the indicies where the magnitudes is greater than 20 will be changed from zero to 1
                %         mask = (mask)*3000;
                
                
                dataImp.set.plInterpTrig = interp1(dataImp.set.plTime,trace,dataImp.set.plInterpTime);
                dataImp.set.shimmerInterpTrig = interp1(dataImp.set.shimmerTime,handles.shimmer.trig,dataImp.set.shimmerInterpTime);
                
                
                dataImp.set.plInterpTrig(dataImp.set.plInterpTrig>0) = 300;
                dataImp.set.shimmerInterpTrig(dataImp.set.shimmerInterpTrig>0) = 300;
                
                inds_pl = [1:length(dataImp.set.plInterpTrig)];
                inds_shimmer = [1:length(dataImp.set.shimmerInterpTrig)];
                
                onset_inds_pl = inds_pl([false ; diff(dataImp.set.plInterpTrig')>0]);
                onset_inds_shimmer = inds_shimmer([false ; diff(dataImp.set.shimmerInterpTrig')>0]);
                
                end_inds_pl = inds_pl([false ; diff(dataImp.set.plInterpTrig')<0]);
                end_inds_shimmer = inds_shimmer([false ; diff(dataImp.set.shimmerInterpTrig')<0]);
                
                if length(onset_inds_pl) ~= length(end_inds_pl)
                    if length(onset_inds_pl)>length(end_inds_pl)
                        onset_inds_pl(end) = [];
                    else
                        end_inds_pl(1) = [];
                    end
                end
                
                spacing = diff(end_inds_shimmer);
                indstoDel = []
                spacing(spacing>10000)=2500;
                indstoDel = [indstoDel find(spacing<1750)];
                indstoDel = [indstoDel find(spacing>3000)];
                if length(indstoDel)>0
                    indstoDel = sort(indstoDel,'descend')
                    for its = 1:length(indstoDel)
                        if spacing(indstoDel(its))<1750
                            end_inds_shimmer(indstoDel(its)) = [];
                            onset_inds_shimmer(indstoDel(its)) = [];
                        elseif spacing(indstoDel(its))>2500
                            end_inds_shimmer(indstoDel(its)+1) = [];
                            onset_inds_shimmer(indstoDel(its)+1) = [];
                        end
                    end
                end
                
                thresh = mean(end_inds_shimmer-onset_inds_shimmer)-100;
                
                final_inds_pl = find((end_inds_pl-onset_inds_pl)>(thresh));
                final_inds_shimmer = find((end_inds_shimmer-onset_inds_shimmer)>(thresh));
                
                onset_inds_final_pl= onset_inds_pl(final_inds_pl);
                onset_inds_final_shimmer= onset_inds_shimmer(final_inds_shimmer);
                
                end_inds_final_pl = end_inds_pl(final_inds_pl);
                end_inds_final_shimmer = end_inds_shimmer(final_inds_shimmer);
                
                if length(onset_inds_final_shimmer)>20
                    d = ([false diff(onset_inds_final_shimmer)]);
                    if d(11)<100000
                        onset_inds_final_shimmer(11)=[];
                        end_inds_final_shimmer(11)=[];
                    end
                end
                
                dif = dataImp.set.shimmerInterpTime(onset_inds_final_shimmer(1))- dataImp.set.plInterpTime(onset_inds_final_pl(1));
                
                dataImp.set.NewplInterpTime = dataImp.set.plInterpTime+dif;
                
                a=find(([false ; diff(onset_inds_final_shimmer')])>100000);
                b=find(([diff(end_inds_final_shimmer') ; false])>100000);
                lower = end_inds_final_shimmer(b);
                upper = onset_inds_final_shimmer(a);
                
                [va,l] = min(abs(dataImp.set.NewplInterpTime-dataImp.set.shimmerInterpTime(lower)));
                [vb,u] = min(abs(dataImp.set.shimmerInterpTime(upper)-dataImp.set.NewplInterpTime));
                
                onset_inds_final_pl(onset_inds_final_pl<(u-5000) & onset_inds_final_pl>(l+5000)) = [];
                end_inds_final_pl(end_inds_final_pl<(u-5000) & end_inds_final_pl>(l+5000)) = [];
                
                dataImp.set.plInterpTrig(l+5000:u-5000) = 0;
                
                shSecond = find(diff(onset_inds_final_shimmer)>10000)+1;
                plSecond = find(diff(onset_inds_final_pl)>10000)+1;
                firstTime = dataImp.set.plInterpTime;
                secondTime = dataImp.set.plInterpTime;
                difFirst = dataImp.set.shimmerInterpTime(onset_inds_final_shimmer(1))- dataImp.set.plInterpTime(onset_inds_final_pl(1));
                difSecond = dataImp.set.shimmerInterpTime(onset_inds_final_shimmer(shSecond))- dataImp.set.plInterpTime(onset_inds_final_pl(plSecond));
                firstTime = firstTime+difFirst;
                secondTime = secondTime+difSecond;
                if length(1:shSecond-1)>length(1:plSecond-1)
                    ptDif = length(1:shSecond-1)-length(1:plSecond-1)
                    offFirst = dataImp.set.shimmerInterpTime(onset_inds_final_shimmer(1:shSecond-1-ptDif))-firstTime(onset_inds_final_pl(1:plSecond-1))
                elseif length(1:shSecond-1)<length(1:plSecond-1)
                    ptDif = abs(length(1:shSecond-1)-length(1:plSecond-1));
                    offFirst = dataImp.set.shimmerInterpTime(onset_inds_final_shimmer(1:shSecond-1))-firstTime(onset_inds_final_pl(1:plSecond-1-ptDif))
                else
                    offFirst = dataImp.set.shimmerInterpTime(onset_inds_final_shimmer(1:shSecond-1))-firstTime(onset_inds_final_pl(1:plSecond-1))
                end
                
                if length(onset_inds_final_shimmer(shSecond:end))>length(onset_inds_final_pl(plSecond:end))
                    ptDif = length(onset_inds_final_shimmer(shSecond:end))-length(onset_inds_final_pl(plSecond:end))
                    offSecond = dataImp.set.shimmerInterpTime(onset_inds_final_shimmer(shSecond:end-ptDif))-secondTime(onset_inds_final_pl(plSecond:end))
                elseif length(onset_inds_final_shimmer(shSecond:end))<length(onset_inds_final_pl(plSecond:end))
                    ptDif = abs(length(onset_inds_final_shimmer(shSecond:end))-length(onset_inds_final_pl(plSecond:end)));
                    offSecond = dataImp.set.shimmerInterpTime(onset_inds_final_shimmer(shSecond:end))-secondTime(onset_inds_final_pl(plSecond:end-ptDif))
                else
                    offSecond = dataImp.set.shimmerInterpTime(onset_inds_final_shimmer(shSecond:end))-secondTime(onset_inds_final_pl(plSecond:end))
                end
                
                
                if mean(abs(offFirst))>mean(abs(offSecond))
                    dif = dataImp.set.shimmerInterpTime(onset_inds_final_shimmer(shSecond))- dataImp.set.plInterpTime(onset_inds_final_pl(plSecond));
                else
                    dif = dataImp.set.shimmerInterpTime(onset_inds_final_shimmer(1))- dataImp.set.plInterpTime(onset_inds_final_pl(1));
                end
                
                dataImp.set.NewplInterpTime = dataImp.set.plInterpTime+dif;
                
                if length(onset_inds_final_pl) ~= length(onset_inds_final_shimmer)
                    
                    go = 1;
                    ind = 1;
                    while go
                        if length(onset_inds_final_pl) ~= length(onset_inds_final_shimmer)
                            if ind==min([length(onset_inds_final_pl) length(onset_inds_final_shimmer)])
                                if ind==length(onset_inds_final_pl)
                                    onset_inds_final_shimmer(ind+1) = [];
                                    end_inds_final_shimmer(ind+1) = [];
                                    go = 0;
                                else
                                    onset_inds_final_pl(ind+1) = [];
                                    end_inds_final_pl(ind+1) = [];
                                    go = 0;
                                end
                            elseif (abs(dataImp.set.NewplInterpTime(onset_inds_final_pl(ind))-dataImp.set.shimmerInterpTime(onset_inds_final_shimmer(ind)))>0.03)
                                if dataImp.set.NewplInterpTime(onset_inds_final_pl(ind))-dataImp.set.shimmerInterpTime(onset_inds_final_shimmer(ind))<0
                                    onset_inds_final_pl(ind) = [];
                                    end_inds_final_pl(ind) = [];
                                    ind = ind -1;
                                else
                                    onset_inds_final_shimmer(ind) = [];
                                    end_inds_final_shimmer(ind) = [];
                                    ind = ind-1;
                                end
                            end
                            ind = ind +1;
                        else
                            go = 0;
                        end
                    end
                end
                
                
                [p,~,mu] = polyfit(dataImp.set.NewplInterpTime([onset_inds_final_pl end_inds_final_pl]),dataImp.set.shimmerInterpTime([onset_inds_final_shimmer end_inds_final_shimmer]),1);
                dataImp.set.FinalplInterpTime = polyval(p,dataImp.set.NewplInterpTime,[],mu);
                
                
                figure
                plot(dataImp.set.shimmerInterpTime,dataImp.set.shimmerInterpTrig)
                hold on
                plot(dataImp.set.FinalplInterpTime,dataImp.set.plInterpTrig)
                plot(dataImp.set.FinalplInterpTime(onset_inds_final_pl),linspace(290,290,length(onset_inds_final_pl)),'b*')
                plot(dataImp.set.FinalplInterpTime(end_inds_final_pl),linspace(290,290,length(end_inds_final_pl)),'g*')
                hold off
                dataImp.final.compare = dif;
            end
            dataImp.final.plTime = dataImp.set.FinalplInterpTime;
            
            dataImp.final.shimmerTime = dataImp.set.shimmerInterpTime;
            
            Data.LE_Position_X = interp1(dataImp.set.plTime,EyeVel.LE_Pos_X,dataImp.set.plInterpTime,'spline');
            Data.LE_Position_Y = interp1(dataImp.set.plTime,EyeVel.LE_Pos_Y,dataImp.set.plInterpTime,'spline');
            Data.LE_Position_Z = interp1(dataImp.set.plTime,EyeVel.LE_Pos_Z,dataImp.set.plInterpTime,'spline');
            
            Data.RE_Position_X = interp1(dataImp.set.plTime,EyeVel.RE_Pos_X,dataImp.set.plInterpTime,'spline');
            Data.RE_Position_Y = interp1(dataImp.set.plTime,EyeVel.RE_Pos_Y,dataImp.set.plInterpTime,'spline');
            Data.RE_Position_Z = interp1(dataImp.set.plTime,EyeVel.RE_Pos_Z,dataImp.set.plInterpTime,'spline');
            
            
            Data.LE_Velocity_X = interp1(dataImp.set.plTime,EyeVel.LE_Vel_X,dataImp.set.plInterpTime,'spline');
            Data.LE_Velocity_Y = interp1(dataImp.set.plTime,EyeVel.LE_Vel_Y,dataImp.set.plInterpTime,'spline');
            Data.LE_Velocity_LARP = interp1(dataImp.set.plTime,EyeVel.LE_Vel_LARP,dataImp.set.plInterpTime,'spline');
            Data.LE_Velocity_RALP = interp1(dataImp.set.plTime,EyeVel.LE_Vel_RALP,dataImp.set.plInterpTime,'spline');
            Data.LE_Velocity_Z = interp1(dataImp.set.plTime,EyeVel.LE_Vel_Z,dataImp.set.plInterpTime,'spline');
            
            Data.RE_Velocity_X = interp1(dataImp.set.plTime,EyeVel.RE_Vel_X,dataImp.set.plInterpTime,'spline');
            Data.RE_Velocity_Y = interp1(dataImp.set.plTime,EyeVel.RE_Vel_Y,dataImp.set.plInterpTime,'spline');
            Data.RE_Velocity_LARP = interp1(dataImp.set.plTime,EyeVel.RE_Vel_LARP,dataImp.set.plInterpTime,'spline');
            Data.RE_Velocity_RALP = interp1(dataImp.set.plTime,EyeVel.RE_Vel_RALP,dataImp.set.plInterpTime,'spline');
            Data.RE_Velocity_Z = interp1(dataImp.set.plTime,EyeVel.RE_Vel_Z,dataImp.set.plInterpTime,'spline');
            
            %%%%%
            Data.HeadMPUVel_X = dataImp.final.shimmerX';
            Data.HeadMPUVel_Y = dataImp.final.shimmerY';
            Data.HeadMPUVel_Z = dataImp.final.shimmerZ';
            
            Data.HeadMPUAccel_X = zeros(length(Data.HeadMPUVel_X),1)';
            Data.HeadMPUAccel_Y = zeros(length(Data.HeadMPUVel_X),1)';
            Data.HeadMPUAccel_Z = zeros(length(Data.HeadMPUVel_X),1)';
            Time_Eye = dataImp.set.FinalplInterpTime;
            Time_Stim = dataImp.set.shimmerInterpTime;
        else
            XvelHeadRaw = data(1:length(Time_Eye),XvelHeadIndex)*gyroscale + XvelHeadOffset;
            YvelHeadRaw = data(1:length(Time_Eye),YvelHeadIndex)*gyroscale + YvelHeadOffset;
            ZvelHeadRaw = data(1:length(Time_Eye),ZvelHeadIndex)*gyroscale + ZvelHeadOffset;
            
            %         XvelHead = data(1:length(Time_Eye),30)*accelscale - XvelHeadOffset;
            %         YvelHead = data(1:length(Time_Eye),29)*accelscale - YvelHeadOffset;
            %         ZvelHead = data(1:length(Time_Eye),28)*accelscale - ZvelHeadOffset;
            
            XaccelHeadRaw = data(1:length(Time_Eye),XaccelHeadIndex)*accelscale;
            YaccelHeadRaw = data(1:length(Time_Eye),YaccelHeadIndex)*accelscale;
            ZaccelHeadRaw = data(1:length(Time_Eye),ZaccelHeadIndex)*accelscale;
            
            % NOTE: We are transposing the rotation matrix in order to apply a
            % PASSIVE (i.e., a coordinate system) transformation
            A = Rotation_Head' * [XvelHeadRaw' ; YvelHeadRaw' ; ZvelHeadRaw'];
            
            XAxisVelHead = A(1,:);
            YAxisVelHead = A(2,:);
            ZAxisVelHead = A(3,:);
            
            B = Rotation_Head' * [XaccelHeadRaw' ; YaccelHeadRaw' ; ZaccelHeadRaw'];
            
            XAxisAccelHead = B(1,:);
            YAxisAccelHead = B(2,:);
            ZAxisAccelHead = B(3,:);
            
            
            
            
            Data.segment_code_version = mfilename;
            Data.raw_filename = handles.raw_FileName;
            Data.LE_Position_X = Torsion_LE_Position;
            Data.LE_Position_Y = Vertical_LE_Position;
            Data.LE_Position_Z = Horizontal_LE_Position;
            
            Data.RE_Position_X = Torsion_RE_Position;
            Data.RE_Position_Y = Vertical_RE_Position;
            Data.RE_Position_Z = Horizontal_RE_Position;
            
            
            Data.LE_Velocity_X = EyeVel.LE_Vel_X;
            Data.LE_Velocity_Y = EyeVel.LE_Vel_Y;
            Data.LE_Velocity_LARP = EyeVel.LE_Vel_LARP;
            Data.LE_Velocity_RALP = EyeVel.LE_Vel_RALP;
            Data.LE_Velocity_Z = EyeVel.LE_Vel_Z;
            
            Data.RE_Velocity_X = EyeVel.RE_Vel_X;
            Data.RE_Velocity_Y = EyeVel.RE_Vel_Y;
            Data.RE_Velocity_LARP = EyeVel.RE_Vel_LARP;
            Data.RE_Velocity_RALP = EyeVel.RE_Vel_RALP;
            Data.RE_Velocity_Z = EyeVel.RE_Vel_Z;
            
            
            Data.HeadMPUVel_X = XAxisVelHead';
            Data.HeadMPUVel_Y = YAxisVelHead';
            Data.HeadMPUVel_Z = ZAxisVelHead';
            
            Data.HeadMPUAccel_X = XAxisAccelHead';
            Data.HeadMPUAccel_Y = YAxisAccelHead';
            Data.HeadMPUAccel_Z = ZAxisAccelHead';
        end
        %Compute the mean
        temp_SampPer = median(abs(diff(Time)));
        temp_Fs = 1/temp_SampPer;
        
        expected_Fs = 100;
        
        if abs(expected_Fs - temp_Fs) > expected_Fs*0.1
            
            answer = questdlg(['The computed sample rate produced an unexpected value.' char(10) 'Expected Sample Rate: ' num2str(expected_Fs) 'Hz' char(10) ...
                'Mean Computed Sample Rate: ' num2str(1/abs(mean(diff(Time)))) 'Hz' char(10) 'Median Computed Sample Rate: ' num2str(temp_Fs) 'Hz' char(10) ...
                'How would you like to proceed?'], ...
                'Sample Rate Error', ...
                'Let me define the sample rate',['Force the expected rate:' num2str(expected_Fs) 'Hz'],['Force the expected rate:' num2str(expected_Fs) 'Hz']);
            % Handle response
            switch answer
                case 'Let me define the sample rate'
                    prompt = {'Enter Sample Rate:'};
                    title = 'Input';
                    dims = [1 35];
                    definput = {'150','hsv'};
                    answer = str2double(inputdlg(prompt,title,dims,definput))
                    
                    Data.Fs = answer;
                case ['Force the expected rate:' num2str(expected_Fs) 'Hz']
                    Data.Fs = expected_Fs;
                    
            end
            
        else
            Data.Fs = expected_Fs;
        end
        
        
        
        Data.Time_Eye = Time_Eye;
        Data.Time_Stim = Time_Stim;
        
        Data.Stim_Trig = zeros(1,length(Time_Eye));
        handles.string_addon = [];
        guidata(hObject,handles)
        
        
        
    case 2 % Lasker System CED
        
        % Check if the user requested to start segmenting a new file, or a
        % 'reload' of the same file.
        if handles.params.reloadflag == 0
            % If requesting a new file, prompt the user to choose the file.
            [FileName,PathName,FilterIndex] = uigetfile('*.smr','Please choose the file to process');
            cd(PathName)
            [FieldGainFile,FieldGainPath,FieldGainFilterIndex] = uigetfile('*.*','Please choose the field gains for this experiment');
            
            handles.raw_PathName = PathName;
            handles.raw_FileName = FileName;
            
            handles.raw_FieldGainPath = FieldGainPath;
            handles.raw_FieldGainFile = FieldGainFile;
            
            eyesRecorded = figure;
            eyesRecorded.Units = 'normalized';
            eyesRecorded.Position = [1.4    0.4    0.075    0.15];
            handles.leftEye = uicontrol(eyesRecorded,'Style','checkbox','String','Left Eye');
            handles.leftEye.Units = 'normalized';
            handles.leftEye.Position = [0.03    0.5    0.5 .5];
            handles.rightEye = uicontrol(eyesRecorded,'Style','checkbox','String','Right Eye');
            handles.rightEye.Units = 'normalized';
            handles.rightEye.Position = [0.5 0.5 .5 .5];
            handles.leftEyeCh = uicontrol(eyesRecorded,'Style','listbox','String',{' ','Ch1Ch2','Ch3Ch4'},'Value',3);
            handles.leftEyeCh.Units = 'normalized';
            handles.leftEyeCh.Position = [0.03    0.3    0.410    0.3000];
            handles.rightEyeCh = uicontrol(eyesRecorded,'Style','listbox','String',{' ','Ch1Ch2','Ch3Ch4'},'Value',2);
            handles.rightEyeCh.Units = 'normalized';
            handles.rightEyeCh.Position = [0.5    0.3    0.410    0.3000];
            handles.eyes = uicontrol(eyesRecorded,'Style','radiobutton','String','ok');
            handles.eyes.Units = 'normalized';
            handles.eyes.Position = [0.3    0.05    0.5    0.2000];
            handles.eyes.FontSize = 18;
            waitfor(handles.eyes,'Value');
            
            
            if handles.leftEye.Value == 0
                handles.EyeCh = handles.leftEyeCh.String{2};
                handles.eye_rec.Value = 4;
                
            elseif handles.rightEye.Value == 0
                handles.EyeCh = handles.rightEyeCh.String{3};
                handles.eye_rec.Value = 3;
            else
                handles.EyeCh = {handles.rightEyeCh.String{2},handles.rightEyeCh.String{3}};
                handles.eye_rec.Value = 2;
            end
            handles.text53.BackgroundColor = [0.94 0.94 0.94];
            delete(eyesRecorded)
            
            
            set(handles.raw_name,'String',FileName);
        else
            % If we are reloading a file, don't prompt the user and reset
            % the 'reload' flag.
            FileName = handles.raw_FileName;
            PathName = handles.raw_PathName;
            
            
            FieldGainPath = handles.raw_FieldGainPath;
            FieldGainFile = handles.raw_FieldGainFile;
            
            handles.params.reloadflag = 0;
        end
        handles.string_addon = [];
        %         % Import the data from the .smr file
        %         [d]=ImportSMR_PJBv2(FileName,PathName);
        
        
        
        
        % Import the Field Gain file, collected using the vordaq/showall
        % software
        fieldgainname = [FieldGainPath FieldGainFile];
        delimiter = '\t';
        formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
        
        fileID = fopen(fieldgainname,'r');
        
        dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN, 'ReturnOnError', false);
        
        fclose(fileID);
        
        FieldGains = [dataArray{1:end-1}];
        
        % During my daily calibration procedure, I zero-out the fields to
        % have no offsets with a test coil.
        coilzeros = [0 0 0 0 0 0 0 0 0 0 0 0];
        % This will use the first data point as a reference position
        ref = 0;
        % Don't put a smapling rate param. in, we will extract it from the
        % CED file.
        Fs = [];
        % Mark the 'system_code'
        switch handles.params.Lasker_param2
            case 1 % Head is upright, but we still need to correct the coil signals into proper X, Y, Z coordinates
                system_code = 2;
            case 2
                system_code = 3;
            case 3
                system_code = 4;
        end
        % Indicate the DAQ code
        DAQ_code = 3; % Lasker System as recorded by a CED 1401 device
        
        
        [RawData] = voma__processeyemovements(PathName,FileName,FieldGains,coilzeros,ref,system_code,DAQ_code,1);
        
        % Attempt to
        
        if ((handles.eye_rec.Value == 3) && (strcmp(handles.EyeCh,'Ch3Ch4'))) || ((handles.eye_rec.Value == 4) && (strcmp(handles.EyeCh,'Ch1Ch2')))
            Data.RE_Position_X = RawData.LE_Pos_X;
            Data.RE_Position_Y = RawData.LE_Pos_Y;
            Data.RE_Position_Z = RawData.LE_Pos_Z;
            
            Data.LE_Position_X = RawData.RE_Pos_X;
            Data.LE_Position_Y = RawData.RE_Pos_Y;
            Data.LE_Position_Z = RawData.RE_Pos_Z;
            
            Data.RE_Velocity_X = RawData.LE_Vel_X;
            Data.RE_Velocity_Y = RawData.LE_Vel_Y;
            Data.RE_Velocity_LARP = RawData.LE_Vel_LARP;
            Data.RE_Velocity_RALP = RawData.LE_Vel_RALP;
            Data.RE_Velocity_Z = RawData.LE_Vel_Z;
            
            Data.LE_Velocity_X = RawData.RE_Vel_X;
            Data.LE_Velocity_Y = RawData.RE_Vel_Y;
            Data.LE_Velocity_LARP = RawData.RE_Vel_LARP;
            Data.LE_Velocity_RALP = RawData.RE_Vel_RALP;
            Data.LE_Velocity_Z = RawData.RE_Vel_Z;
        else
            Data.LE_Position_X = RawData.LE_Pos_X;
            Data.LE_Position_Y = RawData.LE_Pos_Y;
            Data.LE_Position_Z = RawData.LE_Pos_Z;
            
            Data.RE_Position_X = RawData.RE_Pos_X;
            Data.RE_Position_Y = RawData.RE_Pos_Y;
            Data.RE_Position_Z = RawData.RE_Pos_Z;
            
            Data.LE_Velocity_X = RawData.LE_Vel_X;
            Data.LE_Velocity_Y = RawData.LE_Vel_Y;
            Data.LE_Velocity_LARP = RawData.LE_Vel_LARP;
            Data.LE_Velocity_RALP = RawData.LE_Vel_RALP;
            Data.LE_Velocity_Z = RawData.LE_Vel_Z;
            
            Data.RE_Velocity_X = RawData.RE_Vel_X;
            Data.RE_Velocity_Y = RawData.RE_Vel_Y;
            Data.RE_Velocity_LARP = RawData.RE_Vel_LARP;
            Data.RE_Velocity_RALP = RawData.RE_Vel_RALP;
            Data.RE_Velocity_Z = RawData.RE_Vel_Z;
        end
        Data.segment_code_version = mfilename;
        Data.raw_filename = handles.raw_FileName;
        
        Data.Fs = RawData.Fs;
        
        
        
        
        Data.Time_Eye = [0:length(RawData.LE_Vel_LARP)-1]/Data.Fs;
        Data.Time_Stim = RawData.ElecStimTrig';
        
        if isempty(RawData.ElecStimTrig)
            
            Data.Stim_Trig = [];
            Data.Time_Stim = Data.Time_Eye;
        else
            % We will calculate PR using a first order backwards difference
            % instantaneous rate approx. We are not using a central
            % difference, since it will smear/smooth the Pulse rate values
            PR = 1./diff(RawData.ElecStimTrig(:,1));
            % To have the same number of PR values as pulse times, we will
            % copy the first entry in the array, and append the PR array in
            % the front. The first value in the PR array is really
            % "PulseTime(2)-PulseTime(1)". The actual value plotted/saved
            % here is for graphical purposes only and the actual pulse
            % times themselves will be used for analysis.
            Data.Stim_Trig = [PR(1) PR'];
            
        end
        
        % Kludge for now!
        Data.HeadMPUVel_X = zeros(length(Data.Time_Eye),1);
        Data.HeadMPUVel_Y = zeros(length(Data.Time_Eye),1);
        Data.HeadMPUVel_Z = RawData.Var_x083;
        
        Data.HeadMPUAccel_X = zeros(length(Data.Time_Eye),1);
        Data.HeadMPUAccel_Y = zeros(length(Data.Time_Eye),1);
        Data.HeadMPUAccel_Z = zeros(length(Data.Time_Eye),1);
        
    case 3 % Pupil Labs
        % Check if the user requested to start segmenting a new file, or a
        % 'reload' of the same file.
        data = struct();
        if handles.params.reloadflag == 0
            % If requesting a new file, prompt the user to choose the file.
            handles.pl = [];
            handles.shimmer = [];
            answer = questdlg('Are your files already in .mat form?','File Format','Yes','No','No');
            switch answer
                case 'No'
                    answer2 = questdlg('Which alignment method was used?','Alignment Method','Annotation Method','IR LED Washout Method','IR LED Washout Method');
                    switch answer2
                        case 'Annotation Method'
                            fileNumber = inputdlg('How many Pupil Labs Spreadsheets and corresponding Shimmer files are you segmenting?','File Number',[1,40],{'1'});
                            fileNumber = str2num(fileNumber{1});
                            for files = 1:fileNumber
                                [FileName,PathName,FilterIndex] = uigetfile('*.csv',['Please choose the exported Pupil Labs Gaze .csv data file for analysis of set', num2str(files)]);
                                a = strfind(PathName,handles.ispc.slash);
                                savePath = PathName(1:a(length(a)-4));
                                cd(savePath);
                                [FileNameAnnotations,PathNameAnnotations,FilterIndexAnnotatons] = uigetfile('*.csv',['Please choose the exported Pupil Labs Annotations .csv data file for analysis of set', num2str(files)]);
                                [FileNameShimmer,PathNameShimmer,FilterIndexShimmer] = uigetfile('*.csv',['Please choose the exported Shimmer .csv data file for analysis of set', num2str(files)]);
                                handles.load_raw.BackgroundColor = [1    1    0];
                                pause(0.1);
                                gazeset1 = importdata([PathName,FileName]);
                                annotations = importdata([PathNameAnnotations,FileNameAnnotations]);
                                shimmerset1 = importdata([PathNameShimmer,FileNameShimmer]);
                                handles.load_raw.BackgroundColor = [0    1    0];
                                pause(0.1);
                                handles.load_raw.BackgroundColor = [1    1    0];
                                pause(0.1);
                                %Loading in the 3D gaze data in mm from the coordinant system designated by Pupil Labs
                                %With X being horizontal movements, Y vertical, and Z being
                                %depth of gaze or how far away the subject is looking and
                                %therefore not relevant but can still be used during the
                                %conversion to position in degrees
                                handles.pl(files).gazeptX1 = gazeset1.data(:,1);
                                handles.pl(files).gazeptY1 = gazeset1.data(:,2);
                                handles.pl(files).gazeptZ1 = gazeset1.data(:,3);
                                
                                handles.pl(files).time = str2double(gazeset1.textdata(2:end,1))-str2double(gazeset1.textdata(2));
                                handles.pl(files).trig.matchtimes = str2double(annotations.textdata(find(strcmp(annotations.textdata(:,3),'t')),2))-str2double(gazeset1.textdata(2));
                                handles.shimmer(files).time1 = ((shimmerset1.data(:,1)-shimmerset1.data(1,1))/1000);
                                
                                handles.pl(files).trig.plot = zeros(length(handles.pl(files).time),1);
                                
                                handles.shimmer(files).gyroX1 = shimmerset1.data(:,5);
                                handles.shimmer(files).gyroY1 = shimmerset1.data(:,6);
                                handles.shimmer(files).gyroZ1 = shimmerset1.data(:,7);
                                handles.shimmer(files).trig = shimmerset1.data(:,8)*300;
                                
                                
                                for i = 1:length(handles.pl(files).trig.matchtimes)
                                    [c ind] = min(abs(handles.pl(files).time-handles.pl(files).trig.matchtimes(i)));
                                    handles.pl(files).trig.inds(i) = ind;
                                end
                                handles.pl(files).trig.plot(handles.pl(files).trig.inds) = 300;
                                
                                
                                data.set(files).plTime = handles.pl(files).time;
                                data.set(files).shimmerTime = handles.shimmer(files).time1;
                                
                                data.set(files).plangX = handles.pl(files).gazeptX1;
                                data.set(files).plangY = handles.pl(files).gazeptY1;
                                data.set(files).plangZ = handles.pl(files).gazeptZ1;
                                
                                data.set(files).plInterpTime = 0:1/1100:data.set(files).plTime(end);
                                data.set(files).shimmerInterpTime = 0:1/1100:data.set(files).shimmerTime(end);
                                
                                data.set(files).plInterpTrig = interp1(data.set(files).plTime,handles.pl(files).trig.plot,data.set(files).plInterpTime);
                                data.set(files).shimmerInterpTrig = interp1(data.set(files).shimmerTime,handles.shimmer(files).trig,data.set(files).shimmerInterpTime);
                                data.set(files).plInterpTrig(data.set(files).plInterpTrig>0) = 300;
                                data.set(files).shimmerInterpTrig(data.set(files).shimmerInterpTrig>0) = 300;
                                
                                inds_pl = [1:length(data.set(files).plInterpTrig)];
                                inds_shimmer = [1:length(data.set(files).shimmerInterpTrig)];
                                
                                onset_inds_pl = inds_pl([false ; diff(data.set(files).plInterpTrig')>0]);
                                onset_inds_shimmer = inds_shimmer([false ; diff(data.set(files).shimmerInterpTrig')>0]);
                                
                                end_inds_pl = inds_pl([false ; diff(data.set(files).plInterpTrig')<0]);
                                end_inds_shimmer = inds_shimmer([false ; diff(data.set(files).shimmerInterpTrig')<0]);
                                
                                thresh = end_inds_shimmer(1)-onset_inds_shimmer(1)-100;
                                
                                
                                final_inds_pl = find((end_inds_pl-onset_inds_pl)>thresh);
                                final_inds_shimmer = find((end_inds_shimmer-onset_inds_shimmer)>thresh);
                                
                                onset_inds_final_pl= onset_inds_pl(final_inds_pl);
                                onset_inds_final_shimmer= onset_inds_shimmer(final_inds_shimmer);
                                
                                end_inds_final_pl = end_inds_pl(final_inds_pl);
                                end_inds_final_shimmer = end_inds_shimmer(final_inds_shimmer);
                                
                                dif = data.set(files).shimmerInterpTime(onset_inds_final_shimmer(1))- data.set(files).plInterpTime(onset_inds_final_pl(1))
                                data.set(files).plInterpTime = data.set(files).plInterpTime+dif;
                                p = polyfit(shift(onset_inds_final_pl),data.set(files).shimmerInterpTime(onset_inds_final_shimmer),1)
                                data.set(files).shimmerInterpTime = (data.set(files).shimmerInterpTime-p(2))./p(1);
                                
                                
                                data.set(files).plangX = atan2d(sqrt(data.set(files).plangY.^2+data.set(files).plangZ.^2),data.set(files).plangX);
                                data.set(files).plangY = atan2d(sqrt(data.set(files).plangX.^2+data.set(files).plangZ.^2),data.set(files).plangY);
                                data.set(files).plangZ = atan2d(sqrt(data.set(files).plangY.^2+data.set(files).plangX.^2),data.set(files).plangZ);
                                handles.load_raw.BackgroundColor = [0.9400    0.9400    0.9400];
                                answer3 = questdlg('Which orientation was the shimmer placed?','Shimmer Orientation','Connector facing up toward the top of the head','Connector facing down toward the neck','Connector facing down toward the neck');
                                switch answer3
                                    case 'Connector facing down toward the neck'
                                        rotationx = [
                                            1 0 0;
                                            0 cosd(-90) -sind(-90);
                                            0 sind(-90) cosd(-90);
                                            ];
                                        rotationz = [
                                            cosd(90) -sind(90) 0;
                                            sind(90) cosd(90) 0;
                                            0 0 1;
                                            ];
                                    case 'Connector facing up toward the top of the head'
                                        rotationx = [
                                            1 0 0;
                                            0 cosd(90) -sind(90);
                                            0 sind(90) cosd(90);
                                            ];
                                        rotationz = [
                                            cosd(90) -sind(90) 0;
                                            sind(90) cosd(90) 0;
                                            0 0 1;
                                            ];
                                end
                                
                                rgyroX1 = rotationx'*[handles.shimmer(files).gyroX1' ; handles.shimmer(files).gyroY1' ; handles.shimmer(files).gyroZ1'];
                                rgyroZ1 = rotationz'*rgyroX1;
                                
                                data.set(files).shimmerX = rgyroZ1(1,:)';
                                data.set(files).shimmerY = rgyroZ1(2,:)';
                                data.set(files).shimmerZ = rgyroZ1(3,:)';
                                
                                %Reorganizing the Pupil Lab eye movement convention into
                                %rotation about the lab convention axis ***Need to figure out
                                %which direction Left or Right pupil labs sees as positive****
                                handles.load_raw.BackgroundColor = [1    1    0];
                                pause(0.1);
                                
                                data.final(files).plTime = data.set(files).plInterpTime;
                                data.final(files).compare = dif;
                                handles.load_raw.BackgroundColor = [0    1    0];
                                pause(0.1);
                                handles.load_raw.BackgroundColor = [1    1    0];
                                pause(0.1);
                                data.final(files).plangZ = interp1(data.set(files).plTime,data.set(files).plangX,data.set(files).plInterpTime,'spline');
                                handles.load_raw.BackgroundColor = [0    1    0];
                                pause(0.1);
                                handles.load_raw.BackgroundColor = [1    1    0];
                                pause(0.1);
                                data.final(files).plangY = interp1(data.set(files).plTime,data.set(files).plangY,data.set(files).plInterpTime,'spline');
                                handles.load_raw.BackgroundColor = [0    1    0];
                                pause(0.1);
                                handles.load_raw.BackgroundColor = [1    1    0];
                                pause(0.1);
                                data.final(files).plangX = zeros(length(data.final(files).plTime),1);
                                data.final(files).shimmerTime = data.set(files).shimmerInterpTime;
                                data.final(files).shimmerX = interp1(data.set(files).shimmerTime,data.set(files).shimmerX,data.set(files).shimmerInterpTime,'spline');
                                handles.load_raw.BackgroundColor = [0    1    0];
                                pause(0.1);
                                handles.load_raw.BackgroundColor = [1    1    0];
                                pause(0.1);
                                data.final(files).shimmerY = interp1(data.set(files).shimmerTime,data.set(files).shimmerY,data.set(files).shimmerInterpTime,'spline');
                                handles.load_raw.BackgroundColor = [0    1    0];
                                pause(0.1);
                                handles.load_raw.BackgroundColor = [1    1    0];
                                pause(0.1);
                                
                                data.final(files).shimmerZ = interp1(data.set(files).shimmerTime,data.set(files).shimmerZ,data.set(files).shimmerInterpTime,'spline');
                                handles.load_raw.BackgroundColor = [0    1    0];
                                pause(0.1);
                                handles.load_raw.BackgroundColor = [1    1    0];
                                pause(0.1);
                                
                                
                            end
                            data.f.plTime = [];
                            data.f.compare = [];
                            data.f.plangX = [];
                            data.f.plangY = [];
                            data.f.plangZ = [];
                            data.f.shimmerTime = [];
                            data.f.shimmerX = [];
                            data.f.shimmerY = [];
                            data.f.shimmerZ = [];
                            for i = 1:length(data.final)
                                if i>1
                                    timeSpace = max([data.f.plTime(end) data.f.shimmerTime(end)])+10;
                                    data.f.compare = [data.f.compare; data.final(i).compare];
                                    data.f.plangX = [data.f.plangX; data.final(i).plangX];
                                    data.f.plangY = [data.f.plangY; data.final(i).plangY'];
                                    data.f.plangZ = [data.f.plangZ; data.final(i).plangZ'];
                                    if length(find(data.f.shimmerTime-data.final(i).shimmerTime'==0))==length(data.f.shimmerTime)
                                        data.f.plTime = [data.f.plTime; data.final(i).plTime'];
                                        data.f.shimmerTime = data.f.shimmerTime;
                                        data.f.shimmerX = data.f.shimmerX;
                                        data.f.shimmerY = data.f.shimmerY;
                                        data.f.shimmerZ = data.f.shimmerZ;
                                    else
                                        data.f.plTime = [data.f.plTime; data.final(i).plTime'+timeSpace];
                                        data.f.shimmerTime = [data.f.shimmerTime; data.final(i).shimmerTime'+timeSpace];
                                        data.f.shimmerX = [data.f.shimmerX; data.final(i).shimmerX'];
                                        data.f.shimmerY = [data.f.shimmerY; data.final(i).shimmerY'];
                                        data.f.shimmerZ = [data.f.shimmerZ; data.final(i).shimmerZ'];
                                    end
                                    
                                    
                                else
                                    data.f.plTime = [data.f.plTime; data.final(i).plTime'];
                                    data.f.compare = [data.f.compare; data.final(i).compare];
                                    data.f.plangX = [data.f.plangX; data.final(i).plangX];
                                    data.f.plangY = [data.f.plangY; data.final(i).plangY'];
                                    data.f.plangZ = [data.f.plangZ; data.final(i).plangZ'];
                                    data.f.shimmerTime = [data.f.shimmerTime; data.final(i).shimmerTime'];
                                    data.f.shimmerX = [data.f.shimmerX; data.final(i).shimmerX'];
                                    data.f.shimmerY = [data.f.shimmerY; data.final(i).shimmerY'];
                                    data.f.shimmerZ = [data.f.shimmerZ; data.final(i).shimmerZ'];
                                end
                            end
                            handles.load_raw.BackgroundColor = [0.9400    0.9400    0.9400];
                            final = data.f;
                            
                            a = strfind(PathName,handles.ispc.slash);
                            hold1 = PathName;
                            hold1(a)= '_';
                            FileName = hold1(a(2)+1:a(length(a)-4)-1);
                            savePath = PathName(1:a(length(a)-4));
                            save([savePath,FileName,'.mat'],'-struct','final')
                            handles.raw_PathName = savePath;
                            handles.raw_FileName = FileName;
                            set(handles.raw_name,'String',FileName);
                        case 'IR LED Washout Method'
                            handles.pl = [];
                            handles.shimmer = [];
                            data = [];
                            fileNumber = inputdlg('How many Pupil Labs Gaze Spreadsheets are you segmenting?','File Number',[1,40],{'1'});
                            fileNumber = str2num(fileNumber{1});
                            
                            for files = 1:fileNumber
                                [FileName,PathName,FilterIndex] = uigetfile('*.csv',['Please choose the exported Pupil Labs Gaze .csv data file for analysis of set', num2str(files)]);
                                a = strfind(PathName,handles.ispc.slash);
                                savePath = PathName(1:a(length(a)-4));
                                
                                cd(savePath);
                                [FileNameShimmer,PathNameShimmer,FilterIndexShimmer] = uigetfile('*.csv',['Please choose the exported Shimmer .csv data file for analysis of set', num2str(files)]);
                                handles.load_raw.BackgroundColor = [1    1    0];
                                pause(0.1);
                                gazeset1 = importdata([PathName,FileName]);
                                shimmerset1 = importdata([PathNameShimmer,FileNameShimmer]);
                                
                                
                                handles.pl(files).gazeptX1 = gazeset1.data(:,1);
                                handles.pl(files).gazeptY1 = gazeset1.data(:,2);
                                handles.pl(files).gazeptZ1 = gazeset1.data(:,3);
                                
                                handles.pl(files).time = str2double(gazeset1.textdata(2:end,1))-str2double(gazeset1.textdata(2));
                                
                                handles.shimmer(files).time1 = ((shimmerset1.data(:,1)-shimmerset1.data(1,1))/1000);
                                
                                
                                handles.shimmer(files).gyroX1 = shimmerset1.data(:,3);
                                handles.shimmer(files).gyroY1 = shimmerset1.data(:,4);
                                handles.shimmer(files).gyroZ1 = shimmerset1.data(:,5);
                                handles.shimmer(files).trig = (shimmerset1.data(:,2)-3000)*-1;
                                
                                
                                
                                data.set(files).plTime = handles.pl(files).time;
                                data.set(files).shimmerTime = handles.shimmer(files).time1;
                                data.set(files).shimmerTrig = handles.shimmer(files).trig;
                                data.set(files).plangX = handles.pl(files).gazeptX1;
                                data.set(files).plangY = handles.pl(files).gazeptY1;
                                data.set(files).plangZ = handles.pl(files).gazeptZ1;
                                
                                
                                
                                data.set(files).plangX = atan2d(sqrt(data.set(files).plangY.^2+data.set(files).plangZ.^2),data.set(files).plangX);
                                data.set(files).plangY = atan2d(sqrt(data.set(files).plangX.^2+data.set(files).plangZ.^2),data.set(files).plangY);
                                data.set(files).plangZ = atan2d(sqrt(data.set(files).plangY.^2+data.set(files).plangX.^2),data.set(files).plangZ);
                                handles.load_raw.BackgroundColor = [0.9400    0.9400    0.9400];
                                answer3 = questdlg('Which orientation was the shimmer placed?','Shimmer Orientation','Connector facing up toward the top of the head','Connector facing down toward the neck','Connector facing down toward the neck');
                                switch answer3
                                    case 'Connector facing down toward the neck'
                                        rotationx = [
                                            1 0 0;
                                            0 cosd(-90) -sind(-90);
                                            0 sind(-90) cosd(-90);
                                            ];
                                        rotationz = [
                                            cosd(90) -sind(90) 0;
                                            sind(90) cosd(90) 0;
                                            0 0 1;
                                            ];
                                    case 'Connector facing up toward the top of the head'
                                        rotationx = [
                                            1 0 0;
                                            0 cosd(90) -sind(90);
                                            0 sind(90) cosd(90);
                                            ];
                                        rotationz = [
                                            cosd(90) -sind(90) 0;
                                            sind(90) cosd(90) 0;
                                            0 0 1;
                                            ];
                                end
                                
                                rgyroX1 = rotationx'*[handles.shimmer(files).gyroX1' ; handles.shimmer(files).gyroY1' ; handles.shimmer(files).gyroZ1'];
                                rgyroZ1 = rotationz'*rgyroX1;
                                
                                data.set(files).shimmerX = rgyroZ1(1,:)';
                                data.set(files).shimmerY = rgyroZ1(2,:)';
                                data.set(files).shimmerZ = rgyroZ1(3,:)';
                                
                                data.set(files).plInterpTime = 0:1/1100:data.set(files).plTime(end);
                                data.set(files).shimmerInterpTime = 0:1/1100:data.set(files).shimmerTime(end);
                                
                                %Reorganizing the Pupil Lab eye movement convention into
                                %rotation about the lab convention axis ***Need to figure out
                                %which direction Left or Right pupil labs sees as positive****
                                data.final(files).plangZ = interp1(data.set(files).plTime,data.set(files).plangX,data.set(files).plInterpTime,'spline');
                                data.final(files).plangY = interp1(data.set(files).plTime,data.set(files).plangY,data.set(files).plInterpTime,'spline');
                                data.final(files).plangX = zeros(length(data.set(files).plInterpTime),1);
                                
                                data.final(files).shimmerX = interp1(data.set(files).shimmerTime,data.set(files).shimmerX,data.set(files).shimmerInterpTime,'spline');
                                data.final(files).shimmerY = interp1(data.set(files).shimmerTime,data.set(files).shimmerY,data.set(files).shimmerInterpTime,'spline');
                                data.final(files).shimmerZ = interp1(data.set(files).shimmerTime,data.set(files).shimmerZ,data.set(files).shimmerInterpTime,'spline');
                                
                                
                                
                                
                                data.set(files).mag = sqrt((data.set(files).plangX.^2) + (data.set(files).plangY.^2) + (data.set(files).plangZ.^2)); % Calculating the magnitude of the X Y and Z velocities
                                trace = data.set(files).mag;
                                %         traceTest = data.set(files).mag;
                                %         traceTest(traceTest<190) = 0;
                                %                         inds = [1:length(traceTest)];
                                % onset_inds = inds([false ; diff(traceTest)>0]);
                                %
                                % end_inds = inds([false ; diff(traceTest)<0]);
                                % if onset_inds(1)>end_inds(1)
                                %     end_inds(1) = [];
                                % end
                                % final_inds = find((end_inds-onset_inds)>150);
                                % onset_inds_final= onset_inds(final_inds);
                                % end_inds_final = end_inds(final_inds);
                                
                                
                                mask = zeros(length(trace),1);
                                
                                window = 500;
                                b = (1/window)*ones(1,window);
                                a = 1;
                                x = filter(b,a,data.set(files).mag);
                                threshPTx = find(abs(gradient(x)<0.02));
                                xVal =  round(mean(x(threshPTx)));
                                
                                
                                saved_thresh = xVal+40;
                                
                                mask(trace > saved_thresh) = ones(length(find(trace > saved_thresh)),1); % All of the indicies where the magnitudes is greater than 20 will be changed from zero to 1
                                mask = (mask)*3000;
                                
                                
                                data.set(files).plInterpTrig = interp1(data.set(files).plTime,mask,data.set(files).plInterpTime);
                                data.set(files).shimmerInterpTrig = interp1(data.set(files).shimmerTime,handles.shimmer(files).trig,data.set(files).shimmerInterpTime);
                                
                                
                                data.set(files).plInterpTrig(data.set(files).plInterpTrig>0) = 300;
                                data.set(files).shimmerInterpTrig(data.set(files).shimmerInterpTrig>0) = 300;
                                
                                inds_pl = [1:length(data.set(files).plInterpTrig)];
                                inds_shimmer = [1:length(data.set(files).shimmerInterpTrig)];
                                
                                onset_inds_pl = inds_pl([false ; diff(data.set(files).plInterpTrig')>0]);
                                onset_inds_shimmer = inds_shimmer([false ; diff(data.set(files).shimmerInterpTrig')>0]);
                                
                                end_inds_pl = inds_pl([false ; diff(data.set(files).plInterpTrig')<0]);
                                end_inds_shimmer = inds_shimmer([false ; diff(data.set(files).shimmerInterpTrig')<0]);
                                
                                if length(onset_inds_pl) ~= length(end_inds_pl)
                                    if length(onset_inds_pl)>length(end_inds_pl)
                                        onset_inds_pl(end) = [];
                                    else
                                        end_inds_pl(1) = [];
                                    end
                                end
                                
                                thresh = end_inds_shimmer(1)-onset_inds_shimmer(1)-100;
                                
                                final_inds_pl = find((end_inds_pl-onset_inds_pl)>(thresh));
                                final_inds_shimmer = find((end_inds_shimmer-onset_inds_shimmer)>(thresh));
                                
                                onset_inds_final_pl= onset_inds_pl(final_inds_pl);
                                onset_inds_final_shimmer= onset_inds_shimmer(final_inds_shimmer);
                                
                                end_inds_final_pl = end_inds_pl(final_inds_pl);
                                end_inds_final_shimmer = end_inds_shimmer(final_inds_shimmer);
                                
                                if length(onset_inds_final_shimmer)>20
                                    d = ([false diff(onset_inds_final_shimmer)]);
                                    if d(11)<100000
                                        onset_inds_final_shimmer(11)=[];
                                        end_inds_final_shimmer(11)=[];
                                    end
                                end
                                
                                
                                
                                dif = data.set(files).shimmerInterpTime(onset_inds_final_shimmer(1))- data.set(files).plInterpTime(onset_inds_final_pl(1));
                                data.set(files).plInterpTime = data.set(files).plInterpTime+dif;
                                
                                a=find(([false ; diff(onset_inds_final_shimmer')])>100000);
                                b=find(([diff(end_inds_final_shimmer') ; false])>100000);
                                lower = end_inds_final_shimmer(b);
                                upper = onset_inds_final_shimmer(a);
                                
                                [va,l] = min(abs(data.set(files).plInterpTime-data.set(files).shimmerInterpTime(lower)));
                                [vb,u] = min(abs(data.set(files).shimmerInterpTime(upper)-data.set(files).plInterpTime));
                                
                                onset_inds_final_pl(onset_inds_final_pl<(u-2000) & onset_inds_final_pl>(l)) = [];
                                end_inds_final_pl(end_inds_final_pl<(u-2000) & end_inds_final_pl>(l+2000)) = [];
                                
                                data.set(files).plInterpTrig(l:u-2000) = 0;
                                
                                if length(onset_inds_final_pl) ~= length(onset_inds_final_shimmer)
                                    go = 1;
                                    ind = 1;
                                    while go
                                        if length(onset_inds_final_pl) ~= length(onset_inds_final_shimmer)
                                            if ind==min([length(onset_inds_final_pl) length(onset_inds_final_shimmer)])
                                                if ind==length(onset_inds_final_pl)
                                                    onset_inds_final_shimmer(ind+1) = [];
                                                    end_inds_final_shimmer(ind+1) = [];
                                                    go = 0;
                                                else
                                                    onset_inds_final_pl(ind+1) = [];
                                                    end_inds_final_pl(ind+1) = [];
                                                    go = 0;
                                                end
                                            elseif (abs(data.set(files).plInterpTime(onset_inds_final_pl(ind))-data.set(files).shimmerInterpTime(onset_inds_final_shimmer(ind)))>0.03)
                                                if data.set(files).plInterpTime(onset_inds_final_pl(ind))-data.set(files).shimmerInterpTime(onset_inds_final_shimmer(ind))<0
                                                    onset_inds_final_pl(ind) = [];
                                                    end_inds_final_pl(ind) = [];
                                                    ind = ind -1;
                                                else
                                                    onset_inds_final_shimmer(ind) = [];
                                                    end_inds_final_shimmer(ind) = [];
                                                    ind = ind-1;
                                                end
                                            end
                                            ind = ind +1;
                                        else
                                            go = 0;
                                        end
                                    end
                                end
                                
                                p = polyfit(data.set(files).plInterpTime(onset_inds_final_pl),data.set(files).shimmerInterpTime(onset_inds_final_shimmer),1);
                                data.set(files).shimmerInterpTime = (data.set(files).shimmerInterpTime-p(2))./p(1);
                                p = polyfit(data.set(files).plInterpTime(end_inds_final_pl),data.set(files).shimmerInterpTime(end_inds_final_shimmer),1);
                                data.set(files).shimmerInterpTime = (data.set(files).shimmerInterpTime-p(2))./p(1);
                                dif = data.set(files).shimmerInterpTime(onset_inds_final_shimmer(1))- data.set(files).plInterpTime(onset_inds_final_pl(1));
                                data.set(files).plInterpTime = data.set(files).plInterpTime+dif;
                                
                                figure
                                plot(data.set(files).shimmerInterpTime,data.set(files).shimmerInterpTrig)
                                hold on
                                plot(data.set(files).plInterpTime,data.set(files).plInterpTrig)
                                plot(data.set(files).plInterpTime(onset_inds_final_pl),linspace(290,290,length(onset_inds_final_pl)),'b*')
                                plot(data.set(files).plInterpTime(end_inds_final_pl),linspace(290,290,length(end_inds_final_pl)),'g*')
                                hold off
                                
                                data.final(files).plTime = data.set(files).plInterpTime;
                                data.final(files).compare = dif;
                                data.final(files).shimmerTime = data.set(files).shimmerInterpTime;
                                
                            end
                            
                            data.f.plTime = [];
                            data.f.compare = [];
                            data.f.plangX = [];
                            data.f.plangY = [];
                            data.f.plangZ = [];
                            data.f.shimmerTime = [];
                            data.f.shimmerX = [];
                            data.f.shimmerY = [];
                            data.f.shimmerZ = [];
                            for i = 1:length(data.final)
                                if i>1
                                    timeSpace = max([data.f.plTime(end) data.f.shimmerTime(end)])+10;
                                    data.f.plTime = [data.f.plTime; data.final(i).plTime'+timeSpace];
                                    data.f.compare = [data.f.compare; data.final(files).compare];
                                    data.f.plangX = [data.f.plangX; data.final(i).plangX];
                                    data.f.plangY = [data.f.plangY; data.final(i).plangY'];
                                    data.f.plangZ = [data.f.plangZ; data.final(i).plangZ'];
                                    data.f.shimmerTime = [data.f.shimmerTime; data.final(i).shimmerTime'+timeSpace];
                                    data.f.shimmerX = [data.f.shimmerX; data.final(i).shimmerX'];
                                    data.f.shimmerY = [data.f.shimmerY; data.final(i).shimmerY'];
                                    data.f.shimmerZ = [data.f.shimmerZ; data.final(i).shimmerZ'];
                                else
                                    data.f.plTime = [data.f.plTime; data.final(i).plTime'];
                                    data.f.compare = [data.f.compare; data.final(i).compare];
                                    data.f.plangX = [data.f.plangX; data.final(i).plangX];
                                    data.f.plangY = [data.f.plangY; data.final(i).plangY'];
                                    data.f.plangZ = [data.f.plangZ; data.final(i).plangZ'];
                                    data.f.shimmerTime = [data.f.shimmerTime; data.final(i).shimmerTime'];
                                    data.f.shimmerX = [data.f.shimmerX; data.final(i).shimmerX'];
                                    data.f.shimmerY = [data.f.shimmerY; data.final(i).shimmerY'];
                                    data.f.shimmerZ = [data.f.shimmerZ; data.final(i).shimmerZ'];
                                end
                            end
                            final = data.f;
                            
                            a = strfind(PathName,handles.ispc.slash);
                            hold1 = PathName;
                            hold1(a)= '_';
                            FileName = hold1(a(2)+1:a(length(a)-4)-1);
                            savePath = PathName(1:a(length(a)-4));
                            save([savePath,FileName,'.mat'],'-struct','final')
                            handles.raw_PathName = savePath;
                            handles.raw_FileName = FileName;
                            set(handles.raw_name,'String',FileName);
                    end
                case 'Yes'
                    [FileName,PathName,FilterIndex] = uigetfile('*.mat','Please choose the data file for analysis');
                    
                    handles.raw_PathName = PathName;
                    handles.raw_FileName = FileName;
                    
                    set(handles.raw_name,'String',FileName);
            end
        else
            % If we are reloading a file, don't prompt the user and reset
            % the 'reload' flag.
            FileName = handles.raw_FileName;
            PathName = handles.raw_PathName;
            handles.params.reloadflag = 0;
            handles.segment_number.String = '0';
            handles.experimentdata = {};
            data = load([handles.raw_PathName handles.raw_FileName]);
        end
        
        data = load([handles.raw_PathName handles.raw_FileName]);
        Time_Eye = data.plTime;
        Time_Stim = data.shimmerTime;
        
        Horizontal_LE_Position = data.plangZ;
        Vertical_LE_Position = data.plangY;
        Torsion_LE_Position = data.plangX;
        Horizontal_RE_Position = zeros(length(Time_Eye),1);
        Vertical_RE_Position = zeros(length(Time_Eye),1);
        Torsion_RE_Position = zeros(length(Time_Eye),1);
        
        % We will use PJB's 'processeyemovements' routine to process the RAW
        % position data into 3D angular velocities. Note that this will be
        % an angular velocity calculation with NO filtering.
        psi =  Horizontal_LE_Position;
        phi = Vertical_LE_Position;
        theta = Torsion_LE_Position;
        Fs = 1100;
        % Computing angular velocity from Fick angular position angles
        angvel_dps_b = [zeros(length(data.plangY(:)),1) ...
            [diff([data.plangY(:)]);false].*1100 ...
            [diff([data.plangZ(:)]);false].*1100];
        
        LE_Vel_X = angvel_dps_b(:,1);
        LE_Vel_Y = angvel_dps_b(:,2);
        LE_Vel_Z = angvel_dps_b(:,3);
        LE_Vel_LARP = zeros(length(angvel_dps_b(:,1)),1);
        LE_Vel_RALP = zeros(length(angvel_dps_b(:,1)),1);
        
        RE_Vel_X = zeros(length(angvel_dps_b(:,1)),1);
        RE_Vel_Y = zeros(length(angvel_dps_b(:,1)),1);
        RE_Vel_Z = zeros(length(angvel_dps_b(:,1)),1);
        RE_Vel_LARP = zeros(length(angvel_dps_b(:,1)),1);
        RE_Vel_RALP = zeros(length(angvel_dps_b(:,1)),1);
        
        Stim = zeros(1,length(Time_Eye));
        
        set(handles.Xoffset_txt,'String',0)
        set(handles.Yoffset_txt,'String',0)
        set(handles.Zoffset_txt,'String',0)
        
        Data.segment_code_version = mfilename;
        Data.raw_filename = handles.raw_FileName;
        Data.LE_Position_X = Torsion_LE_Position;
        Data.LE_Position_Y = Vertical_LE_Position;
        Data.LE_Position_Z = Horizontal_LE_Position;
        
        Data.RE_Position_X = Torsion_RE_Position;
        Data.RE_Position_Y = Vertical_RE_Position;
        Data.RE_Position_Z = Horizontal_RE_Position;
        
        
        Data.LE_Velocity_X = LE_Vel_X;
        Data.LE_Velocity_Y = LE_Vel_Y;
        Data.LE_Velocity_LARP = LE_Vel_LARP;
        Data.LE_Velocity_RALP = LE_Vel_RALP;
        Data.LE_Velocity_Z = LE_Vel_Z;
        
        Data.RE_Velocity_X = RE_Vel_X;
        Data.RE_Velocity_Y = RE_Vel_Y;
        Data.RE_Velocity_LARP = RE_Vel_LARP;
        Data.RE_Velocity_RALP = RE_Vel_RALP;
        Data.RE_Velocity_Z = RE_Vel_Z;
        
        
        Data.HeadMPUVel_X = data.shimmerX;
        Data.HeadMPUVel_Y = data.shimmerY;
        Data.HeadMPUVel_Z = data.shimmerZ;
        
        Data.HeadMPUAccel_X = zeros(length(data.shimmerX),1);
        Data.HeadMPUAccel_Y = zeros(length(data.shimmerX),1);
        Data.HeadMPUAccel_Z = zeros(length(data.shimmerX),1);
        
        Data.Fs = 1100;
        
        Data.Time_Eye = Time_Eye;
        Data.Time_Stim = Time_Stim;
        
        Data.Stim_Trig = Stim;
        handles.string_addon = [];
        handles.load_raw.BackgroundColor = 'green';
        pause(1)
        handles.load_raw.BackgroundColor = [0.94 0.94 0.94];
        guidata(hObject,handles)
    case 4
        if handles.params.reloadflag == 0
            % If requesting a new file, prompt the user to choose the file.
            
            [indx,tf] = listdlg('Name','Gain file options','PromptString',{'If no gainstouse.txt file exists,'; 'choose one of the first'; 'three choices'},...
                'SelectionMode','single',...
                'ListString',{'Ch1Ch2','Ch3Ch4','Both','GainsToUse.txt file exists'},'ListSize',[160 100]);
            switch indx
                case 1
                    [ch1ch2FileNameGains,ch1ch2PathNameGains,FilterIndex] = uigetfile('*.coil','Please choose the Ch1Ch2 Gain file');
                    [gains,handles.FileNameGains] = gainExtraction(ch1ch2PathNameGains,ch1ch2FileNameGains,[]);
                    handles.PathNameGains = ch1ch2PathNameGains;
                case 2
                    [ch3ch4FileNameGains,ch3ch4PathNameGains,FilterIndex] = uigetfile('*.coil','Please choose the Ch3Ch4 Gain file');
                    [gains,handles.FileNameGains] = gainExtraction(ch3ch4PathNameGains,[],ch3ch4FileNameGains);
                    handles.PathNameGains = ch3ch4PathNameGains;
                case 3
                    [ch1ch2FileNameGains,ch1ch2PathNameGains,FilterIndex] = uigetfile('*.coil','Please choose the Ch1Ch2 Gain file');
                    [ch3ch4FileNameGains,ch3ch4PathNameGains,FilterIndex] = uigetfile('*.coil','Please choose the Ch3Ch4 Gain file');
                    [gains,handles.FileNameGains] = gainExtraction(ch1ch2PathNameGains,ch1ch2FileNameGains,ch3ch4FileNameGains);
                    handles.PathNameGains = ch1ch2PathNameGains;
                case 4
                    [handles.FileNameGains,handles.PathNameGains,FilterIndex] = uigetfile('*.txt','Please choose the Gain file');
            end
            
            
            cd(handles.PathNameGains);
            [handles.FileNameOffset1,handles.PathNameOffset1,FilterIndex] = uigetfile('*.coil','Please choose the First Orientation Offset file');
            [handles.FileNameOffset2,handles.PathNameOffset2,FilterIndex] = uigetfile('*.coil','Please choose the Second Orientation Offset file');
            handles.PathNameofFiles = uigetdir(cd,'Please choose the folder where the coil files are saved');
            handles.segment_number.String = '0';
            handles.experimentdata = {};
            handles.deletedInds = [];
            handles.deletedInds.startInds = [];
            handles.deletedInds.locs = [];
            handles.timesExported = 0;
            eyesRecorded = figure;
            eyesRecorded.Units = 'normalized';
            eyesRecorded.Position = [1.4    0.4    0.075    0.15];
            handles.leftEye = uicontrol(eyesRecorded,'Style','checkbox','String','Left Eye');
            handles.leftEye.Units = 'normalized';
            handles.leftEye.Position = [0.03    0.5    0.5 .5];
            handles.rightEye = uicontrol(eyesRecorded,'Style','checkbox','String','Right Eye');
            handles.rightEye.Units = 'normalized';
            handles.rightEye.Position = [0.5 0.5 .5 .5];
            handles.leftEyeCh = uicontrol(eyesRecorded,'Style','listbox','String',{' ','Ch1Ch2','Ch3Ch4'},'Value',3);
            handles.leftEyeCh.Units = 'normalized';
            handles.leftEyeCh.Position = [0.03    0.3    0.410    0.3000];
            handles.rightEyeCh = uicontrol(eyesRecorded,'Style','listbox','String',{' ','Ch1Ch2','Ch3Ch4'},'Value',2);
            handles.rightEyeCh.Units = 'normalized';
            handles.rightEyeCh.Position = [0.5    0.3    0.410    0.3000];
            handles.eyes = uicontrol(eyesRecorded,'Style','radiobutton','String','ok');
            handles.eyes.Units = 'normalized';
            handles.eyes.Position = [0.3    0.05    0.5    0.2000];
            handles.eyes.FontSize = 18;
            waitfor(handles.eyes,'Value');
            
            
            if handles.leftEye.Value == 0
                handles.EyeCh = handles.leftEyeCh.String{2};
                handles.eye_rec.Value = 4;
                
            elseif handles.rightEye.Value == 0
                handles.EyeCh = handles.rightEyeCh.String{3};
                handles.eye_rec.Value = 3;
            else
                handles.EyeCh = {handles.rightEyeCh.String{2},handles.rightEyeCh.String{3}};
                handles.eye_rec.Value = 2;
            end
            handles.text53.BackgroundColor = [0.94 0.94 0.94];
            delete(eyesRecorded)
            
        else
            handles.segment_number.String = '0';
            handles.exp_spread_sheet_name.String = '';
            handles.worksheet_name.String = '';
            handles.experimentdata = {};
            setappdata(handles.export_data,'data','')
            handles.exportCond = 0;
            handles.timesExported = 0;
            handles.whereToStartExp = 1;
            handles.prevExportSize = 0;
        end
        guidata(hObject,handles)
    case 5 % Lasker System VORDAQ
          if handles.params.reloadflag == 0
        handles.filepath = uigetdir('','Choose Directory For .0000 Files');
        cd(handles.filepath)
        handles.listing = dir(handles.filepath);
        handles.listing(~contains({handles.listing.name},'.0000')) = [];
        handles.listing(contains({handles.listing.name},'.lvs')) = [];
        handles.listing(contains({handles.listing.name},'.txt')) = [];
        fig = uifigure('Position', [885   378   300   535]);
        fig.WindowKeyPressFcn = @confirmFiles;
        lbx = uilistbox(fig);
        lbx.Position = [10 10 280 430];
        lbx.Items = {'',handles.listing.name};
        lbx.Multiselect = 'on';
        t = uitextarea(fig,'Value',{'Highlight the FIRST (EMPTY) line if you would like to segment all files.'; 'Otherwise, ctrl+click all files you do not want to segment.'; 'Then click enter'});
        t.Position = [5 445 290 80];        
        uiwait(fig)
        if isempty(lbx.Value{1})
        else
            items = lbx.Items(2:end);
        handles.listing(contains(items,lbx.Value)) = [];
        end
        lbx.Items = {handles.listing.name};

        close(fig)
        count = 0;
        if isfile('zerosAndGains.mat')
            load('zerosAndGains.mat');
            coilzeros = CaF(1,:);
            FieldGains = CaF(2,:);
        else
            fig = uifigure('Position', [432 412 750 160]);
            fig.WindowKeyPressFcn = @confirmFiles;
            z = uilabel(fig,'Position',[10 80 40 20],'Text','Zeros:');
            zero1 = uieditfield(fig,'numeric','Position',[50 80 50 22]);
            zero2 = uieditfield(fig,'numeric','Position',[105 80 50 22]);
            zero3 = uieditfield(fig,'numeric','Position',[160 80 50 22]);
            zero4 = uieditfield(fig,'numeric','Position',[215 80 50 22]);
            zero5 = uieditfield(fig,'numeric','Position',[270 80 50 22]);
            zero6 = uieditfield(fig,'numeric','Position',[325 80 50 22]);
            zero7 = uieditfield(fig,'numeric','Position',[380 80 50 22]);
            zero8 = uieditfield(fig,'numeric','Position',[435 80 50 22]);
            zero9 = uieditfield(fig,'numeric','Position',[490 80 50 22]);
            zero10 = uieditfield(fig,'numeric','Position',[545 80 50 22]);
            zero11 = uieditfield(fig,'numeric','Position',[600 80 50 22]);
            zero12 = uieditfield(fig,'numeric','Position',[655 80 50 22]);
            g = uilabel(fig,'Position',[10 40 40 20],'Text','Gains:');
            g1 = uieditfield(fig,'numeric','Position',[50 40 50 22]);
            g2 = uieditfield(fig,'numeric','Position',[105 40 50 22]);
            g3 = uieditfield(fig,'numeric','Position',[160 40 50 22]);
            g4 = uieditfield(fig,'numeric','Position',[215 40 50 22]);
            g5 = uieditfield(fig,'numeric','Position',[270 40 50 22]);
            g6 = uieditfield(fig,'numeric','Position',[325 40 50 22]);
            g7 = uieditfield(fig,'numeric','Position',[380 40 50 22]);
            g8 = uieditfield(fig,'numeric','Position',[435 40 50 22]);
            g9 = uieditfield(fig,'numeric','Position',[490 40 50 22]);
            g10 = uieditfield(fig,'numeric','Position',[545 40 50 22]);
            g11 = uieditfield(fig,'numeric','Position',[600 40 50 22]);
            g12 = uieditfield(fig,'numeric','Position',[655 40 50 22]);
            ch = uilabel(fig,'Position',[50 100 655 15],'Text','CH1 - X     CH1 - Y    CH1 - Z   CH2 - X    CH2 - Y    CH2 - Z   CH3 - X    CH3 - Y    CH3 - Z   CH4 - X    CH4 - Y    CH4 - Z');
            uiwait(fig)
            coilzeros = [zero1.Value zero2.Value zero3.Value zero4.Value...
                zero5.Value zero6.Value zero7.Value zero8.Value...
                zero9.Value zero10.Value zero11.Value zero12.Value];
            FieldGains = [g1.Value g2.Value g3.Value g4.Value...
                g5.Value g6.Value g7.Value g8.Value...
                g9.Value g10.Value g11.Value g12.Value];
            CaF = [coilzeros; FieldGains];
            save('zerosAndGains.mat','CaF')
            close(fig)
        end
        if any(FieldGains(1:6)==0)
            handles.eye_rec.Value = 4;
        elseif any(FieldGains(7:end)==0)
            handles.eye_rec.Value = 3;
        else
            handles.eye_rec.Value = 2;
        end
           
        
        data_rot = 2;
        DAQ_code = 1;
        OutputFormat = 2;
                    handles.choice = [];
                    f=figure('Name','Choose the stimulator channels that correspond to the canal');
                f.Position = [600 278 450 290];
                set1_stimNum = uicontrol(f,'Style','listbox','String',{'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15'},'Max',15,'Min',0,'Value',[7:9],'Position',[300 5 130 215]);
                set1_stimCanal = uicontrol(f,'Style','popupmenu','String',{'LHRH','RALP','LARP'},'Value',1,'fontsize',8,'Position',[305 225 100 30]);
                set2_stimNum = uicontrol(f,'Style','listbox','String',{'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15'},'Max',15,'Min',0,'Value',[1:3],'Position',[165 5 130 215]);
                set2_stimCanal = uicontrol(f,'Style','popupmenu','String',{'LHRH','RALP','LARP'},'Value',2,'fontsize',8,'Position',[170 225 100 30]);
                set3_stimNum = uicontrol(f,'Style','listbox','String',{'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15'},'Max',15,'Min',0,'Value',[4:6],'Position',[30 5 130 215]);
                set3_stimCanal = uicontrol(f,'Style','popupmenu','String',{'LHRH','RALP','LARP'},'Value',3,'fontsize',8,'Position',[35 225 100 30]);
                animalEnum = uicontrol(f,'Style','popupmenu','String',{'GiGi','MoMo','Nancy','Yoda','DiDi','Fred'},'Value',1,'fontsize',8,'Position',[200 260 50 25],'CallBack',@changeENum);
                okButton = uicontrol(f,'Style','pushbutton','String','Ok','fontsize',12,'Position',[415 230 30 30],'CallBack',{@ok_axis_Callback, handles});
                uiwait(gcf)
                delete(gcf)
                canalInfo = getappdata(handles.stim_axis,'axisInfo');
        for i = 1:length(handles.listing)
            [Data] = voma__processeyemovements([handles.filepath,'\'],handles.listing(i).name,FieldGains,coilzeros,[],data_rot,DAQ_code,OutputFormat,[]);
            handles.t = 0:1/Data.Fs:(length(Data.Var_x081)-1)/Data.Fs;
            handles.f = figure;
            handles.f.WindowKeyPressFcn = @confirmFiles;
            handles.f.WindowButtonDownFcn = @mouseDownCallback;
            handles.ax = subplot(1,2,1);
            handles.ax.Units = 'pixels';

            handles.plot = plot(handles.ax,handles.t,Data.Var_x081);
                        handles.ax.Title.String = "Click '1' to use this SYNC signal";
            handles.ax2 = subplot(1,2,2);
            handles.ax2.Units = 'pixels';

            handles.plot2 = plot(handles.ax2,handles.t,Data.Var_x087);
                        handles.ax2.Title.String = "Click '2' to use this SYNC signal";
            handles.choice = [];
            guidata(handles.f,handles)
            uiwait(handles.f)
            handles = guidata(handles.f);
            close(handles.f)
            if handles.choice == 1
                Data.Var_x081 = Data.Var_x081;
            elseif handles.choice == 2
                Data.Var_x081 = Data.Var_x087;
            end
            handles.t = 0:1/Data.Fs:(length(Data.Var_x081)-1)/Data.Fs;
            handles.f = figure;
            handles.f.WindowKeyPressFcn = @confirmFiles;
            handles.f.WindowButtonDownFcn = @mouseDownCallback;
            handles.ax = axes(handles.f);
            handles.ax.Units = 'pixels';
            handles.plot = plot(handles.ax,handles.t,Data.Var_x081);
            handles.boundsBegin = [];
            handles.boundsEnd = [];
            if Data.Fs>200
                try
                    final = getFredSeg(Data);
                    handles.boundsBegin = [final.start];
                    handles.boundsEnd = [final.end];
                    hold(handles.ax,'on')
                    plot(handles.ax,handles.t(handles.boundsBegin),Data.Var_x081(handles.boundsBegin),'g*')
                    plot(handles.ax,handles.t(handles.boundsEnd),Data.Var_x081(handles.boundsEnd),'r*')
                    hold(handles.ax,'off')
                    guidata(handles.f,handles)
                catch
                    g = selectBounds(Data);
                    handles.boundsBegin = g.Data.boundsBegin;
                    handles.boundsEnd = g.Data.boundsEnd;
                    guidata(handles.f,handles)
                end
            else
            go = 1;
            k = 1;
            while go
                if length(handles.boundsBegin)>length(handles.boundsEnd)
                    if (Data.Var_x081(k) < mean(Data.Var_x081)) && (Data.Var_x081(k-1)>mean(Data.Var_x081))
                        if k-handles.boundsBegin(end)>40
                        handles.boundsEnd = [handles.boundsEnd k-1];
                        hold(handles.ax,'on')
                        plot(handles.ax,handles.t(k-1),Data.Var_x081(k-1),'r*')
                        hold(handles.ax,'off')
                        end
                    end
                else
                    if k > 1
                        if (Data.Var_x081(k) > mean(Data.Var_x081)) && (Data.Var_x081(k-1)<mean(Data.Var_x081))
                            if length(handles.boundsBegin)==length(handles.boundsEnd)
                                if length(handles.boundsEnd)>0
                                    if k-handles.boundsEnd(end)>20
                                        handles.boundsBegin = [handles.boundsBegin k];
                                    hold(handles.ax,'on')
                                    plot(handles.ax,handles.t(k),Data.Var_x081(k),'g*')
                                    hold(handles.ax,'off')
                                    end
                                else
                                    handles.boundsBegin = [handles.boundsBegin k];
                                    hold(handles.ax,'on')
                                    plot(handles.ax,handles.t(k),Data.Var_x081(k),'g*')
                                    hold(handles.ax,'off')
                                end
                            end
                        end
                    end
                end
                k = k +1;
                if k == length(Data.Var_x081)
                    if length(handles.boundsBegin)>length(handles.boundsEnd)
                        handles.boundsEnd = [handles.boundsEnd k-50];
                        hold(handles.ax,'on')
                        plot(handles.ax,handles.t(k-50),Data.Var_x081(k-50),'r*')
                        hold(handles.ax,'off')
                    end
                    go = 0;
                end
            end
            guidata(handles.f,handles)
            uiwait(handles.f)
            end
            
      
            handles = guidata(handles.f);
            close(handles.f)

            for j = 1:length(handles.boundsBegin)
                
                filename = handles.listing(i).name;
                dashes = find(filename=='-');
                dot = find(filename=='.');
                amp = ['amp',num2str(10+10*(j-1))];
                
                % input all settings
                handles.subj_id.String = {canalInfo.animal};
                handles.visit_number.String = {'NA'};
                dt = filename(1:dashes(3)-1);
                dt = strrep(dt,'-','');
                handles.date.String = dt;
                handles.exp_type.String = {'ElectricalStim'};
                handles.exp_condition.String = {'PulseTrains'};
                handles.stim_frequency.String = {'Sinusoidal0to400'};
                setappdata(handles.stim_frequency,'fq','200');
                stimnum = filename(dashes(7)+1:dashes(8)-1);
                refnum = filename(dashes(6)+1:dashes(7)-1); %was 5 and 6
                handles.stim_type.String = {['stim',stimnum,'ref',refnum]};
                switch stimnum
                    case canalInfo.stimNum{2}'
                        setappdata(handles.stim_axis,'ax',canalInfo.stimCanal{2});
                        handles.stim_axis.String = canalInfo.stimCanal(2);
                        setappdata(handles.stim_type,'type',handles.stim_type.String{1});
                        axSub = 'LP';
                    case canalInfo.stimNum{1}'
                        setappdata(handles.stim_axis,'ax',canalInfo.stimCanal{1});
                        handles.stim_axis.String = canalInfo.stimCanal(1);
                        setappdata(handles.stim_type,'type',handles.stim_type.String{1});
                        axSub = 'LA';
                    case canalInfo.stimNum{3}'
                        setappdata(handles.stim_axis,'ax',canalInfo.stimCanal{3});
                        handles.stim_axis.String = canalInfo.stimCanal(3);
                        setappdata(handles.stim_type,'type',handles.stim_type.String{1});
                        axSub = 'LH';
                end
                inten = {[amp,'baseline200freq2delta200_sinusoidal_',axSub]};
                setappdata(handles.stim_intensity,'intensity',inten{1});
                handles.stim_intensity.String = inten;
                
                [handles] = update_seg_filename(hObject, eventdata, handles);
                
                handles.load_spread_sheet.BackgroundColor = [0.94 0.94 0.94];
                handles.load_spread_sheet.Enable = 'on';
                
                
                
                
                t=0:1/Data.Fs:(handles.boundsEnd(j)-handles.boundsBegin(j))/Data.Fs;
                handles.Fs = Data.Fs;
                handles.f = figure;
                handles.f.Position = [588   558   904   420];
                handles.f.WindowKeyPressFcn = @confirmFiles;
                handles.ax = axes(handles.f);
                handles.ax.Units = 'pixels';
                handles.ax.Position = [73.8000   47.2000  800.0000  342.3000];
                handles.s = (sin(2*pi*2*t))*20+20;
                handles.l = filtfilt(ones(1,5)/5,1,Data.RE_Vel_LARP);
                handles.r = filtfilt(ones(1,5)/5,1,Data.RE_Vel_RALP);
                handles.z = filtfilt(ones(1,5)/5,1,Data.RE_Vel_Z);
                handles.s1 = Data.Var_x081;
                handles.j = j;
                handles.p = [];
                if handles.boundsEnd(j)+50>length(handles.t)
                    bp = handles.boundsBegin(j)-50:handles.boundsEnd(j);
                else
                    bp = handles.boundsBegin(j)-50:handles.boundsEnd(j)+50;
                end
                handles.trig = plot(handles.ax,handles.t(bp),handles.s1(bp));
                hold on
                handles.lPlot = plot(handles.ax,handles.t(bp),handles.l(bp),'g');
                handles.rPlot = plot(handles.ax,handles.t(bp),handles.r(bp),'b');
                handles.zPlot = plot(handles.ax,handles.t(bp),handles.z(bp),'r');
                handles.sPlot = plot(handles.ax,handles.t(handles.boundsBegin(j):handles.boundsEnd(j)),handles.s,'k');
                hold off
                handles.ax.Title.String = handles.seg_filename.String;
                legend(handles.ax,'Trigger','LARP','RALP','LHRH')
                handles.b = uicontrol('Style','pushbutton','String','Time Shift','Callback',@adjustTime);
                ai = strfind(handles.ax.Title.String,'amp');
                bi = strfind(handles.ax.Title.String,'baseline');
                astr = handles.ax.Title.String(ai+3:bi-1);
                handles.a = uicontrol('Style','edit','String',astr,'Callback',@adjustAmp);
                handles.a.Position = [80 5 60 20];
                handles.b.Position = [5 5 60 20];
                handles.ax.YLim = [-200 200];
                guidata(handles.f,handles)
                                if j == 1
                    figure
                    plot(handles.t,handles.s1,'k')
                    hold on
                    plot(handles.t,handles.l,'g');
                    plot(handles.t,handles.r,'b');
                    plot(handles.t,handles.z,'r');
                end
                uiwait(handles.f)
                handles = guidata(handles.f);
                
                if ~isempty(handles.p)
                    Segment.segment_code_version = mfilename;
                Segment.raw_filename = filename;
                t = handles.sPlot.XData-handles.sPlot.XData(1);
                Segment.start_t = t(1);
                Segment.end_t = t(end);
                Segment.LE_Position_X = interp1(handles.rPlot.XData,Data.LE_Pos_X(handles.boundsBegin(j)-50:handles.boundsEnd(j)+50),handles.sPlot.XData);
                Segment.LE_Position_Y = interp1(handles.rPlot.XData,Data.LE_Pos_Y(handles.boundsBegin(j)-50:handles.boundsEnd(j)+50),handles.sPlot.XData);
                Segment.LE_Position_Z = interp1(handles.rPlot.XData,Data.LE_Pos_Z(handles.boundsBegin(j)-50:handles.boundsEnd(j)+50),handles.sPlot.XData);
                
                Segment.RE_Position_X = interp1(handles.rPlot.XData,Data.RE_Pos_X(handles.boundsBegin(j)-50:handles.boundsEnd(j)+50),handles.sPlot.XData)';
                Segment.RE_Position_Y = interp1(handles.rPlot.XData,Data.RE_Pos_Y(handles.boundsBegin(j)-50:handles.boundsEnd(j)+50),handles.sPlot.XData)';
                Segment.RE_Position_Z = interp1(handles.rPlot.XData,Data.RE_Pos_Z(handles.boundsBegin(j)-50:handles.boundsEnd(j)+50),handles.sPlot.XData)';
                
                Segment.LE_Velocity_X = interp1(handles.rPlot.XData,Data.LE_Vel_X(handles.boundsBegin(j)-50:handles.boundsEnd(j)+50),handles.sPlot.XData);
                Segment.LE_Velocity_Y = interp1(handles.rPlot.XData,Data.LE_Vel_Y(handles.boundsBegin(j)-50:handles.boundsEnd(j)+50),handles.sPlot.XData);
                Segment.LE_Velocity_LARP = interp1(handles.rPlot.XData,Data.LE_Vel_LARP(handles.boundsBegin(j)-50:handles.boundsEnd(j)+50),handles.sPlot.XData);
                Segment.LE_Velocity_RALP = interp1(handles.rPlot.XData,Data.LE_Vel_RALP(handles.boundsBegin(j)-50:handles.boundsEnd(j)+50),handles.sPlot.XData);
                Segment.LE_Velocity_Z = interp1(handles.rPlot.XData,Data.LE_Vel_Z(handles.boundsBegin(j)-50:handles.boundsEnd(j)+50),handles.sPlot.XData);
                
                Segment.RE_Velocity_X = interp1(handles.rPlot.XData,Data.RE_Vel_X(handles.boundsBegin(j)-50:handles.boundsEnd(j)+50),handles.sPlot.XData)';
                Segment.RE_Velocity_Y = interp1(handles.rPlot.XData,Data.RE_Vel_Y(handles.boundsBegin(j)-50:handles.boundsEnd(j)+50),handles.sPlot.XData)';
                Segment.RE_Velocity_LARP = interp1(handles.rPlot.XData,Data.RE_Vel_LARP(handles.boundsBegin(j)-50:handles.boundsEnd(j)+50),handles.sPlot.XData)';
                Segment.RE_Velocity_RALP = interp1(handles.rPlot.XData,Data.RE_Vel_RALP(handles.boundsBegin(j)-50:handles.boundsEnd(j)+50),handles.sPlot.XData)';
                Segment.RE_Velocity_Z = interp1(handles.rPlot.XData,Data.RE_Vel_Z(handles.boundsBegin(j)-50:handles.boundsEnd(j)+50),handles.sPlot.XData)';
                if any(isnan(Segment.LE_Position_X))
                    Segment.LE_Position_X = zeros(length(Segment.RE_Position_X),1);
                    Segment.LE_Position_Y = zeros(length(Segment.RE_Position_X),1);
                    Segment.LE_Position_Z = zeros(length(Segment.RE_Position_X),1);
                    Segment.LE_Velocity_X = zeros(length(Segment.RE_Position_X),1);
                    Segment.LE_Velocity_Y = zeros(length(Segment.RE_Position_X),1);
                    Segment.LE_Velocity_LARP = zeros(length(Segment.RE_Position_X),1);
                    Segment.LE_Velocity_RALP = zeros(length(Segment.RE_Position_X),1);
                    Segment.LE_Velocity_Z = zeros(length(Segment.RE_Position_X),1);
                elseif any(isnan(Segment.RE_Position_X))
                    Segment.RE_Position_X = zeros(length(Segment.LE_Position_X),1);
                    Segment.RE_Position_Y = zeros(length(Segment.LE_Position_X),1);
                    Segment.RE_Position_Z = zeros(length(Segment.LE_Position_X),1);
                        Segment.RE_Velocity_X = zeros(length(Segment.LE_Position_X),1);
                        Segment.RE_Velocity_Y = zeros(length(Segment.LE_Position_X),1);
                        Segment.RE_Velocity_LARP = zeros(length(Segment.LE_Position_X),1);
                        Segment.RE_Velocity_RALP = zeros(length(Segment.LE_Position_X),1);
                        Segment.RE_Velocity_Z = zeros(length(Segment.LE_Position_X),1);
                    end
                    Segment.Fs = Data.Fs;
                    
                    Stim_Interp = (sin(2*pi*2*t))*20+20;
                    Time_Stim = t';
                    Segment.Time_Eye =  Time_Stim;
                    Segment.Time_Stim = Time_Stim;
                    
                    Segment.HeadMPUVel_X = zeros(1,length(Stim_Interp))';
                    Segment.HeadMPUVel_Y = zeros(1,length(Stim_Interp))';
                    Segment.HeadMPUVel_Z = Stim_Interp';
                    
                    Segment.HeadMPUAccel_X = zeros(1,length(Stim_Interp))';
                    Segment.HeadMPUAccel_Y = zeros(1,length(Stim_Interp))';
                    Segment.HeadMPUAccel_Z = zeros(1,length(Stim_Interp))';
                    Segment.EyesRecorded = handles.eye_rec.String(handles.eye_rec.Value);
                else
                t=0:1/Data.Fs:(handles.boundsEnd(j)-handles.boundsBegin(j))/Data.Fs;
                Segment.segment_code_version = mfilename;
                Segment.raw_filename = filename;
                Segment.start_t = t(1);
                Segment.end_t = t(end);
                Segment.LE_Position_X = Data.LE_Pos_X(handles.boundsBegin(j):handles.boundsEnd(j));
                Segment.LE_Position_Y = Data.LE_Pos_Y(handles.boundsBegin(j):handles.boundsEnd(j));
                Segment.LE_Position_Z = Data.LE_Pos_Z(handles.boundsBegin(j):handles.boundsEnd(j));
                
                Segment.RE_Position_X = Data.RE_Pos_X(handles.boundsBegin(j):handles.boundsEnd(j));
                Segment.RE_Position_Y = Data.RE_Pos_Y(handles.boundsBegin(j):handles.boundsEnd(j));
                Segment.RE_Position_Z = Data.RE_Pos_Z(handles.boundsBegin(j):handles.boundsEnd(j));
                
                Segment.LE_Velocity_X = Data.LE_Vel_X(handles.boundsBegin(j):handles.boundsEnd(j));
                Segment.LE_Velocity_Y = Data.LE_Vel_Y(handles.boundsBegin(j):handles.boundsEnd(j));
                Segment.LE_Velocity_LARP = Data.LE_Vel_LARP(handles.boundsBegin(j):handles.boundsEnd(j));
                Segment.LE_Velocity_RALP = Data.LE_Vel_RALP(handles.boundsBegin(j):handles.boundsEnd(j));
                Segment.LE_Velocity_Z = Data.LE_Vel_Z(handles.boundsBegin(j):handles.boundsEnd(j));
                
                Segment.RE_Velocity_X = Data.RE_Vel_X(handles.boundsBegin(j):handles.boundsEnd(j));
                Segment.RE_Velocity_Y = Data.RE_Vel_Y(handles.boundsBegin(j):handles.boundsEnd(j));
                Segment.RE_Velocity_LARP = Data.RE_Vel_LARP(handles.boundsBegin(j):handles.boundsEnd(j));
                Segment.RE_Velocity_RALP = Data.RE_Vel_RALP(handles.boundsBegin(j):handles.boundsEnd(j));
                Segment.RE_Velocity_Z = Data.RE_Vel_Z(handles.boundsBegin(j):handles.boundsEnd(j));
                if any(isnan(Segment.LE_Position_X))
                    Segment.LE_Position_X = zeros(length(Segment.RE_Position_X),1);
                    Segment.LE_Position_Y = zeros(length(Segment.RE_Position_X),1);
                    Segment.LE_Position_Z = zeros(length(Segment.RE_Position_X),1);
                    Segment.LE_Velocity_X = zeros(length(Segment.RE_Position_X),1);
                    Segment.LE_Velocity_Y = zeros(length(Segment.RE_Position_X),1);
                    Segment.LE_Velocity_LARP = zeros(length(Segment.RE_Position_X),1);
                    Segment.LE_Velocity_RALP = zeros(length(Segment.RE_Position_X),1);
                    Segment.LE_Velocity_Z = zeros(length(Segment.RE_Position_X),1);
                elseif any(isnan(Segment.RE_Position_X))
                    Segment.RE_Position_X = zeros(length(Segment.LE_Position_X),1);
                    Segment.RE_Position_Y = zeros(length(Segment.LE_Position_X),1);
                    Segment.RE_Position_Z = zeros(length(Segment.LE_Position_X),1);
                    Segment.RE_Velocity_X = zeros(length(Segment.LE_Position_X),1);
                    Segment.RE_Velocity_Y = zeros(length(Segment.LE_Position_X),1);
                    Segment.RE_Velocity_LARP = zeros(length(Segment.LE_Position_X),1);
                    Segment.RE_Velocity_RALP = zeros(length(Segment.LE_Position_X),1);
                    Segment.RE_Velocity_Z = zeros(length(Segment.LE_Position_X),1);
                end
                Segment.Fs = Data.Fs;
                
                Stim_Interp = (sin(2*pi*2*t))*20+20;
                Time_Stim = t';
                Segment.Time_Eye = Time_Stim;
                Segment.Time_Stim = Time_Stim;
                
                Segment.HeadMPUVel_X = zeros(1,length(Stim_Interp))';
                Segment.HeadMPUVel_Y = zeros(1,length(Stim_Interp))';
                Segment.HeadMPUVel_Z = Stim_Interp;
                
                Segment.HeadMPUAccel_X = zeros(1,length(Stim_Interp))';
                Segment.HeadMPUAccel_Y = zeros(1,length(Stim_Interp))';
                Segment.HeadMPUAccel_Z = zeros(1,length(Stim_Interp))';
                Segment.EyesRecorded = handles.eye_rec.String(handles.eye_rec.Value);
                if exist('final')
                    if Data.Fs == 1000
                        Segment.stim_ind = [final(j).Inds]-[final(j).Inds(1)];
                    end
                end
                end
                
                handles.Segment = Segment;
                
                segments = str2num(handles.segment_number.String);
                if segments == 0
                    mkdir([handles.listing(1).folder,handles.ispc.slash,'Segments',handles.ispc.slash])
                    setappdata(handles.save_segment,'foldername',[handles.listing(1).folder,handles.ispc.slash,'Segments',handles.ispc.slash]);
                end
                
                
                
                handles.string_addon = [];
                if ~handles.skipFlag
                    [handles]=save_segment_Callback(hObject, eventdata, handles);
                    count = count +1;
                else
                    count = count +1;
                    segments = count;
                    handles.experimentdata{segments,1} = [handles.seg_filename.String handles.string_addon];
                    handles.experimentdata{segments,2} = [handles.date.String(5:6),'/',handles.date.String(7:8),'/',handles.date.String(1:4)];
                    handles.experimentdata{segments,3} = handles.subj_id.String{handles.subj_id.Value};
                    handles.experimentdata{segments,4} = handles.implant.String{handles.implant.Value};
                    handles.experimentdata{segments,5} = handles.eye_rec.String{handles.eye_rec.Value};
                    handles.experimentdata{segments,9} = [handles.exp_type.String{handles.exp_type.Value},'-',handles.exp_condition.String{handles.exp_condition.Value},'-',handles.stim_type.String{handles.stim_type.Value}];
                    handles.experimentdata{segments,10} = handles.stim_axis.String{handles.stim_axis.Value};
                    stim_freq = handles.stim_frequency.String{handles.stim_frequency.Value};
                    handles.experimentdata{segments,12} = str2double(stim_freq);
                    stim_int = handles.stim_intensity.String{handles.stim_intensity.Value};
                    dps = find(handles.stim_intensity.String{handles.stim_intensity.Value} == 'd');
                    stim_int(dps:end) = [];
                    handles.experimentdata{segments,13} = str2num(stim_int);
                    handles.experimentdata{segments,14} = [];
                    handles.experimentdata{segments,15} = [];
                    handles.experimentdata{segments,16} = [];
                    handles.experimentdata{segments,17} = [];
                    setappdata(handles.export_data,'data',handles.experimentdata);
                end
               
                b = handles.boundsBegin(j)-Data.Fs*2.5:handles.boundsBegin(j);
                if any(b<=0)
                    b = 1:handles.boundsBegin(j);
                end
                t=0:1/Data.Fs:(length(b)-1)/Data.Fs;
                Segment.segment_code_version = mfilename;
                Segment.raw_filename = filename;
                Segment.start_t = t(1);
                Segment.end_t = t(end);
                Segment.LE_Position_X = Data.LE_Pos_X(b);
                Segment.LE_Position_Y = Data.LE_Pos_Y(b);
                Segment.LE_Position_Z = Data.LE_Pos_Z(b);
                
                Segment.RE_Position_X = Data.RE_Pos_X(b);
                Segment.RE_Position_Y = Data.RE_Pos_Y(b);
                Segment.RE_Position_Z = Data.RE_Pos_Z(b);
                
                Segment.LE_Velocity_X = Data.LE_Vel_X(b);
                Segment.LE_Velocity_Y = Data.LE_Vel_Y(b);
                Segment.LE_Velocity_LARP = Data.LE_Vel_LARP(b);
                Segment.LE_Velocity_RALP = Data.LE_Vel_RALP(b);
                Segment.LE_Velocity_Z = Data.LE_Vel_Z(b);
                
                Segment.RE_Velocity_X = Data.RE_Vel_X(b);
                Segment.RE_Velocity_Y = Data.RE_Vel_Y(b);
                Segment.RE_Velocity_LARP = Data.RE_Vel_LARP(b);
                Segment.RE_Velocity_RALP = Data.RE_Vel_RALP(b);
                Segment.RE_Velocity_Z = Data.RE_Vel_Z(b);
                if any(isnan(Segment.LE_Position_X))
                    Segment.LE_Position_X = zeros(length(Segment.RE_Position_X),1);
                    Segment.LE_Position_Y = zeros(length(Segment.RE_Position_X),1);
                    Segment.LE_Position_Z = zeros(length(Segment.RE_Position_X),1);
                    Segment.LE_Velocity_X = zeros(length(Segment.RE_Position_X),1);
                    Segment.LE_Velocity_Y = zeros(length(Segment.RE_Position_X),1);
                    Segment.LE_Velocity_LARP = zeros(length(Segment.RE_Position_X),1);
                    Segment.LE_Velocity_RALP = zeros(length(Segment.RE_Position_X),1);
                    Segment.LE_Velocity_Z = zeros(length(Segment.RE_Position_X),1);
                elseif any(isnan(Segment.RE_Position_X))
                    Segment.RE_Position_X = zeros(length(Segment.LE_Position_X),1);
                    Segment.RE_Position_Y = zeros(length(Segment.LE_Position_X),1);
                    Segment.RE_Position_Z = zeros(length(Segment.LE_Position_X),1);
                    Segment.RE_Velocity_X = zeros(length(Segment.LE_Position_X),1);
                    Segment.RE_Velocity_Y = zeros(length(Segment.LE_Position_X),1);
                    Segment.RE_Velocity_LARP = zeros(length(Segment.LE_Position_X),1);
                    Segment.RE_Velocity_RALP = zeros(length(Segment.LE_Position_X),1);
                    Segment.RE_Velocity_Z = zeros(length(Segment.LE_Position_X),1);
                end
                Segment.Fs = Data.Fs;
                
                Stim_Interp = (sin(2*pi*2*t))*20+20;
                Time_Stim = t';
                Segment.Time_Eye = Time_Stim;
                Segment.Time_Stim = Time_Stim;
                
                Segment.HeadMPUVel_X = zeros(1,length(Stim_Interp))';
                Segment.HeadMPUVel_Y = zeros(1,length(Stim_Interp))';
                Segment.HeadMPUVel_Z = Stim_Interp;
                
                Segment.HeadMPUAccel_X = zeros(1,length(Stim_Interp))';
                Segment.HeadMPUAccel_Y = zeros(1,length(Stim_Interp))';
                Segment.HeadMPUAccel_Z = zeros(1,length(Stim_Interp))';
                Segment.EyesRecorded = handles.eye_rec.String(handles.eye_rec.Value);
                if exist('final')
                    if Data.Fs == 1000
                        Segment.stim_ind = [final(j).Inds]-[final(j).Inds(1)];
                    end
                end
                handles.params.segment_filename = handles.seg_filename.String;
                
                if isempty(getappdata(handles.save_segment,'foldername')) || (numel(getappdata(handles.save_segment,'foldername'))==1 && (getappdata(handles.save_segment,'foldername')==0))
                    folder_name = {uigetdir('','Select Directory to Save the Segmented Data')};
                    setappdata(handles.save_segment,'foldername',folder_name{1});
                    cd(folder_name{1})
                else
                    
                    cd(getappdata(handles.save_segment,'foldername'))
                end
                
                d = struct();
                d.Data = Segment;
                
                handles.string_addon = 'PRESTIM';
                save([handles.params.segment_filename handles.string_addon '.mat'],'-struct','d')

                close(handles.f)
                handles.segment_number.String = num2str(count);
            end
            
            
        end
        
                        if handles.timesExported ==0
                            handles.ss_FileName = [handles.subj_id.String{handles.subj_id.Value} '_ExperimentRecords'];
                            set(handles.exp_spread_sheet_name,'String',[handles.ss_FileName '.mat']);
                            handles.exportCond = 3;
                            guidata(hObject,handles)
                            handles = export_data_Callback(hObject, eventdata, handles);
                        else
                            handles.exportCond = 2;
                            guidata(hObject,handles)
                            handles = export_data_Callback(hObject, eventdata, handles);
                        end
          else
              handles.segment_number.String = '0';
            handles.exp_spread_sheet_name.String = '';
            handles.worksheet_name.String = '';
            handles.experimentdata = {};
            setappdata(handles.export_data,'data','')
            handles.exportCond = 0;
            handles.timesExported = 0;
            handles.whereToStartExp = 1;
            handles.prevExportSize = 0;
                        
          end
    otherwise
        
        
        guidata(hObject,handles)
end
function adjustAmp(figHandle,varargin)
    h = guidata(figHandle);                
    nai = strfind(h.ax.Title.String,'amp');
    nbi = strfind(h.ax.Title.String,'baseline');
    nastr = h.ax.Title.String(nai+3:nbi-1);
    h.ax.Title.String = strrep(h.ax.Title.String,['amp',nastr],['amp',h.a.String]);
    h.seg_filename.String = strrep(h.seg_filename.String,['amp',nastr],['amp',h.a.String]);
    h.stim_intensity.String = strrep(h.stim_intensity.String,['amp',nastr],['amp',h.a.String]);
    setappdata(h.stim_intensity,'intensity',h.stim_intensity.String{1});
    guidata(figHandle,h)
end
function adjustTime(figHandle,varargin)
    h = guidata(figHandle);
    if contains(h.stim_axis.String,'LARP')
        ydID = find(ismember(h.lPlot.XData,h.sPlot.XData));
        h.p = sinShift(h.sPlot.XData,h.sPlot.YData,h.lPlot.YData(ydID));
    elseif contains(h.stim_axis.String,'RALP')
        ydID = find(ismember(h.rPlot.XData,h.sPlot.XData));
        h.p = sinShift(h.sPlot.XData,h.sPlot.YData,h.rPlot.YData(ydID));
    elseif contains(h.stim_axis.String,'LHRH')
        ydID = find(ismember(h.zPlot.XData,h.sPlot.XData));
        h.p = sinShift(h.sPlot.XData,h.sPlot.YData,h.zPlot.YData(ydID));
    end
    h.trig.XData = (h.trig.XData-h.p(2))/h.p(1);
    h.lPlot.XData = (h.lPlot.XData-h.p(2))/h.p(1);
    h.rPlot.XData = (h.rPlot.XData-h.p(2))/h.p(1);
    h.zPlot.XData = (h.zPlot.XData-h.p(2))/h.p(1);
    guidata(figHandle,h)
    
end
function mouseDownCallback(figHandle,varargin)
% get the handles structure
h = guidata(figHandle);
% get the position where the mouse button was pressed (not released)
% within the GUI
if contains(figHandle.SelectionType,'normal')
    currentPoint = get(figHandle, 'CurrentPoint');
    x1            = currentPoint(1,1);
    y            = currentPoint(1,2);
    % get the position of the axes within the GUI
    axesPos = get(h.ax,'Position');
    minx    = axesPos(1);
    miny    = axesPos(2);
    maxx    = minx + axesPos(3);
    maxy    = miny + axesPos(4);
    % is the mouse down event within the axes?
    if x1>=minx && x1<=maxx && y>=miny && y<=maxy
        % do we have graphics objects?
            % get the position of the mouse down event within the axes
            currentPoint = get(h.ax, 'CurrentPoint');
            x1            = currentPoint(2,1);
            y            = currentPoint(2,2);
            % we are going to use the x and y data for each graphic object
            % and determine which one is closest to the mouse down event
            minDist      = Inf;
            minHndl      = 0;
            minHndlInd = 0;
            for k1=1:length(h.ax.Children)-1
                if strcmp(h.ax.Children(k1).Marker,'*')
                xData = get(h.ax.Children(k1),'XData');
                yData = get(h.ax.Children(k1),'YData');
                dist  = min((xData-x1).^2+(yData-y).^2);
                end
                if dist<15
                if dist<minDist
                    minHndl = h.ax.Children(k1);
                    minHndlInd = k1;
                    minDist = dist;
                end
                end
            end
            % if we have a graphics handle that is close to the mouse down
            % event/position, then save the data
            if minHndl~=0
                if ~rem(minHndlInd,2)
                    findTDE = find(h.t(h.boundsEnd)==h.ax.Children(minHndlInd-1).XData);
                    findTDB = find(h.t(h.boundsBegin)==h.ax.Children(minHndlInd).XData);
                    h.boundsBegin(findTDB) = [];
                    h.boundsEnd(findTDE) = [];
                    delete(h.ax.Children(minHndlInd-1:minHndlInd))
                else
                    findTDE = find(h.t(h.boundsEnd)==h.ax.Children(minHndlInd).XData);
                    findTDB = find(h.t(h.boundsBegin)==h.ax.Children(minHndlInd+1).XData);
                    h.boundsBegin(findTDB) = [];
                    h.boundsEnd(findTDE) = [];
                    delete(h.ax.Children(minHndlInd:minHndlInd+1))
                end
                guidata(figHandle,h)

            end
    end

elseif contains(figHandle.SelectionType,'alt')
    currentPoint = get(figHandle, 'CurrentPoint');
    x1            = currentPoint(1,1);
    y            = currentPoint(1,2);
    % get the position of the axes within the GUI
    axesPos = get(h.ax,'Position');
    minx    = axesPos(1);
    miny    = axesPos(2);
    maxx    = minx + axesPos(3);
    maxy    = miny + axesPos(4);
    % is the mouse down event within the axes?
    if x1>=minx && x1<=maxx && y>=miny && y<=maxy
        % do we have graphics objects?
            % get the position of the mouse down event within the axes
            currentPoint = get(h.ax, 'CurrentPoint');
            x1            = currentPoint(2,1);
            y            = currentPoint(2,2);
            % we are going to use the x and y data for each graphic object
            % and determine which one is closest to the mouse down event
            minDist      = Inf;
            minHndl      = 0;
            minHndlInd = 0;
            for k1=1:length(h.ax.Children)-1
                if strcmp(h.ax.Children(k1).Marker,'*')
                xData = get(h.ax.Children(k1),'XData');
                yData = get(h.ax.Children(k1),'YData');
                dist  = min((xData-x1).^2+(yData-y).^2);
                end
                if dist<minDist
                    minHndl = h.ax.Children(k1);
                    minHndlInd = k1;
                    minDist = dist;
                end
            end
            % if we have a graphics handle that is close to the mouse down
            % event/position, then save the data
            if minHndl~=0
                if ~rem(minHndlInd,2)
                    findTDE = find(h.t(h.boundsEnd)==h.ax.Children(minHndlInd-1).XData);
                    findTDB = find(h.t(h.boundsBegin)==h.ax.Children(minHndlInd).XData);
                    [~,newBeg] = min(abs(h.t-(x1+.125)));
                    [~,newEnd] = min(abs(h.t-(x1-.125)));
                    h.boundsBegin  = [h.boundsBegin(1:findTDB) newBeg h.boundsBegin(findTDB+1:end)];
                    h.boundsEnd = [h.boundsEnd(1:findTDE-1) newEnd h.boundsEnd(findTDE:end)];
                    hold(h.ax,'on')
                    plot(h.ax,h.t(newBeg),h.ax.Children(end).YData(newBeg),'g*')
                    plot(h.ax,h.t(newEnd),h.ax.Children(end).YData(newEnd),'r*')
                    hold(h.ax,'off')
                else
                    findTDE = find(h.t(h.boundsEnd)==h.ax.Children(minHndlInd).XData);
                    findTDB = find(h.t(h.boundsBegin)==h.ax.Children(minHndlInd+1).XData);
                    [~,newBeg] = min(abs(h.t-(x1+.125)));
                    [~,newEnd] = min(abs(h.t-(x1-.125)));
                    h.boundsBegin  = [h.boundsBegin(1:findTDB) newBeg h.boundsBegin(findTDB+1:end)];
                    h.boundsEnd = [h.boundsEnd(1:findTDE-1) newEnd h.boundsEnd(findTDE:end)];
                    hold(h.ax,'on')
                    plot(h.ax,h.t(newBeg),h.ax.Children(end).YData(newBeg),'g*')
                    plot(h.ax,h.t(newEnd),h.ax.Children(end).YData(newEnd),'r*')
                    hold(h.ax,'off')
                end
                guidata(figHandle,h)

            end
    end
end
end

function confirmFiles(fig,varargin)
    h = guidata(fig);
        key = varargin{1};
        if strcmp(key.Key,'return')
            h.skipFlag = 0;
            guidata(fig,h);
            uiresume(fig)
        end
        if strcmp(key.Key,'space')
            h.skipFlag = 1;
            guidata(fig,h);
            uiresume(fig)
        end
        if strcmp(key.Key,'a')
            h.boundsBegin(h.j) = h.boundsBegin(h.j)-3;
            t1=0:1/h.Fs:(h.boundsEnd(h.j)-h.boundsBegin(h.j))/h.Fs;
            h.s = (sin(2*pi*2*t1))*20+20;
            y = h.ax.YLim;
            xl = h.ax.XLim;
            if ~isempty(h.p)
                sub = h.p(2);
                div = h.p(1);
            else
                sub = 0;
                div = 1;
            end
            h.trig.XData = (h.t(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50)-sub)/div;
            h.trig.YData = h.s1(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50);
            h.lPlot.XData = (h.t(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50)-sub)/div;
            h.lPlot.YData = h.l(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50);
            h.rPlot.XData = (h.t(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50)-sub)/div;
            h.rPlot.YData = h.r(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50);
            h.zPlot.XData = (h.t(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50)-sub)/div;
            h.zPlot.YData = h.z(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50);
            h.sPlot.XData = h.t(h.boundsBegin(h.j):h.boundsEnd(h.j));
            h.sPlot.YData = h.s;
            h.ax.YLim = y;
            h.ax.XLim = xl;
            guidata(fig,h)
        end
        if strcmp(key.Key,'s')
            h.boundsBegin(h.j) = h.boundsBegin(h.j)+3;
            t1=0:1/h.Fs:(h.boundsEnd(h.j)-h.boundsBegin(h.j))/h.Fs;
            h.s = (sin(2*pi*2*t1))*20+20;
            y = h.ax.YLim;
            xl = h.ax.XLim;
            if ~isempty(h.p)
                sub = h.p(2);
                div = h.p(1);
            else
                sub = 0;
                div = 1;
            end
            h.trig.XData = (h.t(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50)-sub)/div;
            h.trig.YData = h.s1(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50);
            h.lPlot.XData = (h.t(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50)-sub)/div;
            h.lPlot.YData = h.l(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50);
            h.rPlot.XData = (h.t(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50)-sub)/div;
            h.rPlot.YData = h.r(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50);
            h.zPlot.XData = (h.t(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50)-sub)/div;
            h.zPlot.YData = h.z(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50);
            h.sPlot.XData = h.t(h.boundsBegin(h.j):h.boundsEnd(h.j));
            h.sPlot.YData = h.s;
            h.ax.YLim = y;
            h.ax.XLim = xl;
            guidata(fig,h)
        end
        if strcmp(key.Key,'d')
            h.boundsEnd(h.j) = h.boundsEnd(h.j)-3;
            t1=0:1/h.Fs:(h.boundsEnd(h.j)-h.boundsBegin(h.j))/h.Fs;
            h.s = (sin(2*pi*2*t1))*20+20;
            y = h.ax.YLim;
            xl = h.ax.XLim;
            if ~isempty(h.p)
                sub = h.p(2);
                div = h.p(1);
            else
                sub = 0;
                div = 1;
            end
            h.trig.XData = (h.t(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50)-sub)/div;
            h.trig.YData = h.s1(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50);
            h.lPlot.XData = (h.t(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50)-sub)/div;
            h.lPlot.YData = h.l(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50);
            h.rPlot.XData = (h.t(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50)-sub)/div;
            h.rPlot.YData = h.r(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50);
            h.zPlot.XData = (h.t(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50)-sub)/div;
            h.zPlot.YData = h.z(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50);
            h.sPlot.XData = h.t(h.boundsBegin(h.j):h.boundsEnd(h.j));
            h.sPlot.YData = h.s;
            h.ax.YLim = y;
            h.ax.XLim = xl;
            guidata(fig,h)
        end
        if strcmp(key.Key,'f')
            h.boundsEnd(h.j) = h.boundsEnd(h.j)+3;
            t1=0:1/h.Fs:(h.boundsEnd(h.j)-h.boundsBegin(h.j))/h.Fs;
            h.s = (sin(2*pi*2*t1))*20+20;
            y = h.ax.YLim;
            xl = h.ax.XLim;
            if ~isempty(h.p)
                sub = h.p(2);
                div = h.p(1);
            else
                sub = 0;
                div = 1;
            end
            h.trig.XData = (h.t(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50)-sub)/div;
            h.trig.YData = h.s1(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50);
            h.lPlot.XData = (h.t(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50)-sub)/div;
            h.lPlot.YData = h.l(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50);
            h.rPlot.XData = (h.t(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50)-sub)/div;
            h.rPlot.YData = h.r(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50);
            h.zPlot.XData = (h.t(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50)-sub)/div;
            h.zPlot.YData = h.z(h.boundsBegin(h.j)-50:h.boundsEnd(h.j)+50);
            h.sPlot.XData = h.t(h.boundsBegin(h.j):h.boundsEnd(h.j));
            h.sPlot.YData = h.s;
            h.ax.YLim = y;
            h.ax.XLim = xl;
            guidata(fig,h)
        end
        if isempty(h.choice)
        if strcmp(key.Key,'1')
            h.ax.Color = [0 1 0];
            pause(.3);
            h.choice = 1;
            guidata(fig,h)
            uiresume(fig)
        end
        if strcmp(key.Key,'2')
            h.ax2.Color = [0 1 0];
            pause(.3);
            h.choice = 2;
            guidata(fig,h)
            uiresume(fig)
        end
        end
        
end

if handles.params.system_code == 4
else
    
    % Check all saved data variables and make sure they are COLUMN vectors
    if isrow(Data.LE_Position_X)
        Data.LE_Position_X = Data.LE_Position_X';
    end
    if isrow(Data.LE_Position_Y)
        Data.LE_Position_Y = Data.LE_Position_Y';
    end
    if isrow(Data.LE_Position_Z)
        Data.LE_Position_Z = Data.LE_Position_Z';
    end
    if isrow(Data.RE_Position_X)
        Data.RE_Position_X = Data.RE_Position_X';
    end
    if isrow(Data.RE_Position_Y)
        Data.RE_Position_Y = Data.RE_Position_Y';
    end
    if isrow(Data.RE_Position_Z)
        Data.RE_Position_Z = Data.RE_Position_Z';
    end
    if isrow(Data.LE_Velocity_X)
        Data.LE_Velocity_X = Data.LE_Velocity_X';
    end
    if isrow(Data.LE_Velocity_Y)
        Data.LE_Velocity_Y = Data.LE_Velocity_Y';
    end
    if isrow(Data.LE_Velocity_Z)
        Data.LE_Velocity_Z = Data.LE_Velocity_Z';
    end
    if isrow(Data.LE_Velocity_LARP)
        Data.LE_Velocity_LARP = Data.LE_Velocity_LARP';
    end
    if isrow(Data.LE_Velocity_RALP)
        Data.LE_Velocity_RALP = Data.LE_Velocity_RALP';
    end
    if isrow(Data.RE_Velocity_X)
        Data.RE_Velocity_X = Data.RE_Velocity_X';
    end
    if isrow(Data.RE_Velocity_Y)
        Data.RE_Velocity_Y = Data.RE_Velocity_Y';
    end
    if isrow(Data.RE_Velocity_Z)
        Data.RE_Velocity_Z = Data.RE_Velocity_Z';
    end
    if isrow(Data.RE_Velocity_LARP)
        Data.RE_Velocity_LARP = Data.RE_Velocity_LARP';
    end
    if isrow(Data.RE_Velocity_RALP)
        Data.RE_Velocity_RALP = Data.RE_Velocity_RALP';
    end
    if isrow(Data.HeadMPUVel_X)
        Data.HeadMPUVel_X = Data.HeadMPUVel_X';
    end
    if isrow(Data.HeadMPUVel_Y)
        Data.HeadMPUVel_Y = Data.HeadMPUVel_Y';
    end
    if isrow(Data.HeadMPUVel_Z)
        Data.HeadMPUVel_Z = Data.HeadMPUVel_Z';
    end
    if isrow(Data.HeadMPUAccel_X)
        Data.HeadMPUAccel_X = Data.HeadMPUAccel_X';
    end
    if isrow(Data.HeadMPUAccel_Y)
        Data.HeadMPUAccel_Y = Data.HeadMPUAccel_Y';
    end
    if isrow(Data.HeadMPUAccel_Z)
        Data.HeadMPUAccel_Z = Data.HeadMPUAccel_Z';
    end
    if isrow(Data.Time_Eye)
        Data.Time_Eye = Data.Time_Eye';
    end
    if ismatrix(Data.Time_Stim) % i.e., we are dealing with a stimulus timestamp that records an ONSET and OFFSET time (for example, if a pulsatile trigger is sent to an event channel on a CED that records the rising and falling edge of a pulse)
        a = size(Data.Time_Stim);
        if a(2) > a(1)
            Data.Time_Stim = Data.Time_Stim';
        end
    else
        if isrow(Data.Time_Stim)
            Data.Time_Stim = Data.Time_Stim';
        end
    end
    if isrow(Data.Stim_Trig )
        Data.Stim_Trig  = Data.Stim_Trig';
    end
    
    
    % Save the whole data trace in the GUI handles.
    handles.Data = Data;
    % Then save the whole data trace as the 'segment' variable in the handles.
    % This if a user decides they want to process the whole data trace, they
    % can just export the data.
    handles.Segment = Data;
    
    handles.i_start_eye = 1;
    handles.i_end_eye = length(Data.Time_Eye);
    handles.i_start_stim = 1;
    handles.i_end_stim = length(Data.Time_Stim);
    
    handles.Segment.start_t = Data.Time_Eye(1);
    handles.Segment.end_t = Data.Time_Eye(end);
    
    % Update the GUI plot
    keep_plot_limit = false; % Don't keep the plot limits, we are loading a new file
    plot_segment_data(hObject, eventdata, handles,keep_plot_limit)
end

guidata(hObject,handles)
end


% --- Executes on selection change in eye_mov_system.
function eye_mov_system_Callback(hObject, eventdata, handles)
% hObject    handle to eye_mov_system (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

index_selected = get(hObject,'Value');

handles.params.system_code = index_selected;

switch handles.params.system_code
    % Maybe I should switch this to a series of 'if' statements, since I
    % will be shutting off every option box when the system code changes...
    
    case 1 % Labyrinth Devices VOG Goggles
        
        set(handles.LabDevVOG,'Visible','On')
        
        set(handles.LaskerSystPanel,'Visible','Off')
        
        set(handles.mpuoffsetpanel,'Visible','On')
        
    case 2 % Labyrinth Devices VOG Goggles
        
        set(handles.LaskerSystPanel,'Visible','On')
        set(handles.mpuoffsetpanel,'Visible','Off')
        set(handles.LabDevVOG,'Visible','Off')
    case 3 % Pupil Labs
        
        set(handles.LabDevVOG,'Visible','On')
        
        set(handles.LaskerSystPanel,'Visible','Off')
        
        set(handles.mpuoffsetpanel,'Visible','On')
    case 4 % Ross 710 Moog Coil System
        set(handles.LaskerSystPanel,'Visible','Off');
        set(handles.mpuoffsetpanel,'Visible','Off');
        set(handles.LabDevVOG,'Visible','On');
        handles.timesExported ==0;
        [indx,tf] = listdlg('Name','Gain file options','PromptString',{'If no gainstouse.txt file exists,'; 'choose one of the first'; 'three choices'},...
            'SelectionMode','single',...
            'ListString',{'Ch1Ch2','Ch3Ch4','Both','GainsToUse.txt file exists'},'ListSize',[160 100]);
        switch indx
            case 1
                [ch1ch2FileNameGains,ch1ch2PathNameGains,FilterIndex] = uigetfile('*.coil','Please choose the Ch1Ch2 Gain file');
                [gains,handles.FileNameGains] = gainExtraction(ch1ch2PathNameGains,ch1ch2FileNameGains,[]);
                handles.PathNameGains = ch1ch2PathNameGains;
            case 2
                [ch3ch4FileNameGains,ch3ch4PathNameGains,FilterIndex] = uigetfile('*.coil','Please choose the Ch3Ch4 Gain file');
                [gains,handles.FileNameGains] = gainExtraction(ch3ch4PathNameGains,[],ch3ch4FileNameGains);
                handles.PathNameGains = ch3ch4PathNameGains;
            case 3
                [ch1ch2FileNameGains,ch1ch2PathNameGains,FilterIndex] = uigetfile('*.coil','Please choose the Ch1Ch2 Gain file');
                [ch3ch4FileNameGains,ch3ch4PathNameGains,FilterIndex] = uigetfile('*.coil','Please choose the Ch3Ch4 Gain file');
                [gains,handles.FileNameGains] = gainExtraction(ch1ch2PathNameGains,ch1ch2FileNameGains,ch3ch4FileNameGains);
                handles.PathNameGains = ch1ch2PathNameGains;
            case 4
                [handles.FileNameGains,handles.PathNameGains,FilterIndex] = uigetfile('*.txt','Please choose the Gain file');
        end
        
        cd(handles.PathNameGains);
        [handles.FileNameOffset1,handles.PathNameOffset1,FilterIndex] = uigetfile('*.coil','Please choose the First Orientation Offset file');
        [handles.FileNameOffset2,handles.PathNameOffset2,FilterIndex] = uigetfile('*.coil','Please choose the Second Orientation Offset file');
        handles.PathNameofFiles = uigetdir(cd,'Please choose the folder where the coil files are saved');
        eyesRecorded = figure;
        eyesRecorded.Units = 'normalized';
        eyesRecorded.Position = [1.4    0.4    0.075    0.15];
        handles.leftEye = uicontrol(eyesRecorded,'Style','checkbox','String','Left Eye');
        handles.leftEye.Units = 'normalized';
        handles.leftEye.Position = [0.03    0.5    0.5 .5];
        handles.rightEye = uicontrol(eyesRecorded,'Style','checkbox','String','Right Eye');
        handles.rightEye.Units = 'normalized';
        handles.rightEye.Position = [0.5 0.5 .5 .5];
        handles.leftEyeCh = uicontrol(eyesRecorded,'Style','listbox','String',{' ','Ch1Ch2','Ch3Ch4'},'Value',3);
        handles.leftEyeCh.Units = 'normalized';
        handles.leftEyeCh.Position = [0.03    0.3    0.410    0.3000];
        handles.rightEyeCh = uicontrol(eyesRecorded,'Style','listbox','String',{' ','Ch1Ch2','Ch3Ch4'},'Value',2);
        handles.rightEyeCh.Units = 'normalized';
        handles.rightEyeCh.Position = [0.5    0.3    0.410    0.3000];
        handles.eyes = uicontrol(eyesRecorded,'Style','radiobutton','String','ok');
        handles.eyes.Units = 'normalized';
        handles.eyes.Position = [0.3    0.05    0.5    0.2000];
        handles.eyes.FontSize = 18;
        waitfor(handles.eyes,'Value');
        
        handles.text53.BackgroundColor = 'r';
        if handles.leftEye.Value == 0
            handles.EyeCh = handles.leftEyeCh.String{2};
            handles.eye_rec.Value = 4;
            
        elseif handles.rightEye.Value == 0
            handles.EyeCh = handles.rightEyeCh.String{3};
            handles.eye_rec.Value = 3;
        else
            handles.EyeCh = {handles.rightEyeCh.String{2},handles.rightEyeCh.String{3}};
            handles.eye_rec.Value = 2;
        end
        handles.text53.BackgroundColor = [0.94 0.94 0.94];
        delete(eyesRecorded)
        handles.segment_number.String = '0';
        handles.experimentdata = {};
        
        
    otherwise
        set(handles.LabDevVOG,'Visible','Off')
        set(handles.LaskerSystPanel,'Visible','Off')
        set(handles.mpuoffsetpanel,'Visible','Off')
end

guidata(hObject,handles)
% Hints: contents = cellstr(get(hObject,'String')) returns eye_mov_system contents as cell array
%        contents{get(hObject,'Value')} returns selected item from eye_mov_system
end

% --- Executes during object creation, after setting all properties.
function eye_mov_system_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eye_mov_system (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


% --- Executes on button press in reload_raw.
function [handles] = reload_raw_Callback(hObject, eventdata, handles)
% hObject    handle to reload_raw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handles.params.reloadflag = 1;

guidata(hObject,handles)

[handles] = load_raw_Callback(hObject, eventdata, handles)
end

function subj_id_Callback(hObject, eventdata, handles)
% hObject    handle to subj_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.load_spread_sheet.BackgroundColor = [0.94 0.94 0.94];
handles.load_spread_sheet.Enable = 'on';
handles.params.subj_id = get(hObject,'String');
[handles] = update_seg_filename(hObject, eventdata, handles);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of subj_id as text
%        str2double(get(hObject,'String')) returns contents of subj_id as a double
end

% --- Executes during object creation, after setting all properties.
function subj_id_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subj_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function visit_number_Callback(hObject, eventdata, handles)
% hObject    handle to subj_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.params.visit_number = get(hObject,'String');
[handles] = update_seg_filename(hObject, eventdata, handles);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of subj_id as text
%        str2double(get(hObject,'String')) returns contents of subj_id as a double
end

% --- Executes during object creation, after setting all properties.
function visit_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subj_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over date.
% Enable is set to inactive for this text box
function date_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uicalendar('DestinationUI',handles.date,'OutputDateFormat','yyyymmdd') % pulls up the uicalendar and designates the output destination and format
waitfor(handles.date,'String') % Waits for the string of the date textbox to be edited
handles.params.date = get(hObject,'String');
[handles] = update_seg_filename(hObject, eventdata, handles);
guidata(hObject,handles)
end


function date_Callback(hObject, eventdata, handles)
% hObject    handle to date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.params.date = get(hObject,'String')
[handles] = update_seg_filename(hObject, eventdata, handles);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of date as text
%        str2double(get(hObject,'String')) returns contents of date as a double
end

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

end

function exp_type_Callback(hObject, eventdata, handles)
% hObject    handle to exp_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.params.exp_type = get(hObject,'String');
[handles] = update_seg_filename(hObject, eventdata, handles);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of exp_type as text
%        str2double(get(hObject,'String')) returns contents of exp_type as a double
end

% --- Executes during object creation, after setting all properties.
function exp_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exp_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function exp_condition_Callback(hObject, eventdata, handles)
% hObject    handle to exp_condition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.params.exp_condition = get(hObject,'String');
[handles] = update_seg_filename(hObject, eventdata, handles);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of exp_condition as text
%        str2double(get(hObject,'String')) returns contents of exp_condition as a double
end

% --- Executes during object creation, after setting all properties.
function exp_condition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exp_condition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function stim_axis_Callback(hObject, eventdata, handles)
% hObject    handle to stim_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.params.stim_axis = handles.stim_axis.String{handles.stim_axis.Value};
setappdata(hObject,'ax',handles.stim_axis.String{handles.stim_axis.Value})
[handles] = update_seg_filename(hObject, eventdata, handles);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of stim_type as text
%        str2double(get(hObject,'String')) returns contents of stim_type as a double
end

% --- Executes during object creation, after setting all properties.
function stim_axis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function stim_type_Callback(hObject, eventdata, handles)
% hObject    handle to stim_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.params.stim_type = handles.stim_type.String{handles.stim_type.Value};
setappdata(hObject,'type',handles.stim_type.String{handles.stim_type.Value});
if (get(hObject,'Value') == 2) || (get(hObject,'Value') == 4)
    handles.stim_frequency.Value = 2;
end
handles.params.stim_frequency = handles.stim_frequency.String{handles.stim_frequency.Value};
setappdata(handles.stim_frequency,'fq',handles.stim_frequency.String{handles.stim_frequency.Value})
[handles] = update_seg_filename(hObject, eventdata, handles);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of stim_type as text
%        str2double(get(hObject,'String')) returns contents of stim_type as a double
end

% --- Executes during object creation, after setting all properties.
function stim_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function stim_frequency_Callback(hObject, eventdata, handles)
% hObject    handle to stim_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.params.stim_frequency = handles.stim_frequency.String{handles.stim_frequency.Value};
setappdata(hObject,'fq',handles.stim_frequency.String{handles.stim_frequency.Value})
[handles] = update_seg_filename(hObject, eventdata, handles);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of stim_type as text
%        str2double(get(hObject,'String')) returns contents of stim_type as a double
end

% --- Executes during object creation, after setting all properties.
function stim_frequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function stim_intensity_Callback(hObject, eventdata, handles)
% hObject    handle to stim_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.params.stim_intensity = handles.stim_intensity.String{handles.stim_intensity.Value};
setappdata(hObject,'intensity',handles.stim_intensity.String{handles.stim_intensity.Value})
[handles] = update_seg_filename(hObject, eventdata, handles);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of stim_intensity as text
%        str2double(get(hObject,'String')) returns contents of stim_intensity as a double
end

% --- Executes during object creation, after setting all properties.
function stim_intensity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function [handles] = update_seg_filename(hObject, eventdata, handles)
handles.params.subj_id = handles.subj_id.String{handles.subj_id.Value};
handles.params.visit_number = handles.visit_number.String{handles.visit_number.Value};
handles.params.date = handles.date.String;
handles.params.exp_type = handles.exp_type.String{handles.exp_type.Value};
handles.params.exp_condition = handles.exp_condition.String{handles.exp_condition.Value};
handles.params.stim_axis = getappdata(handles.stim_axis,'ax');
handles.params.stim_type = getappdata(handles.stim_type,'type');
handles.params.stim_frequency = getappdata(handles.stim_frequency,'fq');
handles.params.stim_intensity = getappdata(handles.stim_intensity,'intensity');
handles.params.suffix = getappdata(handles.stim_intensity,'suf');

handles.params.segment_filename = [handles.params.subj_id '-' handles.params.visit_number ...
    '-' handles.params.date '-' handles.params.exp_type '-' handles.params.exp_condition ...
    '-' handles.params.stim_axis '-' handles.params.stim_type '-' handles.params.stim_frequency ...
    '-' handles.params.stim_intensity handles.params.suffix];

set(handles.seg_filename,'String',handles.params.segment_filename);
end

% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in plot_MPUGyroData.
function plot_MPUGyroData_Callback(hObject, eventdata, handles)
% hObject    handle to plot_MPUGyroData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.params.plot_MPUGyroData = 1;
else
    handles.params.plot_MPUGyroData = 0;
end

% Update plots!
keep_plot_limit = true; % We want to keep the same plot limits
plot_segment_data(hObject, eventdata, handles,keep_plot_limit)

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of plot_MPUGyroData
end

% --- Executes on button press in plot_TrigLine.
function plot_TrigLine_Callback(hObject, eventdata, handles)
% hObject    handle to plot_TrigLine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.params.plot_TrigLine = 1;
else
    handles.params.plot_TrigLine = 0;
end

% Update plots!
keep_plot_limit = true; % We want to keep the same plot limits
plot_segment_data(hObject, eventdata, handles,keep_plot_limit)

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of plot_TrigLine
end

% --- Executes on button press in plot_LEData.
function plot_LEData_Callback(hObject, eventdata, handles)
% hObject    handle to plot_LEData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.params.plot_LEData = 1;
else
    handles.params.plot_LEData = 0;
end

% Update plots!
keep_plot_limit = true; % We want to keep the same plot limits

plot_segment_data(hObject, eventdata, handles,keep_plot_limit)

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of plot_LEData
end

% --- Executes on button press in plot_REData.
function plot_REData_Callback(hObject, eventdata, handles)
% hObject    handle to plot_REData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.params.plot_REData = 1;
else
    handles.params.plot_REData = 0;
end

% Update plots!
keep_plot_limit = true; % We want to keep the same plot limits

plot_segment_data(hObject, eventdata, handles,keep_plot_limit)

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of plot_REData
end


function trig_mult_Callback(hObject, eventdata, handles)
% hObject    handle to trig_mult_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input = str2double(get(hObject,'String'));
handles.params.trig_mult = input;
keep_plot_limit = true; % We want to keep the same plot limits

plot_segment_data(hObject, eventdata, handles,keep_plot_limit)

guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of trig_mult_text as text
%        str2double(get(hObject,'String')) returns contents of trig_mult_text as a double
end

% --- Executes during object creation, after setting all properties.
function trig_mult_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trig_mult_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in labdev_goggleID.
function labdev_goggleID_Callback(hObject, eventdata, handles)
% hObject    handle to labdev_goggleID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index_selected = get(hObject,'Value');

handles.params.goggleID = index_selected;

switch index_selected
    
    case 1
        temp = handles.TriggerDelay.G1;
    case 2
        temp = handles.TriggerDelay.G2;
    case 3
        temp = handles.TriggerDelay.G3;
    case 4
        temp = 0;
end

handles.AdjustTrig = temp;
set(handles.AdjustTrig_Control,'String',num2str(temp));

guidata(hObject,handles)
% Hints: contents = cellstr(get(hObject,'String')) returns labdev_goggleID contents as cell array
%        contents{get(hObject,'Value')} returns selected item from labdev_goggleID
end

% --- Executes during object creation, after setting all properties.
function labdev_goggleID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to labdev_goggleID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in vog_data_acq_version.
function vog_data_acq_version_Callback(hObject, eventdata, handles)
% hObject    handle to vog_data_acq_version (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index_selected = get(hObject,'Value');

handles.params.vog_data_acq_version = index_selected;

guidata(hObject,handles)
% Hints: contents = cellstr(get(hObject,'String')) returns vog_data_acq_version contents as cell array
%        contents{get(hObject,'Value')} returns selected item from vog_data_acq_version
end

% --- Executes during object creation, after setting all properties.
function vog_data_acq_version_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vog_data_acq_version (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in Lasker_param1.
function Lasker_param1_Callback(hObject, eventdata, handles)
% hObject    handle to Lasker_param1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index_selected = get(hObject,'Value');
handles.params.Lasker_param1 = index_selected;

guidata(hObject,handles)

% Hints: contents = cellstr(get(hObject,'String')) returns Lasker_param1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Lasker_param1
end

% --- Executes during object creation, after setting all properties.
function Lasker_param1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Lasker_param1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in Lasker_param2.
function Lasker_param2_Callback(hObject, eventdata, handles)
% hObject    handle to Lasker_param2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index_selected = get(hObject,'Value');
handles.params.Lasker_param2 = index_selected;

guidata(hObject,handles)
% Hints: contents = cellstr(get(hObject,'String')) returns Lasker_param2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Lasker_param2
end

% --- Executes during object creation, after setting all properties.
function Lasker_param2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Lasker_param2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function Xaxis_Rot_Theta_Callback(hObject, eventdata, handles)
% hObject    handle to Xaxis_Rot_Theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents as double
handles.Xaxis_MPU_Rot_theta = str2double(get(hObject,'String'));
guidata(hObject,handles)

% Hints: get(hObject,'String') returns contents of Xaxis_Rot_Theta as text
%        str2double(get(hObject,'String')) returns contents of Xaxis_Rot_Theta as a double
end

% --- Executes during object creation, after setting all properties.
function Xaxis_Rot_Theta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xaxis_Rot_Theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function Yaxis_Rot_Theta_Callback(hObject, eventdata, handles)
% hObject    handle to Yaxis_Rot_Theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Yaxis_MPU_Rot_theta = str2double(get(hObject,'String'));
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of Yaxis_Rot_Theta as text
%        str2double(get(hObject,'String')) returns contents of Yaxis_Rot_Theta as a double
end

% --- Executes during object creation, after setting all properties.
function Yaxis_Rot_Theta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Yaxis_Rot_Theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function Zaxis_Rot_Theta_Callback(hObject, eventdata, handles)
% hObject    handle to Zaxis_Rot_Theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Zaxis_MPU_Rot_theta = str2double(get(hObject,'String'));
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of Zaxis_Rot_Theta as text
%        str2double(get(hObject,'String')) returns contents of Zaxis_Rot_Theta as a double
end

% --- Executes during object creation, after setting all properties.
function Zaxis_Rot_Theta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Zaxis_Rot_Theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function LaskerSystPanel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LaskerSystPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
end


function Xoffset_txt_Callback(hObject, eventdata, handles)
% hObject    handle to Xoffset_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Xoffset_txt as text
%        str2double(get(hObject,'String')) returns contents of Xoffset_txt as a double
end

% --- Executes during object creation, after setting all properties.
function Xoffset_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xoffset_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function Yoffset_txt_Callback(hObject, eventdata, handles)
% hObject    handle to Yoffset_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Yoffset_txt as text
%        str2double(get(hObject,'String')) returns contents of Yoffset_txt as a double
end

% --- Executes during object creation, after setting all properties.
function Yoffset_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Yoffset_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function Zoffset_txt_Callback(hObject, eventdata, handles)
% hObject    handle to Zoffset_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Zoffset_txt as text
%        str2double(get(hObject,'String')) returns contents of Zoffset_txt as a double
end

% --- Executes during object creation, after setting all properties.
function Zoffset_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Zoffset_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','w++hite');
end
end

% --- Executes on button press in calc_mpu_offsets.
function calc_mpu_offsets_Callback(hObject, eventdata, handles)
% hObject    handle to calc_mpu_offsets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Ask user to choose segmentation points
uiwait(msgbox('Please align the vertical line of the crosshair with the starting point of the data segment used to calculate MPU offsets','Segment Eye Movement Data'));
[x1,y1] = ginput(1);
uiwait(msgbox('Please align the vertical line of the crosshair with the ending point of the data segment used to calculate MPU offsets','Segment Eye Movement Data'));
[x2,y2] = ginput(1);
time_cutout_s = [x1 ; x2];

[a1,i_start_eye] = min(abs(handles.Segment.Time_Eye - time_cutout_s(1,1)));
[a2,i_end_eye] = min(abs(handles.Segment.Time_Eye - time_cutout_s(2,1)));

X_off = mean(handles.Segment.HeadMPUVel_X(i_start_eye:i_start_eye));
Y_off = mean(handles.Segment.HeadMPUVel_Y(i_start_eye:i_start_eye));
Z_off = mean(handles.Segment.HeadMPUVel_Z(i_start_eye:i_start_eye));

handles.Segment.HeadMPUVel_X = handles.Segment.HeadMPUVel_X - X_off;
handles.Segment.HeadMPUVel_Y = handles.Segment.HeadMPUVel_Y - Y_off;
handles.Segment.HeadMPUVel_Z = handles.Segment.HeadMPUVel_Z - Z_off;


set(handles.Xoffset_txt,'String',num2str(X_off))
set(handles.Yoffset_txt,'String',num2str(Y_off))
set(handles.Zoffset_txt,'String',num2str(Z_off))
keep_plot_limit = true; % We want to keep the same plot limits

plot_segment_data(hObject, eventdata, handles,keep_plot_limit)

guidata(hObject,handles)
end

% --- Executes on selection change in gpio_trigger_source.
function gpio_trigger_source_Callback(hObject, eventdata, handles)
% hObject    handle to gpio_trigger_source (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index_selected = get(hObject,'Value');

handles.params.gpio_trig_opt = index_selected;

guidata(hObject,handles)
% Hints: contents = cellstr(get(hObject,'String')) returns gpio_trigger_source contents as cell array
%        contents{get(hObject,'Value')} returns selected item from gpio_trigger_source
end

% --- Executes during object creation, after setting all properties.
function gpio_trigger_source_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gpio_trigger_source (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in auto_segment.
function auto_segment_Callback(hObject, eventdata, handles,upper_trigLev,lower_trigLev)
% hObject    handle to auto_segment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~exist('upper_trigLev','var')
    upper_trigLev = 0;
end
if ~exist('lower_trigLev','var')
    lower_trigLev = 0;
end
[choice] = auto_seg_dialog(hObject, eventdata, handles);
handles.choice.stim = choice.stim;

switch choice.stim
    
    case 1 % Pulse Trains
        
        % Let's detect the ON/OFF times based on the GPIO trigger line.
        inds = [1:length(handles.Segment.Stim_Trig)];
        on_samp = inds([false ; (diff(handles.Segment.Stim_Trig) > upper_trigLev)]);
        off_samp = inds([false ; (diff(handles.Segment.Stim_Trig) < lower_trigLev)]);
        
        % NOTE: I should check if there are unequal numbers of detected ON and
        % OFF triggers
        
        % Let's create a trigger level to determine the PAUSES between
        % stimuli levels. We will set this level to half of the interstimulus interval.
        % We will relaize this by ing half of the ISI to the ON+OFF
        % times.
        trig_level = ((choice.ontime + choice.offtime) + choice.ISI/2)*(handles.Segment.Fs/1000);
        
        stim_interval_startpoints = [ on_samp([false  (diff(on_samp) > trig_level)])];
        
        
        stim_interval_endpoints = [off_samp(diff(off_samp) > trig_level) ];
        
        % Create a 'start_val' variable that is either on_samp(1) - half of
        % the inter-stimulus-interval, or one (i.e., the first time inde)
        % if that value is negative.
        start_val = max(on_samp(1)-(choice.ISI/2)*(handles.Segment.Fs/1000),1);
        
        seg_times = [start_val round((stim_interval_startpoints(1)-stim_interval_endpoints(1))/2+stim_interval_endpoints(1))];
        for k=1:length(stim_interval_startpoints)
            
            if k==length(stim_interval_startpoints)
                seg_times = [seg_times ; round((stim_interval_startpoints(end)-stim_interval_endpoints(end))/2+stim_interval_endpoints(end)) on_samp(end)+(choice.ISI/2)*(handles.Segment.Fs/1000)];
                
            else
                seg_times = [seg_times ; seg_times(k,2) round((stim_interval_startpoints(k+1)-stim_interval_endpoints(k+1))/2+stim_interval_endpoints(k+1))];
                
                %                 seg_times = [seg_times ; round((stim_interval_startpoints(k-1)-stim_interval_endpoints(k-1))/2+stim_interval_endpoints(k-1)) round((stim_interval_startpoints(k)-stim_interval_endpoints(k))/2+stim_interval_endpoints(k))];
            end
            
        end
        
        seg_times(seg_times(:,2)>length(inds),2) = length(inds)*ones(size(seg_times(seg_times(:,2)>length(inds),2),2),1);
        
        stem(handles.Segment.Time_Eye(seg_times(:,1)),handles.params.trig_mult*ones(length(seg_times(:,1)),1))
        
        stem(handles.Segment.Time_Eye(seg_times(:,2)),handles.params.trig_mult*0.75*ones(length(seg_times(:,1)),1))
        
        % Now that we have our segmentation times, lets load the
        % user-generated excel sheet containing the file names, and begin
        % segmenting!
        
        [filename, pathname] = ...
            uigetfile('*.xlsx','Please load an Excel spreadsheet containing the segmented filenames in the first row of the first sheet.');
        
        [num,txt,raw] = xlsread([pathname filename]);
        
        pre_auto_i_start_eye =  handles.i_start_eye;
        pre_auto_i_end_eye =  handles.i_end_eye;
        pre_auto_i_start_stim =  handles.i_start_stim;
        pre_auto_i_end_stim =  handles.i_end_stim;
        
        pre_auto_Seg_start_t = handles.Segment.start_t;
        pre_auto_Seg_end_t = handles.Segment.end_t;
        
        %         handles.folder_name = uigetdir('','Select Directory to Save the Segmented Data');
        
        
        for k=1:size(seg_times,1)
            
            handles.i_start_eye = seg_times(k,1);
            handles.i_end_eye = seg_times(k,2);
            handles.i_start_stim = seg_times(k,1);
            handles.i_end_stim = seg_times(k,2);
            
            
            handles.Segment.start_t = handles.Segment.Time_Eye(handles.i_start_eye);
            handles.Segment.end_t = handles.Segment.Time_Eye(handles.i_end_eye);
            
            
            
            [handles] = new_segment_Callback(hObject, eventdata, handles,false);
            
            handles.params.segment_filename = [raw{k,1}];
            
            handles.seg_filename.String = [raw{k,1}];
            
            handles.skip_excel_fill_flag = 1;
            
            save_segment_Callback(hObject, eventdata, handles);
            
            
            
            
            [handles] = reload_raw_Callback(hObject, eventdata, handles);
            
            handles.i_start_eye = pre_auto_i_start_eye;
            handles.i_end_eye = pre_auto_i_end_eye;
            handles.i_start_stim = pre_auto_i_start_stim;
            handles.i_end_stim = pre_auto_i_end_stim;
            
            
            handles.Segment.start_t =  pre_auto_Seg_start_t;
            handles.Segment.end_t = pre_auto_Seg_end_t;
            
            [handles] = new_segment_Callback(hObject, eventdata, handles,false);
            
        end
        
        
        handles = rmfield(handles,'skip_excel_fill_flag');
        
    case 2 % Electrical only Sinusoids
        Time = handles.Segment.Time_Stim(:,1);
        
        % Let's detect the ON/OFF times based on the GPIO trigger line.
        inds = [1:length(handles.Segment.Stim_Trig)];
        on_samp = inds([(handles.Segment.Stim_Trig > upper_trigLev)])';
        off_samp = inds([(handles.Segment.Stim_Trig < lower_trigLev)])';
        
        % NOTE: I should check if there are unequal numbers of detected ON and
        % OFF triggers
        
        % Let's create a trigger level to determine the PAUSES between
        % stimuli levels. We will set this level to half of the interstimulus interval.
        % We will relaize this by adding half of the ISI to the ON+OFF
        % times.
        %         trig_level = ((choice.ontime + choice.offtime) + choice.ISI/2)*(handles.Segment.Fs/1000);
        trig_level = ((choice.ontime + choice.offtime) + choice.ISI/2)/1000; %For CED trigger times, the data is time-stamped on arrival and NOT synchronously sampled.
        
        stim_interval_startpoints = [ on_samp([false  ;(diff(Time(on_samp)) > trig_level)])];
        
        
        stim_interval_endpoints = [off_samp([(diff(Time(off_samp)) > trig_level) ; false])];
        
        preposttime = choice.preposttime/1000;
        % Create a 'start_val' variable that is either on_samp(1) - half of
        % the inter-stimulus-interval, or one (i.e., the first time inde)
        % if that value is negative.
        %         start_val = max(on_samp(1)-(choice.ISI/2)*(handles.Segment.Fs/1000),1);
        start_val = max(Time(on_samp(1))-(preposttime),Time(1));
        end_val = min(Time(off_samp(end))+(preposttime),Time(end));
        %                 timedif = Time - start_val;
        %                 timedif(timedif<0) = nan(length(timedif(timedif<0)),1);
        %                 [a1,a2] = min(timedif);
        %         seg_times = [start_val round((stim_interval_startpoints(1)-stim_interval_endpoints(1))/2+stim_interval_endpoints(1))];
        seg_times_a = [start_val ; Time(stim_interval_startpoints) - preposttime];
        seg_times_b = [Time(stim_interval_endpoints) + preposttime ; end_val];
        
        seg_times = [seg_times_a seg_times_b];
        %         for k=1:length(stim_interval_startpoints)
        %
        %             if k==length(stim_interval_startpoints)
        %                 seg_times = [seg_times ; round((stim_interval_startpoints(end)-stim_interval_endpoints(end))/2+stim_interval_endpoints(end)) on_samp(end)+(choice.ISI/2)*(handles.Segment.Fs/1000)];
        %
        %             else
        %                 seg_times = [seg_times ; seg_times(k,1)-preposttime seg_times(k,2)+preposttime];
        %
        %                 %                 seg_times = [seg_times ; round((stim_interval_startpoints(k-1)-stim_interval_endpoints(k-1))/2+stim_interval_endpoints(k-1)) round((stim_interval_startpoints(k)-stim_interval_endpoints(k))/2+stim_interval_endpoints(k))];
        %             end
        %
        %         end
        
        %         seg_times(seg_times(:,2)>length(inds),2) = length(inds)*ones(size(seg_times(seg_times(:,2)>length(inds),2),2),1);
        %         seg_times = round(seg_times);
        stem(seg_times(:,1),handles.params.trig_mult*ones(length(seg_times(:,1)),1))
        
        stem(seg_times(:,2),handles.params.trig_mult*0.75*ones(length(seg_times(:,1)),1))
        
        % Now that we have our segmentation times, lets load the
        % user-generated excel sheet containing the file names, and begin
        % segmenting!
        
        [filename, pathname] = ...
            uigetfile('*.xlsx','Please load an Excel spreadsheet containing the segmented filenames in the first row of the first sheet.');
        
        [num,txt,raw] = xlsread([pathname filename]);
        
        pre_auto_i_start_eye =  handles.i_start_eye;
        pre_auto_i_end_eye =  handles.i_end_eye;
        pre_auto_i_start_stim =  handles.i_start_stim;
        pre_auto_i_end_stim =  handles.i_end_stim;
        
        pre_auto_Seg_start_t = handles.Segment.start_t;
        pre_auto_Seg_end_t = handles.Segment.end_t;
        
        
        % Find Stim start times
        timedif1 = repmat(handles.Segment.Time_Eye(:,1),1,length(seg_times(:,1)')) - repmat(seg_times(:,1)',length(handles.Segment.Time_Eye(:,1)),1);
        timedif1(timedif1<0) = nan;
        [a1,a2] = min(timedif1);
        eye_startinds = a2;
        
        timedif2 = repmat(handles.Segment.Time_Eye(:,1),1,length(seg_times(:,2)')) - repmat(seg_times(:,2)',length(handles.Segment.Time_Eye(:,1)),1);
        timedif2(timedif2<0) = nan;
        [a1,a2] = min(timedif2);
        eye_endinds = a2;
        
        % Find Stim start times
        timedif3 = repmat(handles.Segment.Time_Stim(:,1),1,length(seg_times(:,1)')) - repmat(seg_times(:,1)',length(handles.Segment.Time_Stim(:,1)),1);
        timedif3(timedif3<0) = nan;
        [a1,a2] = min(timedif3);
        stim_startinds = a2;
        
        timedif4 = repmat(handles.Segment.Time_Stim(:,1),1,length(seg_times(:,2)')) - repmat(seg_times(:,2)',length(handles.Segment.Time_Stim(:,1)),1);
        timedif4(timedif4<0) = nan;
        [a1,a2] = min(timedif4);
        stim_endinds = a2;
        
        
        
        
        for k=1:size(seg_times,1)
            
            handles.i_start_eye = eye_startinds(k);
            handles.i_end_eye = eye_endinds(k);
            
            
            
            handles.i_start_stim = stim_startinds(k);
            handles.i_end_stim = stim_endinds(k);
            
            
            handles.Segment.start_t = handles.Segment.Time_Eye(handles.i_start_eye);
            handles.Segment.end_t = handles.Segment.Time_Eye(handles.i_end_eye);
            
            
            
            [handles] = new_segment_Callback(hObject, eventdata, handles,false);
            
            handles.params.segment_filename = [raw{k,1}];
            
            save_segment_Callback(hObject, eventdata, handles);
            
            
            
            
            [handles] = reload_raw_Callback(hObject, eventdata, handles);
            
            handles.i_start_eye = pre_auto_i_start_eye;
            handles.i_end_eye = pre_auto_i_end_eye;
            handles.i_start_stim = pre_auto_i_start_stim;
            handles.i_end_stim = pre_auto_i_end_stim;
            
            
            handles.Segment.start_t =  pre_auto_Seg_start_t;
            handles.Segment.end_t = pre_auto_Seg_end_t;
            
            [handles] = new_segment_Callback(hObject, eventdata, handles,false);
        end
    case 3 %Mechanical Sinusoid
        [handles] = auto_seg_general_Callback(hObject, eventdata, handles);
        
    case 4 % Electrical Only
        [handles] = auto_seg_general_Callback(hObject, eventdata, handles);
    case 5 % Ross 710 Moog coils
        handles.listing = dir(handles.PathNameofFiles);
        [GAINSR, GAINSL]=getGains(handles.PathNameGains,handles.FileNameGains);
        [ZEROS_R, ZEROS_L]=calcOffsets(handles.PathNameOffset1,handles.FileNameOffset1,handles.FileNameOffset2,1);
        
        
        
        count = 0;
        test=struct2table(handles.listing);
        allNames=test.name;
        handles.listing([handles.listing.bytes]==0)=[];
        meanSize = mean([handles.listing.bytes]);
        a = [handles.listing.bytes];
        toDel = find(~(a>(meanSize-300000) & a<(meanSize+300000)));
        handles.listing(toDel) = [];
        [y,detect] = max(a);
        [z,detect2] = max(a(a<y));
        if length(a) == 1
            z = y;
        end
        indsForSeg = 1:length(handles.listing);
        handles.totalSegment = length(indsForSeg);
        sortNames = sort_nat({handles.listing(indsForSeg).name})';
        [handles.listing.name] = sortNames{:};
        
        handles.string_addon = [];
        guidata(handles.auto_segment,handles)
        f=figure('Name','Choose the stimulator channels that correspond to the canal');
        %f.Position = [360 278 450 290];
        f.Position = [600 278 450 290];
                            set1_stimNum = uicontrol(f,'Style','listbox','String',{'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15'},'Max',15,'Min',0,'Value',[7:9],'Position',[300 5 130 215]);
                            set1_stimCanal = uicontrol(f,'Style','popupmenu','String',{'LHRH','RALP','LARP'},'Value',1,'fontsize',8,'Position',[305 225 100 30]);
                            set2_stimNum = uicontrol(f,'Style','listbox','String',{'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15'},'Max',15,'Min',0,'Value',[1:3],'Position',[165 5 130 215]);
                            set2_stimCanal = uicontrol(f,'Style','popupmenu','String',{'LHRH','RALP','LARP'},'Value',2,'fontsize',8,'Position',[170 225 100 30]);
                            set3_stimNum = uicontrol(f,'Style','listbox','String',{'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15'},'Max',15,'Min',0,'Value',[4:6],'Position',[30 5 130 215]);
                            set3_stimCanal = uicontrol(f,'Style','popupmenu','String',{'LHRH','RALP','LARP'},'Value',3,'fontsize',8,'Position',[35 225 100 30]);
%         set1_stimNum = uicontrol(f,'Style','listbox','String',{'27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45','46','47','48','49','50'},'Max',24,'Min',0,'Value',[1:8],'Position',[300 5 130 215]);
%         set1_stimCanal = uicontrol(f,'Style','popupmenu','String',{'LHRH','RALP','LARP'},'Value',1,'fontsize',8,'Position',[305 225 100 30]);
%         set2_stimNum = uicontrol(f,'Style','listbox','String',{'27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45','46','47','48','49','50'},'Max',15,'Min',0,'Value',[17:24],'Position',[165 5 130 215]);
%         set2_stimCanal = uicontrol(f,'Style','popupmenu','String',{'LHRH','RALP','LARP'},'Value',2,'fontsize',8,'Position',[170 225 100 30]);
%         set3_stimNum = uicontrol(f,'Style','listbox','String',{'27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45','46','47','48','49','50'},'Max',15,'Min',0,'Value',[9:16],'Position',[30 5 130 215]);
%         set3_stimCanal = uicontrol(f,'Style','popupmenu','String',{'LHRH','RALP','LARP'},'Value',3,'fontsize',8,'Position',[35 225 100 30]);
%         %% MEG CHANGING 7/29/2019
%         set4_stimNum = uicontrol(f,'Style','listbox','String',{'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26'},'Max',26,'Min',0,'Value',[1:13],'Position',[435 5 130 215]);
%         set4_stimCanal = uicontrol(f,'Style','popupmenu','String',{'Utricle','Saccule'},'Value',2,'fontsize',8,'Position',[440 225 100 30]);
%         set5_stimNum = uicontrol(f,'Style','listbox','String',{'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26'},'Max',26,'Min',0,'Value',[14:26],'Position',[570 5 130 215]);
%         set5_stimCanal = uicontrol(f,'Style','popupmenu','String',{'Utricle','Saccule'},'Value',1,'fontsize',8,'Position',[575 225 100 30]);
         animalEnum = uicontrol(f,'Style','popupmenu','String',{'GiGi','MoMo','Nancy','Yoda','JoJo'},'Value',1,'fontsize',8,'Position',[200 260 50 25],'CallBack',@changeENum)
        okButton = uicontrol(f,'Style','pushbutton','String','Ok','fontsize',12,'Position',[415 230 30 30],'CallBack',{@ok_axis_Callback, handles});
        %guidata(f,handles)
        uiwait(gcf)
        delete(gcf)
        repeat = 0;
        handles = guidata(handles.auto_segment)
        
        handles.canalInfo = getappdata(handles.stim_axis,'axisInfo');
        handles.raw_name.String = ['Total of ',num2str(handles.totalSegment),' files to process'];
        
        if y/z>20
            directory = [handles.listing(detect).folder,handles.ispc.slash];
            filename = handles.listing(detect).name;
            handles.rawFileName = filename;
            dashes = find(filename=='_');
            dot = find(filename=='.');
            amp = find(filename=='a');
            coilsWithProsthSync = readcoils(directory, filename, 1);
            prosthSync(:,1:2)=coilsWithProsthSync(:,4:5);
            coils(:,1:3)=coilsWithProsthSync(:,1:3);
            coils(:,4:15)=coilsWithProsthSync(:,6:17);
            
            TS_idx=1+find(gradient(prosthSync(:,1)));
            TS_time = prosthSync(TS_idx, 1)-1 + prosthSync(TS_idx,2)/25000;
            TS_interval = [diff(TS_time) / 1000;0];
            
            [rotRhead,rotLhead,rotRReye,rotLLeye,rotRref,rotLref] = analyzeCoilData(coils, 1, [],GAINSR,GAINSL,ZEROS_R,ZEROS_L);
            rotRlarpralp = rotRref;
            rotLlarpralp = rotLref;
            rotRxyz = rotRReye;
            rotLxyz = rotLLeye;
            [pks,locs] = findpeaks(diff(prosthSync(:,1)),'MinPeakHeight',50);
            handles.startInds = find(pks>500);
            handles.locs = locs;
            handles.totalSegment = length(handles.startInds)
            handles.raw_name.String = ['Total of ',num2str(handles.totalSegment),' files to process'];
            
            handles.angularPosL = rot2fick(rotLlarpralp);
            handles.angularPosR = rot2fick(rotRlarpralp);
            
            
            newFrameinFrame = fick2rot([45 0 0]);
            
            rotrotL = rot2rot(newFrameinFrame,rotLlarpralp);
            rotrotR = rot2rot(newFrameinFrame,rotRlarpralp);
            rotrotLxyz = rot2rot(newFrameinFrame,rotLxyz);
            rotrotRxyz = rot2rot(newFrameinFrame,rotRxyz);
            
            
            handles.AngVelL=rot2angvelBJM20190107(rotrotL)/pi*180 * 1000;
            handles.AngVelR=rot2angvelBJM20190107(rotrotR)/pi*180 * 1000;
            handles.AngVelLxyz=rot2angvelBJM20190107(rotrotLxyz)/pi*180 * 1000;
            handles.AngVelRxyz=rot2angvelBJM20190107(rotrotRxyz)/pi*180 * 1000;
            
            handles.Time_Eye =1/1000:1/1000:length(handles.AngVelL)/1000;
            Time_Stim = TS_idx./1000';
            Stim = 1./TS_interval./10';
            Stim(Stim>4)=20;
            Stim(Stim<20)=0;
            if length(Time_Stim) ~= length(handles.Time_Eye)
                handles.Time_Stim_Interp = handles.Time_Eye;
                handles.Stim_Interp = interp1(Time_Stim',Stim',handles.Time_Stim_Interp);
            end
            handles.Stim_Interp(handles.Stim_Interp<20) = 0;
            go = 1;
            stimCheck = 1;
            rmvCheck = 1;
            blockRmvInds = 1;
            while go==1
                segments = str2num(handles.segment_number.String);
                if ~isempty(handles.deletedInds(1).startInds) && (blockRmvInds == 1)
                    for r = 1:length(handles.deletedInds)
                        startRmv = handles.deletedInds(r).startInds;
                        otherRmv = handles.deletedInds(r).locs
                        handles.startInds(startRmv) = [];
                        handles.locs(otherRmv) = [];
                        handles.startInds(startRmv:end) = handles.startInds(startRmv:end)-length(otherRmv);
                    end
                    stimCheck == 1;
                    removeInds = 0;
                    handles.totalSegment = handles.totalSegment-length(handles.deletedInds)
                    handles.raw_name.String = ['Total of ',num2str(handles.totalSegment),' files to process'];
                    stimCheck = segments+1;
                else
                    if (isempty(segments==0) || (segments==0)) && (handles.rmvInds == 1)
                        handles.subj_id.String = {filename(dashes(1)+1:dashes(2)-1)};
                        handles.visit_number.String = {'NA'};
                        handles.date.String = filename(1:dashes(1)-1);
                        handles.exp_type.String = {'ElectricalStim'};
                        handles.exp_condition.String = {'PulseTrains'};
                        prompt = {'Enter the stimulation rate (pps):'};
                        t1 = 'Input';
                        dims = [1 35];
                        definput = {'100'};
                        answer = inputdlg(prompt,t1,dims,definput);
                        handles.stim_frequency.String = {answer{1}};
                        setappdata(handles.stim_frequency,'fq',answer{1});
                        handles.load_spread_sheet.BackgroundColor = [0.94 0.94 0.94];
                        handles.load_spread_sheet.Enable = 'on';
                        handles.segName = [];
                        removeInds = 0;
                    elseif (stimCheck == 1)
                        removeInds = 0;
                        handles.totalSegment = handles.totalSegment-segments
                        handles.raw_name.String = ['Total of ',num2str(handles.totalSegment),' files to process'];
                        stimCheck = segments+1;
                    end
                end
                handles.plot_num = stimCheck;
                
                handles.seg_plots = figure('Name',['Segment: ',num2str(stimCheck)], 'NumberTitle','off');
                handles.seg_plots.OuterPosition = [220   300   1100   720];
                handles.ax1 = axes;
                handles.ax1.Position = [0.09 0.1 0.72 0.85];
                
                NFilt = 30;
                if stimCheck>1
                    if (length(handles.locs(((stimCheck-1)*20:end)))<20)
                        bound = [(handles.locs(handles.startInds(stimCheck))) (handles.locs(end))];
                        handles.bound = [(handles.startInds(stimCheck)) length(handles.locs)];
                    else
                        bound = [(handles.locs(handles.startInds(stimCheck))) (handles.locs(stimCheck*20))];
                        handles.bound = [(handles.startInds(stimCheck)) (stimCheck*20)];
                    end
                    if length(handles.locs(((stimCheck-1)*20:end)))<40
                        NFilt = 2;
                        filtAngVelL=filtfilt(ones(1,NFilt)/NFilt,1,handles.AngVelL((handles.locs(handles.startInds(stimCheck))-500):(bound(2)+500),:));
                        
                        handles.stim_mag = plot(handles.ax1,handles.Time_Stim_Interp((handles.locs(handles.startInds(stimCheck))-500):(bound(2)+500))...
                            ,handles.Stim_Interp((handles.locs(handles.startInds(stimCheck))-500):(bound(2)+500)),'color','k','LineWidth',2);
                        hold on
                        plot(handles.ax1,handles.Time_Eye((handles.locs(handles.startInds(stimCheck))-500):(bound(2)+500)),filtAngVelL(:,3),'r',...
                            handles.Time_Eye((handles.locs(handles.startInds(stimCheck))-500):(bound(2)+500)), filtAngVelL(:,2),'b',...
                            handles.Time_Eye((handles.locs(handles.startInds(stimCheck))-500):(bound(2)+500)), filtAngVelL(:,1),'g');
                        plot(handles.ax1,handles.Time_Eye((handles.locs(handles.startInds(stimCheck)))),linspace(20,20,1),'r*');
                        plot(handles.ax1,handles.Time_Eye(handles.locs(2+(20*(stimCheck-1))):handles.locs(end)),linspace(20,20,length(handles.locs(((stimCheck-1)*20:end)))),'bo');
                    else
                        
                        filtAngVelL=filtfilt(ones(1,NFilt)/NFilt,1,handles.AngVelL((handles.locs(handles.startInds(stimCheck-1))-500):(handles.locs((stimCheck+1)*20)+500),:));
                        
                        handles.stim_mag = plot(handles.ax1,handles.Time_Stim_Interp((handles.locs(handles.startInds(stimCheck-1))-500):(handles.locs((stimCheck+1)*20)+500))...
                            ,handles.Stim_Interp((handles.locs(handles.startInds(stimCheck-1))-500):(handles.locs((stimCheck+1)*20)+500)),'color','k','LineWidth',2);
                        hold on
                        plot(handles.ax1,handles.Time_Eye((handles.locs(handles.startInds(stimCheck-1))-500):(handles.locs((stimCheck+1)*20)+500)),filtAngVelL(:,3),'r',...
                            handles.Time_Eye((handles.locs(handles.startInds(stimCheck-1))-500):(handles.locs((stimCheck+1)*20)+500)), filtAngVelL(:,2),'b',...
                            handles.Time_Eye((handles.locs(handles.startInds(stimCheck-1))-500):(handles.locs((stimCheck+1)*20)+500)), filtAngVelL(:,1),'g');
                        plot(handles.ax1,handles.Time_Eye((handles.locs(handles.startInds(stimCheck)))),linspace(20,20,1),'r*');
                        plot(handles.ax1,handles.Time_Eye((handles.locs(2+(20*(stimCheck-1)):stimCheck*20))),linspace(20,20,length((handles.locs(2+(20*(stimCheck-1)):stimCheck*20)))),'bo');
                    end
                else
                    bound = [(handles.locs(handles.startInds(stimCheck))) (handles.locs(stimCheck*20))];
                    handles.bound = [(handles.startInds(stimCheck)) (stimCheck*20)];
                    
                    filtAngVelL=filtfilt(ones(1,NFilt)/NFilt,1,handles.AngVelL((bound(1)-500):(bound(2)+500),:));
                    handles.stim_mag = plot(handles.ax1,handles.Time_Stim_Interp((bound(1)-500):(bound(2)+500)),handles.Stim_Interp((bound(1)-500):(bound(2)+500)),'color','k','LineWidth',2);
                    hold on
                    plot(handles.ax1,handles.Time_Eye((bound(1)-500):(bound(2)+500)),filtAngVelL(:,3),'r',...
                        handles.Time_Eye((bound(1)-500):(bound(2)+500)), filtAngVelL(:,2),'b',...
                        handles.Time_Eye((bound(1)-500):(bound(2)+500)), filtAngVelL(:,1),'g');
                    plot(handles.ax1,handles.Time_Eye((handles.locs(handles.startInds(stimCheck)))),linspace(20,20,1),'r*');
                    plot(handles.ax1,handles.Time_Eye((handles.locs(2+(20*(stimCheck-1)):stimCheck*20))),linspace(20,20,length((handles.locs(2+(20*(stimCheck-1)):stimCheck*20)))),'bo');
                end
                handles.left_extra = 0;
                handles.right_extra = 0;
                handles.ax1.YLim = [-300 300];
                
                x1 = [-100 -100 600 600];
                y1 = [-400 300 300 -400];
                a = handles.Time_Eye(bound(1));
                b = handles.Time_Eye(bound(2));
                
                v1 = [handles.ax1.XLim(1) handles.ax1.YLim(1); a handles.ax1.YLim(1); a handles.ax1.YLim(2); handles.ax1.XLim(1) handles.ax1.YLim(2)];
                f1 = [1 2 3 4];
                v2 = [b handles.ax1.YLim(1); handles.ax1.XLim(2) handles.ax1.YLim(1); handles.ax1.XLim(2) handles.ax1.YLim(2); b handles.ax1.YLim(2)];
                f2 = [1 2 3 4];
                handles.seg_patch1 = patch('Faces',f1,'Vertices',v1,'FaceColor','k','FaceAlpha',.3,'EdgeColor','none');
                handles.seg_patch2 = patch('Faces',f2,'Vertices',v2,'FaceColor','k','FaceAlpha',.3,'EdgeColor','none');
                hold off
                
                handles.ok_seg = uicontrol(handles.seg_plots,'Style','pushbutton','String','OK','fontsize',12,'Position',[975 10 70 30],'CallBack',{@ok_seg_Callback, handles},'KeyPressFcn',{@ok_seg_KeyPressFcn, handles});
                
                handles.reject_seg = uicontrol(handles.seg_plots,'Style','pushbutton','String','Reject This Segment','fontsize',12,'Position',[15 10 160 30],'CallBack',{@reject_seg_Callback, handles});
                
                handles.right_extra_val = uicontrol(handles.seg_plots,'Style','edit','enable','off','String', handles.right_extra,'fontsize',12,'Position',[900 295 60 30]);
                handles.left_extra_val = uicontrol(handles.seg_plots,'Style','edit','enable','off','String', handles.left_extra,'fontsize',12,'Position',[15 295 60 30]);
                
                setappdata(handles.ok_seg,'r',(handles.right_extra));
                setappdata(handles.ok_seg,'l',(handles.left_extra));
                
                handles.instructions = uicontrol(handles.seg_plots,'Style','text','String','Use the arrows to increase or decrease the number of pulses selected on the corresponding side. If a segment has a pause, adjust the window to encompass the entire segment, save within the first detected component, reject all following components.','fontsize',12,'Position',[895 365 175 240]);
                handles.inc_right = uicontrol(handles.seg_plots,'Style','pushbutton','String','<html>&#x25BA;</html>','fontsize',20,'Position',[930 325 30 30],'CallBack',{@inc_right_Callback, handles});
                handles.dec_right = uicontrol(handles.seg_plots,'Style','pushbutton','String','<html>&#x25C4;</html>','fontsize',20,'Position',[900 325 30 30],'CallBack',{@dec_right_Callback, handles});
                
                
                handles.dec_left = uicontrol(handles.seg_plots,'Style','pushbutton','String','<html>&#x25BA;</html>','fontsize',20,'Position',[45 325 30 30],'CallBack',{@dec_left_Callback, handles});
                handles.inc_left = uicontrol(handles.seg_plots,'Style','pushbutton','String','<html>&#x25C4;</html>','fontsize',20,'Position',[15 325 30 30],'CallBack',{@inc_left_Callback, handles});
                handles.stim_axis_confirm = uicontrol(handles.seg_plots,'Style','popupmenu','String',handles.stim_axis.String,'Value',handles.stim_axis.Value,'fontsize',8,'Position',[990 260 100 30],'CallBack',{@stim_axis_confirm_Callback ,handles});
                handles.stim_axis_confirm_s = uicontrol(handles.seg_plots,'Style','text','String', 'Stim Axis','fontsize',10,'Position',[910 255 60 30]);
                handles.stim_freq_confirm = uicontrol(handles.seg_plots,'Style','popupmenu','String',handles.stim_frequency.String,'Value',handles.stim_frequency.Value,'fontsize',8,'Position',[990 130 100 30],'CallBack',{@stim_freq_confirm_Callback ,handles});
                handles.stim_freq_confirm_s = uicontrol(handles.seg_plots,'Style','text','String', 'Stim Freq','fontsize',10,'Position',[910 125 70 30]);
                handles.stim_type_confirm = uicontrol(handles.seg_plots,'Style','edit','String',handles.stim_type.String,'Value',handles.stim_type.Value,'fontsize',8,'Position',[965 170 5 5],'CallBack',{@stim_type_confirm_Callback ,handles});
                handles.stim_list = uicontrol(handles.seg_plots,'Style','listbox','String',{'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15'},'Position',[960 165 50 90],'CallBack',{@stim_confirm_Callback ,handles},'Value',1);
                handles.stim_list_s = uicontrol(handles.seg_plots,'Style','text','String', 'stim','fontsize',10,'Position',[930 205 30 30]);
                handles.ref_list = uicontrol(handles.seg_plots,'Style','listbox','String',{'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15'},'Position',[1040 165 50 90],'CallBack',{@ref_confirm_Callback ,handles},'Value',1);
                handles.ref_list_s = uicontrol(handles.seg_plots,'Style','text','String', 'ref','fontsize',10,'Position',[1010 205 30 30]);
                handles.stim_inten_confirm = uicontrol(handles.seg_plots,'Style','popupmenu','String',handles.stim_intensity.String,'Value',handles.stim_intensity.Value,'fontsize',8,'Position',[990 95 100 30],'CallBack',{@stim_intensity_confirm_Callback ,handles});
                handles.stim_inten_confirm_s = uicontrol(handles.seg_plots,'Style','text','String', 'Stim Intensity','fontsize',10,'Position',[910 90 70 35]);
                handles.suffix_confirm = uicontrol(handles.seg_plots,'Style','edit','fontsize',8,'Position',[990 60 100 30],'CallBack',{@suffix_confirm_Callback ,handles});
                handles.suffix_confirm_s = uicontrol(handles.seg_plots,'Style','text','String', 'Add Suffix','fontsize',10,'Position',[910 55 70 35]);
                handles.segName_confirm = uicontrol(handles.seg_plots,'Style','listbox','String',handles.segName,'Position',[900 360 190 100],'Value',1);
                handles.undoSeg = uicontrol(handles.seg_plots,'Style','pushbutton','String','UNDO','fontsize',20,'Position',[200 10 100 30],'CallBack',{@undo_seg_Callback, handles});
                
                guidata(hObject,handles)
                uiwait(gcf)
                if getappdata(handles.ok_seg,'skip') == 0
                    handles.segName = [{[handles.stim_axis.String{1},'-',handles.stim_type.String{1},'-',handles.stim_frequency.String{1},'-',handles.stim_intensity.String{handles.stim_intensity.Value}]};handles.segName]
                    stimCheck = stimCheck +1;
                    handles.totalSegment = handles.totalSegment-1;
                    blockRmvInds = 0;
                    handles.rmvInds = 0;
                elseif getappdata(handles.ok_seg,'skip') == 1
                    %                       stimCheck = stimCheck +1;
                    startRmv = stimCheck- getappdata(handles.ok_seg,'l');
                    lower = handles.bound(1) - getappdata(handles.ok_seg,'l')
                    upper = handles.bound(2) + getappdata(handles.ok_seg,'r')
                    handles.startInds(startRmv) = [];
                    handles.locs(lower:upper) = [];
                    handles.startInds(stimCheck:end) = handles.startInds(stimCheck:end)-length((lower:upper))
                    handles.deletedInds(rmvCheck).locs = [lower:upper];
                    handles.deletedInds(rmvCheck).startInds = [startRmv];
                    handles.totalSegment = handles.totalSegment-1;
                    rmvCheck = rmvCheck +1;
                    blockRmvInds = 0;
                    handles.rmvInds = 0;
                elseif getappdata(handles.ok_seg,'skip') == 2
                    if stimCheck >1
                        stimCheck = stimCheck -1;
                        delete([getappdata(handles.save_segment,'foldername'), handles.ispc.slash, handles.prevFileName, '.mat'])
                        handles.segment_number.String = str2num(handles.segment_number.String)-1;
                        handles.segName(1,:) = [];
                        handles.experimentdata = getappdata(handles.export_data,'data')
                        handles.experimentdata(stimCheck,:) = [];
                        setappdata(handles.export_data,'data',handles.experimentdata)
                        handles.totalSegment = handles.totalSegment+1;
                    else
                    end
                end
                close(handles.seg_plots);
                handles.raw_name.String = ['Total of ',num2str(handles.totalSegment),' files to process'];
                
                
                handles.right_extra = 0;
                handles.left_extra = 0;
                
                
                handles.stim_intensity.Value = 1;
                handles.params.stim_intensity = '';
                handles.params.suffix = '';
                setappdata(handles.stim_intensity,'suf','');
                setappdata(handles.stim_intensity,'intensity','');
                handles.prevFileName = handles.seg_filename.String;
                [handles] = update_seg_filename(hObject, eventdata, handles);
                set(handles.save_indicator,'String','UNSAVED');
                set(handles.save_indicator,'BackgroundColor','r');
                handles.raw_name.String = ['Total of ',num2str(handles.totalSegment),' files to process'];
                
                guidata(hObject,handles)
                if stimCheck==length(handles.startInds)
                    handles.exportCond = 2;
                    guidata(hObject,handles)
                    handles = export_data_Callback(hObject, eventdata, handles);
                    go = 0;
                end
            end
            
            
            
        else
            prosthSync = [];
            handles.canalInfo = getappdata(handles.stim_axis,'axisInfo');
            segments = str2num(handles.segment_number.String);
            if isempty(handles.listing)
                
            else
                if segments>0
                    s = segments+count;
                else
                    s=1;
                end
                prevStimCanal = '';
                for fs = s:length(handles.listing)
                    segments = str2num(handles.segment_number.String);
                    
                    if contains(handles.listing(fs).name,{'LP', 'LA', 'LH', 'RP', 'RA', 'RH','stim','Stim'}) && (handles.listing(fs).bytes>0)
                        directory = [handles.listing(fs).folder,handles.ispc.slash];
                        filename = handles.listing(fs).name;
                        dashes = find(filename=='_');
                        dot = find(filename=='.');
                        amp = strfind(filename,'amp');
                        
                        coilsWithProsthSync = readcoils(directory, filename, 1);
                        prosthSync(:,1:2)=coilsWithProsthSync(:,4:5);
                        [pks,locs] = findpeaks(diff(prosthSync(:,1)),'MinPeakHeight',50);
                        if any(strfind(filename,'sinusoidal')) || any(strfind(filename,'VirtSine'))
                            locs = 1:20;
                        end
                        if isempty(locs) | length(locs)<20
                            handles.totalSegment = handles.totalSegment-1;
                            handles.raw_name.String = ['Total of ',num2str(handles.totalSegment),' files to process'];
                        else
                            
                            if isempty(segments==0) || (segments==0)
                                handles.subj_id.String = {filename(dashes(2)+1:dashes(3)-1)};
                                handles.visit_number.String = {'NA'};
                                handles.date.String = filename(1:dashes(1)-1);
                                handles.exp_type.String = {'ElectricalStim'};
                                handles.exp_condition.String = {'PulseTrains'};
                                prompt = {'Enter the stimulation rate (pps):'};
                                t1 = 'Input';
                                dims = [1 35];
                                definput = {'100'};
                                answer = inputdlg(prompt,t1,dims,definput);
                                handles.stim_frequency.String = {answer{1}};
                                setappdata(handles.stim_frequency,'fq',answer{1});
                                handles.load_spread_sheet.BackgroundColor = [0.94 0.94 0.94];
                                handles.load_spread_sheet.Enable = 'on';
                                
                                %                             if contains(handles.stim_axis.String,'L')
                                %                                 handles.implant.String={'Left'};
                                %                             else
                                %                                 handles.implant.String={'Right'};
                                %                             end
                            end
                            r = strfind(filename,'ref');
                            if isempty(r)
                                r = strfind(filename,'Ref');
                            end
                            startStim = strfind(filename,'stim');
                            if isempty(startStim)
                                startStim = strfind(filename,'Stim');
                            end
                            stimnum = {filename(startStim+4:r(1)-1)};
                            switch stimnum{1}
                                case handles.canalInfo.stimNum{1}
                                    setappdata(handles.stim_axis,'ax',handles.canalInfo.stimCanal{1});
                                    handles.stim_axis.String = handles.canalInfo.stimCanal(1);
                                    setappdata(handles.stim_type,'type',handles.stim_type.String{1});
                                    handles.stim_axis_confirm.String = handles.canalInfo.stimCanal{1};
                                case handles.canalInfo.stimNum{2}
                                    setappdata(handles.stim_axis,'ax',handles.canalInfo.stimCanal{2});
                                    handles.stim_axis.String = handles.canalInfo.stimCanal(2);
                                    setappdata(handles.stim_type,'type',handles.stim_type.String{1});
                                    handles.stim_axis_confirm.String = handles.canalInfo.stimCanal{2};
                                case handles.canalInfo.stimNum{3}
                                    setappdata(handles.stim_axis,'ax',handles.canalInfo.stimCanal{3});
                                    handles.stim_axis.String = handles.canalInfo.stimCanal(3);
                                    setappdata(handles.stim_type,'type',handles.stim_type.String{1});
                                    handles.stim_axis_confirm.String = handles.canalInfo.stimCanal{3};
                            end
                            if ~strcmp(prevStimCanal,getappdata(handles.stim_axis,'ax')) && (str2num(handles.segment_number.String)>1)
                                if handles.timesExported ==0
                                    handles.ss_FileName = [handles.subj_id.String{handles.subj_id.Value} '_ExperimentRecords']
                                    set(handles.exp_spread_sheet_name,'String',[handles.ss_FileName '.mat']);
                                    handles.exportCond = 3;
                                    guidata(hObject,handles)
                                    handles = export_data_Callback(hObject, eventdata, handles);
                                else
                                    handles.exportCond = 2;
                                    guidata(hObject,handles)
                                    handles = export_data_Callback(hObject, eventdata, handles);
                                end
                                
                            end
                            if any(strfind(filename,'VirtSine'))
                                d = find(filename=='-');
                                setappdata(handles.stim_type,'type',filename(startStim:d(4)-1));
                                handles.stim_type.String = {filename(startStim:d(4)-1)};
                            else
                                setappdata(handles.stim_type,'type',filename(dashes(3)+1:amp-1));
                                handles.stim_type.String = {filename(dashes(3)+1:amp-1)};
                            end
                            
                            
                            setappdata(handles.stim_intensity,'intensity',filename(amp:dot-1));
                            handles.stim_intensity.String = {filename(amp:dot-1)};
                            [handles] = update_seg_filename(hObject, eventdata, handles);
                            
                            coilsWithProsthSync = readcoils(directory, filename, 1);
                            
                            prosthSync(:,1:2)=coilsWithProsthSync(:,4:5);
                            coils(:,1:3)=coilsWithProsthSync(:,1:3);
                            coils(:,4:15)=coilsWithProsthSync(:,6:17);
                            TS_idx=1+find([diff(prosthSync(:,1));0]);
                            TS_time = prosthSync(TS_idx, 1)-1 + prosthSync(TS_idx,2)/25000;
                            TS_interval = [diff(TS_time);0] / 1000;
                            
                            [rotRhead,rotLhead,rotRReye,rotLLeye,rotRref,rotLref] = analyzeCoilData(coils, 1, [],GAINSR,GAINSL,ZEROS_R,ZEROS_L);
                            rotRlarpralp = rotRref;
                            rotLlarpralp = rotLref;
                            rotRxyz = rotRReye;
                            rotLxyz = rotLLeye;
                            
                            if fs>1
                                yPosCur = find(filename==handles.subj_id.String{1}(1));
                                yPosPrev = find(handles.listing(fs-1).name==handles.subj_id.String{1}(1));
                                if strcmp(filename(yPosCur:end),handles.listing(fs-1).name(yPosPrev:end))
                                    repeat = repeat+1;
                                    handles.string_addon = num2str(repeat);
                                else
                                    handles.string_addon = [];
                                    repeat = 0;
                                end
                            end
                            
                            
                            [pks,locs] = findpeaks(diff(prosthSync(:,1)),'MinPeakHeight',50);
                            
                            if any(strfind(filename,'sinusoidal')) || any(strfind(filename,'VirtSine'))
                                y = 1./TS_interval;
                                y(y==Inf)=0;
                                syncT = TS_idx./1000;
                                sync = smooth(syncT,y,0.002,'rloess');
                                
                                sync(sync>420) = 0;
                                sync(sync<0) = 0;
                                %                             syncT(sync>50)=[];
                                %                             sync(sync>50)=[];
                                %                             syncT(sync>mean(sync))=[];
                                %                             sync(sync>mean(sync)) = [];
                                %                             sync=interp1(syncT,sync,TS_idx./1000,'spline');
                                %                             syncT = TS_idx./1000;
                                inds = [1:length(syncT)];
                                pos_ind = [false ; diff(sync > 200)];
                                
                                stim_pos_thresh_ind = inds(pos_ind > 0 )';
                                stim_pos_thresh_ind(gradient(stim_pos_thresh_ind)<50) = [];
                                [pks,locs] = findpeaks(sync,'MinPeakHeight',max(sync)-60,'MinPeakDistance',90);
                                locs(sync(locs)>mean(sync(locs))+20) = [];
                                go = 1;
                                posCheck = 1;
                                qI = inds(stim_pos_thresh_ind);
                                while go
                                    if length(locs)~=length(qI)
                                        if locs(posCheck)>qI(posCheck)
                                            
                                            if locs(posCheck)<qI(posCheck+1)
                                                if length(locs)==posCheck
                                                    qI(posCheck+1) = [];
                                                    stim_pos_thresh_ind(posCheck+1) = [];
                                                    posCheck = posCheck - 1;
                                                end
                                                
                                                posCheck = posCheck + 1;
                                            else
                                                qI(posCheck) = [];
                                                stim_pos_thresh_ind(posCheck) = [];
                                            end
                                        elseif locs(posCheck)<qI(posCheck)
                                            locs(posCheck) = [];
                                            
                                        end
                                    else
                                        go = 0;
                                    end
                                end
                                %                             indstocheck = find(gradient(stim_pos_thresh_ind)>50);
                                %                             if length(indstocheck)>40
                                %                                 go = 1;
                                %                                 stepNm = 1;
                                %                                 while go
                                %                                     if stim_pos_thresh_ind(indstocheck(stepNm)+1)-stim_pos_thresh_ind(indstocheck(stepNm))<50
                                %                                         indstocheck(stepNm) = [];
                                %                                     end
                                %                                     if length(indstocheck)==40
                                %                                         go = 0;
                                %                                     end
                                %                                     stepNm = stepNm +1;
                                %                                 end
                                %                             end
                            end
                            
                            %%%meg change ****
                            if any(strfind(filename,'VirtSine'))
                                locst = locs;
                                locs = 1:20;
                            end
                            
                            if isempty(locs) | length(locs)<20
                                handles.totalSegment = handles.totalSegment-1;
                                handles.raw_name.String = ['Total of ',num2str(handles.totalSegment),' files to process'];
                            else
                                
                                %%%%rot2fick of rotRref and rotLref gives position in yaw larp and ralp
                                boundaries = [1 locs(20)];%[locs(1) locs(20)];
                                boundaries(2) = boundaries(2) + 1500;
                                boundaries(1) = boundaries(1); %- 1500;
                                %                         boundaries(1) = 1;
                                %                         boundaries(2) = 5000;
                                if any(strfind(filename,'sinusoidal')) || any(strfind(filename,'VirtSine'))
                                    boundaries = [TS_idx(stim_pos_thresh_ind(1))-1500 TS_idx(stim_pos_thresh_ind(end))+1500];
                                    if boundaries(1)<1
                                        boundaries(1)=1;
                                    end
                                    if boundaries(2)>length(prosthSync(:,1))
                                        boundaries(2)=length(TS_time);
                                    end
                                end
                                coilsSplit = zeros(boundaries(2)-boundaries(1)+1,17,length(boundaries)/2);
                                
                                
                                coilsSplit(:,:,1) = coilsWithProsthSync(boundaries(1):boundaries(2),:);
                                
                                rotRsplit(:,:,1) = rotRlarpralp(boundaries(1):boundaries(2),:);
                                rotLsplit(:,:,1) = rotLlarpralp(boundaries(1):boundaries(2),:);
                                rotRsplitxyz(:,:,1) = rotRxyz(boundaries(1):boundaries(2),:);
                                rotLsplitxyz(:,:,1) = rotLxyz(boundaries(1):boundaries(2),:);
                                
                                
                                angularPosL = rot2fick(rotLsplit(:,:,1));
                                angularPosR = rot2fick(rotRsplit(:,:,1));
                                % prosthSync(:,1:2)=coilsWithProsthSync(:,4:5);
                                %                         coils(:,1:3)=coilsWithProsthSync(:,1:3);
                                %                         coils(:,4:15)=coilsWithProsthSync(:,6:17);
                                %                         TS_idx=1+find([diff(prosthSync(:,1));0]);
                                %                         TS_time = prosthSync(TS_idx, 1)-1 + prosthSync(TS_idx,2)/25000;
                                %                         TS_interval = [diff(TS_time);0] / 1000;
                                
                                pSync(:,1:2)=coilsSplit(:,4:5,1);
                                TS_idxS=1+find([diff(pSync(:,1));0]);
                                TS_timeS = pSync(TS_idxS, 1)-1 + pSync(TS_idxS,2)/25000;
                                TS_intervalS = [diff(TS_timeS);0] / 1000;
                                newFrameinFrame = fick2rot([45 0 0]);
                                
                                rotrotL = rot2rot(newFrameinFrame,rotLsplit(:,:,1));
                                rotrotR = rot2rot(newFrameinFrame,rotRsplit(:,:,1));
                                rotrotLxyz = rot2rot(newFrameinFrame,rotLsplitxyz(:,:,1));
                                rotrotRxyz = rot2rot(newFrameinFrame,rotRsplitxyz(:,:,1));
                                
                                
                                AngVelL=rot2angvelBJM20190107(rotrotL)/pi*180 * 1000;
                                AngVelR=rot2angvelBJM20190107(rotrotR)/pi*180 * 1000;
                                AngVelLxyz=rot2angvelBJM20190107(rotrotLxyz)/pi*180 * 1000;
                                AngVelRxyz=rot2angvelBJM20190107(rotrotRxyz)/pi*180 * 1000;
                                
                                t=1/1000:1/1000:(length(AngVelL)/1000);
                                %filtL=filtfilt(ones(3,15)/15,1,AngVelL);
                                %                             figure;
                                %                             plot(t,filtL(:,3),'r', t, filtL(:,2),'b', t, filtL(:,1),'g');
                                %                             hold on;
                                %                            % plot(t,filtAngVelR(:,3),'r', t, filtAngVelR(:,2),'b', t, filtAngVelR(:,1),'g');
                                %                             rectangle('Position', [0 min([filtL(:,3); filtL(:,2); filtL(:,1)]) 5 max([filtL(:,3); filtL(:,2); filtL(:,1)])-min([filtL(:,3); filtL(:,2); filtL(:,1)])],'EdgeColor','r','LineWidth',3)
                                %
                                %
                                %                             plot(TS_idxS(2:end)./1000,1./TS_intervalS./10,'.'); %to plot the prosthesis sync signal (pps/10)
                                %                             xlabel('Time (s)');
                                %                             ylabel('Eye Velocity (dps)') % left y-axis
                                %                             title('Left Eye Angular Velocity');
                                %                             legend('Yaw','RALP','LARP','Stim Pulses');
                                %                             % Comp flag
                                %                             saveas(gcf,[directory,'Raw Figures\',handles.subj_id.String{1},'-',handles.date.String,'-',handles.stim_axis.String{1},'-',handles.stim_type.String{1},'-',handles.stim_intensity.String{1},'.fig']);
                                %
                                %
                                %                                     legend('Yaw','RALP','LARP','Gyro')  %for vel
                                %legend('Horiz','Vert','Torsion','Gyro')
                                %                             close(gcf)
                                Segment.segment_code_version = mfilename;
                                Segment.raw_filename = filename;
                                Segment.start_t = t(1);
                                Segment.end_t = t(end);
                                Segment.LE_Position_X = angularPosL(:,3);
                                Segment.LE_Position_Y = angularPosL(:,2);
                                Segment.LE_Position_Z = angularPosL(:,1);
                                
                                Segment.RE_Position_X = angularPosR(:,3);
                                Segment.RE_Position_Y = angularPosR(:,2);
                                Segment.RE_Position_Z = angularPosR(:,1);
                                
                                Segment.LE_Velocity_X = AngVelLxyz(:,1);
                                Segment.LE_Velocity_Y = AngVelLxyz(:,2);
                                Segment.LE_Velocity_LARP = AngVelL(:,1);
                                Segment.LE_Velocity_RALP = AngVelL(:,2);
                                Segment.LE_Velocity_Z = AngVelL(:,3);
                                
                                Segment.RE_Velocity_X = AngVelRxyz(:,1);
                                Segment.RE_Velocity_Y = AngVelRxyz(:,2);
                                Segment.RE_Velocity_LARP = AngVelR(:,1);
                                Segment.RE_Velocity_RALP = AngVelR(:,2);
                                Segment.RE_Velocity_Z = AngVelR(:,3);
                                if any(isnan(Segment.LE_Position_X))
                                    Segment.LE_Position_X = zeros(length(Segment.RE_Position_X),1);
                                    Segment.LE_Position_Y = zeros(length(Segment.RE_Position_X),1);
                                    Segment.LE_Position_Z = zeros(length(Segment.RE_Position_X),1);
                                    Segment.LE_Velocity_X = zeros(length(Segment.RE_Position_X),1);
                                    Segment.LE_Velocity_Y = zeros(length(Segment.RE_Position_X),1);
                                    Segment.LE_Velocity_LARP = zeros(length(Segment.RE_Position_X),1);
                                    Segment.LE_Velocity_RALP = zeros(length(Segment.RE_Position_X),1);
                                    Segment.LE_Velocity_Z = zeros(length(Segment.RE_Position_X),1);
                                elseif any(isnan(Segment.RE_Position_X))
                                    Segment.RE_Position_X = zeros(length(Segment.LE_Position_X),1);
                                    Segment.RE_Position_Y = zeros(length(Segment.LE_Position_X),1);
                                    Segment.RE_Position_Z = zeros(length(Segment.LE_Position_X),1);
                                    Segment.RE_Velocity_X = zeros(length(Segment.LE_Position_X),1);
                                    Segment.RE_Velocity_Y = zeros(length(Segment.LE_Position_X),1);
                                    Segment.RE_Velocity_LARP = zeros(length(Segment.LE_Position_X),1);
                                    Segment.RE_Velocity_RALP = zeros(length(Segment.LE_Position_X),1);
                                    Segment.RE_Velocity_Z = zeros(length(Segment.LE_Position_X),1);
                                end
                                Segment.Fs = 1000;
                                Segment.Time_Eye = t';
                                Stim_Interp = zeros(boundaries(2)-boundaries(1)+1,1,length(boundaries)/2);
                                Time_Stim = TS_idxS./1000';
                                Stim = 1./TS_intervalS./10';
                                if any(strfind(filename,'sinusoidal')) || any(strfind(filename,'VirtSine'))
                                    Stim = denoiseSync(TS_intervalS,TS_idxS);
                                    if Stim(1)>40
                                        Stim = Stim./10;
                                    end
                                else
                                    Stim(Stim>4)=20;
                                    Stim(Stim<20)=0;
                                end
                                if length(Time_Stim) ~= length(Segment.Time_Eye)
                                    Time_Stim_Interp = Segment.Time_Eye;
                                    Stim_Interp = interp1(Time_Stim,Stim,Time_Stim_Interp);
                                end
                                if any(strfind(filename,'sinusoidal')) || any(strfind(filename,'VirtSine'))
                                else
                                    Stim_Interp(Stim_Interp<20) = 0;
                                end
                                Segment.Time_Stim = Time_Stim_Interp;
                                
                                Segment.HeadMPUVel_X = zeros(1,length(Stim_Interp))';
                                Segment.HeadMPUVel_Y = zeros(1,length(Stim_Interp))';
                                Segment.HeadMPUVel_Z = Stim_Interp;
                                
                                Segment.HeadMPUAccel_X = zeros(1,length(Stim_Interp))';
                                Segment.HeadMPUAccel_Y = zeros(1,length(Stim_Interp))';
                                Segment.HeadMPUAccel_Z = zeros(1,length(Stim_Interp))';
                                Segment.EyesRecorded = handles.eye_rec.String;
                                
                                handles.Segment = Segment;
                                
                                segments = str2num(handles.segment_number.String);
                                if segments == 0
                                    mkdir([directory,'Segments',handles.ispc.slash])
                                    setappdata(handles.save_segment,'foldername',[directory,'Segments',handles.ispc.slash]);
                                end
                                
                                [handles]=save_segment_Callback(hObject, eventdata, handles);
                                if str2num(handles.segment_number.String)== handles.totalSegment
                                    if handles.timesExported ==0
                                        handles.ss_FileName = [handles.subj_id.String{handles.subj_id.Value} '_ExperimentRecords']
                                        set(handles.exp_spread_sheet_name,'String',[handles.ss_FileName '.mat']);
                                        handles.exportCond = 3;
                                        guidata(hObject,handles)
                                        handles = export_data_Callback(hObject, eventdata, handles);
                                    else
                                        handles.exportCond = 2;
                                        guidata(hObject,handles)
                                        handles = export_data_Callback(hObject, eventdata, handles);
                                    end
                                end
                                guidata(hObject,handles)
                            end
                            prosthSync = [];
                            coils = [];
                            pSync = [];
                            rotRsplit = [];
                            rotLsplit = [];
                            rotRsplitxyz = [];
                            rotLsplitxyz = [];
                        end
                        prosthSync = [];
                        coils = [];
                        pSync = [];
                        rotRsplit = [];
                        rotLsplit = [];
                        rotRsplitxyz = [];
                        rotLsplitxyz = [];
                    elseif contains(handles.listing(fs).name,{'LP', 'LA', 'LH', 'RP', 'RA', 'RH','stim'}) && (handles.listing(fs).bytes==0)
                        handles.totalSegment = handles.totalSegment-1;
                        handles.raw_name.String = ['Total of ',num2str(handles.totalSegment),' files to process'];
                    end
                    prevStimCanal = getappdata(handles.stim_axis,'ax');
                    count = count +1;
                end
            end
            set(handles.save_indicator,'BackgroundColor','b')
            pause(1);
            set(handles.save_indicator,'BackgroundColor','g')
        end
        
    case 6 % Pupil Labs
        [handles] = auto_seg_general_Callback(hObject, eventdata, handles);
        
    case 7 % Moog Mechanical
        % Get all coil filenames
        handles.listing = dir(strcat(handles.PathNameofFiles,'\*.coil'));
        % Calculate gains with the gainfile selected
        [GAINSR, GAINSL]=getGains(handles.PathNameGains,handles.FileNameGains);
        % Calculate offsets with the offset files selected
        [ZEROS_R, ZEROS_L]=calcOffsets(handles.PathNameOffset1,handles.FileNameOffset1,handles.FileNameOffset2,1);
        
        
        count = 0; %% what is this used for 20190916
        % Make filenames into a table
        test=struct2table(handles.listing);
        % List all filenames
        allNames=test.name;
        % Remove all files that are 0 bytes (empty)
        handles.listing([handles.listing.bytes]==0)=[];
        % Indices for segmentation should be the number of files
        indsForSeg = 1:length(handles.listing);
        % Total segments should be the number of files
        handles.totalSegment = length(indsForSeg);
        % Sort the names so like directions are together
        sortNames = sort_nat({handles.listing(indsForSeg).name})'; %% double check 20190916
        % This sorts the listings, but does it sort all the data also? %%
        % 20190916
        [handles.listing.name] = sortNames{:};
        
        % Message showing segments to process should be total number of
        % files
        handles.raw_name.String = ['Total of ',num2str(handles.totalSegment),' files to process'];
        
        % Segments has not been defined yet... %%20190916
        %segments = str2num(handles.segment_number.String);
        % When and why does segments come into play? handles.segment_number
        % is a field on the form
        segments = 0;
        if isempty(handles.listing)
            
        else
            if segments>0
                s = segments+count;
            else
                s=1;
            end
            for fs = s:length(handles.listing)
                % This still hasn't been defined yet %% 20190916
                if isempty(handles.segment_number.String)
                    segments = 1; % 1 or 0? %% 20190916
                else
                    segments = str2num(handles.segment_number.String);
                end
                
                % Only open file if it contains one of the rotational
                % directions and is not empty and is a coil file
                if contains(handles.listing(fs).name,{'Yaw','LARP','RALP','Pitch','Roll'}) && (handles.listing(fs).bytes>0) && contains(handles.listing(fs).name,{'.coil'})
                    directory = [handles.listing(fs).folder,handles.ispc.slash];
                    filename = handles.listing(fs).name;
                    dashes = find(filename=='_');
                    dot = find(filename=='.');
                    amp = strfind(filename,'amp');
                    mpufilename = strcat(filename(1:end-5),'_MPUdata.txt');
                    
                    coilsWithProsthSync = readcoils(directory, filename, 1);
                    %% 20190903 MEG EDITING HERE
                    prosthSync(:,1:2)=coilsWithProsthSync(:,4:5);
                    coils(:,1:3)=coilsWithProsthSync(:,1:3);
                    coils(:,4:15)=coilsWithProsthSync(:,6:17);
                    mpu = readmpu(directory,mpufilename,1);
                    
                    % If prevStimCanal hasn't been set yet
                    if ~exist('prevStimCanal','var')
                        prevStimCanal = '';
                    end
                    % align coils and mpu file
                    [rotR,rotL,mpuAligned,coilsAligned] = align(mpu, coils, 2000, 0,[],GAINSR,GAINSL,ZEROS_R,ZEROS_L);
                    
                    % if didn't align properly, continue to next file
                    if isempty(rotR)
                        continue
                    end
                    % find mpu setting - might not need this? %%20190916
                    if contains(filename,'Yaw')
                        handles.canalInfo = 'Yaw';
                        mpuToUse = mpuAligned(:,8)./65536.*500;
                    elseif contains(filename,'LARP')
                        handles.canalInfo = 'LARP';
                        mpuToUse = mpuAligned(:,7)./65536.*500.*cosd(45) - mpuAligned(:,6)./65536.*500*cosd(45);
                    elseif contains(filename,'RALP')
                        handles.canalInfo = 'RALP';
                        mpuToUse = mpuAligned(:,7)./65536.*500.*cosd(45) + mpuAligned(:,6)./65536.*500*cosd(45);
                    elseif contains(filename,'Pitch')
                        handles.canalInfo = 'Pitch';
                        mpuToUse = mpuAligned(:,6)./65536.*500;
                    elseif contains(filename,'Roll')
                        handles.canalInfo = 'Roll';
                        mpuToUse = mpuAligned(:,7)./65536.*500;
                    end
                    % filter mpu a bit
                    mpuToUse = filtfilt(ones(1,30)/30,1,mpuToUse);
                    
                    % input all settings
                    handles.subj_id.String = {filename(dashes(2)+1:dashes(3)-1)};
                    handles.visit_number.String = {'NA'};
                    handles.date.String = filename(1:dashes(1)-1);
                    handles.exp_type.String = {'MechanicalStim'};
                    handles.exp_condition.String = {'Sinusoidal'};
                    % 20190904 Meg Changing
                    index = strfind(filename, 'hz');
                    if isempty(index)
                        handles.stim_frequency.String = '1';
                    else
                        i = 2;
                        while ~(strcmp(filename(index(1)-i),'-'))
                            i = i + 1;
                        end
                        i = i-1;
                        string = filename(index(1)-i:index(1)-1);
                        split = strsplit(string,'p');
                        if length(split) ~= 1
                            string = strcat(split(1),'.',split(2));
                        end
                        handles.stim_frequency.String = char(string);
                    end
                    setappdata(handles.stim_frequency,'fq',char(string));
                    handles.load_spread_sheet.BackgroundColor = [0.94 0.94 0.94];
                    handles.load_spread_sheet.Enable = 'on';
                    
                    
                    setappdata(handles.stim_axis,'ax',handles.canalInfo);
                    handles.stim_axis.String = handles.canalInfo;
                    setappdata(handles.stim_type,'type',handles.canalInfo);
                    handles.stim_type.String = {handles.canalInfo};
                    
                    if ~strcmp(prevStimCanal,getappdata(handles.stim_axis,'ax')) && (str2num(handles.segment_number.String)>1)
                        if handles.timesExported ==0
                            handles.ss_FileName = [handles.subj_id.String{handles.subj_id.Value} '_ExperimentRecords']
                            set(handles.exp_spread_sheet_name,'String',[handles.ss_FileName '.mat']);
                            handles.exportCond = 3;
                            guidata(hObject,handles)
                            handles = export_data_Callback(hObject, eventdata, handles);
                        else
                            handles.exportCond = 2;
                            guidata(hObject,handles)
                            handles = export_data_Callback(hObject, eventdata, handles);
                        end
                        
                    end
                    
                    index = strfind(filename,'dps');
                    if isempty(index)
                        string = [];
                    else
                        i = 2;
                        while ~(strcmp(filename(index(1)-i),'-'))
                            i = i + 1;
                        end
                        i = i-1;
                        string = filename(index(1)-i:index(1)-1);
                        split = strsplit(string,'p');
                        if length(split) ~= 1
                            string = strcat(split(1),'.',split(2));
                        end
                    end
                    setappdata(handles.stim_intensity,'intensity',char(string));
                    handles.stim_intensity.String = char(string);
                    [handles] = update_seg_filename(hObject, eventdata, handles);
                    
                    % Add add-on with counter to make each filename unique
                    handles.string_addon = num2str(fs);
                    
                    % Angular position
                    handles.angularPosL = rot2fick(rotL);
                    handles.angularPosR = rot2fick(rotR);
                    
                    newFrameinFrame = fick2rot([45 0 0]);
                    
                    % rotation vector in Larp, Ralp, Yaw
                    rotrotL = rot2rot(newFrameinFrame,rotL); % LARP, RALP, Yaw
                    rotrotR = rot2rot(newFrameinFrame,rotR); % LARP, RALP, Yaw
                    
                    % Angular velocity
                    handles.AngVelL=rot2angvelBJM20190107(rotrotL)/pi*180 * 1000;
                    handles.AngVelR=rot2angvelBJM20190107(rotrotR)/pi*180 * 1000;
                    handles.AngVelLxyz=rot2angvelBJM20190107(rotL)/pi*180 * 1000;
                    handles.AngVelRxyz=rot2angvelBJM20190107(rotR)/pi*180 * 1000;
                    
                    rotRsplit(:,:,1) = rotrotR;
                    rotLsplit(:,:,1) = rotrotL;
                    rotRsplitxyz(:,:,1) = rotR;
                    rotLsplitxyz(:,:,1) = rotL;
                    
                    % XYZ
                    angularPosL = rot2fick(rotLsplitxyz(:,:,1));
                    angularPosR = rot2fick(rotRsplitxyz(:,:,1));
                    
                    
                    AngVelL=rot2angvelBJM20190107(rotLsplit(:,:,1))/pi*180 * 1000;
                    AngVelR=rot2angvelBJM20190107(rotRsplit(:,:,1))/pi*180 * 1000;
                    AngVelLxyz=rot2angvelBJM20190107(rotRsplitxyz(:,:,1))/pi*180 * 1000;
                    AngVelRxyz=rot2angvelBJM20190107(rotLsplitxyz(:,:,1))/pi*180 * 1000;
                    
                    t=1/1000:1/1000:(length(AngVelL)/1000);

                    
                    Segment.segment_code_version = mfilename;
                    Segment.raw_filename = filename;
                    Segment.start_t = t(1);
                    Segment.end_t = t(end);
                    Segment.LE_Position_X = angularPosL(:,3);
                    Segment.LE_Position_Y = angularPosL(:,2);
                    Segment.LE_Position_Z = angularPosL(:,1);
                    
                    Segment.RE_Position_X = angularPosR(:,3);
                    Segment.RE_Position_Y = angularPosR(:,2);
                    Segment.RE_Position_Z = angularPosR(:,1);
                    
                    Segment.LE_Velocity_X = AngVelLxyz(:,1);
                    Segment.LE_Velocity_Y = AngVelLxyz(:,2);
                    Segment.LE_Velocity_LARP = AngVelL(:,1);
                    Segment.LE_Velocity_RALP = AngVelL(:,2);
                    Segment.LE_Velocity_Z = AngVelL(:,3);
                    
                    Segment.RE_Velocity_X = AngVelRxyz(:,1);
                    Segment.RE_Velocity_Y = AngVelRxyz(:,2);
                    Segment.RE_Velocity_LARP = AngVelR(:,1);
                    Segment.RE_Velocity_RALP = AngVelR(:,2);
                    Segment.RE_Velocity_Z = AngVelR(:,3);
                    if any(isnan(Segment.LE_Position_X))
                        Segment.LE_Position_X = zeros(length(Segment.RE_Position_X),1);
                        Segment.LE_Position_Y = zeros(length(Segment.RE_Position_X),1);
                        Segment.LE_Position_Z = zeros(length(Segment.RE_Position_X),1);
                        Segment.LE_Velocity_X = zeros(length(Segment.RE_Position_X),1);
                        Segment.LE_Velocity_Y = zeros(length(Segment.RE_Position_X),1);
                        Segment.LE_Velocity_LARP = zeros(length(Segment.RE_Position_X),1);
                        Segment.LE_Velocity_RALP = zeros(length(Segment.RE_Position_X),1);
                        Segment.LE_Velocity_Z = zeros(length(Segment.RE_Position_X),1);
                    elseif any(isnan(Segment.RE_Position_X))
                        Segment.RE_Position_X = zeros(length(Segment.LE_Position_X),1);
                        Segment.RE_Position_Y = zeros(length(Segment.LE_Position_X),1);
                        Segment.RE_Position_Z = zeros(length(Segment.LE_Position_X),1);
                        Segment.RE_Velocity_X = zeros(length(Segment.LE_Position_X),1);
                        Segment.RE_Velocity_Y = zeros(length(Segment.LE_Position_X),1);
                        Segment.RE_Velocity_LARP = zeros(length(Segment.LE_Position_X),1);
                        Segment.RE_Velocity_RALP = zeros(length(Segment.LE_Position_X),1);
                        Segment.RE_Velocity_Z = zeros(length(Segment.LE_Position_X),1);
                    end
                    Segment.Fs = 1000;
                    Segment.Time_Eye = t';
                    Stim_Interp = mpuToUse;
                    Time_Stim = Segment.Time_Eye;
                    
                    Segment.Time_Stim = Time_Stim;
                    
                    Segment.HeadMPUVel_X = mpuAligned(:,7)./65536.*500;
                    Segment.HeadMPUVel_Y = mpuAligned(:,6)./65536.*500;
                    Segment.HeadMPUVel_Z = mpuAligned(:,8)./65536.*500;
                    
                    Segment.HeadMPUAccel_X = zeros(1,length(Stim_Interp))';
                    Segment.HeadMPUAccel_Y = zeros(1,length(Stim_Interp))';
                    Segment.HeadMPUAccel_Z = zeros(1,length(Stim_Interp))';
                    Segment.EyesRecorded = handles.eye_rec.String;
                    
                    handles.Segment = Segment;
                    
                    segments = str2num(handles.segment_number.String);
                    if segments == 0
                        mkdir([directory,'Segments',handles.ispc.slash])
                        setappdata(handles.save_segment,'foldername',[directory,'Segments',handles.ispc.slash]);
                    end
                    
                    handles.stim_axis.String = {handles.stim_axis.String};
                    handles.stim_frequency.String = {char(handles.stim_frequency.String)};
                    handles.stim_intensity.String = {handles.stim_intensity.String};
                    [handles]=save_segment_Callback(hObject, eventdata, handles);
                    if str2num(handles.segment_number.String)== handles.totalSegment
                        if handles.timesExported ==0
                            handles.ss_FileName = [handles.subj_id.String{handles.subj_id.Value} '_ExperimentRecords']
                            set(handles.exp_spread_sheet_name,'String',[handles.ss_FileName '.mat']);
                            handles.exportCond = 3;
                            guidata(hObject,handles)
                                handles = export_data_Callback(hObject, eventdata, handles);
                            else
                                handles.exportCond = 2;
                                guidata(hObject,handles)
                                handles = export_data_Callback(hObject, eventdata, handles);
                            end
                        end
                        guidata(hObject,handles)
                        prosthSync = [];
                        coils = [];
                        coilsSplit=[];
                        pSync = [];
                        rotRsplit = [];
                        rotLsplit = [];
                        rotRsplitxyz = [];
                        rotLsplitxyz = [];
                elseif contains(handles.listing(fs).name,{'Yaw','LARP','RALP','Pitch','Roll'}) && (handles.listing(fs).bytes==0)
                    handles.totalSegment = handles.totalSegment-1;
                    handles.raw_name.String = ['Total of ',num2str(handles.totalSegment),' files to process'];
                end
                prevStimCanal = getappdata(handles.stim_axis,'ax');
                count = count +1;
            end
        end
        set(handles.save_indicator,'BackgroundColor','b')
        pause(1);
        set(handles.save_indicator,'BackgroundColor','g')
        
        
end
end

function ok_axis_Callback(hObject, eventdata, handles)
canalInfo.stimCanal = [eventdata.Source.Parent.Children(3).String(eventdata.Source.Parent.Children(3).Value),...
    eventdata.Source.Parent.Children(5).String(eventdata.Source.Parent.Children(5).Value),...
    eventdata.Source.Parent.Children(7).String(eventdata.Source.Parent.Children(7).Value)];

canalInfo.stimNum = [{eventdata.Source.Parent.Children(4).String(eventdata.Source.Parent.Children(4).Value)},...
    {eventdata.Source.Parent.Children(6).String(eventdata.Source.Parent.Children(6).Value)},...
    {eventdata.Source.Parent.Children(8).String(eventdata.Source.Parent.Children(8).Value)}];
a = eventdata.Source.Parent.Children(2);
canalInfo.animal = a.String{a.Value};
setappdata(handles.stim_axis,'axisInfo',canalInfo);
uiresume(gcbf)
end

function changeENum(hObject, eventdata, handles)

switch hObject.Value
    case 1 %GiGi Left Ear
        hObject.Parent.Children(4).Value = [4 5 6];
        hObject.Parent.Children(6).Value = [1 2 3];
        hObject.Parent.Children(8).Value = [7 8 9];
    case 2 %MoMo Left Ear
        hObject.Parent.Children(4).Value = [7 8 9];
        hObject.Parent.Children(6).Value = [1 2 3];
        hObject.Parent.Children(8).Value = [4 5 6];
    case 3 %Nancy
    case 4 %Yoda Right Ear
        hObject.Parent.Children(4).Value = [1 2 3];
        hObject.Parent.Children(6).Value = [4 5 6 14];
        hObject.Parent.Children(8).Value = [7 8 9 15];
    case 5 %Didi
        hObject.Parent.Children(4).Value = [4 5 6];
        hObject.Parent.Children(6).Value = [1 2 3];
        hObject.Parent.Children(8).Value = [7 8 9];
    case 6 %Fred
        hObject.Parent.Children(4).Value = [4 5 6];
        hObject.Parent.Children(6).Value = [1 2 3];
        hObject.Parent.Children(8).Value = [7 8 9];
end
end



function [options] = auto_seg_dialog(hObject, eventdata, handles)


d = dialog('Position',[300 300 400 150],'Name','Select stimulus type');
txt = uicontrol('Parent',d,...
    'Style','text',...
    'Position',[20 80 300 40],...
    'String','Please select the stimulus type for this file');

popup = uicontrol('Parent',d,...
    'Style','popup',...
    'Position',[75 70 225 25],...
    'String',{'Pulse Train';'Electric Only Sinusoid [CED]';'Mechanical Sinusoid';'LD VOG Electrical Only';'Ross 710 Moog Coils Electrical';'Pupil Labs';'Ross 710 Moog Coils Mechanical'},...
    'Callback',@choose_stimuli_callback);
%             'Callback',{@popup_callback,hObject, eventdata, handles});

btn = uicontrol('Parent',d,...
    'Position',[89 20 70 25],...
    'String','Proceed',...
    'Callback','delete(gcf)');

%     'Callback',@popup_closefcn);

choice = 'Pulse Train';

% Wait for d to close before running to completion
uiwait(d);

    function choose_stimuli_callback(popup,event)
        idx = popup.Value;
        popup_items = popup.String;
        
        choice = char(popup_items(idx,:));
        
        
        
    end

switch choice
    
    case 'Pulse Train'
        options = pulse_train_dialog(hObject, eventdata, handles);
        options.stim = 1;
    case 'Electric Only Sinusoid [CED]'
        options = elec_only_sine_CED_dialog(hObject, eventdata, handles);
        options.stim = 2;
    case 'Mechanical Sinusoid'
        options.stim = 3;
        
    case 'LD VOG Electrical Only'
        options.stim = 4;
    case 'Ross 710 Moog Coils Electrical'
        options.stim = 5;
    case 'Pupil Labs'
        options.stim = 6;
    case 'Ross 710 Moog Coils Mechanical'
        options.stim = 7;
end



% analyze_new_voma_file_Callback(hObject, eventdata, handles)


end





function [options] = pulse_train_dialog(hObject, eventdata, handles)


d2 = dialog('Position',[300 300 400 400],'Name','Pulse Train Params');
txt1 = uicontrol('Parent',d2,...
    'Style','text',...
    'Position',[20 300 350 40],...
    'String','Please enter the ON time of each pulse train cycle [ms]:');

in1 = uicontrol('Parent',d2,...
    'Style','edit',...
    'Position',[140 290 75 25],...
    'Units','normalized',...
    'Callback',@ontime_callback);

txt2 = uicontrol('Parent',d2,...
    'Style','text',...
    'Position',[20 225 300 40],...
    'String','Please enter the OFF time of each pulse train cycle [ms]:');

in2 = uicontrol('Parent',d2,...
    'Style','edit',...
    'Position',[140 215 75 25],...
    'Units','normalized',...
    'Callback',@offtime_callback);

txt3 = uicontrol('Parent',d2,...
    'Style','text',...
    'Position',[20 150 300 40],...
    'String','Please enter the pause time between stimulus conditions [ms]');

in3 = uicontrol('Parent',d2,...
    'Style','edit',...
    'Position',[140 140 75 25],...
    'Units','normalized',...
    'Callback',@ISI_callback);


btn = uicontrol('Parent',d2,...
    'Position',[89 20 70 25],...
    'String','Proceed',...
    'Callback','delete(gcf)');


options.ontime = [];
options.offtime = [];
options.ISI = [];

% Wait for d to close before running to completion
uiwait(d2);


    function ontime = ontime_callback(popup,event)
        ontime = str2double(get(popup,'string'));
        
    end


    function offtime = offtime_callback(popup,event)
        offtime = str2double(get(popup,'string'));
    end

    function ISI = ISI_callback(popup,event)
        ISI = str2double(get(popup,'string'));
    end


options.ontime = ontime;
options.offtime = offtime;
options.ISI = ISI;

end


function [options] = elec_only_sine_CED_dialog(hObject, eventdata, handles)


d2 = dialog('Position',[300 300 400 400],'Name','Pulse Train Params');
txt1 = uicontrol('Parent',d2,...
    'Style','text',...
    'Position',[20 300 350 40],...
    'String','Please enter the freq. of the sine tested [Hz]:');

in1 = uicontrol('Parent',d2,...
    'Style','edit',...
    'Position',[140 290 75 25],...
    'Units','normalized',...
    'Callback',@freq_callback);

txt2 = uicontrol('Parent',d2,...
    'Style','text',...
    'Position',[20 225 300 40],...
    'String','Please enter the pre- and post- time added to each segment [ms]:');

in2 = uicontrol('Parent',d2,...
    'Style','edit',...
    'Position',[140 215 75 25],...
    'Units','normalized',...
    'Callback',@preposttime_callback);

txt3 = uicontrol('Parent',d2,...
    'Style','text',...
    'Position',[20 150 300 40],...
    'String','Please enter the pause time between stimulus conditions [ms]');

in3 = uicontrol('Parent',d2,...
    'Style','edit',...
    'Position',[140 140 75 25],...
    'Units','normalized',...
    'Callback',@ISI_callback);




btn = uicontrol('Parent',d2,...
    'Position',[89 20 70 25],...
    'String','Proceed',...
    'Callback','delete(gcf)');


options.ontime = [];
options.offtime = [];
options.ISI = [];
options.preposttime = [];
% Wait for d to close before running to completion
uiwait(d2);


    function [ontime, offtime] = freq_callback(popup,event)
        freq = str2double(get(popup,'string'));
        ontime = ((1/freq)/2) * 1000; % This parameter is saved in [ms]
        offtime = (1/freq)/2 * 1000; % This parameter is saved in [ms]
    end

    function preposttime = preposttime_callback(popup,event)
        preposttime = str2double(get(popup,'string'));
        
    end
    function ISI = ISI_callback(popup,event)
        ISI = str2double(get(popup,'string'));
    end


options.ontime = ontime;
options.offtime = offtime;
options.ISI = ISI;
options.preposttime = preposttime;
end

% --- Executes on button press in plot_MPUAccelData.
function plot_MPUAccelData_Callback(hObject, eventdata, handles)
% hObject    handle to plot_MPUAccelData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.params.plot_MPUAccelData = 1;
else
    handles.params.plot_MPUAccelData = 0;
end

% Update plots!
keep_plot_limit = true; % We want to keep the same plot limits

plot_segment_data(hObject, eventdata, handles,keep_plot_limit)

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of plot_MPUGyroData
end


% --- Executes on button press in plot_IPR_flag.
function plot_IPR_flag_Callback(hObject, eventdata, handles)
% hObject    handle to plot_IPR_flag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.params.plot_IPR_flag = 1;
else
    handles.params.plot_IPR_flag = 0;
end

% Update plots!
keep_plot_limit = false; % We do not want to keep the same plot limits

plot_segment_data(hObject, eventdata, handles,keep_plot_limit)

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of plot_MPUGyroData
end


% --- Executes on button press in auto_seg_lasker.
function auto_seg_lasker_Callback(hObject, eventdata, handles)
% hObject    handle to auto_seg_lasker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% upper_trigLev = handles.params.upper_trigLev;
% lower_trigLev = handles.params.lower_trigLev;
%
% auto_segment_Callback(hObject, eventdata, handles,upper_trigLev,lower_trigLev)

handles.timesExported =0;
handles.whereToStartExp = 1;
handles.experimentdata = {};
setappdata(handles.export_data,'data',handles.experimentdata)
guidata(hObject,handles)
handles.PathNameofFiles = uigetdir(cd,'Please choose the folder where the coil files are saved');
cd( handles.PathNameofFiles)
handles.raw_PathName = handles.PathNameofFiles;
[FieldGainFile,FieldGainPath,FieldGainFilterIndex] = uigetfile('*.*','Please choose the field gains for this experiment');
if ~isempty(handles.exp_spread_sheet_name.String)
    if ~isfile([FieldGainPath,'\',handles.exp_spread_sheet_name.String])
        handles.exp_spread_sheet_name.String = '';
    end
end

handles.raw_FieldGainPath = FieldGainPath;
handles.raw_FieldGainFile = FieldGainFile;

eyesRecorded = figure;
eyesRecorded.Units = 'normalized';
eyesRecorded.Position = [1.4    0.4    0.075    0.15];
handles.leftEye = uicontrol(eyesRecorded,'Style','checkbox','String','Left Eye');
handles.leftEye.Units = 'normalized';
handles.leftEye.Position = [0.03    0.5    0.5 .5];
handles.rightEye = uicontrol(eyesRecorded,'Style','checkbox','String','Right Eye');
handles.rightEye.Units = 'normalized';
handles.rightEye.Position = [0.5 0.5 .5 .5];
handles.leftEyeCh = uicontrol(eyesRecorded,'Style','listbox','String',{' ','Ch1Ch2','Ch3Ch4'},'Value',3);
handles.leftEyeCh.Units = 'normalized';
handles.leftEyeCh.Position = [0.03    0.3    0.410    0.3000];
handles.rightEyeCh = uicontrol(eyesRecorded,'Style','listbox','String',{' ','Ch1Ch2','Ch3Ch4'},'Value',2);
handles.rightEyeCh.Units = 'normalized';
handles.rightEyeCh.Position = [0.5    0.3    0.410    0.3000];
handles.eyes = uicontrol(eyesRecorded,'Style','radiobutton','String','ok');
handles.eyes.Units = 'normalized';
handles.eyes.Position = [0.3    0.05    0.5    0.2000];
handles.eyes.FontSize = 18;
waitfor(handles.eyes,'Value');


if handles.leftEye.Value == 0
    handles.EyeCh = handles.leftEyeCh.String{2};
    handles.eye_rec.Value = 4;
    
elseif handles.rightEye.Value == 0
    handles.EyeCh = handles.rightEyeCh.String{3};
    handles.eye_rec.Value = 3;
else
    handles.EyeCh = {handles.rightEyeCh.String{2},handles.rightEyeCh.String{3}};
    handles.eye_rec.Value = 2;
end
handles.text53.BackgroundColor = [0.94 0.94 0.94];
delete(eyesRecorded)



handles.string_addon = [];
%         % Import the data from the .smr file
%         [d]=ImportSMR_PJBv2(FileName,PathName);




% Import the Field Gain file, collected using the vor/showall
% software
fieldgainname = [FieldGainPath FieldGainFile];
delimiter = '\t';
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

fileID = fopen(fieldgainname,'r');

dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN, 'ReturnOnError', false);

fclose(fileID);

FieldGains = [dataArray{1:end-1}];

% During my daily calibration procedure, I zero-out the fields to
% have no offsets with a test coil.
coilzeros = [0 0 0 0 0 0 0 0 0 0 0 0];
bigFcn = @(s) (s.bytes > 10000);
tempList = dirPlus(handles.PathNameofFiles,'Struct',true,'FileFilter','\.smr$','Depth',0,'ValidateFileFcn', bigFcn);
t = datetime({tempList.date}','InputFormat','dd-MM-yyyy HH:mm:ss');
[b,idx] = sortrows(t);
handles.listing = tempList(idx);

count = 0;
indsForSeg = 1:length(handles.listing);
handles.totalSegment = length(indsForSeg);


handles.string_addon = [];
guidata(handles.auto_segment,handles)
f=figure('Name','Choose the stimulator channels that correspond to the canal');
f.Position = [360 278 450 290];
set1_stimNum = uicontrol(f,'Style','listbox','String',{'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15'},'Max',15,'Min',0,'Value',[7:9],'Position',[300 5 130 215]);
set1_stimCanal = uicontrol(f,'Style','popupmenu','String',{'LHRH','RALP','LARP'},'Value',1,'fontsize',8,'Position',[305 225 100 30]);
set2_stimNum = uicontrol(f,'Style','listbox','String',{'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15'},'Max',15,'Min',0,'Value',[1:3],'Position',[165 5 130 215]);
set2_stimCanal = uicontrol(f,'Style','popupmenu','String',{'LHRH','RALP','LARP'},'Value',2,'fontsize',8,'Position',[170 225 100 30]);
set3_stimNum = uicontrol(f,'Style','listbox','String',{'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15'},'Max',15,'Min',0,'Value',[4:6],'Position',[30 5 130 215]);
set3_stimCanal = uicontrol(f,'Style','popupmenu','String',{'LHRH','RALP','LARP'},'Value',3,'fontsize',8,'Position',[35 225 100 30]);
animalEnum = uicontrol(f,'Style','popupmenu','String',{'GiGi','MoMo','Nancy','Yoda','JoJo'},'Value',1,'fontsize',8,'Position',[200 260 50 25],'CallBack',@changeENum);
okButton = uicontrol(f,'Style','pushbutton','String','Ok','fontsize',12,'Position',[415 230 30 30],'CallBack',{@ok_axis_Callback, handles});
%guidata(f,handles)
uiwait(gcf)
delete(gcf)
repeat = 0;
handles = guidata(handles.auto_segment);

handles.canalInfo = getappdata(handles.stim_axis,'axisInfo');
handles.raw_name.String = ['Total of ',num2str(handles.totalSegment),' files to process'];

prosthSync = [];
handles.canalInfo = getappdata(handles.stim_axis,'axisInfo');
handles.segment_number.String = '0';
segments = str2num(handles.segment_number.String);
if isempty(handles.listing)
    
else
    if segments>0
        s = segments+count;
    else
        s=1;
    end
    prevStimCanal = '';
    dAsgnFlag = 1;
    dAsgn = 0;
    for fs = s:length(handles.listing)
        segments = str2num(handles.segment_number.String);
        
        if contains(handles.listing(fs).name,{'LP', 'LA', 'LH', 'RP', 'RA', 'RH','stim'}) && (handles.listing(fs).bytes>0)
            directory = [handles.listing(fs).folder,handles.ispc.slash];
            filename = handles.listing(fs).name;
            handles.raw_FileName = filename;
            underS = find(filename=='_');
            dash = find(filename=='-');
            delin = sort([underS dash],'ascend');
            dot = find(filename=='.');
            stimPos = strfind(filename,'stim');
            refPos = strfind(filename,'ref');
            ipgPos = strfind(filename,'IPG');
            ratePos = strfind(filename,'rate');
            rate = str2num(filename(ratePos+4:delin(12)-1));
            stim = str2num(filename(stimPos+4:delin(6)-1));
            refNum = str2num(filename(refPos+3:delin(7)-1));
            subj = filename(delin(3)+1:delin(4)-1);
            if isempty(subj)
                subj = handles.canalInfo.animal;
            end
            if any(strfind(filename,'phaseDur'))
                p1dPos = strfind(filename,'phaseDur');
                p1d = str2num(filename(p1dPos+9:ipgPos-1));
                ipg = str2num(filename(ipgPos+3:delin(13)-1));
                p2d = p1d;
                amp = strfind(filename,'amp');
                nextD = find(delin>amp,1);
                p1amp = str2num(filename(amp(1)+3:delin(nextD)-1));
                p2amp = p1amp;
            elseif any(strfind(filename,'phase1Dur'))
                p1dPos = strfind(filename,'phase1Dur');
                p1d = str2num(filename(p1dPos+9:delin(9)-1));
                p2dPos = strfind(filename,'phase2Dur');
                p2d = str2num(filename(p2dPos+9:delin(11)-1));
                ipg = str2num(filename(ipgPos+3:delin(13)-1));
                p1aPos = strfind(filename,'phase1amp');
                p1amp = str2num(filename(p1aPos+9:delin(8)-1));
                p2aPos = strfind(filename,'phase2amp');
                p2amp = str2num(filename(p2aPos+9:delin(10)-1));
            end
            
            if any(strfind(filename,'defaultStart'))
                dS = 1;
                ftemp = handles.listing(fs+1).name;
                if any(strfind(ftemp,'phaseDur'))
                    p1dPosT = strfind(ftemp,'phaseDur');
                    ipgPosT = strfind(ftemp,'IPG');
                    p1dT = str2num(ftemp(p1dPosT+9:ipgPosT-1));
                    p2dT = p1dT;
                elseif any(strfind(ftemp,'phase1Dur'))
                    underST = find(ftemp=='_');
                    dashT = find(ftemp=='-');
                    delinT = sort([underST dashT],'ascend');
                    p2dPosT = strfind(ftemp,'phase2Dur');
                    p2dT = ftemp(p2dPosT+9:delinT(11)-1);
                end
                start = strfind(filename,'defaultStart');
                handles.string_addon = ['-dSp2d',p2dT,filename(start:delin(14)-1)];
                if dAsgnFlag
                    dAsgn = dAsgn +1;
                    dAsgnFlag = 0;
                end
            else
                dS = 0;
                handles.string_addon = [''];
                dAsgnFlag = 1;
            end
            
            % This will use the first data point as a reference position
            ref = 0;
            % Don't put a smapling rate param. in, we will extract it from the
            % CED file.
            Fs = [];
            % Mark the 'system_code'
            switch handles.params.Lasker_param2
                case 1 % Head is upright, but we still need to correct the coil signals into proper X, Y, Z coordinates
                    system_code = 2;
                case 2
                    system_code = 3;
                case 3
                    system_code = 4;
            end
            % Indicate the DAQ code
            DAQ_code = 3; % Lasker System as recorded by a CED 1401 device
            
            
            [RawData] = voma__processeyemovements(directory,filename,FieldGains,coilzeros,ref,system_code,DAQ_code,1);
            
            % Attempt to
            
            if ((handles.eye_rec.Value == 3) && (strcmp(handles.EyeCh,'Ch3Ch4'))) || ((handles.eye_rec.Value == 4) && (strcmp(handles.EyeCh,'Ch1Ch2')))
                Data.RE_Position_X = RawData.LE_Pos_X;
                Data.RE_Position_Y = RawData.LE_Pos_Y;
                Data.RE_Position_Z = RawData.LE_Pos_Z;
                
                Data.LE_Position_X = RawData.RE_Pos_X;
                Data.LE_Position_Y = RawData.RE_Pos_Y;
                Data.LE_Position_Z = RawData.RE_Pos_Z;
                
                Data.RE_Velocity_X = RawData.LE_Vel_X;
                Data.RE_Velocity_Y = RawData.LE_Vel_Y;
                Data.RE_Velocity_LARP = RawData.LE_Vel_LARP;
                Data.RE_Velocity_RALP = RawData.LE_Vel_RALP;
                Data.RE_Velocity_Z = RawData.LE_Vel_Z;
                
                Data.LE_Velocity_X = RawData.RE_Vel_X;
                Data.LE_Velocity_Y = RawData.RE_Vel_Y;
                Data.LE_Velocity_LARP = RawData.RE_Vel_LARP;
                Data.LE_Velocity_RALP = RawData.RE_Vel_RALP;
                Data.LE_Velocity_Z = RawData.RE_Vel_Z;
            else
                Data.LE_Position_X = RawData.LE_Pos_X;
                Data.LE_Position_Y = RawData.LE_Pos_Y;
                Data.LE_Position_Z = RawData.LE_Pos_Z;
                
                Data.RE_Position_X = RawData.RE_Pos_X;
                Data.RE_Position_Y = RawData.RE_Pos_Y;
                Data.RE_Position_Z = RawData.RE_Pos_Z;
                
                Data.LE_Velocity_X = RawData.LE_Vel_X;
                Data.LE_Velocity_Y = RawData.LE_Vel_Y;
                Data.LE_Velocity_LARP = RawData.LE_Vel_LARP;
                Data.LE_Velocity_RALP = RawData.LE_Vel_RALP;
                Data.LE_Velocity_Z = RawData.LE_Vel_Z;
                
                Data.RE_Velocity_X = RawData.RE_Vel_X;
                Data.RE_Velocity_Y = RawData.RE_Vel_Y;
                Data.RE_Velocity_LARP = RawData.RE_Vel_LARP;
                Data.RE_Velocity_RALP = RawData.RE_Vel_RALP;
                Data.RE_Velocity_Z = RawData.RE_Vel_Z;
            end
            Data.segment_code_version = mfilename;
            Data.raw_filename = filename;
            
            Data.Fs = RawData.Fs;
            
            
            
            
            Data.Time_Eye = [0:length(RawData.LE_Vel_LARP)-1]/Data.Fs;
            Data.Time_Stim = RawData.ElecStimTrig';
            
            if isempty(RawData.ElecStimTrig)
                
                Data.Stim_Trig = [];
                Data.Time_Stim = Data.Time_Eye;
            else
                % We will calculate PR using a first order backwards difference
                % instantaneous rate approx. We are not using a central
                % difference, since it will smear/smooth the Pulse rate values
                PR = 1./diff(RawData.ElecStimTrig(:,1));
                % To have the same number of PR values as pulse times, we will
                % copy the first entry in the array, and append the PR array in
                % the front. The first value in the PR array is really
                % "PulseTime(2)-PulseTime(1)". The actual value plotted/saved
                % here is for graphical purposes only and the actual pulse
                % times themselves will be used for analysis.
                Data.Stim_Trig = [PR(1) PR'];
                
            end
            
            % Kludge for now!
            Data.HeadMPUVel_X = zeros(length(Data.Time_Eye),1);
            Data.HeadMPUVel_Y = zeros(length(Data.Time_Eye),1);
            Data.HeadMPUVel_Z = RawData.Var_x083;
            
            Data.HeadMPUAccel_X = zeros(length(Data.Time_Eye),1);
            Data.HeadMPUAccel_Y = zeros(length(Data.Time_Eye),1);
            Data.HeadMPUAccel_Z = zeros(length(Data.Time_Eye),1);
            
            
            temp = filename;
            temp(delin(1)) = [];
            
            if isempty(segments==0) || (segments==0)
                handles.exp_condition.String = {'PulseTrains'};
                handles.subj_id.String = {subj};
                handles.visit_number.String = {'NA'};
                handles.date.String = temp(1:delin(2)-2);
                handles.exp_type.String = {'ElectricalStim'};
                if isempty(rate)
                    prompt = {'Enter the stimulation rate (pps):'};
                    t1 = 'Input';
                    dims = [1 35];
                    definput = {'200'};
                    answer = inputdlg(prompt,t1,dims,definput);
                else
                    answer = {num2str(rate)};
                end
                handles.stim_frequency.String = {[answer{1},'pps']};
                setappdata(handles.stim_frequency,'fq',[answer{1},'pps']);
                handles.load_spread_sheet.BackgroundColor = [0.94 0.94 0.94];
                handles.load_spread_sheet.Enable = 'on';
                
                %                             if contains(handles.stim_axis.String,'L')
                %                                 handles.implant.String={'Left'};
                %                             else
                %                                 handles.implant.String={'Right'};
                %                             end
            end
            
            stimnum = {num2str(stim)};
            switch stimnum{1}
                case handles.canalInfo.stimNum{1}
                    setappdata(handles.stim_axis,'ax',handles.canalInfo.stimCanal{1});
                    handles.stim_axis.String = handles.canalInfo.stimCanal(1);
                    setappdata(handles.stim_type,'type',handles.stim_type.String{1});
                    handles.stim_axis_confirm.String = handles.canalInfo.stimCanal{1};
                case handles.canalInfo.stimNum{2}
                    setappdata(handles.stim_axis,'ax',handles.canalInfo.stimCanal{2});
                    handles.stim_axis.String = handles.canalInfo.stimCanal(2);
                    setappdata(handles.stim_type,'type',handles.stim_type.String{1});
                    handles.stim_axis_confirm.String = handles.canalInfo.stimCanal{2};
                case handles.canalInfo.stimNum{3}
                    setappdata(handles.stim_axis,'ax',handles.canalInfo.stimCanal{3});
                    handles.stim_axis.String = handles.canalInfo.stimCanal(3);
                    setappdata(handles.stim_type,'type',handles.stim_type.String{1});
                    handles.stim_axis_confirm.String = handles.canalInfo.stimCanal{3};
            end
            
            if ~strcmp(prevStimCanal,getappdata(handles.stim_axis,'ax')) && (str2num(handles.segment_number.String)>1)
                if handles.timesExported ==0
                    if ~isempty(handles.exp_spread_sheet_name.String) && ~strcmp([handles.subj_id.String{handles.subj_id.Value} '_ExperimentRecords.mat'],handles.exp_spread_sheet_name.String)
                        handles.exportCond = 2;
                        guidata(hObject,handles)
                        handles = export_data_Callback(hObject, eventdata, handles);
                    else
                        handles.ss_FileName = [handles.subj_id.String{handles.subj_id.Value} '_ExperimentRecords'];
                        set(handles.exp_spread_sheet_name,'String',[handles.ss_FileName '.mat']);
                        handles.exportCond = 3;
                        guidata(hObject,handles)
                        handles = export_data_Callback(hObject, eventdata, handles);
                    end
                else
                    handles.exportCond = 2;
                    guidata(hObject,handles)
                    handles = export_data_Callback(hObject, eventdata, handles);
                end
                
            end
            setappdata(handles.stim_type,'type',['stim',num2str(stim),'ref',num2str(refNum)]);
            handles.stim_type.String = {['stim',num2str(stim),'ref',num2str(refNum)]};
            setappdata(handles.stim_intensity,'intensity',['phase1Dur',num2str(p1d),'-phase2Dur',num2str(p2d),'-IPG',num2str(ipg),'-phase1Amp',num2str(p1amp),'-phase2Amp',num2str(p2amp)]);
            handles.stim_intensity.String = {['phase1Dur',num2str(p1d),'-phase2Dur',num2str(p2d),'-IPG',num2str(ipg),'-phase1Amp',num2str(p1amp),'-phase2Amp',num2str(p2amp)]};
            [handles] = update_seg_filename(hObject, eventdata, handles);
            
            
            t = Data.Time_Eye;
            Segment.segment_code_version = Data.segment_code_version;
            Segment.raw_filename = Data.raw_filename;
            Segment.start_t = t(1);
            Segment.end_t = t(end);
            
            
            Segment.LE_Position_X =  Data.LE_Position_X;
            Segment.LE_Position_Y =  Data.LE_Position_Y;
            Segment.LE_Position_Z =  Data.LE_Position_Z;
            
            Segment.RE_Position_X = Data.RE_Position_X;
            Segment.RE_Position_Y = Data.RE_Position_Y;
            Segment.RE_Position_Z = Data.RE_Position_Z;
            
            Segment.LE_Velocity_X = Data.LE_Velocity_X;
            Segment.LE_Velocity_Y = Data.LE_Velocity_Y;
            Segment.LE_Velocity_LARP = Data.LE_Velocity_LARP;
            Segment.LE_Velocity_RALP = Data.LE_Velocity_RALP;
            Segment.LE_Velocity_Z = Data.LE_Velocity_Z;
            
            Segment.RE_Velocity_X = Data.RE_Velocity_X;
            Segment.RE_Velocity_Y = Data.RE_Velocity_Y;
            Segment.RE_Velocity_LARP = Data.RE_Velocity_LARP;
            Segment.RE_Velocity_RALP = Data.RE_Velocity_RALP;
            Segment.RE_Velocity_Z = Data.RE_Velocity_Z;
            if any(isnan(Segment.LE_Position_X))
                Segment.LE_Position_X = zeros(length(Segment.RE_Position_X),1);
                Segment.LE_Position_Y = zeros(length(Segment.RE_Position_X),1);
                Segment.LE_Position_Z = zeros(length(Segment.RE_Position_X),1);
                Segment.LE_Velocity_X = zeros(length(Segment.RE_Position_X),1);
                Segment.LE_Velocity_Y = zeros(length(Segment.RE_Position_X),1);
                Segment.LE_Velocity_LARP = zeros(length(Segment.RE_Position_X),1);
                Segment.LE_Velocity_RALP = zeros(length(Segment.RE_Position_X),1);
                Segment.LE_Velocity_Z = zeros(length(Segment.RE_Position_X),1);
            elseif any(isnan(Segment.RE_Position_X))
                Segment.RE_Position_X = zeros(length(Segment.LE_Position_X),1);
                Segment.RE_Position_Y = zeros(length(Segment.LE_Position_X),1);
                Segment.RE_Position_Z = zeros(length(Segment.LE_Position_X),1);
                Segment.RE_Velocity_X = zeros(length(Segment.LE_Position_X),1);
                Segment.RE_Velocity_Y = zeros(length(Segment.LE_Position_X),1);
                Segment.RE_Velocity_LARP = zeros(length(Segment.LE_Position_X),1);
                Segment.RE_Velocity_RALP = zeros(length(Segment.LE_Position_X),1);
                Segment.RE_Velocity_Z = zeros(length(Segment.LE_Position_X),1);
            end
            Segment.Fs = Data.Fs;
            Segment.Time_Eye = t';
            
            Time_Stim = Data.Time_Stim;
            Stim = Data.Stim_Trig;
            if any(strfind(filename,'sinusoidal'))
                Stim = denoiseSync(TS_intervalS,TS_idxS);
            else
                Stim(Stim>100)=200;
                Stim(Stim<200)=0;
            end
            if length(Time_Stim) ~= length(Segment.Time_Eye)
                Time_Stim_Interp = Segment.Time_Eye;
                Stim_Interp = interp1(Time_Stim,Stim,Time_Stim_Interp);
            end
            if any(strfind(filename,'sinusoidal'))
            else
                Stim_Interp(Stim_Interp<200) = 0;
            end
            Segment.Time_Stim = Time_Stim_Interp;
            Segment.Stim_Trig = Stim_Interp;
            
            Segment.HeadMPUVel_X = zeros(1,length(Stim_Interp))';
            Segment.HeadMPUVel_Y = zeros(1,length(Stim_Interp))';
            Segment.HeadMPUVel_Z = Stim_Interp;
            
            Segment.HeadMPUAccel_X = zeros(1,length(Stim_Interp))';
            Segment.HeadMPUAccel_Y = zeros(1,length(Stim_Interp))';
            Segment.HeadMPUAccel_Z = zeros(1,length(Stim_Interp))';
            Segment.EyesRecorded = handles.eye_rec.String;
            Segment.p1d = p1d;
            Segment.p2d = p2d;
            Segment.p1amp = p1amp;
            Segment.p2amp = p2amp;
            Segment.ipg = ipg;
            Segment.dS = dS;
            Segment.dAsgn = dAsgn;
            
            handles.Segment = Segment;
            
            segments = str2num(handles.segment_number.String);
            if segments == 0
                mkdir([directory,'Segments',handles.ispc.slash])
                setappdata(handles.save_segment,'foldername',[directory,'Segments',handles.ispc.slash]);
            end
            
            [handles]=save_segment_Callback(hObject, eventdata, handles);
            if str2num(handles.segment_number.String)== handles.totalSegment
                if handles.timesExported ==0
                    if ~isempty(handles.exp_spread_sheet_name.String) && ~strcmp([handles.subj_id.String{handles.subj_id.Value} '_ExperimentRecords.mat'],handles.exp_spread_sheet_name.String)
                        handles.exportCond = 2;
                        guidata(hObject,handles)
                        handles = export_data_Callback(hObject, eventdata, handles);
                    else
                        handles.ss_FileName = [handles.subj_id.String{handles.subj_id.Value} '_ExperimentRecords'];
                        set(handles.exp_spread_sheet_name,'String',[handles.ss_FileName '.mat']);
                        handles.exportCond = 3;
                        guidata(hObject,handles)
                        handles = export_data_Callback(hObject, eventdata, handles);
                    end
                else
                    handles.exportCond = 2;
                    guidata(hObject,handles)
                    handles = export_data_Callback(hObject, eventdata, handles);
                end
            end
            guidata(hObject,handles)
            
            
        elseif contains(handles.listing(fs).name,{'LP', 'LA', 'LH', 'RP', 'RA', 'RH','stim'}) && (handles.listing(fs).bytes==0)
            handles.totalSegment = handles.totalSegment-1;
            handles.raw_name.String = ['Total of ',num2str(handles.totalSegment),' files to process'];
        end
        prevStimCanal = getappdata(handles.stim_axis,'ax');
        count = count +1;
    end
end
set(handles.save_indicator,'BackgroundColor','b')
pause(1);
set(handles.save_indicator,'BackgroundColor','g')


end



function upper_trigLev_Callback(hObject, eventdata, handles)
% hObject    handle to upper_trigLev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input = str2double(get(hObject,'String'));
handles.params.upper_trigLev = input;

guidata(hObject,handles)

% Hints: get(hObject,'String') returns contents of upper_trigLev as text
%        str2double(get(hObject,'String')) returns contents of upper_trigLev as a double

end
% --- Executes during object creation, after setting all properties.
function upper_trigLev_CreateFcn(hObject, eventdata, handles)
% hObject    handle to upper_trigLev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function lower_trigLev_Callback(hObject, eventdata, handles)
% hObject    handle to lower_trigLev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input = str2double(get(hObject,'String'));
handles.params.lower_trigLev = input;

guidata(hObject,handles)

end
% Hints: get(hObject,'String') returns contents of lower_trigLev as text
%        str2double(get(hObject,'String')) returns contents of lower_trigLev as a double


% --- Executes during object creation, after setting all properties.
function lower_trigLev_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lower_trigLev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in load_excel_sheet.
function load_spread_sheet_Callback(hObject, eventdata, handles)
% hObject    handle to load_excel_sheet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
answer = questdlg('Has a .mat or .xlsx Experiment Records file been created for this subject?', ...
    'Exporting Data', ...
    'Just .xlsx','.mat','Neither','Neither');
% Handle response
switch answer
    case 'Just .xlsx'
        handles.exportCond = 1;
        [FileName,PathName] = uigetfile('*.xlsx','Please choose the experimental batch spreadsheet where the data will be exported');
        ExperimentRecords = ExperimentRecordsExcel2MAT([PathName,FileName]);
        set(handles.exp_spread_sheet_name,'String',[FileName(1:end-4) 'mat']);
        handles.ss_PathName = PathName;
        handles.ss_FileName = [FileName(1:end-4) 'mat'];
        
    case '.mat'
        [FileName,PathName,FilterIndex] = uigetfile('*.mat','Please choose the experimental batch file where the data will be exported');
        handles.ss_PathName = PathName;
        handles.ss_FileName = FileName;
        set(handles.exp_spread_sheet_name,'String',FileName);
        handles.exportCond = 2;
    case 'Neither'
        handles.ss_FileName = [handles.subj_id.String{handles.subj_id.Value} '_ExperimentRecords']
        set(handles.exp_spread_sheet_name,'String',[handles.ss_FileName '.mat']);
        handles.exportCond = 3;
        
end
guidata(hObject,handles)
end

% --- Executes on button press in export_data.
% Exports temporarily saved data from text boxes to spreadsheet
% Compares filenames if worksheet is already present and replaces old data
% with new if match is found
function handles = export_data_Callback(hObject, eventdata, handles)
% hObject    handle to export_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.export_data.BackgroundColor = [1    1    0];
pause(0.1);
% if (handles.choice.stim==5)
%     handles.experimentdata = getappdata(hObject,'data');
%     has = find(~cellfun('isempty', handles.experimentdata(:,1)))
%     emptyC = find(ismember([1:length(handles.experimentdata(:,1))],has')~=1)
%     handles.experimentdata(emptyC,:) = [];
%     setappdata(hObject,'data',handles.experimentdata);
% end
expLRef = size(getappdata(handles.export_data,'data'));
switch handles.exportCond
    case 0
        
    case {1,2}
        cd(handles.ss_PathName);
        expRecords = load(handles.exp_spread_sheet_name.String);
        if length(handles.worksheet_name.String)> 31
            handles.worksheet_name.String = handles.worksheet_name.String(1:31);
        end
        handles.experimentdata = getappdata(handles.export_data,'data');
        handles.experimentdata(:,1)=strrep(handles.experimentdata(:,1),'.mat','');
        handles.experimentdata = handles.experimentdata(handles.whereToStartExp:end,:);
        temp = handles.worksheet_name.String;
        temp(temp=='-') = '_';
        temp(temp==' ') = '';
        if any(strcmp(fieldnames(expRecords),temp))
            segs = size(handles.experimentdata);
            for rs = 1:segs(1)
                %% 20190912 MEG CHANGING THIS MIGHT BREAK SOMETHING
                %if any(strcmp([handles.experimentdata(rs,1)],expRecords.(temp).File_Name))
                %    replaceInd = [find(strcmp(expRecords.(temp).File_Name,[handles.experimentdata(rs,1)]))];
                %    expRecords.(temp)(replaceInd,:)=[handles.experimentdata(rs,:)];
                %else
                    expRecords.(temp)(end+1,:) = [handles.experimentdata(rs,:)];
                %end
            end
        else
            expRecords.(temp) = [];
            segs = size(handles.experimentdata);
            labels = {'File_Name' 'Date' 'Subject' 'Implant' 'Eye_Recorded' 'Compression' 'Max_PR_pps' 'Baseline_pps' 'Function' 'Mod_Canal' 'Mapping_Type' 'Frequency_Hz' 'Max_Velocity_dps' 'Phase_degrees' 'Cycles' 'Phase_Direction' 'Notes'};
            expRecords.(temp) = cell2table([handles.experimentdata],'VariableNames',labels);
        end
        save(handles.exp_spread_sheet_name.String,'-struct','expRecords');
        dotPos = find(handles.ss_FileName=='.');
        if isempty(dotPos)
            toUse = handles.ss_FileName;
        else
            toUse = handles.ss_FileName(1:dotPos-1);
        end
        writetable(expRecords.(temp),[toUse, '.xlsx'],'Sheet',temp,'Range','A:Q','WriteVariableNames',true);
        handles.whereToStartExp = expLRef(1)+1;
        handles.timesExported = handles.timesExported+1;
        handles.export_data.BackgroundColor = [0    1    0];
        pause(1);
        handles.export_data.BackgroundColor = [0.9400    0.9400    0.9400];
        guidata(hObject,handles)
    case 3
        prompt = {'Enter the desired file name without extensions'};
        title = 'File Name';
        dims = [1 35];
        definput = {[handles.params.subj_id '_ExperimentRecords']};
        handles.ss_FileName = inputdlg(prompt,title,dims,definput);
        handles.ss_FileName = handles.ss_FileName{1};
        handles.ss_PathName = uigetdir(cd,'Choose directory where files will be saved');
        set(handles.exp_spread_sheet_name,'String',[handles.ss_FileName '.mat']);
        cd(handles.ss_PathName);
        labels = {'File_Name' 'Date' 'Subject' 'Implant' 'Eye_Recorded' 'Compression' 'Max_PR_pps' 'Baseline_pps' 'Function' 'Mod_Canal' 'Mapping_Type' 'Frequency_Hz' 'Max_Velocity_dps' 'Phase_degrees' 'Cycles' 'Phase_Direction' 'Notes'};
        if length(handles.worksheet_name.String)> 31
            handles.worksheet_name.String = handles.worksheet_name.String(1:31);
        end
        handles.experimentdata = getappdata(handles.export_data,'data');
        if contains(handles.experimentdata(1,1),'.mat')
        handles.experimentdata(:,1)=strrep(handles.experimentdata(:,1),'.mat','');
        end
        if isempty(handles.worksheet_name.String)
            prompt = {'Enter the desired sheet name'};
        title = 'Sheet Name';
        dims = [1 35];
        definput = {['']};
        handles.sheetName = inputdlg(prompt,title,dims,definput);
        handles.worksheet_name.String = handles.sheetName{1};
        temp = handles.sheetName{1};
        end
        temp = handles.worksheet_name.String;
        temp(temp=='-') = '_';
        temp(temp==' ') = '';
        var = genvarname(temp);
        t = cell2table([handles.experimentdata],'VariableNames',labels);
        eval([var '=t']);
        save(handles.exp_spread_sheet_name.String,var);
        writetable(t,[handles.ss_FileName '.xlsx'],'Sheet',temp,'Range','A:Q','WriteVariableNames',true);
        handles.export_data.BackgroundColor = [0    1    0];
        pause(1);
        handles.export_data.BackgroundColor = [0.9400    0.9400    0.9400];
        handles.exportCond = 2;
        handles.whereToStartExp = expLRef(1)+1;
        handles.timesExported = handles.timesExported+1;
        guidata(hObject,handles)
        
end
handles.prevExportSize = expLRef(1);
%     setappdata(handles.export_data,'data','')
%     handles.experimentdata = [];


end

function implant_Callback(hObject, eventdata, handles)
% hObject    handle to stim_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes during object creation, after setting all properties.
function implant_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subj_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function eye_rec_Callback(hObject, eventdata, handles)
% hObject    handle to stim_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.text53.BackgroundColor = [0.94 0.94 0.94];
end

% --- Executes during object creation, after setting all properties.
function eye_rec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subj_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function [handles] = auto_seg_general_Callback(hObject, eventdata, handles)

switch handles.choice.stim
    case 3 % Mechanical Sinusoids
        window = 500;
        b = (1/window)*ones(1,window);
        a = 1;
        x = filter(b,a,handles.Segment.HeadMPUVel_X);
        y = filter(b,a,handles.Segment.HeadMPUVel_Y);
        z = filter(b,a,handles.Segment.HeadMPUVel_Z);
        t = handles.Segment.Time_Stim(:,1);
        threshPTx = find(abs(gradient(x)<0.02));
        threshPTy = find(abs(gradient(y)<0.02));
        threshPTz = find(abs(gradient(z)<0.02));
        xVal =  mean(x(threshPTx));
        yVal =  mean(y(threshPTy));
        zVal =  mean(z(threshPTz));
        handles.Segment.HeadMPUVel_X = handles.Segment.HeadMPUVel_X - xVal;
        handles.Segment.HeadMPUVel_Y = handles.Segment.HeadMPUVel_Y - yVal;
        handles.Segment.HeadMPUVel_Z = handles.Segment.HeadMPUVel_Z - zVal;
        handles.stim_mag = sqrt((handles.Segment.HeadMPUVel_X.^2) + (handles.Segment.HeadMPUVel_Y.^2) + (handles.Segment.HeadMPUVel_Z.^2)); % Calculating the magnitude of the X Y and Z velocities
        trace = handles.stim_mag;
        
        
    case 4 % Electrical Only
        handles.stim_mag = handles.Segment.Stim_Trig;
        trace = handles.Segment.Stim_Trig;
    case 6 % Pupil Labs
        window = 500;
        b = (1/window)*ones(1,window);
        a = 1;
        x = filter(b,a,handles.Segment.HeadMPUVel_X);
        y = filter(b,a,handles.Segment.HeadMPUVel_Y);
        z = filter(b,a,handles.Segment.HeadMPUVel_Z);
        t = handles.Segment.Time_Stim(:,1);
        threshPTx = find(abs(gradient(x)<0.02));
        threshPTy = find(abs(gradient(y)<0.02));
        threshPTz = find(abs(gradient(z)<0.02));
        xVal =  mean(x(threshPTx));
        yVal =  mean(y(threshPTy));
        zVal =  mean(z(threshPTz));
        handles.Segment.HeadMPUVel_X = handles.Segment.HeadMPUVel_X - xVal;
        handles.Segment.HeadMPUVel_Y = handles.Segment.HeadMPUVel_Y - yVal;
        handles.Segment.HeadMPUVel_Z = handles.Segment.HeadMPUVel_Z - zVal;
        handles.stim_mag = sqrt((handles.Segment.HeadMPUVel_X.^2) + (handles.Segment.HeadMPUVel_Y.^2) + (handles.Segment.HeadMPUVel_Z.^2)); % Calculating the magnitude of the X Y and Z velocities
        trace = handles.stim_mag;
end

mask = zeros(length(trace),1);
handles.thresh_plot = figure('Name','Choose Threshold', 'NumberTitle','off');
handles.thresh_plot.OuterPosition = [512   600   700   520];
ax1 = axes;
ax1.Position = [0.06 0.2 0.9 0.75];

switch handles.choice.stim
    case {3,6} % Mechanical Sinusoids & Pupil Labs
        handles.xVel = plot(ax1,handles.Segment.Time_Stim(:,1),handles.Segment.HeadMPUVel_X,'color',[1 0.65 0],'LineStyle',':','DisplayName','MPU-GYRO-X');
        hold on
        handles.yVel = plot(ax1,handles.Segment.Time_Stim(:,1),handles.Segment.HeadMPUVel_Y,'color',[0.55 0.27 0.07],'LineStyle',':','DisplayName','MPU-GYRO-Y');
        handles.zVel = plot(ax1,handles.Segment.Time_Stim(:,1),handles.Segment.HeadMPUVel_Z,'color','r','LineStyle',':','DisplayName','MPU-GYRO-Z');
        plot(ax1,handles.Segment.Time_Stim(:,1),trace,'color','k','DisplayName','MPU-Vel Magnitude');
        handles.h = plot(ax1,handles.Segment.Time_Stim(:,1),zeros(1,length(trace)),'g','DisplayName','Threshold Value');
    case 4 % Electrical Only
        plot(ax1,handles.Segment.Time_Stim(:,1),trace,'color','k','DisplayName','MPU-Vel Magnitude');
        hold on
        handles.h = plot(ax1,handles.Segment.Time_Stim(:,1),zeros(1,length(trace)),'g','DisplayName','Threshold Value');
end

hold off
legend('show')
handles.thresh_value = uicontrol(handles.thresh_plot,'Style','edit','Position',[210 13 70 30],'fontsize',12,'CallBack',{@thresh_value_Callback, handles});
thresh_prompt = uicontrol(handles.thresh_plot,'Style','text','String','Enter a Threshold Value:','Position',[15 18 190 20],'FontSize',12);
thresh_instruct = uicontrol(handles.thresh_plot,'Style','text','String','(Click enter after entering a value to adjust the threshold line and click "ok" when complete)','Position',[290 13 250 30],'FontSize',8);
handles.thresh_close = uicontrol(handles.thresh_plot,'Style','pushbutton','String','OK','fontsize',12,'Position',[600 13 70 30],'CallBack',{@thresh_save_Callback, handles},'KeyPressFcn',{@thresh_save_KeyPressFcn, handles});
uiwait(gcf)
saved_thresh = getappdata(handles.thresh_value,'save');
close(handles.thresh_plot);


mask(trace > saved_thresh) = ones(length(mask(trace > saved_thresh)),1); % All of the indicies where the magnitudes is greater than 20 will be changed from zero to 1
inds = [1:length(mask)];
onset_inds = inds([false ; diff(mask)>0]); % take the backward difference but keep the values greater than zero, disregard the first index, find the index value which corresponds to those positive differences

end_inds = inds([false ; diff(mask)<0]); % take the backward difference but keep the values less than zero, disregard the first index, find the index value which corresponds to those negative differences

switch handles.choice.stim
    case 3 % Mechanical Sinusoids
        window =150;
        b = (1/window)*ones(1,window);
        a = 1;
        testMag = filter(b,a,handles.stim_mag);
        trace = testMag;
        saved_thresh = 15;
        mask = zeros(length(trace),1);
        mask(trace > saved_thresh) = ones(length(mask(trace > saved_thresh)),1);
        
        inds = [1:length(mask)];
        onset_inds = inds([false ; diff(mask)>0]);
        end_inds = inds([false ; diff(mask)<0]);
        if length(onset_inds)~=length(end_inds)
            go = 1;
            steps = 1;
            while go
                if length(onset_inds)==length(end_inds)
                    go = 0;
                else
                    if steps>length(onset_inds)
                        end_inds(steps:end) =[];
                        go = 0;
                    elseif steps>length(end_inds)
                        onset_inds(steps:end) =[];
                        go = 0;
                    else
                        if (end_inds(steps)-onset_inds(steps))<0
                            end_inds(steps) = [];
                            steps = steps-1;
                        elseif ((end_inds(steps)-onset_inds(steps))>0) && (onset_inds(steps+1)<end_inds(steps))
                            onset_inds(steps) = [];
                            steps = steps-1;
                        end
                        
                    end
                end
                steps = steps +1;
            end
        end
        onset_indsTest = onset_inds((end_inds-onset_inds)>220)
        end_indsTest = end_inds((end_inds-onset_inds)>220)
        
        oFinal = onset_indsTest((end_indsTest-onset_indsTest)>800);
        eFinal = end_indsTest((end_indsTest-onset_indsTest)>800);
        
        mask2 = zeros(length(trace),1);
        mask2(handles.stim_mag>120) = ones(length(mask(handles.stim_mag>120)),1);
        
        inds2 = [1:length(mask2)];
        onset_inds2 = inds2([false ; diff(mask2)>0]);
        end_inds2 = inds2([false ; diff(mask2)<0]);
        
        for compInd = 1:length(oFinal)
            indsRmv = find(((oFinal(compInd)-100)<onset_inds2)&(onset_inds2<(eFinal(compInd)+100)));
            onset_inds2(indsRmv) = [];
            indsRmv = find(((oFinal(compInd)-100)<end_inds2)&(end_inds2<(eFinal(compInd)+100)));
            end_inds2(indsRmv) = [];
        end
        
        oFinal2 = [onset_inds2(1) onset_inds2(find(diff(onset_inds2)>2000)+1)];
        eFinal2 = [end_inds2(diff(end_inds2)>2000) end_inds2(end)];
        onset_inds_final = sort([oFinal oFinal2],'ascend');
        end_inds_final = sort([eFinal eFinal2],'ascend');
    case 4 % Electrical Only
        [a,b] = findpeaks(diff(onset_inds),'Threshold',15);
        onset_inds_final = onset_inds([1 b+1]);
        
        [c,d] = findpeaks(diff(end_inds),'Threshold',15);
        end_inds_final = end_inds([d length(end_inds)]);
    case 6 % Pupil Labs
        onset_inds_final = onset_inds([true diff(onset_inds)>2000]); % Take the backwards difference of the index values, keep the first index (true),disregard any differences less than 200
        % Keeping the first index allows for the initial onset to be selected
        end_inds_final = end_inds([diff(end_inds)>2000 true]); % Take the backwards difference of the index values, keep the last index (true), disregard any differences less than 200
        % Keeping the last index allows for the last end to be selected
        go = 1;
        checkEnd = 1;
        checkOn = 1;
        %             Check detection of segments figure
        %             figure
        %             plot(handles.Segment.Time_Stim(:,1),trace);
        %             hold on
        %             plot(handles.Segment.Time_Stim(:,1),mask*75)
        %             s = plot(handles.Segment.Time_Stim(onset_inds_final,1),linspace(50,50,length(onset_inds_final)),'g*')
        %             e = plot(handles.Segment.Time_Stim(end_inds_final,1),linspace(50,50,length(end_inds_final)),'r*')
        %             axis([handles.Segment.Time_Stim(onset_inds_final(1),1) handles.Segment.Time_Stim(end_inds_final(end),1) 0 80])
        while go
            if (max([checkEnd checkOn])< min([length(onset_inds_final) length(end_inds_final)]))
                if end_inds_final(checkEnd)>onset_inds_final(checkOn+1)
                    onset_inds_final(checkOn+1) = [];
                    s.XData = handles.Segment.Time_Stim(onset_inds_final,1);
                    s.YData = linspace(50,50,length(onset_inds_final));
                    
                elseif end_inds_final(checkEnd+1)<onset_inds_final(checkOn+1)
                    end_inds_final(checkEnd) = [];
                    e.XData = handles.Segment.Time_Stim(end_inds_final,1);
                    e.YData = linspace(50,50,length(end_inds_final));
                elseif (end_inds_final(checkEnd)-onset_inds_final(checkOn))<3700
                    onset_inds_final(checkOn) = [];
                    end_inds_final(checkEnd) = [];
                    e.XData = handles.Segment.Time_Stim(end_inds_final,1);
                    e.YData = linspace(50,50,length(end_inds_final));
                    s.XData = handles.Segment.Time_Stim(onset_inds_final,1);
                    s.YData = linspace(50,50,length(onset_inds_final));
                elseif ((end_inds_final(checkEnd)-onset_inds_final(checkOn))<6000) && (mean(trace(onset_inds_final(checkOn):end_inds_final(checkEnd)))<50)
                    onset_inds_final(checkOn) = [];
                    end_inds_final(checkEnd) = [];
                    e.XData = handles.Segment.Time_Stim(end_inds_final,1);
                    e.YData = linspace(50,50,length(end_inds_final));
                    s.XData = handles.Segment.Time_Stim(onset_inds_final,1);
                    s.YData = linspace(50,50,length(onset_inds_final));
                else
                    checkEnd = checkEnd+1;
                    checkOn = checkOn+1;
                end
                
            end
            if (max([checkEnd checkOn])== min([length(onset_inds_final) length(end_inds_final)]))
                go = 0;
            end
            
        end
end

lengthCheck = [];
end_del = [];
onset_del = [];
go = 1;
% check = 2;
% while go
%     if (check>1) && (check< min([length(onset_inds_final) length(end_inds_final)]))
%         if end_inds_final(check)
%         end
%     end
% end
if length(onset_inds_final) ~= length(end_inds_final)
    uneven = max([length(onset_inds_final) length(end_inds_final)]);
    if uneven == length(onset_inds_final)
        check = 1;
        while go
            
            if check == length(onset_inds_final)
                go = 0;
            end
            
            if check > length(end_inds_final)
                onset_inds_final(check) = [];
                check = check - 1;
            elseif check > 1
                if (onset_inds_final(check) - end_inds_final(check-1)) < 0
                    onset_inds_final(check) = [];
                    check = check - 1;
                end
            elseif onset_inds_final(check) > end_inds_final(check)
                onset_inds_final(check) = [];
                check = check - 1;
                
            end
            check = check +1;
        end
        
    end
    
    if uneven == length(end_inds_final)
        check = 1;
        while go
            if check == length(end_inds_final)
                go = 0;
            end
            
            if check > length(onset_inds_final)
                end_inds_final(check) = [];
                check = check - 1;
            elseif check > 1
                if (onset_inds_final(check) - end_inds_final(check-1)) < 0
                    end_inds_final(check) = [];
                    check = check - 1;
                end
            elseif onset_inds_final(check) > end_inds_final(check)
                end_inds_final(check) = [];
                check = check - 1;
                
            end
            
            check = check +1;
        end
        
    end
end
check = 1;
go = 1;
if handles.choice.stim == 6
    bound = 3700;
else
    bound = 300;
end

while go
    if check == length(end_inds_final)
        go = 0;
    end
    if (end_inds_final(check) - onset_inds_final(check)) < bound
        end_inds_final(check) = [];
        onset_inds_final(check) = [];
        check = check - 1;
    end
    check = check +1;
end


handles.end_inds_final = end_inds_final;
handles.onset_inds_final = onset_inds_final;
for plots = 1:length(end_inds_final)
    handles.plot_num = plots;
    handles.seg_plots = figure('Name',['Segment: ',num2str(plots)], 'NumberTitle','off');
    handles.seg_plots.OuterPosition = [220   300   1100   720];
    handles.ax1 = axes;
    handles.ax1.Position = [0.09 0.1 0.72 0.85];
    
    switch handles.choice.stim
        case {3,6} % Mechanical Sinusoids & Pupil Labs
            handles.HeadMPUVel_Z_plot = plot(handles.ax1,handles.Segment.Time_Stim,handles.Segment.HeadMPUVel_Z,'color','r','LineStyle',':');
            hold on
            handles.HeadMPUVel_Y_plot = plot(handles.ax1,handles.Segment.Time_Stim,handles.Segment.HeadMPUVel_Y,'color',[0.55 0.27 0.07],'LineStyle',':');
            handles.HeadMPUVel_X_plot = plot(handles.ax1,handles.Segment.Time_Stim,handles.Segment.HeadMPUVel_X,'color',[1 0.65 0],'LineStyle',':');
        case 4 % Electrical Only
            handles.stim_mag = plot(handles.ax1,handles.Segment.Time_Stim,handles.Segment.Stim_Trig,'color','k','LineWidth',2);
    end
    
    handles.left_extra = 3*handles.Data.Fs;
    handles.right_extra = 3*handles.Data.Fs;
    
    x1 = [-100 -100 600 600];
    y1 = [-400 300 300 -400];
    if (handles.onset_inds_final(plots) - handles.left_extra) < 1
        a = handles.Segment.Time_Stim(1);
    else
        a = handles.Segment.Time_Stim((handles.onset_inds_final(plots) - handles.left_extra));
    end
    if (handles.end_inds_final(plots) +  handles.right_extra)>length(handles.Segment.Time_Stim)
        b = handles.Segment.Time_Stim(end);
    else
        b = handles.Segment.Time_Stim((handles.end_inds_final(plots) +  handles.right_extra));
    end
    v1 = [handles.ax1.XLim(1) handles.ax1.YLim(1); a handles.ax1.YLim(1); a handles.ax1.YLim(2); handles.ax1.XLim(1) handles.ax1.YLim(2)];
    f1 = [1 2 3 4];
    v2 = [b handles.ax1.YLim(1); handles.ax1.XLim(2) handles.ax1.YLim(1); handles.ax1.XLim(2) handles.ax1.YLim(2); b handles.ax1.YLim(2)];
    f2 = [1 2 3 4];
    handles.seg_patch1 = patch('Faces',f1,'Vertices',v1,'FaceColor','k','FaceAlpha',.3,'EdgeColor','none');
    handles.seg_patch2 = patch('Faces',f2,'Vertices',v2,'FaceColor','k','FaceAlpha',.3,'EdgeColor','none');
    if str2num(handles.segment_number.String) > 0
        for done = 1:str2num(handles.segment_number.String)
            patch('Faces',[1 2 3 4], 'Vertices',[handles.Segment.Time_Stim(handles.savedStart(done)) handles.ax1.YLim(1); handles.Segment.Time_Stim(handles.savedEnd(done)) handles.ax1.YLim(1);handles.Segment.Time_Stim(handles.savedEnd(done)) handles.ax1.YLim(2); handles.Segment.Time_Stim(handles.savedStart(done)) handles.ax1.YLim(2)],...
                'FaceColor','g','FaceAlpha',.3,'EdgeColor','none');
        end
    end
    hold off
    
    handles.ok_seg = uicontrol(handles.seg_plots,'Style','pushbutton','String','OK','fontsize',12,'Position',[975 10 70 30],'CallBack',{@ok_seg_Callback, handles},'KeyPressFcn',{@ok_seg_KeyPressFcn, handles});
    
    handles.reject_seg = uicontrol(handles.seg_plots,'Style','pushbutton','String','Reject This Segment','fontsize',12,'Position',[15 10 160 30],'CallBack',{@reject_seg_Callback, handles});
    
    handles.right_extra_val = uicontrol(handles.seg_plots,'Style','edit','enable','off','String', handles.right_extra/handles.Data.Fs,'fontsize',12,'Position',[900 295 60 30]);
    handles.left_extra_val = uicontrol(handles.seg_plots,'Style','edit','enable','off','String', handles.left_extra/handles.Data.Fs,'fontsize',12,'Position',[15 295 60 30]);
    
    setappdata(handles.ok_seg,'r',handles.end_inds_final(plots) +  handles.right_extra);
    setappdata(handles.ok_seg,'l',handles.onset_inds_final(plots) - handles.left_extra);
    
    handles.instructions = uicontrol(handles.seg_plots,'Style','text','String','Use the arrows to increase or decrease the buffer zone on the corresponding side. If a segment has a pause, adjust the window to encompass the entire segment, save within the first detected component, reject all following components.','fontsize',12,'Position',[895 365 175 240]);
    handles.inc_right = uicontrol(handles.seg_plots,'Style','pushbutton','String','<html>&#x25BA;</html>','fontsize',20,'Position',[930 325 30 30],'CallBack',{@inc_right_Callback, handles});
    handles.dec_right = uicontrol(handles.seg_plots,'Style','pushbutton','String','<html>&#x25C4;</html>','fontsize',20,'Position',[900 325 30 30],'CallBack',{@dec_right_Callback, handles});
    
    
    handles.dec_left = uicontrol(handles.seg_plots,'Style','pushbutton','String','<html>&#x25BA;</html>','fontsize',20,'Position',[45 325 30 30],'CallBack',{@dec_left_Callback, handles});
    handles.inc_left = uicontrol(handles.seg_plots,'Style','pushbutton','String','<html>&#x25C4;</html>','fontsize',20,'Position',[15 325 30 30],'CallBack',{@inc_left_Callback, handles});
    handles.stim_axis_confirm = uicontrol(handles.seg_plots,'Style','popupmenu','String',handles.stim_axis.String,'Value',handles.stim_axis.Value,'fontsize',8,'Position',[990 200 100 30],'CallBack',{@stim_axis_confirm_Callback ,handles});
    handles.stim_axis_confirm_s = uicontrol(handles.seg_plots,'Style','text','String', 'Stim Axis','fontsize',10,'Position',[910 195 60 30]);
    handles.stim_freq_confirm = uicontrol(handles.seg_plots,'Style','popupmenu','String',handles.stim_frequency.String,'Value',handles.stim_frequency.Value,'fontsize',8,'Position',[990 130 100 30],'CallBack',{@stim_freq_confirm_Callback ,handles});
    handles.stim_freq_confirm_s = uicontrol(handles.seg_plots,'Style','text','String', 'Stim Freq','fontsize',10,'Position',[910 125 70 30]);
    handles.stim_type_confirm = uicontrol(handles.seg_plots,'Style','popupmenu','String',handles.stim_type.String,'Value',handles.stim_type.Value,'fontsize',8,'Position',[990 165 100 30],'CallBack',{@stim_type_confirm_Callback ,handles});
    handles.stim_type_confirm_s = uicontrol(handles.seg_plots,'Style','text','String', 'Stim Type','fontsize',10,'Position',[910 160 70 30]);
    handles.stim_inten_confirm = uicontrol(handles.seg_plots,'Style','popupmenu','String',handles.stim_intensity.String,'Value',handles.stim_intensity.Value,'fontsize',8,'Position',[990 95 100 30],'CallBack',{@stim_intensity_confirm_Callback ,handles});
    handles.stim_inten_confirm_s = uicontrol(handles.seg_plots,'Style','text','String', 'Stim Intensity','fontsize',10,'Position',[910 90 70 35]);
    handles.suffix_confirm = uicontrol(handles.seg_plots,'Style','edit','fontsize',8,'Position',[990 60 100 30],'CallBack',{@suffix_confirm_Callback ,handles});
    handles.suffix_confirm_s = uicontrol(handles.seg_plots,'Style','text','String', 'Add Suffix','fontsize',10,'Position',[910 55 70 35]);
    
    guidata(hObject,handles)
    uiwait(gcf)
    if getappdata(handles.ok_seg,'skip') == 0
        handles.savedStart(str2num(handles.segment_number.String)) = getappdata(handles.ok_seg,'l');
        handles.savedEnd(str2num(handles.segment_number.String)) = getappdata(handles.ok_seg,'r');
    end
    close(handles.seg_plots);
    
    handles.right_extra = 3*handles.Data.Fs;
    handles.left_extra = 3*handles.Data.Fs;
    
    handles.stim_frequency.Value = 1;
    handles.params.stim_frequency = '';
    handles.stim_intensity.Value = 1;
    handles.params.stim_intensity = '';
    handles.params.suffix = '';
    setappdata(handles.stim_intensity,'suf','');
    setappdata(handles.stim_frequency,'fq','');
    setappdata(handles.stim_intensity,'intensity','');
    [handles] = update_seg_filename(hObject, eventdata, handles);
    set(handles.save_indicator,'String','UNSAVED');
    set(handles.save_indicator,'BackgroundColor','r');
    guidata(hObject,handles)
end
end

function inc_right_Callback(hObject, eventdata, handles)
if handles.choice.stim==5 || handles.choice.stim == 7 % Moog Stim
    handles.r = str2num(handles.right_extra_val.String)
    handles.r = handles.r + 1;
    handles.right_extra_val.String = handles.r;
    handles.seg_patch2.XData([1 4]) = [handles.Time_Eye(handles.locs(handles.bound(2)+handles.r));handles.Time_Eye(handles.locs(handles.bound(2)+handles.r))];
    setappdata(handles.ok_seg,'r',handles.r);
    guidata(hObject,handles)
else
    handles.r = str2num(handles.right_extra_val.String)*handles.Data.Fs;
    handles.r = handles.r + 2*handles.Data.Fs;
    handles.right_extra_val.String = handles.r/handles.Data.Fs;
    handles.seg_patch2.XData([1 4]) = handles.seg_patch2.XData([1 4]) + [2;2];
    setappdata(handles.ok_seg,'r',handles.end_inds_final(handles.plot_num) + handles.r);
    guidata(hObject,handles)
end
end

function dec_right_Callback(hObject, eventdata, handles)
if handles.choice.stim==5 || handles.choice.stim == 7
    handles.r = str2num(handles.right_extra_val.String)
    handles.r = handles.r - 1;
    handles.right_extra_val.String = handles.r;
    handles.seg_patch2.XData([1 4]) = [handles.Time_Eye(handles.locs(handles.bound(2)+handles.r));handles.Time_Eye(handles.locs(handles.bound(2)+handles.r))];
    setappdata(handles.ok_seg,'r',handles.r);
    guidata(hObject,handles)
else
    handles.r = str2num(handles.right_extra_val.String)*handles.Data.Fs;
    handles.r = handles.r - 2*handles.Data.Fs;
    handles.right_extra_val.String = handles.r/handles.Data.Fs;
    handles.seg_patch2.XData([1 4]) = handles.seg_patch2.XData([1 4]) - [2;2];
    setappdata(handles.ok_seg,'r',handles.end_inds_final(handles.plot_num) + handles.r);
    guidata(hObject,handles)
end
end


function inc_left_Callback(hObject, eventdata, handles)
if handles.choice.stim==5 || handles.choice.stim == 7
    handles.l = str2num(handles.left_extra_val.String)
    handles.l = handles.l + 1;
    if (handles.bound(1)-handles.l)<1
        handles.l = handles.l - 1;
    end
    handles.left_extra_val.String = handles.l;
    handles.seg_patch1.XData([2 3]) = [handles.Time_Eye(handles.locs(handles.bound(1)-handles.l));handles.Time_Eye(handles.locs(handles.bound(1)-handles.l))];
    setappdata(handles.ok_seg,'l',handles.l);
    guidata(hObject,handles)
else
    handles.l = str2num(handles.left_extra_val.String)*handles.Data.Fs;
    handles.l = handles.l + 2*handles.Data.Fs;
    handles.left_extra_val.String = handles.l/handles.Data.Fs;
    handles.seg_patch1.XData([2 3]) = handles.seg_patch1.XData([2 3]) - [2;2];
    setappdata(handles.ok_seg,'l',handles.onset_inds_final(handles.plot_num) - handles.l);
    guidata(hObject,handles)
end
end

function dec_left_Callback(hObject, eventdata, handles)
if handles.choice.stim==5 || handles.choice.stim == 7
    handles.l = str2num(handles.left_extra_val.String)
    handles.l = handles.l - 1;
    handles.left_extra_val.String = handles.l;
    handles.seg_patch1.XData([2 3]) =[handles.Time_Eye(handles.locs(handles.bound(1)-handles.l));handles.Time_Eye(handles.locs(handles.bound(1)-handles.l))];
    setappdata(handles.ok_seg,'l',handles.l);
    guidata(hObject,handles)
else
    handles.l = str2num(handles.left_extra_val.String)*handles.Data.Fs;
    handles.l = handles.l - 2*handles.Data.Fs;
    handles.left_extra_val.String = handles.l/handles.Data.Fs;
    handles.seg_patch1.XData([2 3]) = handles.seg_patch1.XData([2 3]) + [2;2];
    setappdata(handles.ok_seg,'l',handles.onset_inds_final(handles.plot_num) - handles.l);
    guidata(hObject,handles)
end
end

function [handles] = suffix_confirm_Callback(hObject, eventdata, handles)
if isempty(hObject.String)
    setappdata(handles.stim_intensity,'suf','');
    guidata(hObject,handles)
    [handles] = update_seg_filename(hObject, eventdata, handles);
else
    setappdata(handles.stim_intensity,'suf',['-',hObject.String]);
    guidata(hObject,handles)
    [handles] = update_seg_filename(hObject, eventdata, handles);
end
end

function [handles] = stim_axis_confirm_Callback(hObject, eventdata, handles)
% hObject    handle to stim_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.stim_axis.Value = get(hObject,'Value');
setappdata(handles.stim_axis,'ax',hObject.String{hObject.Value});
guidata(hObject,handles)
[handles] = update_seg_filename(hObject, eventdata, handles);
% Hints: get(hObject,'String') returns contents of stim_intensity as text
%        str2double(get(hObject,'String')) returns contents of stim_intensity as a double
end

function [handles] = undo_seg_Callback(hObject, eventdata, handles)
setappdata(handles.ok_seg,'skip',2)
uiresume(gcbf)
end

function [handles] = ref_confirm_Callback(hObject, eventdata, handles)
v = get(hObject,'Value');
if any(strcmp(handles.stim_type.String,''))
    handles.stim_type.String = {['ref',hObject.String{v}]};
else
    if contains(handles.stim_type.String,'stim')
        if contains(handles.stim_type.String,'ref')
            place = find(handles.stim_type.String{1}=='r');
            handles.stim_type.String{1} = [handles.stim_type.String{1}(1:place-1),'ref',hObject.String{v}];
        else
            handles.stim_type.String{1} = [handles.stim_type.String{1},'ref',hObject.String{v}];
        end
    else
        handles.stim_type.String{1} = ['ref',hObject.String{v}];
    end
end
setappdata(handles.stim_type,'type',handles.stim_type.String{1});
handles.stim_type.Value = 1;
guidata(hObject,handles)
[handles] = update_seg_filename(hObject, eventdata, handles);
end

function [handles] = stim_confirm_Callback(hObject, eventdata, handles)
v = get(hObject,'Value');
if any(strcmp(handles.stim_type.String,''))
    handles.stim_type.String = {['stim',hObject.String{v}]};
else
    if contains(handles.stim_type.String,'ref')
        if contains(handles.stim_type.String,'stim')
            place = find(handles.stim_type.String{1}=='r');
            handles.stim_type.String{1} = ['stim',hObject.String{v},handles.stim_type.String{1}(place:end)];
        else
            handles.stim_type.String{1} = ['stim',hObject.String{v},handles.stim_type.String{1}];
        end
    else
        handles.stim_type.String{1} = ['stim',hObject.String{v}]
    end
end

switch hObject.String{v}
    case handles.canalInfo.stimNum{1}
        setappdata(handles.stim_axis,'ax',handles.canalInfo.stimCanal{1});
        handles.stim_axis.String = handles.canalInfo.stimCanal(1);
        setappdata(handles.stim_type,'type',handles.stim_type.String{1});
        handles.stim_axis_confirm.String = handles.canalInfo.stimCanal{1};
    case handles.canalInfo.stimNum{2}
        setappdata(handles.stim_axis,'ax',handles.canalInfo.stimCanal{2});
        handles.stim_axis.String = handles.canalInfo.stimCanal(2);
        setappdata(handles.stim_type,'type',handles.stim_type.String{1});
        handles.stim_axis_confirm.String = handles.canalInfo.stimCanal{2};
    case handles.canalInfo.stimNum{3}
        setappdata(handles.stim_axis,'ax',handles.canalInfo.stimCanal{3});
        handles.stim_axis.String = handles.canalInfo.stimCanal(3);
        setappdata(handles.stim_type,'type',handles.stim_type.String{1});
        handles.stim_axis_confirm.String = handles.canalInfo.stimCanal{3};
end
handles.stim_type.Value = 1;
guidata(hObject,handles)
[handles] = update_seg_filename(hObject, eventdata, handles);
end

function [handles] = stim_type_confirm_Callback(hObject, eventdata, handles)
% hObject    handle to stim_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.stim_type.Value = get(hObject,'Value');
setappdata(handles.stim_type,'type',hObject.String{hObject.Value});
if (get(hObject,'Value') == 2) || (get(hObject,'Value') == 4)
    handles.stim_freq_confirm.Value = 2;
end
handles.stim_frequency.Value = handles.stim_freq_confirm.Value;
setappdata(handles.stim_frequency,'fq',handles.stim_freq_confirm.String{handles.stim_freq_confirm.Value});
guidata(hObject,handles)
[handles] = update_seg_filename(hObject, eventdata, handles);
% Hints: get(hObject,'String') returns contents of stim_intensity as text
%        str2double(get(hObject,'String')) returns contents of stim_intensity as a double
end

function [handles] = stim_freq_confirm_Callback(hObject, eventdata, handles)
% hObject    handle to stim_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.stim_frequency.Value = get(hObject,'Value');
setappdata(handles.stim_frequency,'fq',hObject.String{hObject.Value});
guidata(hObject,handles)
[handles] = update_seg_filename(hObject, eventdata, handles);
% Hints: get(hObject,'String') returns contents of stim_intensity as text
%        str2double(get(hObject,'String')) returns contents of stim_intensity as a double
end

function [handles] = stim_intensity_confirm_Callback(hObject, eventdata, handles)
% hObject    handle to stim_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.stim_intensity.Value = get(hObject,'Value');
setappdata(handles.stim_intensity,'intensity',hObject.String{hObject.Value});
guidata(hObject,handles)
[handles] = update_seg_filename(hObject, eventdata, handles);
% Hints: get(hObject,'String') returns contents of stim_intensity as text
%        str2double(get(hObject,'String')) returns contents of stim_intensity as a double
end

function reject_seg_Callback(hObject, eventdata, handles)
setappdata(handles.ok_seg,'skip',1);
uiresume(gcbf)
end

function ok_seg_KeyPressFcn(hObject, eventdata, handles)
key = get(gcf,'CurrentKey');
if(strcmp(key, 'return'))
    ok_seg_Callback(hObject, eventdata, handles);
end
end

function ok_seg_Callback(hObject, eventdata, handles)
% hObject    handle to stim_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles] = update_seg_filename(hObject, eventdata, handles);
if handles.choice.stim==5
    setappdata(hObject,'skip',0);
    i_start = handles.locs(handles.bound(1)-getappdata(hObject,'l'))-750;
    i_end = handles.locs(handles.bound(2)+getappdata(hObject,'r'))+750;
    handles.i_start_eye = i_start;
    handles.i_end_eye = i_end;
    handles.i_start_stim = i_start;
    handles.i_end_stim = i_end;
    
    Segment.segment_code_version = mfilename;
    Segment.raw_filename = handles.rawFileName;
    Segment.start_t = handles.Time_Eye(i_start);
    Segment.end_t = handles.Time_Eye(i_end);
    Segment.LE_Position_X = handles.angularPosL(i_start:i_end,3);
    Segment.LE_Position_Y = handles.angularPosL(i_start:i_end,2);
    Segment.LE_Position_Z = handles.angularPosL(i_start:i_end,1);
    
    Segment.RE_Position_X = handles.angularPosL(i_start:i_end,3);
    Segment.RE_Position_Y = handles.angularPosL(i_start:i_end,2);
    Segment.RE_Position_Z = handles.angularPosL(i_start:i_end,1);
    
    Segment.LE_Velocity_X = handles.AngVelLxyz(i_start:i_end,1);
    Segment.LE_Velocity_Y = handles.AngVelLxyz(i_start:i_end,2);
    Segment.LE_Velocity_LARP = handles.AngVelL(i_start:i_end,1);
    Segment.LE_Velocity_RALP = handles.AngVelL(i_start:i_end,2);
    Segment.LE_Velocity_Z = handles.AngVelL(i_start:i_end,3);
    
    Segment.RE_Velocity_X = handles.AngVelRxyz(i_start:i_end,1);
    Segment.RE_Velocity_Y = handles.AngVelRxyz(i_start:i_end,2);
    Segment.RE_Velocity_LARP = handles.AngVelR(i_start:i_end,1);
    Segment.RE_Velocity_RALP = handles.AngVelR(i_start:i_end,2);
    Segment.RE_Velocity_Z = handles.AngVelR(i_start:i_end,3);
    Segment.Time_Eye = handles.Time_Eye(i_start:i_end);
    Segment.Time_Stim = handles.Time_Stim_Interp(i_start:i_end);
    
    Segment.HeadMPUVel_X = zeros(1,length(Segment.Time_Stim))';
    Segment.HeadMPUVel_Y = zeros(1,length(Segment.Time_Stim))';
    Segment.HeadMPUVel_Z = handles.Stim_Interp(i_start:i_end);
    
    Segment.HeadMPUAccel_X = zeros(1,length(Segment.Time_Stim))';
    Segment.HeadMPUAccel_Y = zeros(1,length(Segment.Time_Stim))';
    Segment.HeadMPUAccel_Z = zeros(1,length(Segment.Time_Stim))';
    
    Segment.Fs = 1000;
    
else
    
    if getappdata(hObject,'r') > length(handles.Segment.Time_Stim)
        e = handles.Segment.Time_Stim(end);
    else
        e = handles.Segment.Time_Stim(getappdata(hObject,'r'));
    end
    
    s = handles.Segment.Time_Stim(getappdata(hObject,'l'));
    setappdata(hObject,'skip',0);
    
    [a1,i_start_eye] = min(abs(handles.Segment.Time_Eye - s));
    [a2,i_end_eye] = min(abs(handles.Segment.Time_Eye - e));
    
    if isvector(handles.Segment.Time_Stim())
        
        [b1,i_start_stim] = min(abs(handles.Segment.Time_Stim - s));
        [b2,i_end_stim] = min(abs(handles.Segment.Time_Stim - e));
        
    else
        
        
        [b1,i_start_stim] = min(abs(handles.Segment.Time_Stim(:,1) - s));
        [b2,i_end_stim] = min(abs(handles.Segment.Time_Stim(:,1) - e));
        
        
    end
    
    
    if (i_end_stim-i_start_stim)~=(i_end_eye-i_start_eye)
        if (i_end_stim-i_start_stim)>(i_end_eye-i_start_eye)
            i_end_eye = i_end_eye +((i_end_stim-i_start_stim)-(i_end_eye-i_start_eye))
        else
            i_end_stim = i_end_stim + ((i_end_eye-i_start_eye)-(i_end_stim-i_start_stim))
        end
    end
    handles.i_start_eye = i_start_eye;
    handles.i_end_eye = i_end_eye;
    handles.i_start_stim = i_start_stim;
    handles.i_end_stim = i_end_stim;
    
    handles.Segment.start_t = s;
    handles.Segment.end_t = e;
    %
    
    
    Segment.segment_code_version = mfilename;
    Segment.raw_filename = handles.Segment.raw_filename;
    Segment.start_t = s;
    Segment.end_t = e;
    Segment.LE_Position_X = handles.Segment.LE_Position_X(i_start_eye:i_end_eye);
    Segment.LE_Position_Y = handles.Segment.LE_Position_Y(i_start_eye:i_end_eye);
    Segment.LE_Position_Z = handles.Segment.LE_Position_Z(i_start_eye:i_end_eye);
    
    Segment.RE_Position_X = handles.Segment.RE_Position_X(i_start_eye:i_end_eye);
    Segment.RE_Position_Y = handles.Segment.RE_Position_Y(i_start_eye:i_end_eye);
    Segment.RE_Position_Z = handles.Segment.RE_Position_Z(i_start_eye:i_end_eye);
    
    Segment.LE_Velocity_X = handles.Segment.LE_Velocity_X(i_start_eye:i_end_eye);
    Segment.LE_Velocity_Y = handles.Segment.LE_Velocity_Y(i_start_eye:i_end_eye);
    Segment.LE_Velocity_LARP = handles.Segment.LE_Velocity_LARP(i_start_eye:i_end_eye);
    Segment.LE_Velocity_RALP = handles.Segment.LE_Velocity_RALP(i_start_eye:i_end_eye);
    Segment.LE_Velocity_Z = handles.Segment.LE_Velocity_Z(i_start_eye:i_end_eye);
    
    Segment.RE_Velocity_X = handles.Segment.RE_Velocity_X(i_start_eye:i_end_eye);
    Segment.RE_Velocity_Y = handles.Segment.RE_Velocity_Y(i_start_eye:i_end_eye);
    Segment.RE_Velocity_LARP = handles.Segment.RE_Velocity_LARP(i_start_eye:i_end_eye);
    Segment.RE_Velocity_RALP = handles.Segment.RE_Velocity_RALP(i_start_eye:i_end_eye);
    Segment.RE_Velocity_Z = handles.Segment.RE_Velocity_Z(i_start_eye:i_end_eye);
    
    Segment.Fs = handles.Segment.Fs;
    
    Segment.Time_Eye = handles.Segment.Time_Eye(i_start_eye:i_end_eye);
    if isvector(handles.Segment.Time_Stim) % This is kludge to process either MVI LD VOG files, or PJB Lasker system elec. stime data. This needs to be rewritten
        Segment.Time_Stim = handles.Segment.Time_Stim(i_start_stim:i_end_stim);
    else
        Segment.Time_Stim = handles.Segment.Time_Stim(i_start_stim:i_end_stim,:);
    end
    
    
    switch handles.params.system_code
        case 1
            Segment.Stim_Trig = handles.Segment.Stim_Trig(i_start_eye:i_end_eye);
        case 2
            
            if isempty(handles.Segment.Stim_Trig)
                Segment.Stim_Trig = [];
            else
                Segment.Stim_Trig = handles.Segment.Stim_Trig(i_start_stim:i_end_stim);
            end
    end
    
    Segment.HeadMPUVel_X = handles.Segment.HeadMPUVel_X(i_start_stim:i_end_stim);
    Segment.HeadMPUVel_Y = handles.Segment.HeadMPUVel_Y(i_start_stim:i_end_stim);
    Segment.HeadMPUVel_Z = handles.Segment.HeadMPUVel_Z(i_start_stim:i_end_stim);
    
    Segment.HeadMPUAccel_X = handles.Segment.HeadMPUAccel_X(i_start_stim:i_end_stim);
    Segment.HeadMPUAccel_Y = handles.Segment.HeadMPUAccel_Y(i_start_stim:i_end_stim);
    Segment.HeadMPUAccel_Z = handles.Segment.HeadMPUAccel_Z(i_start_stim:i_end_stim);
    
    
    
end

handles.Segment = Segment;

segments = str2num(handles.segment_number.String);
if segments == 0
    folder_name = {uigetdir('','Select Directory to Save the Segmented Data')};
    setappdata(handles.save_segment,'foldername',folder_name{1});
end


[handles]=save_segment_Callback(hObject, eventdata, handles);
pause(.2)
guidata(hObject,handles)
uiresume(gcbf)
% Hints: get(hObject,'String') returns contents of stim_intensity as text
%        str2double(get(hObject,'String')) returns contents of stim_intensity as a double
end

function thresh_save_KeyPressFcn(hObject, eventdata, handles)
key = get(gcf,'CurrentKey');
if(strcmp(key, 'return'))
    thresh_save_Callback(hObject, eventdata, handles);
end
end

function thresh_save_Callback(hObject, eventdata, handles)
% hObject    handle to stim_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.thresh_value,'save',str2num(handles.thresh_value.String));
guidata(hObject,handles)
uiresume(gcbf)
% Hints: get(hObject,'String') returns contents of stim_intensity as text
%        str2double(get(hObject,'String')) returns contents of stim_intensity as a double
end

function thresh_value_Callback(hObject, eventdata, handles)
% hObject    handle to stim_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.threshold_Value = get(hObject,'String');
[handles] = update_thresh_val(hObject, eventdata, handles);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of stim_intensity as text
%        str2double(get(hObject,'String')) returns contents of stim_intensity as a double
end


function [handles] = update_thresh_val(hObject, eventdata, handles)
thresh_line = ones(1,length(handles.stim_mag));
thresh_line(1:end) = str2num(handles.threshold_Value);
handles.h.YData = thresh_line;
end



% --- Executes on button press in paramList.
function paramList_Callback(hObject, eventdata, handles)
% hObject    handle to paramList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.paramvals = getappdata(handles.paramList,'handles');
handles.paramvals.editParams = figure('Name','Edit Parameter List', 'NumberTitle','off');
handles.paramvals.editParams.OuterPosition = [50   300   1300   300];
id = table(handles.paramvals.initialize.ID,'VariableNames',{'Subject_ID'});
visit = table(handles.paramvals.initialize.visit,'VariableNames',{'Visit_Number'});
expType = table(handles.paramvals.initialize.expType,'VariableNames',{'Expirement_Type'});
expCond = table(handles.paramvals.initialize.expCond,'VariableNames',{'Expirement_Condition'});
stimAxis = table(handles.paramvals.initialize.stimAxis,'VariableNames',{'Stim_Axis'});
stimType = table(handles.paramvals.initialize.stimType,'VariableNames',{'Stim_Type'});
stimFreq = table(handles.paramvals.initialize.stimFreq,'VariableNames',{'Stim_Frequency'});
stimInt = table(handles.paramvals.initialize.stimInt,'VariableNames',{'Stim_Intensity'});
implant = table(handles.paramvals.initialize.implant,'VariableNames',{'Implant'});
eye = table(handles.paramvals.initialize.eye,'VariableNames',{'Eye'});

handles.paramvals.table.id = uitable(handles.paramvals.editParams,'Data',id{:,:},'ColumnName',id.Properties.VariableNames,...
    'Units', 'Pixels', 'Position',[30, 50, 110, 160],'ColumnEditable',true(1,length(handles.paramvals.initialize.ID)));
handles.paramvals.table.visit = uitable(handles.paramvals.editParams,'Data',visit{:,:},'ColumnName',visit.Properties.VariableNames,...
    'Units', 'Pixels', 'Position',[140, 50, 110, 160],'ColumnEditable',true(1,length(handles.paramvals.initialize.visit)));
handles.paramvals.table.expType = uitable(handles.paramvals.editParams,'Data',expType{:,:},'ColumnName',expType.Properties.VariableNames,...
    'Units', 'Pixels', 'Position',[250, 50, 130, 160],'ColumnEditable',true(1,length(handles.paramvals.initialize.expType)));
handles.paramvals.table.expCond = uitable(handles.paramvals.editParams,'Data',expCond{:,:},'ColumnName',expCond.Properties.VariableNames,...
    'Units', 'Pixels', 'Position',[380, 50, 160, 160],'ColumnEditable',true(1,length(handles.paramvals.initialize.expCond)));
handles.paramvals.table.stimAxis = uitable(handles.paramvals.editParams,'Data',stimAxis{:,:},'ColumnName',stimAxis.Properties.VariableNames,...
    'Units', 'Pixels', 'Position',[540, 50, 110, 160],'ColumnEditable',true(1,length(handles.paramvals.initialize.stimAxis)));
handles.paramvals.table.stimType = uitable(handles.paramvals.editParams,'Data',stimType{:,:},'ColumnName',stimType.Properties.VariableNames,...
    'Units', 'Pixels', 'Position',[650, 50, 110, 160],'ColumnEditable',true(1,length(handles.paramvals.initialize.stimType)));
handles.paramvals.table.stimFreq = uitable(handles.paramvals.editParams,'Data',stimFreq{:,:},'ColumnName',stimFreq.Properties.VariableNames,...
    'Units', 'Pixels', 'Position',[760, 50, 130, 160],'ColumnEditable',true(1,length(handles.paramvals.initialize.stimFreq)));
handles.paramvals.table.stimInt = uitable(handles.paramvals.editParams,'Data',stimInt{:,:},'ColumnName',stimInt.Properties.VariableNames,...
    'Units', 'Pixels', 'Position',[890, 50, 130, 160],'ColumnEditable',true(1,length(handles.paramvals.initialize.stimInt)));
handles.paramvals.table.implant = uitable(handles.paramvals.editParams,'Data',implant{:,:},'ColumnName',implant.Properties.VariableNames,...
    'Units', 'Pixels', 'Position',[1020, 50, 110, 160],'ColumnEditable',true(1,length(handles.paramvals.initialize.implant)));
handles.paramvals.table.eye = uitable(handles.paramvals.editParams,'Data',eye{:,:},'ColumnName',eye.Properties.VariableNames,...
    'Units', 'Pixels', 'Position',[1130, 50, 110, 160],'ColumnEditable',true(1,length(handles.paramvals.initialize.eye)));
handles.table.addEntry = uicontrol(handles.paramvals.editParams,'Style','pushbutton','String','Add Parameter','fontsize',20,'Position',[550 10 200 30],'CallBack',{@addEntry_Callback, handles});
handles.table.saveEntry = uicontrol(handles.paramvals.editParams,'Style','pushbutton','String','Save','fontsize',20,'Position',[1200 10 70 30],'CallBack',{@saveEntry_Callback, handles});
setappdata(hObject,'handles',handles.paramvals);
guidata(hObject,handles)
end

function addEntry_Callback(hObject, eventdata, handles)
handles.paramvals = getappdata(handles.paramList,'handles');
handles.paramvals.initialize.ID{end+1} = '';
handles.paramvals.initialize.visit{end+1} = '';
handles.paramvals.initialize.expType{end+1} = '';
handles.paramvals.initialize.expCond{end+1} = '';
handles.paramvals.initialize.stimAxis{end+1} = '';
handles.paramvals.initialize.stimType{end+1} = '';
handles.paramvals.initialize.stimFreq{end+1} = '';
handles.paramvals.initialize.stimInt{end+1} = '';
handles.paramvals.initialize.implant{end+1} = '';
handles.paramvals.initialize.eye{end+1} = '';
id = table(handles.paramvals.initialize.ID,'VariableNames',{'Subject_ID'});
visit = table(handles.paramvals.initialize.visit,'VariableNames',{'Visit_Number'});
expType = table(handles.paramvals.initialize.expType,'VariableNames',{'Expirement_Type'});
expCond = table(handles.paramvals.initialize.expCond,'VariableNames',{'Expirement_Condition'});
stimAxis = table(handles.paramvals.initialize.stimAxis,'VariableNames',{'Stim_Axis'});
stimType = table(handles.paramvals.initialize.stimType,'VariableNames',{'Stim_Type'});
stimFreq = table(handles.paramvals.initialize.stimFreq,'VariableNames',{'Stim_Frequency'});
stimInt = table(handles.paramvals.initialize.stimInt,'VariableNames',{'Stim_Intensity'});
implant = table(handles.paramvals.initialize.implant,'VariableNames',{'Implant'});
eye = table(handles.paramvals.initialize.eye,'VariableNames',{'Eye'});

handles.paramvals.table.id = uitable(handles.paramvals.editParams,'Data',id{:,:},'ColumnName',id.Properties.VariableNames,...
    'Units', 'Pixels', 'Position',[30, 50, 110, 160],'ColumnEditable',true(1,length(handles.paramvals.initialize.ID)));
handles.paramvals.table.visit = uitable(handles.paramvals.editParams,'Data',visit{:,:},'ColumnName',visit.Properties.VariableNames,...
    'Units', 'Pixels', 'Position',[140, 50, 110, 160],'ColumnEditable',true(1,length(handles.paramvals.initialize.visit)));
handles.paramvals.table.expType = uitable(handles.paramvals.editParams,'Data',expType{:,:},'ColumnName',expType.Properties.VariableNames,...
    'Units', 'Pixels', 'Position',[250, 50, 130, 160],'ColumnEditable',true(1,length(handles.paramvals.initialize.expType)));
handles.paramvals.table.expCond = uitable(handles.paramvals.editParams,'Data',expCond{:,:},'ColumnName',expCond.Properties.VariableNames,...
    'Units', 'Pixels', 'Position',[380, 50, 160, 160],'ColumnEditable',true(1,length(handles.paramvals.initialize.expCond)));
handles.paramvals.table.stimAxis = uitable(handles.paramvals.editParams,'Data',stimAxis{:,:},'ColumnName',stimAxis.Properties.VariableNames,...
    'Units', 'Pixels', 'Position',[540, 50, 110, 160],'ColumnEditable',true(1,length(handles.paramvals.initialize.stimAxis)));
handles.paramvals.table.stimType = uitable(handles.paramvals.editParams,'Data',stimType{:,:},'ColumnName',stimType.Properties.VariableNames,...
    'Units', 'Pixels', 'Position',[650, 50, 110, 160],'ColumnEditable',true(1,length(handles.paramvals.initialize.stimType)));
handles.paramvals.table.stimFreq = uitable(handles.paramvals.editParams,'Data',stimFreq{:,:},'ColumnName',stimFreq.Properties.VariableNames,...
    'Units', 'Pixels', 'Position',[760, 50, 130, 160],'ColumnEditable',true(1,length(handles.paramvals.initialize.stimFreq)));
handles.paramvals.table.stimInt = uitable(handles.paramvals.editParams,'Data',stimInt{:,:},'ColumnName',stimInt.Properties.VariableNames,...
    'Units', 'Pixels', 'Position',[890, 50, 130, 160],'ColumnEditable',true(1,length(handles.paramvals.initialize.stimInt)));
handles.paramvals.table.implant = uitable(handles.paramvals.editParams,'Data',implant{:,:},'ColumnName',implant.Properties.VariableNames,...
    'Units', 'Pixels', 'Position',[1020, 50, 110, 160],'ColumnEditable',true(1,length(handles.paramvals.initialize.implant)));
handles.paramvals.table.eye = uitable(handles.paramvals.editParams,'Data',eye{:,:},'ColumnName',eye.Properties.VariableNames,...
    'Units', 'Pixels', 'Position',[1130, 50, 110, 160],'ColumnEditable',true(1,length(handles.paramvals.initialize.eye)));
setappdata(handles.paramList,'handles',handles.paramvals);
guidata(hObject,handles)
end

function saveEntry_Callback(hObject, eventdata, handles)
handles.paramvals = getappdata(handles.paramList,'handles');
if (isempty(handles.paramvals.table.id.Data{end}))
    empty = find(cellfun('isempty',handles.paramvals.table.id.Data));
    handles.paramvals.table.id.Data(empty(find(empty>1))) = [];
    handles.paramvals.initialize.ID = handles.paramvals.table.id.Data;
else
    handles.paramvals.initialize.ID = handles.paramvals.table.id.Data;
end

if (isempty(handles.paramvals.table.visit.Data{end}))
    empty = find(cellfun('isempty',handles.paramvals.table.visit.Data));
    handles.paramvals.table.visit.Data(empty(find(empty>1))) = [];
    handles.paramvals.initialize.visit = handles.paramvals.table.visit.Data;
else
    handles.paramvals.initialize.visit = handles.paramvals.table.visit.Data;
end

if (isempty(handles.paramvals.table.expType.Data{end}))
    empty = find(cellfun('isempty',handles.paramvals.table.expType.Data));
    handles.paramvals.table.expType.Data(empty(find(empty>1))) = [];
    handles.paramvals.initialize.expType = handles.paramvals.table.expType.Data;
else
    handles.paramvals.initialize.expType = handles.paramvals.table.expType.Data;
end

if (isempty(handles.paramvals.table.expCond.Data{end}))
    empty = find(cellfun('isempty',handles.paramvals.table.expCond.Data));
    handles.paramvals.table.expCond.Data(empty(find(empty>1))) = [];
    handles.paramvals.initialize.expCond = handles.paramvals.table.expCond.Data;
else
    handles.paramvals.initialize.expCond = handles.paramvals.table.expCond.Data;
end

if (isempty(handles.paramvals.table.stimAxis.Data{end}))
    empty = find(cellfun('isempty',handles.paramvals.table.stimAxis.Data));
    handles.paramvals.table.stimAxis.Data(empty(find(empty>1))) = [];
    handles.paramvals.initialize.stimAxis = handles.paramvals.table.stimAxis.Data;
else
    handles.paramvals.initialize.stimAxis = handles.paramvals.table.stimAxis.Data;
end


if (isempty(handles.paramvals.table.stimType.Data{end}))
    empty = find(cellfun('isempty',handles.paramvals.table.stimType.Data));
    handles.paramvals.table.stimType.Data(empty(find(empty>1))) = [];
    handles.paramvals.initialize.stimType = handles.paramvals.table.stimType.Data;
else
    handles.paramvals.initialize.stimType = handles.paramvals.table.stimType.Data;
end

if (isempty(handles.paramvals.table.stimFreq.Data{end}))
    empty = find(cellfun('isempty',handles.paramvals.table.stimFreq.Data));
    handles.paramvals.table.stimFreq.Data(empty(find(empty>1))) = [];
    handles.paramvals.initialize.stimFreq = handles.paramvals.table.stimFreq.Data;
else
    handles.paramvals.initialize.stimFreq = handles.paramvals.table.stimFreq.Data;
end

if (isempty(handles.paramvals.table.stimInt.Data{end}))
    empty = find(cellfun('isempty',handles.paramvals.table.stimInt.Data));
    handles.paramvals.table.stimInt.Data(empty(find(empty>1))) = [];
    handles.paramvals.initialize.stimInt = handles.paramvals.table.stimInt.Data;
else
    handles.paramvals.initialize.stimInt = handles.paramvals.table.stimInt.Data;
end

if (isempty(handles.paramvals.table.implant.Data{end}))
    empty = find(cellfun('isempty',handles.paramvals.table.implant.Data));
    handles.paramvals.table.implant.Data(empty(find(empty>1))) = [];
    handles.paramvals.initialize.implant = handles.paramvals.table.implant.Data;
else
    handles.paramvals.initialize.implant = handles.paramvals.table.implant.Data;
end

if (isempty(handles.paramvals.table.eye.Data{end}))
    empty = find(cellfun('isempty',handles.paramvals.table.eye.Data));
    handles.paramvals.table.eye.Data(empty(find(empty>1))) = [];
    handles.paramvals.initialize.eye = handles.paramvals.table.eye.Data;
else
    handles.paramvals.initialize.eye = handles.paramvals.table.eye.Data;
end
cd(handles.initializePathName)
initialize = handles.paramvals.initialize;
save('initialize.mat','initialize')

handles.subj_id.String = handles.paramvals.initialize.ID;
handles.visit_number.String = handles.paramvals.initialize.visit;
handles.exp_type.String = handles.paramvals.initialize.expType;
handles.exp_condition.String = handles.paramvals.initialize.expCond;
handles.stim_axis.String = handles.paramvals.initialize.stimAxis;
handles.stim_type.String = handles.paramvals.initialize.stimType;
handles.stim_frequency.String = handles.paramvals.initialize.stimFreq;
handles.stim_intensity.String = handles.paramvals.initialize.stimInt;
handles.implant.String = handles.paramvals.initialize.implant;
handles.eye_rec.String = handles.paramvals.initialize.eye;
setappdata(handles.paramList,'handles',handles.paramvals);
guidata(hObject,handles)
close(handles.paramvals.editParams);
end


% --- Executes on button press in AdjustTrigCheckBox.
function AdjustTrigCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to AdjustTrigCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.AdjustTrig_flag = true;
else
    handles.AdjustTrig_flag = false;
end
% Hint: get(hObject,'Value') returns toggle state of AdjustTrigCheckBox

guidata(hObject,handles)

end


function AdjustTrig_Control_Callback(hObject, eventdata, handles)
% hObject    handle to AdjustTrig_Control (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input = get(hObject,'String');

handles.AdjustTrig = str2double(input);
% Hints: get(hObject,'String') returns contents of AdjustTrig_Control as text
%        str2double(get(hObject,'String')) returns contents of AdjustTrig_Control as a double

guidata(hObject,handles)


end

% --- Executes during object creation, after setting all properties.
function AdjustTrig_Control_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AdjustTrig_Control (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in recalibrateVOG.
function recalibrateVOG_Callback(hObject, eventdata, handles)
% hObject    handle to recalibrateVOG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% Check if a file is loaded
if (~isfield(handles,'raw_FileName')) || isempty(handles.raw_FileName)
    
    [handles] = load_raw_Callback(hObject, eventdata, handles)
    
end



% Load LE and RE calibration files

answer = questdlg(['You will be prompted to choose the LEFT and RIGHT eye calibration files for file: ' handles.raw_FileName], ...
    'Recalibration Menu', ...
    'OK','EXIT','EXIT');
% Handle response
switch answer
    case 'OK'
        
        [LEcalibFileName,LEcalibPathName] = uigetfile('.txt','Select LEFT EYE calibration file.')
        [REcalibFileName,REcalibPathName] = uigetfile('.txt','Select RIGHT EYE calibration file.')
        
        prompt = {'Enter the distance from the subject to the calibration grid [in]'};
        title = 'Distance To Wall (in.)';
        definput = {'55'};
        opts.Interpreter = 'tex';
        answer = inputdlg(prompt,title,[1 40],definput,opts);
        
        DistanceToWall = str2double(answer);
        
        flag = true;
    case {'EXIT',''}
        flag = false;
        
end

if flag
    
end

fname_data = strcat(handles.raw_PathName, handles.raw_FileName);

calib_file_fullpath_left = strcat(LEcalibPathName, LEcalibFileName);
calib_file_fullpath_right = strcat(REcalibPathName, REcalibFileName);
%
% matlab_calib_left = strcat(Base_Dir, 'Calib_Polynomial_Left.txt');
% matlab_calib_right = strcat(Base_Dir, 'Calib_Polynomial_Right.txt');

%     Python_Calib_Dir = strcat(Base_Dir, 'Python\Calib');
%     python_calib_left = strcat(Base_Dir, 'Python\Calib_Polynomial_Left.txt');
%     python_calib_right = strcat(Base_Dir, 'Python\Calib_Polynomial_Right.txt');
%



% Load Data from File
vogdata = handles.raw_data;
% These are the column indices of the relevant parameters saved to file
TIndex = 2;
HLeftIndex_Pix = 3;
VLeftIndex_Pix = 4;
TLeftIndex_Pix = 9;
HRightIndex_Pix = 15;
VRightIndex_Pix = 16;
TRightIndex_Pix = 21;
HLeftIndex_Deg = 40;
VLeftIndex_Deg = 41;
TLeftIndex_Deg = 42;
HRightIndex_Deg = 43;
VRightIndex_Deg = 44;
TRightIndex_Deg = 45;

% load eye positions in degrees
H_LE_pix = vogdata(:,HLeftIndex_Pix);
V_LE_pix = vogdata(:,VLeftIndex_Pix);
T_LE_pix = vogdata(:,TLeftIndex_Pix);
H_RE_pix = vogdata(:,HRightIndex_Pix);
V_RE_pix = vogdata(:,VRightIndex_Pix);
T_RE_pix = vogdata(:,TRightIndex_Pix);
H_LE_deg = vogdata(:,HLeftIndex_Deg);
V_LE_deg = vogdata(:,VLeftIndex_Deg);
T_LE_deg = vogdata(:,TLeftIndex_Deg);
H_RE_deg = vogdata(:,HRightIndex_Deg);
V_RE_deg = vogdata(:,VRightIndex_Deg);
T_RE_deg = vogdata(:,TRightIndex_Deg);
count = 0;

N = length(vogdata(:,TIndex));
%
%     time = zeros(N,1);
%     for i = 1:length(data(:,TIndex))-1
%         time(i+1) = (data(i,TIndex)+128*count-data(1,TIndex));
%         if (data(i+1,TIndex)-data(i,TIndex)) < 0
%             count = count + 1;
%         end
%     end

% Generate Time_Eye vector
Time = vogdata(:,2);
% The time vector recorded by the VOG goggles resets after it
% reaches a value of 128. We will find those transitions, and
% correct the time value.
inds =[1:length(Time)];
overrun_inds = inds([false ; (diff(Time) < -20)]);
Time_Eye = Time;
% Loop over each Time vector reset and add '128' to all data points
% following each transition.
for n =1:length(overrun_inds)
    Time_Eye(overrun_inds(n):end) = Time_Eye(overrun_inds(n):end)+128;
end
% Subtract the first time point
Time_Eye = Time_Eye - Time_Eye(1);



%     if (Calibration_Script_Type == MATLAB)

Eye = 'Left';
Polynomials_Left = VOG_Calibration_9_Points(Eye, DistanceToWall, calib_file_fullpath_left,handles.raw_FileName(1:end-4));

H_Left_Coeffs = Polynomials_Left(:,1);
V_Left_Coeffs = Polynomials_Left(:,2);

Eye = 'Right';
Polynomials_Right = VOG_Calibration_9_Points(Eye, DistanceToWall, calib_file_fullpath_right,handles.raw_FileName(1:end-4));

H_Right_Coeffs = Polynomials_Right(:,1);
V_Right_Coeffs = Polynomials_Right(:,2);

%     elseif (Calibration_Script_Type == PYTHON)
%         Eye = 'Left';
%         systemCommand = ['python GridCalibration.py ', calib_file_fullpath_left, ' ', num2str(DistanceToWall), ' ', Python_Calib_Dir, ' ', Eye];
%         [status, result] = system(systemCommand)
%
%         Eye = 'Right';
%         systemCommand = ['python GridCalibration.py ', calib_file_fullpath_right, ' ', num2str(DistanceToWall), ' ', Python_Calib_Dir, ' ', Eye];
%         [status, result] = system(systemCommand)
%
%         % Load left eye calib params from file
%         fileID = fopen(python_calib_left);
%         C = textscan(fileID,'%q %q', 'delimiter','\t');
%         H_Left_Coeffs = cellfun(@str2num,C{1});
%         V_Left_Coeffs = cellfun(@str2num,C{2});
%         fclose(fileID);
%
%         % Load right eye calib params from file
%         fileID = fopen(python_calib_right);
%         C = textscan(fileID,'%q %q', 'delimiter','\t');
%         H_Right_Coeffs = cellfun(@str2num,C{1});
%         V_Right_Coeffs = cellfun(@str2num,C{2});
%         fclose(fileID);
%     end



H_LE_deg_new = zeros(size(H_LE_deg));
V_LE_deg_new = zeros(size(H_LE_deg));
T_LE_deg_new = T_LE_deg;
H_RE_deg_new = zeros(size(H_LE_deg));
V_RE_deg_new = zeros(size(H_LE_deg));
T_RE_deg_new = T_RE_deg;



for i = 1:N
    H_LE_deg_new(i) = Polynomial_Surface_Mult(H_Left_Coeffs, H_LE_pix(i), V_LE_pix(i));
    V_LE_deg_new(i) = Polynomial_Surface_Mult(V_Left_Coeffs, H_LE_pix(i), V_LE_pix(i));
    H_RE_deg_new(i) = Polynomial_Surface_Mult(H_Right_Coeffs, H_RE_pix(i), V_RE_pix(i));
    V_RE_deg_new(i) = Polynomial_Surface_Mult(V_Right_Coeffs, H_RE_pix(i), V_RE_pix(i));
end
% The raw data in pixels will saturate when the subject blinks/tracking
% is lost. The VOG software will replace these data points w/ NaNs
% since there is no real tracking measurements. We will replace these
% saturated values in our newly calibrated data with NaNs.
H_LE_deg_new(isnan(H_LE_deg)) = nan(length(H_LE_deg_new(isnan(H_LE_deg))),1);
V_LE_deg_new(isnan(V_LE_deg)) = nan(length(V_LE_deg_new(isnan(V_LE_deg))),1);
H_RE_deg_new(isnan(H_RE_deg)) = nan(length(H_RE_deg_new(isnan(H_RE_deg))),1);
V_RE_deg_new(isnan(V_RE_deg)) = nan(length(V_RE_deg_new(isnan(V_RE_deg))),1);

vogdata(:,HLeftIndex_Deg) = H_LE_deg_new;
vogdata(:,VLeftIndex_Deg) = V_LE_deg_new;
vogdata(:,HRightIndex_Deg) = H_RE_deg_new;
vogdata(:,VRightIndex_Deg) = V_RE_deg_new;

%     HLeftIndex_Deg = 40;
%     VLeftIndex_Deg = 41;
%     TLeftIndex_Deg = 42;
%     HRightIndex_Deg = 43;
%     VRightIndex_Deg = 44;
%     TRightIndex_Deg = 45;

%     if sum(cell2mat(strfind(Raw_file_names,RawName)))<1
%         Raw_file_names{end+1} = RawName;

% answer = questdlg('Would you like to save the recalibrated LDVOG  file?', ...
%     'Recalibration Menu', ...
%     'YES','NO','NO');
% % Handle response
% switch answer
%     case 'YES'

str = inputdlg('Please enter the name of the output file (WITHOUT any suffix)','Output File', [1 100],{[handles.raw_FileName(1:end-4) '_UpdatedVOGCalib_' num2str(DistanceToWall) 'in' '__' datestr(now,'yyyy-mm-dd') '.txt']});


handles.recalibrateVOG.BackgroundColor = [1    1    0];
drawnow
dlmwrite([handles.raw_PathName str{1}], vogdata, 'delimiter',' ','precision','%.4f');
handles.recalibrateVOG.BackgroundColor = [0    1    0];
pause(1)
handles.recalibrateVOG.BackgroundColor = [0.9400    0.9400    0.9400];
%     case 'NO'

handles.raw_FileName = str{1};

[handles] = reload_raw_Callback(hObject, eventdata, handles)
% end
guidata(hObject,handles)
end



function stringAddonBox_Callback(hObject, eventdata, handles)
% hObject    handle to stringAddonBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stringAddonBox as text

setappdata(handles.stim_intensity,'suf',handles.stringAddonBox.String)
[handles] = update_seg_filename(hObject, eventdata, handles);
guidata(hObject,handles)



end
% --- Executes during object creation, after setting all properties.
function stringAddonBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stringAddonBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
