function p = sinShift(t2,s2,majDir)
h = struct();
h.Data.Time_Stim = t2;
h.Data.Velocity = majDir;
h.Data.HeadMPUVel_Z = s2;
h.newRALP2 = smooth(h.Data.Time_Stim,h.Data.Velocity,0.01,'rloess');
[h.a,h.b]=findpeaks(h.newRALP2,h.Data.Time_Stim,'MinPeakHeight',5,'MinPeakDistance',.4);
[h.c,h.d]=findpeaks(h.Data.HeadMPUVel_Z,h.Data.Time_Stim);
h.indsN = find(ismember(h.Data.Time_Stim,h.b));
h.indsT = find(ismember(h.Data.Time_Stim,h.d));
h.f = figure;
h.f.Position =[600   300   910   500];
h.f.WindowButtonDownFcn = @mouseDownCallback;
h.t = uicontrol('Style','edit','String','15','Callback',@tCallback);
h.ant = annotation(h.f,'textbox',[0 .95 .7 .05],'String','Left click to delete blue triangles, Right click to delete raw dataset max triangles, Click scroll wheel to accept and continue, Use the textbox to adjust the threshold');
h.ant.Position = [0    0.900    1    0.100];
h.thresh = 5;
findpeaks(h.Data.HeadMPUVel_Z,h.Data.Time_Stim);
hold(h.f.Children(2),'on')
findpeaks(h.newRALP2,h.Data.Time_Stim,'MinPeakHeight',h.thresh,'MinPeakDistance',.4);
h.f.Children(2).Position = [.13 .05 .775 .77]
hold(h.f.Children(2),'off')
h.sT = text(h.f.Children(2).Children(end-1).XData,h.f.Children(2).Children(end-1).YData+2,cellstr(num2str([1:length(h.f.Children(2).Children(end-1).XData)]')));
h.nT = text(h.f.Children(2).Children(end-3).XData,h.f.Children(2).Children(end-3).YData+2,cellstr(num2str([1:length(h.f.Children(2).Children(end-3).XData)]')));
guidata(h.f,h)
uiwait(h.f)
h = guidata(h.f);
x = h.Data.Time_Stim(h.indsT);
y = h.Data.Time_Stim(h.indsN);
% figure
% plot(x,y,'b*')
p = polyfit(x,y,1);
yfit = p(1)*x+p(2);
% hold on
% plot(x,yfit,'r-.')
% figure
% plot(h.Data.Time_Stim,h.Data.HeadMPUVel_Z)
% hold on
% plot(h.Data.Time_Stim,h.newRALP2)
hold(h.f.Children(2),'on')
plot((h.Data.Time_Stim-p(2))/p(1),h.newRALP2)
hold(h.f.Children(2),'off')
pause(2)
close(h.f)
end
%%
function mouseDownCallback(figHandle,varargin)
% get the handles structure
h = guidata(figHandle);
% get the position where the mouse button was pressed (not released)
% within the GUI
h.ax = h.f.Children(2);
h.ax.Units = 'pixels';
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
                xData = get(h.ax.Children(end-1),'XData');
                yData = get(h.ax.Children(end-1),'YData');
                [dist,ival]  = min(sqrt((xData-x1).^2+(yData-y).^2));
                if dist<1
                    delete(h.sT)
                    h.ax.Children(end-1).XData(ival) = [];
                    h.ax.Children(end-1).YData(ival) = [];
                    h.sT = text(h.f.Children(2).Children(end-1).XData,h.f.Children(2).Children(end-1).YData+2,cellstr(num2str([1:length(h.f.Children(2).Children(end-1).XData)]')));
                    h.indsT = find(ismember(h.Data.Time_Stim,h.ax.Children(end-1).XData));
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
                xData = get(h.ax.Children(end-3),'XData');
                yData = get(h.ax.Children(end-3),'YData');
                [dist,ival]  = min(sqrt((xData-x1).^2+(yData-y).^2));
                if dist<1
                    delete(h.nT)
                    h.ax.Children(end-3).XData(ival) = [];
                    h.ax.Children(end-3).YData(ival) = [];
                    h.nT = text(h.f.Children(2).Children(end-3).XData,h.f.Children(2).Children(end-3).YData+2,cellstr(num2str([1:length(h.f.Children(2).Children(end-3).XData)]')));
                    h.indsN = find(ismember(h.Data.Time_Stim,h.ax.Children(end-3).XData));
                end
                guidata(figHandle,h)
    end
elseif contains(figHandle.SelectionType,'extend')
    guidata(figHandle,h)
    uiresume(h.f)
end
end
%%
function tCallback(figHandle,varargin)
% get the handles structure
h = guidata(figHandle);
h.thresh = str2num(h.t.String);
delete(h.sT)
delete(h.nT)
delete(h.f.Children(2).Children(1));
delete(h.f.Children(2).Children(1));
hold(h.f.Children(2),'on')
findpeaks(h.newRALP2,h.Data.Time_Stim,'MinPeakHeight',h.thresh,'MinPeakDistance',.4);
hold(h.f.Children(2),'off')
h.sT = text(h.f.Children(2).Children(3).XData,h.f.Children(2).Children(3).YData+2,cellstr(num2str([1:length(h.f.Children(2).Children(3).XData)]')));
h.nT = text(h.f.Children(2).Children(end-3).XData,h.f.Children(2).Children(end-3).YData+2,cellstr(num2str([1:length(h.f.Children(2).Children(end-3).XData)]')));
[h.a,h.b]=findpeaks(h.newRALP2,h.Data.Time_Stim,'MinPeakHeight',h.thresh,'MinPeakDistance',.4);
guidata(h.f,h)
end
