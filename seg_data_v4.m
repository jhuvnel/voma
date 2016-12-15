function varargout = seg_data_v4(varargin)
% SEG_DATA_V4 MATLAB code for seg_data_v4.fig
%      SEG_DATA_V4, by itself, creates a new SEG_DATA_V4 or raises the existing
%      singleton*.
%
%      H = SEG_DATA_V4 returns the handle to a new SEG_DATA_V4 or the handle to
%      the existing singleton*.
%
%      SEG_DATA_V4('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEG_DATA_V4.M with the given input arguments.
%
%      SEG_DATA_V4('Property','Value',...) creates a new SEG_DATA_V4 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before seg_data_v4_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to seg_data_v4_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help seg_data_v4

% Last Modified by GUIDE v2.5 12-Dec-2016 18:20:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @seg_data_v4_OpeningFcn, ...
                   'gui_OutputFcn',  @seg_data_v4_OutputFcn, ...
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


% --- Executes just before seg_data_v4 is made visible.
function seg_data_v4_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to seg_data_v4 (see VARARGIN)

% Choose default command line output for seg_data_v4
handles.output = hObject;

handles.params.subj_id = '';
handles.params.date = '';
handles.params.dev_name = '';
handles.params.stim_axis = '';
handles.params.stim_type = '';
handles.params.stim_intensity = '';

handles.params.system_code = 1;

handles.params.plot_MPUData = 1;
handles.params.plot_MVIGPIO = 1;
handles.params.plot_LEData = 1;
handles.params.plot_REData = 1;

handles.params.reloadflag = 0;

handles.params.gpio_mult = 1;

handles.params.goggleID = 1;

handles.params.vog_data_acq_version = 1;

handles.params.Lasker_param1 = 1;
handles.params.Lasker_param2 = 1;

handles.Yaxis_MPU_Rot_theta = str2double(get(handles.Yaxis_Rot_Theta,'String'));


set(handles.LaskerSystPanel,'Visible','Off')

[handles] = update_seg_filename(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes seg_data_v4 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = seg_data_v4_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in new_segment.
function new_segment_Callback(hObject, eventdata, handles)
% hObject    handle to new_segment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.save_indicator,'String','UNSAVED')
set(handles.save_indicator,'BackgroundColor','r')

% Ask user to 
uiwait(msgbox('Please align the vertical line of the crosshair with the starting point of the stimulus','Segment Eye Movement Data'));
[x1,y1] = ginput(1);
uiwait(msgbox('Please align the vertical line of the crosshair with the ending point of the stimulus','Segment Eye Movement Data'));
[x2,y2] = ginput(1);
time_cutout_s = [x1 ; x2];

%
[a1,i_start_eye] = min(abs(handles.Data.Time_Eye - time_cutout_s(1,1)));
[a2,i_end_eye] = min(abs(handles.Data.Time_Eye - time_cutout_s(2,1)));

if isvector(handles.Data.Time_Stim)
    
    [b1,i_start_stim] = min(abs(handles.Data.Time_Stim - time_cutout_s(1,1)));
    [b2,i_end_stim] = min(abs(handles.Data.Time_Stim - time_cutout_s(2,1)));
    
else
    
    
    [b1,i_start_stim] = min(abs(handles.Data.Time_Stim(1,:) - time_cutout_s(1,1)));
    [b2,i_end_stim] = min(abs(handles.Data.Time_Stim(1,:) - time_cutout_s(2,1)));
    
    
end

% Time_Eye = handles.Data.Time_Eye(i_start_eye:i_end_eye);

Segment.segment_code_version = mfilename;
Segment.raw_filename = handles.Data.raw_filename;
Segment.start_t = time_cutout_s(1);
Segment.end_t = time_cutout_s(2);
Segment.LE_Position_X = handles.Data.LE_Position_X(i_start_eye:i_end_eye);
Segment.LE_Position_Y = handles.Data.LE_Position_Y(i_start_eye:i_end_eye);
Segment.LE_Position_Z = handles.Data.LE_Position_Z(i_start_eye:i_end_eye);

Segment.RE_Position_X = handles.Data.RE_Position_X(i_start_eye:i_end_eye);
Segment.RE_Position_Y = handles.Data.RE_Position_Y(i_start_eye:i_end_eye);
Segment.RE_Position_Z = handles.Data.RE_Position_Z(i_start_eye:i_end_eye);

Segment.LE_Velocity_X = handles.Data.LE_Velocity_X(i_start_eye:i_end_eye);
Segment.LE_Velocity_Y = handles.Data.LE_Velocity_Y(i_start_eye:i_end_eye);
Segment.LE_Velocity_LARP = handles.Data.LE_Velocity_LARP(i_start_eye:i_end_eye);
Segment.LE_Velocity_RALP = handles.Data.LE_Velocity_RALP(i_start_eye:i_end_eye);
Segment.LE_Velocity_Z = handles.Data.LE_Velocity_Z(i_start_eye:i_end_eye);

Segment.RE_Velocity_X = handles.Data.RE_Velocity_X(i_start_eye:i_end_eye);
Segment.RE_Velocity_Y = handles.Data.RE_Velocity_Y(i_start_eye:i_end_eye);
Segment.RE_Velocity_LARP = handles.Data.RE_Velocity_LARP(i_start_eye:i_end_eye);
Segment.RE_Velocity_RALP = handles.Data.RE_Velocity_RALP(i_start_eye:i_end_eye);
Segment.RE_Velocity_Z = handles.Data.RE_Velocity_Z(i_start_eye:i_end_eye);

Segment.Fs = handles.Data.Fs;

Segment.Time_Eye = handles.Data.Time_Eye(i_start_eye:i_end_eye);
if isvector(handles.Data.Time_Stim)
Segment.Time_Stim = handles.Data.Time_Stim(i_start_stim:i_end_stim);    
else
Segment.Time_Stim = handles.Data.Time_Stim(:,i_start_stim:i_end_stim);
end


switch handles.params.system_code
    case 1
Segment.Stim_Trig = handles.Data.Stim_Trig(i_start_eye:i_end_eye);
    case 2
        Segment.Stim_Trig = handles.Data.Stim_Trig(i_start_stim:i_end_stim);

end

Segment.HeadMPUVel_X = handles.Data.HeadMPUVel_X(i_start_stim:i_end_stim);
Segment.HeadMPUVel_Y = handles.Data.HeadMPUVel_Y(i_start_stim:i_end_stim);
Segment.HeadMPUVel_Z = handles.Data.HeadMPUVel_Z(i_start_stim:i_end_stim);

Segment.HeadMPUAccel_X = handles.Data.HeadMPUAccel_X(i_start_stim:i_end_stim);
Segment.HeadMPUAccel_Y = handles.Data.HeadMPUAccel_Y(i_start_stim:i_end_stim);
Segment.HeadMPUAccel_Z = handles.Data.HeadMPUAccel_Z(i_start_stim:i_end_stim);




handles.Segment = Segment;

% Update plots!
plot_segment_data(hObject, eventdata, handles)

% % Reset and plot segment
% axes(handles.data_plot)
% cla reset
% 
% hold on
% 
% if handles.params.plot_MPUData == 1
%     plot(handles.data_plot,Segment.Time_Stim,Segment.HeadMPU_X,'color',[1 0.65 0],'LineStyle',':','DisplayName','MPU-X')
%     plot(handles.data_plot,Segment.Time_Stim,Segment.HeadMPU_Y,'color',[0.55 0.27 0.07],'LineStyle',':','DisplayName','MPU-Y')
%     plot(handles.data_plot,Segment.Time_Stim,Segment.HeadMPU_Z,'color','r','LineStyle',':','DisplayName','MPU-Z')
% end
% 
% if handles.params.plot_MVIGPIO == 1
%     plot(handles.data_plot,Segment.Time_Eye,Segment.Stim_Trig,'color','k','DisplayName','Stim - Trig')
% end
% 
% if handles.params.plot_LEData == 1
%     plot(handles.data_plot,Segment.Time_Eye,Segment.LE_Position_X,'color',[255 140 0]/255,'DisplayName','LE-X')
%     plot(handles.data_plot,Segment.Time_Eye,Segment.LE_Position_Y,'color',[128 0 128]/255,'DisplayName','LE-Y')
%     plot(handles.data_plot,Segment.Time_Eye,Segment.LE_Position_Z,'color','r','DisplayName','LE-Z')
% end
% 
% if handles.params.plot_REData == 1
%     plot(handles.data_plot,Segment.Time_Eye,Segment.RE_Position_X,'color',[255 165 0]/255,'DisplayName','LE-X')
%     plot(handles.data_plot,Segment.Time_Eye,Segment.RE_Position_Y,'color',[138 43 226]/255,'DisplayName','LE-Y')
%     plot(handles.data_plot,Segment.Time_Eye,Segment.RE_Position_Z,'color',[255,0,255]/255,'DisplayName','LE-Z')
% end
% 
% xlabel('Time [s]')
% ylabel('Stimulus Amplitude')
% 
% legend('show')


guidata(hObject,handles)

function plot_segment_data(hObject, eventdata, handles)


% Reset and plot segment
axes(handles.data_plot)
cla reset

hold on

if handles.params.plot_MPUData == 1
    plot(handles.data_plot,handles.Segment.Time_Stim,handles.Segment.HeadMPUVel_X,'color',[1 0.65 0],'LineStyle',':','DisplayName','MPU-X')
    plot(handles.data_plot,handles.Segment.Time_Stim,handles.Segment.HeadMPUVel_Y,'color',[0.55 0.27 0.07],'LineStyle',':','DisplayName','MPU-Y')
    plot(handles.data_plot,handles.Segment.Time_Stim,handles.Segment.HeadMPUVel_Z,'color','r','LineStyle',':','DisplayName','MPU-Z')
end

if handles.params.plot_MVIGPIO == 1
    switch handles.params.system_code
        
        case 1
            plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.Stim_Trig*handles.params.gpio_mult,'color','k','DisplayName','Stim - Trig')
        case 2
            plot(handles.data_plot,handles.Segment.Time_Stim(1,:),ones(1,length(handles.Segment.Time_Stim(1,:)))*handles.params.gpio_mult,'color','k','Marker','*','DisplayName','Stim - Trig')
    end
