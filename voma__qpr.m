function varargout = voma__qpr(varargin)
% VOMA__QPR MATLAB code for voma__qpr.fig
%      VOMA__QPR, by itself, creates a new VOMA__QPR or raises the existing
%      singleton*.
%
%      H = VOMA__QPR returns the handle to a new VOMA__QPR or the handle to
%      the existing singleton*.
%
%      VOMA__QPR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VOMA__QPR.M with the given input arguments.
%
%      VOMA__QPR('Property','Value',...) creates a new VOMA__QPR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before voma__qpr_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to voma__qpr_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
%       The VOMA version of 'qpr' was adapted from
%       'qpr_v3a'
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help voma__qpr

% Last Modified by GUIDE v2.5 23-Jan-2017 02:08:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @voma__qpr_OpeningFcn, ...
    'gui_OutputFcn',  @voma__qpr_OutputFcn, ...
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


% --- Executes just before voma__qpr is made visible.
function voma__qpr_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to voma__qpr (see VARARGIN)

% Choose default command line output for voma__qpr
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

if ~isempty(varargin)
    isrecall = true;
else
    isrecall = false;
end
% Initialize all handles
initialize_gui(hObject, handles, isrecall);

% UIWAIT makes voma__qpr wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Initialization Function
function initialize_gui(hObject, handles, isrecall)
% If the params field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.


if isrecall
    % i.e. we are reloading this GUI. The user may have just updated the
    % 'batch' file containing multiple data files, and we want to reload
    % the data to reflect this.
    handles.reload_flag = 1;
    
    analyze_new_file_Callback(hObject, 1, handles)
    
    % We have nested changes to the GUI's handles, so I want to pull them
    % from the global hObject variable
    handles = guidata(hObject);
    
    % Now set the 'reload_flag'
    handles.reload_flag =0;
    
    % Globally save the handles
    guidata(hObject, handles);
    return;
    
    
else
    % Don't reload the data and thus do nothing.
    handles.reload_flag =0;
end

% Starting flags to NOT plot 'spline' and 'raw' data after quick phase
% removal.
handles.params.raw_data_flag = 0;
handles.params.filt_data_flag = 0;
% This flag indicates if the user has 'smoothed' the data trace. The
% 'vor_analysis_gui' looks for the 'Results' data structure that is created
% AFTER smoothing the data.
handles.params.smooth_flag = 0;
handles.params.spline_sep_flag = 1;

handles.params.e_vel_param1 = [];
handles.params.e_vel_param2 = [];
handles.params.e_vel_param3 = [];
handles.params.e_vel_param4 = [];
handles.params.e_vel_param5 = [];
handles.params.e_vel_param6 = [];

axes(handles.vor_plot);
title('Eye Velocity w/ Stimulis')

axes(handles.pbp_deriv);
title('Point-by-Point Derivative')

% Initialize QPR routine to 'Spline.'
handles.CurrData.QPparams.qpr_routine = 1;
handles.params.qpr_routine_string = 'Spline';
set(handles.e_vel_param6,'Visible','off')
set(handles.e_vel_param6_txt,'Visible','off')

[handles] = update_angvel_filt_options(hObject, [], handles);

% Initialize All Eye-Plot Flags to 'ON'

handles.params.R_1 = 1;
handles.params.R_2 = 1;
handles.params.R_3 = 1;

handles.params.L_1 = 1;
handles.params.L_2 = 1;
handles.params.L_3 = 1;

% Set the processing flag to: ANGULAR VELOCITY
set(handles.angvel_angpos_toggle,'String','ANGULAR VELOCITY')
set(handles.angvel_params,'Visible','on')
set(handles.angpos_params,'Visible','off')
handles.params.plot_toggle_flag = 2;

% Save color codes for plotting
handles.colors.l_x = [255 140 0]/255;
handles.colors.l_y = [128 0 128]/255;
handles.colors.l_z = [1 0 0];
handles.colors.l_l = [0,128,0]/255;
handles.colors.l_r = [0 0 1];

handles.colors.r_x = [238 238 0]/255;
handles.colors.r_y = [138 43 226]/255;
handles.colors.r_z = [255,0,255]/255;
handles.colors.r_l = [0 1 0];
handles.colors.r_r = [64,224,208]/255;

handles.params.pos_filt_method = 1;
handles.params.pos_filt_trace = 1;

handles.params.norm_time = false;

handles.params.stim_plot_mult = 1;

handles.params.save_flag = false;

handles.params.link_x_axis_plots = false;

% Initialize the 'Filter_Param' table
filt_param_data = [{'Data Trace'} {'Filt. Type'} {'Param1'} {'Param2'} {'Param3'} {'Param4'} {'Param5'} {'Param6'} {'Spline Order'}; ...
    {'LE - X Pos'} {''} {''} {''} {''} {''} {''} {''} {'N/A'}; ...
    {'LE - Y Pos'} {''} {''} {''} {''} {''} {''} {''} {'N/A'}; ...
    {'LE - Z Pos'} {''} {''} {''} {''} {''} {''} {''} {'N/A'}; ...
    {'RE - X Pos'} {''} {''} {''} {''} {''} {''} {''} {'N/A'}; ...
    {'RE - Y Pos'} {''} {''} {''} {''} {''} {''} {''} {'N/A'}; ...
    {'RE - Z Pos'} {''} {''} {''} {''} {''} {''} {''} {'N/A'}; ...
    {'LE - LARP Vel'} {''} {''} {''} {''} {''} {''} {''} {''}; ...
    {'LE - RALP Vel'} {''} {''} {''} {''} {''} {''} {''} {''}; ...
    {'LE - LHRH Vel'} {''} {''} {''} {''} {''} {''} {''} {''}; ...
    {'RE - LARP Vel'} {''} {''} {''} {''} {''} {''} {''} {''}; ...
    {'RE - RALP Vel'} {''} {''} {''} {''} {''} {''} {''} {''}; ...
    {'RE - LHRH Vel'} {''} {''} {''} {''} {''} {''} {''} {''}];
set(handles.filt_params,'Data',filt_param_data);

guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = voma__qpr_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in stimuli_files.
function stimuli_files_Callback(hObject, eventdata, handles)
% hObject    handle to stimuli_files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This callback is active when the user clicks on an item in the ListBox
if handles.reload_flag == 0
    
    if handles.params.save_flag
        
        % Construct a questdlg with three options
        choice = questdlg('You haven''t saved any of your work with this file. Continue?', ...
            'File changes UNSAVED', ...
            'Yes, Continue','No, let me save my work','No, let me save my work');
        % Handle response
        switch choice
            case 'Yes, Continue'
                % The user wants to continue. Do nothing.
            case 'No, let me save my work'
                % The user wants to revert back to the old file.
                set(handles.stimuli_files,'Value',handles.curr_file)
                
                return
        end
        
    end
    
    handles.curr_file = get(hObject,'Value');
    % Since we loaded a new file, the 'smooth_flag' should be false
    handles.params.smooth_flag = 0;
    
    
    
