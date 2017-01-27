function varargout = voma__cycle_analysis_gui(varargin)
% VOMA__CYCLE_ANALYSIS_GUI MATLAB code for voma__cycle_analysis_gui.fig
%      VOMA__CYCLE_ANALYSIS_GUI, by itself, creates a new VOMA__CYCLE_ANALYSIS_GUI or raises the existing
%      singleton*.
%
%      H = VOMA__CYCLE_ANALYSIS_GUI returns the handle to a new VOMA__CYCLE_ANALYSIS_GUI or the handle to
%      the existing singleton*.
%
%      VOMA__CYCLE_ANALYSIS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VOMA__CYCLE_ANALYSIS_GUI.M with the given input arguments.
%
%      VOMA__CYCLE_ANALYSIS_GUI('Property','Value',...) creates a new VOMA__CYCLE_ANALYSIS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before voma__cycle_analysis_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to voma__cycle_analysis_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
%       The VOMA version of 'cycle_analysis_gui' was adapted from
%       'vor_analysis_gui_v2b'
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help voma__cycle_analysis_gui

% Last Modified by GUIDE v2.5 22-Jan-2017 17:11:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @voma__cycle_analysis_gui_OpeningFcn, ...
    'gui_OutputFcn',  @voma__cycle_analysis_gui_OutputFcn, ...
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


% --- Executes just before voma__cycle_analysis_gui is made visible.
function voma__cycle_analysis_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to voma__cycle_analysis_gui (see VARARGIN)

% Choose default command line output for voma__cycle_analysis_gui
handles.output = hObject;

% Open the input data file
CurrData = varargin{1};
handles.CurrData = CurrData;

% Save entire data structure for updating
handles.RootData = varargin{2};

handles.curr_file = varargin{3};
handles.pathname = varargin{4};
handles.filename = varargin{5};

handles.params.lefteye_flag = 1;
handles.params.righteye_flag = 1;

handles.params.lock_yaxis = false;

handles.params.stim_plot_mult = 1;
% Set axes
axes(handles.main_plot);
handles.H = axis;

% % Initialize the 'cycle to plot' variable as cycle #1
% handles.params.plot_cycle_val = 1;

% I want to check if the data structure I am loading has QP removal
% parameters already saved. For unprocessed files, the field 'QPparams'
% will not exist. For a 'RootData' file where I have already saved a set of
% parameters for one of the stimulus presentations, all other presentations
% will have an empty field called 'QPparams'. I use the '||' form of the
% logical OR operation in order to short circuit, since if I use the
% 'isempty' command when the field does NOT exist, I will get an error. For
% example, if the field 'QPparams' does not exist the left side of the
% '||' will out put a ~0 = 1, thus causing the statement to enter the 'if'
% block. If the field does exist, but is empty the argument will be ' 1 ||
% 0' and thus still enter the 'if' block. Lastly, if the field does exist,
% but is non-empty, we will enter the 'else' block.
if (~isfield(CurrData,'cyc2plot')) || (isempty(CurrData.cyc2plot))
    
    set(handles.update_file_disp,'BackgroundColor','white')
    set(handles.update_file_disp,'String','Nothing Saved')
    set(handles.update_file_disp,'FontSize',12)
    drawnow
    
    % Initialize the vector containing logical 1s and 0s indicating if a given
    % stimulus presentation will be included in further analysis or not,
    % respectively. We will initialize by including all of the stimulus
    % presentations.
    handles.stim_list = true(1,size(CurrData.VOMA_data.stim_ind,1));
    
    % Initialize the 'cycle to plot' variable as cycle #1
    handles.params.plot_cycle_val = 1;
    
    set(handles.prev_cycle,'Enable','off')
    drawnow
else
    
    % Initialize the vector containing logical 1s and 0s indicating if a given
    % stimulus presentation will be included in further analysis or not,
    % respectively. We will initialize by including all of the stimulus
    % presentations.
    handles.stim_list = false(1,size(CurrData.VOMA_data.stim_ind,1));
    
    handles.stim_list(CurrData.cyc2plot) = true(1);
    
    handles.params.plot_cycle_val = CurrData.cyc2plot(1);
    
    if handles.params.plot_cycle_val == 1
        set(handles.prev_cycle,'Enable','off')
    end
    
    if handles.params.plot_cycle_val == length(CurrData.VOMA_data.stim_ind)
        set(handles.next_cycle,'Enable','off')
    end
    
    set(handles.update_file_disp,'BackgroundColor','yellow')
    set(handles.update_file_disp,'String','Prev. List Loaded')
    set(handles.update_file_disp,'FontSize',10)
    drawnow
    
end

% Initialize the stim_table plot with the included cycles
updatestimlist(hObject, eventdata, handles);

% Initialize the plot with the first cycle
% NOTE: I am not using the 'plot_cycle' callback function below since it
% will mess up the y-axis retrieval code I wrote to keep the y-axis
% consistant. That piece of code uses the 'current figure' axis limits to
% define the new, so it will error for the first plot.

% Retrieve the current cycle number
cycle = handles.params.plot_cycle_val;

% Retrieve the 'stim_ind' variable holding the indices of the starting
% point of each cycle. 
% ** this is a poorly named variable. I need to review and revamp the
% structure of this code **
stim_ind = handles.CurrData.VOMA_data.stim_ind;

