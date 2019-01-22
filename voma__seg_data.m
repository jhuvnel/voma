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

% Last Modified by GUIDE v2.5 09-Oct-2018 23:30:28

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

Segment.HeadMPUVel_X = handles.Segment.HeadMPUVel_X(i_start_stim:i_end_stim);
Segment.HeadMPUVel_Y = handles.Segment.HeadMPUVel_Y(i_start_stim:i_end_stim);
Segment.HeadMPUVel_Z = handles.Segment.HeadMPUVel_Z(i_start_stim:i_end_stim);

Segment.HeadMPUAccel_X = handles.Segment.HeadMPUAccel_X(i_start_stim:i_end_stim);
Segment.HeadMPUAccel_Y = handles.Segment.HeadMPUAccel_Y(i_start_stim:i_end_stim);
Segment.HeadMPUAccel_Z = handles.Segment.HeadMPUAccel_Z(i_start_stim:i_end_stim);




handles.Segment = Segment;

% Update plots!
keep_plot_limit = false; % We do not want to keep the same plot limits

plot_segment_data(hObject, eventdata, handles,keep_plot_limit)


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
    set(handles.worksheet_name,'String',[handles.visit_number.String{handles.visit_number.Value},'-',handles.date.String,'-',handles.exp_type.String{handles.exp_type.Value}]);
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
    setappdata(handles.export_data,'data',handles.experimentdata);
    handles.segment_number.String = num2str(segments);
    set(handles.save_indicator,'String','SAVED!')
    set(handles.save_indicator,'BackgroundColor','g')
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
    handles.experimentdata = {};
    
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
        phi = handles.Yaxis_MPU_Rot_theta;
        
        Rotation_Head = [
            cosd(phi) 0   sind(phi);
            0   1   0;
            -sind(phi)    0   cosd(phi)
            ];
        
        
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
        for k =1:length(overrun_inds)
            Time_Eye(overrun_inds(k):end) = Time_Eye(overrun_inds(k):end)+128;
        end
        % Subtract the first time point
        Time_Eye = Time_Eye - Time_Eye(1);
        
        % Generate the time vector for the MPU9250 Data
        Head_Sensor_Latency = 0.047; % From Mehdi Rahman bench tests, the data acquisition of the MPU9250 leads the LD VOG Goggles by 47ms
        
        Time_Stim = Time_Eye - Head_Sensor_Latency;
        
        
        % Load raw eye position data in Fick coordinates [degrees]
        Horizontal_LE_Position = data(:,HLeftIndex);
        Vertical_LE_Position = data(:,VLeftIndex);
        Torsion_LE_Position = data(:,TLeftIndex);
        Horizontal_RE_Position = data(:,HRightIndex);
        Vertical_RE_Position = data(:,VRightIndex);
        Torsion_RE_Position = data(:,TRightIndex);
        
        % We will use PJB's 'processeyemovements' routine to process the RAW
        % position data into 3D angular velocities. Note that this will be
        % an angular velocity calculation with NO filtering.
        
        FieldGains = []; % Input parameter for processing coil signals
        coilzeros = []; % Input parameter for processing coil signals
        ref = 0; % Input parameter for processing rotation vectors
        system_code = 1; % System code, in this case it tells the routine
        % NOT to apply and additional coordinate system trasnformation
        DAQ_code = 5; % Indicates we are processing Labyrinth Devices VOG Data
        
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
                
            case {3}
                
                Stim = zeros(1,length(Time_Eye));
                
        end
        
        
        gyroscale = 1;
        
        switch handles.params.vog_data_acq_version
            
            case {1}
                accelscale = 1;
                
            case {2,3}
                accelscale = 16384;
        end
        
        XvelHeadIndex = 30;
        YvelHeadIndex = 29;
        ZvelHeadIndex = 28;
        
        XaccelHeadIndex = 27;
        YaccelHeadIndex = 26;
        ZaccelHeadIndex = 25;
        
        
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
        
        Data.Stim_Trig = Stim;
        
        
        
        
    case 2 % Lasker System CED
        
        % Check if the user requested to start segmenting a new file, or a
        % 'reload' of the same file.
        if handles.params.reloadflag == 0
            % If requesting a new file, prompt the user to choose the file.
            [FileName,PathName,FilterIndex] = uigetfile('*.smr','Please choose the file to process');
            
            [FieldGainFile,FieldGainPath,FieldGainFilterIndex] = uigetfile('*.*','Please choose the field gains for this experiment');
            
            handles.raw_PathName = PathName;
            handles.raw_FileName = FileName;
            
            handles.raw_FieldGainPath = FieldGainPath;
            handles.raw_FieldGainFile = FieldGainFile;
            
            
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
        
        Data.segment_code_version = mfilename;
        Data.raw_filename = handles.raw_FileName;
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
        
    otherwise
        
        
        