elseif handles.reload_flag == 1
    % This 'reload_flag' is true when the user is 'recalling' this qpr gui
    % from a different gui (likely the 'vor_analysis_gui'. In that case, we
    % do not want to use the above 'get' command, since the user did not
    % click on a new file to analyze. We instead want to reanalyze the file
    % the user was previously looking at.
    % The 'handles.curr_file' variable should already exist, and contain
    % the file number of the previous file.
    set(handles.stimuli_files,'Value',handles.curr_file)
end

handles.CurrData = handles.RootData(handles.curr_file);


% I want to check if the data structure I am loading has QP removal
% parameters already saved. For 'fresh' data files, the field 'QPparams'
% will not exist. For loaded files where I have already saved a set of
% parameters for one of the stimulus presentations, all other presentations
% will have an empty field called 'QPparams'. I use the '||' form of the
% logical OR operation in order to short circuit, since if I use the
% 'isempty' command when the field does NOT exist, I will get an error. For
% example, if the field 'QPparams' does not exist the left side of the
% '||' will out put a ~0 = 1, thus causing the statement to enter the 'if'
% block. If the field does exist, but is empty the argument will be ' 1 ||
% 0' and thus still enter the 'if' block. Lastly, if the field does exist,
% but is non-empty, we will enter the 'else' block.
if (~isfield(handles.CurrData,'QPparams')) || (isempty(handles.CurrData.QPparams))
    
    [handles] = update_eye_vel(hObject, eventdata, handles, 1);
    
    % If there are no QP parameters to load for this file, then zero out the
    % UGQPR list and clear the GUI display
    handles.CurrData.QPparams.UGQPRarray = [];
    
    % Initialize the 'Filter_Param' table
    filt_param_data = [{'Data Trace'} {'Filt. Type'} {'Param1'} {'Param2'} {'Param3'} {'Param4'} {'Param5'} {'Param6'} {'Spline Order'}; ...
        {'LE - X Pos'} {''} {''} {''} {''} {''} {''} {''} {'N/A'}; ...
        {'LE - Y Pos'} {''} {''} {''} {''} {''} {''} {''} {'N/A'}; ...
        {'LE - Z Pos'} {''} {''} {''} {''} {''} {''} {''} {'N/A'}; ...
        {'RE - X Pos'} {''} {''} {''} {''} {''} {''} {''} {'N/A'}; ...
        {'RE - Y Pos'} {''} {''} {''} {''} {''} {''} {''} {'N/A'}; ...
        {'RE - Z Pos'} {''} {''} {''} {''} {''} {''} {''} {'N/A'}; ...
        {'LE - LARP Vel'} {''} {''} {''} {''} {''} {''} {''} {''}; ...
        {'LE - RALP Vel'} {''} {''} {''} {''} {''} {''} {''} {''}; ...
        {'LE - LHRH Vel'} {''} {''} {''} {''} {''} {''} {''} {''}; ...
        {'RE - LARP Vel'} {''} {''} {''} {''} {''} {''} {''} {''}; ...
        {'RE - RALP Vel'} {''} {''} {''} {''} {''} {''} {''} {''}; ...
        {'RE - LHRH Vel'} {''} {''} {''} {''} {''} {''} {''} {''}];
    set(handles.filt_params,'Data',filt_param_data);
    
    
    % This file has not been processed by the QPR routine yet. We will fill
    % in the 'filtered' data traces with the raw data to start.
    handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_X = handles.CurrData.VOMA_data.Data_LE_Pos_X;
    handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_Y = handles.CurrData.VOMA_data.Data_LE_Pos_Y;
    handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_Z = handles.CurrData.VOMA_data.Data_LE_Pos_Z;
    handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_X = handles.CurrData.VOMA_data.Data_RE_Pos_X;
    handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_Y = handles.CurrData.VOMA_data.Data_RE_Pos_Y;
    handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_Z = handles.CurrData.VOMA_data.Data_RE_Pos_Z;
    
    handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP = handles.CurrData.VOMA_data.Data_LE_Vel_LARP;
    handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP = handles.CurrData.VOMA_data.Data_LE_Vel_RALP;
    handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z = handles.CurrData.VOMA_data.Data_LE_Vel_Z;
    handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP = handles.CurrData.VOMA_data.Data_RE_Vel_LARP;
    handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP = handles.CurrData.VOMA_data.Data_RE_Vel_RALP;
    handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z = handles.CurrData.VOMA_data.Data_RE_Vel_Z;
    
    % Set the 'smooth_flag' to false
    handles.params.smooth_flag = 0;
    
    % Mark the file as 'SAVED', since this is an unprocessed file
    handles.params.save_flag = false;
    
    %
    handles.CurrData.QPparams.qpr_routine =  get(handles.qpr_routine,'Value');
else
    

    handles.CurrData.QPparams.qpr_routine = handles.CurrData.QPparams.qpr_routine;
    set(handles.qpr_routine,'value',handles.CurrData.QPparams.qpr_routine);
    qpr_routine_Callback(hObject, eventdata, handles,1)
    handles = guidata(hObject);
    
    [handles] = update_angvel_filt_options(hObject, eventdata, handles);
    
    handles.params.e_vel_param1 = handles.CurrData.QPparams.filt_params{8,3};
    set(handles.e_vel_param1,'String',handles.CurrData.QPparams.filt_params{8,3});
    handles.params.e_vel_param2 = handles.CurrData.QPparams.filt_params{8,4};
    set(handles.e_vel_param2,'String',handles.CurrData.QPparams.filt_params{8,4});
    handles.params.e_vel_param3 = handles.CurrData.QPparams.filt_params{8,5};
    set(handles.e_vel_param3,'String',handles.CurrData.QPparams.filt_params{8,5});
    handles.params.e_vel_param4 = handles.CurrData.QPparams.filt_params{8,6};
    set(handles.e_vel_param4,'String',handles.CurrData.QPparams.filt_params{8,6});
    handles.params.e_vel_param5 = handles.CurrData.QPparams.filt_params{8,7};
    set(handles.e_vel_param5,'String',handles.CurrData.QPparams.filt_params{8,7});
    handles.params.e_vel_param6 = handles.CurrData.QPparams.filt_params{8,8};
    set(handles.e_vel_param6,'String',handles.CurrData.QPparams.filt_params{8,8});
    
    % KLUDGE!
    if strcmp(handles.CurrData.QPparams.filt_params{8,9},'')
       handles.CurrData.QPparams.filt_params(8:11,9) = {1};
    end
    
    handles.params.spline_sep_flag = handles.CurrData.QPparams.filt_params{8,9};
    set(handles.spline_sep_flag,'Value',handles.CurrData.QPparams.filt_params{8,9});
    
    if size(handles.CurrData.QPparams.filt_params,2)==10
        handles.params.post_qpr_filt_param1 = handles.CurrData.QPparams.filt_params{8,10};
        set(handles.post_qpr_filt_param1,'String',handles.CurrData.QPparams.filt_params{8,10});
    end
   
%     try
        set(handles.filt_params,'Data',handles.CurrData.QPparams.filt_params);
%     catch
%         
%     end
    
    % Set the 'smooth_flag' to true, since this file has already been
    % processed.
    handles.params.smooth_flag = 1;
    
    
    [handles] = update_eye_vel(hObject, eventdata, handles, 4);
    
    if (~isfield(handles.CurrData.QPparams,'UGQPRarray')) || (isempty(handles.CurrData.QPparams.UGQPRarray))
        
        handles.CurrData.QPparams.UGQPRarray = [];
        
    else
                
        
    end
    
    
    % Mark the file as SAVED
    handles.params.save_flag = false;
    
end


% % Store this files data in the handles
% handles.ind_filename = handles.CurrData.name;
% handles.Fs = handles.CurrData.VOMA_data.Fs;
% 
% 
% handles.l_x_pos = handles.CurrData.VOMA_data.Data_LE_Pos_X;
% handles.l_y_pos = handles.CurrData.VOMA_data.Data_LE_Pos_Y;
% handles.l_z_pos = handles.CurrData.VOMA_data.Data_LE_Pos_Z;
% handles.r_x_pos = handles.CurrData.VOMA_data.Data_RE_Pos_X;
% handles.r_y_pos = handles.CurrData.VOMA_data.Data_RE_Pos_Y;
% handles.r_z_pos = handles.CurrData.VOMA_data.Data_RE_Pos_Z;
% 
% 
% handles.smth_pos.l_x_pos = handles.l_x_pos;
% handles.smth_pos.l_y_pos = handles.l_y_pos;
% handles.smth_pos.l_z_pos = handles.l_z_pos;
% handles.smth_pos.r_x_pos = handles.r_x_pos;
% handles.smth_pos.r_y_pos = handles.r_y_pos;
% handles.smth_pos.r_z_pos = handles.r_z_pos;
% 
% handles.l_x_vel = handles.CurrData.VOMA_data.Data_LE_Vel_X;
% handles.l_y_vel = handles.CurrData.VOMA_data.Data_LE_Vel_Y;
% handles.l_l_vel = handles.CurrData.VOMA_data.Data_LE_Vel_LARP;
% handles.l_r_vel = handles.CurrData.VOMA_data.Data_LE_Vel_RALP;
% handles.l_z_vel = handles.CurrData.VOMA_data.Data_LE_Vel_Z;

% handles.r_x_vel = handles.CurrData.VOMA_data.Data_RE_Vel_X;
% handles.r_y_vel = handles.CurrData.VOMA_data.Data_RE_Vel_Y;
% handles.r_l_vel = handles.CurrData.VOMA_data.Data_RE_Vel_LARP;
% handles.r_r_vel = handles.CurrData.VOMA_data.Data_RE_Vel_RALP;
% handles.r_z_vel = handles.CurrData.VOMA_data.Data_RE_Vel_Z;
% 
% handles.l_l_smooth = handles.l_l_vel;
% handles.l_r_smooth = handles.l_r_vel;
% handles.l_z_smooth = handles.l_z_vel;
% handles.r_l_smooth = handles.r_l_vel;
% handles.r_r_smooth = handles.r_r_vel;
% handles.r_z_smooth = handles.r_z_vel;
% 

% We will initialize the 'filtered' data plots to contain the processed 
% data traces with quick phases removed. The terminology here is confusing,
% but my thought process is that the user may want to plot their data:
%
% 1) Raw, unfiltered
% 2) Filtered, but without any quick phase removal paradigm
% 3) Filtered, with quick phases removed
%
% For now, I feel it is a waste of space to save three copies of EACH data
% trace. Instead, we will save 1) and 3) above into the VOMA data
% structure, and zero out 2) for now. 
% 
% handles.spline.l_l = handles.l_l_vel;
% handles.spline.l_r = handles.l_r_vel;
% handles.spline.l_z = handles.l_z_vel;
% handles.spline.r_l = handles.r_l_vel;
% handles.spline.r_r = handles.r_r_vel;
% handles.spline.r_z = handles.r_z_vel;

handles.filter_noQPR.LE_Vel_LARP = handles.CurrData.VOMA_data.Data_LE_Vel_LARP;
handles.filter_noQPR.LE_Vel_RALP = handles.CurrData.VOMA_data.Data_LE_Vel_RALP;
handles.filter_noQPR.LE_Vel_Z = handles.CurrData.VOMA_data.Data_LE_Vel_Z;

handles.filter_noQPR.RE_Vel_LARP = handles.CurrData.VOMA_data.Data_RE_Vel_LARP;
handles.filter_noQPR.RE_Vel_RALP = handles.CurrData.VOMA_data.Data_RE_Vel_RALP;
handles.filter_noQPR.RE_Vel_Z = handles.CurrData.VOMA_data.Data_RE_Vel_Z;

handles.vel_deriv.LE_LARP = diff(handles.CurrData.VOMA_data.Data_LE_Vel_LARP);
handles.vel_deriv.LE_RALP = diff(handles.CurrData.VOMA_data.Data_LE_Vel_RALP);
handles.vel_deriv.LE_Z = diff(handles.CurrData.VOMA_data.Data_LE_Vel_Z);

handles.vel_deriv.RE_LARP = diff(handles.CurrData.VOMA_data.Data_RE_Vel_LARP);
handles.vel_deriv.RE_RALP = diff(handles.CurrData.VOMA_data.Data_RE_Vel_RALP);
handles.vel_deriv.RE_Z = diff(handles.CurrData.VOMA_data.Data_RE_Vel_Z);

handles.t_0 = handles.CurrData.VOMA_data.Eye_t(1);
if handles.params.norm_time
    handles.CurrData.VOMA_data.Eye_t = handles.CurrData.VOMA_data.Eye_t - handles.CurrData.VOMA_data.Eye_t(1);
    handles.CurrData.VOMA_data.Stim_t = handles.CurrData.VOMA_data.Stim_t - handles.CurrData.VOMA_data.Stim_t(1);

else
    
end

% handles.Stimulus = handles.CurrData.VOMA_data.Parameters.Stim_Info;
% handles.Mapping = handles.CurrData.VOMA_data.Parameters.Mapping;

% handles.DAQ = handles.CurrData.VOMA_data.Parameters.DAQ;

% handles.stim = handles.CurrData.VOMA_data.Stim_Trace;

% handles.stim_ind = handles.CurrData.VOMA_data.stim_ind;

% Display the present file's UGQPR times
if iscolumn(handles.CurrData.VOMA_data.Eye_t)
    handles.CurrData.VOMA_data.Eye_t = handles.CurrData.VOMA_data.Eye_t';
    
end
set(handles.UGQPR_table,'Data',handles.CurrData.VOMA_data.Eye_t(handles.CurrData.QPparams.UGQPRarray))


if (isfield(handles.CurrData,'cyc2plot')) && (~isempty(handles.CurrData.cyc2plot))
%     handles.CurrData.cyc2plot = handles.CurrData.cyc2plot;
    set(handles.saved_cycle_list,'BackgroundColor','green')
    set(handles.saved_cycle_list,'String','Loaded List of Cycles')
else
    handles.CurrData.cyc2plot = [];
    set(handles.saved_cycle_list,'BackgroundColor','yellow')
    set(handles.saved_cycle_list,'String','No List of Cycles')
end



% Plot the raw data
axes(handles.vor_plot);
cla
plot_raw_data(hObject,eventdata,handles)
% Clear the PBP Deriv. plot
axes(handles.pbp_deriv);
cla


guidata(hObject,handles)


% Hints: contents = cellstr(get(hObject,'String')) returns stimuli_files contents as cell array
%        contents{get(hObject,'Value')} returns selected item from stimuli_files


% --- Executes during object creation, after setting all properties.
function stimuli_files_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimuli_files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function filename_string_Callback(hObject, eventdata, handles)
% hObject    handle to filename_string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filename_string as text
%        str2double(get(hObject,'String')) returns contents of filename_string as a double


% --- Executes during object creation, after setting all properties.
function filename_string_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filename_string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in analyze_new_file.
function analyze_new_file_Callback(hObject, eventdata, handles)
% hObject    handle to analyze_new_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Prompt the user to choose a file to analyze.
if handles.reload_flag == 0
    [filename, pathname, filterindex] =  uigetfile('*.voma');
    handles.filename = filename;
    handles.pathname = pathname;
elseif handles.reload_flag == 1
    % Don't prompt the user for a file...just reload the old one
end

cd(handles.pathname);
temp=load('-mat',handles.filename);

% Get the names of the variables loaded into the environment
fn=fieldnames(temp);

% The internal argument here converts the 'cell' containing the variable
% name loaded to the environment into a string. This is so we can 'extract'
% the variable loaded and give it a set variable name.
RootData = temp.(char(cellfun(@(x) num2str(x),fn(1),'Un',0)));
% Store the data
handles.RootData = RootData;

for j=1:length(RootData)
    
    switch num2str(RootData(j).VOMA_data.Parameters.Stim_Info.Stim_Type{1})
        
        case {'Current Fitting'}
            stimlist{j}=[ num2str(RootData(j).VOMA_data.Parameters.Stim_Info.Stim_Type{1}) ' , '  num2str(RootData(j).VOMA_data.Parameters.Stim_Info.ModCanal{1}) ...
                ' , '  num2str(RootData(j).VOMA_data.Parameters.Mapping.Type{1}) ' us ON, ' num2str(RootData(j).VOMA_data.Parameters.Stim_Info.Freq{1}) ' us OFF, '  num2str(RootData(j).VOMA_data.Parameters.Stim_Info.Max_Vel{1}) ...
                ' uA, ' num2str(RootData(j).VOMA_data.Parameters.Mapping.Max_PR{1}) ' pps Trans. Rate, ' num2str(RootData(j).VOMA_data.Parameters.Mapping.Baseline{1}) ' pps Base. Rate, ' ...
                num2str(RootData(j).VOMA_data.Parameters.Stim_Info.Cycles{1}) ' cycles: ' num2str(RootData(j).name)];
        otherwise
            
            stimlist{j}=[ num2str(RootData(j).VOMA_data.Parameters.Stim_Info.Stim_Type{1}) ' , '  num2str(RootData(j).VOMA_data.Parameters.Stim_Info.ModCanal{1}) ...
                ' , '  num2str(RootData(j).VOMA_data.Parameters.Stim_Info.Freq{1}) ' Hz, '  num2str(RootData(j).VOMA_data.Parameters.Stim_Info.Max_Vel{1}) ...
                ' dps, '  num2str(RootData(j).VOMA_data.Parameters.Stim_Info.Cycles{1}) ' cycles: ' num2str(RootData(j).name)];
    end