end

if handles.params.plot_LEData == 1
    plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.LE_Position_X,'color',[255 140 0]/255,'DisplayName','LE-X')
    plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.LE_Position_Y,'color',[128 0 128]/255,'DisplayName','LE-Y')
    plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.LE_Position_Z,'color','r','DisplayName','LE-Z')
end

if handles.params.plot_REData == 1
    plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.RE_Position_X,'color',[255 165 0]/255,'DisplayName','RE-X')
    plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.RE_Position_Y,'color',[138 43 226]/255,'DisplayName','RE-Y')
    plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.RE_Position_Z,'color',[255,0,255]/255,'DisplayName','RE-Z')
end

xlabel('Time [s]')
ylabel('Stimulus Amplitude')

legend('show')


% --- Executes on button press in save_segment.
function save_segment_Callback(hObject, eventdata, handles)
% hObject    handle to save_segment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder_name = uigetdir('','Select Directory to Save the Segmented Data');

cd(folder_name)
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

save(handles.params.segment_filename,'Data')

set(handles.save_indicator,'String','SAVED!')
set(handles.save_indicator,'BackgroundColor','g')

guidata(hObject,handles)

% --- Executes on button press in load_raw.
function load_raw_Callback(hObject, eventdata, handles)
% hObject    handle to load_raw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Prompt user for experimental file