end

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
handles.params.Lasker_param1 = index_selected;

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
        % We will relaize this by adding half of the ISI to the ON+OFF
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
    'String',{'Pulse Train';'Electric Only Sinusoid [CED]';'Mechanical Sinusoid';'LD VOG Electrical Only'},...
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


    function ontime_callback(popup,event)
        ontime = str2double(get(popup,'string'));
        
    end


    function offtime_callback(popup,event)
        offtime = str2double(get(popup,'string'));
    end

    function ISI_callback(popup,event)
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


    function freq_callback(popup,event)
        freq = str2double(get(popup,'string'));
        ontime = ((1/freq)/2) * 1000; % This parameter is saved in [ms]
        offtime = (1/freq)/2 * 1000; % This parameter is saved in [ms]
    end

    function preposttime_callback(popup,event)
        preposttime = str2double(get(popup,'string'));
        
    end
    function ISI_callback(popup,event)
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

upper_trigLev = handles.params.upper_trigLev;
lower_trigLev = handles.params.lower_trigLev;

auto_segment_Callback(hObject, eventdata, handles,upper_trigLev,lower_trigLev)

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

% Prompt user for experimental file
[FileName,PathName,FilterIndex] = uigetfile('*.xlsx','Please choose the experimental batch spreadsheet where the data will be exported');

handles.ss_PathName = PathName;
handles.ss_FileName = FileName;

set(handles.exp_spread_sheet_name,'String',FileName);
guidata(hObject,handles)
end

% --- Executes on button press in export_data.
% Exports temporarily saved data from text boxes to spreadsheet
% Compares filenames if worksheet is already present and replaces old data
% with new if match is found
function export_data_Callback(hObject, eventdata, handles)
% hObject    handle to export_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.export_data.BackgroundColor = [1    1    0];
pause(0.1);
cd(handles.ss_PathName);
if handles.ispc.flag
    [status,sheets,xlFormat] = xlsfinfo(handles.ss_FileName);
else
    A = importdata(handles.ss_FileName);
    if(isempty(A))
        disp('There are no sheets detected in this document at all.')
        return;
    elseif(iscell(A))
        disp('There is only one sheet in this excel document. Please add another sheet and add characters to one cell and a number to another cell.')
        return;
    else
        names = fieldnames(A.textdata);
        sheets = strrep(names,'0x2D','-')';
    end
end

handles.experimentdata = getappdata(hObject,'data');
rmvinds = strfind(handles.experimentdata(:,1),'.mat');
for k=1:length(rmvinds)
    
    temp = handles.experimentdata{k,1};
    
    temp(rmvinds{k}:rmvinds{k}+3) = '';
    
    handles.experimentdata{k,1} = temp;
end


