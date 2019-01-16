function varargout = voma(varargin)
% VOMA MATLAB code for voma.fig
%      VOMA, by itself, creates a new VOMA or raises the existing
%      singleton*.
%
%      H = VOMA returns the handle to a new VOMA or the handle to
%      the existing singleton*.
%
%      VOMA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VOMA.M with the given input arguments.
%
%      VOMA('Property','Value',...) creates a new VOMA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before voma_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to voma_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help voma
% Testing
% Last Modified by GUIDE v2.5 10-Oct-2018 11:46:15

% Begin initialization code - DO NOT EDIT
% Brian M test
%%IM EDITING
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @voma_OpeningFcn, ...
    'gui_OutputFcn',  @voma_OutputFcn, ...
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

% --- Executes just before voma is made visible.
function voma_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to voma (see VARARGIN)

% Choose default command line output for voma
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes voma wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = voma_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in seg_data_open.
function seg_data_open_Callback(hObject, eventdata, handles)
% hObject    handle to seg_data_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
voma__seg_data
end

% --- Executes on button press in qpr_open.
function qpr_open_Callback(hObject, eventdata, handles)
% hObject    handle to qpr_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
voma__qpr
end

% --- Executes on button press in convert_raw2qpr_open.
function convert_raw2qpr_open_Callback(hObject, eventdata, handles)
% hObject    handle to convert_raw2qpr_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
voma__convert_raw2qpr
end

% --- Executes on button press in gen_report_open.
function gen_report_open_Callback(hObject, eventdata, handles)
% hObject    handle to gen_report_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
voma__gen_report
end

% --- Executes on button press in RecalibVOMAfile.
function RecalibVOMAfile_Callback(hObject, eventdata, handles)
% hObject    handle to RecalibVOMAfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
answer = questdlg(['You have chosen to recalibrate a VOMA file, the corresponding segmented files, and any raw data files connected to the VOMA file. This code ASSUMES the data is saved in the standard folder format.'], ...
    'Recalibration Menu', ...
    'PROCEED','EXIT','EXIT');

