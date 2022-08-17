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

% Last Modified by GUIDE v2.5 20-Sep-2019 17:45:52

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
% Initialize Operating system flag
if ispc
    handles.ispc.flag = true;
    handles.ispc.slash = '\';
else
    handles.ispc.flag = false;
    handles.ispc.slash = '/';
end

handles.axes1.YTick = [];
handles.axes1.YTickLabelMode = 'manual';
handles.axes1.XTick = [];
handles.axes1.XTickLabelMode = 'manual';
box on
% Update handles structure
handles.prevExportSize = 0;
handles.timesExported = 0;
handles.whereToStartExp = 1;
handles.notoallFlag = 0;
handles.yestoallFlag = 0;

handles.params.system_code = handles.eye_mov_system.Value;
handles.animalENum.String = [handles.animalENum.String; {'Opal'}];

handles.set4_stimNum.String = [handles.set4_stimNum.String; {'16'}; {'17'}; {'18'}];
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
function [handles] = save_segment_Callback(hObject, eventdata, handles, fs)
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
if isempty(handles.save_path_name.String)
    save_path_Callback(hObject, eventdata, handles)
end

Data = handles.Segment(fs);


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

save([handles.save_path_name.String handles.params.segment_filename handles.string_addon '.mat'],'Data')
if segments ~= handles.totalSegment
    segments = segments + 1;
end


% if ~isfield(handles,'skip_excel_fill_flag')
%     
% 
%     set(handles.worksheet_name,'String',[handles.stim_axis.String{handles.stim_axis.Value},'-',handles.visit_number.String{handles.visit_number.Value},'-',handles.date.String,'-',handles.exp_type.String{handles.exp_type.Value}]);
%     handles.experimentdata{segments,1} = [handles.seg_filename.String handles.string_addon];
%     handles.experimentdata{segments,2} = [handles.date.String(5:6),'/',handles.date.String(7:8),'/',handles.date.String(1:4)];
%     handles.experimentdata{segments,3} = handles.subj_id.String{handles.subj_id.Value};
%     handles.experimentdata{segments,4} = handles.implant.String{handles.implant.Value};
%     handles.experimentdata{segments,5} = handles.eye_rec.String{handles.eye_rec.Value};
%     handles.experimentdata{segments,9} = [handles.exp_type.String{handles.exp_type.Value},'-',handles.exp_condition.String{handles.exp_condition.Value},'-',handles.exp_ecomb.String{handles.exp_ecomb.Value}];
%     handles.experimentdata{segments,10} = handles.stim_axis.String{handles.stim_axis.Value};
%     handles.experimentdata{segments,12} = str2double(handles.stim_frequency.String{handles.stim_frequency.Value});
%     handles.experimentdata{segments,13} = [];
%     handles.experimentdata{segments,14} = [];
%     handles.experimentdata{segments,15} = [];
%     handles.experimentdata{segments,16} = [];
%     handles.experimentdata{segments,17} = [];
% 
% end
    handles.segment_number.String = num2str(segments);
    handles.total_seg_num.String = ['Total of ',num2str(handles.totalSegment),' files to process, ',handles.segment_number.String,' files processed'];
    patch(handles.axes1,[0 segments segments 0],[0 0 1 1],'g')
    drawnow
guidata(hObject,handles)


