function varargout = Coil_data_Segmenting(varargin)
% COIL_DATA_SEGMENTING MATLAB code for Coil_data_Segmenting.fig
%      COIL_DATA_SEGMENTING, by itself, creates a new COIL_DATA_SEGMENTING or raises the existing
%      singleton*.
%
%      H = COIL_DATA_SEGMENTING returns the handle to a new COIL_DATA_SEGMENTING or the handle to
%      the existing singleton*.
%
%      COIL_DATA_SEGMENTING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COIL_DATA_SEGMENTING.M with the given input arguments.
%
%      COIL_DATA_SEGMENTING('Property','Value',...) creates a new COIL_DATA_SEGMENTING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Coil_data_Segmenting_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Coil_data_Segmenting_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Coil_data_Segmenting

% Last Modified by GUIDE v2.5 17-Sep-2019 12:47:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Coil_data_Segmenting_OpeningFcn, ...
                   'gui_OutputFcn',  @Coil_data_Segmenting_OutputFcn, ...
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


% --- Executes just before Coil_data_Segmenting is made visible.
function Coil_data_Segmenting_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Coil_data_Segmenting (see VARARGIN)

% Choose default command line output for Coil_data_Segmenting
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Coil_data_Segmenting wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Coil_data_Segmenting_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in save_segment.
function [handles] = save_segment_Callback(hObject, eventdata, handles)
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
    folder_name = {uigetdir('','Select handles.Segment(fs).directory to Save the Segmented Data')};
    setappdata(handles.save_segment,'foldername',folder_name{1});
    cd(folder_name{1})
else
    
    cd(getappdata(handles.save_segment,'foldername'))
end

Data = handles.Segment;


% Note, there is an error in matlab if the first character of a file name
% is: '-'.
% This can happen if the user decides not to inlcude an input for the
% 'SubjectID' handles.filename input.
if strcmp(handles.params.segment_filename(1),'-')
    uiwait(msgbox('You have attempted to save a file segment which has a handles.filename leading with a ''-'' character. This will cause an error saving the file, so we are adding a ''_'' character infront of the handles.filename.','Segment Eye Movement Data'));
    
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
    handles.segment_number.String = num2str(segments);
end


guidata(hObject,handles)


function stringAddonBox_Callback(hObject, eventdata, handles)
% hObject    handle to stringAddonBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stringAddonBox as text
%        str2double(get(hObject,'String')) returns contents of stringAddonBox as a double


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


% --- Executes on button press in autoSeg.
function autoSeg_Callback(hObject, eventdata, handles)
% hObject    handle to autoSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.experimentdata = {};
setappdata(handles.export_data,'data',handles.experimentdata)
guidata(hObject,handles)
if isempty(handles.raw_name.String)
    load_raw_Callback(hObject, eventdata, handles)
end
if isempty(handles.gain_filename.String)
    load_gain_Callback(hObject, eventdata, handles)
end
% Get channel numbers that correspond to the animal
handles.eConfigPan.BackgroundColor = 'y';
uiwait(handles.figure1)
handles.eConfigPan.BackgroundColor = [0.94 0.94 0.94];

handles.canalInfo.stimCanal = [handles.set1_stim.String(handles.set1_stim.Value),...
    handles.set2_stim.String(handles.set2_stim.Value),...
    handles.set3_stim.String(handles.set3_stim.Value),...
    handles.set4_stim.String(handles.set4_stim.Value),...
    handles.set5_stim.String(handles.set5_stim.Value)];

handles.canalInfo.stimNum = [{handles.set1_stimNum.String(handles.set1_stimNum.Value)},...
    {handles.set2_stimNum.String(handles.set2_stimNum.Value)},...
    {handles.set3_stimNum.String(handles.set3_stimNum.Value)},...
    {handles.set4_stimNum.String(handles.set4_stimNum.Value)},...
    {handles.set5_stimNum.String(handles.set5_stimNum.Value)}];
handles.canalInfo.animal = handles.animalENum.String{handles.animalENum.Value};


% determine which eyes were recorded and what channels were used
handles.eyerecordedPan.BackgroundColor = 'y';
uiwait(handles.figure1)
handles.eyerecordedPan.BackgroundColor = [0.94 0.94 0.94];

if handles.leftEye.Value == 0
    handles.EyeCh = handles.leftEyeCh.String{handles.leftEyeCh.Value};
    handles.eye_rec.Value = 4;
    
