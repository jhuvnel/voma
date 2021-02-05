function a = post_CycleAvg_QPR_filt(sub,r)
% hObject    handle to post_qpr_filt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a = struct();
a.sub = sub;
a.r = r;


a = start_deseccade(a);


% Update the 'filter parameter spreadsheet'
filt_params = a.r.QPparams.filt_params;

if ~isstr(a.r.QPparams.filt_params{8,10})
a.Filtered.Data_LE_Vel_LARP=voma__smooth([1:length(a.Filtered.Data_LE_Vel_LARP)]',a.Filtered.Data_LE_Vel_LARP,a.r.QPparams.filt_params{8,10},[1:length(a.Filtered.Data_LE_Vel_LARP)]');
a.Filtered.Data_LE_Vel_RALP=voma__smooth([1:length(a.Filtered.Data_LE_Vel_RALP)]',a.Filtered.Data_LE_Vel_RALP,a.r.QPparams.filt_params{8,10},[1:length(a.Filtered.Data_LE_Vel_RALP)]');
a.Filtered.Data_LE_Vel_Z=voma__smooth([1:length(a.Filtered.Data_LE_Vel_Z)]',a.Filtered.Data_LE_Vel_Z,a.r.QPparams.filt_params{8,10},[1:length(a.Filtered.Data_LE_Vel_Z)]');
a.Filtered.Data_LE_Vel_X=voma__smooth([1:length(a.Filtered.Data_LE_Vel_X)]',a.Filtered.Data_LE_Vel_X,a.r.QPparams.filt_params{8,10},[1:length(a.Filtered.Data_LE_Vel_X)]');
a.Filtered.Data_LE_Vel_Y=voma__smooth([1:length(a.Filtered.Data_LE_Vel_Y)]',a.Filtered.Data_LE_Vel_Y,a.r.QPparams.filt_params{8,10},[1:length(a.Filtered.Data_LE_Vel_Y)]');

a.Filtered.Data_RE_Vel_LARP=voma__smooth([1:length(a.Filtered.Data_RE_Vel_LARP)]',a.Filtered.Data_RE_Vel_LARP,a.r.QPparams.filt_params{8,10},[1:length(a.Filtered.Data_RE_Vel_LARP)]');
a.Filtered.Data_RE_Vel_RALP=voma__smooth([1:length(a.Filtered.Data_RE_Vel_RALP)]',a.Filtered.Data_RE_Vel_RALP,a.r.QPparams.filt_params{8,10},[1:length(a.Filtered.Data_RE_Vel_RALP)]');
a.Filtered.Data_RE_Vel_Z=voma__smooth([1:length(a.Filtered.Data_RE_Vel_Z)]',a.Filtered.Data_RE_Vel_Z,a.r.QPparams.filt_params{8,10},[1:length(a.Filtered.Data_RE_Vel_Z)]');
a.Filtered.Data_RE_Vel_X=voma__smooth([1:length(a.Filtered.Data_RE_Vel_X)]',a.Filtered.Data_RE_Vel_X,a.r.QPparams.filt_params{8,10},[1:length(a.Filtered.Data_RE_Vel_X)]');
a.Filtered.Data_RE_Vel_Y=voma__smooth([1:length(a.Filtered.Data_RE_Vel_Y)]',a.Filtered.Data_RE_Vel_Y,a.r.QPparams.filt_params{8,10},[1:length(a.Filtered.Data_RE_Vel_Y)]');
end
a = sb(a);
lOData = [];
rOData = [];
zOData = [];
for i = 1:length(a.boundsBegin)
    lOData = [lOData; a.Filtered.Data_RE_Vel_LARP(a.boundsBegin(i):a.boundsEnd(i))];
    rOData = [rOData; a.Filtered.Data_RE_Vel_RALP(a.boundsBegin(i):a.boundsEnd(i))];
    zOData = [zOData; a.Filtered.Data_RE_Vel_Z(a.boundsBegin(i):a.boundsEnd(i))];