end

set(handles.stimuli_files,'Value',1)

set(handles.stimuli_files,'String',stimlist)

set(handles.filename_string,'String',handles.filename)

guidata(hObject,handles);
stimuli_files_Callback(hObject, eventdata, handles)

% Stimuli_files_Callback may have altered the handles...make sure to
% retrieve them!
handles = guidata(hObject);

guidata(hObject,handles)

function e_vel_param2_Callback(hObject, eventdata, handles)
% hObject    handle to e_vel_param2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
e_vel_param2 = str2double(get(hObject,'String'));
if isnan(e_vel_param2)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.params.e_vel_param2 = e_vel_param2;
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of e_vel_param2 as text
%        str2double(get(hObject,'String')) returns contents of e_vel_param2 as a double


% --- Executes during object creation, after setting all properties.
function e_vel_param2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_vel_param2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function e_vel_param3_Callback(hObject, eventdata, handles)
% hObject    handle to e_vel_param3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
e_vel_param3 = str2double(get(hObject,'String'));
if isnan(e_vel_param3)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.params.e_vel_param3 = e_vel_param3;
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of e_vel_param3 as text
%        str2double(get(hObject,'String')) returns contents of e_vel_param3 as a double


% --- Executes during object creation, after setting all properties.
function e_vel_param3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_vel_param3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function e_vel_param5_Callback(hObject, eventdata, handles)
% hObject    handle to e_vel_param5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
e_vel_param5 = str2double(get(hObject,'String'));
if isnan(e_vel_param5)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.params.e_vel_param5 = e_vel_param5;
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of e_vel_param5 as text
%        str2double(get(hObject,'String')) returns contents of e_vel_param5 as a double


% --- Executes during object creation, after setting all properties.
function e_vel_param5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_vel_param5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function e_vel_param4_Callback(hObject, eventdata, handles)
% hObject    handle to e_vel_param4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
e_vel_param4 = str2double(get(hObject,'String'));
if isnan(e_vel_param4)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.params.e_vel_param4 = e_vel_param4;
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of e_vel_param4 as text
%        str2double(get(hObject,'String')) returns contents of e_vel_param4 as a double


% --- Executes during object creation, after setting all properties.
function e_vel_param4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_vel_param4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in start_deseccade.
function [handles] = start_deseccade_Callback(hObject, eventdata, handles)
% hObject    handle to start_deseccade (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% % Do quick phase removal for each trace
% desaccade1 = LARP
% desaccade2 = RALP
% desaccade3 = LHRH
%

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
                        desaccade1 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1);
                        desaccade2 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,[],desaccade1.QP_range);
                        desaccade3 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,[],desaccade1.QP_range);
                        
                        desaccade4 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1);
                        desaccade5 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,[],desaccade1.QP_range);
                        desaccade6 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,[],desaccade1.QP_range);
                        
                    case {'LP','RALP-Axis','RALP'}
                        desaccade2 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1);
                        desaccade1 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,[],desaccade2.QP_range);
                        desaccade3 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,[],desaccade2.QP_range);
                        
                        desaccade5 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1);
                        desaccade4 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,[],desaccade2.QP_range);
                        desaccade6 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,[],desaccade2.QP_range);
                        
                    case {'LH','LHRH-Axis','LHRH'}
                        desaccade3 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1);
                        desaccade1 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,[],desaccade3.QP_range);
                        desaccade2 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,[],desaccade3.QP_range);
                        
                        desaccade6 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1);
                        desaccade4 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,[],desaccade3.QP_range);
                        desaccade5 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,[],desaccade3.QP_range);
                        
                    otherwise
                        desaccade1 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1);
                        desaccade2 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1);
                        desaccade3 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1);
                        
                        desaccade4 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1);
                        desaccade5 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1);
                        desaccade6 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1);
                        
                end
                
            case 2 % Spline each 3D component seperately
                
                desaccade1 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1);
                desaccade2 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1);
                desaccade3 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1);
                
                desaccade4 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1);
                desaccade5 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1);
                desaccade6 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1);
                
                
            case 3 % Spline the LARP component first, then use the QPs detected to spline the other components
                desaccade1 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1);
                desaccade2 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,[],desaccade1.QP_range);
                desaccade3 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,[],desaccade1.QP_range);
                
                desaccade4 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1);
                desaccade5 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,[],desaccade4.QP_range);
                desaccade6 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,[],desaccade4.QP_range);
            case 4 % Spline the RALP component first, then use the QPs detected to spline the other components
                desaccade2 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1);
                desaccade1 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,[],desaccade2.QP_range);
                desaccade3 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,[],desaccade2.QP_range);
                
                desaccade5 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1);
                desaccade4 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,[],desaccade5.QP_range);
                desaccade6 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,[],desaccade5.QP_range);
                
            case 5 % Spline the LHRH component first, then use the QPs detected to spline the other components

                desaccade3 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,[]);
                desaccade1 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,[],desaccade3.QP_range);
                desaccade2 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,[],desaccade3.QP_range);
               
                desaccade6 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1);
                desaccade4 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,[],desaccade6.QP_range);
                desaccade5 = voma__desaccadedata(handles.CurrData.VOMA_data.Data_RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,[],desaccade6.QP_range);
        end
        
        % Save the data after QP removal
        handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP = desaccade1.results;
        handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP = desaccade2.results;
        handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z = desaccade3.results;
        
        handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP = desaccade4.results;
        handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP = desaccade5.results;
        handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z = desaccade6.results;
        
        
        % Save the 'spline-only' data seperately for plotting purposes.
        handles.filter_noQPR.LE_Vel_LARP = desaccade1.smooth;
        handles.filter_noQPR.LE_Vel_RALP = desaccade2.smooth;
        handles.filter_noQPR.LE_Vel_Z = desaccade3.smooth;
        
        handles.filter_noQPR.RE_Vel_LARP = desaccade4.smooth;
        handles.filter_noQPR.RE_Vel_RALP = desaccade5.smooth;
        handles.filter_noQPR.RE_Vel_Z = desaccade6.smooth;
        
        handles.vel_deriv.LE_LARP = desaccade1.deriv;
        handles.vel_deriv.LE_RALP = desaccade2.deriv;
        handles.vel_deriv.LE_Z = desaccade3.deriv;
        
        handles.vel_deriv.RE_LARP = desaccade4.deriv;
        handles.vel_deriv.RE_RALP = desaccade5.deriv;
        handles.vel_deriv.RE_Z = desaccade6.deriv;
        
        
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
        LE_Vel_LARP = filter(b,a,handles.CurrData.VOMA_data.Data_LE_Vel_LARP);
        LE_Vel_LARP = [LE_Vel_LARP(gd+1:end) ; ones(gd,1)];
        LE_Vel_RALP = filter(b,a,handles.CurrData.VOMA_data.Data_LE_Vel_RALP);
        LE_Vel_RALP = [LE_Vel_RALP(gd+1:end) ; ones(gd,1)];
        LE_Vel_Z = filter(b,a,handles.CurrData.VOMA_data.Data_LE_Vel_Z);
        LE_Vel_Z = [LE_Vel_Z(gd+1:end) ; ones(gd,1)];
        
        
        RE_Vel_LARP = filter(b,a,handles.CurrData.VOMA_data.Data_RE_Vel_LARP);
        RE_Vel_LARP = [RE_Vel_LARP(gd+1:end) ; ones(gd,1)];
        RE_Vel_RALP = filter(b,a,handles.CurrData.VOMA_data.Data_RE_Vel_RALP);
        RE_Vel_RALP = [RE_Vel_RALP(gd+1:end) ; ones(gd,1)];
        RE_Vel_Z = filter(b,a,handles.CurrData.VOMA_data.Data_RE_Vel_Z);
        RE_Vel_Z = [RE_Vel_Z(gd+1:end) ; ones(gd,1)];
        
        E = 0; % This code instructs the 'desaccadedata' routine to NOT 
        % apply any additional filtering to the input data.
        
        switch handles.params.spline_sep_flag
            
            case 1 % Detect splining options from the file being processed
                switch handles.CurrData.VOMA_data.Parameters.Stim_Info.ModCanal{1}
                    
                    case {'LA','LARP-Axis','LARP'}
                        
                        
                        
                        desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                        desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade1.QP_range);
                        desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade1.QP_range);
                        
                        desaccade4 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                        desaccade5 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade1.QP_range);
                        desaccade6 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade1.QP_range);
                        
                    case {'LP','RALP-Axis','RALP'}
                        desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                        desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade2.QP_range);
                        desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade2.QP_range);
                        
                        desaccade5 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                        desaccade4 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade2.QP_range);
                        desaccade6 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade2.QP_range);
                        
                    case {'LH','LHRH-Axis','LHRH'}
                        desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                        desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade3.QP_range);
                        desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade3.QP_range);
                        
                        desaccade6 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                        desaccade4 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade3.QP_range);
                        desaccade5 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade3.QP_range);
                        
                    otherwise
                        desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                        desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                        desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                        
                        desaccade4 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                        desaccade5 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                        desaccade6 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                        
                end
                
            case 2 % Spline each 3D component seperately
                
                desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                
                desaccade4 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                desaccade5 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                desaccade6 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                
                
            case 3 % Spline the LARP component first, then use the QPs detected to spline the other components
                desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade1.QP_range);
                desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade1.QP_range);
                
                desaccade4 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                desaccade5 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade4.QP_range);
                desaccade6 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade4.QP_range);
            case 4 % Spline the RALP component first, then use the QPs detected to spline the other components
                desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade2.QP_range);
                desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade2.QP_range);
                
                desaccade5 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                desaccade4 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade5.QP_range);
                desaccade6 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade5.QP_range);
                
            case 5 % Spline the LHRH component first, then use the QPs detected to spline the other components
