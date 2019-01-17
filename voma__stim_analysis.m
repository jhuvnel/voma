function varargout = voma__stim_analysis(varargin)
% VOMA__STIM_ANALYSIS MATLAB code for voma__stim_analysis.fig
%      VOMA__STIM_ANALYSIS, by itself, creates a new VOMA__STIM_ANALYSIS or raises the existing
%      singleton*.
%
%      H = VOMA__STIM_ANALYSIS returns the handle to a new VOMA__STIM_ANALYSIS or the handle to
%      the existing singleton*.
%
%      VOMA__STIM_ANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VOMA__STIM_ANALYSIS.M with the given input arguments.
%
%      VOMA__STIM_ANALYSIS('Property','Value',...) creates a new VOMA__STIM_ANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before voma__stim_analysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to voma__stim_analysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
%       The VOMA version of 'stim_analysis' was adapted from
%       'stim_analysis_v2b'
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help voma__stim_analysis

% Last Modified by GUIDE v2.5 02-Mar-2017 19:12:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @voma__stim_analysis_OpeningFcn, ...
                   'gui_OutputFcn',  @voma__stim_analysis_OutputFcn, ...
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


% --- Executes just before voma__stim_analysis is made visible.
function voma__stim_analysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to voma__stim_analysis (see VARARGIN)

% Choose default command line output for voma__stim_analysis
handles.output = hObject;

% handles.CurrData,handles.RootData

% Open the input data file
CurrData = varargin{1};
handles.CurrData = CurrData;

% Save entire data structure for updating
handles.RootData = varargin{2};

handles.curr_file = varargin{3};
handles.pathname = varargin{4};
handles.filename = varargin{5};

if isrow(handles.CurrData.VOMA_data.Stim_t)
    handles.CurrData.VOMA_data.Stim_t = handles.CurrData.VOMA_data.Stim_t';
end

set(handles.upsamp_Fs,'String',num2str(handles.CurrData.VOMA_data.Fs));

if isfield(CurrData.VOMA_data,'UpSamp')
    
    
    choice = questdlg('You have previously upsampled the data for this file. How would you like to proceed?', ...
        'Upsampled Data Found', ...
        'Use the upsampled data in this GUI','Load the data on its original time base.','Load the data on its original time base.');
    % Handle response
    switch choice
        case 'Use the upsampled data in this GUI'
            handles.upsamp_flag = true;
        case 'Load the data on its original time base.'
            handles.upsamp_flag = false;
        otherwise
            % If the user exits the dialog box, just load the data on the
            % original time base.
            handles.upsamp_flag = false;
    end
else
    % If the file being processed has not been upsampled, load the
    % processed data on the original time base.
    handles.upsamp_flag = false;
    
end

if handles.upsamp_flag
    
    handles.Stimulus = handles.CurrData.VOMA_data.UpSamp.Stim_Trace;
    handles.Time = handles.CurrData.VOMA_data.UpSamp.Stim_t;
    handles.stim_ind = handles.CurrData.VOMA_data.UpSamp.stim_ind;
    
    handles.UpSamp = handles.CurrData.VOMA_data.UpSamp;
    
    handles.params.upsamp_Fs = handles.UpSamp.Fs;
    
    set(handles.upsamp_Fs,'String',num2str(handles.params.upsamp_Fs))
else
    
    handles.Stimulus = handles.CurrData.VOMA_data.Stim_Trace;
    handles.Time = handles.CurrData.VOMA_data.Stim_t;
    handles.stim_ind = handles.CurrData.VOMA_data.stim_ind;
    
    
end

if isrow(handles.Stimulus)
    handles.Stimulus = handles.Stimulus';
end

if isrow(handles.Time)
    handles.Stimulus = handles.Time';
end

% Plot the Stimulus Trace
plot_stim_trace(hObject, eventdata, handles)


set(handles.trig_time_params,'Visible','Off')

handles.params.detect_method = 1;

handles.params.align_thresh = 0;

handles.params.pre_stim_dur = 0;

handles.params.btwn_stim_dur = str2double(get(handles.btwn_stim_duration,'String'))/1000;

set(handles.align_thresh,'String',num2str(handles.params.align_thresh));

set(handles.pre_stim_dur,'String',num2str(handles.params.pre_stim_dur));



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes voma__stim_analysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function plot_stim_trace(hObject, eventdata, handles) 

