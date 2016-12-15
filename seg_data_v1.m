function varargout = seg_data_v1(varargin)
% SEG_DATA_V1 MATLAB code for seg_data_v1.fig
%      SEG_DATA_V1, by itself, creates a new SEG_DATA_V1 or raises the existing
%      singleton*.
%
%      H = SEG_DATA_V1 returns the handle to a new SEG_DATA_V1 or the handle to
%      the existing singleton*.
%
%      SEG_DATA_V1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEG_DATA_V1.M with the given input arguments.
%
%      SEG_DATA_V1('Property','Value',...) creates a new SEG_DATA_V1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before seg_data_v1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to seg_data_v1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help seg_data_v1

% Last Modified by GUIDE v2.5 12-Sep-2016 00:57:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @seg_data_v1_OpeningFcn, ...
                   'gui_OutputFcn',  @seg_data_v1_OutputFcn, ...
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


% --- Executes just before seg_data_v1 is made visible.
function seg_data_v1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to seg_data_v1 (see VARARGIN)

% Choose default command line output for seg_data_v1
handles.output = hObject;

handles.params.subj_id = '';
handles.params.date = '';
handles.params.dev_name = '';
handles.params.stim_axis = '';
handles.params.stim_type = '';
handles.params.stim_intensity = '';

handles.params.system_code = 1;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes seg_data_v1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = seg_data_v1_OutputFcn(hObject, eventdata, handles) 
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

% Ask user to 
uiwait(msgbox('Please align the vertical line of the crosshair with the starting point of the stimulus','Segment Eye Movement Data'));
[x1,y1] = ginput(1);
uiwait(msgbox('Please align the vertical line of the crosshair with the ending point of the stimulus','Segment Eye Movement Data'));
[x2,y2] = ginput(1);
time_cutout_s = [x1 ; x2];

%
t1_cutout_eye = find(handles.Data.time >= time_cutout_s(1,1));
t2_cutout_eye = find(handles.Data.time >= time_cutout_s(2,1));
i_start_eye = t1_cutout_eye(1);
i_end_eye = t2_cutout_eye(1);

t1_cutout_head = find(handles.Data.Time_Head_Sensor >= time_cutout_s(1,1));
t2_cutout_head = find(handles.Data.Time_Head_Sensor >= time_cutout_s(2,1));
i_start_head = t1_cutout_head(1);
i_end_head = t2_cutout_head(1);

Time_Eye = handles.Data.time(i_start_eye:i_end_eye);

Torsion_LE_Position = handles.Data.TposLE(i_start_eye:i_end_eye);
Vertical_LE_Position = handles.Data.VposLE(i_start_eye:i_end_eye);
Horizontal_LE_Position = handles.Data.HposLE(i_start_eye:i_end_eye);
Torsion_RE_Position = handles.Data.TposRE(i_start_eye:i_end_eye);
Vertical_RE_Position = handles.Data.VposRE(i_start_eye:i_end_eye);
Horizontal_RE_Position = handles.Data.HposRE(i_start_eye:i_end_eye);

Torsion_LE_Velocity = handles.Data.Axis1LeftEyeVel(i_start_eye:i_end_eye);
Vertical_LE_Velocity = handles.Data.Axis2LeftEyeVel(i_start_eye:i_end_eye);
Horizontal_LE_Velocity = handles.Data.Axis3LeftEyeVel(i_start_eye:i_end_eye);
Torsion_RE_Velocity = handles.Data.Axis1RightEyeVel(i_start_eye:i_end_eye);
Vertical_RE_Velocity = handles.Data.Axis2RightEyeVel(i_start_eye:i_end_eye);
Horizontal_RE_Velocity = handles.Data.Axis3RightEyeVel(i_start_eye:i_end_eye);
Time_Head = handles.Data.Time_Head_Sensor(i_start_head:i_end_head);
Torsion_Head_Velocity = handles.Data.Axis1HeadVel(i_start_head:i_end_head);
Vertical_Head_Velocity = handles.Data.Axis2HeadVel(i_start_head:i_end_head);
Horizontal_Head_Velocity = handles.Data.Axis3HeadVel(i_start_head:i_end_head);

Stimulus = handles.Data.Stim(i_start_eye:i_end_eye)';

fname_save = handles.params.segment_filename;

folder_name = uigetdir;

cd(folder_name)

% Reset and plot segment
axes(handles.data_plot)
cla reset

plot(handles.data_plot,Time_Head,Torsion_Head_Velocity,'color',[1 0.65 0])
hold on
plot(handles.data_plot,Time_Head,Vertical_Head_Velocity,'color',[0.55 0.27 0.07])
plot(handles.data_plot,Time_Head,Horizontal_Head_Velocity,'color','r')
plot(handles.data_plot,Time_Eye,Stimulus,'color','k')