set(handles.save_indicator,'String','UNSAVED')
set(handles.save_indicator,'BackgroundColor','r')


switch handles.params.system_code
    
    case 1 % Labyrinth Devices 3D VOG
        
        % Check if the user requested to start segmenting a new file, or a
        % 'reload' of the same file.
        if handles.params.reloadflag == 0
            % If requesting a new file, prompt the user to choose the file.
            [FileName,PathName,FilterIndex] = uigetfile('*.txt','Please choose the experimental batch spreadsheet for analysis');
            
            handles.raw_PathName = PathName;
            handles.raw_FileName = FileName;
            
            set(handles.raw_name,'String',FileName);
        else
            % If we are reloading a file, don't prompt the user and reset
            % the 'reload' flag.
            FileName = handles.raw_FileName;
            PathName = handles.raw_PathName;
            handles.params.reloadflag = 0;
        end
        
         
        
        
        
        
        
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
        
        % Load raw eye position data in Fick coordinates [degrees]
        Horizontal_LE_Position = data(:,HLeftIndex);
        Vertical_LE_Position = data(:,VLeftIndex);
        Torsion_LE_Position = data(:,TLeftIndex);
        Horizontal_RE_Position = data(:,HRightIndex);
        Vertical_RE_Position = data(:,VRightIndex);
        Torsion_RE_Position = data(:,TRightIndex);
        
        % We will use my 'processeyemovements' routine to process the RAW
        % position data into 3D angular velocities. Note that this will be
        % an angular velocity calculation with NO filtering.
        
        FieldGains = []; % Input parameter for processing coil signals
        coilzeros = []; % Input parameter for processing coil signals
        ref = 0; % Input parameter for processing rotation vectors
        system_code = 5; % System code, in this case it tells the routine
        % NOT to apply and additional coordinate system trasnformation
        DAQ_code = 3; % Indicates we are processing Labyrinth Devices VOG Data
        
        [EyeVel] = processeyemovements_v6(PathName,FileName,FieldGains,coilzeros,ref,system_code,DAQ_code);
        
        
        switch handles.params.vog_data_acq_version
            
            case {1,2}
                % Index for the VOG GPIO line
                StimIndex = 35;
                
                Stim = data(1:length(Time_Eye),StimIndex);
                
            case {3}
                
                Stim = zeros(1,length(Time_Eye));
                
        end
        % NOTE, this is a kludge! I do not have the MPU offsets/notes for
        % each set of goggles the patient used. I will take an average of
        % the first 50 sample points to estimate the offset for each axis
        % of rotation
        
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
        
        
        Head_Sensor_Latency = 0.047;

        Time_Stim = Time_Eye - Head_Sensor_Latency;
        
        Data.segment_code_version = mfilename;
        Data.raw_filename = handles.raw_FileName;
        Data.LE_Position_X = Torsion_LE_Position;
        Data.LE_Position_Y = Vertical_LE_Position;
        Data.LE_Position_Z = Horizontal_LE_Position;

        Data.RE_Position_X = Torsion_RE_Position;
        Data.RE_Position_Y = Vertical_RE_Position;
        Data.RE_Position_Z = Horizontal_RE_Position;

        Data.LE_Velocity_X = EyeVel.lx;
        Data.LE_Velocity_Y = EyeVel.ly;
        Data.LE_Velocity_LARP = EyeVel.ll;
        Data.LE_Velocity_RALP = EyeVel.lr;
        Data.LE_Velocity_Z = EyeVel.lz;
        
        Data.RE_Velocity_X = EyeVel.rx;
        Data.RE_Velocity_Y = EyeVel.ry;
        Data.RE_Velocity_LARP = EyeVel.rl;
        Data.RE_Velocity_RALP = EyeVel.rr;
        Data.RE_Velocity_Z = EyeVel.rz;
        
        
        Data.HeadMPUVel_X = XAxisVelHead';
        Data.HeadMPUVel_Y = YAxisVelHead';
        Data.HeadMPUVel_Z = ZAxisVelHead';
        
        Data.HeadMPUAccel_X = XAxisAccelHead';
        Data.HeadMPUAccel_Y = YAxisAccelHead';
        Data.HeadMPUAccel_Z = ZAxisAccelHead';
        
        Data.Fs = 100;
        
        Data.Time_Eye = Time_Eye;
        Data.Time_Stim = Time_Stim;
        
        Data.Stim_Trig = Stim;
        
        