if ismember(handles.worksheet_name.String, sheets)
    segs = size(handles.experimentdata);
    [num1, txt1, raw1] = xlsread(handles.exp_spread_sheet_name.String, handles.worksheet_name.String,'A:A');
    oldVals = size(txt1);
    newEntry = 0;
    [~,sheetnum] = ismember(handles.worksheet_name.String, sheets);
    if handles.ispc.flag
        for rs = 1:segs(1)
            if ismember([handles.experimentdata(rs,1)],txt1)
                replaceInd = [find(ismember(txt1,[handles.experimentdata(rs,1)]))];
                xlswrite(handles.ss_FileName, [handles.experimentdata(rs,:)], handles.worksheet_name.String, ['A',num2str(replaceInd(1)),':Q',num2str(replaceInd(1))]);
                
            else
                xlswrite(handles.ss_FileName, [handles.experimentdata(rs,:)], handles.worksheet_name.String, ['A',num2str(oldVals(1)+1+newEntry),':Q',num2str(oldVals(1)+1+newEntry)]);
                newEntry = newEntry+1;
            end
        end
    else
        for rs = 1:segs(1)
            if ismember([handles.experimentdata(rs,1)],txt1)
                replaceInd = [find(ismember(txt1,[handles.experimentdata(rs,1)]))];
                Tdata = cell2table([handles.experimentdata(rs,:)]);
                writetable(Tdata,handles.ss_FileName,'Sheet',sheetnum,'Range',['A',num2str(replaceInd(1)),':Q',num2str(replaceInd(1))],'WriteVariableNames',false)
            else
                Tdata = cell2table([handles.experimentdata(rs,:)]);
                writetable(Tdata,handles.ss_FileName,'Sheet',sheetnum,'Range',['A',num2str(oldVals(1)+1+newEntry),':Q',num2str(oldVals(1)+1+newEntry)],'WriteVariableNames',false)
                newEntry = newEntry+1;
            end
        end
    end
else
    labels = {'File Name','Date','Subject','Implant','Eye Recorded','Compression','Max PR [pps]','Baseline [pps]','Function','Mod Canal','Mapping Type','Frequency [Hz]','Max Velocity [dps]','Phase [degrees]','Cycles','Phase Direction','Notes'};
    % Check if the length of the Sheet name is > 31 chars
    if length(handles.worksheet_name.String)> 31
        handles.worksheet_name.String = handles.worksheet_name.String(1:31);
    end
    if handles.ispc.flag
        xlswrite(handles.exp_spread_sheet_name.String, labels, handles.worksheet_name.String,'A1:Q1')
        segs = size(handles.experimentdata);
        xlswrite(handles.exp_spread_sheet_name.String, [handles.experimentdata], handles.worksheet_name.String, ['A2:Q',num2str(segs(1)+1)]);
    else
        Tlabels = cell2table(labels);
        Tdata = cell2table([handles.experimentdata]);
        segs = size(handles.experimentdata);
        writetable(Tlabels,handles.exp_spread_sheet_name.String,'Sheet',handles.worksheet_name.String,'Range','A1:Q1','WriteVariableNames',false)
        writetable(Tdata,handles.exp_spread_sheet_name.String,'Sheet',handles.worksheet_name.String,'Range',['A2:Q',num2str(segs(1)+1)],'WriteVariableNames',false)
    end
end
handles.export_data.BackgroundColor = [0    1    0];
pause(1);
handles.export_data.BackgroundColor = [0.9400    0.9400    0.9400];
guidata(hObject,handles)
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
end

mask = zeros(length(trace),1);
handles.thresh_plot = figure('Name','Choose Threshold', 'NumberTitle','off');
handles.thresh_plot.OuterPosition = [512   600   700   520];
ax1 = axes;
ax1.Position = [0.06 0.2 0.9 0.75];

switch handles.choice.stim
    case 3 % Mechanical Sinusoids
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
        onset_inds_final = onset_inds([true  diff(onset_inds)>300]); % Take the backwards difference of the index values, keep the first index (true),disregard any differences less than 200
        % Keeping the first index allows for the initial onset to be selected
        end_inds_final = end_inds([diff(end_inds)>300 true]); % Take the backwards difference of the index values, keep the last index (true), disregard any differences less than 200
        % Keeping the last index allows for the last end to be selected
    case 4 % Electrical Only
        [a,b] = findpeaks(diff(onset_inds),'Threshold',15);
        onset_inds_final = onset_inds([1 b+1]);
        
        [c,d] = findpeaks(diff(end_inds),'Threshold',15);
        end_inds_final = end_inds([d length(end_inds)]);
end