end
lO = mean(lOData);
rO = mean(rOData);
zO = mean(zOData);
f = figure;
subplot(2,1,1)
szl=size(a.r.rl_cyc);
plot(reshape(a.r.rl_cyc,[1,szl(1)*szl(2)]),'g')
hold on
szr=size(a.r.rr_cyc);
plot(reshape(a.r.rr_cyc,[1,szr(1)*szr(2)]),'b')
szz=size(a.r.rz_cyc); 
plot(reshape(a.r.rz_cyc,[1,szz(1)*szz(2)]),'r')
hold off
subplot(2,1,2)
szl=size(a.r.rl_cyc);
plot(reshape(a.r.rl_cyc,[1,szl(1)*szl(2)])-lO,'g')
hold on
szr=size(a.r.rr_cyc);
plot(reshape(a.r.rr_cyc,[1,szr(1)*szr(2)])-rO,'b')
szz=size(a.r.rz_cyc); 
plot(reshape(a.r.rz_cyc,[1,szz(1)*szz(2)])-zO,'r')
hold off
uiwait
a.lO = lO;
a.rO = rO;
a.zO = zO;
end

function Data = sb(Data)
h = struct();
h.Data = Data;
h.clicks = 0;
h.Data.t = h.Data.sub.Data.Time_Eye;
h.Data.boundsBegin = [];
h.Data.boundsEnd = [];
h.f = figure;
h.f.WindowButtonDownFcn = @mouseDownCallback;
h.ax = axes(h.f);
txa = uicontrol('style','text',...
    'string',{'Click left mouse button to indicate start and end of boundaries';'Right mouse click on boundary line to remove';'Once finished with making boundaries, click the scroll whell'},...
    'backgroundcolor','w');
txa.Position = [20 20 250 40];
plot(h.ax,h.Data.t,h.Data.Filtered.Data_RE_Vel_LARP,'g')
hold on
plot(h.ax,h.Data.t,h.Data.Filtered.Data_RE_Vel_RALP,'b')
plot(h.ax,h.Data.t,h.Data.Filtered.Data_RE_Vel_Z,'r')
hold off
guidata(h.f,h)
uiwait(h.f)
h = guidata(h.f);
Data = h.Data;
close(h.f)
end

function mouseDownCallback(figHandle,varargin)
% get the handles structure
h = guidata(figHandle);
% get the position where the mouse button was pressed (not released)
% within the GUI
h.f.Units = 'Normalized';
h.ax.Units = 'Normalized';
if contains(figHandle.SelectionType,'normal')
    currentPoint = get(figHandle, 'CurrentPoint');
    x1            = currentPoint(1,1);
    y            = currentPoint(1,2);
    % get the position of the axes within the GUI
    axesPos = get(h.ax,'Position');
    minx    = axesPos(1);
    miny    = axesPos(2);
    maxx    = minx + axesPos(3);
    maxy    = miny + axesPos(4);
    % is the mouse down event within the axes?
    if x1>=minx && x1<=maxx && y>=miny && y<=maxy
        h.clicks = h.clicks +1;
        % do we have graphics objects?
            % get the position of the mouse down event within the axes
            currentPoint = get(h.ax, 'CurrentPoint');
            x1            = currentPoint(2,1);
            y            = currentPoint(2,2);
            % we are going to use the x and y data for each graphic object
            % and determine which one is closest to the mouse down event
            if rem(h.clicks,2)
                [a,b]=min(abs(h.Data.t-x1));
                h.Data.boundsBegin = [h.Data.boundsBegin b];
                h.Data.boundsBegin = sort(h.Data.boundsBegin,'ascend');
                hold(h.ax,'on')
                plot([x1 x1],h.ax.YLim,'g','LineWidth',3)
                hold(h.ax,'off')
            else
                [a,b]=min(abs(h.Data.t-x1));
                h.Data.boundsEnd = [h.Data.boundsEnd b];
                h.Data.boundsEnd = sort(h.Data.boundsEnd,'ascend');
                hold(h.ax,'on')
                plot([x1 x1],h.ax.YLim,'r','LineWidth',3)
                hold(h.ax,'off')
            end
                guidata(figHandle,h)
    end