% --- Executes on button press in autoSeg.
function autoSeg_Callback(hObject, eventdata, handles)
% hObject    handle to autoSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if str2num(handles.segment_number.String)>0
    recent = dir(handles.save_path_name.String);
            recent([recent.isdir]) = [];
            if isempty(recent)
                cont = 'No';
            else
    cont = questdlg('Would you like to continue where you left off?',...
        'Start of Segmenting','Yes','No','Yes');
            end
    switch cont
        case 'Yes'
            recent = dir(handles.save_path_name.String);
            recent([recent.isdir]) = [];
            t = datetime({recent.date}','InputFormat','dd-MM-yyyy HH:mm:ss');
            [b,idx] = sortrows(t);
            recent = recent(idx);
            tempPull = load([handles.save_path_name.String recent(end).name]);
            segments = find(ismember({handles.listing.name}',{tempPull.Data.raw_filename}))+1;
            handles.Segment(segments:end) = [];
            s = segments;
            handles.segment_number.String = num2str(segments);
            handles.total_seg_num.String = ['Total of ',num2str(handles.totalSegment),' files to process, ',handles.segment_number.String,' files processed'];
            handles.notoallFlag = 0;
            handles.yestoallFlag = 0;
            handles.repeatNum = 0;
            handles.string_addon = [''];
        case 'No'
            segments = 0;
    end
else
    segments = 0;
    
end

if (segments==0) || isempty(handles.segment_number.String)
    handles.notoallFlag = 0;
    handles.yestoallFlag = 0;
    handles.repeatNum = 0;
    handles.Segment = [];
    handles = eye_mov_system_Callback(hObject, eventdata, handles);
    handles.params.system_code = handles.eye_mov_system.Value;
    if isempty(handles.raw_name.String)
        [handles] = load_raw_Callback(hObject, eventdata, handles);
    end
    if isempty(handles.gain_filename.String)
        [handles] = load_gain_Callback(hObject, eventdata, handles,1);
    else
        [handles] = load_gain_Callback(hObject, eventdata, handles,0);
    end
    
    if isempty(handles.implant.String{handles.implant.Value})
        handles.implant.BackgroundColor = 'y';
        uiwait(handles.figure1)
        handles.implant.BackgroundColor = [0.94 0.94 0.94];
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
    
    if handles.leftEye.Value && handles.rightEye.Value
        handles.EyeCh = {handles.rightEyeCh.String{handles.rightEyeCh.Value}...
            ,handles.leftEyeCh.String{handles.leftEyeCh.Value}};
        handles.eye_rec.Value = 2;
        
    elseif handles.rightEye.Value
        handles.EyeCh = handles.rightEyeCh.String{handles.rightEyeCh.Value};
        handles.eye_rec.Value = 4;
    elseif handles.leftEye.Value
        handles.EyeCh = handles.leftEyeCh.String{handles.leftEyeCh.Value};
        handles.eye_rec.Value = 3;
    end
    handles.string_addon = [];
    
    handles.options.BackgroundColor = 'y';
    uiwait(handles.figure1)
    handles.options.BackgroundColor = [0.94 0.94 0.94];
    
    guidata(hObject,handles)
    
    handles.listing = [];
    % Get list of all coil files and sort chronologically, use number
    % of coil files as iterations for for loop
    handles.listing = dir(handles.raw_name.String);
    handles.listing(~contains({handles.listing.name},{'LP','LH','LA'})) = [];
    handles.listing([handles.listing.bytes]==0) = [];
    [cs,index] = sort_nat({handles.listing.name});
    handles.listing = handles.listing(index);
    handles.listing(contains({handles.listing.name},'.s2rx')) = [];
    [~,lInds] = sortrows({handles.listing.date}');
    handles.listing = handles.listing(lInds);
    dts = [];
    formatIn = 'yyyy_MMdd_HHmmss';
    for iii = 1:length(handles.listing)
        a = datetime(handles.listing(iii).name(1:16),'InputFormat',formatIn);
        b = datetime([handles.listing(iii).name(1:10),'090000'],'InputFormat',formatIn);
        if a<b
            a = a+minutes(720);
        end
        dts = [dts;a];
    end
    if issorted(dts)
        FileOrder = {handles.listing.name}';
        save([handles.raw_PathName,'\FileOrder.mat'],"FileOrder")
    else
        reSort = 1;
    end
    indsForSeg = 1:length(handles.listing);
    handles.totalSegment = length(indsForSeg);
    
    prosthSync = [];
    handles.segment_number.String = '0';
    handles.total_seg_num.String = ['Total of ',num2str(handles.totalSegment),' files to process, ',handles.segment_number.String,' files processed'];
    segments = str2num(handles.segment_number.String);
    
    handles.axes1.XLim = [0 handles.totalSegment];
    patch(handles.axes1,[0 handles.totalSegment handles.totalSegment 0],[0 0 1 1],'w')
    
    s=1;
    handles.prevStimCanal = '';
    handles.dAsgnFlag = 1;
    handles.dAsgn = 0;
    handles.mfilename = mfilename;
    handles.string_addon = [''];
end

if isempty(handles.listing)
    
else
    
    
    for fs = s:length(handles.listing)
        segments = str2num(handles.segment_number.String);
        
        if contains(handles.listing(fs).name,{'LP', 'LA', 'LH', 'RP', 'RA', 'RH','stim'}) && (handles.listing(fs).bytes>0)
            switch handles.params.system_code
                case 1 % Lasker Spike2 Coil Files
                    handles.Segment(fs).directory = [handles.listing(fs).folder,handles.ispc.slash];
                    handles.filename = handles.listing(fs).name;
                    handles.Segment(fs).raw_filename = handles.filename;
                    underS = find(handles.filename=='_');
                    dash = find(handles.filename=='-');
                    handles.delin =[];
                    handles.delin = sort([underS dash],'ascend');
                    dot = find(handles.filename=='.');
                    stimPos = strfind(handles.filename,'stim');
                    refPos = strfind(handles.filename,'ref');
                    ipgPos = strfind(handles.filename,'IPG');
                    p1aPos = strfind(handles.filename,'phase1amp');
                    p2aPos = strfind(handles.filename,'phase2amp');
                    p1dPos = strfind(handles.filename,'phase1Dur');
                    p2dPos = strfind(handles.filename,'phase2Dur');
                    basePos = NaN;
                    fqPos = NaN;
                    deltaPos = NaN;
                    
                    if contains(handles.filename,'sinusoidal')
                        basePos = strfind(handles.filename,'baseline');
                        fqPos = strfind(handles.filename,'freq');
                        deltaPos = strfind(handles.filename,'delta');
                        sinu = 1;
                    else
                        basePos = NaN;
                        fqPos = NaN;
                        deltaPos = NaN;
                        ratePos = strfind(handles.filename,'rate');
                        sinu = 0;
                    end
                    
                    ampPos = strfind(handles.filename,'amp');
                    
                    %handles.Segment(fs).subj = handles.filename(handles.delin(3)+1:handles.delin(4)-1);
                    %if isempty(handles.Segment(fs).subj)
                        handles.Segment(fs).subj = handles.canalInfo.animal;
                    %end
                    
                    if length(handles.delin)<6
                        handles.Segment(fs).stim = str2num(handles.filename(stimPos+4:refPos-1));
                        handles.Segment(fs).refNum = str2num(handles.filename(refPos+3:ampPos-1));
                    
                    else
                        sd = find(handles.delin>stimPos,1);
                        rd = find(handles.delin>refPos,1);
                        handles.Segment(fs).stim = str2num(handles.filename(stimPos+4:handles.delin(sd)-1));
                    handles.Segment(fs).refNum = str2num(handles.filename(refPos+3:handles.delin(rd)-1));
                    
                    end
                    
                    
                    stimnum = {num2str(handles.Segment(fs).stim)};
                    switch stimnum{1}
                        case handles.canalInfo.stimNum{1}
                            handles.stim_axis.String = handles.canalInfo.stimCanal(1);
                        case handles.canalInfo.stimNum{2}
                            handles.stim_axis.String = handles.canalInfo.stimCanal(2);
                        case handles.canalInfo.stimNum{3}
                            handles.stim_axis.String = handles.canalInfo.stimCanal(3);
                    end
                    
                    if sinu
                        handles.Segment(fs).stim_axis = handles.stim_axis.String{1};
                        P1D = handles.delin(find(handles.delin>p1dPos,1));
                        P2D = handles.delin(find(handles.delin>p2dPos,1));
                        IPGD = handles.delin(find(handles.delin>ipgPos,1));
                        P1A = handles.delin(find(handles.delin>p1aPos,1));
                        P2A = handles.delin(find(handles.delin>p2aPos,1));
                        BD = handles.delin(find(handles.delin>basePos,1));
                        FQD = handles.delin(find(handles.delin>fqPos,1));
                        delD = handles.delin(find(handles.delin>deltaPos,1));
                        
                        br = handles.filename(basePos:BD-1);
                        b = str2num(handles.filename(basePos+8:BD-1));
                        d = str2num(handles.filename(deltaPos+5:delD-1));
                        ppsMin = b-d;
                        ppsMax = b+d;
                        spar = ['Sinusoidal',num2str(ppsMin),'to',num2str(ppsMax)];
                        handles.Segment(fs).rate = [br,spar];
                        handles.stim_frequency.String = {[br,spar]};
                        
                        handles.Segment(fs).p1d = str2num(handles.filename(p1dPos+9:P1D-1));
                        handles.Segment(fs).p2d = str2num(handles.filename(p2dPos+9:P2D-1));
                        handles.Segment(fs).ipg = str2num(handles.filename(ipgPos+3:IPGD-1));
                        handles.Segment(fs).p1amp = str2num(handles.filename(p1aPos+9:P1A-1));
                        handles.Segment(fs).p2amp = str2num(handles.filename(p2aPos+9:P2A-1));
                        
                        dS = 0;
                        handles.exp_def.String = {['']};
                        handles.Segment(fs).exp_defS = [''];
                        handles.dAsgnFlag = 1;
                        
                        if isempty(segments==0) || (segments==0)
                        temp = handles.filename;
                        temp(handles.delin(1)) = [];
                        handles.subj_id.String = {handles.Segment(fs).subj};
                        handles.visit_number.String = {'NA'};
                        handles.date.String = temp(1:handles.delin(2)-2);
                        
                        end
                        handles.Segment(fs).date = handles.date.String;
                        handles.AvC.String = {''};
                    else
                    
                    
                    handles.Segment(fs).stim_axis = handles.stim_axis.String{1};
                    if length(handles.delin)<6
                       phPos = strfind(handles.filename,'phaseDur');
                       handles.Segment(fs).rate = str2num(handles.filename(ratePos+4:phPos-1));
                    else
                       handles.Segment(fs).rate = str2num(handles.filename(ratePos+4:handles.delin(12)-1));
                    end
                    
                    if isempty(handles.Segment(fs).rate)
                        prompt = {'Enter the stimulation rate (pps):'};
                        t1 = 'Input';
                        dims = [1 35];
                        definput = {'200'};
                        answer = inputdlg(prompt,t1,dims,definput);
                    else
                        answer = {num2str(handles.Segment(fs).rate)};
                    end
                    handles.stim_frequency.String = {[answer{1},'pps']};
                    
                    if any(strfind(handles.filename,'phaseDur'))
                        p1dPos = strfind(handles.filename,'phaseDur');
                        handles.Segment(fs).p1d = str2num(handles.filename(p1dPos+8:ipgPos-1));
                        if 13>length(handles.delin)
                            handles.Segment(fs).ipg = str2num(handles.filename(ipgPos+3:handles.delin(end)-1));
                        else
                        handles.Segment(fs).ipg = str2num(handles.filename(ipgPos+3:handles.delin(13)-1));
                        end
                        handles.Segment(fs).p2d = handles.Segment(fs).p1d;
                        amp = strfind(handles.filename,'amp');
                        nextD = find(handles.delin>amp,1);
                        if handles.delin(nextD)-amp(1)>6
                            handles.Segment(fs).p1amp = str2num(handles.filename(amp(1)+3:ratePos-1));
                        else
                        handles.Segment(fs).p1amp = str2num(handles.filename(amp(1)+3:handles.delin(nextD)-1));
                        end
                        handles.Segment(fs).p2amp = handles.Segment(fs).p1amp;
                    elseif any(strfind(handles.filename,'phase1Dur'))
                        p1dPos = strfind(handles.filename,'phase1Dur');
                        handles.Segment(fs).p1d = str2num(handles.filename(p1dPos+9:handles.delin(9)-1));
                        p2dPos = strfind(handles.filename,'phase2Dur');
                        handles.Segment(fs).p2d = str2num(handles.filename(p2dPos+9:handles.delin(11)-1));
                        handles.Segment(fs).ipg = str2num(handles.filename(ipgPos+3:handles.delin(13)-1));
                        p1aPos = strfind(handles.filename,'phase1amp');
                        handles.Segment(fs).p1amp = str2num(handles.filename(p1aPos+9:handles.delin(8)-1));
                        p2aPos = strfind(handles.filename,'phase2amp');
                        handles.Segment(fs).p2amp = str2num(handles.filename(p2aPos+9:handles.delin(10)-1));
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
                            handles.delinT = sort([underST dashT],'ascend');
                            p2dPosT = strfind(ftemp,'phase2Dur');
                            p2dT = ftemp(p2dPosT+9:handles.delinT(11)-1);
                        end
                        start = strfind(handles.filename,'defaultStart');
                        handles.exp_def.String = {['-dSp2d',p2dT,handles.filename(start:handles.delin(14)-1)]};
                        handles.Segment(fs).exp_defS = ['-dSp2d',p2dT,handles.filename(start:handles.delin(14)-1)];
                        if handles.dAsgnFlag
                            handles.dAsgn = handles.dAsgn +1;
                            handles.dAsgnFlag = 0;
                        end
                    else
                        dS = 0;
                        handles.exp_def.String = {['']};
                        handles.Segment(fs).exp_defS = [''];
                        handles.dAsgnFlag = 1;
                    end
                    
                    if isempty(segments==0) || (segments==0)
                        temp = handles.filename;
                        temp(handles.delin(1)) = [];
                        handles.subj_id.String = {handles.Segment(fs).subj};
                        handles.visit_number.String = {'NA'};
                        handles.date.String = temp(1:handles.delin(2)-2);
                        
                    end
                    handles.Segment(fs).date = handles.date.String;
                    
                    if contains(handles.listing(fs).name,{'AnodicFirst'})
                        handles.AvC.String = {'-AnodicFirst'};
                        handles.Segment(fs).AvC = 1;
                    elseif contains(handles.listing(fs).name,{'CathodicFirst'})
                        handles.AvC.String = {'-CathodicFirst'};
                        handles.Segment(fs).AvC = 0;
                    elseif ~isempty(handles.AvC.String)
                        handles.AvC.String = {''};
                    end
                    end
                    
                    handles = LaskerSpike2Seg(hObject, eventdata,handles,fs);
                %%%%
                case 2
                    handles.Segment(fs).directory = [handles.listing(fs).folder,handles.ispc.slash];
                    handles.filename = handles.listing(fs).name;
                    handles.Segment(fs).raw_filename = handles.filename;
                    underS = find(handles.filename=='_');
                    dash = find(handles.filename=='-');
                    handles.delin =[];
                    handles.delin = sort([underS dash],'ascend');
                    dot = find(handles.filename=='.');
                    stimPos = strfind(handles.filename,'stim');
                    refPos = strfind(handles.filename,'ref');
                    ampPos = strfind(handles.filename,'amp');
                    
                    handles.Segment(fs).subj = handles.filename(handles.delin(2)+1:handles.delin(3)-1);
                    if isempty(handles.Segment(fs).subj)
                        handles.Segment(fs).subj = handles.canalInfo.animal;
                    end
                    
                    
                    
                    handles.Segment(fs).stim = str2num(handles.filename(stimPos+4:refPos-1));
                    handles.Segment(fs).refNum = str2num(handles.filename(refPos+3:ampPos-1));
                    
                    stimnum = {num2str(handles.Segment(fs).stim)};
                    switch stimnum{1}
                        case handles.canalInfo.stimNum{1}
                            handles.stim_axis.String = handles.canalInfo.stimCanal(1);
                        case handles.canalInfo.stimNum{2}
                            handles.stim_axis.String = handles.canalInfo.stimCanal(2);
                        case handles.canalInfo.stimNum{3}
                            handles.stim_axis.String = handles.canalInfo.stimCanal(3);
                    end
                    
                    handles.Segment(fs).stim_axis = handles.stim_axis.String{1};
                    handles.Segment(fs).rate = 200;
                    if isempty(handles.Segment(fs).rate)
                        prompt = {'Enter the stimulation rate (pps):'};
                        t1 = 'Input';
                        dims = [1 35];
                        definput = {'200'};
                        answer = inputdlg(prompt,t1,dims,definput);
                    else
                        answer = {num2str(handles.Segment(fs).rate)};
                    end
                    handles.stim_frequency.String = {[answer{1},'pps']};
                    
                        
                        handles.Segment(fs).p1d = 200;
                        handles.Segment(fs).p2d = 200;
                        handles.Segment(fs).ipg = 0;
                        handles.Segment(fs).p1amp = str2num(handles.filename(ampPos+3:handles.delin(4)-1));
                        handles.Segment(fs).p2amp = str2num(handles.filename(ampPos+3:handles.delin(4)-1));
                    
                    
                        dS = 0;
                        handles.exp_def.String = {['']};
                        handles.Segment(fs).exp_defS = [''];
                        handles.dAsgnFlag = 1;

                    
                    if isempty(segments==0) || (segments==0)
                        handles.subj_id.String = {handles.Segment(fs).subj};
                        handles.visit_number.String = {'NA'};
                        handles.date.String = handles.filename(1:handles.delin(1)-1);
                        
                    end
                    handles.Segment(fs).date = handles.date.String;
                    
                    if contains(handles.listing(fs).name,{'AnodicFirst'})
                        handles.AvC.String = {'-AnodicFirst'};
                        handles.Segment(fs).AvC = 1;
                    elseif contains(handles.listing(fs).name,{'CathodicFirst'})
                        handles.AvC.String = {'-CathodicFirst'};
                        handles.Segment(fs).AvC = 0;
                    elseif ~isempty(handles.AvC.String)
                        handles.AvC.String = {''};
                    end
                    handles = Moog710Coil2Seg(hObject, eventdata,handles,fs);
            end
            
            
            handles.Segment(fs).EyesRecorded = handles.eye_rec.String{handles.eye_rec.Value};
            handles.Segment(fs).implant = handles.implant.String{handles.implant.Value};
            handles.Segment(fs).dS = dS;
            handles.Segment(fs).dAsgn = handles.dAsgn;
            handles.Segment(fs).segment_code_version = mfilename;
            
            
            
            segments = str2num(handles.segment_number.String);
            if (segments == 0) && isempty(handles.save_path_name.String)
                handles.save_path_name.String = [handles.Segment(fs).directory,'Segments',handles.ispc.slash];
                handles.save_path_name.BackgroundColor = 'y';
                uiwait(handles.figure1)
                handles.save_path_name.BackgroundColor = 'w';
                drawnow
                
                if ~any(exist([handles.Segment(fs).directory,'Segments',handles.ispc.slash], 'dir'))
                    mkdir([handles.Segment(fs).directory,'Segments',handles.ispc.slash])
                end
                cd(handles.save_path_name.String)
            end
            
            
            if length(find(ismember({handles.Segment.seg_filename}',{handles.seg_filename.String})))>1
                if handles.yestoallFlag
                else
                    if handles.notoallFlag
                        answer = 'No';
                    else
                        answer = nbuttondlg([{handles.seg_filename.String};{'This file name already exsits, would you like to overwrite it?'}],{'Yes','No','Yes To All','No To All'},'DefaultButton',2,'PromptTextHeight',50);
                    end
                    switch answer
                        case 'Yes'
                        case 'No'
                            tot = length(find(~cellfun('isempty',strfind({handles.Segment.seg_filename}',handles.seg_filename.String))));
                            handles.seg_filename.String = [handles.seg_filename.String, '_', num2str(tot)];
                            handles.Segment(segments).seg_filename = handles.seg_filename.String;
                        case 'Yes To All'
                            handles.string_addon = [''];
                            handles.yestoallFlag = 1;
                            
                        case 'No To All'
                            tot = length(find(~cellfun('isempty',strfind({handles.Segment.seg_filename}',handles.seg_filename.String))));
                            handles.seg_filename.String = [handles.seg_filename.String, '_', num2str(tot)];
                            handles.Segment(segments).seg_filename = handles.seg_filename.String;
                            handles.notoallFlag = 1;
                    end
                end
            else
                
            end
            [handles]=save_segment_Callback(hObject, eventdata, handles, fs);
            
            
            if str2num(handles.segment_number.String)== handles.totalSegment
                if handles.timesExported ==0
                    if ~isempty(handles.exp_spread_sheet_name.String) && ~strcmp([handles.subj_id.String{handles.subj_id.Value} '_ExperimentRecords.mat'],handles.exp_spread_sheet_name.String)
                        handles.exportCond = 2;
                        guidata(hObject,handles)
                        handles = export_data_Callback(hObject, eventdata, handles);
                    else
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
            handles.axes1.XLim = [0 handles.totalSegment];
            handles.total_seg_num.String = ['Total of ',num2str(handles.totalSegment),' files to process, ',handles.segment_number.String,' files processed'];
        end
    end
end

% --- Executes on button press in load_spread_sheet.
function load_spread_sheet_Callback(hObject, eventdata, handles)
% hObject    handle to load_spread_sheet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in export_data.
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
expLRef = size(handles.Segment);

if handles.export_canal.Value
    itTimes = 3;
directions = {'LARP','RALP','LHRH'};
else

    
end
if isfield(handles,'ss_PathName')
    if ~isempty(handles.ss_PathName)
        if ~isempty(handles.exp_spread_sheet_name.String)
            cd(handles.ss_PathName)
            if isfile(handles.exp_spread_sheet_name.String)
                dec = questdlg('Would you like to append the existing experiment spreadsheet?',...
                    'Spreadsheet Saving Option','Yes','No','Yes');
                switch dec
                    case 'Yes'
                        handles.exportCond = 2;
                        handles.export_append.Value = 1;
                    case 'No'
                        handles.exportCond = 3;
                        handles.export_append.Value = 0;
                end
            else
                handles.exportCond = 3;
            end
        else
            handles.exportCond = 3;
        end
    else
        handles.exportCond = 3;
    end
else
    handles.exportCond = 3;
end

for its = 1:itTimes
    if any(strcmp({handles.Segment(1:end).stim_axis},directions{its}))
switch handles.exportCond
    case 0
       
    case {1,2}
        handles.worksheet_name.String = [directions{its},'-',handles.visit_number.String{handles.visit_number.Value},'-',handles.date.String,'-',handles.exp_type.String{handles.exp_type.Value}];
        cd(handles.ss_PathName);
        expRecords = load(handles.exp_spread_sheet_name.String);
        if length(handles.worksheet_name.String)> 31
            handles.worksheet_name.String = handles.worksheet_name.String(1:31);
        end
        temp = handles.worksheet_name.String;
        temp(temp=='-') = '_';
        temp(temp==' ') = '';
         dirInds = strcmp({handles.Segment(1:end).stim_axis},directions{its});
         a = struct();
        a = {handles.Segment(dirInds).seg_filename}';
        a(:,2) = {handles.Segment(dirInds).date}';
        a(:,3) = {handles.Segment(dirInds).subj}';
        a(:,4) = {handles.Segment(dirInds).implant}';
        a(:,5) = {handles.Segment(dirInds).EyesRecorded}';
        a(:,9) = strcat({handles.Segment(dirInds).exp_type}',{'-'},{handles.Segment(dirInds).exp_condition}',{'-'},{handles.Segment(dirInds).ecomb}');
        a(:,10) = {handles.Segment(dirInds).stim_axis}';
        a(:,12) = {handles.Segment(dirInds).rate}';
        a(:,17) = {[]};
        if any(strcmp(fieldnames(expRecords),temp))
            segs = size(a);
            for rs = 1:segs(1)
                if any(strcmp([handles.experimentdata(rs,1)],expRecords.(temp).File_Name))
                    if handles.export_replace.Value
                   replaceInd = [find(strcmp(expRecords.(temp).File_Name,[handles.experimentdata(rs,1)]))];
                   expRecords.(temp)(replaceInd,:)=[handles.experimentdata(rs,:)];
                    elseif handles.export_append.Value
                        expRecords.(temp)(end+1,:) = [a(rs,:)];
                    end
                  
                else
                    expRecords.(temp)(end+1,:) = [a(rs,:)];
                end
            end
        else
            expRecords.(temp) = [];
            segs = size(a);
            labels = {'File_Name' 'Date' 'Subject' 'Implant' 'Eye_Recorded' 'Compression' 'Max_PR_pps' 'Baseline_pps' 'Function' 'Mod_Canal' 'Mapping_Type' 'Frequency_Hz' 'Max_Velocity_dps' 'Phase_degrees' 'Cycles' 'Phase_Direction' 'Notes'};
            expRecords.(temp) = cell2table([a],'VariableNames',labels);
        end
        save(handles.exp_spread_sheet_name.String,'-struct','expRecords');

        writetable(expRecords.(temp),[handles.ss_FileName '.xlsx'],'Sheet',temp,'Range','A:Q','WriteVariableNames',true);
                
        if handles.makeVoma.Value
         Fs = {handles.Segment(dirInds).Fs}';
        Stimulus = {handles.Segment(dirInds).Stim_Trig}';
        Stim_t = {handles.Segment(dirInds).Time_Stim}';
        stim_ind = {handles.Segment(dirInds).Time_Stim}';
        stim_ind(:) = {[]};
        Data_LE_Pos_X = {handles.Segment(dirInds).LE_Position_X}';
        Data_LE_Pos_Y = {handles.Segment(dirInds).LE_Position_Y}';
        Data_LE_Pos_Z = {handles.Segment(dirInds).LE_Position_Z}';
        Data_RE_Pos_X = {handles.Segment(dirInds).RE_Position_X}';
        Data_RE_Pos_Y = {handles.Segment(dirInds).RE_Position_Y}';
        Data_RE_Pos_Z = {handles.Segment(dirInds).RE_Position_Z}';
        Data_LE_Vel_X = {handles.Segment(dirInds).LE_Velocity_X}';
        Data_LE_Vel_Y = {handles.Segment(dirInds).LE_Velocity_Y}';
        Data_LE_Vel_LARP = {handles.Segment(dirInds).LE_Velocity_LARP}';
        Data_LE_Vel_RALP = {handles.Segment(dirInds).LE_Velocity_RALP}';
        Data_LE_Vel_Z = {handles.Segment(dirInds).LE_Velocity_Z}';
        Data_RE_Vel_X = {handles.Segment(dirInds).RE_Velocity_X}';
        Data_RE_Vel_Y = {handles.Segment(dirInds).RE_Velocity_Y}';
        Data_RE_Vel_LARP = {handles.Segment(dirInds).RE_Velocity_LARP}';
        Data_RE_Vel_RALP = {handles.Segment(dirInds).RE_Velocity_RALP}';
        Data_RE_Vel_Z = {handles.Segment(dirInds).RE_Velocity_Z}';
        Eye_t = {handles.Segment(dirInds).Time_Eye}';
        Filenames = strcat({handles.Segment(dirInds).seg_filename},{'.mat'})';
        Parameters = struct();
        Parameters.Stim_Info.Stim_Type = a(:,9);
            Parameters.Stim_Info.ModCanal = a(:,10);
            Parameters.Stim_Info.Freq = a(:,12);
            Parameters.Stim_Info.Max_Vel = a(:,13);
            Parameters.Stim_Info.Cycles = a(:,15);
            Parameters.Stim_Info.Notes = a(:,17);
            Parameters.Mapping.Type = a(:,11);
            Parameters.Mapping.Compression = a(:,6);
            Parameters.Mapping.Max_PR = a(:,7);
            Parameters.Mapping.Baseline = a(:,8);
            Parameters.SoftwareVer.SegSoftware = a(:,9);
            Parameters.SoftwareVer.SegSoftware(:) = {handles.Segment(dirInds).segment_code_version}';
            Parameters.SoftwareVer.QPRconvGUI = a(:,9);
            Parameters.SoftwareVer.QPRconvGUI(:) = {'voma__qpr_data_convert'};
            Parameters.DAQ = a(:,9);
            Parameters.DAQ(:) = handles.eye_mov_system.String(handles.eye_mov_system.Value);
            Parameters.Stim_Info.Seg_Directory = a(:,9);
            Parameters.Stim_Info.Seg_Directory(:) = {handles.save_path_name.String};
                   
            Parameters.DAQ_code = a(:,9);
            Parameters.DAQ_code(:) = {handles.Segment(dirInds).DAQ_code}';
                            
        Raw_Filenames = {handles.Segment(dirInds).raw_filename}';
        [Data_QPR] = coil_seg__qpr_data_convert(Fs,Stimulus,Stim_t,stim_ind,Data_LE_Pos_X,Data_LE_Pos_Y,Data_LE_Pos_Z,Data_RE_Pos_X,Data_RE_Pos_Y,Data_RE_Pos_Z,Data_LE_Vel_X,Data_LE_Vel_Y,Data_LE_Vel_LARP,Data_LE_Vel_RALP,Data_LE_Vel_Z,Data_RE_Vel_X,Data_RE_Vel_Y,Data_RE_Vel_LARP,Data_RE_Vel_RALP,Data_RE_Vel_Z,Eye_t,Filenames,Parameters,Raw_Filenames);
        cd(handles.params.output_data_path)
        useName = find(dirInds);
        defaultName = {[handles.Segment(useName(1)).date '-' handles.Segment(useName(1)).subj '-' handles.Segment(useName(1)).stim_axis '-' handles.Segment(useName(1)).exp_type]};  
            str = inputdlg('Please enter the name of the output file (WITHOUT any suffix)','Output File', [1 50],defaultName);
            save([str{1} '.voma'],'Data_QPR')
        end
        
        handles.whereToStartExp = expLRef(1)+1;
        handles.timesExported = handles.timesExported+1;
        handles.exportedInds = find(dirInds);
        guidata(hObject,handles)
    case 3
        handles.ss_FileName = [handles.subj_id.String{handles.subj_id.Value} '_ExperimentRecords'];
        set(handles.exp_spread_sheet_name,'String',[handles.ss_FileName '.mat']);
        handles.worksheet_name.String = [directions{its},'-',handles.visit_number.String{handles.visit_number.Value},'-',handles.date.String,'-',handles.exp_type.String{handles.exp_type.Value}];
        prompt = {'Enter the desired file name without extensions'};
        title = 'File Name';
        dims = [1 35];
        definput = {[handles.Segment(1).date '-' handles.subj_id.String{handles.subj_id.Value} '_ExperimentRecords']};
        handles.ss_FileName = inputdlg(prompt,title,dims,definput);
        handles.ss_FileName = handles.ss_FileName{1};
        handles.exp_spread_sheet_name.String = handles.ss_FileName;
        handles.ss_PathName = uigetdir(cd,'Choose directory where experiment spreadsheet file will be saved');
        handles.exp_ss_savepath.String = handles.ss_PathName;
        set(handles.exp_spread_sheet_name,'String',[handles.ss_FileName '.mat']);
        cd(handles.ss_PathName);
        labels = {'File_Name' 'Date' 'Subject' 'Implant' 'Eye_Recorded' 'Compression' 'Max_PR_pps' 'Baseline_pps' 'Function' 'Mod_Canal' 'Mapping_Type' 'Frequency_Hz' 'Max_Velocity_dps' 'Phase_degrees' 'Cycles' 'Phase_Direction' 'Notes'};
        if length(handles.worksheet_name.String)> 31
            handles.worksheet_name.String = handles.worksheet_name.String(1:31);
        end
        
        dirInds = strcmp({handles.Segment(1:end).stim_axis},directions{its});
        a = struct();
        a = {handles.Segment(dirInds).seg_filename}';
        a(:,2) = {handles.Segment(dirInds).date}';
        a(:,3) = {handles.Segment(dirInds).subj}';
        a(:,4) = {handles.Segment(dirInds).implant}';
        a(:,5) = {handles.Segment(dirInds).EyesRecorded}';
        a(:,9) = strcat({handles.Segment(dirInds).exp_type}',{'-'},{handles.Segment(dirInds).exp_condition}',{'-'},{handles.Segment(dirInds).ecomb}');
        a(:,10) = {handles.Segment(dirInds).stim_axis}';
        a(:,12) = {handles.Segment(dirInds).rate}';
        a(:,17) = {[]};
        %     handles.experimentdata{segments,1} = [handles.seg_filename.String handles.string_addon];
%     handles.experimentdata{segments,2} = [handles.date.String(5:6),'/',handles.date.String(7:8),'/',handles.date.String(1:4)];
%     handles.experimentdata{segments,3} = handles.subj_id.String{handles.subj_id.Value};
%     handles.experimentdata{segments,4} = handles.implant.String{handles.implant.Value};
%     handles.experimentdata{segments,5} = handles.eye_rec.String{handles.eye_rec.Value};
%     handles.experimentdata{segments,9} = [handles.exp_type.String{handles.exp_type.Value},'-',handles.exp_condition.String{handles.exp_condition.Value},'-',handles.exp_ecomb.String{handles.exp_ecomb.Value}];
%     handles.experimentdata{segments,10} = handles.stim_axis.String{handles.stim_axis.Value};
%     handles.experimentdata{segments,12} = str2double(handles.stim_frequency.String{handles.stim_frequency.Value});
%     handles.experimentdata{segments,13} = [];
%     handles.experimentdata{segments,14} = [];
%     handles.experimentdata{segments,15} = [];
%     handles.experimentdata{segments,16} = [];
%     handles.experimentdata{segments,17} = [];
        temp = handles.worksheet_name.String;
        temp(temp=='-') = '_';
        temp(temp==' ') = '';
        var = genvarname(temp);
        t = cell2table([a],'VariableNames',labels);
        s = struct(var,t);
        save(handles.exp_spread_sheet_name.String,'-struct','s');
        writetable(t,[handles.ss_FileName '.xlsx'],'Sheet',temp,'Range','A:Q','WriteVariableNames',true)
        
        if handles.makeVoma.Value
        Fs = {handles.Segment(dirInds).Fs}';
        Stimulus = {handles.Segment(dirInds).Stim_Trig}';
        Stim_t = {handles.Segment(dirInds).Time_Stim}';
        stim_ind = {handles.Segment(dirInds).Time_Stim}';
        stim_ind(:) = {[]};
        Data_LE_Pos_X = {handles.Segment(dirInds).LE_Position_X}';
        Data_LE_Pos_Y = {handles.Segment(dirInds).LE_Position_Y}';
        Data_LE_Pos_Z = {handles.Segment(dirInds).LE_Position_Z}';
        Data_RE_Pos_X = {handles.Segment(dirInds).RE_Position_X}';
        Data_RE_Pos_Y = {handles.Segment(dirInds).RE_Position_Y}';
        Data_RE_Pos_Z = {handles.Segment(dirInds).RE_Position_Z}';
        Data_LE_Vel_X = {handles.Segment(dirInds).LE_Velocity_X}';
        Data_LE_Vel_Y = {handles.Segment(dirInds).LE_Velocity_Y}';
        Data_LE_Vel_LARP = {handles.Segment(dirInds).LE_Velocity_LARP}';
        Data_LE_Vel_RALP = {handles.Segment(dirInds).LE_Velocity_RALP}';
        Data_LE_Vel_Z = {handles.Segment(dirInds).LE_Velocity_Z}';
        Data_RE_Vel_X = {handles.Segment(dirInds).RE_Velocity_X}';
        Data_RE_Vel_Y = {handles.Segment(dirInds).RE_Velocity_Y}';
        Data_RE_Vel_LARP = {handles.Segment(dirInds).RE_Velocity_LARP}';
        Data_RE_Vel_RALP = {handles.Segment(dirInds).RE_Velocity_RALP}';
        Data_RE_Vel_Z = {handles.Segment(dirInds).RE_Velocity_Z}';
        Eye_t = {handles.Segment(dirInds).Time_Eye}';
        Filenames = strcat({handles.Segment(dirInds).seg_filename},{'.mat'})';
        Parameters = struct();
        Parameters.Stim_Info.Stim_Type = a(:,9);
            Parameters.Stim_Info.ModCanal = a(:,10);
            Parameters.Stim_Info.Freq = a(:,12);
            Parameters.Stim_Info.Max_Vel = a(:,13);
            Parameters.Stim_Info.Cycles = a(:,15);
            Parameters.Stim_Info.Notes = a(:,17);
            Parameters.Mapping.Type = a(:,11);
            Parameters.Mapping.Compression = a(:,6);
            Parameters.Mapping.Max_PR = a(:,7);
            Parameters.Mapping.Baseline = a(:,8);
            Parameters.SoftwareVer.SegSoftware = a(:,9);
            Parameters.SoftwareVer.SegSoftware(:) = {handles.Segment(dirInds).segment_code_version}';
            Parameters.SoftwareVer.QPRconvGUI = a(:,9);
            Parameters.SoftwareVer.QPRconvGUI(:) = {'voma__qpr_data_convert'};
            Parameters.DAQ = a(:,9);
            Parameters.DAQ(:) = handles.eye_mov_system.String(handles.eye_mov_system.Value);
            Parameters.Stim_Info.Seg_Directory = a(:,9);
            Parameters.Stim_Info.Seg_Directory(:) = {handles.save_path_name.String};
                   
            Parameters.DAQ_code = a(:,9);
            Parameters.DAQ_code(:) = {handles.Segment(dirInds).DAQ_code}';
                            
        Raw_Filenames = {handles.Segment(dirInds).raw_filename}';
        [Data_QPR] = coil_seg__qpr_data_convert(Fs,Stimulus,Stim_t,stim_ind,Data_LE_Pos_X,Data_LE_Pos_Y,Data_LE_Pos_Z,Data_RE_Pos_X,Data_RE_Pos_Y,Data_RE_Pos_Z,Data_LE_Vel_X,Data_LE_Vel_Y,Data_LE_Vel_LARP,Data_LE_Vel_RALP,Data_LE_Vel_Z,Data_RE_Vel_X,Data_RE_Vel_Y,Data_RE_Vel_LARP,Data_RE_Vel_RALP,Data_RE_Vel_Z,Eye_t,Filenames,Parameters,Raw_Filenames);
        handles.params.output_data_path = uigetdir(cd,'Choose directory where VOMA files will be saved');
        cd(handles.params.output_data_path)
        useName = find(dirInds);
        defaultName = {[handles.Segment(useName(1)).date '-' handles.Segment(useName(1)).subj '-' handles.Segment(useName(1)).stim_axis '-' handles.Segment(useName(1)).exp_type]};  
            str = inputdlg('Please enter the name of the output file (WITHOUT any suffix)','Output File', [1 50],defaultName);
            save([str{1} '.voma'],'Data_QPR')
        end
        handles.whereToStartExp = expLRef(1)+1;
        handles.timesExported = handles.timesExported+1;
        handles.exportedInds = find(dirInds);
        handles.exportCond = 2;
        guidata(hObject,handles)
        
end
    end
handles.prevExportSize = expLRef(1);
end
        handles.export_data.BackgroundColor = [0    1    0];
        pause(1);
        handles.export_data.BackgroundColor = [0.9400    0.9400    0.9400];
%     setappdata(handles.export_data,'data','')
%     handles.experimentdata = [];







% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in load_raw.
function handles = load_raw_Callback(hObject, eventdata, handles)
% hObject    handle to load_raw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.PathNameofFiles = uigetdir(cd,'Please choose the folder where the coil files are saved');
cd( handles.PathNameofFiles)
handles.raw_PathName = handles.PathNameofFiles;
handles.raw_name.String = handles.raw_PathName;
handles.prevExportSize = 0;
handles.timesExported = 0;
handles.exportedInds = [];
handles.whereToStartExp = 1;
guidata(hObject,handles)
eye_mov_system_Callback(handles.load_raw, [], handles);
guidata(hObject,handles)

% --- Executes on selection change in eye_mov_system.
function handles = eye_mov_system_Callback(hObject, eventdata, handles)
% hObject    handle to eye_mov_system (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns eye_mov_system contents as cell array
%        contents{get(hObject,'Value')} returns selected item from eye_mov_system
index_selected = get(handles.eye_mov_system,'Value');

handles.params.system_code = index_selected;

switch handles.params.system_code
    % Maybe I should switch this to a series of 'if' statements, since I
    % will be shutting off every option box when the system code changes...
    
    case 1 % Lasker Spike2 Coil Files
        set(handles.LaskerSystPanel,'Visible','On')

    case 2 % Ross 710 Moog Coil System
        set(handles.LaskerSystPanel,'Visible','Off');

end
handles.prevExportSize = 0;
handles.timesExported = 0;
handles.exportedInds = [];
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
function handles = load_gain_Callback(hObject, eventdata, handles, skipAsk)
% hObject    handle to load_gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~exist('skipAsk')
[FieldGainFile,FieldGainPath,FieldGainFilterIndex] = uigetfile('*.*','Please choose the field gains for this experiment');
handles.raw_FieldGainPath = FieldGainPath;
handles.raw_FieldGainFile = FieldGainFile;
handles.gain_filename.String = [FieldGainPath , FieldGainFile];
else
    ds = find(handles.gain_filename.String=='\',1,'last');
    handles.raw_FieldGainPath = handles.gain_filename.String(1:ds);
    handles.raw_FieldGainFile = handles.gain_filename.String(ds+1:end);
    FieldGainPath = handles.raw_FieldGainPath;
end
if ~isempty(handles.exp_spread_sheet_name.String)
    if ~isfile([FieldGainPath,'\',handles.exp_spread_sheet_name.String])
        handles.exp_spread_sheet_name.String = '';
    end
end

switch handles.params.system_code
    case 1
        % Import the Field Gain file, collected using the vordaq/showall
        % software
        handles.fieldgainname = [handles.raw_FieldGainPath handles.raw_FieldGainFile];
        delimiter = '\t';
        formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
        
        fileID = fopen(handles.fieldgainname,'r');
        
        dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN, 'ReturnOnError', false);
        
        fclose(fileID);
        
        handles.FieldGains = [dataArray{1:end-1}];
        
        % During my daily calibration procedure, I zero-out the fields to
        % have no offsets with a test coil.
        handles.coilzeros = [0 0 0 0 0 0 0 0 0 0 0 0];
    case 2
        [handles.GAINSR, handles.GAINSL]=getGains(handles.raw_FieldGainPath,handles.raw_FieldGainFile);
        handles = get_Offsets_Callback(hObject, eventdata, handles);
end
guidata(hObject,handles)

% --- Executes on button press in load_gain.
function handles = get_Offsets_Callback(hObject, eventdata, handles)
% hObject    handle to load_gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch handles.params.system_code
    case 1

    case 2
         [handles.offsetFile1,handles.offsetPath1,offsetFilterIndex1] = uigetfile('*.*','Please choose the FIRST offset file this experiment');
         [handles.offsetFile2,handles.offsetPath2,offsetFilterIndex2] = uigetfile('*.*','Please choose the SECOND offset file this experiment');
         handles.offsets.String = {[handles.offsetPath1,'\',handles.offsetFile1];[handles.offsetPath2,'\',handles.offsetFile2]};
         [handles.ZEROS_R, handles.ZEROS_L]=calcOffsets(handles.offsetPath1,handles.offsetFile1,handles.offsetFile2,1);
end
guidata(hObject,handles)



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
    case 3 %Nancy Left Ear
        handles.set1_stimNum.Value = [4 5 6 14];
        handles.set2_stimNum.Value = [1 2 3];
        handles.set3_stimNum.Value = [7 8 9 15];
         handles.set4_stimNum.Value = [11 12 13];
          handles.set5_stimNum.Value = [10];
    case 4 %Yoda Right Ear
        handles.set1_stimNum.Value = [1 2 3];
        handles.set2_stimNum.Value = [4 5 6 14];
        handles.set3_stimNum.Value = [7 8 9 15];
         handles.set4_stimNum.Value = [11 12 13];
          handles.set5_stimNum.Value = [10];
    case 5 %Opal Left Ear
        handles.set1_stimNum.Value = [7 8 9 15];
        handles.set2_stimNum.Value = [1 2 3];
        handles.set3_stimNum.Value = [4 5 6 14];
         handles.set4_stimNum.Value = [11 12 13 16 17 18];
          handles.set5_stimNum.Value = [10];
end
guidata(hObject,handles)




% --- Executes on button press in confirmParams.
function confirmParams_Callback(hObject, eventdata, handles)
% hObject    handle to confirmParams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1)
guidata(hObject, handles);

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


% --- Executes on button press in save_path.
function save_path_Callback(hObject, eventdata, handles)
% hObject    handle to save_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.save_path_name.String = uigetdir('','Select directory to Save the Segmented Data');
handles.save_path_name.String = [handles.save_path_name.String handles.ispc.slash];
cd(handles.save_path_name.String)
guidata(hObject,handles)

function rightEyeCh_Callback(hObject, eventdata, handles)
if hObject.Value == 2
    handles.leftEyeCh.Value = 1;
else
    handles.leftEyeCh.Value = 2;
end
guidata(hObject,handles)

function leftEyeCh_Callback(hObject, eventdata, handles)
if hObject.Value == 2
    handles.rightEyeCh.Value = 1;
else
    handles.rightEyeCh.Value = 2;
end
guidata(hObject,handles)