switch handles.CurrData.VOMA_data.Parameters.DAQ_code
    
    case {2,3} % These case involve using the CED to record precise eletrical
        % Stimulus pulse arrival times.
        
        switch CurrData.VOMA_data.Parameters.Stim_Info.Stim_Type{1}
            case 'Current Fitting'
                
                % Check if the variable is empty. If it is, set the 'stimulus length' to
                % the starting and ending point of the stimulus trace.
                % If it is not empty, find the minimum difference between stimulus
                % start indicies
                if isempty(stim_ind)
                    handles.len_stim = size(CurrData.VOMA_data.Stim_Trace,2)-1;
                    stim_ind = [1 size(CurrData.VOMA_data.Stim_Trace,2)];
                else
                    % I am finding the minimum length of each
                    % cycle and use that for the length of each cycle I extract
                    handles.len_stim = min(diff(stim_ind(:,1)))-1;
                end
                
                % Find indices from the eye data traces that correspond to the
                % start times for each cycle of electrical stimulation.
                
                
                temp_stim = CurrData.VOMA_data.Stim_Trace(1,:);
                
                temp1 = repmat(CurrData.VOMA_data.Stim_t',1,size(stim_ind,1),size(stim_ind,2));
                temp2 = repmat(temp_stim(stim_ind),1,1,length(CurrData.VOMA_data.Stim_t));
                temp3 = permute(temp2,[3 1 2]);
                
                temp4 = temp1 - temp3;
                
                temp4(temp4<0) = nan;
                
                [temp5,temp6] = min(temp4);
                
                eye_stim_ind = squeeze(temp6);
                
                if size(eye_stim_ind)==[2,1];
                    eye_stim_ind = eye_stim_ind';
                end
                
                eye_stim_ind(:,2) = eye_stim_ind(:,2)-1;
                
                if isempty(min(diff(stim_ind(:,1))))
                    handles.len =  eye_stim_ind(:,2) - eye_stim_ind(:,1);
                else
                    handles.len = min(eye_stim_ind(1:end-1,2) - eye_stim_ind(1:end-1,1));
                end
                
                eye_stim_ind(end,2) = eye_stim_ind(end,1)+handles.len;
                
%                 plot(handles.main_plot,CurrData.VOMA_data.Stim_Trace(1,stim_ind(cycle,1):stim_ind(cycle,1)+handles.len_stim),200*ones(1,length(CurrData.VOMA_data.Stim_Trace(1,stim_ind(cycle,1):stim_ind(cycle,1)+handles.len_stim))),'Marker','*','color','k','LineWidth',0.5)
                hold on
            otherwise
                
                % Check if the variable is empty. If it is, set the 'stimulus length' to
                % the starting and ending point of the stimulus trace.
                % If it is not empty, find the minimum difference between stimulus
                % start indicies
                if isempty(stim_ind)
                    handles.len = length(CurrData.VOMA_data.Eye_t)-1;
                    handles.len_stim = handles.len;
                    
                    
                    stim_ind = [1 handles.len+1];
                else
                    % I am finding the minimum length of each
                    % cycle and use that for the length of each cycle I extract
                    handles.len = min(diff(stim_ind(:,1)));
                    if isempty(handles.len)
                        handles.len = stim_ind(1,2) - stim_ind(1,1);
                    end
                    handles.len_stim = handles.len;
                    
                end
                eye_stim_ind = stim_ind;
                hold on
                
        end
        
    case {1,4,5}
        
        % Check if the variable is empty. If it is, set the 'stimulus length' to
        % the starting and ending point of the stimulus trace.
        % If it is not empty, find the minimum difference between stimulus
        % start indicies
        if isempty(stim_ind)
            handles.len = length(CurrData.VOMA_data.Eye_t)-1;
            handles.len_stim = handles.len;
            
            
            stim_ind = [1 handles.len+1];
        else
            % I am finding the minimum length of each
            % cycle and use that for the length of each cycle I extract
            handles.len = min(diff(stim_ind(:,1)));
            if isempty(handles.len)
                handles.len = stim_ind(1,2) - stim_ind(1,1);
            end
            handles.len_stim = handles.len;
            
        end
        eye_stim_ind = stim_ind;
%         plot(handles.main_plot,handles.CurrData.VOMA_data.Stim_t(stim_ind(cycle,1):stim_ind(cycle,1) + handles.len),handles.CurrData.VOMA_data.Stim_Trace(stim_ind(cycle,1):stim_ind(cycle,1) + handles.len),'k','LineWidth',1)
        hold on
end

handles.CurrData.VOMA_data.eye_stim_ind = eye_stim_ind;
handles.CurrData.VOMA_data.stim_ind = stim_ind;

if isempty(handles.stim_list)
    handles.stim_list = [true];
else
    % Check if the 'stim_list' has this cycle marked to be kept and update the
    % checkbox accordingly.
    if handles.stim_list(cycle) == true(1)
        set(handles.keep_cycle,'Value',1)
    else
        set(handles.keep_cycle,'Value',0)
    end
end

% Ask the user to choose a directory to save files in
handles.params.pathtosave = uigetdir;
cd(handles.params.pathtosave)
set(handles.pathtosave,'String',handles.params.pathtosave);


% Display the filename
set(handles.file_name,'String',CurrData.name);

% Display the stimulus/mapping info for this file
set(handles.stim_type,'String',CurrData.VOMA_data.Parameters.Stim_Info.Stim_Type);
set(handles.mod_canal,'String',CurrData.VOMA_data.Parameters.Stim_Info.ModCanal);
set(handles.freq,'String',CurrData.VOMA_data.Parameters.Stim_Info.Freq);
set(handles.max_vel,'String',CurrData.VOMA_data.Parameters.Stim_Info.Max_Vel);
set(handles.map_type,'String',CurrData.VOMA_data.Parameters.Mapping.Type);
set(handles.baseline,'String',CurrData.VOMA_data.Parameters.Mapping.Baseline);
set(handles.max_pr,'String',CurrData.VOMA_data.Parameters.Mapping.Max_PR);
set(handles.comp_fact,'String',CurrData.VOMA_data.Parameters.Mapping.Compression);


plot_cycle_Callback(hObject, eventdata, handles)


% Initialize plot_saved_cycles_flag and plot_saved_cycleavg_flag to OFF
handles.params.plot_saved_cycles_flag = 0;
handles.params.plot_cycleavg_flag = 0;
handles.params.plot_sinefit_flag = 0;
handles.params.plot_final_trace = 0;

% Initialize the Sine Fit method to SF-DFT
handles.params.sine_fit_method = 1;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes voma__cycle_analysis_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% function plot_cycle_data(hObject, eventdata, handles)
% 
% % Plot the chosen cycle of data
% if handles.params.lefteye_flag == 1
%     plot(handles.main_plot,handles.CurrData.VOMA_data.Eye_t(handles.CurrData.VOMA_data.eye_stim_ind(handles.params.plot_cycle_val,1):handles.CurrData.VOMA_data.eye_stim_ind(handles.params.plot_cycle_val,1) + handles.len),handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z(handles.CurrData.VOMA_data.eye_stim_ind(handles.params.plot_cycle_val,1):handles.CurrData.VOMA_data.eye_stim_ind(handles.params.plot_cycle_val,1) + handles.len),'r','LineWidth',1)
%     hold on
%     plot(handles.main_plot,handles.CurrData.VOMA_data.Eye_t(handles.CurrData.VOMA_data.eye_stim_ind(handles.params.plot_cycle_val,1):handles.CurrData.VOMA_data.eye_stim_ind(handles.params.plot_cycle_val,1) + handles.len),handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP(handles.CurrData.VOMA_data.eye_stim_ind(handles.params.plot_cycle_val,1):handles.CurrData.VOMA_data.eye_stim_ind(handles.params.plot_cycle_val,1) + handles.len),'color' ,[0,128,0]/255,'LineWidth',1)
%     plot(handles.main_plot,handles.CurrData.VOMA_data.Eye_t(handles.CurrData.VOMA_data.eye_stim_ind(handles.params.plot_cycle_val,1):handles.CurrData.VOMA_data.eye_stim_ind(handles.params.plot_cycle_val,1) + handles.len),handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP(handles.CurrData.VOMA_data.eye_stim_ind(handles.params.plot_cycle_val,1):handles.CurrData.VOMA_data.eye_stim_ind(handles.params.plot_cycle_val,1) + handles.len),'b','LineWidth',1)
% end
% 
% if handles.params.righteye_flag == 1
%     plot(handles.main_plot,handles.CurrData.VOMA_data.Eye_t(handles.CurrData.VOMA_data.eye_stim_ind(handles.params.plot_cycle_val,1):handles.CurrData.VOMA_data.eye_stim_ind(handles.params.plot_cycle_val,1) + handles.len),handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z(handles.CurrData.VOMA_data.eye_stim_ind(handles.params.plot_cycle_val,1):handles.CurrData.VOMA_data.eye_stim_ind(handles.params.plot_cycle_val,1) + handles.len),'color' ,[255,0,255]/255,'LineWidth',1)
%     hold on
%     plot(handles.main_plot,handles.CurrData.VOMA_data.Eye_t(handles.CurrData.VOMA_data.eye_stim_ind(handles.params.plot_cycle_val,1):handles.CurrData.VOMA_data.eye_stim_ind(handles.params.plot_cycle_val,1) + handles.len),handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP(handles.CurrData.VOMA_data.eye_stim_ind(handles.params.plot_cycle_val,1):handles.CurrData.VOMA_data.eye_stim_ind(handles.params.plot_cycle_val,1) + handles.len),'g','LineWidth',1)
%     plot(handles.main_plot,handles.CurrData.VOMA_data.Eye_t(handles.CurrData.VOMA_data.eye_stim_ind(handles.params.plot_cycle_val,1):handles.CurrData.VOMA_data.eye_stim_ind(handles.params.plot_cycle_val,1) + handles.len),handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP(handles.CurrData.VOMA_data.eye_stim_ind(handles.params.plot_cycle_val,1):handles.CurrData.VOMA_data.eye_stim_ind(handles.params.plot_cycle_val,1) + handles.len),'color' ,[64,224,208]/255,'LineWidth',1)
% end
% 
%     plot(handles.main_plot,handles.CurrData.VOMA_data.Eye_t(handles.CurrData.VOMA_data.eye_stim_ind(handles.params.plot_cycle_val,1):handles.CurrData.VOMA_data.eye_stim_ind(handles.params.plot_cycle_val,1) + handles.len),zeros(1,handles.len+1),'k--','LineWidth',0.5)
% 
% 
% switch handles.CurrData.VOMA_data.Parameters.DAQ_code
%     case {1,4,5}
%         plot(handles.main_plot,handles.CurrData.VOMA_data.Stim_t(handles.CurrData.VOMA_data.stim_ind(handles.params.plot_cycle_val,1):handles.CurrData.VOMA_data.stim_ind(handles.params.plot_cycle_val,1) + handles.len),handles.params.stim_plot_mult*handles.CurrData.VOMA_data.Stim_Trace(handles.CurrData.VOMA_data.stim_ind(handles.params.plot_cycle_val,1):handles.CurrData.VOMA_data.stim_ind(handles.params.plot_cycle_val,1) + handles.len),'k','LineWidth',1)
%     case {2,3}
%         plot(handles.main_plot,handles.CurrData.VOMA_data.Stim_Trace(1,handles.CurrData.VOMA_data.stim_ind(handles.params.plot_cycle_val,1):handles.CurrData.VOMA_data.stim_ind(handles.params.plot_cycle_val,1)+handles.len_stim),200*ones(1,length(CurrData.VOMA_data.Stim_Trace(1,handles.CurrData.VOMA_data.stim_ind(handles.params.plot_cycle_val,1):handles.CurrData.VOMA_data.stim_ind(handles.params.plot_cycle_val,1)+handles.len_stim))),'Marker','*','color','k','LineWidth',0.5)
%         
% end
% 
% xlabel(handles.main_plot,'Time [s]')
% ylabel(handles.main_plot,'Eye Velocity [dps]')
% hold off


function updatestimlist(hObject, eventdata, handles)

% This is the logical array with 1s representing cycles to include, and 0s
% representing cycles to ignore
stim_list = handles.stim_list;

if isrow(stim_list)
    stim_list = stim_list';
end

% Create an array of 'all' cycles. We will then use the logical array
% 'stim_list' to extract the relevant cycles
stim_nums = [1:size(stim_list,1)]';

% Store this array in the table
set(handles.stim_table,'Data',stim_nums(stim_list));

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = voma__cycle_analysis_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in prev_cycle.
function prev_cycle_Callback(hObject, eventdata, handles)
% hObject    handle to prev_cycle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% When the 'prev_cycle' button is pressed, decrement the 'plot_cycle_val'
% variable
handles.params.plot_cycle_val = handles.params.plot_cycle_val - 1;
% Update the display in the gui
set(handles.plot_cycle_val,'String',handles.params.plot_cycle_val);

% Plot the new cycle
plot_cycle_Callback(hObject, eventdata, handles)

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in next_cycle.
function next_cycle_Callback(hObject, eventdata, handles)
% hObject    handle to next_cycle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% When the 'next_cycle' button is pressed, decrement the 'plot_cycle_val'
% variable
handles.params.plot_cycle_val = handles.params.plot_cycle_val + 1;
% Update the display in the gui
set(handles.plot_cycle_val,'String',handles.params.plot_cycle_val);

% Plot the new cycle
plot_cycle_Callback(hObject, eventdata, handles)

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in keep_cycle.
function keep_cycle_Callback(hObject, eventdata, handles)
% hObject    handle to keep_cycle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Retrieve the current cycle number
cycle = handles.params.plot_cycle_val;

% Check if the user has toggled to 'keep cycle' or not
if (get(hObject,'Value') == get(hObject,'Max'))
    % The user just chose to 'keep cycle', so make sure the value in the
    % 'stim_list' logical array value for this cycle is a logical 'true'
    handles.stim_list(cycle) = true(1);
    
else
    % The user just chose to not 'keep cycle', so make sure the value in the
    % 'stim_list' logical array value for this cycle is a logical 'false'
    handles.stim_list(cycle) = false(1);
end

% Since we changed the list of stimuli to keep, run the 'updatestimlist'
% function
updatestimlist(hObject, eventdata, handles)

handles = guidata(hObject);

% Update handles structure
guidata(hObject, handles);


% Hint: get(hObject,'Value') returns toggle state of keep_cycle


% --- Executes on button press in plot_final_data.
function plot_final_data_Callback(hObject, eventdata, handles)
% hObject    handle to plot_final_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% If the user calls to 'Plot the final data trace', we want to diable
% other plot options (i.e. 'Plot saved cycles' which plots each saved
% cycles overlapped, or 'Plot cycle average') which plots the cycle average
% of the saved cycles. Before we plot this trace, we need to clear the
% corresponding flags and buttons. NOTE: we will leave the 'plot_sine_fit'
% flag alone, since we may want to plot the sine fit on top of the data.
% Reset flags
handles.params.plot_saved_cycles_flag = 0;
handles.params.plot_cycleavg_flag = 0;
% Reset buttons
set(handles.plot_saved_cycles,'Value',0);
set(handles.cycle_average,'Value',0);

% Set 'plot_final_trace' flag
handles.params.plot_final_trace = 1;

% Plot the data
plot_data(hObject, eventdata, handles)

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in plot_cycle.
function plot_cycle_Callback(hObject, eventdata, handles)
% hObject    handle to plot_cycle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% Retrieve the current cycle number
cycle = handles.params.plot_cycle_val;

% Check if the 'stim_list' has this cycle marked to be kept and update the
% checkbox accordingly.
if handles.stim_list(cycle) == true(1)
    set(handles.keep_cycle,'Value',1)
else
    set(handles.keep_cycle,'Value',0)
end

% Retrieve and save the present axis values. This is done so a user can
% zoom into the plot however they want, and the y-axs scale will be the
% same.
axes(handles.main_plot);

if handles.params.lock_yaxis
H = axis;
else
    
end

axes(handles.main_plot); % Make main_plot the current axes.
cla reset; % Do a complete and total reset of the axes.

% Retrieve the 'stim_ind' variable holding the cycle indices
stim_ind = handles.CurrData.VOMA_data.stim_ind;
eye_stim_ind = handles.CurrData.VOMA_data.eye_stim_ind;

% Plot the chosen cycle of data
if handles.params.lefteye_flag == 1
    
    % Plot Smooth Cycle Data
    plot(handles.main_plot,handles.CurrData.VOMA_data.Eye_t(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),'r','LineWidth',1)
    hold on
    plot(handles.main_plot,handles.CurrData.VOMA_data.Eye_t(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),'color' ,[0,128,0]/255,'LineWidth',1)
    plot(handles.main_plot,handles.CurrData.VOMA_data.Eye_t(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),'b','LineWidth',1)
    plot(handles.main_plot,handles.CurrData.VOMA_data.Eye_t(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),zeros(1,handles.len+1),'k--','LineWidth',0.5)
    
    try
        patchline(handles.CurrData.VOMA_data.Eye_t(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),handles.CurrData.VOMA_data.Data_LE_Vel_LARP(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),'edgecolor',[0,128,0]/255,'LineWidth',0.05,'edgealpha',0.5);
        patchline(handles.CurrData.VOMA_data.Eye_t(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),handles.CurrData.VOMA_data.Data_LE_Vel_RALP(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),'edgecolor','b','LineWidth',0.05,'edgealpha',0.5);
        patchline(handles.CurrData.VOMA_data.Eye_t(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),handles.CurrData.VOMA_data.Data_LE_Vel_Z(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),'edgecolor','r','LineWidth',0.05,'edgealpha',0.5);
        
       
        
        
    catch
        plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),handles.CurrData.VOMA_data.Data_LE_Vel_LARP(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),'Color',[0,128,0]/255,'LineWidth',1)
        plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),handles.CurrData.VOMA_data.Data_LE_Vel_RALP(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),'b','LineWidth',1)
        plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),handles.CurrData.VOMA_data.Data_LE_Vel_Z(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),'r','LineWidth',1)
        
        
    end