xlabel('Time [s]')
ylabel('stimulus Amplitude')


save(fname_save,'Time_Eye','Torsion_LE_Position','Vertical_LE_Position', ...
'Horizontal_LE_Position', 'Torsion_RE_Position', 'Vertical_RE_Position',...
'Horizontal_RE_Position', 'Torsion_LE_Velocity', 'Vertical_LE_Velocity',...
'Horizontal_LE_Velocity', 'Torsion_RE_Velocity', 'Vertical_RE_Velocity',...
'Horizontal_RE_Velocity', 'Time_Head', 'Torsion_Head_Velocity',...
'Vertical_Head_Velocity', 'Horizontal_Head_Velocity', 'Stimulus')

guidata(hObject,handles)

% --- Executes on button press in save_segment.
function save_segment_Callback(hObject, eventdata, handles)
% hObject    handle to save_segment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in load_raw.
function load_raw_Callback(hObject, eventdata, handles)
% hObject    handle to load_raw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Prompt user for experimental file


switch handles.params.system_code
    
    case 1 % Labyrinth Devices 3D VOG
        
        
        
        [FileName,PathName,FilterIndex] = uigetfile('*.txt','Please choose the experimental batch spreadsheet for analysis');
        
        set(handles.raw_name,'String',FileName);
        
        handles.params.raw_name = [PathName FileName];
        
        % This code was taken from the ''Analyze_VOG_Head_and_Eye_Data_Single_Plot.m'' from Mehdi Rahman
        
        gyroscale = 1;
        
        phi_eye_correction = 0;
        phi = 170;
        
        % These are the column indices of the relevant parameters saved to file
        % NOTE! MVI001R019 Pre-Op data was acquired without the GPIO line,
        % and thus all of the follwing indices are decremented by 1.
        HLeftIndex = 40;
        VLeftIndex = 41;
        TLeftIndex = 42;
        HRightIndex = 43;
        VRightIndex = 44;
        TRightIndex = 45;
        
        % Patient System
        XvelHeadOffset = 2.13;
        YvelHeadOffset = -1.36;
        ZvelHeadOffset = -1.03;
        
        % rotation of PCB 150 degrees about y-axis
        Rotation_Y = [
            cosd(phi) 0   sind(phi);
            0   1   0;
            -sind(phi)    0   cosd(phi)
            ];
        
        Rotation_Head = Rotation_Y;
        
        Pitch_Eye_Correction = [
            cosd(phi_eye_correction) 0   sind(phi_eye_correction);
            0   1   0;
            -sind(phi_eye_correction)    0   cosd(phi_eye_correction)
            ];
        
        Rotation_Eye = Pitch_Eye_Correction;
        
        
        % Load Data
        data = dlmread(handles.params.raw_name,' ',1,0);
        
        % Generate time vector
        count = 0;
        for i = 2:length(data)-1
            time(i) = (data(i,2)+128*count-data(1,2));
            if (data(i+1,2)-data(i,2)) < 0
                count = count + 1;
            end
        end
        
        % load eye positions in degrees
        theta_LE_deg = data(:,HLeftIndex);
        phi_LE_deg = data(:,VLeftIndex);
        psi_LE_deg = data(:,TLeftIndex);
        theta_RE_deg = data(:,HRightIndex);
        phi_RE_deg = data(:,VRightIndex);
        psi_RE_deg = data(:,TRightIndex);
        
        %
        
        
        for i = 2:length(time)-1
            if(data(i+1,2)-data(i,2) == data(i,2)-data(i-1,2))
                dtheta_LE(i) = (theta_LE_deg(i+1) - theta_LE_deg(i-1))/(2*(time(i+1)-time(i)));
                dphi_LE(i) = (phi_LE_deg(i+1) - phi_LE_deg(i-1))/(2*(time(i+1)-time(i)));
                dpsi_LE(i) = ((psi_LE_deg(i+1) - psi_LE_deg(i-1)))/(2*(time(i+1)-time(i)));
                dtheta_RE(i) = (theta_RE_deg(i+1) - theta_RE_deg(i-1))/(2*(time(i+1)-time(i)));
                dphi_RE(i) = (phi_RE_deg(i+1) - phi_RE_deg(i-1))/(2*(time(i+1)-time(i)));
                dpsi_RE(i) = ((psi_RE_deg(i+1) - psi_RE_deg(i-1)))/(2*(time(i+1)-time(i)));
            else
                dtheta_LE(i) = ((theta_LE_deg(i+1) - theta_LE_deg(i)))/((time(i+1)-time(i)));
                dphi_LE(i) = ((phi_LE_deg(i+1) - phi_LE_deg(i)))/((time(i+1)-time(i)));
                dpsi_LE(i) = ((psi_LE_deg(i+1) - psi_LE_deg(i)))/((time(i+1)-time(i)));
                dtheta_RE(i) = ((theta_RE_deg(i+1) - theta_RE_deg(i)))/((time(i+1)-time(i)));
                dphi_RE(i) = ((phi_RE_deg(i+1) - phi_RE_deg(i)))/((time(i+1)-time(i)));
                dpsi_RE(i) = ((psi_RE_deg(i+1) - psi_RE_deg(i)))/((time(i+1)-time(i)));
            end
            
            TvelLE(i) = dpsi_LE(i)*cosd(theta_LE_deg(i))*cosd(phi_LE_deg(i)) - dphi_LE(i)*sind(theta_LE_deg(i));
            VvelLE(i) = dpsi_LE(i)*sind(theta_LE_deg(i))*cosd(phi_LE_deg(i)) + dphi_LE(i)*cosd(theta_LE_deg(i));
            HvelLE(i) = dtheta_LE(i) - dpsi_LE(i) * sind(phi_LE_deg(i));
            TvelRE(i) = dpsi_RE(i)*cosd(theta_RE_deg(i))*cosd(phi_RE_deg(i)) - dphi_RE(i)*sind(theta_RE_deg(i));
            VvelRE(i) = dpsi_RE(i)*sind(theta_RE_deg(i))*cosd(phi_RE_deg(i)) + dphi_RE(i)*cosd(theta_RE_deg(i));
            HvelRE(i) = dtheta_RE(i) - dpsi_RE(i) * sind(phi_RE_deg(i));
            
        end
        
        
        %
        StimIndex = 35;
        
        Stim_Scale_Factor = 1;
        
        Stim = Stim_Scale_Factor*data(1:length(time),StimIndex);
        
        XvelHead = data(1:length(time),30)*gyroscale + XvelHeadOffset;
        YvelHead = data(1:length(time),29)*gyroscale + YvelHeadOffset;
        ZvelHead = data(1:length(time),28)*gyroscale + ZvelHeadOffset;
        
        
        A = Rotation_Head * [XvelHead' ; YvelHead' ; ZvelHead'];
        
        Axis1VelHead = A(1,:);
        Axis2VelHead = A(2,:);
        Axis3VelHead = A(3,:);
        
        
        
        Head_Sensor_Latency = 0.047;
        
        Time_Head_Sensor = time - Head_Sensor_Latency;
        
        Axis1HeadVel = Axis1VelHead;
        Axis2HeadVel = Axis2VelHead;
        Axis3HeadVel = Axis3VelHead;
        Axis3LeftEyeVel = TvelLE;
        Axis2LeftEyeVel = VvelLE;
        Axis1LeftEyeVel = HvelLE;
        Axis3RightEyeVel = TvelRE;
        Axis2RightEyeVel = VvelRE;
        Axis1RightEyeVel = HvelRE;
        
        %         if (SCC_Plane == 'LHRH')
        %             Stimulus = Axis3HeadVel;
        %         elseif (SCC_Plane == 'RALP')
        %             Stimulus = Axis2HeadVel;
        %         elseif (SCC_Plane == 'LARP')
        %             Stimulus = Axis1HeadVel;
        %         end
        
        axes(handles.data_plot)
        cla reset
        
        plot(handles.data_plot,time,Axis1HeadVel,'color',[1 0.65 0])
        hold on
        plot(handles.data_plot,Time_Head_Sensor,Axis2HeadVel,'color',[0.55 0.27 0.07])
        plot(handles.data_plot,Time_Head_Sensor,Axis3HeadVel,'color','r')
        plot(handles.data_plot,Time_Head_Sensor,Stim,'color','k')
        
        xlabel('Time [s]')
        ylabel('stimulus Amplitude')
        
        Data.TposLE = psi_LE_deg;
        Data.VposLE = phi_LE_deg;
        Data.HposLE = theta_LE_deg;
        Data.TposRE = psi_RE_deg;
        Data.VposRE = phi_RE_deg;
        Data.HposRE = theta_RE_deg;
        Data.Axis1HeadVel = Axis1HeadVel;
        Data.Axis2HeadVel = Axis2HeadVel;
        Data.Axis3HeadVel = Axis3HeadVel;
        Data.Axis3LeftEyeVel = Axis3LeftEyeVel;
        Data.Axis2LeftEyeVel = Axis2LeftEyeVel;
        Data.Axis1LeftEyeVel = Axis1LeftEyeVel;
        Data.Axis3RightEyeVel = Axis3RightEyeVel;
        Data.Axis2RightEyeVel = Axis2RightEyeVel;
        Data.Axis1RightEyeVel = Axis1RightEyeVel;
        Data.Time_Head_Sensor = Time_Head_Sensor;
        Data.time = time;
        Data.Stim = Stim;
    otherwise

        
        
end

handles.Data = Data;

guidata(hObject,handles)

% --- Executes on selection change in eye_mov_system.
function eye_mov_system_Callback(hObject, eventdata, handles)
% hObject    handle to eye_mov_system (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

index_selected = get(hObject,'Value');

handles.params.system_code = index_selected;

display(item_selected);

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
switch handles.params.system_code
    
    case 1 % Labyrinth Devices 3D VOG
        % This code was taken from the ''Analyze_VOG_Head_and_Eye_Data_Single_Plot.m'' from Mehdi Rahman
        
        gyroscale = 1;
        
        phi_eye_correction = 0;
        phi = 170;
        
        % These are the column indices of the relevant parameters saved to file
        % NOTE! MVI001R019 Pre-Op data was acquired without the GPIO line,
        % and thus all of the follwing indices are decremented by 1.
        HLeftIndex = 40;
        VLeftIndex = 41;
        TLeftIndex = 42;
        HRightIndex = 43;
        VRightIndex = 44;
        TRightIndex = 45;
        
        % Patient System
        XvelHeadOffset = 2.13;
        YvelHeadOffset = -1.36;
        ZvelHeadOffset = -1.03;
        
        % rotation of PCB 150 degrees about y-axis
        Rotation_Y = [
            cosd(phi) 0   sind(phi);
            0   1   0;
            -sind(phi)    0   cosd(phi)
            ];
        
        Rotation_Head = Rotation_Y;
        
        Pitch_Eye_Correction = [
            cosd(phi_eye_correction) 0   sind(phi_eye_correction);
            0   1   0;
            -sind(phi_eye_correction)    0   cosd(phi_eye_correction)
            ];
        
        Rotation_Eye = Pitch_Eye_Correction;
        
        
        % Load Data
        data = dlmread(handles.params.raw_name,' ',1,0);
        
        % Generate time vector
        count = 0;
        for i = 2:length(data)-1
            time(i) = (data(i,2)+128*count-data(1,2));
            if (data(i+1,2)-data(i,2)) < 0
                count = count + 1;
            end
        end
        
        % load eye positions in degrees
        theta_LE_deg = data(:,HLeftIndex);
        phi_LE_deg = data(:,VLeftIndex);
        psi_LE_deg = data(:,TLeftIndex);
        theta_RE_deg = data(:,HRightIndex);
        phi_RE_deg = data(:,VRightIndex);
        psi_RE_deg = data(:,TRightIndex);
        
        %
        
        
        for i = 2:length(time)-1
            if(data(i+1,2)-data(i,2) == data(i,2)-data(i-1,2))
                dtheta_LE(i) = (theta_LE_deg(i+1) - theta_LE_deg(i-1))/(2*(time(i+1)-time(i)));
                dphi_LE(i) = (phi_LE_deg(i+1) - phi_LE_deg(i-1))/(2*(time(i+1)-time(i)));
                dpsi_LE(i) = ((psi_LE_deg(i+1) - psi_LE_deg(i-1)))/(2*(time(i+1)-time(i)));
                dtheta_RE(i) = (theta_RE_deg(i+1) - theta_RE_deg(i-1))/(2*(time(i+1)-time(i)));
                dphi_RE(i) = (phi_RE_deg(i+1) - phi_RE_deg(i-1))/(2*(time(i+1)-time(i)));
                dpsi_RE(i) = ((psi_RE_deg(i+1) - psi_RE_deg(i-1)))/(2*(time(i+1)-time(i)));
            else
                dtheta_LE(i) = ((theta_LE_deg(i+1) - theta_LE_deg(i)))/((time(i+1)-time(i)));
                dphi_LE(i) = ((phi_LE_deg(i+1) - phi_LE_deg(i)))/((time(i+1)-time(i)));
                dpsi_LE(i) = ((psi_LE_deg(i+1) - psi_LE_deg(i)))/((time(i+1)-time(i)));
                dtheta_RE(i) = ((theta_RE_deg(i+1) - theta_RE_deg(i)))/((time(i+1)-time(i)));
                dphi_RE(i) = ((phi_RE_deg(i+1) - phi_RE_deg(i)))/((time(i+1)-time(i)));
                dpsi_RE(i) = ((psi_RE_deg(i+1) - psi_RE_deg(i)))/((time(i+1)-time(i)));
            end
            
            TvelLE(i) = dpsi_LE(i)*cosd(theta_LE_deg(i))*cosd(phi_LE_deg(i)) - dphi_LE(i)*sind(theta_LE_deg(i));
            VvelLE(i) = dpsi_LE(i)*sind(theta_LE_deg(i))*cosd(phi_LE_deg(i)) + dphi_LE(i)*cosd(theta_LE_deg(i));
            HvelLE(i) = dtheta_LE(i) - dpsi_LE(i) * sind(phi_LE_deg(i));
            TvelRE(i) = dpsi_RE(i)*cosd(theta_RE_deg(i))*cosd(phi_RE_deg(i)) - dphi_RE(i)*sind(theta_RE_deg(i));
            VvelRE(i) = dpsi_RE(i)*sind(theta_RE_deg(i))*cosd(phi_RE_deg(i)) + dphi_RE(i)*cosd(theta_RE_deg(i));
            HvelRE(i) = dtheta_RE(i) - dpsi_RE(i) * sind(phi_RE_deg(i));
            
        end
        
        
        %
        StimIndex = 35;
        
        Stim_Scale_Factor = 1;
        
        Stim = Stim_Scale_Factor*data(1:length(time),StimIndex);
        
        XvelHead = data(1:length(time),30)*gyroscale + XvelHeadOffset;
        YvelHead = data(1:length(time),29)*gyroscale + YvelHeadOffset;
        ZvelHead = data(1:length(time),28)*gyroscale + ZvelHeadOffset;
        
        
        A = Rotation_Head * [XvelHead' ; YvelHead' ; ZvelHead'];
        
        Axis1VelHead = A(1,:);
        Axis2VelHead = A(2,:);
        Axis3VelHead = A(3,:);
        
        
        
        Head_Sensor_Latency = 0.047;
        
        Time_Head_Sensor = time - Head_Sensor_Latency;
        
        Axis1HeadVel = Axis1VelHead;
        Axis2HeadVel = Axis2VelHead;
        Axis3HeadVel = Axis3VelHead;
        Axis3LeftEyeVel = TvelLE;
        Axis2LeftEyeVel = VvelLE;
        Axis1LeftEyeVel = HvelLE;
        Axis3RightEyeVel = TvelRE;
        Axis2RightEyeVel = VvelRE;
        Axis1RightEyeVel = HvelRE;
        
        %         if (SCC_Plane == 'LHRH')
        %             Stimulus = Axis3HeadVel;
        %         elseif (SCC_Plane == 'RALP')
        %             Stimulus = Axis2HeadVel;
        %         elseif (SCC_Plane == 'LARP')
        %             Stimulus = Axis1HeadVel;
        %         end
        
        axes(handles.data_plot)
        cla reset
        
        plot(handles.data_plot,time,Axis1HeadVel,'color',[1 0.65 0])
        hold on
        plot(handles.data_plot,Time_Head_Sensor,Axis2HeadVel,'color',[0.55 0.27 0.07])
        plot(handles.data_plot,Time_Head_Sensor,Axis3HeadVel,'color','r')
        plot(handles.data_plot,Time_Head_Sensor,Stim,'color','k')
        
        xlabel('Time [s]')
        ylabel('stimulus Amplitude')
        
                
        Data.TposLE = psi_LE_deg;
        Data.VposLE = phi_LE_deg;
        Data.HposLE = theta_LE_deg;
        Data.TposRE = psi_RE_deg;
        Data.VposRE = phi_RE_deg;
        Data.HposRE = theta_RE_deg;
        Data.Axis1HeadVel = Axis1HeadVel;
        Data.Axis2HeadVel = Axis2HeadVel;
        Data.Axis3HeadVel = Axis3HeadVel;
        Data.Axis3LeftEyeVel = Axis3LeftEyeVel;
        Data.Axis2LeftEyeVel = Axis2LeftEyeVel;
        Data.Axis1LeftEyeVel = Axis1LeftEyeVel;
        Data.Axis3RightEyeVel = Axis3RightEyeVel;
        Data.Axis2RightEyeVel = Axis2RightEyeVel;
        Data.Axis1RightEyeVel = Axis1RightEyeVel;
        Data.Time_Head_Sensor = Time_Head_Sensor;
        Data.time = time;
        Data.Stim = Stim;
    otherwise
        
        
        
end

handles.Data = Data;

guidata(hObject,handles)

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