lengthCheck = [];
end_del = [];
onset_del = [];
go = 1;
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
while go
    if check == length(end_inds_final)
        go = 0;
    end
    if (end_inds_final(check) - onset_inds_final(check)) < 300
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
        case 3 % Mechanical Sinusoids
            handles.HeadMPUVel_Z_plot = plot(handles.ax1,handles.Segment.Time_Stim,handles.Segment.HeadMPUVel_Z,'color','r','LineStyle',':');
            hold on
            handles.HeadMPUVel_Y_plot = plot(handles.ax1,handles.Segment.Time_Stim,handles.Segment.HeadMPUVel_Y,'color',[0.55 0.27 0.07],'LineStyle',':');
            handles.HeadMPUVel_X_plot = plot(handles.ax1,handles.Segment.Time_Stim,handles.Segment.HeadMPUVel_X,'color',[1 0.65 0],'LineStyle',':');
        case 4 % Electrical Only
            handles.stim_mag = plot(handles.ax1,handles.Segment.Time_Stim,handles.Segment.Stim_Trig,'color','k','LineWidth',2);
    end
    
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
    
    handles.right_extra_val = uicontrol(handles.seg_plots,'Style','edit','enable','off','String', handles.right_extra/100,'fontsize',12,'Position',[900 295 60 30]);
    handles.left_extra_val = uicontrol(handles.seg_plots,'Style','edit','enable','off','String', handles.left_extra/100,'fontsize',12,'Position',[15 295 60 30]);
    
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
    
    handles.right_extra = 300;
    handles.left_extra = 300;
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
handles.r = str2num(handles.right_extra_val.String)*100;
dif = round(1/(handles.Segment.Time_Stim(2)-handles.Segment.Time_Stim(1)))/100;
handles.r = handles.r + 200*dif;
handles.right_extra_val.String = handles.r/100;
handles.seg_patch2.XData([1 4]) = handles.seg_patch2.XData([1 4]) + [2;2];
setappdata(handles.ok_seg,'r',handles.end_inds_final(handles.plot_num) + handles.r);
guidata(hObject,handles)
end

function dec_right_Callback(hObject, eventdata, handles)
handles.r = str2num(handles.right_extra_val.String)*100;
dif = round(1/(handles.Segment.Time_Stim(2)-handles.Segment.Time_Stim(1)))/100;
handles.r = handles.r - 200*dif;
handles.right_extra_val.String = handles.r/100;
handles.seg_patch2.XData([1 4]) = handles.seg_patch2.XData([1 4]) - [2;2];
r = getappdata(handles.ok_seg,'r');
setappdata(handles.ok_seg,'r',handles.end_inds_final(handles.plot_num) + handles.r);
guidata(hObject,handles)
end


function inc_left_Callback(hObject, eventdata, handles)
handles.l = str2num(handles.left_extra_val.String)*100;
dif = round(1/(handles.Segment.Time_Stim(2)-handles.Segment.Time_Stim(1)))/100;
handles.l = handles.l + 200*dif;
handles.left_extra_val.String = handles.l/100;
handles.seg_patch1.XData([2 3]) = handles.seg_patch1.XData([2 3]) - [2;2];
setappdata(handles.ok_seg,'l',handles.onset_inds_final(handles.plot_num) - handles.l);
guidata(hObject,handles)
end

function dec_left_Callback(hObject, eventdata, handles)
handles.l = str2num(handles.left_extra_val.String)*100;
dif = round(1/(handles.Segment.Time_Stim(2)-handles.Segment.Time_Stim(1)))/100;
handles.l = handles.l - 200*dif;
handles.left_extra_val.String = handles.l/100;
handles.seg_patch1.XData([2 3]) = handles.seg_patch1.XData([2 3]) + [2;2];
setappdata(handles.ok_seg,'l',handles.onset_inds_final(handles.plot_num) - handles.l);
guidata(hObject,handles)
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




handles.Segment = Segment;

segments = str2num(handles.segment_number.String);
if segments == 0
    folder_name = {uigetdir('','Select Directory to Save the Segmented Data')};
    setappdata(handles.save_segment,'foldername',folder_name{1});
end


[handles]=save_segment_Callback(hObject, eventdata, handles);
pause(1)
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