%                 Ord = 1;
                
                desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[]);
                desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade3.QP_range);
                desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade3.QP_range);
                
                desaccade6 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[]);
                desaccade4 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade6.QP_range);
                desaccade5 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade6.QP_range);
        end
        
        % Save the data after QP removal
        handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP = desaccade1.results;
        handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP = desaccade2.results;
        handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z = desaccade3.results;
        
        handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP = desaccade4.results;
        handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP = desaccade5.results;
        handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z = desaccade6.results;
        
        
        % Save the 'spline-only' data seperately for plotting purposes.
        handles.filter_noQPR.LE_Vel_LARP = desaccade1.smooth;
        handles.filter_noQPR.LE_Vel_RALP = desaccade2.smooth;
        handles.filter_noQPR.LE_Vel_Z = desaccade3.smooth;
        
        handles.filter_noQPR.RE_Vel_LARP = desaccade4.smooth;
        handles.filter_noQPR.RE_Vel_RALP = desaccade5.smooth;
        handles.filter_noQPR.RE_Vel_Z = desaccade6.smooth;
        
        handles.vel_deriv.LE_LARP = desaccade1.deriv;
        handles.vel_deriv.LE_RALP = desaccade2.deriv;
        handles.vel_deriv.LE_Z = desaccade3.deriv;
        
        handles.vel_deriv.RE_LARP = desaccade4.deriv;
        handles.vel_deriv.RE_RALP = desaccade5.deriv;
        handles.vel_deriv.RE_Z = desaccade6.deriv;
        
        
    case 3 %S.G. Filter
        
        
        LE_Vel_LARP = sgolayfilt(handles.CurrData.VOMA_data.Data_LE_Vel_LARP,handles.params.e_vel_param6,handles.params.e_vel_param4);
        LE_Vel_RALP = sgolayfilt(handles.CurrData.VOMA_data.Data_LE_Vel_RALP,handles.params.e_vel_param6,handles.params.e_vel_param4);
        LE_Vel_Z = sgolayfilt(handles.CurrData.VOMA_data.Data_LE_Vel_Z,handles.params.e_vel_param6,handles.params.e_vel_param4);
        
        RE_Vel_LARP = sgolayfilt(handles.CurrData.VOMA_data.Data_RE_Vel_LARP,handles.params.e_vel_param6,handles.params.e_vel_param4);
        RE_Vel_RALP = sgolayfilt(handles.CurrData.VOMA_data.Data_RE_Vel_RALP,handles.params.e_vel_param6,handles.params.e_vel_param4);
        RE_Vel_Z = sgolayfilt(handles.CurrData.VOMA_data.Data_RE_Vel_Z,handles.params.e_vel_param6,handles.params.e_vel_param4);
        
        E = 0; % This code instructs the 'desaccadedata' routine to NOT 
        % apply any additional filtering to the input data.
        
        switch handles.params.spline_sep_flag
            
            case 1 % Detect splining options from the file being processed
                switch handles.CurrData.VOMA_data.Parameters.Stim_Info.ModCanal{1}
                    
                    case {'LA','LARP-Axis','LARP'}
                        
                        
                        
                        desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                        desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade1.QP_range);
                        desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade1.QP_range);
                        
                        desaccade4 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                        desaccade5 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade1.QP_range);
                        desaccade6 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade1.QP_range);
                        
                    case {'LP','RALP-Axis','RALP'}
                        desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                        desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade2.QP_range);
                        desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade2.QP_range);
                        
                        desaccade5 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                        desaccade4 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade2.QP_range);
                        desaccade6 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade2.QP_range);
                        
                    case {'LH','LHRH-Axis','LHRH'}
                        desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                        desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade3.QP_range);
                        desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade3.QP_range);
                        
                        desaccade6 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                        desaccade4 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade3.QP_range);
                        desaccade5 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade3.QP_range);
                        
                    otherwise
                        desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                        desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                        desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                        
                        desaccade4 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                        desaccade5 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                        desaccade6 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                        
                end
                
            case 2 % Spline each 3D component seperately
                
                desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                
                desaccade4 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                desaccade5 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                desaccade6 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                
                
            case 3 % Spline the LARP component first, then use the QPs detected to spline the other components
                desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade1.QP_range);
                desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade1.QP_range);
                
                desaccade4 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                desaccade5 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade4.QP_range);
                desaccade6 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade4.QP_range);
            case 4 % Spline the RALP component first, then use the QPs detected to spline the other components
                desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade2.QP_range);
                desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade2.QP_range);
                
                desaccade5 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                desaccade4 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade5.QP_range);
                desaccade6 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade5.QP_range);
                
            case 5 % Spline the LHRH component first, then use the QPs detected to spline the other components
                desaccade3 = voma__desaccadedata(LE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                desaccade1 = voma__desaccadedata(LE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade3.QP_range);
                desaccade2 = voma__desaccadedata(LE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade3.QP_range);
                
                desaccade6 = voma__desaccadedata(RE_Vel_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E);
                desaccade4 = voma__desaccadedata(RE_Vel_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade6.QP_range);
                desaccade5 = voma__desaccadedata(RE_Vel_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,E,[],desaccade6.QP_range);
        end
        
        % Save the data after QP removal
        handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP = desaccade1.results;
        handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP = desaccade2.results;
        handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z = desaccade3.results;
        
        handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP = desaccade4.results;
        handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP = desaccade5.results;
        handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z = desaccade6.results;
        
        
        % Save the 'spline-only' data seperately for plotting purposes.
        handles.filter_noQPR.LE_Vel_LARP = desaccade1.smooth;
        handles.filter_noQPR.LE_Vel_RALP = desaccade2.smooth;
        handles.filter_noQPR.LE_Vel_Z = desaccade3.smooth;
        
        handles.filter_noQPR.RE_Vel_LARP = desaccade4.smooth;
        handles.filter_noQPR.RE_Vel_RALP = desaccade5.smooth;
        handles.filter_noQPR.RE_Vel_Z = desaccade6.smooth;
        
        handles.vel_deriv.LE_LARP = desaccade1.deriv;
        handles.vel_deriv.LE_RALP = desaccade2.deriv;
        handles.vel_deriv.LE_Z = desaccade3.deriv;
        
        handles.vel_deriv.RE_LARP = desaccade4.deriv;
        handles.vel_deriv.RE_RALP = desaccade5.deriv;
        handles.vel_deriv.RE_Z = desaccade6.deriv;
        
        
end
axes(handles.vor_plot)
cla
hold on
plot_smth_data(hObject,eventdata,handles)

axes(handles.pbp_deriv)
cla

if handles.params.L_1==1
    plot(handles.CurrData.VOMA_data.Eye_t(2:end),abs(handles.vel_deriv.LE_LARP),'Color',handles.colors.l_l)
end
hold on
if handles.params.L_2==1
    plot(handles.CurrData.VOMA_data.Eye_t(2:end),abs(handles.vel_deriv.LE_RALP),'Color',handles.colors.l_r)
end
if handles.params.L_3==1
    plot(handles.CurrData.VOMA_data.Eye_t(2:end),abs(handles.vel_deriv.LE_Z),'Color',handles.colors.l_z)
end

if handles.params.R_1==1
    plot(handles.CurrData.VOMA_data.Eye_t(2:end),abs(handles.vel_deriv.RE_LARP),'Color',handles.colors.r_l)
end
if handles.params.R_2==1
    plot(handles.CurrData.VOMA_data.Eye_t(2:end),abs(handles.vel_deriv.RE_RALP),'Color',handles.colors.r_r)
end
if handles.params.R_3==1
    plot(handles.CurrData.VOMA_data.Eye_t(2:end),abs(handles.vel_deriv.RE_Z),'Color',handles.colors.r_z)
end
plot(handles.CurrData.VOMA_data.Eye_t(2:end),handles.params.e_vel_param3*ones(1,length(handles.CurrData.VOMA_data.Eye_t)-1),'k-')
xlabel('Time [s]')
ylabel('Point-by-point Derivative magnitude')

% Set the 'smooth_flag' to true
handles.params.smooth_flag = 1;

% Mark AngVel Traces as UNSAVED
[handles] = update_eye_vel(hObject, eventdata, handles, 1);

% Update the 'filter parameter spreadsheet'
filt_params = get(handles.filt_params,'Data');
filt_params(8:13,2) = {handles.params.qpr_routine_string}; % Ang. Vel. Filter Type
filt_params(8:13,3) = {handles.params.e_vel_param1}; 
filt_params(8:13,4) = {handles.params.e_vel_param2};
filt_params(8:13,5) = {handles.params.e_vel_param3};
filt_params(8:13,6) = {handles.params.e_vel_param4};
filt_params(8:13,7) = {handles.params.e_vel_param5};
filt_params(8:13,8) = {handles.params.e_vel_param6};
filt_params(8:13,9) = {handles.params.spline_sep_flag};

filt_params(8:13,10) = {'N/A'};

set(handles.filt_params,'Data',filt_params);

guidata(hObject,handles)





% --- Executes on button press in holdplot1.
function holdplot1_Callback(hObject, eventdata, handles)
% hObject    handle to holdplot1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    axes(handles.vor_plot);
    H = axis;
    axis manual
elseif button_state == get(hObject,'Min')
    axes(handles.vor_plot);
    H = axis;
    axis auto
end

% --- Executes on button press in holdplot2.
function holdplot2_Callback(hObject, eventdata, handles)
% hObject    handle to holdplot2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    axes(handles.pbp_derive);
    H = axis;
    axis manual
elseif button_state == get(hObject,'Min')
    axes(handles.pbp_derive);
    H = axis;
    axis auto
end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over holdplot1.
function holdplot1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to holdplot1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function plot_raw_data(hObject,eventdata,handles)

switch handles.params.plot_toggle_flag
    
    case 1
        
        try
            if handles.params.L_1==1
                patchline(handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Data_LE_Pos_X,'edgecolor',handles.colors.l_x,'LineWidth',0.05,'edgealpha',0.5);
            end
            hold on
            if handles.params.L_2==1
                patchline(handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Data_LE_Pos_Y,'edgecolor',handles.colors.l_y,'LineWidth',0.05,'edgealpha',0.5);
            end
            if handles.params.L_3==1
                patchline(handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Data_LE_Pos_Z,'edgecolor',handles.colors.l_z,'LineWidth',0.05,'edgealpha',0.5);
            end
            
            if handles.params.R_1==1
                patchline(handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Data_RE_Pos_X,'edgecolor',handles.colors.r_x,'LineWidth',0.05,'edgealpha',0.5);
            end
            hold on
            if handles.params.R_2==1
                patchline(handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Data_RE_Pos_Y,'edgecolor',handles.colors.r_y,'LineWidth',0.05,'edgealpha',0.5);
            end
            if handles.params.R_3==1
                patchline(handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Data_RE_Pos_Z,'edgecolor',handles.colors.r_z,'LineWidth',0.05,'edgealpha',0.5);
            end
            
            xlabel(handles.vor_plot,'Time [s]');
            ylabel(handles.vor_plot,'Ang. Eye Position [\circ]');
        catch
            if handles.params.L_1==1
                plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Data_LE_Pos_X,'Color',[0,128,0]/255,'LineWidth',1)
            end
            hold on
            if handles.params.L_2==1
                plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Data_LE_Pos_Y,'b','LineWidth',1)
            end
            if handles.params.L_3==1
                plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Data_LE_Pos_Z,'r','LineWidth',1)
            end

            
            if handles.params.R_1==1
                plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Data_RE_Pos_X,'g','LineWidth',1)
            end
            hold on
            if handles.params.R_2==1
                plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Data_RE_Pos_Y,'Color',[64,224,208]/255,'LineWidth',1)
            end
            if handles.params.R_3==1
                plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Data_RE_Pos_Z,'Color',[255,0,255]/255,'LineWidth',1)
            end
            xlabel(handles.vor_plot,'Time [s]')
            ylabel(handles.vor_plot,'Ang. Eye Position [\circ]')
        end
        
        plot_angpos_deriv(hObject,eventdata,handles)
        
    case 2
        
        try
            if handles.params.L_1==1
                patchline(handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Data_LE_Vel_LARP,'edgecolor',[0,128,0]/255,'LineWidth',0.05,'edgealpha',0.5);
            end
            hold on
            if handles.params.L_2==1
                patchline(handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Data_LE_Vel_RALP,'edgecolor','b','LineWidth',0.05,'edgealpha',0.5);
            end
            if handles.params.L_3==1
                patchline(handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Data_LE_Vel_Z,'edgecolor','r','LineWidth',0.05,'edgealpha',0.5);
            end
            
            if handles.params.R_1==1
                patchline(handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Data_RE_Vel_LARP,'edgecolor','g','LineWidth',0.05,'edgealpha',0.5);
            end
            hold on
            if handles.params.R_2==1
                patchline(handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Data_RE_Vel_RALP,'edgecolor',[64,224,208]/255,'LineWidth',0.05,'edgealpha',0.5);
            end
            if handles.params.R_3==1
                patchline(handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Data_RE_Vel_Z,'edgecolor', [255,0,255]/255,'LineWidth',0.05,'edgealpha',0.5);
            end
            
            xlabel(handles.vor_plot,'Time [s]');
            ylabel(handles.vor_plot,'Ang. Eye Velocity [\circ/s]');

        catch
            if handles.params.L_1==1
                plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Data_LE_Vel_LARP,'Color',[0,128,0]/255,'LineWidth',1)
            end
            hold on
            if handles.params.L_2==1
                plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Data_LE_Vel_RALP,'b','LineWidth',1)
            end
            if handles.params.L_3==1
                plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Data_LE_Vel_Z,'r','LineWidth',1)
            end

            
            if handles.params.R_1==1
                plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Data_RE_Vel_LARP,'g','LineWidth',1)
            end
            hold on
            if handles.params.R_2==1
                plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Data_RE_Vel_RALP,'Color',[64,224,208]/255,'LineWidth',1)
            end
            if handles.params.R_3==1
                plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Data_RE_Vel_Z,'Color',[255,0,255]/255,'LineWidth',1)
            end
            xlabel(handles.vor_plot,'Time [s]')
            ylabel(handles.vor_plot,'Ang. Eye Velocity [\circ/s]')
            
        end
