function varargout = voma__convert_raw2qpr(varargin)
% VOMA__CONVERT_RAW2QPR MATLAB code for voma__convert_raw2qpr.fig
%      VOMA__CONVERT_RAW2QPR, by itself, creates a new VOMA__CONVERT_RAW2QPR or raises the existing
%      singleton*.
%
%      H = VOMA__CONVERT_RAW2QPR returns the handle to a new VOMA__CONVERT_RAW2QPR or the handle to
%      the existing singleton*.
%
%      VOMA__CONVERT_RAW2QPR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VOMA__CONVERT_RAW2QPR.M with the given input arguments.
%
%      VOMA__CONVERT_RAW2QPR('Property','Value',...) creates a new VOMA__CONVERT_RAW2QPR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before voma__convert_raw2qpr_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to voma__convert_raw2qpr_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
%       The VOMA version of 'convert_raw2qpr' was adapted from
%       'convert_raw2qpr_v5'
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help voma__convert_Raw2qpr

% Last Modified by GUIDE v2.5 03-Jul-2017 23:10:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @voma__convert_raw2qpr_OpeningFcn, ...
    'gui_OutputFcn',  @voma__convert_raw2qpr_OutputFcn, ...
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


% --- Executes just before voma__convert_raw2qpr is made visible.
function voma__convert_raw2qpr_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to voma__convert_raw2qpr (see VARARGIN)

% Choose default command line output for voma__convert_raw2qpr
handles.output = hObject;

handles.params.system_config = 1;

handles.params.file_format = 1;

handles.params.lasker_stim_chan = 1;

handles.params.R710_mky_chair_orientation = 1;

handles.params.goggleID = 1;

handles.params.vog_data_acq_version = 1;

handles.params.interp_ldvog_mpu = true;

handles.Yaxis_MPU_Rot_theta = str2double(get(handles.Yaxis_Rot_Theta,'String'));

if ispc
    handles.ispc.flag = true;
    handles.ispc.slash = '\';
else
    handles.ispc.flag = false;
    handles.ispc.slash = '/';
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes voma__convert_raw2qpr wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = voma__convert_raw2qpr_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load_excel_sheet.
function load_excel_sheet_Callback(hObject, eventdata, handles)
% hObject    handle to load_excel_sheet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Prompt user for experimental file
[FileName,PathName,FilterIndex] = uigetfile('*.xlsx','Please choose the experimental batch spreadsheet for analysis');

if FileName ~= 0
    handles.params.xlsname = FileName;
    handles.params.xlspath = PathName;
    
    if handles.ispc.flag
        [status,sheets,xlFormat] = xlsfinfo([PathName,FileName]);
    else
        A = importdata([PathName,FileName]);
        names = fieldnames(A.textdata);
        sheets = strrep(names,'0x2D','-')';
    end
    
    set(handles.excel_sheet_list,'String',sheets);
    set(handles.excel_sheet_text,'String',FileName);
    
    % Assume the user is loading the first sheet
    [num1,txt1,raw1] = xlsread([handles.params.xlspath handles.params.xlsname],1);
    
    handles.params.raw = raw1;
end

guidata(hObject,handles)