elseif contains(figHandle.SelectionType,'alt')
    currentPoint = get(figHandle, 'CurrentPoint');
    x1            = currentPoint(1,1);
    y            = currentPoint(1,2);
    % get the position of the axes within the GUI
    axesPos = get(h.ax,'Position');
    minx    = axesPos(1);
    miny    = axesPos(2);
    maxx    = minx + axesPos(3);
    maxy    = miny + axesPos(4);
    % is the mouse down event within the axes?
    if x1>=minx && x1<=maxx && y>=miny && y<=maxy
        % do we have graphics objects?
            % get the position of the mouse down event within the axes
            currentPoint = get(h.ax, 'CurrentPoint');
            x1            = currentPoint(2,1);
            y            = currentPoint(2,2);
            % we are going to use the x and y data for each graphic object
            % and determine which one is closest to the mouse down event
            minDist      = Inf;
            minHndl      = 0;
            minHndlInd = 0;
            for k1=1:length(h.ax.Children)-4
                xData = get(h.ax.Children(k1),'XData');
                yData = get(h.ax.Children(k1),'YData');
                dist  = min((xData-x1).^2+(yData-y).^2);
                if dist<minDist
                    minHndl = h.ax.Children(k1);
                    minHndlInd = k1;
                    minDist = dist;
                end
            end
            % if we have a graphics handle that is close to the mouse down
            % event/position, then save the data
            if minHndl~=0
                if any(h.Data.boundsBegin==minHndl.XData(1))
                    id = find(h.Data.boundsBegin==minHndl.XData(1));
                    h.Data.boundsBegin(id) = [];
                    delete(minHndl)
                else
                    id = find(h.Data.boundsEnd==minHndl.XData(1));
                    h.Data.boundsEnd(id) = [];
                    delete(minHndl)
                end

            end
            guidata(figHandle,h)
    end
elseif contains(figHandle.SelectionType,'extend')
    guidata(figHandle,h)
    uiresume(h.f)
end
end