end


switch handles.CurrData.VOMA_data.Parameters.Stim_Info.Stim_Type{1}
    case 'Current Fitting'
        
        switch handles.CurrData.VOMA_data.Parameters.DAQ
            case 'Lasker_CED'
                plot(handles.vor_plot,handles.CurrData.VOMA_data.Stim_Trace(1,:),handles.params.stim_plot_mult*ones(1,length(handles.CurrData.VOMA_data.Stim_Trace(1,:))),'Marker','*','color','k','LineWidth',0.5)
                
            otherwise
                plot(handles.vor_plot,handles.CurrData.VOMA_data.Stim_t,handles.params.stim_plot_mult*handles.CurrData.VOMA_data.Stim_Trace,'k','LineWidth',0.5)
                
        end
        
        
    otherwise
        plot(handles.vor_plot,handles.CurrData.VOMA_data.Stim_t,handles.params.stim_plot_mult*handles.CurrData.VOMA_data.Stim_Trace,'k','LineWidth',0.5)
        
end



guidata(hObject,handles)

function plot_angpos_deriv(hObject,eventdata,handles)
% This function plots the 1st-order diff. of the eye angular position data
% Not that this is not a proper first order derivative (i.e., not the
% angular eye velocity) since it does not use the equation. This is only
% use to help the user visualize QPs when looking at angular position.
axes(handles.pbp_deriv)
cla
if handles.params.L_1==1
    plot(handles.CurrData.VOMA_data.Eye_t,gradient(handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_X),'Color',handles.colors.l_x)
end
hold on
if handles.params.L_2==1
    plot(handles.CurrData.VOMA_data.Eye_t,gradient(handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_Y),'Color',handles.colors.l_y)
end
if handles.params.L_3==1
    plot(handles.CurrData.VOMA_data.Eye_t,gradient(handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_Z),'Color',handles.colors.l_z)
end

if handles.params.R_1==1
    plot(handles.CurrData.VOMA_data.Eye_t,gradient(handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_X),'Color',handles.colors.r_x)
end
if handles.params.R_2==1
    plot(handles.CurrData.VOMA_data.Eye_t,gradient(handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_Y),'Color',handles.colors.r_y)
end
if handles.params.R_3==1
    plot(handles.CurrData.VOMA_data.Eye_t,gradient(handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_Z),'Color',handles.colors.r_z)
end

xlabel('Time [s]')
ylabel('Point-by-point Derivative magnitude')

function plot_smth_data(hObject,eventdata,handles)

switch handles.params.plot_toggle_flag
    
    case 1
        
        if handles.params.L_1==1
            plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t, handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_X,'Color',handles.colors.l_x,'LineWidth',1)
        end
        hold on
        if handles.params.L_2==1
            plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t, handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_Y,'Color',handles.colors.l_y,'LineWidth',1)
        end
        if handles.params.L_3==1
            plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t, handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_Z,'Color',handles.colors.l_z,'LineWidth',1)
        end
        
        if handles.params.R_1==1
            plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t, handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_X,'Color',handles.colors.r_x,'LineWidth',1)
        end
        hold on
        if handles.params.R_2==1
            plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t, handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_Y,'Color',handles.colors.r_y,'LineWidth',1)
        end
        if handles.params.R_3==1
            plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t, handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_Z,'Color',handles.colors.r_z,'LineWidth',1)
        end
        
        xlabel(handles.vor_plot,'Time [s]')
        ylabel(handles.vor_plot,'Eye Velocity [dps]')
        
        
    case 2
        
        
        if handles.params.L_1==1
            plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP,'Color',[0,128,0]/255,'LineWidth',1)
        end
        hold on
        if handles.params.L_2==1
            plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP,'b','LineWidth',1)
        end
        if handles.params.L_3==1
            plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z,'r','LineWidth',1)
        end
        
        if handles.params.R_1==1
            plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP,'g','LineWidth',1)
        end
        hold on
        if handles.params.R_2==1
            plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP,'Color',[64,224,208]/255,'LineWidth',1)
        end
        if handles.params.R_3==1
            plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z,'Color',[255,0,255]/255,'LineWidth',1)
        end
        
        xlabel(handles.vor_plot,'Time [s]')
        ylabel(handles.vor_plot,'Eye Velocity [dps]')
        if handles.params.L_1==1
            plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t(handles.CurrData.QPparams.UGQPRarray),handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP(handles.CurrData.QPparams.UGQPRarray),'ko','LineWidth',3);
        end
        if handles.params.L_2==1
            plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t(handles.CurrData.QPparams.UGQPRarray),handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP(handles.CurrData.QPparams.UGQPRarray),'ko','LineWidth',3);
        end
        if handles.params.L_3==1
            plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t(handles.CurrData.QPparams.UGQPRarray),handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z(handles.CurrData.QPparams.UGQPRarray),'ko','LineWidth',3);
        end
        
        if handles.params.R_1==1
            plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t(handles.CurrData.QPparams.UGQPRarray),handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP(handles.CurrData.QPparams.UGQPRarray),'ko','LineWidth',3);
        end
        if handles.params.R_2==1
            plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t(handles.CurrData.QPparams.UGQPRarray),handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP(handles.CurrData.QPparams.UGQPRarray),'ko','LineWidth',3);
        end
        if handles.params.R_3==1
            plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t(handles.CurrData.QPparams.UGQPRarray),handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z(handles.CurrData.QPparams.UGQPRarray),'ko','LineWidth',3);
        end
        
end

switch handles.CurrData.VOMA_data.Parameters.Stim_Info.Stim_Type{1}
    case 'Current Fitting'
        
        switch handles.CurrData.VOMA_data.Parameters.DAQ
            case 'Lasker_CED'
                plot(handles.vor_plot,handles.CurrData.VOMA_data.Stim_Trace(1,:),handles.params.stim_plot_mult*ones(1,length(handles.CurrData.VOMA_data.Stim_Trace(1,:))),'Marker','*','color','k','LineWidth',0.5)
                
            otherwise
                plot(handles.vor_plot,handles.CurrData.VOMA_data.Stim_t,handles.params.stim_plot_mult*handles.CurrData.VOMA_data.Stim_Trace,'k','LineWidth',0.5)
                
        end
        
        
    otherwise
        plot(handles.vor_plot,handles.CurrData.VOMA_data.Stim_t,handles.params.stim_plot_mult*handles.CurrData.VOMA_data.Stim_Trace,'k','LineWidth',0.5)
        
end
guidata(hObject,handles)


% --- Executes on button press in plot_raw_data.
function plot_raw_data_Callback(hObject, eventdata, handles)
% hObject    handle to plot_raw_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    handles.params.raw_data_flag = 1;
    
    if handles.params.filt_data_flag == 1
        axes(handles.vor_plot);
        cla
        plot_raw_data(hObject,eventdata,handles)
        hold on
        plot_spline_data(hObject,eventdata,handles)
        plot_smth_data(hObject,eventdata,handles)
        
    elseif handles.params.filt_data_flag == 0
        axes(handles.vor_plot);
        cla
        plot_raw_data(hObject,eventdata,handles)
        hold on
        plot_smth_data(hObject,eventdata,handles)
    end
    
elseif button_state == get(hObject,'Min')
    
    handles.params.raw_data_flag = 0;
    
    if handles.params.filt_data_flag == 1
        axes(handles.vor_plot);
        cla
        plot_spline_data(hObject,eventdata,handles)
        plot_smth_data(hObject,eventdata,handles)
        
    elseif handles.params.filt_data_flag == 0
        axes(handles.vor_plot);
        cla
        plot_smth_data(hObject,eventdata,handles)
    end
end
guidata(hObject,handles)


% Hint: get(hObject,'Value') returns toggle state of plot_raw_data


% --- Executes on button press in plot_filt_data.
function plot_filt_data_Callback(hObject, eventdata, handles)
% hObject    handle to plot_filt_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    handles.params.filt_data_flag = 1;
    
    if handles.params.raw_data_flag == 1
        axes(handles.vor_plot);
        cla
        plot_raw_data(hObject,eventdata,handles)
        hold on
        plot_spline_data(hObject,eventdata,handles)
        plot_smth_data(hObject,eventdata,handles)
        
    elseif handles.params.raw_data_flag == 0
        axes(handles.vor_plot);
        cla
        plot_spline_data(hObject,eventdata,handles)
        hold on
        plot_smth_data(hObject,eventdata,handles)
        
    end
    
    
elseif button_state == get(hObject,'Min')
    
    handles.params.filt_data_flag = 0;
    
    if handles.params.raw_data_flag == 1
        axes(handles.vor_plot);
        cla
        plot_raw_data(hObject,eventdata,handles)
        plot_smth_data(hObject,eventdata,handles)
        
    elseif handles.params.raw_data_flag == 0
        axes(handles.vor_plot);
        cla
        plot_smth_data(hObject,eventdata,handles)
    end
end
guidata(hObject,handles)

% Hint: get(hObject,'Value') returns toggle state of plot_filt_data

function plot_spline_data(hObject, eventdata, handles)
try
    if handles.params.L_1==1
        patchline(handles.CurrData.VOMA_data.Eye_t,handles.filter_noQPR.LE_Vel_LARP,'edgecolor',[0,128,0]/255,'LineWidth',0.05,'edgealpha',0.5);
    end
    hold on
    if handles.params.L_2==1
        patchline(handles.CurrData.VOMA_data.Eye_t,handles.filter_noQPR.LE_Vel_RALP,'edgecolor','b','LineWidth',0.05,'edgealpha',0.5);
    end
    if handles.params.L_3==1
        patchline(handles.CurrData.VOMA_data.Eye_t,handles.filter_noQPR.LE_Vel_Z,'edgecolor','r','LineWidth',0.05,'edgealpha',0.5);
    end
    
    if handles.params.R_1==1
        patchline(handles.CurrData.VOMA_data.Eye_t,handles.filter_noQPR.RE_Vel_LARP,'edgecolor','g','LineWidth',0.05,'edgealpha',0.5);
    end
    hold on
    if handles.params.R_2==1
        patchline(handles.CurrData.VOMA_data.Eye_t,handles.filter_noQPR.RE_Vel_RALP,'edgecolor',[64,224,208]/255,'LineWidth',0.05,'edgealpha',0.5);
    end
    if handles.params.R_3==1
        patchline(handles.CurrData.VOMA_data.Eye_t,handles.filter_noQPR.RE_Vel_Z,'edgecolor',[255,0,255]/255,'LineWidth',0.05,'edgealpha',0.5);
    end
    xlabel(handles.vor_plot,'Time [s]');
    ylabel(handles.vor_plot,'Eye Velocity [dps]');

catch
    if handles.params.L_1==1
        plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t,handles.filter_noQPR.LE_Vel_LARP,'Color',[0,128,0]/255,'LineWidth',1)
    end
    hold on
    if handles.params.L_2==1
        plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t,handles.filter_noQPR.LE_Vel_RALP,'b','LineWidth',1)
    end
    if handles.params.L_3==1
        plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t,handles.filter_noQPR.LE_Vel_Z,'r','LineWidth',1)
    end
    
    if handles.params.R_1==1
        plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t,handles.filter_noQPR.RE_Vel_LARP,'g','LineWidth',1)
    end
    hold on
    if handles.params.R_2==1
        plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t,handles.filter_noQPR.RE_Vel_RALP,'Color',[64,224,208]/255,'LineWidth',1)
    end
    if handles.params.R_3==1
        plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t,handles.filter_noQPR.RE_Vel_Z,'Color',[255,0,255]/255,'LineWidth',1)
    end
    xlabel(handles.vor_plot,'Time [s]')
    ylabel(handles.vor_plot,'Eye Velocity [dps]')

end
switch handles.CurrData.VOMA_data.Parameters.Stim_Info.Stim_Type{1}
    case 'Current Fitting'
        plot(handles.vor_plot,handles.CurrData.VOMA_data.Stim_Trace(1,:),200*ones(1,length(handles.CurrData.VOMA_data.Stim_Trace(1,:))),'Marker','*','color','k','LineWidth',0.5)
    otherwise
        plot(handles.vor_plot,handles.CurrData.VOMA_data.Stim_t,handles.CurrData.VOMA_data.Stim_Trace,'k','LineWidth',0.5)