switch answer
    
    case 'PROCEED'
        [VOMAFileName,VOMAPathName] = uigetfile('.voma','Select VOMA file to recalibrate.');
        
        cd(VOMAPathName)
        
        cd ..\
        
        ExpFolder = pwd;
        
        h_wb = waitbar(0,'Starting...','Name','Recalibrating Old LD VOG Data');
        
        setappdata(h_wb,'canceling',0)
        
        % FileFold = 'F:\MVI\__MVI-Server-Sync-Folder\MVI002_R004\Visit 5\Rotary Chair\VOMA Files\';
        % FileName = 'MVI002R004-Visit5-20161214-RotChair.voma';
        % Load VOMA file
        load([VOMAPathName VOMAFileName],'-mat')
        
        temp= load([VOMAPathName VOMAFileName],'-mat');
        
        % Get the names of the variables loaded into the environment
        fn=fieldnames(temp);
        
        % The internal argument here converts the 'cell' containing the variable
        % name loaded to the environment into a string. This is so we can 'extract'
        % the variable loaded and give it a set variable name.
        RootData = temp.(char(cellfun(@(x) num2str(x),fn(1),'Un',0)));
        
        Raw_file_names = {};
        
        for k=1:length(RootData)
            
            partnum = 1;
            NumOfParts = 7;
            part_txt = 'Recalibrating Ang.Pos. Data';
            waitbar(((k-1)+(partnum/NumOfParts))/length(RootData),h_wb,sprintf(['File ' num2str(k) ' of ' num2str(length(RootData)) ': ' part_txt]))
            
            handles.CurrData = RootData(k);
            
            
            SegmentName = handles.CurrData.name;
            
            %% Load Segmented File
            
            cd([ExpFolder '\Segmented Files'])
            load(SegmentName)
            RawName = Data.raw_filename;
            RawName(strfind(RawName,'.txt'):end) = [];
            
            
            %% Recalibrate VOG data
            
            
            if sum(cell2mat(strfind(Raw_file_names,RawName)))<1
                
                answer = questdlg(['You will be prompted to choose the LEFT and RIGHT eye calibration files for file: ' RawName], ...
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
                
            end
            
            
            calib_file_fullpath_left = strcat(LEcalibPathName, LEcalibFileName);
            calib_file_fullpath_right = strcat(REcalibPathName, REcalibFileName);
            
            % Load Data from File
            fname_data = strcat(ExpFolder, '\Raw LD VOG Files\' , RawName, '.txt');
            vogdata = dlmread(fname_data,' ',1,0);
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
            Polynomials_Left = VOG_Calibration_9_Points(Eye, DistanceToWall, calib_file_fullpath_left,RawName);
            
            H_Left_Coeffs = Polynomials_Left(:,1);
            V_Left_Coeffs = Polynomials_Left(:,2);
            
            Eye = 'Right';
            Polynomials_Right = VOG_Calibration_9_Points(Eye, DistanceToWall, calib_file_fullpath_right,RawName);
            
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
            
            if sum(cell2mat(strfind(Raw_file_names,RawName)))<1
                Raw_file_names{end+1} = RawName;
                partnum = 2;
                NumOfParts = 7;
                part_txt = 'Saving Re-Calibrated LD VOG File';
                waitbar(((k-1)+(partnum/NumOfParts))/length(RootData),h_wb,sprintf(['File ' num2str(k) ' of ' num2str(length(RootData)) ': ' part_txt]))
                dlmwrite([fname_data(1:end-4) '_UpdatedVOGCalib_' num2str(DistanceToWall) 'in' '__' datestr(now,'yyyy-mm-dd') '.txt'], vogdata, 'delimiter',' ','precision','%.4f');
            end
            Report{k,1} = {RawName};
            %% Re-segment VOG data
            
            
            [a,b]  = min(abs(Time_Eye - Data.start_t));
            [c,d]  = min(abs(Time_Eye - Data.end_t));
            
            [a,b]  = min(abs(Time_Eye - Data.start_t));
            [c,d]  = min(abs(Time_Eye - Data.end_t));
            
            
            Data.LE_Position_Y = V_LE_deg_new(b:d);
            Data.LE_Position_Z = H_LE_deg_new(b:d);
            Data.RE_Position_Y = V_RE_deg_new(b:d);
            Data.RE_Position_Z = H_RE_deg_new(b:d);
            
            % This system code marks that no additional manipulations of the raw data
            % are required.
            data_rot = 1;
            
            
            % If, regardless of the system used to record the eye movement data,
            % the data is presented in Fick angles, change the DAQ_code to '5'
            DAQ_code = 5;
            OutputFormat = 1;
            
            
            
            % Store Relevant Ocular Ang. Pos. data in the proper format for the
            % 'processeyemovements' function
            Data_In.Data_LE_Pos_X = Data.LE_Position_X;
            Data_In.Data_LE_Pos_Y = Data.LE_Position_Y;
            Data_In.Data_LE_Pos_Z = Data.LE_Position_Z;
            
            Data_In.Data_RE_Pos_X = Data.RE_Position_X;
            Data_In.Data_RE_Pos_Y = Data.RE_Position_Y;
            Data_In.Data_RE_Pos_Z = Data.RE_Position_Z;
            
            Data_In.Fs = Data.Fs;
            
            [New_Ang_Vel] = voma__processeyemovements([],[],[],[],0,data_rot,DAQ_code,OutputFormat,Data_In);
            
            Data.LE_Velocity_X = New_Ang_Vel.LE_Vel_X;
            Data.LE_Velocity_Y = New_Ang_Vel.LE_Vel_Y;
            Data.LE_Velocity_LARP = New_Ang_Vel.LE_Vel_LARP;
            Data.LE_Velocity_RALP = New_Ang_Vel.LE_Vel_RALP;
            Data.LE_Velocity_Z = New_Ang_Vel.LE_Vel_Z;
            
            Data.RE_Velocity_X = New_Ang_Vel.RE_Vel_X;
            Data.RE_Velocity_Y = New_Ang_Vel.RE_Vel_Y;
            Data.RE_Velocity_LARP = New_Ang_Vel.RE_Vel_LARP;
            Data.RE_Velocity_RALP = New_Ang_Vel.RE_Vel_RALP;
            Data.RE_Velocity_Z = New_Ang_Vel.RE_Vel_Z;
            
            %% Save Recalibrated VOG segmented file
            
            partnum = 3;
            part_txt = 'Saving Segmented VOG Data';
            waitbar(((k-1)+(partnum/NumOfParts))/length(RootData),h_wb,sprintf(['File ' num2str(k) ' of ' num2str(length(RootData)) ': ' part_txt]))
            
            cd([ExpFolder '\Segmented Files'])
            NewSegName = [SegmentName(1:end-4) '_UpdatedVOGCalib_' date '_' num2str(DistanceToWall) 'in' '.mat'];
            save(NewSegName,'Data')
            Report{k,2} = {SegmentName(1:end-4)};
            %% Construct NEW VOMA file / Replace 'raw' AngPos Data
            handles.CurrData.name = NewSegName(1:end-4);
            
            handles.CurrData.VOMA_data.Data_LE_Pos_Y = Data.LE_Position_Y;
            handles.CurrData.VOMA_data.Data_LE_Pos_Z = Data.LE_Position_Z;
            
            handles.CurrData.VOMA_data.Data_RE_Pos_Y = Data.RE_Position_Y;
            handles.CurrData.VOMA_data.Data_RE_Pos_Z = Data.RE_Position_Z;
            
            if isfield(handles.CurrData,'QPparams') && ~isempty(handles.CurrData.QPparams)
                filt_params = handles.CurrData.QPparams.filt_params;
            end
            
            %% Apply AngPos Filters
            
            
            partnum = 4;
            part_txt = 'Applying AngPos Filters';
            waitbar(((k-1)+(partnum/NumOfParts))/length(RootData),h_wb,sprintf(['File ' num2str(k) ' of ' num2str(length(RootData)) ': ' part_txt]))
            if isfield(handles.CurrData,'QPparams') && ~isempty(handles.CurrData.QPparams)
                
                for p=2:7
                    if ~isempty(filt_params{p,2})
                        handles.params.pos_filt_trace = p-1;
                        handles.params.angpos_filt_param1 = filt_params{p,3};
                        handles.params.angpos_filt_param2 = filt_params{p,4};
                        handles.params.angpos_filt_param3 = filt_params{p,5};
                        handles.params.angpos_filt_param4 = filt_params{p,6};
                        handles.params.angpos_filt_param5 = filt_params{p,7};
                        handles.params.angpos_filt_param6 = filt_params{p,8};
                        
                        switch filt_params{p,2}
                            
                            case 'S. Golay'
                                handles.params.pos_filt_method = 1;
                            case 'Env. Filt.'
                                handles.params.pos_filt_method = 2;
                            case 'Median Filter'
                                handles.params.pos_filt_method = 3;
                            case 'irlssmooth'
                                handles.params.pos_filt_method = 4;
                        end
                        
                        [handles] = apply_angpos_filt_Callback(handles);
                    else
                        % If the current AngPos trace was not filtered at all, we
                        % will propogate the 'raw' AngPos data forward to the
                        % 'Filtered' variable.
                        switch p-1
                            case 1
                                handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_X = handles.CurrData.VOMA_data.Data_LE_Pos_X;
                            case 2
                                handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_Y = handles.CurrData.VOMA_data.Data_LE_Pos_Y;
                            case 3
                                handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_Z = handles.CurrData.VOMA_data.Data_LE_Pos_Z;
                            case 4
                                handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_X = handles.CurrData.VOMA_data.Data_RE_Pos_X;
                            case 5
                                handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_Y = handles.CurrData.VOMA_data.Data_RE_Pos_Y;
                            case 6
                                handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_Z = handles.CurrData.VOMA_data.Data_RE_Pos_Z;
                        end
                    end
                end
                
            else
                handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_X = handles.CurrData.VOMA_data.Data_LE_Pos_X;
                handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_Y = handles.CurrData.VOMA_data.Data_LE_Pos_Y;
                handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_Z = handles.CurrData.VOMA_data.Data_LE_Pos_Z;
                
                handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_X = handles.CurrData.VOMA_data.Data_RE_Pos_X;
                handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_Y = handles.CurrData.VOMA_data.Data_RE_Pos_Y;
                handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_Z = handles.CurrData.VOMA_data.Data_RE_Pos_Z;
            end
            
            %% Recalc AngVel
            
            
            [handles] = recalc_angvel_Callback(handles);
            
            %% Apply AngVel Filters
            
            partnum = 5;
            part_txt = 'Applying AngVelocity Filters';
            waitbar(((k-1)+(partnum/NumOfParts))/length(RootData),h_wb,sprintf(['File ' num2str(k) ' of ' num2str(length(RootData)) ': ' part_txt]))
            
            handles.LE_filt_flag = true;
            handles.RE_filt_flag = true;
            
            if isfield(handles.CurrData,'QPparams') && ~isempty(handles.CurrData.QPparams)
                
                handles.params.e_vel_param1 = filt_params{8,3};
                handles.params.e_vel_param2 = filt_params{8,4};
                handles.params.e_vel_param3 = filt_params{8,5};
                handles.params.e_vel_param4 = filt_params{8,6};
                handles.params.e_vel_param5 = filt_params{8,7};
                handles.params.e_vel_param6 = filt_params{8,8};
                
                handles.params.spline_sep_flag = filt_params{8,9};
                
                if ~isempty(filt_params{8,2})
                    switch filt_params{8,2}
                        
                        case 'Spline'
                            handles.CurrData.QPparams.qpr_routine = 1;
                            
                        case 'MovAvg'
                            handles.CurrData.QPparams.qpr_routine = 2;
                        case 'SGFilter'
                            handles.CurrData.QPparams.qpr_routine = 3;
                        case 'irlssmooth'
                            handles.CurrData.QPparams.qpr_routine = 4;
                            
                    end
                end
                
                if isempty(handles.params.e_vel_param3)
                    handles.thresholding_qpr_flag = false;
                else
                    handles.thresholding_qpr_flag = true;
                end
                
                [handles] = AngVel_Filt_Callback(handles);
                
            end
            
            % I actually saved this parameter in the 'handles.CurrData.QPparams'
            % structure. I should have done this more often...
            %     handles.CurrData.QPparams.qpr_routine
            
            % Check if the file used the UGQPR algorithm to allow the user to define QP
            % locations to spline over.
            if isfield(handles.CurrData.QPparams,'UGQPRarray') && ~isempty(handles.CurrData.QPparams.UGQPRarray)
                
                [handles] = UGQPR_go_Callback(handles);
                
            end
            
            % Check if the file used a Post-QPR spline filter.
            if size(filt_params,2)>9 && ~isempty(filt_params{8,10}) && isempty(strfind(filt_params{8,10},'N/A'))
                
                handles.params.post_qpr_filt_param1 = filt_params{8,10};
                [handles] = post_qpr_filt_Callback(handles);
            end
            
            %% Save VOMA file
            
            
            RootData(k) = handles.CurrData;
            RootData(k).RawFileName = RawName;
            
            handles.CurrData.RawFileName = RawName;
            
            %% Generate CycAvg Files
            
            if isfield(handles.CurrData,'cyc2plot') && ~isempty(handles.CurrData.cyc2plot)
                partnum = 6;
                part_txt = 'Generating Cycle Average Files';
                waitbar(((k-1)+(partnum/NumOfParts))/length(RootData),h_wb,sprintf(['File ' num2str(k) ' of ' num2str(length(RootData)) ': ' part_txt]))
                
                cd([ExpFolder '\Cyc_Avg'])
                
                load([SegmentName(1:end-4) '_CycleAvg.mat'])
                
                if isfield(handles.CurrData.VOMA_data,'UpSamp')
                    
                    
                    
                    handles.CurrData.VOMA_data.UpSamp.Data_LE_Vel_LARP = interp1(handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP,handles.CurrData.VOMA_data.UpSamp.Stim_t);
                    handles.CurrData.VOMA_data.UpSamp.Data_LE_Vel_RALP = interp1(handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP,handles.CurrData.VOMA_data.UpSamp.Stim_t);
                    handles.CurrData.VOMA_data.UpSamp.Data_LE_Vel_Z = interp1(handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z,handles.CurrData.VOMA_data.UpSamp.Stim_t);
                    
                    handles.CurrData.VOMA_data.UpSamp.Data_RE_Vel_LARP = interp1(handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP,handles.CurrData.VOMA_data.UpSamp.Stim_t);
                    handles.CurrData.VOMA_data.UpSamp.Data_RE_Vel_RALP = interp1(handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP,handles.CurrData.VOMA_data.UpSamp.Stim_t);
                    handles.CurrData.VOMA_data.UpSamp.Data_RE_Vel_Z = interp1(handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z,handles.CurrData.VOMA_data.UpSamp.Stim_t);
                    
                    RootData(k) = handles.CurrData;
                    
                    handles.Final_Data.Data_LE_Vel_LARP = handles.CurrData.VOMA_data.UpSamp.Data_LE_Vel_LARP;
                    handles.Final_Data.Data_LE_Vel_RALP = handles.CurrData.VOMA_data.UpSamp.Data_LE_Vel_RALP;
                    handles.Final_Data.Data_LE_Vel_Z = handles.CurrData.VOMA_data.UpSamp.Data_LE_Vel_Z;
                    
                    handles.Final_Data.Data_RE_Vel_LARP = handles.CurrData.VOMA_data.UpSamp.Data_RE_Vel_LARP;
                    handles.Final_Data.Data_RE_Vel_RALP = handles.CurrData.VOMA_data.UpSamp.Data_RE_Vel_RALP;
                    handles.Final_Data.Data_RE_Vel_Z = handles.CurrData.VOMA_data.UpSamp.Data_RE_Vel_Z;
                    
                    handles.Final_Data.Stim_Trace = handles.CurrData.VOMA_data.UpSamp.Stim_Trace;
                    
                    handles.Final_Data.Fs = handles.CurrData.VOMA_data.UpSamp.Fs;
                else
                    
                    handles.Final_Data.Data_LE_Vel_LARP = handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP;
                    handles.Final_Data.Data_LE_Vel_RALP = handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP;
                    handles.Final_Data.Data_LE_Vel_Z = handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z;
                    
                    handles.Final_Data.Data_RE_Vel_LARP = handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP;
                    handles.Final_Data.Data_RE_Vel_RALP = handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP;
                    handles.Final_Data.Data_RE_Vel_Z = handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z;
                    handles.Final_Data.Fs = handles.CurrData.VOMA_data.Fs;
                    
                    handles.Final_Data.Stim_Trace = handles.CurrData.VOMA_data.Stim_Trace;
                end
                
                % Initialize variables for each plane's cycles
                ll_cyc = [];
                lr_cyc = [];
                lz_cyc = [];
                
                rl_cyc = [];
                rr_cyc = [];
                rz_cyc = [];
                
                stim = [];
                
                if isfield(handles.CurrData.VOMA_data,'UpSamp')
                    eye_stim_ind = handles.CurrData.VOMA_data.UpSamp.stim_ind;
                    stim_ind = handles.CurrData.VOMA_data.UpSamp.stim_ind;
                else
                    try
                        eye_stim_ind = handles.CurrData.VOMA_data.eye_stim_ind;
                    catch
                        eye_stim_ind = handles.CurrData.VOMA_data.stim_ind;
                    end
                    stim_ind = handles.CurrData.VOMA_data.stim_ind;
                end
                % Extract data
                
                
                cyc2plot = handles.CurrData.cyc2plot;
                len = length(Results.ll_cycavg);
                handles.len_stim = len;
                for m=[cyc2plot']
                    ll_cyc = [ll_cyc ; handles.Final_Data.Data_LE_Vel_LARP(eye_stim_ind(m,1):eye_stim_ind(m,1) + len)'];
                    lr_cyc = [lr_cyc ; handles.Final_Data.Data_LE_Vel_RALP(eye_stim_ind(m,1):eye_stim_ind(m,1) + len)'];
                    lz_cyc = [lz_cyc ; handles.Final_Data.Data_LE_Vel_Z(eye_stim_ind(m,1):eye_stim_ind(m,1) + len)'];
                    
                    rl_cyc = [rl_cyc ; handles.Final_Data.Data_RE_Vel_LARP(eye_stim_ind(m,1):eye_stim_ind(m,1) + len)'];
                    rr_cyc = [rr_cyc ; handles.Final_Data.Data_RE_Vel_RALP(eye_stim_ind(m,1):eye_stim_ind(m,1) + len)'];
                    rz_cyc = [rz_cyc ; handles.Final_Data.Data_RE_Vel_Z(eye_stim_ind(m,1):eye_stim_ind(m,1) + len)'];
                    
                    stim = [stim ; handles.Final_Data.Stim_Trace(stim_ind(m,1):stim_ind(m,1) + handles.len_stim)'];
                end
                
                % Compute the cycle average
                ll_cycavg = mean(ll_cyc,1);
                lr_cycavg = mean(lr_cyc,1);
                lz_cycavg = mean(lz_cyc,1);
                
                rl_cycavg = mean(rl_cyc,1);
                rr_cycavg = mean(rr_cyc,1);
                rz_cycavg = mean(rz_cyc,1);
                
                % Compute the standard deviation
                ll_cycstd = std(ll_cyc,0,1);
                lr_cycstd = std(lr_cyc,0,1);
                lz_cycstd = std(lz_cyc,0,1);
                
                rl_cycstd = std(rl_cyc,0,1);
                rr_cycstd = std(rr_cyc,0,1);
                rz_cycstd = std(rz_cyc,0,1);
                
                % Save the data in a structure called 'Results'
                handles.Results.ll_cyc = ll_cyc;
                handles.Results.ll_cycavg = ll_cycavg;
                handles.Results.ll_cycstd = ll_cycstd;
                
                handles.Results.rl_cyc = rl_cyc;
                handles.Results.rl_cycavg = rl_cycavg;
                handles.Results.rl_cycstd = rl_cycstd;
                
                
                handles.Results.lr_cyc = lr_cyc;
                handles.Results.lr_cycavg = lr_cycavg;
                handles.Results.lr_cycstd = lr_cycstd;
                
                handles.Results.rr_cyc = rr_cyc;
                handles.Results.rr_cycavg = rr_cycavg;
                handles.Results.rr_cycstd = rr_cycstd;
                
                
                handles.Results.lz_cyc = lz_cyc;
                handles.Results.lz_cycavg = lz_cycavg;
                handles.Results.lz_cycstd = lz_cycstd;
                
                handles.Results.rz_cyc = rz_cyc;
                handles.Results.rz_cycavg = rz_cycavg;
                handles.Results.rz_cycstd = rz_cycstd;
                
                handles.Results.stim = stim;
                
                Results = handles.Results;
                Results.name = handles.CurrData.name;
                
                Results.raw_filename = RawName;
                
                Results.Parameters = handles.CurrData.VOMA_data.Parameters;
                Results.Fs = handles.Final_Data.Fs;
                Results.QPparams = handles.CurrData.QPparams;
                
%                 Results.SubjectID = Subject;
%                 Results.SubjectID(strfind(Results.SubjectID,'_')) = [];
%                 
%                 Results.VisitID = VisitNum;
%                 
%                 Results.Date = Date;
                
                Results.raw_start_t = Data.start_t;
                Results.raw_end_t = Data.end_t;
                
                if ~isempty(strfind(handles.CurrData.name,'.mat'))
                    save([handles.CurrData.name(1:end-4) '_CycleAvg.mat'],'Results')
                else
                    save([handles.CurrData.name '_CycleAvg.mat'],'Results')
                end
                Report{k,3} = {[SegmentName(1:end-4) '_CycleAvg']};
            end
            
        end
        
        %% Save RecaliVOMA file
        cd(VOMAPathName)
        partnum = 7;
        part_txt = 'Saving VOMA File';
        waitbar(((k-1)+(partnum/NumOfParts))/length(RootData),h_wb,sprintf(['File ' num2str(k) ' of ' num2str(length(RootData)) ': ' part_txt]))
        save([VOMAFileName(1:end-5) '_UpdatedVOGCalib_' date '_' num2str(DistanceToWall) 'in' '.voma'],'RootData')
        
        
    case {'EXIT',''}
        
        
end

end


function [handles] = AngVel_Filt_Callback(handles)
% hObject    handle to start_deseccade (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.thresholding_qpr_flag
    ThresholdQPRflag = true;
    
else
    ThresholdQPRflag = false;
end


% This code uses the custom 'desaccade' routine (specifically Version 3.
% This version of the code takes ina  data trace, splines over the whole
% trace, then checks if there is an input argument containing Quick Phase
% locations. If there is NOT, the routine finds QP locations based off of
% input parameters (outlined in the Help document for that routine) and
% then proceeds to spline over the QP locations. If the Quick Phase
% location argument IS present, the routine uses those locations to spline
% over the QPs. This was done so a user can essentially find QPs for the
% modulation canal (which typically has the largest quick phases) and then
% spline over those time points for ALL traces.

switch handles.CurrData.QPparams.qpr_routine
    case 1
        
        switch handles.params.spline_sep_flag
            
            case 1 % Detect splining options from the file being processed
                switch handles.CurrData.VOMA_data.Parameters.Stim_Info.ModCanal{1}
                    
                    
                    
                    case {'LA','LARP-Axis','LARP'}
                        if handles.LE_filt_flag
                            desaccade1 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                            desaccade2 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade1.QP_range);
                            desaccade3 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade1.QP_range);
                            desaccade4 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade1.QP_range);
                            desaccade5 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade1.QP_range);
                        end
                        
                        if handles.RE_filt_flag
                            desaccade6 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                            desaccade7 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade6.QP_range);
                            desaccade8 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade6.QP_range);
                            desaccade9 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade6.QP_range);
                            desaccade10 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade6.QP_range);
                        end
                    case {'LP','RALP-Axis','RALP'}
                        if handles.LE_filt_flag
                            desaccade2 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                            desaccade1 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade2.QP_range);
                            desaccade3 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade2.QP_range);
                            desaccade4 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade2.QP_range);
                            desaccade5 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade2.QP_range);
                        end
                        if handles.RE_filt_flag
                            desaccade7 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                            desaccade6 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade7.QP_range);
                            desaccade8 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade7.QP_range);
                            desaccade9 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade7.QP_range);
                            desaccade10 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade7.QP_range);
                        end
                    case {'LH','LHRH-Axis','LHRH'}
                        if handles.LE_filt_flag
                            desaccade3 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                            desaccade1 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade3.QP_range);
                            desaccade2 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade3.QP_range);
                            desaccade4 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade3.QP_range);
                            desaccade5 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade3.QP_range);
                        end
                        if handles.RE_filt_flag
                            desaccade8 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                            desaccade6 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade8.QP_range);
                            desaccade7 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade8.QP_range);
                            desaccade9 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade8.QP_range);
                            desaccade10 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade8.QP_range);
                        end
                    otherwise
                        if handles.LE_filt_flag
                            desaccade1 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                            desaccade2 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                            desaccade3 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                            desaccade4 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                            desaccade5 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                        end
                        if handles.RE_filt_flag
                            desaccade6 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                            desaccade7 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                            desaccade8 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                            desaccade9 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                            desaccade10 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                        end
                end
                
            case 2 % Spline each 3D component seperately
                if handles.LE_filt_flag
                    desaccade1 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                    desaccade2 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                    desaccade3 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                    desaccade4 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                    desaccade5 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                end
                if handles.RE_filt_flag
                    desaccade6 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                    desaccade7 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                    desaccade8 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                    desaccade9 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                    desaccade10 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                end
                
            case 3 % Spline the LARP component first, then use the QPs detected to spline the other components %or X component first
                if handles.LE_filt_flag
                    desaccade1 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                    desaccade2 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade1.QP_range);
                    desaccade3 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade1.QP_range);
                    desaccade4 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade1.QP_range);
                    desaccade5 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade1.QP_range);
                end
                if handles.RE_filt_flag
                    desaccade6 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                    desaccade7 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade6.QP_range);
                    desaccade8 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade6.QP_range);
                    desaccade9 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade6.QP_range);
                    desaccade10 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade6.QP_range);
                end
            case 4 % Spline the RALP component first, then use the QPs detected to spline the other components
                if handles.LE_filt_flag
                    desaccade2 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                    desaccade1 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade2.QP_range);
                    desaccade3 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade2.QP_range);
                    desaccade4 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade2.QP_range);
                    desaccade5 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade2.QP_range);
                end
                if handles.RE_filt_flag
                    desaccade7 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                    desaccade6 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade7.QP_range);
                    desaccade8 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade7.QP_range);
                    desaccade9 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade7.QP_range);
                    desaccade10 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade7.QP_range);
                end
            case 5 % Spline the LHRH component first, then use the QPs detected to spline the other components
                if handles.LE_filt_flag
                    desaccade3 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[]);
                    desaccade1 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade3.QP_range);
                    desaccade2 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade3.QP_range);
                    desaccade4 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade3.QP_range);
                    desaccade5 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade3.QP_range);
                end
                if handles.RE_filt_flag
                    desaccade8 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                    desaccade6 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade8.QP_range);
                    desaccade7 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade8.QP_range);
                    desaccade9 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade8.QP_range);
                    desaccade10 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade8.QP_range);
                end
            case 6 % Spline the X component first, then use the QPs detected to spline the other components
                if handles.LE_filt_flag
                    desaccade4 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                    desaccade1 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade4.QP_range);
                    desaccade3 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade4.QP_range);
                    desaccade2 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade4.QP_range);
                    desaccade5 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade4.QP_range);
                end
                if handles.RE_filt_flag
                    desaccade9 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                    desaccade6 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade9.QP_range);
                    desaccade8 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade9.QP_range);
                    desaccade7 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade9.QP_range);
                    desaccade10 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade9.QP_range);
                end
            case 7 % Spline the Y component first, then use the QPs detected to spline the other components
                if handles.LE_filt_flag
                    desaccade5 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[]);
                    desaccade1 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade5.QP_range);
                    desaccade2 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade5.QP_range);
                    desaccade4 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade5.QP_range);
                    desaccade3 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade5.QP_range);
                end
                if handles.RE_filt_flag
                    desaccade10 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                    desaccade6 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade10.QP_range);
                    desaccade7 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade10.QP_range);
                    desaccade9 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade10.QP_range);
                    desaccade8 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade10.QP_range);
                end
        end
        
        % Save the data after QP removal
        if handles.LE_filt_flag
            handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP = desaccade1.results;
            handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP = desaccade2.results;
            handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z = desaccade3.results;
            handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_X = desaccade4.results;
            handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Y = desaccade5.results;
        end
        if handles.RE_filt_flag
            handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP = desaccade6.results;
            handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP = desaccade7.results;
            handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z = desaccade8.results;
            handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_X = desaccade9.results;
            handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Y = desaccade10.results;
        end
        
        % Save the 'spline-only' data seperately for plotting purposes.
        if handles.LE_filt_flag
            handles.filter_noQPR.LE_Vel_LARP = desaccade1.smooth;
            handles.filter_noQPR.LE_Vel_RALP = desaccade2.smooth;
            handles.filter_noQPR.LE_Vel_Z = desaccade3.smooth;
            handles.filter_noQPR.LE_Vel_X = desaccade4.smooth;
            handles.filter_noQPR.LE_Vel_Y = desaccade5.smooth;
        end
        if handles.RE_filt_flag
            handles.filter_noQPR.RE_Vel_LARP = desaccade6.smooth;
            handles.filter_noQPR.RE_Vel_RALP = desaccade7.smooth;
            handles.filter_noQPR.RE_Vel_Z = desaccade8.smooth;
            handles.filter_noQPR.RE_Vel_X = desaccade9.smooth;
            handles.filter_noQPR.RE_Vel_Y = desaccade10.smooth;
        end
        if handles.LE_filt_flag
            handles.vel_deriv.LE_LARP = desaccade1.deriv;
            handles.vel_deriv.LE_RALP = desaccade2.deriv;
            handles.vel_deriv.LE_Z = desaccade3.deriv;
            handles.vel_deriv.LE_X = desaccade4.deriv;
            handles.vel_deriv.LE_Y = desaccade5.deriv;
        end
        if handles.RE_filt_flag
            handles.vel_deriv.RE_LARP = desaccade6.deriv;
            handles.vel_deriv.RE_RALP = desaccade7.deriv;
            handles.vel_deriv.RE_Z = desaccade8.deriv;
            handles.vel_deriv.RE_X = desaccade9.deriv;
            handles.vel_deriv.RE_Y = desaccade10.deriv;
        end
    case 2 % Simple, zero-phase moving average filter
        
        % Create a simple FIR mov. avg. LPF of the desired order.
        frame_len = handles.params.e_vel_param4;
        a = 1;
        b = ones(1,frame_len)/frame_len;
        gd = (frame_len-1)/2; % Calc. the group delay of the linear phase filter.
        % NOTE: We will not use 'filtfilt' here. We are using a linear
        % phase FIR filter and we can correct the phase manually while
        % avoiding the second pass of filter that is performed with the
        % 'filtfilt' routine.
        
        % Filter each eye velocity component and zero-pad
        % the end of the file to correct the phase
        % distortion of the mvoing average filter.
        if handles.LE_filt_flag
            LE_Vel_LARP = filter(b,a,handles.CurrData.VOMA_data.Data_LE_Vel_LARP);
            LE_Vel_LARP = [LE_Vel_LARP(gd+1:end) ; ones(gd,1)];
            LE_Vel_RALP = filter(b,a,handles.CurrData.VOMA_data.Data_LE_Vel_RALP);
            LE_Vel_RALP = [LE_Vel_RALP(gd+1:end) ; ones(gd,1)];
            LE_Vel_X = filter(b,a,handles.CurrData.VOMA_data.Data_LE_Vel_X);
            LE_Vel_X = [LE_Vel_X(gd+1:end) ; ones(gd,1)];
            LE_Vel_Y = filter(b,a,handles.CurrData.VOMA_data.Data_LE_Vel_Y);
            LE_Vel_Y = [LE_Vel_Y(gd+1:end) ; ones(gd,1)];
            LE_Vel_Z = filter(b,a,handles.CurrData.VOMA_data.Data_LE_Vel_Z);
            LE_Vel_Z = [LE_Vel_Z(gd+1:end) ; ones(gd,1)];
        end
        
        if handles.RE_filt_flag
            RE_Vel_LARP = filter(b,a,handles.CurrData.VOMA_data.Data_RE_Vel_LARP);
            RE_Vel_LARP = [RE_Vel_LARP(gd+1:end) ; ones(gd,1)];
            RE_Vel_RALP = filter(b,a,handles.CurrData.VOMA_data.Data_RE_Vel_RALP);
            RE_Vel_RALP = [RE_Vel_RALP(gd+1:end) ; ones(gd,1)];
            RE_Vel_X = filter(b,a,handles.CurrData.VOMA_data.Data_RE_Vel_X);
            RE_Vel_X = [RE_Vel_X(gd+1:end) ; ones(gd,1)];
            RE_Vel_Y = filter(b,a,handles.CurrData.VOMA_data.Data_RE_Vel_Y);
            RE_Vel_Y = [RE_Vel_Y(gd+1:end) ; ones(gd,1)];
            RE_Vel_Z = filter(b,a,handles.CurrData.VOMA_data.Data_RE_Vel_Z);
            RE_Vel_Z = [RE_Vel_Z(gd+1:end) ; ones(gd,1)];
        end
        
        
        E = 0; % This code instructs the 'desaccadedata' routine to NOT
        % apply any additional filtering to the input data.
        
        switch handles.params.spline_sep_flag
            case 1 % Detect splining options from the file being processed
                switch handles.CurrData.VOMA_data.Parameters.Stim_Info.ModCanal{1}
                    
                    case {'LA','LARP-Axis','LARP'}
                        if handles.LE_filt_flag
                            desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade1.QP_range);
                            desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade1.QP_range);
                            desaccade4 = voma__desaccadedata(LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade1.QP_range);
                            desaccade5 = voma__desaccadedata(LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade1.QP_range);
                        end
                        
                        if handles.RE_filt_flag
                            desaccade6 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade7 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade6.QP_range);
                            desaccade8 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade6.QP_range);
                            desaccade9 = voma__desaccadedata(RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade6.QP_range);
                            desaccade10 = voma__desaccadedata(RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade6.QP_range);
                        end
                    case {'LP','RALP-Axis','RALP'}
                        if handles.LE_filt_flag
                            desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade2.QP_range);
                            desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade2.QP_range);
                            desaccade4 = voma__desaccadedata(LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade2.QP_range);
                            desaccade5 = voma__desaccadedata(LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade2.QP_range);
                        end
                        if handles.RE_filt_flag
                            desaccade7 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade6 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade7.QP_range);
                            desaccade8 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade7.QP_range);
                            desaccade9 = voma__desaccadedata(RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade7.QP_range);
                            desaccade10 = voma__desaccadedata(RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade7.QP_range);
                        end
                    case {'LH','LHRH-Axis','LHRH'}
                        if handles.LE_filt_flag
                            desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade3.QP_range);
                            desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade3.QP_range);
                            desaccade4 = voma__desaccadedata(LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade3.QP_range);
                            desaccade5 = voma__desaccadedata(LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade3.QP_range);
                        end
                        if handles.RE_filt_flag
                            desaccade8 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade6 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade8.QP_range);
                            desaccade7 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade8.QP_range);
                            desaccade9 = voma__desaccadedata(RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade8.QP_range);
                            desaccade10 = voma__desaccadedata(RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade8.QP_range);
                        end
                    otherwise
                        if handles.LE_filt_flag
                            desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade4 = voma__desaccadedata(LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade5 = voma__desaccadedata(LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                        end
                        if handles.RE_filt_flag
                            desaccade6 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade7 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade8 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade9 = voma__desaccadedata(RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade10 = voma__desaccadedata(RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                        end
                end
                
            case 2 % run QPR on each 3D component seperately
                if handles.LE_filt_flag
                    desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade4 = voma__desaccadedata(LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade5 = voma__desaccadedata(LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                end
                if handles.RE_filt_flag
                    desaccade6 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade7 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade8 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade9 = voma__desaccadedata(RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade10 = voma__desaccadedata(RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                end
                
            case 3 % run QPR on the LARP component first, then use the QPs detected to run QPR on the other components %or X component first
                if handles.LE_filt_flag
                    desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade1.QP_range);
                    desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade1.QP_range);
                    desaccade4 = voma__desaccadedata(LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade1.QP_range);
                    desaccade5 = voma__desaccadedata(LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade1.QP_range);
                end
                if handles.RE_filt_flag
                    desaccade6 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade7 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade6.QP_range);
                    desaccade8 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade6.QP_range);
                    desaccade9 = voma__desaccadedata(RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade6.QP_range);
                    desaccade10 = voma__desaccadedata(RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade6.QP_range);
                end
            case 4 % run QPR on the RALP component first, then use the QPs detected to run QPR on the other components
                if handles.LE_filt_flag
                    desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade2.QP_range);
                    desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade2.QP_range);
                    desaccade4 = voma__desaccadedata(LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade2.QP_range);
                    desaccade5 = voma__desaccadedata(LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade2.QP_range);
                end
                if handles.RE_filt_flag
                    desaccade7 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade6 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade7.QP_range);
                    desaccade8 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade7.QP_range);
                    desaccade9 = voma__desaccadedata(RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade7.QP_range);
                    desaccade10 = voma__desaccadedata(RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade7.QP_range);
                end
            case 5 % run QPR on the LHRH component first, then use the QPs detected to run QPR on the other components
                if handles.LE_filt_flag
                    desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[]);
                    desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade3.QP_range);
                    desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade3.QP_range);
                    desaccade4 = voma__desaccadedata(LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade3.QP_range);
                    desaccade5 = voma__desaccadedata(LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade3.QP_range);
                end
                if handles.RE_filt_flag
                    desaccade8 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade6 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade8.QP_range);
                    desaccade7 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade8.QP_range);
                    desaccade9 = voma__desaccadedata(RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade8.QP_range);
                    desaccade10 = voma__desaccadedata(RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade8.QP_range);
                end
            case 6 % run QPR on the X component first, then use the QPs detected to run QPR on the other components
                if handles.LE_filt_flag
                    desaccade4 = voma__desaccadedata(LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade4.QP_range);
                    desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade4.QP_range);
                    desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade4.QP_range);
                    desaccade5 = voma__desaccadedata(LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade4.QP_range);
                end
                if handles.RE_filt_flag
                    desaccade9 = voma__desaccadedata(RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade6 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade9.QP_range);
                    desaccade8 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade9.QP_range);
                    desaccade7 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade9.QP_range);
                    desaccade10 = voma__desaccadedata(RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade9.QP_range);
                end
            case 7 % run QPR on the Y component first, then use the QPs detected to run QPR on the other components
                if handles.LE_filt_flag
                    desaccade5 = voma__desaccadedata(LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[]);
                    desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade5.QP_range);
                    desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade5.QP_range);
                    desaccade4 = voma__desaccadedata(LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade5.QP_range);
                    desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade5.QP_range);
                end
                if handles.RE_filt_flag
                    desaccade10 = voma__desaccadedata(RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade6 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade10.QP_range);
                    desaccade7 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade10.QP_range);
                    desaccade9 = voma__desaccadedata(RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade10.QP_range);
                    desaccade8 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade10.QP_range);
                end
        end
        
        % Save the data after QP removal
        if handles.LE_filt_flag
            handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP = desaccade1.results;
            handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP = desaccade2.results;
            handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z = desaccade3.results;
            handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_X = desaccade4.results;
            handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Y = desaccade5.results;
        end
        if handles.RE_filt_flag
            handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP = desaccade6.results;
            handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP = desaccade7.results;
            handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z = desaccade8.results;
            handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_X = desaccade9.results;
            handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Y = desaccade10.results;
        end
        
        % Save the 'spline-only' data seperately for plotting purposes.
        if handles.LE_filt_flag
            handles.filter_noQPR.LE_Vel_LARP = desaccade1.smooth;
            handles.filter_noQPR.LE_Vel_RALP = desaccade2.smooth;
            handles.filter_noQPR.LE_Vel_Z = desaccade3.smooth;
            handles.filter_noQPR.LE_Vel_X = desaccade4.smooth;
            handles.filter_noQPR.LE_Vel_Y = desaccade5.smooth;
        end
        if handles.RE_filt_flag
            handles.filter_noQPR.RE_Vel_LARP = desaccade6.smooth;
            handles.filter_noQPR.RE_Vel_RALP = desaccade7.smooth;
            handles.filter_noQPR.RE_Vel_Z = desaccade8.smooth;
            handles.filter_noQPR.RE_Vel_X = desaccade9.smooth;
            handles.filter_noQPR.RE_Vel_Y = desaccade10.smooth;
        end
        
        if handles.LE_filt_flag
            handles.vel_deriv.LE_LARP = desaccade1.deriv;
            handles.vel_deriv.LE_RALP = desaccade2.deriv;
            handles.vel_deriv.LE_Z = desaccade3.deriv;
            handles.vel_deriv.LE_X = desaccade4.deriv;
            handles.vel_deriv.LE_Y = desaccade5.deriv;
        end
        if handles.RE_filt_flag
            handles.vel_deriv.RE_LARP = desaccade6.deriv;
            handles.vel_deriv.RE_RALP = desaccade7.deriv;
            handles.vel_deriv.RE_Z = desaccade8.deriv;
            handles.vel_deriv.RE_X = desaccade9.deriv;
            handles.vel_deriv.RE_Y = desaccade10.deriv;
        end
        
    case 3 %S.G. Filter
        
        if handles.LE_filt_flag
            LE_Vel_LARP = sgolayfilt(handles.CurrData.VOMA_data.Data_LE_Vel_LARP,handles.params.e_vel_param6,handles.params.e_vel_param4);
            LE_Vel_RALP = sgolayfilt(handles.CurrData.VOMA_data.Data_LE_Vel_RALP,handles.params.e_vel_param6,handles.params.e_vel_param4);
            LE_Vel_X = sgolayfilt(handles.CurrData.VOMA_data.Data_LE_Vel_X,handles.params.e_vel_param6,handles.params.e_vel_param4);
            LE_Vel_Y = sgolayfilt(handles.CurrData.VOMA_data.Data_LE_Vel_Y,handles.params.e_vel_param6,handles.params.e_vel_param4);
            LE_Vel_Z = sgolayfilt(handles.CurrData.VOMA_data.Data_LE_Vel_Z,handles.params.e_vel_param6,handles.params.e_vel_param4);
        end
        if handles.RE_filt_flag
            RE_Vel_LARP = sgolayfilt(handles.CurrData.VOMA_data.Data_RE_Vel_LARP,handles.params.e_vel_param6,handles.params.e_vel_param4);
            RE_Vel_RALP = sgolayfilt(handles.CurrData.VOMA_data.Data_RE_Vel_RALP,handles.params.e_vel_param6,handles.params.e_vel_param4);
            RE_Vel_X = sgolayfilt(handles.CurrData.VOMA_data.Data_RE_Vel_X,handles.params.e_vel_param6,handles.params.e_vel_param4);
            RE_Vel_Y = sgolayfilt(handles.CurrData.VOMA_data.Data_RE_Vel_Y,handles.params.e_vel_param6,handles.params.e_vel_param4);
            RE_Vel_Z = sgolayfilt(handles.CurrData.VOMA_data.Data_RE_Vel_Z,handles.params.e_vel_param6,handles.params.e_vel_param4);
        end
        
        E = 0; % This code instructs the 'desaccadedata' routine to NOT
        % apply any additional filtering to the input data.
        
        switch handles.params.spline_sep_flag
            case 1 % Detect splining options from the file being processed
                switch handles.CurrData.VOMA_data.Parameters.Stim_Info.ModCanal{1}
                    
                    case {'LA','LARP-Axis','LARP'}
                        if handles.LE_filt_flag
                            desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade1.QP_range);
                            desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade1.QP_range);
                            desaccade4 = voma__desaccadedata(LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade1.QP_range);
                            desaccade5 = voma__desaccadedata(LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade1.QP_range);
                        end
                        if handles.RE_filt_flag
                            desaccade6 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade7 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade6.QP_range);
                            desaccade8 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade6.QP_range);
                            desaccade9 = voma__desaccadedata(RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade6.QP_range);
                            desaccade10 = voma__desaccadedata(RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade6.QP_range);
                        end
                    case {'LP','RALP-Axis','RALP'}
                        if handles.LE_filt_flag
                            desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade2.QP_range);
                            desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade2.QP_range);
                            desaccade4 = voma__desaccadedata(LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade2.QP_range);
                            desaccade5 = voma__desaccadedata(LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade2.QP_range);
                        end
                        if handles.RE_filt_flag
                            desaccade7 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade6 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade7.QP_range);
                            desaccade8 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade7.QP_range);
                            desaccade9 = voma__desaccadedata(RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade7.QP_range);
                            desaccade10 = voma__desaccadedata(RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade7.QP_range);
                        end
                    case {'LH','LHRH-Axis','LHRH'}
                        if handles.LE_filt_flag
                            desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade3.QP_range);
                            desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade3.QP_range);
                            desaccade4 = voma__desaccadedata(LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade3.QP_range);
                            desaccade5 = voma__desaccadedata(LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade3.QP_range);
                        end
                        if handles.RE_filt_flag
                            desaccade8 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade6 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade8.QP_range);
                            desaccade7 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade8.QP_range);
                            desaccade9 = voma__desaccadedata(RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade8.QP_range);
                            desaccade10 = voma__desaccadedata(RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade8.QP_range);
                        end
                    otherwise
                        if handles.LE_filt_flag
                            desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade4 = voma__desaccadedata(LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade5 = voma__desaccadedata(LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                        end
                        if handles.RE_filt_flag
                            desaccade6 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade7 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade8 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade9 = voma__desaccadedata(RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade10 = voma__desaccadedata(RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                        end
                end
                
            case 2 % run QPR on each 3D component seperately
                if handles.LE_filt_flag
                    desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade4 = voma__desaccadedata(LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade5 = voma__desaccadedata(LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                end
                if handles.RE_filt_flag
                    desaccade6 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade7 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade8 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade9 = voma__desaccadedata(RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade10 = voma__desaccadedata(RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                end
                
            case 3 % run QPR on the LARP component first, then use the QPs detected to run QPR on the other components %or X component first
                if handles.LE_filt_flag
                    desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade1.QP_range);
                    desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade1.QP_range);
                    desaccade4 = voma__desaccadedata(LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade1.QP_range);
                    desaccade5 = voma__desaccadedata(LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade1.QP_range);
                end
                if handles.RE_filt_flag
                    desaccade6 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade7 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade6.QP_range);
                    desaccade8 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade6.QP_range);
                    desaccade9 = voma__desaccadedata(RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade6.QP_range);
                    desaccade10 = voma__desaccadedata(RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade6.QP_range);
                end
            case 4 % run QPR on the RALP component first, then use the QPs detected to run QPR on the other components
                if handles.LE_filt_flag
                    desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade2.QP_range);
                    desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade2.QP_range);
                    desaccade4 = voma__desaccadedata(LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade2.QP_range);
                    desaccade5 = voma__desaccadedata(LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade2.QP_range);
                end
                if handles.RE_filt_flag
                    desaccade7 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade6 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade7.QP_range);
                    desaccade8 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade7.QP_range);
                    desaccade9 = voma__desaccadedata(RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade7.QP_range);
                    desaccade10 = voma__desaccadedata(RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade7.QP_range);
                end
            case 5 % run QPR on the LHRH component first, then use the QPs detected to run QPR on the other components
                if handles.LE_filt_flag
                    desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[]);
                    desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade3.QP_range);
                    desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade3.QP_range);
                    desaccade4 = voma__desaccadedata(LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade3.QP_range);
                    desaccade5 = voma__desaccadedata(LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade3.QP_range);
                end
                if handles.RE_filt_flag
                    desaccade8 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade6 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade8.QP_range);
                    desaccade7 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade8.QP_range);
                    desaccade9 = voma__desaccadedata(RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade8.QP_range);
                    desaccade10 = voma__desaccadedata(RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade8.QP_range);
                end
            case 6 % run QPR on the X component first, then use the QPs detected to run QPR on the other components
                if handles.LE_filt_flag
                    desaccade4 = voma__desaccadedata(LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade4.QP_range);
                    desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade4.QP_range);
                    desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade4.QP_range);
                    desaccade5 = voma__desaccadedata(LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade4.QP_range);
                end
                if handles.RE_filt_flag
                    desaccade9 = voma__desaccadedata(RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade6 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade9.QP_range);
                    desaccade8 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade9.QP_range);
                    desaccade7 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade9.QP_range);
                    desaccade10 = voma__desaccadedata(RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade9.QP_range);
                end
            case 7 % run QPR on the Y component first, then use the QPs detected to run QPR on the other components
                if handles.LE_filt_flag
                    desaccade5 = voma__desaccadedata(LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[]);
                    desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade5.QP_range);
                    desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade5.QP_range);
                    desaccade4 = voma__desaccadedata(LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade5.QP_range);
                    desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade5.QP_range);
                end
                
                if handles.RE_filt_flag
                    desaccade10 = voma__desaccadedata(RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade6 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade10.QP_range);
                    desaccade7 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade10.QP_range);
                    desaccade9 = voma__desaccadedata(RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade10.QP_range);
                    desaccade8 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade10.QP_range);
                end
        end
        
        % Save the data after QP removal
        if handles.LE_filt_flag
            handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP = desaccade1.results;
            handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP = desaccade2.results;
            handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z = desaccade3.results;
            handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_X = desaccade4.results;
            handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Y = desaccade5.results;
        end
        if handles.RE_filt_flag
            handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP = desaccade6.results;
            handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP = desaccade7.results;
            handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z = desaccade8.results;
            handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_X = desaccade9.results;
            handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Y = desaccade10.results;
        end
        
        % Save the 'spline-only' data seperately for plotting purposes.
        if handles.LE_filt_flag
            handles.filter_noQPR.LE_Vel_LARP = desaccade1.smooth;
            handles.filter_noQPR.LE_Vel_RALP = desaccade2.smooth;
            handles.filter_noQPR.LE_Vel_Z = desaccade3.smooth;
            handles.filter_noQPR.LE_Vel_X = desaccade4.smooth;
            handles.filter_noQPR.LE_Vel_Y = desaccade5.smooth;
        end
        if handles.RE_filt_flag
            handles.filter_noQPR.RE_Vel_LARP = desaccade6.smooth;
            handles.filter_noQPR.RE_Vel_RALP = desaccade7.smooth;
            handles.filter_noQPR.RE_Vel_Z = desaccade8.smooth;
            handles.filter_noQPR.RE_Vel_X = desaccade9.smooth;
            handles.filter_noQPR.RE_Vel_Y = desaccade10.smooth;
        end
        
        if handles.LE_filt_flag
            handles.vel_deriv.LE_LARP = desaccade1.deriv;
            handles.vel_deriv.LE_RALP = desaccade2.deriv;
            handles.vel_deriv.LE_Z = desaccade3.deriv;
            handles.vel_deriv.LE_X = desaccade4.deriv;
            handles.vel_deriv.LE_Y = desaccade5.deriv;
        end
        if handles.RE_filt_flag
            handles.vel_deriv.RE_LARP = desaccade6.deriv;
            handles.vel_deriv.RE_RALP = desaccade7.deriv;
            handles.vel_deriv.RE_Z = desaccade8.deriv;
            handles.vel_deriv.RE_X = desaccade9.deriv;
            handles.vel_deriv.RE_Y = desaccade10.deriv;
        end
    case 4 % irlssmooth
        
        if handles.LE_filt_flag
            LE_Vel_LARP = handles.CurrData.VOMA_data.Data_LE_Vel_LARP;
            inds = [1:length(LE_Vel_LARP)];
            LE_Vel_LARP(isnan(LE_Vel_LARP)) = interp1(inds(~isnan(LE_Vel_LARP)),LE_Vel_LARP(~isnan(LE_Vel_LARP)),inds(isnan(LE_Vel_LARP)));
            if isnan(LE_Vel_LARP(1))
                non_nan = inds(~isnan(LE_Vel_LARP));
                LE_Vel_LARP(1:non_nan(1)-1) = LE_Vel_LARP(non_nan(1));
            end
            if isnan(LE_Vel_LARP(end))
                non_nan = inds(~isnan(LE_Vel_LARP));
                LE_Vel_LARP(non_nan(end)+1:end) = LE_Vel_LARP(non_nan(end));
            end
            LE_Vel_LARP = voma__irlssmooth(LE_Vel_LARP,handles.params.e_vel_param4);
            
            LE_Vel_RALP = handles.CurrData.VOMA_data.Data_LE_Vel_RALP;
            inds = [1:length(LE_Vel_RALP)];
            LE_Vel_RALP(isnan(LE_Vel_RALP)) = interp1(inds(~isnan(LE_Vel_RALP)),LE_Vel_RALP(~isnan(LE_Vel_RALP)),inds(isnan(LE_Vel_RALP)));
            if isnan(LE_Vel_RALP(1))
                non_nan = inds(~isnan(LE_Vel_RALP));
                LE_Vel_RALP(1:non_nan(1)-1) = LE_Vel_RALP(non_nan(1));
            end
            if isnan(LE_Vel_RALP(end))
                non_nan = inds(~isnan(LE_Vel_RALP));
                LE_Vel_RALP(non_nan(end)+1:end) = LE_Vel_RALP(non_nan(end));
            end
            LE_Vel_RALP = voma__irlssmooth(LE_Vel_RALP,handles.params.e_vel_param4);
            
            LE_Vel_X = handles.CurrData.VOMA_data.Data_LE_Vel_X;
            inds = [1:length(LE_Vel_X)];
            LE_Vel_X(isnan(LE_Vel_X)) = interp1(inds(~isnan(LE_Vel_X)),LE_Vel_LARP(~isnan(LE_Vel_X)),inds(isnan(LE_Vel_X)));
            if isnan(LE_Vel_X(1))
                non_nan = inds(~isnan(LE_Vel_X));
                LE_Vel_X(1:non_nan(1)-1) = LE_Vel_X(non_nan(1));
            end
            if isnan(LE_Vel_X(end))
                non_nan = inds(~isnan(LE_Vel_X));
                LE_Vel_X(non_nan(end)+1:end) = LE_Vel_X(non_nan(end));
            end
            LE_Vel_X = voma__irlssmooth(LE_Vel_X,handles.params.e_vel_param4);
            
            LE_Vel_Y = handles.CurrData.VOMA_data.Data_LE_Vel_Y;
            inds = [1:length(LE_Vel_Y)];
            LE_Vel_Y(isnan(LE_Vel_Y)) = interp1(inds(~isnan(LE_Vel_Y)),LE_Vel_Y(~isnan(LE_Vel_Y)),inds(isnan(LE_Vel_Y)));
            if isnan(LE_Vel_Y(1))
                non_nan = inds(~isnan(LE_Vel_Y));
                LE_Vel_Y(1:non_nan(1)-1) = LE_Vel_Y(non_nan(1));
            end
            if isnan(LE_Vel_Y(end))
                non_nan = inds(~isnan(LE_Vel_Y));
                LE_Vel_Y(non_nan(end)+1:end) = LE_Vel_Y(non_nan(end));
            end
            LE_Vel_Y = voma__irlssmooth(LE_Vel_Y,handles.params.e_vel_param4);
            
            LE_Vel_Z = handles.CurrData.VOMA_data.Data_LE_Vel_Z;
            inds = [1:length(LE_Vel_Z)];
            LE_Vel_Z(isnan(LE_Vel_Z)) = interp1(inds(~isnan(LE_Vel_Z)),LE_Vel_Z(~isnan(LE_Vel_Z)),inds(isnan(LE_Vel_Z)));
            if isnan(LE_Vel_Z(1))
                non_nan = inds(~isnan(LE_Vel_Z));
                LE_Vel_Z(1:non_nan(1)-1) = LE_Vel_Z(non_nan(1));
            end
            if isnan(LE_Vel_Z(end))
                non_nan = inds(~isnan(LE_Vel_Z));
                LE_Vel_Z(non_nan(end)+1:end) = LE_Vel_Z(non_nan(end));
            end
            LE_Vel_Z = voma__irlssmooth(LE_Vel_Z,handles.params.e_vel_param4);
        end
        
        if handles.RE_filt_flag
            RE_Vel_LARP = handles.CurrData.VOMA_data.Data_RE_Vel_LARP;
            inds = [1:length(RE_Vel_LARP)];
            RE_Vel_LARP(isnan(RE_Vel_LARP)) = interp1(inds(~isnan(RE_Vel_LARP)),RE_Vel_LARP(~isnan(RE_Vel_LARP)),inds(isnan(RE_Vel_LARP)));
            if isnan(RE_Vel_LARP(1))
                non_nan = inds(~isnan(RE_Vel_LARP));
                RE_Vel_LARP(1:non_nan(1)-1) = RE_Vel_LARP(non_nan(1));
            end
            if isnan(RE_Vel_LARP(end))
                non_nan = inds(~isnan(RE_Vel_LARP));
                RE_Vel_LARP(non_nan(end)+1:end) = RE_Vel_LARP(non_nan(end));
            end
            RE_Vel_LARP = voma__irlssmooth(RE_Vel_LARP,handles.params.e_vel_param4);
            
            RE_Vel_RALP = handles.CurrData.VOMA_data.Data_RE_Vel_RALP;
            inds = [1:length(RE_Vel_RALP)];
            RE_Vel_RALP(isnan(RE_Vel_RALP)) = interp1(inds(~isnan(RE_Vel_RALP)),RE_Vel_RALP(~isnan(RE_Vel_RALP)),inds(isnan(RE_Vel_RALP)));
            if isnan(RE_Vel_RALP(1))
                non_nan = inds(~isnan(RE_Vel_RALP));
                RE_Vel_RALP(1:non_nan(1)-1) = RE_Vel_RALP(non_nan(1));
            end
            if isnan(RE_Vel_RALP(end))
                non_nan = inds(~isnan(RE_Vel_RALP));
                RE_Vel_RALP(non_nan(end)+1:end) = RE_Vel_RALP(non_nan(end));
            end
            RE_Vel_RALP = voma__irlssmooth(RE_Vel_RALP,handles.params.e_vel_param4);
            
            RE_Vel_X = handles.CurrData.VOMA_data.Data_RE_Vel_X;
            inds = [1:length(RE_Vel_X)];
            RE_Vel_X(isnan(RE_Vel_X)) = interp1(inds(~isnan(RE_Vel_X)),RE_Vel_X(~isnan(RE_Vel_X)),inds(isnan(RE_Vel_X)));
            if isnan(RE_Vel_X(1))
                non_nan = inds(~isnan(RE_Vel_X));
                RE_Vel_X(1:non_nan(1)-1) = RE_Vel_X(non_nan(1));
            end
            if isnan(RE_Vel_X(end))
                non_nan = inds(~isnan(RE_Vel_X));
                RE_Vel_X(non_nan(end)+1:end) = RE_Vel_X(non_nan(end));
            end
            RE_Vel_X = voma__irlssmooth(RE_Vel_X,handles.params.e_vel_param4);
            
            RE_Vel_Y = handles.CurrData.VOMA_data.Data_RE_Vel_Y;
            inds = [1:length(RE_Vel_Y)];
            RE_Vel_Y(isnan(RE_Vel_Y)) = interp1(inds(~isnan(RE_Vel_Y)),RE_Vel_Y(~isnan(RE_Vel_Y)),inds(isnan(RE_Vel_Y)));
            if isnan(RE_Vel_Y(1))
                non_nan = inds(~isnan(RE_Vel_Y));
                RE_Vel_Y(1:non_nan(1)-1) = RE_Vel_Y(non_nan(1));
            end
            if isnan(RE_Vel_Y(end))
                non_nan = inds(~isnan(RE_Vel_Y));
                RE_Vel_Y(non_nan(end)+1:end) = RE_Vel_Y(non_nan(end));
            end
            RE_Vel_Y = voma__irlssmooth(RE_Vel_Y,handles.params.e_vel_param4);
            
            RE_Vel_Z = handles.CurrData.VOMA_data.Data_RE_Vel_Z;
            inds = [1:length(RE_Vel_Z)];
            RE_Vel_Z(isnan(RE_Vel_Z)) = interp1(inds(~isnan(RE_Vel_Z)),RE_Vel_Z(~isnan(RE_Vel_Z)),inds(isnan(RE_Vel_Z)));
            if isnan(RE_Vel_Z(1))
                non_nan = inds(~isnan(RE_Vel_Z));
                RE_Vel_Z(1:non_nan(1)-1) = RE_Vel_Z(non_nan(1));
            end
            if isnan(RE_Vel_Z(end))
                non_nan = inds(~isnan(RE_Vel_Z));
                RE_Vel_Z(non_nan(end)+1:end) = RE_Vel_Z(non_nan(end));
            end
            RE_Vel_Z = voma__irlssmooth(RE_Vel_Z,handles.params.e_vel_param4);
        end
        
        
        E = 0; % This code instructs the 'desaccadedata' routine to NOT
        % apply any additional filtering to the input data.
        
        switch handles.params.spline_sep_flag
            case 1 % Detect splining options from the file being processed
                switch handles.CurrData.VOMA_data.Parameters.Stim_Info.ModCanal{1}
                    
                    case {'LA','LARP-Axis','LARP'}
                        if handles.LE_filt_flag
                            desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade1.QP_range);
                            desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade1.QP_range);
                            desaccade4 = voma__desaccadedata(LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade1.QP_range);
                            desaccade5 = voma__desaccadedata(LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade1.QP_range);
                        end
                        if handles.RE_filt_flag
                            desaccade6 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade7 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade6.QP_range);
                            desaccade8 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade6.QP_range);
                            desaccade9 = voma__desaccadedata(RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade6.QP_range);
                            desaccade10 = voma__desaccadedata(RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade6.QP_range);
                        end
                    case {'LP','RALP-Axis','RALP'}
                        if handles.LE_filt_flag
                            desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade2.QP_range);
                            desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade2.QP_range);
                            desaccade4 = voma__desaccadedata(LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade2.QP_range);
                            desaccade5 = voma__desaccadedata(LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade2.QP_range);
                        end
                        if handles.RE_filt_flag
                            desaccade7 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade6 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade7.QP_range);
                            desaccade8 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade7.QP_range);
                            desaccade9 = voma__desaccadedata(RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade7.QP_range);
                            desaccade10 = voma__desaccadedata(RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade7.QP_range);
                        end
                    case {'LH','LHRH-Axis','LHRH'}
                        if handles.LE_filt_flag
                            desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade3.QP_range);
                            desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade3.QP_range);
                            desaccade4 = voma__desaccadedata(LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade3.QP_range);
                            desaccade5 = voma__desaccadedata(LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade3.QP_range);
                        end
                        if handles.RE_filt_flag
                            desaccade8 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade6 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade8.QP_range);
                            desaccade7 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade8.QP_range);
                            desaccade9 = voma__desaccadedata(RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade8.QP_range);
                            desaccade10 = voma__desaccadedata(RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade8.QP_range);
                        end
                    otherwise
                        if handles.LE_filt_flag
                            desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade4 = voma__desaccadedata(LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade5 = voma__desaccadedata(LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                        end
                        if handles.RE_filt_flag
                            desaccade6 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade7 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade8 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade9 = voma__desaccadedata(RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                            desaccade10 = voma__desaccadedata(RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                        end
                end
                
            case 2 % Run QPR on each 3D component seperately
                if handles.LE_filt_flag
                    desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade4 = voma__desaccadedata(LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade5 = voma__desaccadedata(LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                end
                if handles.RE_filt_flag
                    desaccade6 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade7 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade8 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade9 = voma__desaccadedata(RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade10 = voma__desaccadedata(RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                end
                
            case 3 % Run QPR on the LARP component first, then use the QPs detected to run QPR on the other components %or X component first
                if handles.LE_filt_flag
                    desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade1.QP_range);
                    desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade1.QP_range);
                    desaccade4 = voma__desaccadedata(LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade1.QP_range);
                    desaccade5 = voma__desaccadedata(LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade1.QP_range);
                end
                if handles.RE_filt_flag
                    desaccade6 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade7 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade6.QP_range);
                    desaccade8 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade6.QP_range);
                    desaccade9 = voma__desaccadedata(RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade6.QP_range);
                    desaccade10 = voma__desaccadedata(RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade6.QP_range);
                end
            case 4 % run QPR on the RALP component first, then use the QPs detected to run QPR on the other components
                if handles.LE_filt_flag
                    desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade2.QP_range);
                    desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade2.QP_range);
                    desaccade4 = voma__desaccadedata(LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade2.QP_range);
                    desaccade5 = voma__desaccadedata(LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade2.QP_range);
                end
                if handles.RE_filt_flag
                    desaccade7 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade6 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade7.QP_range);
                    desaccade8 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade7.QP_range);
                    desaccade9 = voma__desaccadedata(RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade7.QP_range);
                    desaccade10 = voma__desaccadedata(RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade7.QP_range);
                end
            case 5 % run QPR on the LHRH component first, then use the QPs detected to run QPR on the other components
                if handles.LE_filt_flag
                    desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[]);
                    desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade3.QP_range);
                    desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade3.QP_range);
                    desaccade4 = voma__desaccadedata(LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade3.QP_range);
                    desaccade5 = voma__desaccadedata(LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade3.QP_range);
                end
                if handles.RE_filt_flag
                    desaccade8 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade6 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade8.QP_range);
                    desaccade7 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade8.QP_range);
                    desaccade9 = voma__desaccadedata(RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade8.QP_range);
                    desaccade10 = voma__desaccadedata(RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade8.QP_range);
                end
            case 6 % run QPR on the X component first, then use the QPs detected to run QPR on the other components
                if handles.LE_filt_flag
                    desaccade4 = voma__desaccadedata(LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade4.QP_range);
                    desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade4.QP_range);
                    desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade4.QP_range);
                    desaccade5 = voma__desaccadedata(LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade4.QP_range);
                end
                if handles.RE_filt_flag
                   desaccade9 = voma__desaccadedata(RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade6 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade9.QP_range);
                    desaccade8 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade9.QP_range);
                    desaccade7 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade9.QP_range);
                    desaccade10 = voma__desaccadedata(RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade9.QP_range);
                end
            case 7 % run QPR on the Y component first, then use the QPs detected to run QPR on the other components
                if handles.LE_filt_flag
                    desaccade5 = voma__desaccadedata(LE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[]);
                    desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade5.QP_range);
                    desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade5.QP_range);
                    desaccade4 = voma__desaccadedata(LE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade5.QP_range);
                    desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade5.QP_range);
                end
                if handles.RE_filt_flag
                   desaccade10 = voma__desaccadedata(RE_Vel_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag);
                    desaccade6 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade10.QP_range);
                    desaccade7 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade10.QP_range);
                    desaccade9 = voma__desaccadedata(RE_Vel_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade10.QP_range);
                    desaccade8 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,ThresholdQPRflag,[],desaccade10.QP_range);
                end
        end
        
        % Save the data after QP removal
        if handles.LE_filt_flag
            handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP = desaccade1.results;
            handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP = desaccade2.results;
            handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z = desaccade3.results;
            handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_X = desaccade4.results;
            handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Y = desaccade5.results;
        end
        if handles.RE_filt_flag
            handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP = desaccade6.results;
            handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP = desaccade7.results;
            handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z = desaccade8.results;
            handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_X = desaccade9.results;
            handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Y = desaccade10.results;
        end
        
        % Save the 'spline-only' data seperately for plotting purposes.
        if handles.LE_filt_flag
            handles.filter_noQPR.LE_Vel_LARP = desaccade1.smooth;
            handles.filter_noQPR.LE_Vel_RALP = desaccade2.smooth;
            handles.filter_noQPR.LE_Vel_Z = desaccade3.smooth;
            handles.filter_noQPR.LE_Vel_X = desaccade4.smooth;
            handles.filter_noQPR.LE_Vel_Y = desaccade5.smooth;
        end
        if handles.RE_filt_flag
            handles.filter_noQPR.RE_Vel_LARP = desaccade6.smooth;
            handles.filter_noQPR.RE_Vel_RALP = desaccade7.smooth;
            handles.filter_noQPR.RE_Vel_Z = desaccade8.smooth;
            handles.filter_noQPR.RE_Vel_X = desaccade9.smooth;
            handles.filter_noQPR.RE_Vel_Y = desaccade10.smooth;
        end
        
        if handles.LE_filt_flag
            handles.vel_deriv.LE_LARP = desaccade1.deriv;
            handles.vel_deriv.LE_RALP = desaccade2.deriv;
            handles.vel_deriv.LE_Z = desaccade3.deriv;
            handles.vel_deriv.LE_X = desaccade4.deriv;
            handles.vel_deriv.LE_Y = desaccade5.deriv;
        end
        if handles.RE_filt_flag
            handles.vel_deriv.RE_LARP = desaccade6.deriv;
            handles.vel_deriv.RE_RALP = desaccade7.deriv;
            handles.vel_deriv.RE_Z = desaccade8.deriv;
            handles.vel_deriv.RE_X = desaccade9.deriv;
            handles.vel_deriv.RE_Y = desaccade10.deriv;
        end
        
        
        