function b = start_deseccade(b)
% hObject    handle to start_deseccade (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% % Do quick phase removal for each trace
% desaccade1 = LARP
% desaccade2 = RALP
% desaccade3 = LHRH
%


    ThresholdQPRflag = false;



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

switch b.r.QPparams.qpr_routine
    case 1
        
        switch b.r.QPparams.filt_params{8,9}
            
            case 1 % Detect splining options from the file being processed
                switch b.r.Parameters.Stim_Info.ModCanal{1}
                    
                    
                    
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
                handles = struct();
                handles.CurrData.VOMA_data.Eye_t = b.sub.Data.Time_Eye;
                handles.CurrData.VOMA_data.Fs = b.sub.Data.Fs;
                handles.params.e_vel_param3 = b.r.QPparams.filt_params{8,5};
                handles.params.e_vel_param5 = b.r.QPparams.filt_params{8,7};
                handles.params.e_vel_param2 = b.r.QPparams.filt_params{8,4};
                handles.params.e_vel_param1 = b.r.QPparams.filt_params{8,3};
                handles.params.e_vel_param4 = b.r.QPparams.filt_params{8,6};
                    desaccade1 = voma__desaccadedata(b.sub.Data.LE_Velocity_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                    desaccade2 = voma__desaccadedata(b.sub.Data.LE_Velocity_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                    desaccade3 = voma__desaccadedata(b.sub.Data.LE_Velocity_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                    desaccade4 = voma__desaccadedata(b.sub.Data.LE_Velocity_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                    desaccade5 = voma__desaccadedata(b.sub.Data.LE_Velocity_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                    desaccade6 = voma__desaccadedata(b.sub.Data.RE_Velocity_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                    desaccade7 = voma__desaccadedata(b.sub.Data.RE_Velocity_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                    desaccade8 = voma__desaccadedata(b.sub.Data.RE_Velocity_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                    desaccade9 = voma__desaccadedata(b.sub.Data.RE_Velocity_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                    desaccade10 = voma__desaccadedata(b.sub.Data.RE_Velocity_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);

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
                handles = struct();
                handles.CurrData.VOMA_data.Eye_t = b.sub.Data.Time_Eye;
                handles.CurrData.VOMA_data.Fs = b.sub.Data.Fs;
                handles.params.e_vel_param3 = b.r.QPparams.filt_params{8,5};
                handles.params.e_vel_param5 = b.r.QPparams.filt_params{8,7};
                handles.params.e_vel_param2 = b.r.QPparams.filt_params{8,4};
                handles.params.e_vel_param1 = b.r.QPparams.filt_params{8,3};
                handles.params.e_vel_param4 = b.r.QPparams.filt_params{8,6};

                    desaccade2 = voma__desaccadedata(b.sub.Data.LE_Velocity_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                    desaccade1 = voma__desaccadedata(b.sub.Data.LE_Velocity_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade2.QP_range);
                    desaccade3 = voma__desaccadedata(b.sub.Data.LE_Velocity_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade2.QP_range);
                    desaccade4 = voma__desaccadedata(b.sub.Data.LE_Velocity_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade2.QP_range);
                    desaccade5 = voma__desaccadedata(b.sub.Data.LE_Velocity_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade2.QP_range);
                    desaccade7 = voma__desaccadedata(b.sub.Data.RE_Velocity_RALP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag);
                    desaccade6 = voma__desaccadedata(b.sub.Data.RE_Velocity_LARP,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade7.QP_range);
                    desaccade8 = voma__desaccadedata(b.sub.Data.RE_Velocity_Z,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade7.QP_range);
                    desaccade9 = voma__desaccadedata(b.sub.Data.RE_Velocity_X,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade7.QP_range);
                    desaccade10 = voma__desaccadedata(b.sub.Data.RE_Velocity_Y,handles.CurrData.VOMA_data.Eye_t,handles.CurrData.VOMA_data.Fs,handles.params.e_vel_param3,handles.params.e_vel_param5,handles.params.e_vel_param2,handles.params.e_vel_param1,handles.params.e_vel_param4,1,ThresholdQPRflag,[],desaccade7.QP_range);
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

            b.Filtered.Data_LE_Vel_LARP = desaccade1.results;
            b.Filtered.Data_LE_Vel_RALP = desaccade2.results;
            b.Filtered.Data_LE_Vel_Z = desaccade3.results;
            b.Filtered.Data_LE_Vel_X = desaccade4.results;
            b.Filtered.Data_LE_Vel_Y = desaccade5.results;

            b.Filtered.Data_RE_Vel_LARP = desaccade6.results;
            b.Filtered.Data_RE_Vel_RALP = desaccade7.results;
            b.Filtered.Data_RE_Vel_Z = desaccade8.results;
            b.Filtered.Data_RE_Vel_X = desaccade9.results;
            b.Filtered.Data_RE_Vel_Y = desaccade10.results;

        
%         % Save the 'spline-only' data seperately for plotting purposes.
%         if handles.LE_filt_flag
%             handles.filter_noQPR.LE_Vel_LARP = desaccade1.smooth;
%             handles.filter_noQPR.LE_Vel_RALP = desaccade2.smooth;
%             handles.filter_noQPR.LE_Vel_Z = desaccade3.smooth;
%             handles.filter_noQPR.LE_Vel_X = desaccade4.smooth;
%             handles.filter_noQPR.LE_Vel_Y = desaccade5.smooth;
%         end
%         if handles.RE_filt_flag
%             handles.filter_noQPR.RE_Vel_LARP = desaccade6.smooth;
%             handles.filter_noQPR.RE_Vel_RALP = desaccade7.smooth;
%             handles.filter_noQPR.RE_Vel_Z = desaccade8.smooth;
%             handles.filter_noQPR.RE_Vel_X = desaccade9.smooth;
%             handles.filter_noQPR.RE_Vel_Y = desaccade10.smooth;
%         end
%         if handles.LE_filt_flag
%             handles.vel_deriv.LE_LARP = desaccade1.deriv;
%             handles.vel_deriv.LE_RALP = desaccade2.deriv;
%             handles.vel_deriv.LE_Z = desaccade3.deriv;
%             handles.vel_deriv.LE_X = desaccade4.deriv;
%             handles.vel_deriv.LE_Y = desaccade5.deriv;
%         end
%         if handles.RE_filt_flag
%             handles.vel_deriv.RE_LARP = desaccade6.deriv;
%             handles.vel_deriv.RE_RALP = desaccade7.deriv;
%             handles.vel_deriv.RE_Z = desaccade8.deriv;
%             handles.vel_deriv.RE_X = desaccade9.deriv;
%             handles.vel_deriv.RE_Y = desaccade10.deriv;
%         end
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