% --- Executes on selection change in system_config.
function system_config_Callback(hObject, eventdata, handles)
% hObject    handle to system_config (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


index_selected = get(hObject,'Value');


switch index_selected
    case 1 % Ross 710 - Lasker System
        set(handles.lasker_stim_chan,'Visible','On')
        
        set(handles.rawfile_opt1,'Visible','On')
        set(handles.rawfile_opt1,'String','VORDAQ-Only Files ')
        set(handles.rawfile_opt2,'Visible','On')
        set(handles.rawfile_opt2,'String','VORDAQ + CED Files')
        set(handles.rawfile_opt3,'Visible','On')
        set(handles.rawfile_opt3,'String','CED-Only Files')
        set(handles.lasker_panel,'Visible','On')
        set(handles.labdev_panel,'Visible','Off')
        set(handles.coil_sys_gen_panel,'Visible','On')
        
        set(handles.rawfile_opt1,'Value',1)
        handles.params.file_format = 1;
    case 2 % McGill System 1 [2D]
        set(handles.lasker_stim_chan,'Visible','Off')
        
        set(handles.rawfile_opt1,'Visible','On')
        set(handles.rawfile_opt1,'String','*.NEV & *.NS2 Files')
        set(handles.rawfile_opt2,'Visible','Off')
        set(handles.rawfile_opt3,'Visible','Off')
        set(handles.lasker_panel,'Visible','Off')
        set(handles.labdev_panel,'Visible','Off')
        set(handles.coil_sys_gen_panel,'Visible','Off')
        
        set(handles.rawfile_opt1,'Value',1)
        handles.params.file_format = 1;
    case 3 % Lab. Dev. VOG [3D]
        set(handles.lasker_stim_chan,'Visible','Off')
        
        set(handles.rawfile_opt1,'Visible','On')
        set(handles.rawfile_opt1,'String','*.txt Files')
        set(handles.rawfile_opt2,'Visible','Off')
        set(handles.rawfile_opt3,'Visible','Off')
        set(handles.lasker_panel,'Visible','Off')
        set(handles.labdev_panel,'Visible','On')
        set(handles.coil_sys_gen_panel,'Visible','Off')
        
        set(handles.rawfile_opt1,'Value',1)
        handles.params.file_format = 1;
    case 4 % VNEL Digital Coil System [3D]
        set(handles.lasker_stim_chan,'Visible','Off')
        
        set(handles.rawfile_opt1,'Visible','On')
        set(handles.rawfile_opt1,'String','*.coil & *_mpudata.txt Files')
        set(handles.rawfile_opt2,'Visible','Off')
        set(handles.rawfile_opt3,'Visible','Off')
        set(handles.lasker_panel,'Visible','Off')
        set(handles.labdev_panel,'Visible','Off')
        set(handles.coil_sys_gen_panel,'Visible','On')
        
        set(handles.rawfile_opt1,'Value',1)
        handles.params.file_format = 1;
        
    case 5 % This is a case used for FIck angle data. Currently this is a kludge to analyze my Lasker System data
        % UPDATE %
        set(handles.lasker_stim_chan,'Visible','On')
        
        set(handles.rawfile_opt1,'Visible','On')
        set(handles.rawfile_opt1,'String','VORDAQ-Only Files ')
        set(handles.rawfile_opt2,'Visible','On')
        set(handles.rawfile_opt2,'String','VORDAQ + CED Files')
        set(handles.rawfile_opt3,'Visible','On')
        set(handles.rawfile_opt3,'String','CED-Only Files')
        set(handles.lasker_panel,'Visible','On')
        set(handles.labdev_panel,'Visible','Off')
        set(handles.coil_sys_gen_panel,'Visible','On')
        
        set(handles.rawfile_opt1,'Value',1)
        handles.params.file_format = 1;
end

handles.params.system_config = index_selected;

guidata(hObject,handles)
% Hints: contents = cellstr(get(hObject,'String')) returns system_config contents as cell array
%        contents{get(hObject,'Value')} returns selected item from system_config


% --- Executes during object creation, after setting all properties.
function system_config_CreateFcn(hObject, eventdata, handles)
% hObject    handle to system_config (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in raw_files_btn.
function raw_files_btn_Callback(hObject, eventdata, handles)
% hObject    handle to raw_files_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rootpath = uigetdir(pwd,'Please locate the path containing the raw data to be converted');

set(handles.raw_files_loc,'String',rootpath);

handles.params.raw_data_path = rootpath;

guidata(hObject,handles)


% --- Executes on button press in output_files_btn.
function output_files_btn_Callback(hObject, eventdata, handles)
% hObject    handle to output_files_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rootpath = uigetdir(pwd,'Please choose the location to save the output file');

set(handles.output_files_loc,'String',rootpath);

handles.params.output_data_path = rootpath;

guidata(hObject,handles)


% --- Executes on button press in field_gains_btn.
function field_gains_btn_Callback(hObject, eventdata, handles)
% hObject    handle to field_gains_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName,FilterIndex] = uigetfile('*.*', 'Please choose the file containing the field gains for the data being processed');

handles.params.fieldgain_name = FileName;
handles.params.fieldgain_path = PathName;

set(handles.field_gains_txt,'String',FileName);

guidata(hObject,handles)



% --- Executes on button press in start_conversion.
function start_conversion_Callback(hObject, eventdata, handles)
% hObject    handle to start_conversion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

save_flag = true;				 
switch handles.params.file_format
    
    case {1,2,3} % We are processing RAW files
        
        switch handles.params.system_config % This parameter indicates the eye movement recording system used for each experiment
            
            case 1 % Ross 710 - Lasker System
                filepath = handles.params.raw_data_path;
                
                
                raw = handles.params.raw;
                
                data_fldr = handles.params.raw_data_path;
                cd(data_fldr)
                
                fieldgainname = handles.params.fieldgain_name;
                delimiter = '\t';
                formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
                
                fileID = fopen(fieldgainname,'r');
                
                dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN, 'ReturnOnError', false);
                
                fclose(fileID);
                
                FieldGains = [dataArray{1:end-1}];
                
                coilzeros = [0 0 0 0 0 0 0 0 0 0 0 0];
                
                ref = 0;
                
                Fs = {1000};
                
                % filepath = 'F:\Boutros_Data_Local_Copy\MoMo\2016-06-13_RhMoMo';
                
                
                for n = 2:length(raw)
                    
                    FileName = [raw{n,18} '.' sprintf('%04d',raw{n,1})];
                    
                    switch raw{n,10}
                        
                        case 'LARP-Axis'
                            
                            switch handles.params.R710_mky_chair_orientation
                                case 1 % Ross 710, Lasker Coil System, with the animal
                                    % oriented in 'starting position #1'. The term 'starting position'
                                    % refers to the 'zero' position as defined by the Acutrol
                                    % controller.
                                    % 'starting position #1' refers to the animal seated
                                    % with its LEFT EAR facing the door of the Ross 710
                                    % monkey chamber, the BACK of the animals head facing
                                    % the tall black metal plate containing the additional
                                    % rotation joint, and the FRONT of the animals head
                                    % facing the moog room/wall containing the service
                                    % elevator. In this orientation, to align the animal's
                                    % +LARP-axis with the +Z axis of the rotator, we will
                                    % re-orient the animal/coil frame by rolling the
                                    % chair -90degrees (so the animals LEFT ear is facing
                                    % the ground) from starting position, then apply a
                                    % -45degree rotation (in HEAD-coordinates) within the
                                    % coil frame. Additionally, a correction must be made to adjust the
                                    % raw coil signals into the standard {+X,+Y,+Z} coordinate
                                    % system, since the Lasker system does not use the standard version. (see
                                    % the 'processeyemovements' code used below for
                                    % details)
                                    % The 'data_rot' code signals the angular
                                    % velocity computation to apply a
                                    % -135 deg YAW axis passive
                                    % rotation to align the '[+X,+Y,+Z}'
                                    % axes of the coils system to the
                                    % '[+X,+Y,+Z}' of the subject's head.
                                    data_rot = 4;
                                case 2 % Ross 710, Lasker Coil System, with the animal
                                    % oriented in 'starting position #2'. The term 'starting position'
                                    % refers to the 'zero' position as defined by the Acutrol
                                    % controller.
                                    % 'starting position #2' refers to the animal seated
                                    % with the BACK of its head facing the door of the Ross 710
                                    % monkey chamber, the RIGHT EAR facing
                                    % the tall black metal plate containing the additional
                                    % rotation joint, and the animal's LEFT EAR
                                    % facing the moog room/wall containing the service
                                    % elevator. In this orientation, to align the animal's
                                    % +LARP-axis with the +Z axis of the rotator, we will
                                    % re-orient the animal/coil frame by pitching the
                                    % chair -90degrees (so the BACK of the animals head is facing
                                    % the ground) from starting position, then apply a
                                    % +45degree rotation (in HEAD-coordinates) within the
                                    % coil frame. Additionally, a correction must be made to adjust the
                                    % raw coil signals into the standard {+X,+Y,+Z} coordinate
                                    % system, since the Lasker system does not use the standard version. (see
                                    % the 'processeyemovements' code used below for
                                    % details)
                                    % The 'data_rot' code signals the angular
                                    % velocity computation to apply a
                                    % -45 deg YAW axis passive
                                    % rotation to align the '[+X,+Y,+Z}'
                                    % axes of the coils system to the
                                    % '[+X,+Y,+Z}' of the subject's head.
                                    
                                    data_rot = 3;
                            end
                        case 'RALP-Axis'
                            switch handles.params.R710_mky_chair_orientation
                                case 1 % Ross 710, Lasker Coil System, with the animal
                                    % oriented in 'starting position #1'. The term 'starting position'
                                    % refers to the 'zero' position as defined by the Acutrol
                                    % controller.
                                    % 'starting position #1' refers to the animal seated
                                    % with its LEFT EAR facing the door of the Ross 710
                                    % monkey chamber, the BACK of the animals head facing
                                    % the tall black metal plate containing the additional
                                    % rotation joint, and the FRONT of the animals head
                                    % facing the moog room/wall containing the service
                                    % elevator. In this orientation, to align the animal's
                                    % +RALP-axis with the +Z axis of the rotator, we will
                                    % re-orient the animal/coil frame by rolling the
                                    % chair +90degrees (so the animals RIGHT ear is facing
                                    % the ground) from starting position, then apply a
                                    % +45degree rotation (in HEAD-coordinates) within the
                                    % coil frame. Additionally, a correction must be made to adjust the
                                    % raw coil signals into the standard {+X,+Y,+Z} coordinate
                                    % system, since the Lasker system does not use the standard version. (see
                                    % the 'processeyemovements' code used below for
                                    % details)
                                    % The 'data_rot' code signals the angular
                                    % velocity computation to apply a
                                    % -45 deg YAW axis passive
                                    % rotation to align the '[+X,+Y,+Z}'
                                    % axes of the coils system to the
                                    % '[+X,+Y,+Z}' of the subject's head.
                                    % details)
                                    data_rot = 3;
                                case 2 % Ross 710, Lasker Coil System, with the animal
                                    % oriented in 'starting position #2'. The term 'starting position'
                                    % refers to the 'zero' position as defined by the Acutrol
                                    % controller.
                                    % 'starting position #2' refers to the animal seated
                                    % with the BACK of its head facing the door of the Ross 710
                                    % monkey chamber, the RIGHT EAR facing
                                    % the tall black metal plate containing the additional
                                    % rotation joint, and the animal's LEFT EAR
                                    % facing the moog room/wall containing the service
                                    % elevator. In this orientation, to align the animal's
                                    % +RALP-axis with the +Z axis of the rotator, we will
                                    % re-orient the animal/coil frame by pitching the
                                    % chair -90degrees (so the BACK of the animals head is facing
                                    % the ground) from starting position, then apply a
                                    % -45degree rotation (in HEAD-coordinates) within the
                                    % coil frame. Additionally, a correction must be made to adjust the
                                    % raw coil signals into the standard {+X,+Y,+Z} coordinate
                                    % system, since the Lasker system does not use the standard version. (see
                                    % the 'processeyemovements' code used below for
                                    % details)
                                    % The 'data_rot' code signals the angular
                                    % velocity computation to apply a
                                    % -135 deg YAW axis passive
                                    % rotation to align the '[+X,+Y,+Z}'
                                    % axes of the coils system to the
                                    % '[+X,+Y,+Z}' of the subject's head.
                                    data_rot = 4;
                            end
                        case 'LHRH-Axis'
                            switch handles.params.R710_mky_chair_orientation
                                case {1,2} % For both of these cases, the animal's +LHRH
                                    % axis should be aligned with the +Z/rotation axis of
                                    % the motor.
                                    % Additionally, a correction must be made to adjust the
                                    % raw coil signals into the standard {+X,+Y,+Z} (see
                                    % the 'processeyemovements' code used below for
                                    % details)
                                    data_rot = 2;
                            end
                        otherwise
                            data_rot = 2;
                    end
                    
                    
                    switch  handles.params.file_format
                        case 1
                            DAQ_code = 1; % This is the code used in the 'processeyemovements' code to indicate we are dealing with a file that was only recorded using VORDAQ system
                        case 2
                            % I need to add the DAQ alignment code here
                        case 3
                            DAQ_code = 3; % This is the code used in the 'processeyemovements' code to indicate we are dealing with a file that was only recorded using a CED system
                    end
                    
                    [Data] = voma__processeyemovements(filepath,filename,FieldGains,coilzeros,ref,data_rot,DAQ_code);
                    
                    Fs{n-1} = {Data.Fs};
                    
                    Eye_t{n-1} = {[0:length(Data.lz)-1]/Fs{n-1}{1}};
                    Stim_t{n-1} = {Eye_t{n-1}};
                    
                    Data_LE_Pos_X{n-1} = {Data.LE_Pos_X};
                    Data_LE_Pos_Y{n-1} = {Data.LE_Pos_Y};
                    Data_LE_Pos_Z{n-1} = {Data.LE_Pos_Z};
                    
                    Data_RE_Pos_X{n-1} = {Data.RE_Pos_X};
                    Data_RE_Pos_Y{n-1} = {Data.RE_Pos_Y};
                    Data_RE_Pos_Z{n-1} = {Data.RE_Pos_Z};
                    
                    Data_LE_Vel_X{n-1} = {Data.LE_Vel_X};
                    Data_LE_Vel_Y{n-1} = {Data.LE_Vel_Y};
                    Data_LE_Vel_LARP{n-1} = {Data.LE_Vel_LARP};
                    Data_LE_Vel_RALP{n-1} = {Data.LE_Vel_RALP};
                    Data_LE_Vel_Z{n-1} = {Data.LE_Vel_Z};
                    
                    Data_RE_Vel_X{n-1} = {Data.RE_Vel_X};
                    Data_RE_Vel_Y{n-1} = {Data.RE_Vel_Y};
                    Data_RE_Vel_LARP{n-1} = {Data.RE_Vel_LARP};
                    Data_RE_Vel_RALP{n-1} = {Data.RE_Vel_RALP};
                    Data_RE_Vel_Z{n-1} = {Data.RE_Vel_Z};
                    
                    switch handles.params.lasker_stim_chan
                        case 1
                            Stimulus{n-1} = {Data.angvel};
                        case 2
                            angvel_calc_temp = gradient(Data.angpos)*Data.Fs;
                    end
                    
                    useradjust = 'n';
                    
                    if ~isempty(strfind(raw{n,9}, 'Velocity Step'))
                        
                        if str2num(raw{n,13})>0
                            polarity = 1;
                        else
                            polarity = 2;
                        end
                        
                        %                 [stim_ind_temp] = find_stim_ind_v4(Stimulus{n-1}{1},Fs{n-1}{1},Time{n-1}{1},useradjust,polarity);
                        [stim_ind_temp] = [];
                        if isempty([stim_ind_temp])
                            stim_ind{n-1} = {0};
                        else
                            stimdur_samp = raw{n,12}*Fs{n-1}{1};
                            stim_ind_temp(:,2) = stim_ind_temp(:,2)+stimdur_samp;
                            stim_ind{n-1} = {stim_ind_temp(:,:)};
                        end
                    else
                        polarity = 1;
                        %                 [stim_ind_temp] = find_stim_ind_v5(Stimulus{n-1}{1},Fs{n-1}{1},Time{n-1}{1},useradjust,polarity,0.07);
                        [stim_ind_temp] = [];
                        if isempty([stim_ind_temp])
                            stim_ind{n-1} = {0};
                        else
                            stim_ind{n-1} = {stim_ind_temp(:,:)};
                        end
                        
                        
                    end
                    
                    Filenames{n-1} = {FileName};
                    
                    Parameters(n-1).Stim_Info.Stim_Type = raw(n,9);
                    Parameters(n-1).Stim_Info.ModCanal = raw(n,10);
                    Parameters(n-1).Stim_Info.Freq = raw(n,12);
                    Parameters(n-1).Stim_Info.Max_Vel = raw(n,13);
                    Parameters(n-1).Stim_Info.Cycles = raw(n,15);
                    Parameters(n-1).Stim_Info.Notes = raw(n,17);
                    Parameters(n-1).Mapping.Type = raw(n,11);
                    Parameters(n-1).Mapping.Compression = raw(n,6);
                    Parameters(n-1).Mapping.Max_PR = raw(n,7);
                    Parameters(n-1).Mapping.Baseline = raw(n,8);
                    
                    switch  handles.params.file_format
                        case 1
                            Parameters(n-1).DAQ = 'Lasker_VORDAQ';
                            Parameters(n-1).DAQ_code = 1;
                        case 2
                            Parameters(n-1).DAQ = 'Lasker_VORDAQ+CED';
                            Parameters(n-1).DAQ_code = 2;
                        case 3
                            Parameters(n-1).DAQ = 'Lasker_CED';
                            Parameters(n-1).DAQ_code = 3;
                    end
                    
                end
                
                
                [Data_QPR] = voma__qpr_data_convert(Fs,Stimulus,Stim_t,stim_ind,Data_LE_Pos_X,Data_LE_Pos_Y,Data_LE_Pos_Z,Data_RE_Pos_X,Data_RE_Pos_Y,Data_RE_Pos_Z,Data_LE_Vel_X,Data_LE_Vel_Y,Data_LE_Vel_LARP,Data_LE_Vel_RALP,Data_LE_Vel_Z,Data_RE_Vel_X,Data_RE_Vel_Y,Data_RE_Vel_LARP,Data_RE_Vel_RALP,Data_RE_Vel_Z,Eye_t,Filenames,Parameters);
                
            case 2 % McGill 2D Recording System / Blackrock
                
                raw = handles.params.raw;
                
                Fs_eye = 1000;
                Fs_pulse = 30000;
                
                data_fldr = handles.params.raw_data_path;
                cd(data_fldr)
                
                for n = 2:length(raw)
                    
                    
                    
                    FileName = [raw{n,18} sprintf('%03d',raw{n,1})];
                    myData = openNSx([FileName '.ns2'],'read');
                    %     myData = openNSx('read');
                    
                    myDataEv = openNEV([FileName '.nev'],'read');
                    H1_chan = strmatch('ghpos',{myData.ElectrodesInfo.Label},'exact');
                    V1_chan = strmatch('gvpos',{myData.ElectrodesInfo.Label},'exact');
                    T1_chan = strmatch('T1',{myData.ElectrodesInfo.Label},'exact');
                    H2_chan = strmatch('hhpos',{myData.ElectrodesInfo.Label},'exact');
                    V2_chan = strmatch('hvpos',{myData.ElectrodesInfo.Label},'exact');
                    T2_chan = strmatch('T2',{myData.ElectrodesInfo.Label},'exact');
                    
                    VelCmd_chan = strmatch('Table (cmd)',{myData.ElectrodesInfo.Label},'exact');
                    Vel_chan = strmatch('tablev',{myData.ElectrodesInfo.Label},'exact');
                    
                    ADC2Deg = 622;
                    ADC_offset = 400;
                    TableVel2DPS = 60;
                    TableVelCmd2DPS = 180;
                    
                    H1 = double(myData.Data(H1_chan,:)); % i.e., Gaze Box, Horiz. Output
                    V1 = double(myData.Data(V1_chan,:)); % i.e., Gaze Box, Vert. Output
                    T1 = double(myData.Data(T1_chan,:)); % i.e., Torsion/Torsion Box, 'Torsion 1' Output
                    H2 = double(myData.Data(H2_chan,:)); % i.e., Head Box, Horiz. Output
                    V2 = double(myData.Data(V2_chan,:)); % i.e., Head Box, Vert. Output
                    T2 = double(myData.Data(T2_chan,:)); % i.e., Torsion/Torsion Box, 'Torsion 2' Output
                    
                    VelCmd = double(myData.Data(VelCmd_chan,:));
                    Vel = double(myData.Data(Vel_chan,:));
                    
                    try
                        PTimes = double(myDataEv.Data.Spikes.TimeStamp)*(1/Fs_pulse);
                        PRate = 1./diff(PTimes);
                        PRate_t = (PTimes(1:end-1) + PTimes(2:end))/2;
                        
                    catch
                        PRate = [];
                    end
                    
                    Fs{n-1} = {Fs_eye};
                    
                    
                    if ~isempty(strfind(raw{n,9}, 'Motor Sine'))
                        
                        H1 = (H1+ADC_offset)/ADC2Deg;
                        V1 = (V1+ADC_offset)/ADC2Deg;
                        % According to Omid Zobeiri from the Cullen lab:
                        % "
                        % Hi Peter,
                        %
                        % For the coil signal, if it's calibrated with REX (that means REX window shows the angles in degrees), there is and offset and calibration gain as follows:
                        %
                        % Gaze_degrees_leftward=(Gaze_blackrock+400)/622;
                        %
                        % Note that our coil signals are flipped which means positive=leftward.
                        %
                        % Gaze_degrees_rightward=-Gaze_degrees_leftward;
                        % For Table command the calibration is as follows:
                        %
                        % Table_V_(degrees/sec)=(Table_CMD_balckrock+400)/180;
                        %
                        % and here positive =rightward
                        %
                        % also note that the Table_CMD in velocity and coil signal is position so you need to differentiate the Gaze data with regard to the sampling frequency which is 1000;
                        %
                        % After these calibrations you can calculate the eye velocity with the equation you mentioned:
                        %
                        % eye_velocity=gaze_velocity-head_velocity;
                        %
                        % "
                        %
                        % To conform to our lab's right-hand-rule convention, I will leave
                        % the polarity of the H-signal in its raw state (Positive =
                        % Leftward), and flip the vleocity comand signal to match it)
                        Stimulus{n-1} = {-(VelCmd+ADC_offset)/TableVelCmd2DPS};
                        
                        
                        H1_vel = gradient(H1)*Fs{n-1}{1};
                        V1_vel = gradient(V1)*Fs{n-1}{1};
                        %     H1_vel = gradient(H1/ADC2Deg)*Fs_eye;
                        %     V1_vel = gradient(V1/ADC2Deg)*Fs_eye;
                        %
                        %     Gaze = H1_vel - Vel;
                        
                        
                        Time{n-1} = {[0:length(H1)-1]/Fs_eye};
                        
                        
                        Data_l{n-1} = {zeros(1,length(H1_vel))};
                        
                        Data_r{n-1} = {V1_vel};
                        
                        Data_z{n-1} = {H1_vel - Stimulus{n-1}{1}};
                        
                        if ~isempty(strfind(raw{n,9}, 'Velocity Step'))
                            
                            if str2num(raw{n,13})>0
                                polarity = 1;
                            else
                                polarity = 2;
                            end
                            
                            [stim_ind_temp] = voma__find_stim_ind(Stimulus{n-1}{1},Fs{n-1}{1},Time{n-1}{1},useradjust,polarity);
                            
                            stimdur_samp = raw{n,12}*Fs{n-1}{1};
                            stim_ind_temp(:,2) = stim_ind_temp(:,2)+stimdur_samp;
                            stim_ind{n-1} = {stim_ind_temp(:,:)};
                        else
                            [stim_ind_temp] = voma__find_stim_ind(Stimulus{n-1}{1},Fs{n-1}{1},Time{n-1}{1},useradjust);
                            stim_ind{n-1} = {stim_ind_temp(:,:)};
                        end
                        
                    else
                        H1 = (H1+ADC_offset)/ADC2Deg;
                        V1 = (V1+ADC_offset)/ADC2Deg;
                        
                        H1_vel = gradient(H1)*Fs{n-1}{1};
                        V1_vel = gradient(V1)*Fs{n-1}{1};
                        Data_l{n-1} = {zeros(1,length(H1_vel))};
                        
                        Data_r{n-1} = {V1_vel};
                        
                        Data_z{n-1} = {H1_vel};
                        
                        Time{n-1} = {[0:length(H1)-1]/Fs_eye};
                        
                        
                        if ~isempty(PRate)
                            Stimulus{n-1} = {interp1(PRate_t,PRate,Time{n-1}{1})};
                        else
                            Stimulus{n-1} = {zeros(1,length(H1))};
                        end
                        
                        useradjust = 'y';
                        
                        
                        if ~isempty(strfind(raw{n,9}, 'Velocity Step'))
                            
                            if isnumeric(raw{n,13})
                                raw{n,13} = num2str(raw{n,13});
                            end
                            
                            if str2num(raw{n,13})>=0
                                polarity = 1;
                            else
                                polarity = 2;
                            end
                            
                            [stim_ind_temp] = voma__find_stim_ind(Stimulus{n-1}{1},Fs{n-1}{1},Time{n-1}{1},useradjust,polarity);
                            
                            stimdur_samp = raw{n,12}*Fs{n-1}{1};
                            stim_ind_temp(:,2) = stim_ind_temp(:,2)+stimdur_samp;
                            stim_ind{n-1} = {stim_ind_temp(:,:)};
                        else
                            [stim_ind_temp] = voma__find_stim_ind(Stimulus{n-1}{1},Fs{n-1}{1},Time{n-1}{1},useradjust);
                            stim_ind{n-1} = {stim_ind_temp(:,:)};
                        end
                        
                    end
                    
                    Fs{n-1} = {Data.Fs};
                    
                    Time{n-1} = {[0:length(Data.lz)-1]/Fs{n-1}{1}};
                    
                    Data_l_l{n-1} = {Data.ll};
                    Data_l_r{n-1} = {Data.lr};
                    Data_l_z{n-1} = {Data.lz};
                    
                    Data_r_l{n-1} = {Data.rl};
                    Data_r_r{n-1} = {Data.rr};
                    Data_r_z{n-1} = {Data.rz};
                    
                    
                    Filenames{n-1} = {FileName};
                    
                    Parameters(n-1).Stim_Info.Stim_Type = raw(n,9);
                    Parameters(n-1).Stim_Info.ModCanal = raw(n,10);
                    Parameters(n-1).Stim_Info.Freq = raw(n,12);
                    Parameters(n-1).Stim_Info.Max_Vel = raw(n,13);
                    Parameters(n-1).Stim_Info.Cycles = raw(n,15);
                    Parameters(n-1).Stim_Info.Notes = raw(n,17);
                    Parameters(n-1).Mapping.Type = raw(n,11);
                    Parameters(n-1).Mapping.Compression = raw(n,6);
                    Parameters(n-1).Mapping.Max_PR = raw(n,7);
                    Parameters(n-1).Mapping.Baseline = raw(n,8);
                    
                    Parameters(n-1).DAQ = 'McGill';
                    Parameters(n-1).DAQ_code = 4;
                    
                end
                
                [Data_QPR] = voma__qpr_data_convert(Stimulus,Data_l,Data_r,Data_z,Time,stim_ind,Fs,Filenames,Parameters);
                
            case 3 % Lab. Dev. VOG Goggles [3D]
                
                FileName = handles.params.raw;
                PathName = handles.params.raw_data_path;
                
                cd(PathName)
                
                for n = 2:size(raw,1)
                    
                    Fs_temp = 100;
                    
                    FileName = [raw{n,1} '.txt'];
                    load(FileName)
                    
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
                    
                    % Generate the time vector for the MPU9250 Data
                    Head_Sensor_Latency = 0.047; % From Mehdi Rahman's bench tests, the data acquisition of the MPU9250 leads the LD VOG Goggles by 47ms
                    Time_Stim = Time_Eye - Head_Sensor_Latency;
                    
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
                    data_rot = 1; % Data rotation code, in this case it tells the routine
                    % NOT to apply and additional coordinate system trasnformation
                    DAQ_code = 5; % Indicates we are processing Labyrinth Devices VOG Data
                    
                    [EyeData] = voma__processeyemovements(PathName,FileName,FieldGains,coilzeros,ref,data_rot,DAQ_code);
                    
                    switch handles.params.vog_data_acq_version
                        
                        case {1,2}
                            % Index for the VOG GPIO line
                            StimIndex = 35;
                            
                            Stim = data(1:length(Time_Eye),StimIndex);
                            
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
                    
                    
                    
                    
                    switch raw{n,10}
                        case {'LARP','LARP-Axis'}
                            %                     stim_temp = interp1(Time_Head,headmpu_lrz(:,1),Time_new);
                            stim_temp = interp1(Data.Time_Stim,headmpu_lrz(:,1),Data.Time_Eye);
                            %                     Stimulus{n-1} = {smooth([1:length(headmpu_lrz(:,1))],headmpu_lrz(:,1),0.01,[1:length(headmpu_lrz(:,1))])};
                        case {'RALP','RALP-Axis'}
                            %                     stim_temp = interp1(Time_Head,headmpu_lrz(:,2),Time_new);
                            stim_temp = interp1(Data.Time_Stim,headmpu_lrz(:,2),Data.Time_Eye);
                            %                     Stimulus{n-1} = {smooth([1:length(headmpu_lrz(:,2))],headmpu_lrz(:,2),0.01,[1:length(headmpu_lrz(:,2))])};
                        case {'LHRH','LHRH-Axis'}
                            %                     stim_temp = interp1(Time_Head,headmpu_lrz(:,3),Time_new);
                            stim_temp = interp1(Data.Time_Stim,headmpu_lrz(:,3),Data.Time_Eye);
                            %                     Stimulus{n-1} = {smooth([1:length(headmpu_lrz(:,3))],headmpu_lrz(:,3),0.01,[1:length(headmpu_lrz(:,3))])};
                    end
                    
                    switch raw{n,9}
                        
                        case 'Pulse Train'
                            Stimulus{n-1} = {Stimulus};
                            
                            inds = [1:length(Data.ll)];
                            
                            trig_inds = [false diff(Stimulus>0)];
                            
                            stim_ind{n-1} = {inds(trig_inds > 0)'};
                            
                        case 'Current Fitting'
                            
                            Stimulus{n-1} = {Data.Stim_Trig};
                            
                            inds = [1:length(Data.Stim_Trig)]';
                            on_inds = inds([false ; diff(Data.Stim_Trig)>0]);
                            off_inds = inds([false ; diff(Data.Stim_Trig)<0]);
                            %    stim_ind{n-1} = {[on_inds off_inds]};
                            stim_ind{n-1} ={[]};
                        case 'Virtual Sinusoid'
                            
                            Transitions = abs(diff(Stimulus));
                            inds = [1:length(Stimulus)];
                            transition_inds = inds(Transitions==1);
                            transition_inds = transition_inds(1:end-1);
                            %                     plot(transition_inds,Stimulus(transition_inds),'ro')
                            
                            A = raw{n,13};
                            mean_period = mean(diff(transition_inds))/Fs_temp;
                            f = 1/(mean_period);
                            phi = raw{n,14};
                            t_sine = [0:1/Fs_temp:((transition_inds(end)-transition_inds(1))/Fs_temp)+mean_period];
                            
                            sine = A*sin(2*pi*f*t_sine + phi);
                            VirtSine = [zeros(1,transition_inds(1)-1) sine zeros(1,length(Stimulus)-(transition_inds(end)+floor(mean_period*Fs_temp)))];
                            Stimulus{n-1} = {VirtSine};
                            
                            stim_ind{n-1} = {transition_inds'};
                        case 'Gaussian'
                            Stimulus{n-1} = {stim_temp};
                        otherwise
                            
                            %                             switch raw{n,12}
                            %                                 case {0.1,0.2}
                            %                                     spline_val = 0.0001;
                            %                                 case {0.5 , 1, 2, 5, 10}
                            %                                     spline_val =0.001;
                            %                                 otherwise
                            %                                     splineval = 0.9999999;
                            %                             end
                            
                            % Check for NaNs
                            stim_temp(isnan(stim_temp)) = zeros(1,length(stim_temp(isnan(stim_temp))));
                            Stimulus{n-1} = {stim_temp};
                            stim_ind{n-1} = {[]};
                            %
                            %                     Stimulus{n-1} = {smooth([1:length(stim_temp)],stim_temp,spline_val,[1:length(stim_temp)])};
                            %
                            % %                     % If the stimulus IS a Gaussian impulse, let's not alter
                            % %                     % the stim. trace at all since we are fitting a line to a constant
                            % %                     % acceleration ramp.
                            % %                     [stim_ind_temp] = find_stim_ind_v3(Stimulus{n-1}{1},Fs{n-1}{1},Time{n-1}{1},useradjust);
                            % %                     stim_ind{n-1} = {stim_ind_temp(:,:)};
                            
                    end
                    
                    
                    Fs{n-1} = {100};
                    
                    Eye_t{n-1} = {Time_Eye};
                    Stim_t{n-1} = {Time_Stim};
                    
                    Data_LE_Pos_X{n-1} = {EyeData.LE_Pos_X};
                    Data_LE_Pos_Y{n-1} = {EyeData.LE_Pos_Y};
                    Data_LE_Pos_Z{n-1} = {EyeData.LE_Pos_Z};
                    
                    Data_RE_Pos_X{n-1} = {EyeData.RE_Pos_X};
                    Data_RE_Pos_Y{n-1} = {EyeData.RE_Pos_Y};
                    Data_RE_Pos_Z{n-1} = {EyeData.RE_Pos_Z};
                    
                    Data_LE_Vel_X{n-1} = {EyeData.LE_Vel_X};
                    Data_LE_Vel_Y{n-1} = {EyeData.LE_Vel_Y};
                    Data_LE_Vel_LARP{n-1} = {EyeData.LE_Vel_LARP};
                    Data_LE_Vel_RALP{n-1} = {EyeData.LE_Vel_RALP};
                    Data_LE_Vel_Z{n-1} = {EyeData.LE_Vel_Z};
                    
                    Data_RE_Vel_X{n-1} = {EyeData.RE_Vel_X};
                    Data_RE_Vel_Y{n-1} = {EyeData.RE_Vel_Y};
                    Data_RE_Vel_LARP{n-1} = {EyeData.RE_Vel_LARP};
                    Data_RE_Vel_RALP{n-1} = {EyeData.RE_Vel_RALP};
                    Data_RE_Vel_Z{n-1} = {EyeData.RE_Vel_Z};
                    
                    useradjust = 'y';
                    
                    %                     if isempty(strfind(raw{n,9},'Pulse Train'))
                    %
                    %                     else
                    %
                    %                     end
                    
                    Filenames{n-1} = {FileName};
                    
                    Parameters(n-1).Stim_Info.Stim_Type = raw(n,9);
                    Parameters(n-1).Stim_Info.ModCanal = raw(n,10);
                    Parameters(n-1).Stim_Info.Freq = raw(n,12);
                    Parameters(n-1).Stim_Info.Max_Vel = raw(n,13);
                    Parameters(n-1).Stim_Info.Cycles = raw(n,15);
                    Parameters(n-1).Stim_Info.Notes = raw(n,17);
                    Parameters(n-1).Mapping.Type = raw(n,11);
                    Parameters(n-1).Mapping.Compression = raw(n,6);
                    Parameters(n-1).Mapping.Max_PR = raw(n,7);
                    Parameters(n-1).Mapping.Baseline = raw(n,8);
                    
                    Parameters(n-1).DAQ = 'LDVOG';
                    Parameters(n-1).DAQ_code = 5;
                end
                
                [Data_QPR] = voma__qpr_data_convert(Fs,Stimulus,Stim_t,stim_ind,Data_LE_Pos_X,Data_LE_Pos_Y,Data_LE_Pos_Z,Data_RE_Pos_X,Data_RE_Pos_Y,Data_RE_Pos_Z,Data_LE_Vel_X,Data_LE_Vel_Y,Data_LE_Vel_LARP,Data_LE_Vel_RALP,Data_LE_Vel_Z,Data_RE_Vel_X,Data_RE_Vel_Y,Data_RE_Vel_LARP,Data_RE_Vel_RALP,Data_RE_Vel_Z,Eye_t,Filenames,Parameters);
            case 4
                filepath = handles.params.raw_data_path;
                
                
                raw = handles.params.raw;
                
                data_fldr = handles.params.raw_data_path;
                cd(data_fldr)
                
                fieldgainname = handles.params.fieldgain_name;
                delimiter = '\t';
                formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
                
                fileID = fopen(fieldgainname,'r');
                
                dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN, 'ReturnOnError', false);
                
                fclose(fileID);
                
                FieldGains = [dataArray{1:end-1}];
                
                zerosname = handles.params.zeros_name;
                delimiter = '\t';
                formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
                
                fileID = fopen(zerosname,'r');
                
                dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN, 'ReturnOnError', false);
                
                fclose(fileID);
                
                coilzeros = [dataArray{1:end-1}];
                
                ref = 1;
                
                Fs = {1000};
                data_rot = 1;
                
                for n = 2:length(raw)
                    
                    FileName = [raw{n,1}];
                    
                    %% Check with peter on this?
                    DAQ_code = 6; % This is the code used in the 'processeyemovements'
                    % code to indicate we are dealing with a file that was only recorded using digital coil system
                    
                    inds = [];
                    [direction, frequency, amplitude, theta, phi] = voma__readFileInfo(filepath,FileName);
                    [Data] = voma__processeyemovements(filepath,FileName,FieldGains,coilzeros,ref,data_rot,DAQ_code);
                    
                    if isfield(Data, 'LE_Vel_Z')
                        Fs{n-1} = {Data.Fs};
                        
                        Eye_t{n-1} = {[0:length(Data.LE_Vel_Z)-1]/Fs{n-1}{1}};
                        Stim_t{n-1} = {Eye_t{n-1}{1}};
                        stim_ind{n-1} ={[]};
                        
                        Data_LE_Pos_X{n-1} = {Data.LE_Pos_X(1:length(Data.LE_Pos_X))};
                        Data_LE_Pos_Y{n-1} = {Data.LE_Pos_Y(1:length(Data.LE_Pos_Y))};
                        Data_LE_Pos_Z{n-1} = {Data.LE_Pos_Z(1:length(Data.LE_Pos_Z))};
                        
                        Data_RE_Pos_X{n-1} = {Data.RE_Pos_X(1:length(Data.RE_Pos_X))};
                        Data_RE_Pos_Y{n-1} = {Data.RE_Pos_Y(1:length(Data.RE_Pos_Y))};
                        Data_RE_Pos_Z{n-1} = {Data.RE_Pos_Z(1:length(Data.RE_Pos_Z))};
                        
                        Data_LE_Vel_X{n-1} = {Data.LE_Vel_X};
                        Data_LE_Vel_Y{n-1} = {Data.LE_Vel_Y};
                        Data_LE_Vel_LARP{n-1} = {Data.LE_Vel_LARP};
                        Data_LE_Vel_RALP{n-1} = {Data.LE_Vel_RALP};
                        Data_LE_Vel_Z{n-1} = {Data.LE_Vel_Z};
                        
                        Data_RE_Vel_X{n-1} = {Data.RE_Vel_X};
                        Data_RE_Vel_Y{n-1} = {Data.RE_Vel_Y};
                        Data_RE_Vel_LARP{n-1} = {Data.RE_Vel_LARP};
                        Data_RE_Vel_RALP{n-1} = {Data.RE_Vel_RALP};
                        Data_RE_Vel_Z{n-1} = {Data.RE_Vel_Z};
                        
                        
                        
                        Filenames{n-1} = {FileName};
                        
                        Parameters(n-1).DAQ = 'Digital Coil System';
                        Parameters(n-1).DAQ_code = 6;
                        
                        Parameters(n-1).Stim_Info.ModCanal = {direction};
                        Parameters(n-1).Stim_Info.Freq = {frequency};
                        Parameters(n-1).Stim_Info.Max_Vel = {amplitude};
                        Parameters(n-1).Stim_Info.Cycles = {10};
                        Parameters(n-1).Stim_Info.Theta = {theta};
                        Parameters(n-1).Stim_Info.Phi = {phi};
                        mpuAligned = Data.MPU;
                        Parameters(n-1).Stim_Info.ModCanal = {''};
                        Parameters(n-1).Stim_Info.Phase = {''};
                        Parameters(n-1).Stim_Info.PhaseDir = {''};
                        Parameters(n-1).Stim_Info.Notes = {''};
                        Parameters(n-1).Mapping.Type = {''};
                        Parameters(n-1).Mapping.Compression = {''};
                        Parameters(n-1).Mapping.Max_PR = {''};
                        Parameters(n-1).Mapping.Baseline = {''};
                        
                        Nf = 50;
                        if strcmp(direction, 'ObliqueAngle') || strcmp(direction,'ObliqueAngleHoriztonal')
                            if strcmp(direction,'ObliqueAngleHorizontal') || isempty(phi)
                                phi = 0;
                            end
                            if theta > 180
                                theta = mod(theta,180);
                            end
                            addedvec = -mpuAligned(1:length(Data.LE_Vel_Z),4).*cosd(theta).*sind(phi) + mpuAligned(1:length(Data.LE_Vel_Z),3).*sind(theta).*sind(phi)+mpuAligned(1:length(Data.LE_Vel_Z),5).*cosd(phi);
                            Stimulus{n-1}={atand((filtfilt(ones(1,Nf)/Nf,1,addedvec)/65536*9.8*8)/9.8)};
                            
                            
                            %%STATIC TILT
                        elseif (strcmp(direction,'LED')||strcmp(direction,'RED')||strcmp(direction,'NU')||strcmp(direction,'ND'))
                            if (strcmp(direction,'LED')||strcmp(direction,'RED'))
                                sensorColumn=4;
                            else %NU or ND
                                sensorColumn=3;
                            end
                            Stimulus{n-1}={asind((filtfilt(ones(1,Nf)/Nf,1,mpuAligned(1:length(Data.LE_Vel_Z),sensorColumn))/65536*9.8*8)/9.8)};
                            
                        elseif (strcmp(direction,'Lateral'))||strcmp(direction,'Surge')||strcmp(direction,'Heave')
                            if (strcmp(direction,'Lateral'))
                                sensorColumn=4;
                            elseif (strcmp(direction,'Surge'))
                                sensorColumn=3;
                            else %Heave
                                sensorColumn=5;
                            end
                            Stimulus{n-1}={atand((filtfilt(ones(1,Nf)/Nf,1,mpuAligned(1:length(Data.LE_Vel_Z),sensorColumn))/65536*9.8*8)/9.8)};
                        elseif strcmp(direction, 'Yaw') || strcmp(direction, 'Pitch') || strcmp(direction, 'Roll') || strcmp(direction,'Utricle') || strcmp(direction,'Saccule')  %change from rotation matrix to rotational velocity
                            
                            
                            if strcmp(direction,'Roll')
                                sensorColumn=6;
                            elseif strcmp(direction,'Pitch')
                                sensorColumn=7;
                            else %For Yaw
                                sensorColumn=8;
                            end
                            
                            Stimulus{n-1} = {mpuAligned(1:length(Data.LE_Vel_Z),sensorColumn)/65536*500};
                            
                            
                            
                            %%FOR LARP and RALP
                            %Gyro- 6,7,8 dps R,P,Y
                        elseif (strcmp(direction,'LARP') || strcmp(direction,'RALP') || strcmp(direction,'LA') || strcmp(direction,'LP') || strcmp(direction,'RP') ) ||strcmp(direction,'RA')
                            %for dual axes plot
                            larpang = (45-90)*pi/180;
                            ralpang = (45)*pi/180;
                            if (strcmp(direction,'LARP')) ||(strcmp(direction,'LA')) || (strcmp(direction,'RP'))
                                ang = larpang;
                            else
                                ang = ralpang;
                            end
                            RPY=[];
                            RPY(:,1) = mpuAligned(1:length(Data.LE_Vel_Z),6)./65536.*500; %dps
                            RPY(:,2) = mpuAligned(1:length(Data.LE_Vel_Z),7)./65536.*500;
                            RPY(:,3) = mpuAligned(1:length(Data.LE_Vel_Z),8)./65536.*500;
                            alpha = 0;
                            beta = 0;
                            gamma = 0;
                            dt = 0.001;
                            projectedAngVel = zeros(1,length(Data.LE_Vel_Z));
                            for i = 1:length(RPY(:,1))
                                alpha = alpha + dt*RPY(i,3)*pi/180;
                                beta = beta + dt*RPY(i,2)*pi/180;
                                gamma = gamma + dt*RPY(i,1)*pi/180;
                                R = rpyToMat(gamma,beta,alpha);
                                projectedAngVel(i) = (R*RPY(i,:)')'*[cos(ang);sin(ang);0];
                            end
                            Stimulus{n-1} = {projectedAngVel};
                        end
                    else
                        inds = [inds n-1];
                    end
                    
                end
                for i = 1:length(inds)
                    Parameters(i) = [];
                    Filenames(i) = [];
                    Fs(i) = [];
                    Eye_t(i) = [];
                    Stim_t(i) = [];
                    stim_ind(i) =[];
                    
                    Data_LE_Pos_X(i) = [];
                    Data_LE_Pos_Y(i) = [];
                    Data_LE_Pos_Z(i) = [];
                    
                    Data_RE_Pos_X(i) = [];
                    Data_RE_Pos_Y(i) = [];
                    Data_RE_Pos_Z(i) = [];
                    
                    Data_LE_Vel_X(i) = [];
                    Data_LE_Vel_Y(i) = [];
                    Data_LE_Vel_LARP(i) = [];
                    Data_LE_Vel_RALP(i) = [];
                    Data_LE_Vel_Z(i) = [];
                    
                    Data_RE_Vel_X(i) = [];
                    Data_RE_Vel_Y(i) = [];
                    Data_RE_Vel_LARP(i) = [];
                    Data_RE_Vel_RALP(i) = [];
                    Data_RE_Vel_Z(i) = [];
                    Stimulus(i) =[];
                end
                
                [Data_QPR] = voma__qpr_data_convert(Fs,Stimulus,Stim_t,stim_ind,Data_LE_Pos_X,Data_LE_Pos_Y,Data_LE_Pos_Z,Data_RE_Pos_X,Data_RE_Pos_Y,Data_RE_Pos_Z,Data_LE_Vel_X,Data_LE_Vel_Y,Data_LE_Vel_LARP,Data_LE_Vel_RALP,Data_LE_Vel_Z,Data_RE_Vel_X,Data_RE_Vel_Y,Data_RE_Vel_LARP,Data_RE_Vel_RALP,Data_RE_Vel_Z,Eye_t,Filenames,Parameters);
                
            otherwise
                
        end
        
        
    case 4 % i.e., processing data that was already converted into the VOMA compatible .mat format
        
        filepath = handles.params.raw_data_path;
        
        cd(filepath)
        
        raw = handles.params.raw;
        
        for n=2:size(raw,1)
            
            FileName = [raw{n,1} '.mat'];
            
            load(FileName)
            
            Filenames{n-1} = {FileName};
            
            Fs{n-1} = {Data.Fs};
            
            if isfield(Data,'Time_Eye')
                Eye_t{n-1} = {Data.Time_Eye};
            else
                Eye_t{n-1} = {[0:length(Data.LE_Velocity_Z)-1]/Fs{n-1}{1}};
            end
            
            Stim_t{n-1} = {Data.Time_Stim};
            
            % Extract Position Data
            Data_LE_Pos_X{n-1} = {Data.LE_Position_X};
            Data_LE_Pos_Y{n-1} = {Data.LE_Position_Y};
            Data_LE_Pos_Z{n-1} = {Data.LE_Position_Z};
            
            Data_RE_Pos_X{n-1} = {Data.RE_Position_X};
            Data_RE_Pos_Y{n-1} = {Data.RE_Position_Y};
            Data_RE_Pos_Z{n-1} = {Data.RE_Position_Z};
            
            Data_LE_Vel_X{n-1} = {Data.LE_Velocity_X};
            Data_LE_Vel_Y{n-1} = {Data.LE_Velocity_Y};
            Data_LE_Vel_LARP{n-1} = {Data.LE_Velocity_LARP};
            Data_LE_Vel_RALP{n-1} = {Data.LE_Velocity_RALP};
            Data_LE_Vel_Z{n-1} = {Data.LE_Velocity_Z};
            
            Data_RE_Vel_X{n-1} = {Data.RE_Velocity_X};
            Data_RE_Vel_Y{n-1} = {Data.RE_Velocity_Y};
            Data_RE_Vel_LARP{n-1} = {Data.RE_Velocity_LARP};
            Data_RE_Vel_RALP{n-1} = {Data.RE_Velocity_RALP};
            Data_RE_Vel_Z{n-1} = {Data.RE_Velocity_Z};
            
            Parameters(n-1).Stim_Info.Stim_Type = raw(n,9);
            Parameters(n-1).Stim_Info.ModCanal = raw(n,10);
            Parameters(n-1).Stim_Info.Freq = raw(n,12);
            Parameters(n-1).Stim_Info.Max_Vel = raw(n,13);
            Parameters(n-1).Stim_Info.Cycles = raw(n,15);
            Parameters(n-1).Stim_Info.Notes = raw(n,17);
            Parameters(n-1).Mapping.Type = raw(n,11);
            Parameters(n-1).Mapping.Compression = raw(n,6);
            Parameters(n-1).Mapping.Max_PR = raw(n,7);
            Parameters(n-1).Mapping.Baseline = raw(n,8);
            
            Parameters(n-1).SoftwareVer.SegSoftware = Data.segment_code_version;
            Parameters(n-1).SoftwareVer.QPRconvGUI = mfilename;
            
            if isfield('Data','start_t')
                Results.raw_start_t = Data.start_t;
                Results.raw_end_t = Data.end_t;
            end
            
            switch handles.params.system_config
                
                case {1,5}
                    switch handles.params.file_format
                        case 1
                            Parameters(n-1).DAQ = 'Lasker_VORDAQ';
                            Parameters(n-1).DAQ_code = 1;
                        case 2
                            Parameters(n-1).DAQ = 'Lasker_VORDAQ+CED';
                            Parameters(n-1).DAQ_code = 2;
                        case 3
                            Parameters(n-1).DAQ = 'Lasker_CED';
                            Parameters(n-1).DAQ_code = 3;
                            
                        case 4
                            Parameters(n-1).DAQ = 'Fick Angles';
                            Parameters(n-1).DAQ_code = 3;
                            
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
                    
                    
                    headmpu_xyz = [Data.HeadMPUVel_X Data.HeadMPUVel_Y Data.HeadMPUVel_Z];
                    
                    headmpu_lrz = [rotZ3deg(-45)'*headmpu_xyz']';
                    switch raw{n,9}
                        
                        case {'Electrical Only','*ElectricOnly*','ElectricalOnly*'}
                            Stimulus{n-1} = {Data.Stim_Trig};
                            Stim_t{n-1} = {Data.Time_Stim(:,1)};
                            
                            stim_ind{n-1} ={[]};
                        otherwise
                            switch raw{n,10}
                                case {'LARP-Axis','LA','LARP','RP'}
                                    Stimulus{n-1} = {headmpu_lrz(:,1)};
                                case {'RALP-Axis','LP','RALP','RA'}
                                    Stimulus{n-1} = {headmpu_lrz(:,2)};
                                    
                                case {'LHRH-Axis','LH','LHRH','RH'}
                                    Stimulus{n-1} = {headmpu_lrz(:,3)};
                                    
                            end
                            stim_ind{n-1} = {[]};
                    end
                    
                case 2
                    Parameters(n-1).DAQ = 'McGill';
                    Parameters(n-1).DAQ_code = 4;
                case 3 % MVI VOG
                    
                    Parameters(n-1).DAQ = 'LDVOG';
                    Parameters(n-1).DAQ_code = 5;
                    
                    if ~isempty(strfind(raw{n,9},'ElectricalOnly')) || ~isempty(strfind(raw{n,9},'ElectricOnly')) || ~isempty(strfind(raw{n,9},'Electrical Only')) || ~isempty(strfind(raw{n,9},'Electric Only'))
                        
                        % Create sinusoidal stimulus file
                        Transitions = abs(diff(Data.Stim_Trig));
                        inds = [1:length(Data.Stim_Trig)];
                        transition_inds = inds(Transitions==1);
                        transition_inds = transition_inds(1:end-1);
                        
                        A = raw{n,13};
                        mean_period = mean(diff(transition_inds))/(Data.Fs);
                        f = 1/(mean_period);
                        phi = 0;
                        t_sine = [0:1/(Data.Fs):((transition_inds(end)-transition_inds(1))/(Data.Fs))+mean_period];
                        
                        sine = A*sin(2*pi*f*t_sine + phi);
                        VirtSine = [zeros(1,transition_inds(1)-1) sine zeros(1,length(Data.Stim_Trig)-(transition_inds(end)+floor(mean_period*(Data.Fs))))];
                        
                        Stimulus{n-1} = {VirtSine};
                        stim_ind{n-1} = {transition_inds'};
                        % For Elec. Only stimuli w/ the MVI LD goggles,
                        % the GPIO line is collected w/ the VOG data.
                        % Thus, we will overwrite the 'Stim_t' time
                        % vector w/ the VOG time vector.
                        Stim_t{n-1} = {Data.Time_Eye};
                        
                    elseif ~isempty(strfind(raw{n,9},'65Vector'))
                        
                        inds = [1:length(Data.Stim_Trig)];
                        
                        temp_inds = [0 ; diff(Data.Stim_Trig)];
                        
                        start_ramp = inds(temp_inds > 0);
                        start_onramp = start_ramp(1:2:end);
                        start_offramp = start_ramp(2:2:end);
                        
                        stop_ramp = inds(temp_inds < 0);
                        stop_onramp = stop_ramp(1:2:end);
                        stop_offramp = stop_ramp(2:2:end);
                        
                        A = raw{n,13};
                        
                        stimwaveform = zeros(length(Data.Stim_Trig),1);
                        for jjj = 1:length(start_onramp)
                            stimwaveform(start_onramp(jjj):stop_onramp(jjj)) = linspace(0,A,length(stimwaveform(start_onramp(jjj):stop_onramp(jjj))));
                            stimwaveform(stop_onramp(jjj):start_offramp(jjj)) = A*ones(length(stimwaveform(stop_onramp(jjj):start_offramp(jjj))),1);
                            stimwaveform(start_offramp(jjj):stop_offramp(jjj)) = linspace(A,0,length(stimwaveform(start_offramp(jjj):stop_offramp(jjj))));
                        end
                        
                        Stimulus{n-1} = {stimwaveform};
                        Stim_t{n-1} = {Data.Time_Eye};
                        stim_ind{n-1} ={start_onramp'};
                        
                    elseif ~isempty(strfind(raw{n,9},'Activation')) || ~isempty(strfind(raw{n,9},'Adaptation'))
                        
                        Stimulus{n-1} = {Data.Stim_Trig};
                        Stim_t{n-1} = {Data.Time_Eye};
                        stim_ind{n-1} ={[]};
                        
                    elseif ~isempty(strfind(raw{n,9},'Current Fitting')) || ~isempty(strfind(raw{n,9},'CurrentFitting'))
                        Stimulus{n-1} = {Data.Stim_Trig};
                        
                        inds = [1:length(Data.Stim_Trig)]';
                        on_inds = inds([false ; diff(Data.Stim_Trig)>0]);
                        off_inds = inds([false ; diff(Data.Stim_Trig)<0]);
                        %    stim_ind{n-1} = {[on_inds off_inds]};
                        stim_ind{n-1} ={[]};
                        % For Elec. Only stimuli w/ the MVI LD goggles,
                        % the GPIO line is collected w/ the VOG data.
                        % Thus, we will overwrite the 'Stim_t' time
                        % vector w/ the VOG time vector.
                        Stim_t{n-1} = {Data.Time_Eye};
                        
                    elseif ~isempty(strfind(raw{n,9},'Pulse Train')) || ~isempty(strfind(raw{n,9},'PulseTrain'))
                        
                        
                        
                        Stimulus{n-1} = {Data.Stim_Trig};
                        
                        inds = [1:length(Data.Stim_Trig)]';
                        on_inds = inds([false ; diff(Data.Stim_Trig)>0]);
                        off_inds = inds([false ; diff(Data.Stim_Trig)<0]);
                        %    stim_ind{n-1} = {[on_inds off_inds]};
                        stim_ind{n-1} ={[]};
                        % For Elec. Only stimuli w/ the MVI LD goggles,
                        % the GPIO line is collected w/ the VOG data.
                        % Thus, we will overwrite the 'Stim_t' time
                        % vector w/ the VOG time vector.
                        Stim_t{n-1} = {Data.Time_Eye};
                        
                        
                        
                    else
                        
                        
                        headmpu_xyz = [Data.HeadMPUVel_X Data.HeadMPUVel_Y Data.HeadMPUVel_Z];
                        
                        headmpu_lrz = [rotZ3deg(-45)'*headmpu_xyz']';
                        
                        % NOTE: The data acquired on the
                        % MPU9250 is not time stamped
                        % identically with the VOG data. Thus,
                        % the 'Time_Eye' and 'Time_Stim' traces
                        % are NOT identicle for these files. The user
                        % has the option to interpolate the MPU data to
                        % the VOG time stamps.
                        
                        if handles.params.interp_ldvog_mpu
                            
                            switch raw{n,10}
                                case {'LARP-Axis','LA','LARP','RP'}
                                    Stimulus{n-1} = {interp1(Data.Time_Stim,headmpu_lrz(:,1),Data.Time_Eye)};
                                    
                                case {'RALP-Axis','LP','RALP','RA'}
                                    Stimulus{n-1} = {interp1(Data.Time_Stim,headmpu_lrz(:,2),Data.Time_Eye)};
                                    
                                case {'LHRH-Axis','LH','LHRH','RH'}
                                    Stimulus{n-1} = {interp1(Data.Time_Stim,headmpu_lrz(:,3),Data.Time_Eye)};
                                    
                            end
                            Stim_t{n-1} = {Data.Time_Eye};
                        else
                            
                            switch raw{n,10}
                                case {'LARP-Axis','LA','LARP','RP'}
                                    Stimulus{n-1} = {headmpu_lrz(:,1)};
                                case {'RALP-Axis','LP','RALP','RA'}
                                    Stimulus{n-1} = {headmpu_lrz(:,2)};
                                    
                                case {'LHRH-Axis','LH','LHRH','RH'}
                                    Stimulus{n-1} = {headmpu_lrz(:,3)};
                                    
                            end
                            
                        end
                        stim_ind{n-1} = {[]};
                        
                    end
                    
                    
                case 4 %VNEL Digital Coil System
                    Parameters(n-1).DAQ = 'DigCoilSys';
                    Parameters(n-1).DAQ_code = 6;
            end
            
            
            
            Raw_Filenames{n-1} = Data.raw_filename;
            
			if ~exist('Stimulus','var')
                h = questdlg(['ERROR: No stimulus file was extracted for file number: ' num2str(n-1) '. Please check the ''Function''  listed in your experimental record sheet. Please choose how to proceed.'],'Stimulus Error',...
                    'Exit','Try Next File','Try Next File');
                
                switch h
                    
                    case 'Exit'
                        save_flag = false;
                        break
                    case 'Try Next File'
                        continue
                end
                
                
            end   
        end
        
        
        
        
        [Data_QPR] = voma__qpr_data_convert(Fs,Stimulus,Stim_t,stim_ind,Data_LE_Pos_X,Data_LE_Pos_Y,Data_LE_Pos_Z,Data_RE_Pos_X,Data_RE_Pos_Y,Data_RE_Pos_Z,Data_LE_Vel_X,Data_LE_Vel_Y,Data_LE_Vel_LARP,Data_LE_Vel_RALP,Data_LE_Vel_Z,Data_RE_Vel_X,Data_RE_Vel_Y,Data_RE_Vel_LARP,Data_RE_Vel_RALP,Data_RE_Vel_Z,Eye_t,Filenames,Parameters,Raw_Filenames);
        
        
		if save_flag
            
            [Data_QPR] = voma__qpr_data_convert(Fs,Stimulus,Stim_t,stim_ind,Data_LE_Pos_X,Data_LE_Pos_Y,Data_LE_Pos_Z,Data_RE_Pos_X,Data_RE_Pos_Y,Data_RE_Pos_Z,Data_LE_Vel_X,Data_LE_Vel_Y,Data_LE_Vel_LARP,Data_LE_Vel_RALP,Data_LE_Vel_Z,Data_RE_Vel_X,Data_RE_Vel_Y,Data_RE_Vel_LARP,Data_RE_Vel_RALP,Data_RE_Vel_Z,Eye_t,Filenames,Parameters,Raw_Filenames);
            
        end 
end



if save_flag
cd(handles.params.output_data_path)
str = inputdlg('Please enter the name of the output file (WITHOUT any suffix)','Output File', [1 50]);

save([str{1} '.voma'],'Data_QPR')
   end

% --- Executes on selection change in excel_sheet_list.
function excel_sheet_list_Callback(hObject, eventdata, handles)
% hObject    handle to excel_sheet_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sheet_id = get(hObject,'Value');

[num1,txt1,raw1] = xlsread([handles.params.xlspath handles.params.xlsname],sheet_id);

handles.params.raw = raw1;
guidata(hObject,handles)

% Hints: contents = cellstr(get(hObject,'String')) returns excel_sheet_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from excel_sheet_list


% --- Executes during object creation, after setting all properties.
function excel_sheet_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to excel_sheet_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in lasker_stim_chan.
function lasker_stim_chan_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in lasker_stim_chan
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'stim_x083'
        handles.params.stim_chan = 1;
    case 'stim_derivx081'
        handles.params.stim_chan = 2;
        
end

guidata(hObject,handles)


% --- Executes on button press in pulse_train_analysis.
function pulse_train_analysis_Callback(hObject, eventdata, handles)
% hObject    handle to pulse_train_analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

raw = handles.params.raw;


data_fldr = handles.params.raw_data_path;
cd(data_fldr)

for n = 2:size(raw,1)
    
    Fs_temp = 100;
    
    FileName = [raw{n,1} '.mat'];
    load(FileName)
    headmpu_xyz = [Torsion_Head_Velocity' Vertical_Head_Velocity' Horizontal_Head_Velocity'];
    
    headmpu_lrz = [rotZ3deg(-45)'*headmpu_xyz']';
    
    % Extract the stimulus trigger
    
    
    % The VOG system does not always sample data in a synchronous
    % manner. Additionally, the MPU is not sampled at the same time
    % points as the VOG data. To mitigate these issues, we will
    % first create a new time vector of uniformly sampled time
    % stamps and interpolate the eye movement data on this new time
    % base. Second, we will interpolate the head velocity data to
    % the new VOG time points.
    
    data_len = min([length(Torsion_LE_Position) length(Torsion_RE_Position) length(Vertical_LE_Position) length(Vertical_RE_Position) length(Horizontal_LE_Position) length(Horizontal_RE_Position) length(Time_Eye)]);
    
    % New, uniformly sampled time base
    Time_new = [Time_Eye(1):1/Fs_temp:Time_Eye(end)];
    % Check if the new time vector is longer than the number of
    % data ponts.
    if length(Time_new)>data_len
        Time_new = Time_new(1:data_len);
    end
    
    raw_data.LE_H = interp1(Time_Eye(1:data_len),Horizontal_LE_Position(1:data_len),Time_new);
    raw_data.LE_V = interp1(Time_Eye(1:data_len),Vertical_LE_Position(1:data_len),Time_new);
    raw_data.LE_T = interp1(Time_Eye(1:data_len),Torsion_LE_Position(1:data_len),Time_new);
    
    raw_data.RE_H = interp1(Time_Eye(1:data_len),Horizontal_RE_Position(1:data_len),Time_new);
    raw_data.RE_V = interp1(Time_Eye(1:data_len),Vertical_RE_Position(1:data_len),Time_new);
    raw_data.RE_T = interp1(Time_Eye(1:data_len),Torsion_RE_Position(1:data_len),Time_new);
    raw_data.Fs = Fs_temp;
    
    [Data] = voma__processeyemovements(data_fldr,FileName,[],[],0,1,3,raw_data);
    
    Data.ll(isnan(Data.ll)) = zeros(1,length(Data.ll(isnan(Data.ll))));
    Data.lr(isnan(Data.lr)) = zeros(1,length(Data.lr(isnan(Data.lr))));
    Data.lz(isnan(Data.lz)) = zeros(1,length(Data.lz(isnan(Data.lz))));
    
    Data.rl(isnan(Data.rl)) = zeros(1,length(Data.rl(isnan(Data.rl))));
    Data.rr(isnan(Data.rr)) = zeros(1,length(Data.rr(isnan(Data.rr))));
    Data.rz(isnan(Data.rz)) = zeros(1,length(Data.rz(isnan(Data.rz))));
    
    figure
    
    plot(Time_new,Data.ll,'LineStyle',':','color' ,[0,128,0]/255,'LineWidth',2)
    hold on
    plot(Time_new,Data.lr,'LineStyle',':','color' ,'b','LineWidth',2)
    plot(Time_new,Data.lz,'LineStyle',':','color' ,'r','LineWidth',2)
    
    plot(Time_new,Data.rl,'LineStyle',':','color' ,'g','LineWidth',2)
    hold on
    plot(Time_new,Data.rr,'LineStyle',':','color' ,[64,224,208]/255,'LineWidth',2)
    plot(Time_new,Data.rz,'LineStyle',':','color' ,[255,0,255]/255,'LineWidth',2)
    
    plot(Time_new,Stimulus(1:data_len)*1000,'k')
    
    inds = [1:length(Data.ll)];
    
    trig_inds = [false diff(Stimulus'>0)];
    
    stim_on = inds(trig_inds > 0);
    stim_off = inds(trig_inds < 0);
    
    if stim_off(1)<stim_on(1)
        stim_off = stim_off(2:end);
    end
    
    stim_dur = stim_off - stim_on;
    
    segment_len = min(stim_dur);
    
    ll_cyc = [];
    lr_cyc = [];
    lz_cyc = [];
    
    rl_cyc = [];
    rr_cyc = [];
    rz_cyc = [];
    
    for n=1:length(stim_on)
        
        ll_cyc = [ll_cyc ; Data.ll(stim_on(n):stim_on(n)+segment_len)'];
        lr_cyc = [lr_cyc ; Data.lr(stim_on(n):stim_on(n)+segment_len)'];
        lz_cyc = [lz_cyc ; Data.lz(stim_on(n):stim_on(n)+segment_len)'];
        
        rl_cyc = [rl_cyc ; Data.rl(stim_on(n):stim_on(n)+segment_len)'];
        rr_cyc = [rr_cyc ; Data.rr(stim_on(n):stim_on(n)+segment_len)'];
        rz_cyc = [rz_cyc ; Data.rz(stim_on(n):stim_on(n)+segment_len)'];
        
    end
    
    m_ll = mean(ll_cyc);
    m_lr = mean(lr_cyc);
    m_lz = mean(lz_cyc);
    m_rl = mean(rl_cyc);
    m_rr = mean(rr_cyc);
    m_rz = mean(rz_cyc);
    
    t = [1:size(m_ll,2)]/Fs_temp;
    
    figure
    title(['MVI001R019 - ' raw{n,10} raw{n,13}])
    hold on
    h1 = plot(t,m_ll,'LineWidth',2,'color' ,[0,128,0]/255)
    h2 = plot(t,m_lr,'LineWidth',2,'color' ,'b')
    h3 = plot(t,m_lz,'LineWidth',2,'color' ,'r')
    
    h4 = plot(t,m_rl,'LineWidth',2,'color' ,'g')
    h5 = plot(t,m_rr,'LineWidth',2,'color' ,[64,224,208]/255)
    h6 = plot(t,m_rz,'LineWidth',2,'color' ,[255,0,255]/255)
    
    
    h7 = plot(t,m_ll+std(ll_cyc),'LineStyle',':','color' ,[0,128,0]/255)
    h8 = plot(t,m_ll-std(ll_cyc),'LineStyle',':','color' ,[0,128,0]/255)
    h9 = plot(t,m_lr+std(lr_cyc),'LineStyle',':','color' ,'b')
    h10 = plot(t,m_lr-std(lr_cyc),'LineStyle',':','color' ,'b')
    h11 = plot(t,m_lz+std(lz_cyc),'LineStyle',':','color' ,'r')
    h12 = plot(t,m_lz-std(lz_cyc),'LineStyle',':','color' ,'r')
    
    
    h13 = plot(t,std(ll_cyc),'LineStyle',':','color' ,'g')
    h14 = plot(t,std(lr_cyc),'LineStyle',':','color' ,[64,224,208]/255)
    h15 = plot(t,std(lz_cyc),'LineStyle',':','color' ,[255,0,255]/255)
    
    xlabel('Time [s]')
    ylabel('Angular Eye Velocity [dps]')
    legend('Left - LARP', 'Left - RALP' , 'Left - LHRH' , 'Right - LARP', 'Right - RALP' , 'Right - LHRH')
    
    
    
    switch raw{n,10}
        
        case {'E11 - LARP'}
            
            [m_l,ind_l] = max(m_ll);
            plot(t(ind_l),m_ll(ind_1),'ko');
            plot(t(ind_1),m_lr(ind_1),'ko');
            plot(t(ind_1),m_lz(ind_1),'ko');
            
            [m_r,ind_r] = max(m_rl);
            plot(t(ind_r),m_ll(ind_r),'ko');
            plot(t(ind_r),m_lr(ind_r),'ko');
            plot(t(ind_r),m_lz(ind_r),'ko');
            
            
        case {'E3 - RALP'}
            [m_l,ind_l] = max(m_lr);
            plot(t(ind_l),m_ll(ind_1),'ko');
            plot(t(ind_1),m_lr(ind_1),'ko');
            plot(t(ind_1),m_lz(ind_1),'ko');
            
            [m_r,ind_r] = max(m_rr);
            plot(t(ind_r),m_ll(ind_r),'ko');
            plot(t(ind_r),m_lr(ind_r),'ko');
            plot(t(ind_r),m_lz(ind_r),'ko');
        case {'E7 - LHRH'}
            [m_l,ind_l] = max(m_lz);
            plot(t(ind_l),m_ll(ind_1),'ko');
            plot(t(ind_1),m_lr(ind_1),'ko');
            plot(t(ind_1),m_lz(ind_1),'ko');
            
            [m_r,ind_r] = max(m_rz);
            plot(t(ind_r),m_ll(ind_r),'ko');
            plot(t(ind_r),m_lr(ind_r),'ko');
            plot(t(ind_r),m_lz(ind_r),'ko');
    end
    
    
end



[Data_QPR] = voma__qpr_data_convert(Stimulus,Data_l_l,Data_l_r,Data_l_z,Data_r_l,Data_r_r,Data_r_z,Time,stim_ind,Fs,Filenames,Parameters);


% --- Executes when selected object is changed in file_type.
function file_type_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in file_type
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'rawfile_opt1'
        handles.params.file_format = 1;
    case 'rawfile_opt2'
        handles.params.file_format = 2;
    case 'rawfile_opt3'
        handles.params.file_format = 3;
    case 'mat_file_format'
        handles.params.file_format = 4;
end



guidata(hObject,handles)


% --- Executes on selection change in R710_mky_chair_orientation.
function R710_mky_chair_orientation_Callback(hObject, eventdata, handles)
% hObject    handle to R710_mky_chair_orientation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index_selected = get(hObject,'Value');
handles.params.R710_mky_chair_orientation = index_selected;

guidata(hObject,handles)
% Hints: contents = cellstr(get(hObject,'String')) returns R710_mky_chair_orientation contents as cell array
%        contents{get(hObject,'Value')} returns selected item from R710_mky_chair_orientation


% --- Executes during object creation, after setting all properties.
function R710_mky_chair_orientation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R710_mky_chair_orientation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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


% --- Executes on button press in interp_ldvog_mpu.
function interp_ldvog_mpu_Callback(hObject, eventdata, handles)
% hObject    handle to interp_ldvog_mpu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.params.interp_ldvog_mpu = true;
else
    handles.params.interp_ldvog_mpu = false;
end
% Hint: get(hObject,'Value') returns toggle state of interp_ldvog_mpu
guidata(hObject,handles)


% --- Executes on button press in zerosPushButton.
function zerosPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to zerosPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName,FilterIndex] = uigetfile('*.*', 'Please choose the file containing the zeros for the data being processed');

handles.params.zeros_name = FileName;
handles.params.zeros_path = PathName;

set(handles.zerosText,'String',FileName);

guidata(hObject,handles)


%% returns the rotation matrix given rotations in roll, pitch, and yaw
function R = rpyToMat(r,p,y)
R = zeros(3,3);

sy = sin(y);
cy = cos(y);

sp = sin(p);
cp = cos(p);

sr = sin(r);
cr = cos(r);

Ryaw = [cy -sy 0;
    sy  cy 0;
    0    0 1];

Rpitch = [cp 0 sp;
    0 1  0;
    -sp 0 cp];

Rroll = [1 0 0;
    0 cr -sr;
    0 sr  cr];

R = Ryaw*Rpitch*Rroll;


% --- Executes on button press in mat_file_format.
function mat_file_format_Callback(hObject, eventdata, handles)
% hObject    handle to mat_file_format (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mat_file_format
