function h = selectBounds(Data)
h = struct();
h.Data = Data;
h.clicks = 0;
h.Data.t = 0:1/h.Data.Fs:(length(h.Data.Var_x081)-1)/h.Data.Fs;
h.Data.boundsBegin = [];
h.Data.boundsEnd = [];
h.f = figure;
h.f.WindowButtonDownFcn = @mouseDownCallback;
plot(h.Data.t,h.Data.RE_Vel_LARP,'g')
hold on
plot(h.Data.t,h.Data.RE_Vel_RALP,'b')
plot(h.Data.t,h.Data.RE_Vel_Z,'r')
hold off
guidata(h.f,h)
uiwait(h.f)
h = guidata(h.f);
close(h.f)
end

function mouseDownCallback(figHandle,varargin)
% get the handles structure
h = guidata(figHandle);
% get the position where the mouse button was pressed (not released)
% within the GUI
h.ax = h.f.Children;
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