end
guidata(hObject,handles)

% --- Executes on button press in open_voranalysis.
function open_voranalysis_Callback(hObject, eventdata, handles)
% hObject    handle to open_voranalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.params.smooth_flag == 1;
    
    
%     DataSmth.filename = handles.ind_filename;
%     DataSmth.batch_filename = handles.filename;
%     DataSmth.pathname = handles.pathname;
%     DataSmth.Fs = handles.Fs;
%     DataSmth.t = handles.t;
%     DataSmth.ll = handles.l_l_smooth;
%     DataSmth.lr = handles.l_r_smooth;
%     DataSmth.lz = handles.l_z_smooth;
%     DataSmth.rl = handles.r_l_smooth;
%     DataSmth.rr = handles.r_r_smooth;
%     DataSmth.rz = handles.r_z_smooth;
%     
%     DataSmth.stim_ind = handles.stim_ind;
%     DataSmth.Mapping = handles.Mapping;
%     DataSmth.Stimulus = handles.Stimulus;
%     DataSmth.DAQ = handles.DAQ;
%     DataSmth.curr_file = handles.curr_file;
%     
%     QPparams.e_vel_param1 = handles.params.e_vel_param1;
%     QPparams.e_vel_param2 = handles.params.e_vel_param2;
%     QPparams.e_vel_param3 = handles.params.e_vel_param3;
%     QPparams.e_vel_param4 = handles.params.e_vel_param4;
%     QPparams.e_vel_param5 = handles.params.e_vel_param5;
%     QPparams.qpr_routine = handles.params.qpr_routine;
%     QPparams.UGQPRarray = handles.UGQPRarray;
%     
%     QPparams.filt_params = get(handles.filt_params,'Data');
%     
%     DataSmth.stim_trace = handles.stim;
%     
%     DataSmth.QPparams = QPparams;
%     
%     if (isfield(handles,'cyc2plot')) && (~isempty(handles.cyc2plot))
%         DataSmth.cyc2plot = handles.CurrData.cyc2plot;
%     end
    
    % Input both the 'smooth' data traces with QPs removed, as well as the
    % entire data file. The second input is used so a user can save their list
    % of saved cycles.
    voma__cycle_analysis_gui(handles.CurrData,handles.RootData,handles.curr_file,handles.pathname,handles.filename)
    
elseif handles.params.smooth_flag == 0;
        
    % Construct a questdlg with three options
    choice = questdlg('You haven''t smoothed the present data trace yet. You need to do so before you can proceed', ...
        'QPR GUI Error', ...
        'OK, let me go back.','Continue into the Cycle Analysis GUI');
    % Handle response
    switch choice
        case 'OK, let me go back.'

        case 'Continue into the Cycle Analysis GUI'
    % Input both the 'smooth' data traces with QPs removed, as well as the
    % entire data file. The second input is used so a user can save their list
    % of saved cycles.
    voma__cycle_analysis_gui(handles.CurrData,handles.RootData,handles.curr_file,handles.pathname,handles.filename)

    end
    
end


function e_vel_param1_Callback(hObject, eventdata, handles)
% hObject    handle to e_vel_param1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
e_vel_param1 = str2double(get(hObject,'String'));
if isnan(e_vel_param1)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.params.e_vel_param1 = e_vel_param1;
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of e_vel_param1 as text
%        str2double(get(hObject,'String')) returns contents of e_vel_param1 as a double