end

if handles.params.righteye_flag == 1
    plot(handles.main_plot,handles.CurrData.VOMA_data.Eye_t(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),'color' ,[255,0,255]/255,'LineWidth',1)
    hold on
    plot(handles.main_plot,handles.CurrData.VOMA_data.Eye_t(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),'g','LineWidth',1)
    plot(handles.main_plot,handles.CurrData.VOMA_data.Eye_t(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),'color' ,[64,224,208]/255,'LineWidth',1)
    plot(handles.main_plot,handles.CurrData.VOMA_data.Eye_t(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),zeros(1,handles.len+1),'k--','LineWidth',0.5)
    
    try
        
        patchline(handles.CurrData.VOMA_data.Eye_t(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),handles.CurrData.VOMA_data.Data_RE_Vel_LARP(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),'edgecolor','g','LineWidth',0.05,'edgealpha',0.5);
        patchline(handles.CurrData.VOMA_data.Eye_t(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),handles.CurrData.VOMA_data.Data_RE_Vel_RALP(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),'edgecolor',[64,224,208]/255,'LineWidth',0.05,'edgealpha',0.5);
        patchline(handles.CurrData.VOMA_data.Eye_t(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),handles.CurrData.VOMA_data.Data_RE_Vel_Z(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),'edgecolor', [255,0,255]/255,'LineWidth',0.05,'edgealpha',0.5);
        
    catch
        
        plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),handles.CurrData.VOMA_data.Data_RE_Vel_LARP(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),'g','LineWidth',1)
        plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),handles.CurrData.VOMA_data.Data_RE_Vel_RALP(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),'Color',[64,224,208]/255,'LineWidth',1)
        plot(handles.vor_plot,handles.CurrData.VOMA_data.Eye_t(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),handles.CurrData.VOMA_data.Data_RE_Vel_Z(eye_stim_ind(cycle,1):eye_stim_ind(cycle,1) + handles.len),'Color',[255,0,255]/255,'LineWidth',1)
    end
    