end

end


% --- Executes on button press in UGQPR_go.
function [handles] = UGQPR_go_Callback(handles)
% hObject    handle to UGQPR_go (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


for n=1:size(handles.CurrData.QPparams.UGQPRarray,1)
    
    k1 = handles.CurrData.QPparams.UGQPRarray(n,1);
    k2 = handles.CurrData.QPparams.UGQPRarray(n,2);
    
    handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP(k1:k2)=spline([k1 k2],[0 handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP(k1) handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP(k2) 0], k1:k2);
    handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP(k1:k2)=spline([k1 k2],[0 handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP(k1) handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP(k2) 0], k1:k2);
    handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z(k1:k2)=spline([k1 k2],[0 handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z(k1) handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z(k2) 0], k1:k2);
    handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_X(k1:k2)=spline([k1 k2],[0 handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_X(k1) handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_X(k2) 0], k1:k2);
    handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Y(k1:k2)=spline([k1 k2],[0 handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Y(k1) handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Y(k2) 0], k1:k2);
    
    handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP(k1:k2)=spline([k1 k2],[0 handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP(k1) handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP(k2) 0], k1:k2);
    handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP(k1:k2)=spline([k1 k2],[0 handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP(k1) handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP(k2) 0], k1:k2);
    handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z(k1:k2)=spline([k1 k2],[0 handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z(k1) handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z(k2) 0], k1:k2);
    handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_X(k1:k2)=spline([k1 k2],[0 handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_X(k1) handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_X(k2) 0], k1:k2);
    handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Y(k1:k2)=spline([k1 k2],[0 handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Y(k1) handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Y(k2) 0], k1:k2);
    
end

end

function [handles] = post_qpr_filt_Callback(handles)
% hObject    handle to post_qpr_filt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP=voma__smooth([1:length(handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP)]',handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP,handles.params.post_qpr_filt_param1,[1:length(handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP)]');
handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP=voma__smooth([1:length(handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP)]',handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP,handles.params.post_qpr_filt_param1,[1:length(handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP)]');
handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z=voma__smooth([1:length(handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z)]',handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z,handles.params.post_qpr_filt_param1,[1:length(handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z)]');
handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_X=voma__smooth([1:length(handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_X)]',handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_X,handles.params.post_qpr_filt_param1,[1:length(handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_X)]');
handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Y=voma__smooth([1:length(handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Y)]',handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Y,handles.params.post_qpr_filt_param1,[1:length(handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Y)]');

handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP=voma__smooth([1:length(handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP)]',handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP,handles.params.post_qpr_filt_param1,[1:length(handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP)]');
handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP=voma__smooth([1:length(handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP)]',handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP,handles.params.post_qpr_filt_param1,[1:length(handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP)]');
handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z=voma__smooth([1:length(handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z)]',handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z,handles.params.post_qpr_filt_param1,[1:length(handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z)]');
handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_X=voma__smooth([1:length(handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_X)]',handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_X,handles.params.post_qpr_filt_param1,[1:length(handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_X)]');
handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Y=voma__smooth([1:length(handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Y)]',handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Y,handles.params.post_qpr_filt_param1,[1:length(handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Y)]');

end

% --- Executes on button press in apply_angpos_filt.
function [handles] = apply_angpos_filt_Callback(handles)
% hObject    handle to apply_angpos_filt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



switch handles.params.pos_filt_trace
    
    case 1
        temp = handles.CurrData.VOMA_data.Data_LE_Pos_X;
    case 2
        temp = handles.CurrData.VOMA_data.Data_LE_Pos_Y;
    case 3
        temp = handles.CurrData.VOMA_data.Data_LE_Pos_Z;
    case 4
        temp = handles.CurrData.VOMA_data.Data_RE_Pos_X;
    case 5
        temp = handles.CurrData.VOMA_data.Data_RE_Pos_Y;
    case 6
        temp = handles.CurrData.VOMA_data.Data_RE_Pos_Z;
end

switch handles.params.pos_filt_method
    
    case 1
        temp_smth = sgolayfilt(temp,handles.params.angpos_filt_param1,handles.params.angpos_filt_param2);
        
    case 2
        temp(isnan(temp)) = 0;
        [envHigh, envLow] = envelope(temp,handles.params.angpos_filt_param1,'peak');
        
        
        
    case 3
        
        temp_smth = medfilt1(temp,handles.params.angpos_filt_param1);
        
        
    case 4 % irlssmooth
        
        
        inds = [1:length(temp)];
        temp(isnan(temp)) = interp1(inds(~isnan(temp)),temp(~isnan(temp)),inds(isnan(temp)));
        
        
        if isnan(temp(1))
            non_nan = inds(~isnan(temp));
            temp(1:non_nan(1)-1) = temp(non_nan(1));
        end
        if isnan(temp(end))
            non_nan = inds(~isnan(temp));
            temp(non_nan(end)+1:end) = temp(non_nan(end));
        end
        temp_smth = voma__irlssmooth(temp,handles.params.angpos_filt_param1);
        
        
end


switch handles.params.pos_filt_trace
    
    case 1
        handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_X = temp_smth;
    case 2
        handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_Y = temp_smth;
    case 3
        handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_Z = temp_smth;
    case 4
        handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_X = temp_smth;
    case 5
        handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_Y = temp_smth;
    case 6
        handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_Z = temp_smth;
end


end

% --- Executes on button press in recalc_angvel.
function [handles] = recalc_angvel_Callback(handles)
% hObject    handle to recalc_angvel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This system code marks that no additional manipulations of the raw data
% are required.
data_rot = 1;



DAQ_code = handles.CurrData.VOMA_data.Parameters.DAQ_code;
% Initialize the output format as and empty value. If needed, we will
% update the value below.
OutputFormat = [];

if strcmp(handles.CurrData.VOMA_data.Parameters.DAQ,'Fick Angles')
    % If, regardless of the system used to record the eye movement data,
    % the data is presented in Fick angles, change the DAQ_code to '5'
    DAQ_code = 5;
    OutputFormat = 1;
end

if strcmp(handles.CurrData.VOMA_data.Parameters.DAQ,'RotVect')
    % If, regardless of the system used to record the eye movement data,
    % the data is presented in Rotation Vectors, change the DAQ_code to '3'
    DAQ_code = 3;
    OutputFormat = 2;
end

% Store Relevant Ocular Ang. Pos. data in the proper format for the
% 'processeyemovements' function
Data_In.Data_LE_Pos_X = handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_X;
Data_In.Data_LE_Pos_Y = handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_Y;
Data_In.Data_LE_Pos_Z = handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_Z;

Data_In.Data_RE_Pos_X = handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_X;
Data_In.Data_RE_Pos_Y = handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_Y;
Data_In.Data_RE_Pos_Z = handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_Z;

Data_In.Fs = handles.CurrData.VOMA_data.Fs;

[New_Ang_Vel] = voma__processeyemovements([],[],[],[],0,data_rot,DAQ_code,OutputFormat,Data_In);

handles.CurrData.VOMA_data.Data_LE_Vel_X = New_Ang_Vel.LE_Vel_X;
handles.CurrData.VOMA_data.Data_LE_Vel_Y = New_Ang_Vel.LE_Vel_Y;
handles.CurrData.VOMA_data.Data_LE_Vel_LARP = New_Ang_Vel.LE_Vel_LARP;
handles.CurrData.VOMA_data.Data_LE_Vel_RALP = New_Ang_Vel.LE_Vel_RALP;
handles.CurrData.VOMA_data.Data_LE_Vel_Z = New_Ang_Vel.LE_Vel_Z;

handles.CurrData.VOMA_data.Data_RE_Vel_X = New_Ang_Vel.RE_Vel_X;
handles.CurrData.VOMA_data.Data_RE_Vel_Y = New_Ang_Vel.RE_Vel_Y;
handles.CurrData.VOMA_data.Data_RE_Vel_LARP = New_Ang_Vel.RE_Vel_LARP;
handles.CurrData.VOMA_data.Data_RE_Vel_RALP = New_Ang_Vel.RE_Vel_RALP;
handles.CurrData.VOMA_data.Data_RE_Vel_Z = New_Ang_Vel.RE_Vel_Z;



handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP = handles.CurrData.VOMA_data.Data_LE_Vel_LARP;
handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP = handles.CurrData.VOMA_data.Data_LE_Vel_RALP;
handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z = handles.CurrData.VOMA_data.Data_LE_Vel_Z;
handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_X = handles.CurrData.VOMA_data.Data_LE_Vel_X;
handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Y = handles.CurrData.VOMA_data.Data_LE_Vel_Y;
handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP = handles.CurrData.VOMA_data.Data_RE_Vel_LARP;
handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP = handles.CurrData.VOMA_data.Data_RE_Vel_RALP;
handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z = handles.CurrData.VOMA_data.Data_RE_Vel_Z;
handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_X = handles.CurrData.VOMA_data.Data_RE_Vel_X;
handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Y = handles.CurrData.VOMA_data.Data_RE_Vel_Y;




end

% --- Executes on button press in savedata.
function [handles] = savedata_Callback(handles)
% hObject    handle to savedata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if ~isfield(handles,'Results')
    
    h = msgbox('You haven''t created a Cycle Average yet! Click ''Plot Cycle Average'' Then Try again.','Woops! Missing Output Variable');
    set(handles.save_status,'BackgroundColor','green')
    drawnow
    return
end

cd(handles.params.pathtosave);

Results = handles.Results;
Results.name = handles.CurrData.name;

if isfield(handles.CurrData,'RawFileName')
    Results.raw_filename = handles.CurrData.RawFileName;
end

Results.Parameters = handles.CurrData.VOMA_data.Parameters;
%
% Results.Mapping = handles.CurrData.VOMA_data.Parameters.Mapping;
% Results.Stimulus = handles.CurrData.VOMA_data.Parameters.Stim_Info;
Results.Fs = handles.Final_Data.Fs;
Results.QPparams = handles.CurrData.QPparams;



if ~isempty(strfind(handles.CurrData.name,'.mat'))
    save([handles.CurrData.name(1:end-4) '_CycleAvg'],'Results')
else
    save([handles.CurrData.name '_CycleAvg'],'Results')
end

set(handles.save_status,'BackgroundColor','green')
drawnow

end