% --- Executes during object creation, after setting all properties.
function e_vel_param1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_vel_param1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_qp_params.
function save_qp_params_Callback(hObject, eventdata, handles)
% hObject    handle to save_qp_params (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[handles] = update_eye_vel(hObject, eventdata, handles, 2);

% Even though the user may have normalized the time vector for plotting
% purposes, we will reload the time vector for clarity. 
handles.CurrData.VOMA_data.Eye_t = handles.RootData(handles.curr_file).VOMA_data.Eye_t;
handles.CurrData.VOMA_data.Stim_t = handles.RootData(handles.curr_file).VOMA_data.Stim_t;

handles.CurrData.QPparams.filt_params = get(handles.filt_params,'Data');

handles.RootData(handles.curr_file).VOMA_data = handles.CurrData.VOMA_data;
handles.RootData(handles.curr_file).SoftwareVer = handles.CurrData.SoftwareVer;
handles.RootData(handles.curr_file).QPparams = handles.CurrData.QPparams;
handles.RootData(handles.curr_file).cyc2plot = handles.CurrData.cyc2plot;

RootData = handles.RootData; 

cd(handles.pathname);

eval(['save ' handles.filename ' RootData'])


handles.reload_flag = 1;

analyze_new_file_Callback(hObject, 1, handles)

% We have nested changes to the GUI's handles, so I want to pull them
% from the global hObject variable
handles = guidata(hObject);

% Now set the 'reload_flag'
handles.reload_flag =0;

% Mark the file as UNSAVED
handles.params.save_flag = false;

[handles] = update_eye_pos(hObject, eventdata, handles, 3);
[handles] = update_eye_vel(hObject, eventdata, handles, 3);

% Globally save the handles
guidata(hObject, handles);



% --- Executes on selection change in qpr_routine.
function qpr_routine_Callback(hObject, eventdata, handles,flag)
% hObject    handle to qpr_routine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This checks if the user included a 'flag' input. If the 'flag' variable
% exists, then the user has called this routine directly and we do not want
% to touch the dynamic object. 
if ~exist('flag','var')
    
    handles.CurrData.QPparams.qpr_routine =  get(hObject,'Value');
end


switch handles.CurrData.QPparams.qpr_routine
    
    case 1 % Spline
        set(handles.e_vel_param6,'Visible','off')
        set(handles.e_vel_param6_txt,'Visible','off')
        set(handles.e_vel_param4_txt,'String','Spline Param.')
        
        handles.params.qpr_routine_string = 'Spline';
    case 2 % Moving Average
        set(handles.e_vel_param6,'Visible','off')
        set(handles.e_vel_param6_txt,'Visible','off')
        set(handles.e_vel_param4_txt,'String','Frame Length [odd]')
        
        handles.params.qpr_routine_string = 'MovAvg';
        
    case 3 % S.G. Filter
        
        set(handles.e_vel_param6,'Visible','on')
        set(handles.e_vel_param6_txt,'Visible','on')
        
        set(handles.e_vel_param4_txt,'String','Frame Length [odd]')
        
        handles.params.qpr_routine_string = 'SGFilter';
end



guidata(hObject,handles)
% Hints: contents = cellstr(get(hObject,'String')) returns qpr_routine contents as cell array
%        contents{get(hObject,'Value')} returns selected item from qpr_routine


% --- Executes during object creation, after setting all properties.
function qpr_routine_CreateFcn(hObject, eventdata, handles)
% hObject    handle to qpr_routine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in UGQPR_choose.
function UGQPR_choose_Callback(hObject, eventdata, handles)
% hObject    handle to UGQPR_choose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



h = questdlg(['You have started User Guided QPR. This will allow you to fine-tune your QPR data analysis' ...
    ' by choosing particular sections of data traces to remove. You will click on the end-points of your QP to remove the data. Click ''OK'' to continue.'] ...
    ,'User Guided QPR','OK','Nevermind','Nevermind');

switch h
    
    case 'OK'
        % Ask user for two input points
        
        uiwait(msgbox('Click ''OK'' when you are ready to choose the first data point','User Guided QPR'));
        [x1,y1] = ginput(1);
        uiwait(msgbox('Click ''OK'' when you are ready to choose the second data point','User Guided QPR'));
        [x2,y2] = ginput(1);
        x = [x1 ; x2];
        
        if iscolumn(handles.CurrData.VOMA_data.Stim_t)
            handles.CurrData.VOMA_data.Stim_t = handles.CurrData.VOMA_data.Stim_t';
            
        end
        
        [temp,i1] = min(abs(handles.CurrData.VOMA_data.Stim_t([1 1],:) - x(:,ones(1,length(handles.CurrData.VOMA_data.Stim_t)))),[],2);
        
        
        
        handles.CurrData.QPparams.UGQPRarray = [handles.CurrData.QPparams.UGQPRarray ; i1'];
        
        set(handles.UGQPR_table,'Data',handles.CurrData.VOMA_data.Stim_t(handles.CurrData.QPparams.UGQPRarray))
        
        
        plot(handles.vor_plot,handles.CurrData.VOMA_data.Stim_t(i1),handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP(i1),'ko','LineWidth',3);
        plot(handles.vor_plot,handles.CurrData.VOMA_data.Stim_t(i1),handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP(i1),'ko','LineWidth',3);
        plot(handles.vor_plot,handles.CurrData.VOMA_data.Stim_t(i1),handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z(i1),'ko','LineWidth',3);
        
        plot(handles.vor_plot,handles.CurrData.VOMA_data.Stim_t(i1),handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP(i1),'ko','LineWidth',3);
        plot(handles.vor_plot,handles.CurrData.VOMA_data.Stim_t(i1),handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP(i1),'ko','LineWidth',3);
        plot(handles.vor_plot,handles.CurrData.VOMA_data.Stim_t(i1),handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z(i1),'ko','LineWidth',3);
        
    case 'Nevermind'
        
        
end
guidata(hObject,handles)


% --- Executes on button press in UGQPR_go.
function UGQPR_go_Callback(hObject, eventdata, handles)
% hObject    handle to UGQPR_go (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


for n=1:size(handles.CurrData.QPparams.UGQPRarray,1)
    
    k1 = handles.CurrData.QPparams.UGQPRarray(n,1);
    k2 = handles.CurrData.QPparams.UGQPRarray(n,2);
    
    handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP(k1:k2)=spline([k1 k2],[0 handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP(k1) handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP(k2) 0], k1:k2);
    handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP(k1:k2)=spline([k1 k2],[0 handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP(k1) handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP(k2) 0], k1:k2);
    handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z(k1:k2)=spline([k1 k2],[0 handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z(k1) handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z(k2) 0], k1:k2);
    
    handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP(k1:k2)=spline([k1 k2],[0 handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP(k1) handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP(k2) 0], k1:k2);
    handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP(k1:k2)=spline([k1 k2],[0 handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP(k1) handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP(k2) 0], k1:k2);
    handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z(k1:k2)=spline([k1 k2],[0 handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z(k1) handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z(k2) 0], k1:k2);
    
end

plot_filt_data_Callback(hObject, eventdata, handles)

[handles] = update_eye_vel(hObject, eventdata, handles, 1);


guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function UGQPR_table_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UGQPR_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when selected cell(s) is changed in UGQPR_table.
function UGQPR_table_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to UGQPR_table (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
indices = eventdata.Indices;
r = indices(:,1);
c = indices(:,2);

handles.params.r = r;

set(handles.UGQPR_start_text,'string',handles.CurrData.VOMA_data.Stim_t(handles.CurrData.QPparams.UGQPRarray(r,1)));
set(handles.UGQPR_end_text,'string',handles.CurrData.VOMA_data.Stim_t(handles.CurrData.QPparams.UGQPRarray(r,2)));

guidata(hObject,handles)




% --- Executes on button press in remove_UGQPRpt.
function remove_UGQPRpt_Callback(hObject, eventdata, handles)
% hObject    handle to remove_UGQPRpt (see GCBO)

% Remove the data points from the 
if isfield(handles.params,'r') && ~isempty(handles.params.r)
    r = handles.params.r;
    handles.CurrData.QPparams.UGQPRarray = handles.CurrData.QPparams.UGQPRarray([true(1,r-1) false(1,1) true(1,size(handles.CurrData.QPparams.UGQPRarray,1)-r)],:);
    guidata(hObject,handles)
    r = [];
    plot_filt_data_Callback(hObject, eventdata, handles)
    
    set(handles.UGQPR_table,'Data',handles.CurrData.VOMA_data.Stim_t(handles.CurrData.QPparams.UGQPRarray))
    
else
    
    msgbox('You have tried to delete a UGQPR point without selecting which point to delete. Please click on a cell in either column for the row you want to delete.','User Guided QPR')
    
end

[handles] = update_eye_vel(hObject, eventdata, handles, 1);

guidata(hObject,handles)

% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in spline_sep_flag.
function spline_sep_flag_Callback(hObject, eventdata, handles)
% hObject    handle to spline_sep_flag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.params.spline_sep_flag = get(hObject,'Value');

% Hint: get(hObject,'Value') returns toggle state of spline_sep_flag
guidata(hObject,handles)


% --- Executes on button press in R_1.
function R_1_Callback(hObject, eventdata, handles)
% hObject    handle to R_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.params.R_1 = 1;
else
    handles.params.R_1 = 0;
end
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of R_1


% --- Executes on button press in R_2.
function R_2_Callback(hObject, eventdata, handles)
% hObject    handle to R_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.params.R_2 = 1;
else
    handles.params.R_2 = 0;
end
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of R_2


% --- Executes on button press in R_3.
function R_3_Callback(hObject, eventdata, handles)
% hObject    handle to R_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.params.R_3 = 1;
else
    handles.params.R_3 = 0;
end
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of R_3


% --- Executes on button press in L_1.
function L_1_Callback(hObject, eventdata, handles)
% hObject    handle to L_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.params.L_1 = 1;
else
    handles.params.L_1 = 0;
end
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of L_1


% --- Executes on button press in L_2.
function L_2_Callback(hObject, eventdata, handles)
% hObject    handle to L_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.params.L_2 = 1;
else
    handles.params.L_2 = 0;
end
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of L_2


% --- Executes on button press in L_3.
function L_3_Callback(hObject, eventdata, handles)
% hObject    handle to L_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.params.L_3 = 1;
else
    handles.params.L_3 = 0;
end
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of L_3


% --- Executes on selection change in spline_sep_flag.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to spline_sep_flag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns spline_sep_flag contents as cell array
%        contents{get(hObject,'Value')} returns selected item from spline_sep_flag


% --- Executes during object creation, after setting all properties.
function spline_sep_flag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spline_sep_flag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox9


% --- Executes on button press in angvel_angpos_toggle.
function angvel_angpos_toggle_Callback(hObject, eventdata, handles)
% hObject    handle to angvel_angpos_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.angvel_angpos_toggle,'String','ANGULAR POSITION')
    set(handles.angvel_params,'Visible','off')
    set(handles.angpos_params,'Visible','on')
    
    handles.params.plot_toggle_flag = 1;
    
    
    
    axes(handles.vor_plot);
    ylabel('Ang. Eye Position [\circ]')
    cla
    plot_raw_data(hObject,eventdata,handles)
    
    % Change plot legend
    set(handles.L_1,'String','X')
    set(handles.L_2,'String','Y')
    set(handles.L_3,'String','LHRH')
    
    set(handles.R_1,'String','X')
    set(handles.R_2,'String','Y')
    set(handles.R_3,'String','LHRH')
    
    
    set(handles.L_1_color,'BackgroundColor',handles.colors.l_x);
    set(handles.L_2_color,'BackgroundColor',handles.colors.l_y);
    set(handles.L_3_color,'BackgroundColor',handles.colors.l_z);
    
    set(handles.R_1_color,'BackgroundColor',handles.colors.r_x);
    set(handles.R_2_color,'BackgroundColor',handles.colors.r_y);
    set(handles.R_3_color,'BackgroundColor',handles.colors.r_z);
    
    switch handles.params.pos_filt_method
        
        case 1
            set(handles.angpos_param1_txt,'String','Filter Order')
            set(handles.angpos_param2_txt,'String','Frame Length')
        case 2
            
            set(handles.angpos_param1_txt,'String','Filter Order')
            set(handles.angpos_param2_txt,'String','Up = 1, Low = 2')
        case 3
            set(handles.angpos_param1_txt,'String','Filter Order')
            set(handles.angpos_param2_txt,'String','NOT IN USE')
    end
    
elseif button_state == get(hObject,'Min')
    
    % Clear the 'point-by-point' derivative plot
    axes(handles.pbp_deriv)
    cla
    
    set(handles.angvel_angpos_toggle,'String','ANGULAR VELOCITY')
    set(handles.angvel_params,'Visible','on')
    set(handles.angpos_params,'Visible','off')
    
    handles.params.plot_toggle_flag = 2;
    
    axes(handles.vor_plot);
    ylabel('Ang. Eye Position [\circ/s]')
    cla
    plot_raw_data(hObject,eventdata,handles)
    
    % Change plot legend
    set(handles.L_1,'String','LARP')
    set(handles.L_2,'String','RALP')
    set(handles.L_3,'String','LHRH')
    
    set(handles.R_1,'String','LARP')
    set(handles.R_2,'String','RALP')
    set(handles.R_3,'String','LHRH')
    
    set(handles.L_1_color,'BackgroundColor',handles.colors.l_l);
    set(handles.L_2_color,'BackgroundColor',handles.colors.l_r);
    set(handles.L_3_color,'BackgroundColor',handles.colors.l_z);
    
    set(handles.R_1_color,'BackgroundColor',handles.colors.r_l);
    set(handles.R_2_color,'BackgroundColor',handles.colors.r_r);
    set(handles.R_3_color,'BackgroundColor',handles.colors.r_z);
    
end
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of angvel_angpos_toggle


% --- Executes on selection change in angpos_filt_type.
function angpos_filt_type_Callback(hObject, eventdata, handles)
% hObject    handle to angpos_filt_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index_selected = get(hObject,'Value');
handles.params.pos_filt_method = index_selected;

switch handles.params.pos_filt_method
    
    case 1
        set(handles.angpos_param1_txt,'String','Filter Order')
        set(handles.angpos_param2_txt,'String','Frame Length')
    case 2
        
        set(handles.angpos_param1_txt,'String','Filter Order')
        set(handles.angpos_param2_txt,'String','Up = 1, Low = 2')
        
    case 3
        set(handles.angpos_param1_txt,'String','Filter Order')
        set(handles.angpos_param2_txt,'String','NOT IN USE')
end

guidata(hObject,handles)
% Hints: contents = cellstr(get(hObject,'String')) returns angpos_filt_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from angpos_filt_type


% --- Executes during object creation, after setting all properties.
function angpos_filt_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angpos_filt_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in angpos_filt_trace_select.
function angpos_filt_trace_select_Callback(hObject, eventdata, handles)
% hObject    handle to angpos_filt_trace_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index_selected = get(hObject,'Value');
handles.params.pos_filt_trace = index_selected;

filt_params = get(handles.filt_params,'Data');
if ~isempty(filt_params{handles.params.pos_filt_trace+1,2})
    
    handles.params.angpos_filt_param1 = filt_params{handles.params.pos_filt_trace+1,3};
    set(handles.angpos_filt_param1,'String',handles.params.angpos_filt_param1);
    handles.params.angpos_filt_param2 = filt_params{handles.params.pos_filt_trace+1,4};
    set(handles.angpos_filt_param2,'String',handles.params.angpos_filt_param2);
    
    switch filt_params{handles.params.pos_filt_trace+1,2}
        
        case 'S. Golay'
            set(handles.angpos_filt_type,'Value',1)
            handles.params.pos_filt_method = 1;
        case 'Env. Filt.'
            set(handles.angpos_filt_type,'Value',2)
            handles.params.pos_filt_method = 2;
        case 'Median Filter'
            set(handles.angpos_filt_type,'Value',3)
            handles.params.pos_filt_method = 3;
    end
end


guidata(hObject,handles)

% Hints: contents = cellstr(get(hObject,'String')) returns angpos_filt_trace_select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from angpos_filt_trace_select


% --- Executes during object creation, after setting all properties.
function angpos_filt_trace_select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angpos_filt_trace_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function angpos_filt_param1_Callback(hObject, eventdata, handles)
% hObject    handle to angpos_filt_param1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input = get(hObject,'String');
handles.params.angpos_filt_param1 = str2double(input);
guidata(hObject,handles)

% Hints: get(hObject,'String') returns contents of angpos_filt_param1 as text
%        str2double(get(hObject,'String')) returns contents of angpos_filt_param1 as a double


% --- Executes during object creation, after setting all properties.
function angpos_filt_param1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angpos_filt_param1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function angpos_filt_param2_Callback(hObject, eventdata, handles)
% hObject    handle to angpos_filt_param2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input = get(hObject,'String');
handles.params.angpos_filt_param2 = str2double(input);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of angpos_filt_param2 as text
%        str2double(get(hObject,'String')) returns contents of angpos_filt_param2 as a double


% --- Executes during object creation, after setting all properties.
function angpos_filt_param2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angpos_filt_param2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in apply_angpos_filt.
function apply_angpos_filt_Callback(hObject, eventdata, handles)
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
        filt_type = 'S. Golay';
        filt_param1 = handles.params.angpos_filt_param1;
        filt_param2 = handles.params.angpos_filt_param2;
        filt_param3 = '';
    case 2
        temp(isnan(temp)) = 0;
        [envHigh, envLow] = envelope(temp,handles.params.angpos_filt_param1,'peak');
        filt_type = 'Env. Filt.';
        filt_param1 = handles.params.angpos_filt_param1;
        filt_param2 = handles.params.angpos_filt_param2;
        filt_param3 = '';
        
        switch handles.params.angpos_filt_param2
            case 1
                temp_smth = envHigh;
            case 2
                temp_smth = envLow;
            otherwise
                h = msgbox({'The second input parameter for the Envelope Filter MUST be either:' '1: Use Upper Envelope' '2: Use Lower Envelope'});
                return
        end
        
    case 3
        
        temp_smth = medfilt1(temp,handles.params.angpos_filt_param1);
        filt_type = 'Median Filter';
        filt_param1 = handles.params.angpos_filt_param1;
        filt_param2 = '';
        filt_param3 = '';
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


axes(handles.vor_plot)
cla
hold on
plot_smth_data(hObject,eventdata,handles)

filt_params = get(handles.filt_params,'Data');
filt_params{handles.params.pos_filt_trace + 1,2} = filt_type;
filt_params{handles.params.pos_filt_trace + 1,3} = filt_param1;
filt_params{handles.params.pos_filt_trace + 1,4} = filt_param2;
filt_params{handles.params.pos_filt_trace + 1,5} = filt_param3;
set(handles.filt_params,'Data',filt_params);


[handles] = update_eye_pos(hObject, eventdata, handles, 1);

guidata(hObject,handles)

% --- Executes on button press in recalc_angvel.
function recalc_angvel_Callback(hObject, eventdata, handles)
% hObject    handle to recalc_angvel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This system code marks that no additional manipulations of the raw data
% are required.
data_rot = 1;


DAQ_code = handles.CurrData.VOMA_data.Parameters.DAQ_code;

% Store Relevant Ocular Ang. Pos. data in the proper format for the
% 'processeyemovements' function
Data_In.Data_LE_Pos_X = handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_X;
Data_In.Data_LE_Pos_Y = handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_Y;
Data_In.Data_LE_Pos_Z = handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_Z;

Data_In.Data_RE_Pos_X = handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_X;
Data_In.Data_RE_Pos_Y = handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_Y;
Data_In.Data_RE_Pos_Z = handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_Z;

Data_In.Fs = handles.CurrData.VOMA_data.Fs;

[New_Ang_Vel] = voma__processeyemovements([],[],[],[],0,data_rot,DAQ_code,Data_In);

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

[handles] = update_eye_pos(hObject, eventdata, handles, 2);

handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP = handles.CurrData.VOMA_data.Data_LE_Vel_LARP;
handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP = handles.CurrData.VOMA_data.Data_LE_Vel_RALP;
handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z = handles.CurrData.VOMA_data.Data_LE_Vel_Z;
handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP = handles.CurrData.VOMA_data.Data_RE_Vel_LARP;
handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP = handles.CurrData.VOMA_data.Data_RE_Vel_RALP;
handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z = handles.CurrData.VOMA_data.Data_RE_Vel_Z;

guidata(hObject,handles)


% --- Executes on button press in reset_angpos_trace.
function reset_angpos_trace_Callback(hObject, eventdata, handles)
% hObject    handle to reset_angpos_trace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch handles.params.pos_filt_trace
    
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

filt_params = get(handles.filt_params,'Data');
filt_params{handles.params.pos_filt_trace + 1,2} = '';
filt_params{handles.params.pos_filt_trace + 1,3} = '';
filt_params{handles.params.pos_filt_trace + 1,4} = '';
filt_params{handles.params.pos_filt_trace + 1,5} = '';
set(handles.filt_params,'Data',filt_params);

% Update the user indicator that the position traces were changed
[handles] = update_eye_pos(hObject, eventdata, handles, 1);

guidata(hObject,handles)



function stim_plot_mult_Callback(hObject, eventdata, handles)
% hObject    handle to stim_plot_mult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input = str2double(get(hObject,'String'));
handles.params.stim_plot_mult = input;

axes(handles.vor_plot);
cla
plot_raw_data(hObject,eventdata,handles)

guidata(hObject,handles)

% Hints: get(hObject,'String') returns contents of stim_plot_mult as text
%        str2double(get(hObject,'String')) returns contents of stim_plot_mult as a double


% --- Executes during object creation, after setting all properties.
function stim_plot_mult_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim_plot_mult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in norm_time.
function norm_time_Callback(hObject, eventdata, handles)
% hObject    handle to norm_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Reset the time vector
handles.CurrData.VOMA_data.Eye_t = handles.RootData(handles.curr_file).VOMA_data.Eye_t;


if (get(hObject,'Value') == get(hObject,'Max'))
    handles.params.norm_time = true;
    handles.CurrData.VOMA_data.Eye_t = handles.CurrData.VOMA_data.Eye_t - handles.CurrData.VOMA_data.Eye_t(1);
    handles.CurrData.VOMA_data.Stim_t = handles.CurrData.VOMA_data.Stim_t - handles.CurrData.VOMA_data.Stim_t(1);
else
    handles.params.norm_time = false;
    
    
    handles.CurrData.VOMA_data.Eye_t = handles.RootData(handles.curr_file).VOMA_data.Eye_t;
    handles.CurrData.VOMA_data.Stim_t = handles.RootData(handles.curr_file).VOMA_data.Stim_t;

    
end

axes(handles.vor_plot);
cla
plot_raw_data(hObject,eventdata,handles)

guidata(hObject,handles)


% Hint: get(hObject,'Value') returns toggle state of norm_time


function [handles] = update_eye_pos(hObject, eventdata, handles, flag)

switch flag
    case 1 % The Eye Position Traces were changed
        set(handles.recalc_angvel_ind,'BackgroundColor','r')
        set(handles.recalc_angvel_ind,'String',['Eye pos. traces were changed!'])
        % Mark the file as UNSAVED
        handles.params.save_flag = true;
    case 2 % Eye Velocities were Recalculated
        set(handles.recalc_angvel_ind,'BackgroundColor','y')
        set(handles.recalc_angvel_ind,'String',['AngVel Recal. @ ' char(datetime)])
        % Mark the file as SAVED
        handles.params.save_flag = false;
    case 3 % Eye position Data was Saved!
        set(handles.recalc_angvel_ind,'BackgroundColor','g')
        set(handles.recalc_angvel_ind,'String',['Changes Saved @ ' char(datetime)])
        % Mark the file as SAVED
        handles.params.save_flag = false;
end

function [handles] = update_eye_vel(hObject, eventdata, handles, flag)

switch flag
    case 1 % The Eye Velocity Traces were changed
        set(handles.save_status,'BackgroundColor','yellow')
        set(handles.save_status,'String','Unsaved QP Params.')
        set(handles.save_status,'FontSize',12)
        drawnow
        % Mark the file as UNSAVED
        handles.params.save_flag = true;
        
    case 2 % Saving in progress
        set(handles.save_status,'FontSize',12)
        set(handles.save_status,'BackgroundColor','red');
        set(handles.save_status,'String','Saving...')
        
    case 3 % Entire QPR structure was saved!
        
        set(handles.save_status,'BackgroundColor','green')
        set(handles.save_status,'String',['Filter Settings Saved @ ' char(datetime)])
        set(handles.save_status,'FontSize',9)
        drawnow
        % Mark the file as SAVED
        handles.params.save_flag = false;
        
    case 4
        set(handles.save_status,'BackgroundColor','green')
        set(handles.save_status,'String',['Loaded Filter Params From File'])
        set(handles.save_status,'FontSize',9)
        drawnow
        % Mark the file as SAVED
        handles.params.save_flag = false;
        
end


function [handles] = update_angvel_filt_options(hObject, eventdata, handles)

switch handles.CurrData.QPparams.qpr_routine
    
    case 1 % Spline
        set(handles.e_vel_param4,'Enable','on')
        set(handles.text5,'String','Derivative Threshold')
    case 2
        
end



function e_vel_param6_Callback(hObject, eventdata, handles)
% hObject    handle to e_vel_param6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input = get(hObject,'String');
handles.params.e_vel_param6 = str2double(input);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of e_vel_param6 as text
%        str2double(get(hObject,'String')) returns contents of e_vel_param6 as a double


% --- Executes during object creation, after setting all properties.
function e_vel_param6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_vel_param6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in link_x_axis_plots.
function link_x_axis_plots_Callback(hObject, eventdata, handles)
% hObject    handle to link_x_axis_plots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.params.link_x_axis_plots = true;
    
    linkaxes([handles.vor_plot,handles.pbp_deriv],'x')
    
else
    handles.params.link_x_axis_plots = false;
    
    
    linkaxes([handles.vor_plot,handles.pbp_deriv],'off')

    
end

% Hint: get(hObject,'Value') returns toggle state of link_x_axis_plots


% --- Executes on button press in lin_interp_nans.
function lin_interp_nans_Callback(hObject, eventdata, handles)
% hObject    handle to lin_interp_nans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

inds = [1:length(handles.CurrData.VOMA_data.Data_LE_Pos_X)]';

handles.CurrData.VOMA_data.Data_LE_Pos_X(isnan(handles.CurrData.VOMA_data.Data_LE_Pos_X)) = interp1(inds(~isnan(handles.CurrData.VOMA_data.Data_LE_Pos_X)),handles.CurrData.VOMA_data.Data_LE_Pos_X(~isnan(handles.CurrData.VOMA_data.Data_LE_Pos_X)),inds(isnan(handles.CurrData.VOMA_data.Data_LE_Pos_X)));
handles.CurrData.VOMA_data.Data_LE_Pos_Y(isnan(handles.CurrData.VOMA_data.Data_LE_Pos_Y)) = interp1(inds(~isnan(handles.CurrData.VOMA_data.Data_LE_Pos_Y)),handles.CurrData.VOMA_data.Data_LE_Pos_Y(~isnan(handles.CurrData.VOMA_data.Data_LE_Pos_Y)),inds(isnan(handles.CurrData.VOMA_data.Data_LE_Pos_Y)));
handles.CurrData.VOMA_data.Data_LE_Pos_Z(isnan(handles.CurrData.VOMA_data.Data_LE_Pos_Z)) = interp1(inds(~isnan(handles.CurrData.VOMA_data.Data_LE_Pos_Z)),handles.CurrData.VOMA_data.Data_LE_Pos_Z(~isnan(handles.CurrData.VOMA_data.Data_LE_Pos_Z)),inds(isnan(handles.CurrData.VOMA_data.Data_LE_Pos_Z)));

handles.CurrData.VOMA_data.Data_RE_Pos_X(isnan(handles.CurrData.VOMA_data.Data_RE_Pos_X)) = interp1(inds(~isnan(handles.CurrData.VOMA_data.Data_RE_Pos_X)),handles.CurrData.VOMA_data.Data_RE_Pos_X(~isnan(handles.CurrData.VOMA_data.Data_RE_Pos_X)),inds(isnan(handles.CurrData.VOMA_data.Data_RE_Pos_X)));
handles.CurrData.VOMA_data.Data_RE_Pos_Y(isnan(handles.CurrData.VOMA_data.Data_RE_Pos_Y)) = interp1(inds(~isnan(handles.CurrData.VOMA_data.Data_RE_Pos_Y)),handles.CurrData.VOMA_data.Data_RE_Pos_Y(~isnan(handles.CurrData.VOMA_data.Data_RE_Pos_Y)),inds(isnan(handles.CurrData.VOMA_data.Data_RE_Pos_Y)));
handles.CurrData.VOMA_data.Data_RE_Pos_Z(isnan(handles.CurrData.VOMA_data.Data_RE_Pos_Z)) = interp1(inds(~isnan(handles.CurrData.VOMA_data.Data_RE_Pos_Z)),handles.CurrData.VOMA_data.Data_RE_Pos_Z(~isnan(handles.CurrData.VOMA_data.Data_RE_Pos_Z)),inds(isnan(handles.CurrData.VOMA_data.Data_RE_Pos_Z)));

handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_X(isnan(handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_X)) = interp1(inds(~isnan(handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_X)),handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_X(~isnan(handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_X)),inds(isnan(handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_X)));
handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_Y(isnan(handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_Y)) = interp1(inds(~isnan(handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_Y)),handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_Y(~isnan(handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_Y)),inds(isnan(handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_Y)));
handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_Z(isnan(handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_Z)) = interp1(inds(~isnan(handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_Z)),handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_Z(~isnan(handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_Z)),inds(isnan(handles.CurrData.VOMA_data.Filtered.Data_LE_Pos_Z)));

handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_X(isnan(handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_X)) = interp1(inds(~isnan(handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_X)),handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_X(~isnan(handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_X)),inds(isnan(handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_X)));
handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_Y(isnan(handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_Y)) = interp1(inds(~isnan(handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_Y)),handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_Y(~isnan(handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_Y)),inds(isnan(handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_Y)));
handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_Z(isnan(handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_Z)) = interp1(inds(~isnan(handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_Z)),handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_Z(~isnan(handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_Z)),inds(isnan(handles.CurrData.VOMA_data.Filtered.Data_RE_Pos_Z)));


plot_smth_data(hObject,eventdata,handles)

guidata(hObject,handles)



function post_qpr_filt_param1_Callback(hObject, eventdata, handles)
% hObject    handle to post_qpr_filt_param1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.params.post_qpr_filt_param1 = str2double(get(hObject,'String'));


guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of post_qpr_filt_param1 as text
%        str2double(get(hObject,'String')) returns contents of post_qpr_filt_param1 as a double


% --- Executes during object creation, after setting all properties.
function post_qpr_filt_param1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to post_qpr_filt_param1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in post_qpr_filt.
function post_qpr_filt_Callback(hObject, eventdata, handles)
% hObject    handle to post_qpr_filt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.params.post_qpr_filt_param1;

[handles] = start_deseccade_Callback(hObject, eventdata, handles);

% Update the 'filter parameter spreadsheet'
filt_params = get(handles.filt_params,'Data');
filt_params(1,10) = {'Post-QPR Spline Param.'};
filt_params(8:13,10) = {handles.params.post_qpr_filt_param1};

set(handles.filt_params,'Data',filt_params);


handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP=voma__smooth([1:length(handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP)]',handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP,handles.params.post_qpr_filt_param1,[1:length(handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP)]');
handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP=voma__smooth([1:length(handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP)]',handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP,handles.params.post_qpr_filt_param1,[1:length(handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP)]');
handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z=voma__smooth([1:length(handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z)]',handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z,handles.params.post_qpr_filt_param1,[1:length(handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z)]');


handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP=voma__smooth([1:length(handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP)]',handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP,handles.params.post_qpr_filt_param1,[1:length(handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP)]');
handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP=voma__smooth([1:length(handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP)]',handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP,handles.params.post_qpr_filt_param1,[1:length(handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP)]');
handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z=voma__smooth([1:length(handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z)]',handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z,handles.params.post_qpr_filt_param1,[1:length(handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z)]');

axes(handles.vor_plot)
cla
plot_smth_data(hObject,eventdata,handles)

guidata(hObject,handles)