end

switch handles.CurrData.VOMA_data.Parameters.DAQ_code
    case {1,4,5}
        
        plot(handles.main_plot,handles.CurrData.VOMA_data.Stim_t(handles.CurrData.VOMA_data.stim_ind(handles.params.plot_cycle_val,1):handles.CurrData.VOMA_data.stim_ind(handles.params.plot_cycle_val,1) + handles.len),handles.params.stim_plot_mult*handles.CurrData.VOMA_data.Stim_Trace(handles.CurrData.VOMA_data.stim_ind(handles.params.plot_cycle_val,1):handles.CurrData.VOMA_data.stim_ind(handles.params.plot_cycle_val,1) + handles.len),'k','LineWidth',1)
        
        %         plot(handles.main_plot,handles.CurrData.VOMA_data.Eye_t(stim_ind(cycle,1):stim_ind(cycle,1) + handles.len_stim),handles.CurrData.VOMA_data.Stim_Trace(stim_ind(cycle,1):stim_ind(cycle,1) + handles.len_stim),'k','LineWidth',1)
        
    case {2,3}
        switch CurrData.VOMA_data.Parameters.Stim_Info.Stim_Type{1}
            case 'Current Fitting'
                %                 plot(handles.main_plot,handles.CurrData.VOMA_data.Stim_Trace(1,stim_ind(cycle,1):stim_ind(cycle,1)+handles.len_stim),200*ones(1,length(handles.CurrData.VOMA_data.Stim_Trace(1,stim_ind(cycle,1):stim_ind(cycle,1)+handles.len_stim))),'Marker','*','color','k','LineWidth',0.5)
                plot(handles.main_plot,handles.CurrData.VOMA_data.Stim_Trace(1,handles.CurrData.VOMA_data.stim_ind(handles.params.plot_cycle_val,1):handles.CurrData.VOMA_data.stim_ind(handles.params.plot_cycle_val,1)+handles.len_stim),200*ones(1,length(CurrData.VOMA_data.Stim_Trace(1,handles.CurrData.VOMA_data.stim_ind(handles.params.plot_cycle_val,1):handles.CurrData.VOMA_data.stim_ind(handles.params.plot_cycle_val,1)+handles.len_stim))),'Marker','*','color','k','LineWidth',0.5)
                
            otherwise
                
                
                plot(handles.main_plot,handles.CurrData.VOMA_data.Stim_t(handles.CurrData.VOMA_data.stim_ind(handles.params.plot_cycle_val,1):handles.CurrData.VOMA_data.stim_ind(handles.params.plot_cycle_val,1) + handles.len),handles.params.stim_plot_mult*handles.CurrData.VOMA_data.Stim_Trace(handles.CurrData.VOMA_data.stim_ind(handles.params.plot_cycle_val,1):handles.CurrData.VOMA_data.stim_ind(handles.params.plot_cycle_val,1) + handles.len),'k','LineWidth',1)
        end
end

xlabel(handles.main_plot,'Time [s]')
ylabel(handles.main_plot,'Eye Velocity [dps]')
hold off


% Now we want to keep the same y-axis scale as the previous plot, but
% adjust the x-axis.
% Make the plot the current figure
axes(handles.main_plot);

if handles.params.lock_yaxis
    
else
    H = axis;
end

% Temporary variable to hold the autoscaled values
H_temp = axis;
% Set the x-axis limits to whatever Matlab chose, and the y-axis limits to
% what the were for the previous plot (saved in handles.H)
axis([H_temp(1) H_temp(2) H(3) H(4)])



% If we are plotting the first cycle, disable the 'previous cycle' button
if cycle==1
    set(handles.prev_cycle,'Enable','off')
    
else
    set(handles.prev_cycle,'Enable','on')
end

% If we are plotting the last cycle, disable the 'next cycle' button
if cycle==length(stim_ind)
    set(handles.next_cycle,'Enable','off')
    
else
    set(handles.next_cycle,'Enable','on')
end

% Update handles structure
guidata(hObject, handles);

function plot_cycle_val_Callback(hObject, eventdata, handles)
% hObject    handle to plot_cycle_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.params.plot_cycle_val = str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of plot_cycle_val as text
%        str2double(get(hObject,'String')) returns contents of plot_cycle_val as a double