%         handles.Segment = Data;
        
%         % Reset and plot segment
%         axes(handles.data_plot)
%         cla reset
%         
%         hold on
%         
%         if handles.params.plot_MPUData == 1
%             plot(handles.data_plot,Data.Time_Stim,Data.HeadMPU_X,'color',[1 0.65 0],'LineStyle',':','DisplayName','MPU-X')
%             plot(handles.data_plot,Data.Time_Stim,Data.HeadMPU_Y,'color',[0.55 0.27 0.07],'LineStyle',':','DisplayName','MPU-Y')
%             plot(handles.data_plot,Data.Time_Stim,Data.HeadMPU_Z,'color','r','LineStyle',':','DisplayName','MPU-Z')
%         end
%         
%         if handles.params.plot_MVIGPIO == 1
%             plot(handles.data_plot,Data.Time_Eye,Data.Stim_Trig,'color','k','DisplayName','Stim - Trig')
%         end
%         
%         if handles.params.plot_LEData == 1
%             plot(handles.data_plot,Data.Time_Eye,Data.LE_Position_X,'color',[255 140 0]/255,'DisplayName','LE-X')
%             plot(handles.data_plot,Data.Time_Eye,Data.LE_Position_Y,'color',[128 0 128]/255,'DisplayName','LE-Y')
%             plot(handles.data_plot,Data.Time_Eye,Data.LE_Position_Z,'color','r','DisplayName','LE-Z')
%         end
%         
%         if handles.params.plot_REData == 1
%             plot(handles.data_plot,Data.Time_Eye,Data.RE_Position_X,'color',[255 165 0]/255,'DisplayName','LE-X')
%             plot(handles.data_plot,Data.Time_Eye,Data.RE_Position_Y,'color',[138 43 226]/255,'DisplayName','LE-Y')
%             plot(handles.data_plot,Data.Time_Eye,Data.RE_Position_Z,'color',[255,0,255]/255,'DisplayName','LE-Z')
%         end
%         
%         xlabel('Time [s]')
%         ylabel('stimulus Amplitude')
        