elseif handles.rightEye.Value == 0
    handles.EyeCh = handles.rightEyeCh.String{handles.rightEyeCh.String.Value};
    handles.eye_rec.Value = 3;
else
    handles.EyeCh = {handles.rightEyeCh.String{handles.rightEyeCh.String.Value}...
        ,handles.leftEyeCh.String{handles.leftEyeCh.Value}};
    handles.eye_rec.Value = 2;
end
handles.string_addon = [];

guidata(hObject,handles)


% Get list of all coil files and sort chronologically, use number
% of coil files as iterations for for loop
bigFcn = @(s) (s.bytes > 10000);
tempList = dirPlus(handles.PathNameofFiles,'Struct',true,'FileFilter','\.smr$','Depth',0,'ValidateFileFcn', bigFcn);
t = datetime({tempList.date}','InputFormat','dd-MM-yyyy HH:mm:ss');
[b,idx] = sortrows(t);
handles.listing = tempList(idx);

count = 0;
indsForSeg = 1:length(handles.listing);
handles.totalSegment = length(indsForSeg);
handles.total_seg_num.String = ['Total of ',num2str(handles.totalSegment),' files to process'];
prosthSync = [];
handles.segment_number.String = '0';
segments = str2num(handles.segment_number.String);

if isempty(handles.listing)
    
else
    if segments>0
        s = segments+count;
    else
        s=1;
    end
    handles.prevStimCanal = '';
    handles.dAsgnFlag = 1;
    handles.dAsgn = 0;
    for fs = s:length(handles.listing)
        segments = str2num(handles.segment_number.String);
        
        if contains(handles.listing(fs).name,{'LP', 'LA', 'LH', 'RP', 'RA', 'RH','stim'}) && (handles.listing(fs).bytes>0)
            handles.Segment(fs).directory = [handles.listing(fs).folder,handles.ispc.slash];
            handles.filename = handles.listing(fs).name;
            handles.Segment(fs).raw_filename = handles.filename;
            underS = find(handles.filename=='_');
            dash = find(handles.filename=='-');
            delin = sort([underS dash],'ascend');
            dot = find(handles.filename=='.');
            stimPos = strfind(handles.filename,'stim');
            refPos = strfind(handles.filename,'ref');
            ipgPos = strfind(handles.filename,'IPG');
            ratePos = strfind(handles.filename,'rate');
            handles.Segment(fs).rate = str2num(handles.filename(ratePos+4:delin(12)-1));
            handles.Segment(fs).stim = str2num(handles.filename(stimPos+4:delin(6)-1));
            handles.Segment(fs).refNum = str2num(handles.filename(refPos+3:delin(7)-1));
            handles.Segment(fs).subj = handles.filename(delin(3)+1:delin(4)-1);
            if isempty(handles.Segment(fs).subj)
                handles.Segment(fs).subj = handles.canalInfo.animal;
            end
            if any(strfind(handles.filename,'phaseDur'))
                p1dPos = strfind(handles.filename,'phaseDur');
                handles.Segment(fs).p1d = str2num(handles.filename(p1dPos+9:ipgPos-1));
                handles.Segment(fs).ipg = str2num(handles.filename(ipgPos+3:delin(13)-1));
                handles.Segment(fs).p2d = handles.Segment(fs).p1d;
                amp = strfind(handles.filename,'amp');
                nextD = find(delin>amp,1);
                handles.Segment(fs).p1amp = str2num(handles.filename(amp(1)+3:delin(nextD)-1));
                handles.Segment(fs).p2amp = handles.Segment(fs).p1amp;
            elseif any(strfind(handles.filename,'phase1Dur'))
                p1dPos = strfind(handles.filename,'phase1Dur');
                handles.Segment(fs).p1d = str2num(handles.filename(p1dPos+9:delin(9)-1));
                p2dPos = strfind(handles.filename,'phase2Dur');
                handles.Segment(fs).p2d = str2num(handles.filename(p2dPos+9:delin(11)-1));
                handles.Segment(fs).ipg = str2num(handles.filename(ipgPos+3:delin(13)-1));
                p1aPos = strfind(handles.filename,'phase1amp');
                handles.Segment(fs).p1amp = str2num(handles.filename(p1aPos+9:delin(8)-1));
                p2aPos = strfind(handles.filename,'phase2amp');
                handles.Segment(fs).p2amp = str2num(handles.filename(p2aPos+9:delin(10)-1));
            end
            
            if any(strfind(handles.filename,'defaultStart'))
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
                start = strfind(handles.filename,'defaultStart');
                handles.string_addon = ['-dSp2d',p2dT,handles.filename(start:delin(14)-1)];
                if handles.dAsgnFlag
                    handles.dAsgn = handles.dAsgn +1;
                    handles.dAsgnFlag = 0;
                end
            else
                dS = 0;
                handles.string_addon = [''];
                handles.dAsgnFlag = 1;
            end
            
            
            
            
            switch handles.params.system_code
                case 1 % Lasker Spike2 Coil Files
                    
                case 2
            end
            
            
            handles.Segment(fs).EyesRecorded = handles.eye_rec.String;
            handles.Segment(fs).dS = dS;
            handles.Segment(fs).dAsgn = handles.dAsgn;
            handles.Segment(fs).segment_code_version = mfilename;

            
            
            segments = str2num(handles.segment_number.String);
            if segments == 0
                handles.save_path_name.String = [handles.Segment(fs).directory,'Segments',handles.ispc.slash];
                handles.save_path_name.BackgroundColor = 'y';
                uiwait(handles.figure1)
                mkdir([handles.Segment(fs).directory,'Segments',handles.ispc.slash])
                setappdata(handles.save_segment,'foldername',[handles.Segment(fs).directory,'Segments',handles.ispc.slash]);
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
            
        elseif contains(handles.listing(fs).name,{'LP', 'LA', 'LH', 'RP', 'RA', 'RH','handles.Segment(fs).stim'}) && (handles.listing(fs).bytes==0)
            handles.totalSegment = handles.totalSegment-1;
            handles.raw_name.String = ['Total of ',num2str(handles.totalSegment),' files to process'];
        end
        handles.prevStimCanal = getappdata(handles.stim_axis,'ax');
        count = count +1;
    end
end







% --- Executes on button press in load_spread_sheet.
function load_spread_sheet_Callback(hObject, eventdata, handles)
% hObject    handle to load_spread_sheet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in export_data.
function export_data_Callback(hObject, eventdata, handles)
% hObject    handle to export_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in Lasker_param1.
function Lasker_param1_Callback(hObject, eventdata, handles)
% hObject    handle to Lasker_param1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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


% --- Executes on button press in plot_IPR_flag.
function plot_IPR_flag_Callback(hObject, eventdata, handles)
% hObject    handle to plot_IPR_flag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot_IPR_flag



function upper_trigLev_Callback(hObject, eventdata, handles)
% hObject    handle to upper_trigLev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of upper_trigLev as text
%        str2double(get(hObject,'String')) returns contents of upper_trigLev as a double


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



function lower_trigLev_Callback(hObject, eventdata, handles)
% hObject    handle to lower_trigLev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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


% --- Executes on selection change in subj_id.
function subj_id_Callback(hObject, eventdata, handles)
% hObject    handle to subj_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns subj_id contents as cell array
%        contents{get(hObject,'Value')} returns selected item from subj_id


% --- Executes during object creation, after setting all properties.
function subj_id_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subj_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in visit_number.
function visit_number_Callback(hObject, eventdata, handles)
% hObject    handle to visit_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns visit_number contents as cell array
%        contents{get(hObject,'Value')} returns selected item from visit_number


% --- Executes during object creation, after setting all properties.
function visit_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to visit_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function date_Callback(hObject, eventdata, handles)
% hObject    handle to date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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


% --- Executes on selection change in exp_type.
function exp_type_Callback(hObject, eventdata, handles)
% hObject    handle to exp_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns exp_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from exp_type


% --- Executes during object creation, after setting all properties.
function exp_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exp_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in exp_condition.
function exp_condition_Callback(hObject, eventdata, handles)
% hObject    handle to exp_condition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns exp_condition contents as cell array
%        contents{get(hObject,'Value')} returns selected item from exp_condition


% --- Executes during object creation, after setting all properties.
function exp_condition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exp_condition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in stim_axis.
function stim_axis_Callback(hObject, eventdata, handles)
% hObject    handle to stim_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns stim_axis contents as cell array
%        contents{get(hObject,'Value')} returns selected item from stim_axis


% --- Executes during object creation, after setting all properties.
function stim_axis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in stim_type.
function stim_type_Callback(hObject, eventdata, handles)
% hObject    handle to stim_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns stim_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from stim_type


% --- Executes during object creation, after setting all properties.
function stim_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in stim_frequency.
function stim_frequency_Callback(hObject, eventdata, handles)
% hObject    handle to stim_frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns stim_frequency contents as cell array
%        contents{get(hObject,'Value')} returns selected item from stim_frequency


% --- Executes during object creation, after setting all properties.
function stim_frequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim_frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in stim_intensity.
function stim_intensity_Callback(hObject, eventdata, handles)
% hObject    handle to stim_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns stim_intensity contents as cell array
%        contents{get(hObject,'Value')} returns selected item from stim_intensity


% --- Executes during object creation, after setting all properties.
function stim_intensity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in implant.
function implant_Callback(hObject, eventdata, handles)
% hObject    handle to implant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns implant contents as cell array
%        contents{get(hObject,'Value')} returns selected item from implant


% --- Executes during object creation, after setting all properties.
function implant_CreateFcn(hObject, eventdata, handles)
% hObject    handle to implant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in eye_rec.
function eye_rec_Callback(hObject, eventdata, handles)
% hObject    handle to eye_rec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns eye_rec contents as cell array
%        contents{get(hObject,'Value')} returns selected item from eye_rec


% --- Executes during object creation, after setting all properties.
function eye_rec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eye_rec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in load_raw.
function load_raw_Callback(hObject, eventdata, handles)
% hObject    handle to load_raw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.PathNameofFiles = uigetdir(cd,'Please choose the folder where the coil files are saved');
cd( handles.PathNameofFiles)
handles.raw_PathName = handles.PathNameofFiles;
handles.raw_name.String = handles.raw_PathName;
guidata(hObject,handles)

% --- Executes on selection change in eye_mov_system.
function eye_mov_system_Callback(hObject, eventdata, handles)
% hObject    handle to eye_mov_system (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns eye_mov_system contents as cell array
%        contents{get(hObject,'Value')} returns selected item from eye_mov_system
index_selected = get(hObject,'Value');

handles.params.system_code = index_selected;

switch handles.params.system_code
    % Maybe I should switch this to a series of 'if' statements, since I
    % will be shutting off every option box when the system code changes...
    
    case 1 % Lasker Spike2 Coil Files
        set(handles.LaskerSystPanel,'Visible','On')

    case 2 % Ross 710 Moog Coil System
        set(handles.LaskerSystPanel,'Visible','Off');

end
handles.timesExported =0;
handles.whereToStartExp = 1;
guidata(hObject,handles)

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


% --- Executes on button press in load_gain.
function load_gain_Callback(hObject, eventdata, handles)
% hObject    handle to load_gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FieldGainFile,FieldGainPath,FieldGainFilterIndex] = uigetfile('*.*','Please choose the field gains for this experiment');
if ~isempty(handles.exp_spread_sheet_name.String)
    if ~isfile([FieldGainPath,'\',handles.exp_spread_sheet_name.String])
        handles.exp_spread_sheet_name.String = '';
    end
end

handles.raw_FieldGainPath = FieldGainPath;
handles.raw_FieldGainFile = FieldGainFile;
handles.gain_filename.String = FieldGainFile;

switch handles.params.system_code
    case 1
        % Import the Field Gain file, collected using the vordaq/showall
        % software
        handles.fieldgainname = [handles.raw_FieldGainPath handles.raw_FieldGainFile];
        delimiter = '\t';
        formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
        
        fileID = fopen(fieldgainname,'r');
        
        dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN, 'ReturnOnError', false);
        
        fclose(fileID);
        
        handles.FieldGains = [dataArray{1:end-1}];
        
        % During my daily calibration procedure, I zero-out the fields to
        % have no offsets with a test coil.
        handles.coilzeros = [0 0 0 0 0 0 0 0 0 0 0 0];
    case 2
end
guidata(hObject,handles)

% --- Executes on selection change in set1_stimNum.
function set1_stimNum_Callback(hObject, eventdata, handles)
% hObject    handle to set1_stimNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns set1_stimNum contents as cell array
%        contents{get(hObject,'Value')} returns selected item from set1_stimNum


% --- Executes during object creation, after setting all properties.
function set1_stimNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to set1_stimNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in set2_stimNum.
function set2_stimNum_Callback(hObject, eventdata, handles)
% hObject    handle to set2_stimNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns set2_stimNum contents as cell array
%        contents{get(hObject,'Value')} returns selected item from set2_stimNum


% --- Executes during object creation, after setting all properties.
function set2_stimNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to set2_stimNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in set3_stimNum.
function set3_stimNum_Callback(hObject, eventdata, handles)
% hObject    handle to set3_stimNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns set3_stimNum contents as cell array
%        contents{get(hObject,'Value')} returns selected item from set3_stimNum


% --- Executes during object creation, after setting all properties.
function set3_stimNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to set3_stimNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in set4_stimNum.
function set4_stimNum_Callback(hObject, eventdata, handles)
% hObject    handle to set4_stimNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns set4_stimNum contents as cell array
%        contents{get(hObject,'Value')} returns selected item from set4_stimNum


% --- Executes during object creation, after setting all properties.
function set4_stimNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to set4_stimNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in set5_stimNum.
function set5_stimNum_Callback(hObject, eventdata, handles)
% hObject    handle to set5_stimNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns set5_stimNum contents as cell array
%        contents{get(hObject,'Value')} returns selected item from set5_stimNum


% --- Executes during object creation, after setting all properties.
function set5_stimNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to set5_stimNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in animalENum.
function animalENum_Callback(hObject, eventdata, handles)
% hObject    handle to animalENum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns animalENum contents as cell array
%        contents{get(hObject,'Value')} returns selected item from animalENum
switch hObject.Value
    case 1 %GiGi Left Ear
        handles.set1_stimNum.Value = [4 5 6];
        handles.set2_stimNum.Value = [1 2 3];
        handles.set3_stimNum.Value = [7 8 9];
         handles.set4_stimNum.Value = [11];
          handles.set5_stimNum.Value = [10];
        
    case 2 %MoMo Left Ear
              handles.set1_stimNum.Value = [7 8 9];
        handles.set2_stimNum.Value = [1 2 3];
        handles.set3_stimNum.Value = [4 5 6];
         handles.set4_stimNum.Value = [11];
          handles.set5_stimNum.Value = [10];
    case 3 %Nancy
    case 4 %Yoda Right Ear
        handles.set1_stimNum.Value = [1 2 3];
        handles.set2_stimNum.Value = [4 5 6 14];
        handles.set3_stimNum.Value = [7 8 9 15];
         handles.set4_stimNum.Value = [11 12 13];
          handles.set5_stimNum.Value = [10];
end
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function animalENum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to animalENum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in set5_stim.
function set5_stim_Callback(hObject, eventdata, handles)
% hObject    handle to set5_stim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns set5_stim contents as cell array
%        contents{get(hObject,'Value')} returns selected item from set5_stim


% --- Executes during object creation, after setting all properties.
function set5_stim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to set5_stim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in confirmParams.
function confirmParams_Callback(hObject, eventdata, handles)
% hObject    handle to confirmParams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1)
guidata(hObject, handles);

% --- Executes on button press in leftEye.
function leftEye_Callback(hObject, eventdata, handles)
% hObject    handle to leftEye (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of leftEye


% --- Executes on button press in rightEye.
function rightEye_Callback(hObject, eventdata, handles)
% hObject    handle to rightEye (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rightEye


% --- Executes on selection change in leftEyeCh.
function leftEyeCh_Callback(hObject, eventdata, handles)
% hObject    handle to leftEyeCh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns leftEyeCh contents as cell array
%        contents{get(hObject,'Value')} returns selected item from leftEyeCh


% --- Executes during object creation, after setting all properties.
function leftEyeCh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to leftEyeCh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in rightEyeCh.
function rightEyeCh_Callback(hObject, eventdata, handles)
% hObject    handle to rightEyeCh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns rightEyeCh contents as cell array
%        contents{get(hObject,'Value')} returns selected item from rightEyeCh


% --- Executes during object creation, after setting all properties.
function rightEyeCh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rightEyeCh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over confirmParams.
function confirmParams_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to confirmParams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
eventdata
%confirmParams_Callback(hObject, eventdata, handles)
guidata(hObject,handles)



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


% --- Executes on button press in save_path.
function save_path_Callback(hObject, eventdata, handles)
% hObject    handle to save_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder_name = {uigetdir('','Select handles.Segment(fs).directory to Save the Segmented Data')};
handles.save_path_name.String = folder_name;
guidata(hObject,handles)