% --- Executes during object creation, after setting all properties.
function plot_cycle_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plot_cycle_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cycle_average.
function cycle_average_Callback(hObject, eventdata, handles)
% hObject    handle to cycle_average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    
    % Turn off the 'plot_final_trace' flag
    handles.params.plot_final_trace = 0;
    
    % Extract the cycle indices
    stim_ind = handles.CurrData.VOMA_data.stim_ind;
    eye_stim_ind = handles.CurrData.VOMA_data.eye_stim_ind;

    % Extract the current list of stimuli the user wants to analyze
    cyc2plot = get(handles.stim_table,'Data');
    
    % We will be taking a cycle average, so we want to make sure each 'cycle'
    % we grab is the same length. I found the minimum cycle length when I
    % loaded the file, so I grab it here.
    len = handles.len;
    
    % Initialize variables for each plane's cycles
    ll_cyc = [];
    lr_cyc = [];
    lz_cyc = [];
    
    rl_cyc = [];
    rr_cyc = [];
    rz_cyc = [];
    
    stim = [];
    
    % Extract data
    for k=[cyc2plot']
        ll_cyc = [ll_cyc ; handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP(eye_stim_ind(k,1):eye_stim_ind(k,1) + len)'];
        lr_cyc = [lr_cyc ; handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP(eye_stim_ind(k,1):eye_stim_ind(k,1) + len)'];
        lz_cyc = [lz_cyc ; handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z(eye_stim_ind(k,1):eye_stim_ind(k,1) + len)'];
        
        rl_cyc = [rl_cyc ; handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP(eye_stim_ind(k,1):eye_stim_ind(k,1) + len)'];
        rr_cyc = [rr_cyc ; handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP(eye_stim_ind(k,1):eye_stim_ind(k,1) + len)'];
        rz_cyc = [rz_cyc ; handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z(eye_stim_ind(k,1):eye_stim_ind(k,1) + len)'];
        
        stim = [stim ; handles.CurrData.VOMA_data.Stim_Trace(stim_ind(k,1):stim_ind(k,1) + len)'];
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
    
    handles.params.plot_cycleavg_flag = 1;
    
    
    
    
elseif button_state == get(hObject,'Min')
    
    
    handles.params.plot_cycleavg_flag = 0;
    
end

% Update plot
plot_data(hObject, eventdata, handles)

% Update handles structure
guidata(hObject, handles);

function file_name_Callback(hObject, eventdata, handles)
% hObject    handle to file_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file_name as text
%        str2double(get(hObject,'String')) returns contents of file_name as a double


% --- Executes during object creation, after setting all properties.
function file_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in savedata.
function savedata_Callback(hObject, eventdata, handles)
% hObject    handle to savedata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.save_status,'BackgroundColor','red')
drawnow

if ~isfield(handles,'Results')
    
    h = msgbox('You haven''t created a Cycle Average yet! Click ''Plot Cycle Average'' Then Try again.','Woops! Missing Output Variable');
    set(handles.save_status,'BackgroundColor','green')
    drawnow
    return
end

cd(handles.params.pathtosave);

Results = handles.Results;
Results.name = handles.CurrData.name;
Results.Mapping = handles.CurrData.VOMA_data.Parameters.Mapping;
Results.Stimulus = handles.CurrData.VOMA_data.Parameters.Stim_Info;
Results.Fs = handles.CurrData.VOMA_data.Fs;
Results.QPparams = handles.CurrData.QPparams;



if ~isempty(strfind(handles.CurrData.name,'.mat'))
    save([handles.CurrData.name(1:end-4) '_CycleAvg'],'Results')
else
    save([handles.CurrData.name '_CycleAvg'],'Results')
end

set(handles.save_status,'BackgroundColor','green')
drawnow


% --- Executes on button press in plot_saved_cycles.
function plot_saved_cycles_Callback(hObject, eventdata, handles)
% hObject    handle to plot_saved_cycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    handles.params.plot_saved_cycles_flag = 1;
    handles.params.plot_final_trace = 0;
    
elseif button_state == get(hObject,'Min')
    handles.params.plot_saved_cycles_flag = 0;
end

% Update plot
plot_data(hObject, eventdata, handles)


% Update handles structure
guidata(hObject, handles);

% Hint: get(hObject,'Value') returns toggle state of plot_saved_cycles


function plot_data(hObject, eventdata, handles)

% Retrieve and save the present axis values. This is done so a user can
% zoom into the plot however they want, and the y-axs scale will be the
% same.
axes(handles.main_plot);
handles.H = axis;

axes(handles.main_plot); % Make main_plot the current axes.
cla reset; % Do a complete and total reset of the axes.

% If the plot_saved_cycles flag is high, plot all of the cycles that are
% marked as 'saved'
if handles.params.plot_saved_cycles_flag == 1
    
    % Extract the cycle indices
    stim_ind = handles.CurrData.VOMA_data.stim_ind;
    eye_stim_ind = handles.CurrData.VOMA_data.eye_stim_ind;

    % Extract the current list of stimuli the user wants to analyze
    cyc2plot = get(handles.stim_table,'Data');
    
    % We will be taking a cycle average, so we want to make sure each 'cycle'
    % we grab is the same length. I found the minimum cycle length when I
    % loaded the file, so I grab it here.
    len = handles.len;
    
    
    % Extract data
    for k=[cyc2plot']
        
        hold on
        
        if handles.params.lefteye_flag == 1
            plot(handles.main_plot,[1:len+1]/handles.CurrData.VOMA_data.Fs,handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP(eye_stim_ind(k,1):eye_stim_ind(k,1) + len),'color' ,[0,128,0]/255,'LineWidth',1)
            plot(handles.main_plot,[1:len+1]/handles.CurrData.VOMA_data.Fs,handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP(eye_stim_ind(k,1):eye_stim_ind(k,1) + len),'b','LineWidth',1)
            plot(handles.main_plot,[1:len+1]/handles.CurrData.VOMA_data.Fs,handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z(eye_stim_ind(k,1):eye_stim_ind(k,1) + len),'r','LineWidth',1)
        end
        
        if handles.params.righteye_flag == 1
            plot(handles.main_plot,[1:len+1]/handles.CurrData.VOMA_data.Fs,handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP(eye_stim_ind(k,1):eye_stim_ind(k,1) + len),'g','LineWidth',1)
            plot(handles.main_plot,[1:len+1]/handles.CurrData.VOMA_data.Fs,handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP(eye_stim_ind(k,1):eye_stim_ind(k,1) + len),'color' ,[64,224,208]/255,'LineWidth',1)
            plot(handles.main_plot,[1:len+1]/handles.CurrData.VOMA_data.Fs,handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z(eye_stim_ind(k,1):eye_stim_ind(k,1) + len),'color' ,[255,0,255]/255,'LineWidth',1)
        end
        
    end
    
    xlabel(handles.main_plot,'Time [s]')
    ylabel(handles.main_plot,'Eye Velocity [dps]')
    
    drawnow
end

% If the cycleavg flag is high, plot that
if handles.params.plot_cycleavg_flag == 1
    
    % Extract the cycle indices
    stim_ind = handles.CurrData.VOMA_data.stim_ind;
    eye_stim_ind = handles.CurrData.VOMA_data.eye_stim_ind;

    % Extract the current list of stimuli the user wants to analyze
    cyc2plot = get(handles.stim_table,'Data');
    
    % We will be taking a cycle average, so we want to make sure each 'cycle'
    % we grab is the same length. I found the minimum cycle length when I
    % loaded the file, so I grab it here.
    len = handles.len;
    
    SDplot = 1;
    
    % Plot the cycle average
    if handles.params.lefteye_flag == 1
        plot(handles.main_plot,[1:len+1]/handles.CurrData.VOMA_data.Fs,handles.Results.ll_cycavg,'Color',[0,128,0]/255,'LineWidth',2)
        hold on
        plot(handles.main_plot,[1:len+1]/handles.CurrData.VOMA_data.Fs,handles.Results.lr_cycavg,'b','LineWidth',2)
        plot(handles.main_plot,[1:len+1]/handles.CurrData.VOMA_data.Fs,handles.Results.lz_cycavg,'r','LineWidth',2)
        
        % Plot the mean + 2*standard deviations
        plot(handles.main_plot,[1:len+1]/handles.CurrData.VOMA_data.Fs,handles.Results.ll_cycavg + SDplot*handles.Results.ll_cycstd,'LineStyle','--','Color',[0,128,0]/255,'LineWidth',0.5)
        plot(handles.main_plot,[1:len+1]/handles.CurrData.VOMA_data.Fs,handles.Results.lr_cycavg + SDplot*handles.Results.lr_cycstd,'b--','LineWidth',0.5)
        plot(handles.main_plot,[1:len+1]/handles.CurrData.VOMA_data.Fs,handles.Results.lz_cycavg + SDplot*handles.Results.lz_cycstd,'r--','LineWidth',0.5)
        
        % Plot the mean - 2*standard deviations
        plot(handles.main_plot,[1:len+1]/handles.CurrData.VOMA_data.Fs,handles.Results.ll_cycavg - SDplot*handles.Results.ll_cycstd,'LineStyle','--','Color',[0,128,0]/255,'LineWidth',0.5)
        plot(handles.main_plot,[1:len+1]/handles.CurrData.VOMA_data.Fs,handles.Results.lr_cycavg - SDplot*handles.Results.lr_cycstd,'b--','LineWidth',0.5)
        plot(handles.main_plot,[1:len+1]/handles.CurrData.VOMA_data.Fs,handles.Results.lz_cycavg - SDplot*handles.Results.lz_cycstd,'r--','LineWidth',0.5)
    end
    
    if handles.params.righteye_flag == 1
        plot(handles.main_plot,[1:len+1]/handles.CurrData.VOMA_data.Fs,handles.Results.rl_cycavg,'g','LineWidth',2)
        hold on
        plot(handles.main_plot,[1:len+1]/handles.CurrData.VOMA_data.Fs,handles.Results.rr_cycavg,'Color',[64,224,208]/255,'LineWidth',2)
        plot(handles.main_plot,[1:len+1]/handles.CurrData.VOMA_data.Fs,handles.Results.rz_cycavg,'Color',[255,0,255]/255,'LineWidth',2)
        
        % Plot the mean + 2*standard deviations
        plot(handles.main_plot,[1:len+1]/handles.CurrData.VOMA_data.Fs,handles.Results.rl_cycavg + SDplot*handles.Results.rl_cycstd,'g--','LineWidth',0.5)
        plot(handles.main_plot,[1:len+1]/handles.CurrData.VOMA_data.Fs,handles.Results.rr_cycavg + SDplot*handles.Results.rr_cycstd,'LineStyle','--','Color',[64,224,208]/255,'LineWidth',0.5)
        plot(handles.main_plot,[1:len+1]/handles.CurrData.VOMA_data.Fs,handles.Results.rz_cycavg + SDplot*handles.Results.rz_cycstd,'LineStyle','--','Color',[255,0,255]/255,'LineWidth',0.5)
        
        % Plot the mean - 2*standard deviations
        plot(handles.main_plot,[1:len+1]/handles.CurrData.VOMA_data.Fs,handles.Results.rl_cycavg - SDplot*handles.Results.rl_cycstd,'g--','LineWidth',0.5)
        plot(handles.main_plot,[1:len+1]/handles.CurrData.VOMA_data.Fs,handles.Results.rr_cycavg - SDplot*handles.Results.rr_cycstd,'LineStyle','--','Color',[64,224,208]/255,'LineWidth',0.5)
        plot(handles.main_plot,[1:len+1]/handles.CurrData.VOMA_data.Fs,handles.Results.rz_cycavg - SDplot*handles.Results.rz_cycstd,'LineStyle','--','Color',[255,0,255]/255,'LineWidth',0.5)
    end
    
    switch handles.CurrData.VOMA_data.Parameters.DAQ_code
        case {1,4,5}
            plot(handles.main_plot,[1:len+1]/handles.CurrData.VOMA_data.Fs,handles.params.stim_plot_mult*handles.CurrData.VOMA_data.Stim_Trace(stim_ind(1,1):stim_ind(1,1) + handles.len),'k','LineWidth',1)
            
        case {2,3}
            switch CurrData.VOMA_data.Parameters.Stim_Info.Stim_Type{1}
                case 'Current Fitting'
                    %             plot(handles.main_plot,handles.CurrData.VOMA_data.Stim_Trace(1,stim_ind(cycle,1):stim_ind(cycle,1)+handles.len_stim),200*ones(1,length(handles.CurrData.VOMA_data.Stim_Trace(1,stim_ind(cycle,1):stim_ind(cycle,1)+handles.len_stim))),'Marker','*','color','k','LineWidth',0.5)
                    
                otherwise
                    
                    plot(handles.main_plot,[1:len+1]/handles.CurrData.VOMA_data.Fs,handles.CurrData.VOMA_data.Stim_Trace(stim_ind(1,1):stim_ind(1,1) + handles.len),'k','LineWidth',1)
            end
    end
    
    
    xlabel(handles.main_plot,'Time [s]')
    ylabel(handles.main_plot,'Eye Velocity [dps]')
    
    drawnow
end

if handles.params.plot_final_trace == 1
    
    axes(handles.main_plot); % Make main_plot the current axes.
    cla reset; % Do a complete and total reset of the axes.
    
    % Extract the cycle indices
    stim_ind = handles.CurrData.VOMA_data.stim_ind;
    eye_stim_ind = handles.CurrData.VOMA_data.eye_stim_ind;

    % Extract the current list of stimuli the user wants to analyze
    cyc2plot = get(handles.stim_table,'Data');
    
    % We will be taking a cycle average, so we want to make sure each 'cycle'
    % we grab is the same length. I found the minimum cycle length when I
    % loaded the file, so I grab it here.
    len = handles.len;
    
    % Initialize variables for each plane's cycles
    ll_cyc = [];
    lr_cyc = [];
    lz_cyc = [];
    
    rl_cyc = [];
    rr_cyc = [];
    rz_cyc = [];
    
    stim = [ ];
    t_cyc = [];
    
    % Extract data
    for k=[cyc2plot']
        ll_cyc = [ll_cyc ; handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP(eye_stim_ind(k,1):eye_stim_ind(k,1) + len)];
        lr_cyc = [lr_cyc ; handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP(eye_stim_ind(k,1):eye_stim_ind(k,1) + len)];
        lz_cyc = [lz_cyc ; handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z(eye_stim_ind(k,1):eye_stim_ind(k,1) + len)];
        
        rl_cyc = [rl_cyc ; handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP(eye_stim_ind(k,1):eye_stim_ind(k,1) + len)];
        rr_cyc = [rr_cyc ; handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP(eye_stim_ind(k,1):eye_stim_ind(k,1) + len)];
        rz_cyc = [rz_cyc ; handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z(eye_stim_ind(k,1):eye_stim_ind(k,1) + len)];
        
        stim = [stim ; handles.CurrData.VOMA_data.Stim_Trace(stim_ind(k,1):stim_ind(k,1) + len)];

        
        t_cyc = [t_cyc  handles.CurrData.VOMA_data.Eye_t(eye_stim_ind(k,1):eye_stim_ind(k,1) + len)];
    end
    
    % Plot the cycle average
    if handles.params.lefteye_flag == 1
    plot(handles.main_plot,[1:length(ll_cyc)]/handles.CurrData.VOMA_data.Fs,ll_cyc,'color' ,[0,128,0]/255,'LineWidth',1)
    hold on
    plot(handles.main_plot,[1:length(ll_cyc)]/handles.CurrData.VOMA_data.Fs,lr_cyc,'b','LineWidth',1)
    plot(handles.main_plot,[1:length(ll_cyc)]/handles.CurrData.VOMA_data.Fs,lz_cyc,'r','LineWidth',1)
    end
    
    if handles.params.righteye_flag == 1
    plot(handles.main_plot,[1:length(ll_cyc)]/handles.CurrData.VOMA_data.Fs,rl_cyc,'g','LineWidth',1)
    hold on
    plot(handles.main_plot,[1:length(ll_cyc)]/handles.CurrData.VOMA_data.Fs,rr_cyc,'color' ,[64,224,208]/255,'LineWidth',1)
    plot(handles.main_plot,[1:length(ll_cyc)]/handles.CurrData.VOMA_data.Fs,rz_cyc,'color' ,[255,0,255]/255,'LineWidth',1)
    end
    
    plot(handles.main_plot,[1:length(stim)]/handles.CurrData.VOMA_data.Fs,handles.params.stim_plot_mult*stim,'color' ,'k','LineWidth',1)

    
    drawnow
    
end


% If the sinefit flag is high, plot that as well
% NOTE: The sine fit option should be LAST in this order since the sine
% wave that is generated is dpeends on the width of the plot display
if handles.params.plot_sinefit_flag == 1
    
    
    t = handles.H(1):1/handles.CurrData.VOMA_data.Fs:handles.H(2);
    
    F = handles.Results.SineFit.Freq;
    
    % Left eye sine fit
    ll_offset = handles.Results.SineFit.ll_offset;
    llsinphase = handles.Results.SineFit.ll_sinphase;
    ll_mag = handles.Results.SineFit.ll_mag;
    
    lr_offset = handles.Results.SineFit.lr_offset;
    lrsinphase = handles.Results.SineFit.lr_sinphase;
    lr_mag = handles.Results.SineFit.lr_mag;
    
    lz_offset = handles.Results.SineFit.lz_offset;
    lzsinphase = handles.Results.SineFit.lz_sinphase;
    lz_mag = handles.Results.SineFit.lz_mag;
    
    ll_sine = ll_offset + ll_mag*sin(2*pi*F*t + llsinphase);
    lr_sine = lr_offset + lr_mag*sin(2*pi*F*t + lrsinphase);
    lz_sine = lz_offset + lz_mag*sin(2*pi*F*t + lzsinphase);
    
    % right eye
    rl_offset = handles.Results.SineFit.rl_offset;
    rlsinphase = handles.Results.SineFit.rl_sinphase;
    rl_mag = handles.Results.SineFit.rl_mag;
    
    rr_offset = handles.Results.SineFit.rr_offset;
    rrsinphase = handles.Results.SineFit.rr_sinphase;
    rr_mag = handles.Results.SineFit.rr_mag;
    
    rz_offset = handles.Results.SineFit.rz_offset;
    rzsinphase = handles.Results.SineFit.rz_sinphase;
    rz_mag = handles.Results.SineFit.rz_mag;
    
    rl_sine = rl_offset + rl_mag*sin(2*pi*F*t + rlsinphase);
    rr_sine = rr_offset + rr_mag*sin(2*pi*F*t + rrsinphase);
    rz_sine = rz_offset + rz_mag*sin(2*pi*F*t + rzsinphase);
    
    if handles.params.lefteye_flag == 1
        plot(handles.main_plot,t,ll_sine,'LineStyle',':','color' ,[0,128,0]/255,'LineWidth',2)
        hold on
        plot(handles.main_plot,t,lr_sine,'LineStyle',':','color' ,'b','LineWidth',2)
        plot(handles.main_plot,t,lz_sine,'LineStyle',':','color' ,'r','LineWidth',2)
    end
    
    if handles.params.righteye_flag == 1
        plot(handles.main_plot,t,rl_sine,'LineStyle',':','color' ,'g','LineWidth',2)
        hold on
        plot(handles.main_plot,t,rr_sine,'LineStyle',':','color' ,[64,224,208]/255,'LineWidth',2)
        plot(handles.main_plot,t,rz_sine,'LineStyle',':','color' ,[255,0,255]/255,'LineWidth',2)
    end
    
    
    drawnow
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in sine_fit.
function sine_fit_Callback(hObject, eventdata, handles)
% hObject    handle to sine_fit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    
    % Extract the cycle indices
    stim_ind = handles.CurrData.VOMA_data.stim_ind;
    eye_stim_ind = handles.CurrData.VOMA_data.eye_stim_ind;
    
    % Extract the current list of stimuli the user wants to analyze
    cyc2plot = get(handles.stim_table,'Data');
    
    % We will be taking a cycle average, so we want to make sure each 'cycle'
    % we grab is the same length. I found the minimum cycle length when I
    % loaded the file, so I grab it here.
    len = handles.len;
    
    % Initialize variables for each plane's cycles
    ll_cyc = [];
    lr_cyc = [];
    lz_cyc = [];
    
    rl_cyc = [];
    rr_cyc = [];
    rz_cyc = [];
    
    
    % Extract data
    for k=[cyc2plot']
        ll_cyc = [ll_cyc ; handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP(eye_stim_ind(k,1):eye_stim_ind(k,1) + len)];
        lr_cyc = [lr_cyc ; handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP(eye_stim_ind(k,1):eye_stim_ind(k,1) + len)];
        lz_cyc = [lz_cyc ; handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z(eye_stim_ind(k,1):eye_stim_ind(k,1) + len)];
        
        rl_cyc = [rl_cyc ; handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP(eye_stim_ind(k,1):eye_stim_ind(k,1) + len)];
        rr_cyc = [rr_cyc ; handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP(eye_stim_ind(k,1):eye_stim_ind(k,1) + len)];
        rz_cyc = [rz_cyc ; handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z(eye_stim_ind(k,1):eye_stim_ind(k,1) + len)];
    end
    
    % Make a time vector
    tt = [1:length(ll_cyc)]/handles.CurrData.VOMA_data.Fs;
    % Stimulus FRequency
    freq = handles.CurrData.VOMA_data.Parameters.Stim_Info.Freq{1};
    
    switch handles.params.sine_fit_method
        
        case 1 % Single Frequency DFT
            
            handles.Results.SineFit = [];
            
            [ll_offset,ll_mag,ll_sinphase,ll_cosphase,ll_THD] = SingleFreqDFT(tt,ll_cyc,freq);
            [lr_offset,lr_mag,lr_sinphase,lr_cosphase,lr_THD] = SingleFreqDFT(tt,lr_cyc,freq);
            [lz_offset,lz_mag,lz_sinphase,lz_cosphase,lz_THD] = SingleFreqDFT(tt,lz_cyc,freq);
            
            [rl_offset,rl_mag,rl_sinphase,rl_cosphase,rl_THD] = SingleFreqDFT(tt,rl_cyc,freq);
            [rr_offset,rr_mag,rr_sinphase,rr_cosphase,rr_THD] = SingleFreqDFT(tt,rr_cyc,freq);
            [rz_offset,rz_mag,rz_sinphase,rz_cosphase,rz_THD] = SingleFreqDFT(tt,rz_cyc,freq);
            
            % Display results
            set(handles.l_larp_sin_offset,'String',num2str(ll_offset));
            set(handles.l_larp_sin_amp,'String',num2str(ll_mag));
            set(handles.l_larp_sin_phase,'String',num2str(ll_sinphase*(180/pi)));
            set(handles.l_larp_sin_THD,'String',num2str(ll_THD));
            
            set(handles.r_larp_sin_offset,'String',num2str(rl_offset));
            set(handles.r_larp_sin_amp,'String',num2str(rl_mag));
            set(handles.r_larp_sin_phase,'String',num2str(rl_sinphase*(180/pi)));
            set(handles.r_larp_sin_THD,'String',num2str(rl_THD));
            
            
            set(handles.l_ralp_sin_offset,'String',num2str(lr_offset));
            set(handles.l_ralp_sin_amp,'String',num2str(lr_mag));
            set(handles.l_ralp_sin_phase,'String',num2str(lr_sinphase*(180/pi)));
            set(handles.l_ralp_sin_THD,'String',num2str(lr_THD));
            
            set(handles.r_ralp_sin_offset,'String',num2str(rr_offset));
            set(handles.r_ralp_sin_amp,'String',num2str(rr_mag));
            set(handles.r_ralp_sin_phase,'String',num2str(rr_sinphase*(180/pi)));
            set(handles.r_ralp_sin_THD,'String',num2str(rr_THD));
            
            
            set(handles.l_lhrh_sin_offset,'String',num2str(lz_offset));
            set(handles.l_lhrh_sin_amp,'String',num2str(lz_mag));
            set(handles.l_lhrh_sin_phase,'String',num2str(lz_sinphase*(180/pi)));
            set(handles.l_lhrh_sin_THD,'String',num2str(lz_THD));
            
            set(handles.r_lhrh_sin_offset,'String',num2str(rz_offset));
            set(handles.r_lhrh_sin_amp,'String',num2str(rz_mag));
            set(handles.r_lhrh_sin_phase,'String',num2str(rz_sinphase*(180/pi)));
            set(handles.r_lhrh_sin_THD,'String',num2str(rz_THD));
            
            
            % Save results
            handles.Results.SineFit.ll_offset = ll_offset;
            handles.Results.SineFit.ll_mag = ll_mag;
            handles.Results.SineFit.ll_sinphase = ll_sinphase;
            handles.Results.SineFit.ll_cosphase = ll_cosphase;
            handles.Results.SineFit.ll_THD = ll_THD;
            
            handles.Results.SineFit.lr_offset = lr_offset;
            handles.Results.SineFit.lr_mag = lr_mag;
            handles.Results.SineFit.lr_sinphase = lr_sinphase;
            handles.Results.SineFit.lr_cosphase = lr_cosphase;
            handles.Results.SineFit.lr_THD = lr_THD;
            
            handles.Results.SineFit.lz_offset = lz_offset;
            handles.Results.SineFit.lz_mag = lz_mag;
            handles.Results.SineFit.lz_sinphase = lz_sinphase;
            handles.Results.SineFit.lz_cosphase = lz_cosphase;
            handles.Results.SineFit.lz_THD = lz_THD;
            
            % Right Eye
            handles.Results.SineFit.rl_offset = rl_offset;
            handles.Results.SineFit.rl_mag = rl_mag;
            handles.Results.SineFit.rl_sinphase = rl_sinphase;
            handles.Results.SineFit.rl_cosphase = rl_cosphase;
            handles.Results.SineFit.rl_THD = rl_THD;
            
            handles.Results.SineFit.rr_offset = rr_offset;
            handles.Results.SineFit.rr_mag = rr_mag;
            handles.Results.SineFit.rr_sinphase = rr_sinphase;
            handles.Results.SineFit.rr_cosphase = rr_cosphase;
            handles.Results.SineFit.rr_THD = rr_THD;
            
            handles.Results.SineFit.rz_offset = rz_offset;
            handles.Results.SineFit.rz_mag = rz_mag;
            handles.Results.SineFit.rz_sinphase = rz_sinphase;
            handles.Results.SineFit.rz_cosphase = rz_cosphase;
            handles.Results.SineFit.rz_THD = rz_THD;
            
            
            handles.Results.SineFit.Freq = freq;
            
        case 2 
            
            
            
            
    end
    
    
    handles.params.plot_sinefit_flag = 1;
    plot_data(hObject, eventdata, handles)
    
elseif button_state == get(hObject,'Min')
    
    handles.params.plot_sinefit_flag = 0;
    plot_data(hObject, eventdata, handles)
    
end

% Update handles structure
guidata(hObject, handles);

% --- Executes on selection change in sine_fit_method.
function sine_fit_method_Callback(hObject, eventdata, handles)
% hObject    handle to sine_fit_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 1 = Single Freq. FFT (CDS's code)

handles.params.sine_fit_method = get(hObject,'value');


% Update handles structure
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns sine_fit_method contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sine_fit_method


% --- Executes during object creation, after setting all properties.
function sine_fit_method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sine_fit_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in update_cycle_list.
function update_cycle_list_Callback(hObject, eventdata, handles)
% hObject    handle to update_cycle_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.update_file_disp,'BackgroundColor','red');
set(handles.update_file_disp,'String','Saving...')
set(handles.update_file_disp,'FontSize',15)

drawnow

RootData = handles.RootData;

% Save QP params
% RootData(handles.CurrData.curr_file).QPparams = handles.CurrData.QPparams;
% 
% RootData(handles.CurrData.curr_file).cyc2plot = get(handles.stim_table,'Data');
% 
% RootData(handles.CurrData.curr_file).CED.stim_ind = handles.CurrData.VOMA_data.stim_ind;


RootData(handles.curr_file).VOMA_data = handles.CurrData.VOMA_data;
RootData(handles.curr_file).SoftwareVer = handles.CurrData.SoftwareVer;
RootData(handles.curr_file).QPparams = handles.CurrData.QPparams;
RootData(handles.curr_file).cyc2plot = get(handles.stim_table,'Data');
RootData(handles.curr_file).VOMA_data.stim_ind = handles.CurrData.VOMA_data.stim_ind;

cd(handles.pathname);

eval(['save ' handles.filename ' RootData'])

set(handles.update_file_disp,'BackgroundColor','green');
set(handles.update_file_disp,'String','Saved!')
set(handles.update_file_disp,'FontSize',15)


guidata(hObject,handles)


% --- Executes on button press in go_back_to_gui.
function go_back_to_gui_Callback(hObject, eventdata, handles)
% hObject    handle to go_back_to_gui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.figure1)
voma__qpr(handles.RootData)


% --- Executes on button press in all_on.
function all_on_Callback(hObject, eventdata, handles)
% hObject    handle to all_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.stim_list = true(1,length(handles.CurrData.VOMA_data.stim_ind));

set(handles.keep_cycle,'Value',1);

% Since we changed the list of stimuli to keep, run the 'updatestimlist'
% function
updatestimlist(hObject, eventdata, handles)

handles = guidata(hObject);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in all_off.
function all_off_Callback(hObject, eventdata, handles)
% hObject    handle to all_off (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.stim_list = false(1,length(handles.CurrData.VOMA_data.stim_ind));

set(handles.keep_cycle,'Value',0);

% Since we changed the list of stimuli to keep, run the 'updatestimlist'
% function
updatestimlist(hObject, eventdata, handles)

handles = guidata(hObject);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in lefteye_flag.
function lefteye_flag_Callback(hObject, eventdata, handles)
% hObject    handle to lefteye_flag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
	handles.params.lefteye_flag = 1;
else
	handles.params.lefteye_flag = 0;
end
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of lefteye_flag


% --- Executes on button press in righteye_flag.
function righteye_flag_Callback(hObject, eventdata, handles)
% hObject    handle to righteye_flag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
	handles.params.righteye_flag = 1;
else
	handles.params.righteye_flag = 0;
end
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of righteye_flag


% --- Executes on button press in over_ride_max_vel.
function over_ride_max_vel_Callback(hObject, eventdata, handles)
% hObject    handle to over_ride_max_vel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.RootData(handles.CurrData.curr_file).Coils.Stim_Info.Max_Vel  = {max(abs(handles.CurrData.VOMA_data.Stim_Trace))};
set(handles.max_vel,'String',handles.RootData(handles.CurrData.curr_file).Coils.Stim_Info.Max_Vel{1});



guidata(hObject,handles)


% --- Executes on button press in open_stimanalysis.
function open_stimanalysis_Callback(hObject, eventdata, handles)
% hObject    handle to open_stimanalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
voma__stim_analysis(handles.CurrData,handles.RootData,handles.curr_file,handles.pathname,handles.filename);



function stim_plot_mult_Callback(hObject, eventdata, handles)
% hObject    handle to stim_plot_mult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input = str2double(get(hObject,'String'));
handles.params.stim_plot_mult = input;

plot_cycle_Callback(hObject, eventdata, handles)

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


% --- Executes on button press in lock_yaxis.
function lock_yaxis_Callback(hObject, eventdata, handles)
% hObject    handle to lock_yaxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.params.lock_yaxis = true;
    
    

    
else
    handles.params.lock_yaxis = false;
    
    

    
end
guidata(hObject,handles)

% Hint: get(hObject,'Value') returns toggle state of lock_yaxis


% --- Executes during object creation, after setting all properties.
function update_cycle_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to update_cycle_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