% plot_segment_data(hObject, eventdata, handles)

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
        DAQ_code = 2; % Lasker System as recorded by a CED 1401 device
                
        
        [RawData] = processeyemovements_v7(PathName,FileName,FieldGains,coilzeros,ref,system_code,DAQ_code);
        
        % Attempt to
        
        Data.segment_code_version = mfilename;
        Data.raw_filename = handles.raw_FileName;
        Data.LE_Position_X = RawData.LE_Pos_X;
        Data.LE_Position_Y = RawData.LE_Pos_Y;
        Data.LE_Position_Z = RawData.LE_Pos_Z;

        Data.RE_Position_X = RawData.RE_Pos_X;
        Data.RE_Position_Y = RawData.RE_Pos_Y;
        Data.RE_Position_Z = RawData.RE_Pos_Z;

        Data.LE_Velocity_X = RawData.lx;
        Data.LE_Velocity_Y = RawData.ly;
        Data.LE_Velocity_LARP = RawData.ll;
        Data.LE_Velocity_RALP = RawData.lr;
        Data.LE_Velocity_Z = RawData.lz;
        
        Data.RE_Velocity_X = RawData.rx;
        Data.RE_Velocity_Y = RawData.ry;
        Data.RE_Velocity_LARP = RawData.rl;
        Data.RE_Velocity_RALP = RawData.rr;
        Data.RE_Velocity_Z = RawData.rz;
        
        Data.Fs = RawData.Fs;
        
             
        
        
        Data.Time_Eye = [0:length(RawData.ll)-1]/Data.Fs;
        Data.Time_Stim = RawData.ElecStimTrig';
        
        if isempty(RawData.ElecStimTrig)
        
            Data.Stim_Trig = [];
        else
            % We will calculate PR using a first order backwards difference
            % instantaneous rate approx. We are not using a central
            % difference, since it will smear/smooth the Pulse rate values
            PR = 1./diff(RawData.ElecStimTrig(:,1));
            % To have the same number of PR valuse as pulse times, we will
            % copy the first entry in the array, and append the PR array in
            % the front. The first value in the PR array is really
            % "PulseTime(2)-PulseTime(1)". The actual value plotted/saved
            % here is vor graphical purposes only and the actual pulse
            % times themselves will be used for analysis.
            Data.Stim_Trig = [PR(1) PR'];
            
        end
        
        % Kludge for now!
        Data.HeadMPUVel_X = zeros(1,length(Data.Stim_Trig));
        Data.HeadMPUVel_Y = zeros(1,length(Data.Stim_Trig));
        Data.HeadMPUVel_Z = zeros(1,length(Data.Stim_Trig));
        
        Data.HeadMPUAccel_X = zeros(1,length(Data.Stim_Trig));
        Data.HeadMPUAccel_Y = zeros(1,length(Data.Stim_Trig));
        Data.HeadMPUAccel_Z = zeros(1,length(Data.Stim_Trig));
        
    otherwise
        
        
        
end

% Save the whole data trace in the GUI handles.
handles.Data = Data;
% Then save the whole data trace as the 'segment' variable in the handles.
% This if a user decides they want to process the whole data trace, they
% can just export the data.
handles.Segment = Data;
% Update the GUI plot
plot_segment_data(hObject, eventdata, handles)


guidata(hObject,handles)

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

        
        
    case 2 % Labyrinth Devices VOG Goggles
        
        set(handles.LaskerSystPanel,'Visible','On')
        
        set(handles.LabDevVOG,'Visible','Off')
        
    otherwise
        set(handles.LabDevVOG,'Visible','Off')
        set(handles.LaskerSystPanel,'Visible','Off')
        
end
    
guidata(hObject,handles)
% Hints: contents = cellstr(get(hObject,'String')) returns eye_mov_system contents as cell array
%        contents{get(hObject,'Value')} returns selected item from eye_mov_system


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


% --- Executes on button press in reload_raw.
function reload_raw_Callback(hObject, eventdata, handles)
% hObject    handle to reload_raw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% switch handles.params.system_code
%     
%     case 1 % Labyrinth Devices 3D VOG
%         % This code was taken from the ''Analyze_VOG_Head_and_Eye_Data_Single_Plot.m'' from Mehdi Rahman
%         
%         gyroscale = 1;
%         
%         phi_eye_correction = 0;
%         phi = 170;
%         
%         % These are the column indices of the relevant parameters saved to file
%         % NOTE! MVI001R019 Pre-Op data was acquired without the GPIO line,
%         % and thus all of the follwing indices are decremented by 1.
%         HLeftIndex = 40;
%         VLeftIndex = 41;
%         TLeftIndex = 42;
%         HRightIndex = 43;
%         VRightIndex = 44;
%         TRightIndex = 45;
%         
%         % Patient System
%         XvelHeadOffset = 2.13;
%         YvelHeadOffset = -1.36;
%         ZvelHeadOffset = -1.03;
%         
%         % rotation of PCB 150 degrees about y-axis
%         Rotation_Y = [
%             cosd(phi) 0   sind(phi);
%             0   1   0;
%             -sind(phi)    0   cosd(phi)
%             ];
%         
%         Rotation_Head = Rotation_Y;
%         
%         Pitch_Eye_Correction = [
%             cosd(phi_eye_correction) 0   sind(phi_eye_correction);
%             0   1   0;
%             -sind(phi_eye_correction)    0   cosd(phi_eye_correction)
%             ];
%         
%         Rotation_Eye = Pitch_Eye_Correction;
%         
%         
%         % Load Data
%         data = dlmread(handles.params.raw_name,' ',1,0);
%         
%         % Generate Time_Eye vector
%         count = 0;
%         for i = 2:length(data)-1
%             Time_Eye(i) = (data(i,2)+128*count-data(1,2));
%             if (data(i+1,2)-data(i,2)) < 0
%                 count = count + 1;
%             end
%         end
%         
%         % load eye positions in degrees
%         theta_LE_deg = data(:,HLeftIndex);
%         phi_LE_deg = data(:,VLeftIndex);
%         psi_LE_deg = data(:,TLeftIndex);
%         theta_RE_deg = data(:,HRightIndex);
%         phi_RE_deg = data(:,VRightIndex);
%         psi_RE_deg = data(:,TRightIndex);
%         
%         %
%         
%         
%         for i = 2:length(Time_Eye)-1
%             if(data(i+1,2)-data(i,2) == data(i,2)-data(i-1,2))
%                 dtheta_LE(i) = (theta_LE_deg(i+1) - theta_LE_deg(i-1))/(2*(Time_Eye(i+1)-Time_Eye(i)));
%                 dphi_LE(i) = (phi_LE_deg(i+1) - phi_LE_deg(i-1))/(2*(Time_Eye(i+1)-Time_Eye(i)));
%                 dpsi_LE(i) = ((psi_LE_deg(i+1) - psi_LE_deg(i-1)))/(2*(Time_Eye(i+1)-Time_Eye(i)));
%                 dtheta_RE(i) = (theta_RE_deg(i+1) - theta_RE_deg(i-1))/(2*(Time_Eye(i+1)-Time_Eye(i)));
%                 dphi_RE(i) = (phi_RE_deg(i+1) - phi_RE_deg(i-1))/(2*(Time_Eye(i+1)-Time_Eye(i)));
%                 dpsi_RE(i) = ((psi_RE_deg(i+1) - psi_RE_deg(i-1)))/(2*(Time_Eye(i+1)-Time_Eye(i)));
%             else
%                 dtheta_LE(i) = ((theta_LE_deg(i+1) - theta_LE_deg(i)))/((Time_Eye(i+1)-Time_Eye(i)));
%                 dphi_LE(i) = ((phi_LE_deg(i+1) - phi_LE_deg(i)))/((Time_Eye(i+1)-Time_Eye(i)));
%                 dpsi_LE(i) = ((psi_LE_deg(i+1) - psi_LE_deg(i)))/((Time_Eye(i+1)-Time_Eye(i)));
%                 dtheta_RE(i) = ((theta_RE_deg(i+1) - theta_RE_deg(i)))/((Time_Eye(i+1)-Time_Eye(i)));
%                 dphi_RE(i) = ((phi_RE_deg(i+1) - phi_RE_deg(i)))/((Time_Eye(i+1)-Time_Eye(i)));
%                 dpsi_RE(i) = ((psi_RE_deg(i+1) - psi_RE_deg(i)))/((Time_Eye(i+1)-Time_Eye(i)));
%             end
%             
%             TvelLE(i) = dpsi_LE(i)*cosd(theta_LE_deg(i))*cosd(phi_LE_deg(i)) - dphi_LE(i)*sind(theta_LE_deg(i));
%             VvelLE(i) = dpsi_LE(i)*sind(theta_LE_deg(i))*cosd(phi_LE_deg(i)) + dphi_LE(i)*cosd(theta_LE_deg(i));
%             HvelLE(i) = dtheta_LE(i) - dpsi_LE(i) * sind(phi_LE_deg(i));
%             TvelRE(i) = dpsi_RE(i)*cosd(theta_RE_deg(i))*cosd(phi_RE_deg(i)) - dphi_RE(i)*sind(theta_RE_deg(i));
%             VvelRE(i) = dpsi_RE(i)*sind(theta_RE_deg(i))*cosd(phi_RE_deg(i)) + dphi_RE(i)*cosd(theta_RE_deg(i));
%             HvelRE(i) = dtheta_RE(i) - dpsi_RE(i) * sind(phi_RE_deg(i));
%             
%         end
%         
%         
%         %
%         StimIndex = 35;
%         
%         Stim_Scale_Factor = 1;
%         
%         Stim = Stim_Scale_Factor*data(1:length(Time_Eye),StimIndex);
%         
%         XvelHead = data(1:length(Time_Eye),30)*gyroscale + XvelHeadOffset;
%         YvelHead = data(1:length(Time_Eye),29)*gyroscale + YvelHeadOffset;
%         ZvelHead = data(1:length(Time_Eye),28)*gyroscale + ZvelHeadOffset;
%         
%         
%         A = Rotation_Head * [XvelHead' ; YvelHead' ; ZvelHead'];
%         
%         Axis1VelHead = A(1,:);
%         Axis2VelHead = A(2,:);
%         Axis3VelHead = A(3,:);
%         
%         
%         
%         Head_Sensor_Latency = 0.047;
%         
%         Time_Stim = Time_Eye - Head_Sensor_Latency;
%         
%         Axis1HeadVel = Axis1VelHead;
%         Axis2HeadVel = Axis2VelHead;
%         Axis3HeadVel = Axis3VelHead;
%         Axis3LeftEyeVel = TvelLE;
%         Axis2LeftEyeVel = VvelLE;
%         Axis1LeftEyeVel = HvelLE;
%         Axis3RightEyeVel = TvelRE;
%         Axis2RightEyeVel = VvelRE;
%         Axis1RightEyeVel = HvelRE;
%         
%         %         if (SCC_Plane == 'LHRH')
%         %             Stimulus = Axis3HeadVel;
%         %         elseif (SCC_Plane == 'RALP')
%         %             Stimulus = Axis2HeadVel;
%         %         elseif (SCC_Plane == 'LARP')
%         %             Stimulus = Axis1HeadVel;
%         %         end
%         
%         axes(handles.data_plot)
%         cla reset
%         
%         plot(handles.data_plot,Time_Eye,Axis1HeadVel,'color',[1 0.65 0])
%         hold on
%         plot(handles.data_plot,Time_Stim,Axis2HeadVel,'color',[0.55 0.27 0.07])
%         plot(handles.data_plot,Time_Stim,Axis3HeadVel,'color','r')
%         plot(handles.data_plot,Time_Stim,Stim,'color','k')
%         
%         xlabel('Time [s]')
%         ylabel('stimulus Amplitude')
%         
%                 
%         Data.TposLE = psi_LE_deg;
%         Data.VposLE = phi_LE_deg;
%         Data.HposLE = theta_LE_deg;
%         Data.TposRE = psi_RE_deg;
%         Data.VposRE = phi_RE_deg;
%         Data.HposRE = theta_RE_deg;
%         Data.Axis1HeadVel = Axis1HeadVel;
%         Data.Axis2HeadVel = Axis2HeadVel;
%         Data.Axis3HeadVel = Axis3HeadVel;
%         Data.Axis3LeftEyeVel = Axis3LeftEyeVel;
%         Data.Axis2LeftEyeVel = Axis2LeftEyeVel;
%         Data.Axis1LeftEyeVel = Axis1LeftEyeVel;
%         Data.Axis3RightEyeVel = Axis3RightEyeVel;
%         Data.Axis2RightEyeVel = Axis2RightEyeVel;
%         Data.Axis1RightEyeVel = Axis1RightEyeVel;
%         Data.Time_Stim = Time_Stim;
%         Data.Time_Eye = Time_Eye;
%         Data.Stim = Stim;
%     otherwise
%         
%         
%         
% end
% 
% handles.Data = Data;
% 

handles.params.reloadflag = 1;

guidata(hObject,handles)

load_raw_Callback(hObject, eventdata, handles)


function subj_id_Callback(hObject, eventdata, handles)
% hObject    handle to subj_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.params.subj_id = get(hObject,'String');
[handles] = update_seg_filename(hObject, eventdata, handles);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of subj_id as text
%        str2double(get(hObject,'String')) returns contents of subj_id as a double


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



function date_Callback(hObject, eventdata, handles)
% hObject    handle to date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.params.date = get(hObject,'String');
[handles] = update_seg_filename(hObject, eventdata, handles);
guidata(hObject,handles)
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



function dev_name_Callback(hObject, eventdata, handles)
% hObject    handle to dev_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.params.dev_name = get(hObject,'String');
[handles] = update_seg_filename(hObject, eventdata, handles);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of dev_name as text
%        str2double(get(hObject,'String')) returns contents of dev_name as a double


% --- Executes during object creation, after setting all properties.
function dev_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dev_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stim_axis_Callback(hObject, eventdata, handles)
% hObject    handle to stim_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.params.stim_axis = get(hObject,'String');
[handles] = update_seg_filename(hObject, eventdata, handles);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of stim_axis as text
%        str2double(get(hObject,'String')) returns contents of stim_axis as a double


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



function stim_type_Callback(hObject, eventdata, handles)
% hObject    handle to stim_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.params.stim_type = get(hObject,'String');
[handles] = update_seg_filename(hObject, eventdata, handles);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of stim_type as text
%        str2double(get(hObject,'String')) returns contents of stim_type as a double


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



function stim_intensity_Callback(hObject, eventdata, handles)
% hObject    handle to stim_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.params.stim_intensity = get(hObject,'String');
[handles] = update_seg_filename(hObject, eventdata, handles);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of stim_intensity as text
%        str2double(get(hObject,'String')) returns contents of stim_intensity as a double


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


function [handles] = update_seg_filename(hObject, eventdata, handles)

handles.params.segment_filename = [handles.params.subj_id '-' handles.params.date '-' handles.params.dev_name '-' handles.params.stim_axis '-' handles.params.stim_type '-' handles.params.stim_intensity '.mat'];

set(handles.seg_filename,'String',handles.params.segment_filename);


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in plot_MPUData.
function plot_MPUData_Callback(hObject, eventdata, handles)
% hObject    handle to plot_MPUData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
	handles.params.plot_MPUData = 1;
else
	handles.params.plot_MPUData = 0;
end

% Update plots!
plot_segment_data(hObject, eventdata, handles)

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of plot_MPUData


% --- Executes on button press in plot_MVIGPIO.
function plot_MVIGPIO_Callback(hObject, eventdata, handles)
% hObject    handle to plot_MVIGPIO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
	handles.params.plot_MVIGPIO = 1;
else
	handles.params.plot_MVIGPIO = 0;
end

% Update plots!
plot_segment_data(hObject, eventdata, handles)

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of plot_MVIGPIO


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
plot_segment_data(hObject, eventdata, handles)

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of plot_LEData


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
plot_segment_data(hObject, eventdata, handles)

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of plot_REData



function gpio_mult_Callback(hObject, eventdata, handles)
% hObject    handle to gpio_mult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input = str2double(get(hObject,'String'));
handles.params.gpio_mult = input;

plot_segment_data(hObject, eventdata, handles)

guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of gpio_mult as text
%        str2double(get(hObject,'String')) returns contents of gpio_mult as a double


% --- Executes during object creation, after setting all properties.
function gpio_mult_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gpio_mult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in labdev_goggleID.
function labdev_goggleID_Callback(hObject, eventdata, handles)
% hObject    handle to labdev_goggleID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index_selected = get(hObject,'Value');

handles.params.goggleID = index_selected;

guidata(hObject,handles)
% Hints: contents = cellstr(get(hObject,'String')) returns labdev_goggleID contents as cell array
%        contents{get(hObject,'Value')} returns selected item from labdev_goggleID


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



function Yaxis_Rot_Theta_Callback(hObject, eventdata, handles)
% hObject    handle to Yaxis_Rot_Theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Yaxis_MPU_Rot_theta = str2double(get(hObject,'String'));
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of Yaxis_Rot_Theta as text
%        str2double(get(hObject,'String')) returns contents of Yaxis_Rot_Theta as a double


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



function Zaxis_Rot_Theta_Callback(hObject, eventdata, handles)
% hObject    handle to Zaxis_Rot_Theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Zaxis_MPU_Rot_theta = str2double(get(hObject,'String'));
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of Zaxis_Rot_Theta as text
%        str2double(get(hObject,'String')) returns contents of Zaxis_Rot_Theta as a double


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