axes(handles.stim_plot);
cla

CurrData = handles.CurrData;
switch CurrData.VOMA_data.Parameters.DAQ_code
    case {1,4,5,7,8}
        plot(handles.stim_plot,handles.Time,handles.Stimulus,'k')
        hold on
        plot(handles.stim_plot,handles.Time(handles.stim_ind(:,1)),handles.Stimulus(handles.stim_ind(:,1)),'rx')
        
        set(handles.cycle_table,'Data',[handles.Time(handles.stim_ind(:,1)) handles.Stimulus(handles.stim_ind(:,1))]);
        
        
    case {2,3} % These case involve using the CED to record precise eletrical
        % Stimulus pulse arrival times.
        switch CurrData.VOMA_data.Parameters.Stim_Info.Stim_Type{1}
            case 'Current Fitting'
                plot(handles.stim_plot,handles.Stimulus(1,:),ones(1,length(handles.Stimulus(1,:))),'Marker','*','color','k','LineWidth',0.5)
                hold on
                plot(handles.stim_plot,handles.Stimulus(1,handles.stim_ind(:,1)),ones(1,length(handles.Stimulus(1,handles.stim_ind(:,1)))),'ro')
                %         plot(handles.stim_plot,handles.Stimulus(1,handles.stim_ind(:,2)),ones(1,length(handles.Stimulus(1,handles.stim_ind(:,2)))),'go')
                
                set(handles.cycle_table,'Data',[handles.Stimulus(1,handles.stim_ind(:,1))' handles.Stimulus(1,handles.stim_ind(:,2))']);
                %         set(handles.cycle_table,'Data',[handles.Stimulus(1,handles.stim_ind(:,1))]');
            otherwise
                
                plot(handles.stim_plot,handles.Time,handles.Stimulus,'k')
                hold on
                plot(handles.stim_plot,handles.Time(handles.stim_ind(:,1)),handles.Stimulus(handles.stim_ind(:,1)),'rx')
                
                set(handles.cycle_table,'Data',[handles.Time(handles.stim_ind(:,1)) handles.Stimulus(handles.stim_ind(:,1))]);
                
        end
end

% --- Outputs from this function are returned to the command line.
function varargout = voma__stim_analysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in upsample_data.
function upsample_data_Callback(hObject, eventdata, handles)
% hObject    handle to upsample_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.upsamp_flag = true;

% Before upsampling, lets reset the traces
[handles] = reset_stim_Callback(hObject, eventdata, handles);

Fs_up = handles.params.upsamp_Fs;

handles.UpSamp.Fs = Fs_up;

handles.UpSamp.Stim_t = [handles.Time(1):1/Fs_up:handles.Time(end)]';

handles.UpSamp.Stim_Trace = interp1(handles.Time,handles.Stimulus,handles.UpSamp.Stim_t);



handles.UpSamp.Data_LE_Vel_LARP = interp1(handles.Time,handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_LARP,handles.UpSamp.Stim_t);
handles.UpSamp.Data_LE_Vel_RALP = interp1(handles.Time,handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_RALP,handles.UpSamp.Stim_t);
handles.UpSamp.Data_LE_Vel_Z = interp1(handles.Time,handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Z,handles.UpSamp.Stim_t);
handles.UpSamp.Data_LE_Vel_X = interp1(handles.Time,handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_X,handles.UpSamp.Stim_t);
handles.UpSamp.Data_LE_Vel_Y = interp1(handles.Time,handles.CurrData.VOMA_data.Filtered.Data_LE_Vel_Y,handles.UpSamp.Stim_t);

handles.UpSamp.Data_RE_Vel_LARP = interp1(handles.Time,handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_LARP,handles.UpSamp.Stim_t);
handles.UpSamp.Data_RE_Vel_RALP = interp1(handles.Time,handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_RALP,handles.UpSamp.Stim_t);
handles.UpSamp.Data_RE_Vel_Z = interp1(handles.Time,handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Z,handles.UpSamp.Stim_t);
handles.UpSamp.Data_RE_Vel_X = interp1(handles.Time,handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_X,handles.UpSamp.Stim_t);
handles.UpSamp.Data_RE_Vel_Y = interp1(handles.Time,handles.CurrData.VOMA_data.Filtered.Data_RE_Vel_Y,handles.UpSamp.Stim_t);

handles.UpSamp.stim_ind = [1];

handles.Stimulus = handles.UpSamp.Stim_Trace;
handles.Time = handles.UpSamp.Stim_t;
handles.stim_ind = handles.UpSamp.stim_ind;

plot_stim_trace(hObject, eventdata, handles) 


% Update handles structure
guidata(hObject, handles);

function upsamp_Fs_Callback(hObject, eventdata, handles)
% hObject    handle to upsamp_Fs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input = get(hObject,'String');

handles.params.upsamp_Fs = str2double(input);


guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of upsamp_Fs as text
%        str2double(get(hObject,'String')) returns contents of upsamp_Fs as a double


% --- Executes during object creation, after setting all properties.
function upsamp_Fs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to upsamp_Fs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in find_cycles.
function find_cycles_Callback(hObject, eventdata, handles)
% hObject    handle to find_cycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isrow(handles.Time)
    handles.Time = handles.Time';
end

switch handles.params.detect_method
    
    case 1
       
        
        if handles.params.align_thresh >= 0
            
            inds = [1:length(handles.Time)];
        
            pos_ind = [false ; diff(handles.Stimulus > handles.params.align_thresh)];
        
            stim_pos_thresh_ind = inds(pos_ind > 0 )';
%             stim_neg_thresh_ind = inds(neg_ind > 0 )';
            
           
            
        else
            
            inds = [1:length(handles.Time)];
        
            pos_ind = [false ; diff(handles.Stimulus < handles.params.align_thresh)];
        
            stim_pos_thresh_ind = inds(pos_ind > 0 )';
            
            
        end
        
         if handles.upsamp_flag
                
                handles.pos_stim_ind = stim_pos_thresh_ind - round(handles.params.pre_stim_dur*handles.params.upsamp_Fs);
                
            else
                handles.pos_stim_ind = stim_pos_thresh_ind - round(handles.params.pre_stim_dur*handles.CurrData.VOMA_data.Fs);
                
            end
            
            %         handles.neg_stim_ind = stim_neg_thresh_ind;
            
            %         set(handles.cycle_table,'Data',[handles.Time([stim_pos_thresh_ind stim_neg_thresh_ind]) handles.Stimulus([stim_pos_thresh_ind stim_neg_thresh_ind])]);
            set(handles.cycle_table,'Data',[handles.Time([stim_pos_thresh_ind ]) handles.Stimulus([stim_pos_thresh_ind ])]);
            
            axes(handles.stim_plot);
            cla
            %         handles.stim_ind = [handles.pos_stim_ind handles.neg_stim_ind];
            handles.stim_ind = [handles.pos_stim_ind ];
        
        plot(handles.stim_plot,handles.Time,handles.Stimulus,'k')
        hold on
        plot(handles.stim_plot,handles.Time(stim_pos_thresh_ind),handles.Stimulus(stim_pos_thresh_ind),'rx')
        %         plot(handles.stim_plot,handles.Time(stim_neg_thresh_ind),handles.Stimulus(stim_neg_thresh_ind),'bx')
        guidata(hObject,handles)
    case 2
        inds = [1:length(handles.Stimulus)];
        
        % This case is applicable for ELECTRICAL stimulation trigger
        % timestamps
        
        % We will not find cycles of the stimulus by using the 'time
        % between stimulation' threshold defined by the user. We will check
        % the timing between each stimulus data point, and find where the
        % 'inter-stimulus-interval' is LONGER than the user defined
        % thhreshold. We will grab the indices of all pulses where this
        % occurs, starting with the the FIRST stimulus index.
        stim_inds_new = [1 inds([false diff(handles.Stimulus(1,:))>handles.params.btwn_stim_dur])];
        
        if length(stim_inds_new)>1
            handles.stim_ind = [stim_inds_new' [stim_inds_new(2:end)' ;  stim_inds_new(end)]];
            
        else
            
            handles.stim_ind = [stim_inds_new' 0];
            
        end
        plot_stim_trace(hObject, eventdata, handles)
        guidata(hObject,handles)
        
    case 3
        [stim_ind_temp] = voma__find_stim_ind(handles.Stimulus,handles.CurrData.VOMA_data.Fs,handles.Time,'n');
        
        set(handles.cycle_table,'Data',[handles.Time(stim_ind_temp)]);
        
        handles.stim_ind = stim_ind_temp;
        
        plot_stim_inds(hObject, eventdata, handles)
        guidata(hObject,handles)
    case 4
                        temp_smth = sgolayfilt(handles.Stimulus,3,105);
                temp_smth = sgolayfilt(temp_smth,3,105);
                mask = zeros(1,length(temp_smth));
        mask(temp_smth>20) = ones(length(mask(temp_smth>20)),1);
        a = [false ; diff(abs(mask'))>0];
        inds = find(a>0);

        [pks,locs] = findpeaks(handles.Stimulus,'MinPeakHeight',100,'MinPeakDistance',2000);
        if length(locs)>10
            finalInds = [];
            for i = 1:length(locs)
                d = inds-locs(i);
                d(d<0);
                finalInds = [finalInds;inds(max(d(d<0))==(d))];
            end
            finalInds = finalInds-100;
        else

finalInds = inds([diff(inds);false]>500);

        end
            stim_ind_temp = finalInds;
        set(handles.cycle_table,'Data',[handles.Time(stim_ind_temp)]);
        
        handles.stim_ind = stim_ind_temp;
        
        plot_stim_inds(hObject, eventdata, handles)
guidata(hObject,handles)
end

function plot_stim_inds(hObject, eventdata, handles)
 stim_inds = get(handles.cycle_table,'Data');

 axes(handles.stim_plot);
 cla
 
 plot(handles.stim_plot,handles.Time,handles.Stimulus,'k')
 hold on
 plot(handles.stim_plot,handles.Time(handles.stim_ind(:,1)),handles.Stimulus(handles.stim_ind(:,1)),'rx')
 try
 plot(handles.stim_plot,handles.Time(handles.stim_ind(:,2)),handles.Stimulus(handles.stim_ind(:,2)),'bx')
 catch
 end


% --- Executes on button press in delete_ind.
function delete_ind_Callback(hObject, eventdata, handles)
% hObject    handle to delete_ind (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles.params,'r') && ~isempty(handles.params.r)
    r = handles.params.r;
%     handles.stim_ind = handles.stim_ind([true(1,r-1) false(1,1) true(1,size(handles.stim_ind,1)-r)],:);
    handles.stim_ind(r,:) = [];
    guidata(hObject,handles)
    r = [];
    plot_stim_inds(hObject, eventdata, handles)
    set(handles.cycle_table,'Data',handles.Time(handles.stim_ind))

else
    
    msgbox('You have tried to delete a UGQPR point without selecting which point to delete. Please click on a cell in either column for the row you want to delete.','User Guided QPR')
    
end

function align_thresh_Callback(hObject, eventdata, handles)
% hObject    handle to align_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input = get(hObject,'String');

handles.params.align_thresh = str2double(input);


guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of align_thresh as text
%        str2double(get(hObject,'String')) returns contents of align_thresh as a double


% --- Executes during object creation, after setting all properties.
function align_thresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to align_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in go_back_vor_gui.
function go_back_vor_gui_Callback(hObject, eventdata, handles)
% hObject    handle to go_back_vor_gui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.upsamp_flag 
    handles.CurrData.VOMA_data.UpSamp = handles.UpSamp;
    handles.CurrData.VOMA_data.UpSamp.stim_ind = handles.stim_ind;
else
    handles.CurrData.VOMA_data.stim_ind = handles.stim_ind;
end
handles.CurrData.cyc2plot = [];

handles.RootData(handles.curr_file).VOMA_data = handles.CurrData.VOMA_data;
handles.RootData(handles.curr_file).SoftwareVer = handles.CurrData.SoftwareVer;
handles.RootData(handles.curr_file).QPparams = handles.CurrData.QPparams;
handles.RootData(handles.curr_file).cyc2plot = handles.CurrData.cyc2plot;

if handles.upsamp_flag
    handles.RootData(handles.curr_file).VOMA_data.UpSamp = handles.CurrData.VOMA_data.UpSamp;
end


close(handles.figure1)
voma__cycle_analysis_gui(handles.CurrData,handles.RootData,handles.curr_file,handles.pathname,handles.filename);


% --- Executes during object creation, after setting all properties.
function stim_plot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate stim_plot


% --- Executes on selection change in detect_method.
function detect_method_Callback(hObject, eventdata, handles)
% hObject    handle to detect_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index_selected = get(hObject,'Value');

handles.params.detect_method = index_selected;

switch handles.params.detect_method
    
    case 1
        set(handles.thresh_params,'Visible','on')
        set(handles.trig_time_params,'Visible','off')
    case 2
        set(handles.thresh_params,'Visible','off')
        set(handles.trig_time_params,'Visible','on')
end


guidata(hObject,handles)

% Hints: contents = cellstr(get(hObject,'String')) returns detect_method contents as cell array
%        contents{get(hObject,'Value')} returns selected item from detect_method


% --- Executes during object creation, after setting all properties.
function detect_method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to detect_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function btwn_stim_duration_Callback(hObject, eventdata, handles)
% hObject    handle to btwn_stim_duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input = str2double(get(hObject,'String'));
handles.params.btwn_stim_dur = input/1000;

guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of btwn_stim_duration as text
%        str2double(get(hObject,'String')) returns contents of btwn_stim_duration as a double


% --- Executes during object creation, after setting all properties.
function btwn_stim_duration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to btwn_stim_duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected cell(s) is changed in cycle_table.
function cycle_table_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to cycle_table (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
indices = eventdata.Indices;
r = indices(:,1);
c = indices(:,2);

handles.params.r = r;

set(handles.stim_ind_start,'string',handles.Time(handles.stim_ind(r,1)));
try
    set(handles.stim_ind_end,'string',handles.Time(handles.stim_ind(r,2)));

catch
end
guidata(hObject,handles)



function stim_ind_start_Callback(hObject, eventdata, handles)
% hObject    handle to stim_ind_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stim_ind_start as text
%        str2double(get(hObject,'String')) returns contents of stim_ind_start as a double


% --- Executes during object creation, after setting all properties.
function stim_ind_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim_ind_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stim_ind_end_Callback(hObject, eventdata, handles)
% hObject    handle to stim_ind_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stim_ind_end as text
%        str2double(get(hObject,'String')) returns contents of stim_ind_end as a double


% --- Executes during object creation, after setting all properties.
function stim_ind_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim_ind_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pre_stim_dur_Callback(hObject, eventdata, handles)
% hObject    handle to pre_stim_dur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input = get(hObject,'String');

handles.params.pre_stim_dur = str2double(input)/1000;


guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of pre_stim_dur as text
%        str2double(get(hObject,'String')) returns contents of pre_stim_dur as a double


% --- Executes during object creation, after setting all properties.
function pre_stim_dur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pre_stim_dur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in reset_stim.
function [handles] = reset_stim_Callback(hObject, eventdata, handles)
% hObject    handle to reset_stim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Stimulus = handles.CurrData.VOMA_data.Stim_Trace;
handles.Time = handles.CurrData.VOMA_data.Stim_t;
handles.stim_ind = handles.CurrData.VOMA_data.stim_ind;

% Check if a 'UpSamp' field already exists in the GUI handles. If so, let's
% remove it since we are reseting the stimulus trace.
if isfield(handles,'UpSamp')
    handles = rmfield(handles,'UpSamp');
end

% Plot the Stimulus Trace
plot_stim_trace(hObject, eventdata, handles)

guidata(hObject,handles)


% --- Executes on button press in remove_offsets.
function remove_offsets_Callback(hObject, eventdata, handles)
% hObject    handle to remove_offsets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiwait(msgbox('Please align the vertical line of the crosshair with the starting point of the data segment used to calculate MPU offsets','Segment Eye Movement Data'));
[x1,y1] = ginput(1);
uiwait(msgbox('Please align the vertical line of the crosshair with the ending point of the data segment used to calculate MPU offsets','Segment Eye Movement Data'));
[x2,y2] = ginput(1);
time_cutout_s = [x1 ; x2];

[a1,i_start_eye] = min(abs(handles.Time - time_cutout_s(1,1)));
[a2,i_end_eye] = min(abs(handles.Time - time_cutout_s(2,1)));

Stim_off = mean(handles.Stimulus(i_start_eye:i_start_eye));

handles.Stimulus = handles.Stimulus - Stim_off;

% Plot the Stimulus Trace
plot_stim_trace(hObject, eventdata, handles)

guidata(hObject,handles)
