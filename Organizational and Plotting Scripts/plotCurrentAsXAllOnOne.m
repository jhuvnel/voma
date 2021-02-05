function handles = plotCurrentAsXAllOnOne(handles,i,j,k,l)
ePosFig = getePos(handles,handles.figE(j));
ePosAx = getePos(handles,handles.axE(k));
if k==1
    if l == 1
        handles.avgMisalignPlot3D(i,j).normalize = figure('units','normalized','outerposition',[0 0 1 1],'Visible','off');
        sgtitle(handles.avgMisalignPlot3D(i,j).normalize,{['3D Angle of Misalignment, ',handles.axName,ePosFig,', ',handles.figdir]; ' '},'FontSize', 22, 'FontWeight', 'Bold');
        
        if handles.LEyeFlag.Value + handles.REyeFlag.Value == 2
            handles.fig(i,j).avgMisalign3D.R = subtightplot(1,2,1,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot3D(i,j).normalize);
            handles.fig(i,j).avgMisalign3D.L = subtightplot(1,2,2,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot3D(i,j).normalize);
            handles.fig(i,j).avgMisalign3D.R.XGrid = 'on';
            handles.fig(i,j).avgMisalign3D.R.YGrid = 'on';
            handles.fig(i,j).avgMisalign3D.L.XGrid = 'on';
            handles.fig(i,j).avgMisalign3D.L.YGrid = 'on';
            handles.fig(i,j).avgMisalign3D.L.Title.String = 'Left Eye 3D Misalignment';
            handles.fig(i,j).avgMisalign3D.L.FontSize = 13.5;
            handles.fig(i,j).avgMisalign3D.R.Title.String = 'Right Eye 3D Misalignment';
            handles.fig(i,j).avgMisalign3D.R.FontSize = 13.5;
            
        elseif handles.LEyeFlag.Value
            
            handles.fig(i,j).avgMisalign3D.L = axes('Parent', handles.avgMisalignPlot3D(i,j).normalize);
            handles.fig(i,j).avgMisalign3D.L.XGrid = 'on';
            handles.fig(i,j).avgMisalign3D.L.YGrid = 'on';
            handles.fig(i,j).avgMisalign3D.L.Title.String = 'Left Eye 3D Misalignment, Phase 2 Duration';
            handles.fig(i,j).avgMisalign3D.L.FontSize = 13.5;
        elseif handles.REyeFlag.Value
            
            handles.fig(i,j).avgMisalign3D.R = axes('Parent', handles.avgMisalignPlot3D(i,j).normalize);
            handles.fig(i,j).avgMisalign3D.R.XGrid = 'on';
            handles.fig(i,j).avgMisalign3D.R.YGrid = 'on';
            handles.fig(i,j).avgMisalign3D.R.Title.String = 'Right Eye 3D Misalignment';
            handles.fig(i,j).avgMisalign3D.R.FontSize = 13.5;
        end
        
        if handles.LEyeFlag.Value
            set(0,'CurrentFigure',handles.avgMisalignPlot3D(i,j).normalize);
            set( handles.avgMisalignPlot3D(i,j).normalize,'CurrentAxes',handles.fig(i,j).avgMisalign3D.L)
            hold(handles.fig(i,j).avgMisalign3D.L,'on');
            h=plot3vect([1/sqrt(2);-1/sqrt(2);0],'LARP Axis',[0 1 0],2);
            set(h,'LineStyle','--','Marker','o');
            h=plot3vect([1/sqrt(2);1/sqrt(2);0],'RALP Axis',[0 1 1],2);
            set(h,'LineStyle','--','Marker','o');
            h=plot3vect([0;0;1],'Yaw Axis',[0.68 0 0],2);
            set(h,'LineStyle','--','Marker','o');
            
            [x,y,z]=sphere();
            h=surf(0.5*x,0.5*y,0.5*z);
            set(h,'FaceColor','white')
            handles.fig(i,j).avgMisalign3D.L.View = [90 -0.5];
            axis vis3d
            axis equal
            box on;
            xlim([-1 1])
            ylim([-1 1])
            zlim([-1 1])
            hold(handles.fig(i,j).avgMisalign3D.L,'off');
            
            
        end
        
        if handles.REyeFlag.Value
            set( handles.avgMisalignPlot3D(i,j).normalize,'CurrentAxes',handles.fig(i,j).avgMisalign3D.R)
            hold(handles.fig(i,j).avgMisalign3D.R,'on');
            h=plot3vect([1/sqrt(2);-1/sqrt(2);0],'LARP Axis',[0 1 0],2);
            set(h,'LineStyle','--','Marker','o');
            h=plot3vect([1/sqrt(2);1/sqrt(2);0],'RALP Axis',[0 1 1],2);
            set(h,'LineStyle','--','Marker','o');
            h=plot3vect([0;0;1],'Yaw Axis',[0.68 0 0],2);
            set(h,'LineStyle','--','Marker','o');
            
            [x,y,z]=sphere();
            h=surf(0.5*x,0.5*y,0.5*z);
            set(h,'FaceColor','white')
            handles.fig(i,j).avgMisalign3D.R.View = [90 -0.5];
            axis vis3d
            axis equal
            box on;
            xlim([-1 1])
            ylim([-1 1])
            zlim([-1 1])
            hold(handles.fig(i,j).avgMisalign3D.R,'off');
            
        end
        handles.ldg3D.lines = {};
        handles.ldg3D.Defaultlines = {};
        handles.ldg3D.AP = {};
    end
end
if (k == 1) && (j == 1)
    handles.avgMagPlot(i).normalized(l) = figure('units','normalized','outerposition',[0 0 1 1],'Visible','off');
    handles.avgMisalignPlot(i).normalized(l) = figure('units','normalized','outerposition',[0 0 1 1],'Visible','off');
    sgtitle(handles.avgMagPlot(i).normalized(l),{['Average Eye Velocity Magnitude, ',handles.figdir] ; ' '},'FontSize', 22, 'FontWeight', 'Bold');
    sgtitle(handles.avgMisalignPlot(i).normalized(l),{['Angle of Misalignment, ',handles.figdir]; ' '},'FontSize', 22, 'FontWeight', 'Bold');
    handles.ldgNames = {};
    handles.lines = zeros(1,length(handles.axE));
    handles.plottedInds =[];
    handles.allInds = [];
end
if handles.LEyeFlag.Value + handles.REyeFlag.Value == 2
    if k == 1
        handles.fig(i).normalized(l).avgMagaxL(j) = subtightplot(2,length(handles.figE),j,[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMagPlot(i).normalized(l));
        handles.fig(i).normalized(l).avgMagaxR(j) = subtightplot(2,length(handles.figE),j+length(handles.figE),[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMagPlot(i).normalized(l));
        
        handles.fig(i).normalized(l).avgMisalignaxL(j) = subtightplot(2,length(handles.figE),j,[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot(i).normalized(l));
        handles.fig(i).normalized(l).avgMisalignaxR(j) = subtightplot(2,length(handles.figE),j+length(handles.figE),[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot(i).normalized(l));
        
        handles.fig(i).normalized(l).avgMagaxL(j).XTickLabel = [];
        handles.fig(i).normalized(l).avgMagaxR(j).XTick = [0:50:handles.allP1a(end)];
        handles.fig(i).normalized(l).avgMisalignaxL(j).XTickLabel = [];
        handles.fig(i).normalized(l).avgMisalignaxR(j).XTick = [0:50:handles.allP1a(end)];
        handles.fig(i).normalized(l).avgMagaxL(j).XGrid = 'on';
        handles.fig(i).normalized(l).avgMagaxR(j).XGrid = 'on';
        handles.fig(i).normalized(l).avgMagaxL(j).YGrid = 'on';
        handles.fig(i).normalized(l).avgMagaxR(j).YGrid = 'on';
        handles.fig(i).normalized(l).avgMisalignaxL(j).XGrid = 'on';
        handles.fig(i).normalized(l).avgMisalignaxR(j).XGrid = 'on';
        handles.fig(i).normalized(l).avgMisalignaxL(j).YGrid = 'on';
        handles.fig(i).normalized(l).avgMisalignaxR(j).YGrid = 'on';
        handles.fig(i).normalized(l).avgMagaxR(j).XLim = [0 handles.allP1a(end)+50];
        handles.fig(i).normalized(l).avgMagaxL(j).XLim = [0 handles.allP1a(end)+50];
        handles.fig(i).normalized(l).avgMisalignaxR(j).XLim = [0 handles.allP1a(end)+50];
        handles.fig(i).normalized(l).avgMisalignaxL(j).XLim = [0 handles.allP1a(end)+50];
        handles.fig(i).normalized(l).avgMagaxR(j).XTick = [0:50:handles.allP1a(end)];
        handles.fig(i).normalized(l).avgMisalignaxR(j).XTick = [0:50:handles.allP1a(end)];
    else
        handles.fig(i).normalized(l).avgMisalignaxR(j).YTickLabel = [];
        handles.fig(i).normalized(l).avgMagaxR(j).YTickLabel = [];
        handles.fig(i).normalized(l).avgMisalignaxL(j).YTickLabel = [];
        handles.fig(i).normalized(l).avgMagaxL(j).YTickLabel = [];
        
    end
elseif handles.LEyeFlag.Value
    if k == 1
        handles.fig(i).normalized(l).avgMagaxL(j) = subtightplot(1,length(handles.figE),j,[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMagPlot(i).normalized(l));
        handles.fig(i).normalized(l).avgMisalignaxL(j) = subtightplot(1,length(handles.figE),j,[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot(i).normalized(l));
        handles.fig(i).normalized(l).avgMagaxL(j).XTick = [0:50:handles.allP1a(end)];
        handles.fig(i).normalized(l).avgMisalignaxL(j).XTick = [0:50:handles.allP1a(end)];
        handles.fig(i).normalized(l).avgMagaxL(j).XGrid = 'on';
        handles.fig(i).normalized(l).avgMagaxL(j).YGrid = 'on';
        handles.fig(i).normalized(l).avgMisalignaxL(j).XGrid = 'on';
        handles.fig(i).normalized(l).avgMisalignaxL(j).YGrid = 'on';
        handles.fig(i).normalized(l).avgMagaxL(j).XLim = [0 handles.allP1a(end)+50];
        handles.fig(i).normalized(l).avgMisalignaxL(j).XLim = [0 handles.allP1a(end)+50];
        handles.fig(i).normalized(l).avgMagaxL(j).XTick = [0:50:handles.allP1a(end)];
        handles.fig(i).normalized(l).avgMisalignaxL(j).XTick = [0:50:handles.allP1a(end)];
    elseif j>1
        handles.fig(i).normalized(l).avgMisalignaxL(j).YTickLabel = [];
        handles.fig(i).normalized(l).avgMagaxL(j).YTickLabel = [];
        
    end
elseif handles.REyeFlag.Value
    if k == 1
        handles.fig(i).normalized(l).avgMagaxR(j) = subtightplot(1,length(handles.figE),j,[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMagPlot(i).normalized(l));
        handles.fig(i).normalized(l).avgMisalignaxR(j) = subtightplot(1,length(handles.figE),j,[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot(i).normalized(l));
        handles.fig(i).normalized(l).avgMagaxR(j).XTick = [0:50:handles.allP1a(end)];
        handles.fig(i).normalized(l).avgMisalignaxR(j).XTick = [0:50:handles.allP1a(end)];
        handles.fig(i).normalized(l).avgMagaxR(j).XGrid = 'on';
        handles.fig(i).normalized(l).avgMagaxR(j).YGrid = 'on';
        handles.fig(i).normalized(l).avgMisalignaxR(j).XGrid = 'on';
        handles.fig(i).normalized(l).avgMisalignaxR(j).YGrid = 'on';
        handles.fig(i).normalized(l).avgMagaxR(j).XLim = [0 handles.allP1a(end)+50];
        handles.fig(i).normalized(l).avgMisalignaxR(j).XLim = [0 handles.allP1a(end)+50];
        handles.fig(i).normalized(l).avgMagaxR(j).XTick = [0:50:handles.allP1a(end)];
        handles.fig(i).normalized(l).avgMisalignaxR(j).XTick = [0:50:handles.allP1a(end)];
    elseif j>1
        handles.fig(i).normalized(l).avgMisalignaxR(j).YTickLabel = [];
        handles.fig(i).normalized(l).avgMagaxR(j).YTickLabel = [];
        
    end
end


switch handles.axE(k)
    case 1
        colorPlot = [65 82 31]/255;
    case 2
        colorPlot = [72 169 60]/255;
    case 3
        colorPlot = [40 82 56]/255;
    case 4
        colorPlot = [13 0 164]/255;
    case 5
        colorPlot = [18 53 91]/255;
    case 6
        colorPlot = [3 157 201]/255;
    case 7
        colorPlot = [215 38 56]/255;
    case 8
        colorPlot = [158 43 37]/255;
    case 9
        colorPlot = [219 108 35]/255;
    case 10
        colorPlot = [57 61 63]/255;
    case 11
        colorPlot = [246 189 96]/255;
    case 12
        colorPlot = [115 98 138]/255;
    case 13
        colorPlot = [135 142 136]/255;
    case 14
        colorPlot = [51 92 103]/255;
    case 15
        colorPlot = [107 15 26]/255;
end
if isempty(handles.ldg3D.lines)
    handles.ldg3D.lines = {[handles.ldgName,ePosAx]};
elseif any([strcmp(handles.ldg3D.lines,[handles.ldgName,ePosAx])])
else
    handles.ldg3D.lines = [handles.ldg3D.lines,{[handles.ldgName,ePosAx]}];
end
% notOneInds = [];
% if handles.axE(k) == 1
%     toplotInds = oneInds;
% else
%     toplotInds = find(([handles.params.stim]==handles.figE(j)) & ([handles.params.ref]==handles.axE(k)) & ([handles.params.dSp2d]<0));
%     toplotdS = find(([handles.params.stim]==handles.figE(j)) & ([handles.params.ref]==handles.axE(k)) & ([handles.params.dSp2d]>0));
% end
if handles.stimulatingE.Value
    toplotInds = find(([handles.params.stim]==handles.figE(j)) & ([handles.params.ref]==handles.axE(k)) & ([handles.params.dSp2d]<0));
elseif handles.referenceE.Value
    toplotInds = find(([handles.params.stim]==handles.axE(k)) & ([handles.params.ref]==handles.figE(j)) & ([handles.params.dSp2d]<0));
end
for m = 1:length(toplotInds)
    filename = handles.listing(toplotInds(m)).name;
    
    if handles.LEyeFlag.Value
        
        set(0,'CurrentFigure',handles.avgMisalignPlot3D(i,j).normalize);
        set( handles.avgMisalignPlot3D(i,j).normalize,'CurrentAxes',handles.fig(i,j).avgMisalign3D.L);
        hold(handles.fig(i,j).avgMisalign3D.L,'on');
        if handles.norm.Value
            if m == 1
                mis3DPlotD = handles.params(handles.params(toplotInds(m)).normInd(l)).plotM3DL;
                switch handles.params(handles.params(toplotInds(m)).normInd(l)).p1amp
                    case 20
                        markerToUse = 'o';
                    case 25
                        markerToUse = 'v';
                    case 50
                        markerToUse = '+';
                    case 75
                        markerToUse = '*';
                    case 100
                        markerToUse = '^';
                    case 125
                        markerToUse = 's';
                    case 150
                        markerToUse = 'd';
                    case 175
                        markerToUse = '>';
                    case 200
                        markerToUse = '<';
                    case 250
                        markerToUse = 'p';
                    case 300
                        markerToUse = 'h';
                end
                handles.fig(i,j).mis3D(m,k).lPlotLD(l) = plot3([0 mis3DPlotD(1)]',[0 mis3DPlotD(2)]',[0 mis3DPlotD(3)]');
                set(handles.fig(i,j).mis3D(m,k).lPlotLD(l),'LineWidth',3.5,'DisplayName','','Color','k')
                handles.fig(i,j).mis3D(m,k).pPlotLD(l) = plot3(mis3DPlotD(1),mis3DPlotD(2),mis3DPlotD(3),'o');
                set(handles.fig(i,j).mis3D(m,k).pPlotLD(l),'LineWidth',3.5,'DisplayName','','Marker',DmarkerToUse,'MarkerSize',15,'MarkerEdgeColor',colorPlot)
                if ~isempty(handles.ldg3D.Defaultlines)
                    if any([contains(handles.ldg3D.Defaultlines,num2str(handles.params(handles.params(toplotInds(m)).normInd(l)).p1amp))])
                    else
                        handles.ldg3D.Defaultlines = [handles.ldg3D.Defaultlines,{['Default Stimulation, ',num2str(handles.params(handles.params(toplotInds(m)).normInd(l)).p1amp),'p1amp']}];
                        handles.fig(i,j).mis3D(m,k).lPlotFakeLD(l) = plot3([0 .01]',[0 .01]',[0 .01]');
                        set(handles.fig(i,j).mis3D(m,k).lPlotFakeLD(l),'LineWidth',3.5,'DisplayName','','Color','k','Marker',DmarkerToUse,'MarkerSize',15,'MarkerEdgeColor','k')
                        
                    end
                else
                    handles.ldg3D.Defaultlines = [handles.ldg3D.Defaultlines,{['Default Stimulation, ',num2str(handles.params(handles.params(toplotInds(m)).normInd(l)).p1amp),'p1amp']}];
                    handles.fig(i,j).mis3D(m,k).lPlotFakeLD(l) = plot3([0 .01]',[0 .01]',[0 .01]');
                    set(handles.fig(i,j).mis3D(m,k).lPlotFakeLD(l),'LineWidth',3.5,'DisplayName','','Color','k','Marker',DmarkerToUse,'MarkerSize',15,'MarkerEdgeColor','k')
                end
            end
            
        end
        
        if l == 1
            mis3DPlot = handles.params(toplotInds(m)).plotM3DL;
            handles.fig(i,j).mis3D(m,k).lPlotL = plot3([0 mis3DPlot(1)]',[0 mis3DPlot(2)]',[0 mis3DPlot(3)]');
            set(handles.fig(i,j).mis3D(m,k).lPlotL,'LineWidth',2,'DisplayName','','Color',colorPlot)
            switch handles.params(toplotInds(m)).p1amp
                case 20
                    markerToUse = 'o';
                case 25
                    markerToUse = 'v';
                case 50
                    markerToUse = '+';
                case 75
                    markerToUse = '*';
                case 100
                    markerToUse = '^';
                case 125
                    markerToUse = 's';
                case 150
                    markerToUse = 'd';
                case 175
                    markerToUse = '>';
                case 200
                    markerToUse = '<';
                case 250
                    markerToUse = 'p';
                case 300
                    markerToUse = 'h';
            end
            if m==1
                handles.fig(i,j).mis3D(m,k).lPlotFakeL = plot3([0 .01]',[0 .01]',[0 .01]');
                set(handles.fig(i,j).mis3D(m,k).lPlotFakeL,'LineWidth',2,'DisplayName','','Color',colorPlot)
            end
            if isempty(handles.ldg3D.AP)
                handles.ldg3D.AP = {[num2str(handles.params(toplotInds(m)).p1amp),' uA']};
                handles.fig(i,j).mis3D(m,k).pPlotFakeL = plot3(0,0,0,'Marker',markerToUse,'MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2,'Linestyle', 'none');
            elseif any(strcmp(handles.ldg3D.AP,[num2str(handles.params(toplotInds(m)).p1amp),' uA']))
            else
                handles.ldg3D.AP = [handles.ldg3D.AP,{[num2str(handles.params(toplotInds(m)).p1amp),' uA']}];
                handles.fig(i,j).mis3D(m,k).pPlotFakeL = plot3(0,0,0,'Marker',markerToUse,'MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2,'Linestyle', 'none');
            end
            
            handles.fig(i,j).mis3D(m,k).pPlotL = plot3(mis3DPlot(1),mis3DPlot(2),mis3DPlot(3),'o');
            set(handles.fig(i,j).mis3D(m,k).pPlotL,'LineWidth',2,'DisplayName','','Marker',markerToUse,'MarkerSize',10,'MarkerEdgeColor',colorPlot)
            
            if any(handles.params(toplotInds(m)).FacialNerve)
                handles.twitchPlotL = plot3(mis3DPlot(1),mis3DPlot(2),mis3DPlot(3),'rx','MarkerSize', 20,'LineWidth',3,'Linestyle', 'none');
            end
        end
        hold(handles.fig(i,j).avgMisalign3D.L,'off');
        
        
    end
    
    if handles.REyeFlag.Value
        
        set(0,'CurrentFigure',handles.avgMisalignPlot3D(i,j).normalize);
        set( handles.avgMisalignPlot3D(i,j).normalize,'CurrentAxes',handles.fig(i,j).avgMisalign3D.R);
        hold(handles.fig(i,j).avgMisalign3D.R,'on');
        if handles.norm.Value
            if m == 1
                mis3DPlotD = handles.params(handles.params(toplotInds(m)).normInd(l)).plotM3DR;
                switch handles.params(handles.params(toplotInds(m)).normInd(l)).p1amp
                    case 20
                        markerToUse = 'o';
                    case 25
                        markerToUse = 'v';
                    case 50
                        markerToUse = '+';
                    case 75
                        markerToUse = '*';
                    case 100
                        markerToUse = '^';
                    case 125
                        markerToUse = 's';
                    case 150
                        markerToUse = 'd';
                    case 175
                        markerToUse = '>';
                    case 200
                        markerToUse = '<';
                    case 250
                        markerToUse = 'p';
                    case 300
                        markerToUse = 'h';
                end
                handles.fig(i,j).mis3D(m,k).lPlotRD(l) = plot3([0 mis3DPlotD(1)]',[0 mis3DPlotD(2)]',[0 mis3DPlotD(3)]');
                set(handles.fig(i,j).mis3D(m,k).lPlotRD(l),'LineWidth',3.5,'DisplayName','','Color','k')
                handles.fig(i,j).mis3D(m,k).pPlotRD(l) = plot3(mis3DPlotD(1),mis3DPlotD(2),mis3DPlotD(3),'o');
                set(handles.fig(i,j).mis3D(m,k).pPlotRD(l),'LineWidth',3.5,'DisplayName','','Marker',DmarkerToUse,'MarkerSize',15,'MarkerEdgeColor',colorPlot)
                if ~isempty(handles.ldg3D.Defaultlines)
                    if any([contains(handles.ldg3D.Defaultlines,num2str(handles.params(handles.params(toplotInds(m)).normInd(l)).p1amp))])
                    else
                        handles.ldg3D.Defaultlines = [handles.ldg3D.Defaultlines,{['Default Stimulation, ',num2str(handles.params(handles.params(toplotInds(m)).normInd(l)).p1amp),'p1amp']}];
                        handles.fig(i,j).mis3D(m,k).lPlotFakeRD(l) = plot3([0 .01]',[0 .01]',[0 .01]');
                        set(handles.fig(i,j).mis3D(m,k).lPlotFakeRD(l),'LineWidth',3.5,'DisplayName','','Color','k','Marker',DmarkerToUse,'MarkerSize',15,'MarkerEdgeColor','k')
                        
                    end
                else
                    handles.ldg3D.Defaultlines = [handles.ldg3D.Defaultlines,{['Default Stimulation, ',num2str(handles.params(handles.params(toplotInds(m)).normInd(l)).p1amp),'p1amp']}];
                    handles.fig(i,j).mis3D(m,k).lPlotFakeRD(l) = plot3([0 .01]',[0 .01]',[0 .01]');
                    set(handles.fig(i,j).mis3D(m,k).lPlotFakeRD(l),'LineWidth',3.5,'DisplayName','','Color','k','Marker',DmarkerToUse,'MarkerSize',15,'MarkerEdgeColor','k')
                end
            end
            
        end
        
        if l == 1
            mis3DPlot = handles.params(toplotInds(m)).plotM3DR;
            handles.fig(i,j).mis3D(m,k).lPlotR = plot3([0 mis3DPlot(1)]',[0 mis3DPlot(2)]',[0 mis3DPlot(3)]');
            set(handles.fig(i,j).mis3D(m,k).lPlotR,'LineWidth',2,'DisplayName','','Color',colorPlot)
            switch handles.params(toplotInds(m)).p1amp
                case 20
                    markerToUse = 'o';
                case 25
                    markerToUse = 'v';
                case 50
                    markerToUse = '+';
                case 75
                    markerToUse = '*';
                case 100
                    markerToUse = '^';
                case 125
                    markerToUse = 's';
                case 150
                    markerToUse = 'd';
                case 175
                    markerToUse = '>';
                case 200
                    markerToUse = '<';
                case 250
                    markerToUse = 'p';
                case 300
                    markerToUse = 'h';
            end
            if m==1
                handles.fig(i,j).mis3D(m,k).lPlotFakeR = plot3([0 .01]',[0 .01]',[0 .01]');
                set(handles.fig(i,j).mis3D(m,k).lPlotFakeR,'LineWidth',2,'DisplayName','','Color',colorPlot)
            end
            if isempty(handles.ldg3D.AP)
                handles.ldg3D.AP = {[num2str(handles.params(toplotInds(m)).p1amp),' uA']};
                handles.fig(i,j).mis3D(m,k).pPlotFakeR = plot3(0,0,0,'Marker',markerToUse,'MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2,'Linestyle', 'none');
            elseif any(strcmp(handles.ldg3D.AP,[num2str(handles.params(toplotInds(m)).p1amp),' uA']))
            else
                handles.ldg3D.AP = [handles.ldg3D.AP,{[num2str(handles.params(toplotInds(m)).p1amp),' uA']}];
                handles.fig(i,j).mis3D(m,k).pPlotFakeR = plot3(0,0,0,'Marker',markerToUse,'MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2,'Linestyle', 'none');
            end
            
            handles.fig(i,j).mis3D(m,k).pPlotR = plot3(mis3DPlot(1),mis3DPlot(2),mis3DPlot(3),'o');
            set(handles.fig(i,j).mis3D(m,k).pPlotR,'LineWidth',2,'DisplayName','','Marker',markerToUse,'MarkerSize',10,'MarkerEdgeColor',colorPlot)
            
            if any(handles.params(toplotInds(m)).FacialNerve)
                twitchPlotRP2 = plot3(mis3DPlot(1),mis3DPlot(2),mis3DPlot(3),'rx','MarkerSize', 20,'LineWidth',3,'Linestyle', 'none');
            end
        end
        hold(handles.fig(i,j).avgMisalign3D.R,'off');
    end
    
    
    if handles.LEyeFlag.Value
        set(0,'CurrentFigure',handles.avgMagPlot(i).normalized(l))
        set( handles.avgMagPlot(i).normalized(l),'CurrentAxes',handles.fig(i).normalized(l).avgMagaxL(j));
        hold(handles.fig(i).normalized(l).avgMagaxL(j),'on');
        handles.fig(i).p(j,k).ptL(m) = plot(handles.fig(i).normalized(l).avgMagaxL(j),handles.params(toplotInds(m)).p1amp,handles.params(toplotInds(m)).meanMagL,'color',colorPlot,'marker','o','MarkerSize',10,'LineWidth',2);
        errorbar(handles.fig(i).normalized(l).avgMagaxL(j),handles.params(toplotInds(m)).p1amp,handles.params(toplotInds(m)).meanMagL,handles.params(toplotInds(m)).stdMagL,'color',colorPlot,'LineWidth',2.5);
        handles.fig(i).normalized(l).avgMagaxL(j).LineWidth = 2.5;
        if handles.params(toplotInds(m)).FacialNerve
            handles.cutOff1 = plot(handles.fig(i).normalized(l).avgMagaxL(j),handles.params(toplotInds(m)).p1amp,handles.params(toplotInds(m)).meanMagL,'rx','MarkerSize', 20,'LineWidth',3);
        end
        hold(handles.fig(i).normalized(l).avgMagaxL(j),'off');
        
        set(0,'CurrentFigure',handles.avgMisalignPlot(i).normalized(l))
        set( handles.avgMisalignPlot(i).normalized(l),'CurrentAxes',handles.fig(i).normalized(l).avgMisalignaxL(j));
        hold(handles.fig(i).normalized(l).avgMisalignaxL(j),'on')
        handles.fig(i).q(j,k).ptL(m) = plot(handles.fig(i).normalized(l).avgMisalignaxL(j),handles.params(toplotInds(m)).p1amp,handles.params(toplotInds(m)).meanMisalignL,'color',colorPlot,'marker','o','MarkerSize',10,'LineWidth',2);
        errorbar(handles.fig(i).normalized(l).avgMisalignaxL(j),handles.params(toplotInds(m)).p1amp,handles.params(toplotInds(m)).meanMisalignL,handles.params(toplotInds(m)).stdMisalignL,'color',colorPlot,'LineWidth',2.5);
        handles.fig(i).normalized(l).avgMisalignaxL(j).LineWidth = 2.5;
        if handles.params(toplotInds(m)).FacialNerve
            plot(handles.fig(i).normalized(l).avgMisalignaxL(j),handles.params(toplotInds(m)).p1amp,handles.params(toplotInds(m)).meanMisalignL,'rx','MarkerSize', 20,'LineWidth',3);
        end
        hold(handles.fig(i).normalized(l).avgMisalignaxL(j),'off');
    end
    
    if handles.REyeFlag.Value
        set(0,'CurrentFigure',handles.avgMagPlot(i).normalized(l))
        set( handles.avgMagPlot(i).normalized(l),'CurrentAxes',handles.fig(i).normalized(l).avgMagaxR(j));
        hold(handles.fig(i).normalized(l).avgMagaxR(j),'on');
        handles.fig(i).p(j,k).ptR(m) = plot(handles.fig(i).normalized(l).avgMagaxR(j),handles.params(toplotInds(m)).p1amp,handles.params(toplotInds(m)).meanMagR,'color',colorPlot,'marker','o','MarkerSize',10,'LineWidth',2);
        errorbar(handles.fig(i).normalized(l).avgMagaxR(j),handles.params(toplotInds(m)).p1amp,handles.params(toplotInds(m)).meanMagR,handles.params(toplotInds(m)).stdMagR,'color',colorPlot,'LineWidth',2.5);
        handles.fig(i).normalized(l).avgMagaxR(j).LineWidth = 2.5;
        
        hold(handles.fig(i).normalized(l).avgMagaxR(j),'off');
        
        set(0,'CurrentFigure',handles.avgMisalignPlot(i).normalized(l))
        set( handles.avgMisalignPlot(i).normalized(l),'CurrentAxes',handles.fig(i).normalized(l).avgMisalignaxR(j));
        hold(handles.fig(i).normalized(l).avgMisalignaxR(j),'on')
        handles.fig(i).q(j,k).ptR(m) = plot(handles.fig(i).normalized(l).avgMisalignaxR(j),handles.params(toplotInds(m)).p1amp,handles.params(toplotInds(m)).meanMisalignR,'color',colorPlot,'marker','o','MarkerSize',10,'LineWidth',2);
        errorbar(handles.fig(i).normalized(l).avgMisalignaxR(j),handles.params(toplotInds(m)).p1amp,handles.params(toplotInds(m)).meanMisalignR,handles.params(toplotInds(m)).stdMisalignR,'color',colorPlot,'LineWidth',2.5);
        handles.fig(i).normalized(l).avgMisalignaxR(j).LineWidth = 2.5;
        
        hold(handles.fig(i).normalized(l).avgMisalignaxR(j),'off');
    end
    
end
handles.plottedInds = [handles.plottedInds toplotInds];
if j == length(handles.figE)
    handles.allInds = [handles.allInds handles.plottedInds];
end

if handles.REyeFlag.Value && handles.LEyeFlag.Value
    handles.fig(i).normalized(l).avgMagaxL(j).XLabel.String = '';
    handles.fig(i).normalized(l).avgMisalignaxL(j).XLabel.String = '';
end

if handles.LEyeFlag.Value
    if handles.stimulatingE.Value
        term = 'Source, ';
    elseif handles.referenceE.Value
        term = 'Reference, ';
    end
    set(0,'CurrentFigure',handles.avgMagPlot(i).normalized(l))
    set( handles.avgMagPlot(i).normalized(l),'CurrentAxes',handles.fig(i).normalized(l).avgMagaxL(j));
    hold(handles.fig(i).normalized(l).avgMagaxL(j),'on');
    handles.fig(i).normalized(l).avgMagaxL(j).Title.String = [term,ePosFig];
    handles.fig(i).p(j,k).lineL = line(handles.fig(i).normalized(l).avgMagaxL(j),[handles.fig(i).p(j,k).ptL.XData],[handles.fig(i).p(j,k).ptL.YData],'color',colorPlot,'LineWidth',4);
    handles.fig(i).normalized(l).avgMagaxL(j).XLabel.String = {'Current (uA)'};
    handles.fig(i).normalized(l).avgMagaxL(j).XLabel.FontSize = 22;
    if (k == 1) && (j == 1)
        handles.fig(i).normalized(l).avgMagaxL(j).YLabel.String = {'Velocity (dps)'};
        handles.fig(i).normalized(l).avgMagaxL(j).YLabel.FontSize = 22;
    end
    hold(handles.fig(i).normalized(l).avgMagaxL(j),'off');
    
    set(0,'CurrentFigure',handles.avgMisalignPlot(i).normalized(l))
    set( handles.avgMisalignPlot(i).normalized(l),'CurrentAxes',handles.fig(i).normalized(l).avgMisalignaxL(j));
    hold(handles.fig(i).normalized(l).avgMisalignaxL(j),'on')
    handles.fig(i).normalized(l).avgMisalignaxL(j).Title.String = [term,ePosFig];
    handles.fig(i).q(j,k).lineL = line(handles.fig(i).normalized(l).avgMisalignaxL(j),[handles.fig(i).q(j,k).ptL.XData],[handles.fig(i).q(j,k).ptL.YData],'color',colorPlot,'LineWidth',4);
    handles.fig(i).normalized(l).avgMisalignaxL(j).XLabel.String = {'Current (uA)'};
    handles.fig(i).normalized(l).avgMisalignaxL(j).XLabel.FontSize = 22;
    if (k == 1) && (j == 1)
        handles.fig(i).normalized(l).avgMisalignaxL(j).YLabel.String = {'Misalignment (degrees)'};
        handles.fig(i).normalized(l).avgMisalignaxL(j).YLabel.FontSize = 22;
    end
    hold(handles.fig(i).normalized(l).avgMisalignaxL(j),'off');
end

if handles.REyeFlag.Value
    if handles.stimulatingE.Value
        term = 'Source, ';
    elseif handles.referenceE.Value
        term = 'Reference, ';
    end
    set(0,'CurrentFigure',handles.avgMagPlot(i).normalized(l))
    set( handles.avgMagPlot(i).normalized(l),'CurrentAxes',handles.fig(i).normalized(l).avgMagaxR(j));
    hold(handles.fig(i).normalized(l).avgMagaxR(j),'on');
    handles.fig(i).normalized(l).avgMagaxR(j).Title.String = [term,ePosFig];
    handles.fig(i).p(j,k).lineR = line(handles.fig(i).normalized(l).avgMagaxR(j),[handles.fig(i).p(j,k).ptR.XData],[handles.fig(i).p(j,k).ptR.YData],'color',colorPlot,'LineWidth',4);
    handles.fig(i).normalized(l).avgMagaxR(j).XLabel.String = {'Current (uA)'};
    handles.fig(i).normalized(l).avgMagaxR(j).XLabel.FontSize = 22;
    hold(handles.fig(i).normalized(l).avgMagaxR(j),'off');
    
    set(0,'CurrentFigure',handles.avgMisalignPlot(i).normalized(l))
    set( handles.avgMisalignPlot(i).normalized(l),'CurrentAxes',handles.fig(i).normalized(l).avgMisalignaxR(j));
    hold(handles.fig(i).normalized(l).avgMisalignaxR(j),'on')
    handles.fig(i).normalized(l).avgMisalignaxR(j).Title.String = [term,ePosFig];
    handles.fig(i).q(j,k).lineR = line(handles.fig(i).normalized(l).avgMisalignaxR(j),[handles.fig(i).q(j,k).ptR.XData],[handles.fig(i).q(j,k).ptR.YData],'color',colorPlot,'LineWidth',4);
    handles.fig(i).normalized(l).avgMisalignaxR(j).XLabel.String = {'Current (uA)'};
    handles.fig(i).normalized(l).avgMisalignaxR(j).XLabel.FontSize = 22;
    hold(handles.fig(i).normalized(l).avgMisalignaxR(j),'off');
end
sameaxes([],[handles.avgMisalignPlot(i).normalized])
sameaxes([],[handles.avgMagPlot(i).normalized])




if (k == length(handles.axE)) && (l == handles.currmaxNorm)
    twitchLDG = 0;
    sourceLab = 0;
    if handles.LEyeFlag.Value
        if handles.norm.Value
            if any([handles.params(handles.plottedInds).FacialNerve]) && ~twitchLDG
                ldg3D = legend(handles.fig(i,j).avgMisalign3D.L,[handles.fig(i,j).mis3D.lPlotFakeL handles.fig(i,j).mis3D.lPlotFakeLD handles.fig(i,j).mis3D.pPlotFakeL handles.twitchPlotL],[handles.ldg3D.lines handles.ldg3D.Defaultlines handles.ldg3D.AP {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
                twitchLDG = 1;
            else
                ldg3D = legend(handles.fig(i,j).avgMisalign3D.L,[handles.fig(i,j).mis3D.lPlotFakeL handles.fig(i,j).mis3D.lPlotFakeLD handles.fig(i,j).mis3D.pPlotFakeL],[handles.ldg3D.lines handles.ldg3D.Defaultlines handles.ldg3D.AP],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
                twitchLDG = 1;
            end
            
        else
            if any([handles.params(handles.plottedInds).FacialNerve]) && ~twitchLDG
                ldg3D = legend(handles.fig(i,j).avgMisalign3D.L,[handles.fig(i,j).mis3D.lPlotFakeL handles.fig(i,j).mis3D.pPlotFakeL handles.twitchPlotL],[handles.ldg3D.lines handles.ldg3D.AP {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
                twitchLDG = 1;
            else
                ldg3D = legend(handles.fig(i,j).avgMisalign3D.L,[handles.fig(i,j).mis3D.lPlotFakeL handles.fig(i,j).mis3D.pPlotFakeL],[handles.ldg3D.lines handles.ldg3D.AP],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
                twitchLDG = 1;
            end
            
        end
    end
    if handles.REyeFlag.Value
        if handles.norm.Value
            if any([handles.params(handles.plottedInds).FacialNerve]) && ~twitchLDG
                ldg3D = legend(handles.fig(i,j).avgMisalign3D.R,[handles.fig(i,j).mis3D.lPlotFakeR handles.fig(i,j).mis3D.lPlotFakeRD handles.fig(i,j).mis3D.pPlotFakeR twitchPlotR],[handles.ldg3D.lines handles.ldg3D.Defaultlines handles.ldg3D.AP {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
                twitchLDG = 1;
            else
                ldg3D = legend(handles.fig(i,j).avgMisalign3D.R,[handles.fig(i,j).mis3D.lPlotFakeR handles.fig(i,j).mis3D.lPlotFakeRD handles.fig(i,j).mis3D.pPlotFakeR],[handles.ldg3D.lines handles.ldg3D.Defaultlines handles.ldg3D.AP],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
                twitchLDG = 1;
            end
            
        else
            if any([handles.params(handles.plottedInds).FacialNerve]) && ~twitchLDG
                ldg3D = legend(handles.fig(i,j).avgMisalign3D.R,[handles.fig(i,j).mis3D.lPlotFakeR handles.fig(i,j).mis3D.pPlotFakeR twitchPlotR],[handles.ldg3D.lines handles.ldg3D.AP {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
                twitchLDG = 1;
            else
                ldg3D = legend(handles.fig(i,j).avgMisalign3D.R,[handles.fig(i,j).mis3D.lPlotFakeR handles.fig(i,j).mis3D.pPlotFakeR],[handles.ldg3D.lines handles.ldg3D.AP],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
                twitchLDG = 1;
            end
            
        end
    end
    
    
    ecombName=[];
    if handles.distantstim.Value
        if isempty(ecombName)
            ecombName = [ecombName,'Distant'];
        else
            ecombName = [ecombName,'-Distant'];
        end
    end
    if handles.ccstim.Value
        if isempty(ecombName)
            ecombName = [ecombName,'CC'];
        else
            ecombName = [ecombName,'-CC'];
        end
    end
    if handles.bipolarstim.Value
        if isempty(ecombName)
            ecombName = [ecombName,'Bipolar'];
        else
            ecombName = [ecombName,'-Bipolar'];
        end
    end
    
    if handles.LEyeFlag.Value && handles.REyeFlag.Value
        if handles.stimulatingE.Value
            misalgn3DName = [handles.figDir,'\eyeMisalignment3D_Current_ByStimE_R&Leye_Stim',num2str(handles.figE(j)),'_',ecombName,handles.figdir];
        elseif handles.referenceE.Value
            misalgn3DName = [handles.figDir,'\eyeMisalignment3D_Current_ByRefE_R&Leye_Ref',num2str(handles.figE(j)),'_',ecombName,handles.figdir];
        end
        
    elseif handles.LEyeFlag.Value
        if handles.norm.Value
            normName = [];
            for g = 1:length([handles.params(handles.params(toplotInds(1)).normInd).p1d])
                if g == 1
                    temp = {handles.params(handles.params(toplotInds(1)).normInd).p1d};
                    normName = [normName num2str(temp{g})];
                else
                    temp = {handles.params(handles.params(toplotInds(1)).normInd).p1d};
                    normName = [normName,'&',num2str(temp{g})];
                end
            end
            if handles.stimulatingE.Value
                misalgn3DName = [handles.figDir,'\eyeMisalignment3D_Default',normName,'P1D_Current_ByStimE_Leye_Stim',num2str(handles.figE(j)),'_',ecombName,handles.figdir];
            elseif handles.referenceE.Value
                misalgn3DName = [handles.figDir,'\eyeMisalignment3D_Default',normName,'P1D_Current_ByRefE_Leye_Ref',num2str(handles.figE(j)),'_',ecombName,handles.figdir];
            end
        else
            if handles.stimulatingE.Value
                misalgn3DName = [handles.figDir,'\eyeMisalignment3D_Current_ByStimE_Leye_Stim',num2str(handles.figE(j)),'_',ecombName,handles.figdir];
            elseif handles.referenceE.Value
                misalgn3DName = [handles.figDir,'\eyeMisalignment3D_Current_ByRefE_Leye_Ref',num2str(handles.figE(j)),'_',ecombName,handles.figdir];
            end
        end
    elseif handles.REyeFlag.Value
        if handles.norm.Value
            normName = [];
            for g = 1:length([handles.params(handles.params(toplotInds(1)).normInd).p1d])
                if g == 1
                    temp = {handles.params(handles.params(toplotInds(1)).normInd).p1d};
                    normName = [normName num2str(temp{g})];
                else
                    temp = {handles.params(handles.params(toplotInds(1)).normInd).p1d};
                    normName = [normName,'&',num2str(temp{g})];
                end
            end
            if handles.stimulatingE.Value
                misalgn3DName = [handles.figDir,'\eyeMisalignment3D_Default',normName,'P1D_Current_ByStimE_Reye_Stim',num2str(handles.figE(j)),'_',ecombName,handles.figdir];
            elseif handles.referenceE.Value
                misalgn3DName = [handles.figDir,'\eyeMisalignment3D_Default',normName,'P1D_Current_ByRefE_Reye_Ref',num2str(handles.figE(j)),'_',ecombName,handles.figdir];
            end
        else
            if handles.stimulatingE.Value
                misalgn3DName = [handles.figDir,'\eyeMisalignment3D_Current_ByStimE_Reye_Stim',num2str(handles.figE(j)),'_',ecombName,handles.figdir];
            elseif handles.referenceE.Value
                misalgn3DName = [handles.figDir,'\eyeMisalignment3D_Current_ByRefE_Reye_Ref',num2str(handles.figE(j)),'_',ecombName,handles.figdir];
            end
        end
    end
    saveas(handles.avgMisalignPlot3D(i,j).normalize,[misalgn3DName,'.svg']);
    saveas(handles.avgMisalignPlot3D(i,j).normalize,[misalgn3DName,'.jpg']);
    saveas(handles.avgMisalignPlot3D(i,j).normalize,[misalgn3DName,'.fig']);
    close(handles.avgMisalignPlot3D(i,j).normalize);
    
    for rN = 1:length(handles.axE)
        if isempty(handles.ldgNames)
        elseif strcmp(handles.ldgNames{rN},' ')
            handles.ldgNames{rN} = ' ';
        else
        end
    end
    
    for rN = 1:length(handles.axE)
        ePosAx = getePos(handles,handles.axE(rN));
        if handles.stimulatingE.Value
            if ~any(strcmp(handles.ldgNames,['Return, ',ePosAx]))
                handles.ldgNames{rN} = ['Return, ',ePosAx];
                if handles.LEyeFlag.Value
                    handles.lines(rN) = [handles.fig(i).q(j,rN).lineL];
                elseif handles.REyeFlag
                    handles.lines(rN) = [handles.fig(i).q(j,rN).lineR];
                end
            end
        elseif handles.referenceE.Value
            if ~any(strcmp(handles.ldgNames,['Source, ',ePosAx]))
                handles.ldgNames{rN} = ['Source, ',ePosAx];
                if handles.LEyeFlag.Value
                    handles.lines(rN) = [handles.fig(i).q(j,rN).lineL];
                elseif handles.REyeFlag.Value
                    handles.lines(rN) = [handles.fig(i).q(j,rN).lineR];
                end
            end
        end
        
        
    end
    if j == length(handles.figE)
        if handles.LEyeFlag.Value + handles.REyeFlag.Value == 2
            t=[handles.params(handles.allInds).FacialNerve];
            if any(t)
                ldg1 = legend(handles.fig(i).normalized(l).avgMagaxR(j),[handles.lines handles.cutOff1],[handles.ldgNames {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','horizontal');
                ldg2 = legend(handles.fig(i).normalized(l).avgMisalignaxR(j),[handles.lines handles.cutOff1],[handles.ldgNames {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','horizontal');
                ldg1.Position = [0.4 0.01 0.1308 0.0192];
                ldg2.Position = [0.4 0.01 0.1308 0.0192];
                ldg1.FontSize = 13.5;
                ldg2.FontSize = 13.5;
            else
                ldg1 = legend(handles.fig(i).normalized(l).avgMagaxR(j),handles.lines,handles.ldgNames,'Orientation','horizontal');
                ldg2 = legend(handles.fig(i).normalized(l).avgMisalignaxR(j),handles.lines,handles.ldgNames,'Orientation','horizontal');
                ldg1.Position = [0.4 0.01 0.1308 0.0192];
                ldg2.Position = [0.4 0.01 0.1308 0.0192];
                ldg1.FontSize = 13.5;
                ldg2.FontSize = 13.5;
            end
            
            
            %*[0.7940    0.0297    0.1153;-0.8296    0.0283   -0.1883;0.7940    0.0297    0.1153]
            if handles.stimulatingE.Value
                misalgnName = [handles.figDir,'\eyeMisalignment_ByStim',num2str(handles.figE(j)),'_R&Leye_',handles.figdir];
                velName = [handles.figDir,'\eyeVelocity_ByStim',num2str(handles.figE(j)),'_R&Leye_',handles.figdir];
            elseif handles.referenceE.Value
                misalgnName = [handles.figDir,'\eyeMisalignment_ByRef',num2str(handles.figE(j)),'_R&Leye_',handles.figdir];
                velName = [handles.figDir,'\eyeVelocity_ByRef',num2str(handles.figE(j)),'_R&Leye_',handles.figdir];
            end
            
        elseif handles.LEyeFlag.Value
            t=[handles.params(handles.allInds).FacialNerve];
            if any(t)
                ldg1 = legend(handles.fig(i).normalized(l).avgMagaxL(j),[handles.lines handles.cutOff1],[handles.ldgNames {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','horizontal','AutoUpdate','off');
                ldg2 = legend(handles.fig(i).normalized(l).avgMisalignaxL(j),[handles.lines handles.cutOff1],[handles.ldgNames {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','horizontal','AutoUpdate','off');
                ldg1.Position = [0.4 0.01 0.1308 0.0192];
                ldg2.Position = [0.4 0.01 0.1308 0.0192];
                ldg1.FontSize = 13.5;
                ldg2.FontSize = 13.5;
            else
                ldg1 = legend(handles.fig(i).normalized(l).avgMagaxL(j),handles.lines,handles.ldgNames,'Orientation','horizontal','AutoUpdate','off');
                ldg2 = legend(handles.fig(i).normalized(l).avgMisalignaxL(j),handles.lines,handles.ldgNames,'Orientation','horizontal','AutoUpdate','off');
                ldg1.Position = [0.4 0.01 0.1308 0.0192];
                ldg2.Position = [0.4 0.01 0.1308 0.0192];
                ldg1.FontSize = 13.5;
                ldg2.FontSize = 13.5;
            end
            
            
            %*[0.7940    0.0297    0.1153;-0.8296    0.0283   -0.1883;0.7940    0.0297    0.1153]
            if handles.stimulatingE.Value
                if handles.norm.Value
                    handles.avgMisalignPlot(i).normalized(l).Name = [handles.figDir,'\NormalizedeyeMisalignmentBy',normName,'P1D_Current_ByStim_',ecombName,'_Leye_',handles.figdir];
                    handles.avgMagPlot(i).normalized(l).Name = [handles.figDir,'\NormalizedeyeVelocityBy',normName,'P1D_Current_ByStim_',ecombName,'_Leye_',handles.figdir];
                else
                    handles.avgMisalignPlot(i).normalized(l).Name = [handles.figDir,'\eyeMisalignment_Current_ByStim_',ecombName,'_Leye_',handles.figdir];
                    handles.avgMagPlot(i).normalized(l).Name = [handles.figDir,'\eyeVelocity_Current_ByStim_',ecombName,'_Leye_',handles.figdir];
                end
            elseif handles.referenceE.Value
                if handles.norm.Value
                    handles.avgMisalignPlot(i).normalized(l).Name = [handles.figDir,'\NormalizedeyeMisalignmentBy',normName,'P1D_Current_ByRef_',ecombName,'_Leye_',handles.figdir];
                    handles.avgMagPlot(i).normalized(l).Name = [handles.figDir,'\NormalizedeyeVelocityBy',normName,'P1D_Current_ByRef_',ecombName,'_Leye_',handles.figdir];
                else
                    handles.avgMisalignPlot(i).normalized(l).Name = [handles.figDir,'\eyeMisalignment_Current_ByRef_',ecombName,'_Leye_',handles.figdir];
                    handles.avgMagPlot(i).normalized(l).Name = [handles.figDir,'\eyeVelocity_Current_ByRef_',ecombName,'_Leye_',handles.figdir];
                end
            end
            
            
        elseif handles.REyeFlag.Value
            t=[handles.params(handles.allInds).FacialNerve];
            if any(t)
                ldg1 = legend(handles.fig(i).normalized(l).avgMagaxR(j),[handles.lines handles.cutOff1],[handles.ldgNames {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','horizontal','AutoUpdate','off');
                ldg2 = legend(handles.fig(i).normalized(l).avgMisalignaxR(j),[handles.lines handles.cutOff1],[handles.ldgNames {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','horizontal','AutoUpdate','off');
                ldg1.Position = [0.4 0.01 0.1308 0.0192];
                ldg2.Position = [0.4 0.01 0.1308 0.0192];
                ldg1.FontSize = 13.5;
                ldg2.FontSize = 13.5;
            else
                ldg1 = legend(handles.fig(i).normalized(l).avgMagaxR(j),handles.lines,handles.ldgNames,'Orientation','horizontal','AutoUpdate','off');
                ldg2 = legend(handles.fig(i).normalized(l).avgMisalignaxR(j),handles.lines,handles.ldgNames,'Orientation','horizontal','AutoUpdate','off');
                ldg1.Position = [0.4 0.01 0.1308 0.0192];
                ldg2.Position = [0.4 0.01 0.1308 0.0192];
                ldg1.FontSize = 13.5;
                ldg2.FontSize = 13.5;
            end
            
            
            %*[0.7940    0.0297    0.1153;-0.8296    0.0283   -0.1883;0.7940    0.0297    0.1153]
            if handles.stimulatingE.Value
                if handles.norm.Value
                    handles.avgMisalignPlot(i).normalized(ltimes).Name = [handles.figDir,'\NormalizedeyeMisalignmentBy',normName,'P1D_Current_ByStim_',ecombName,'Reye_',handles.figdir];
                    handles.avgMagPlot(i).normalized(ltimes).Name = [handles.figDir,'\NormalizedeyeVelocityBy',normName,'P1D_Current_ByStim_',ecombName,'_Reye_',handles.figdir];
                else
                    handles.avgMisalignPlot(i).normalized(ltimes).Name = [handles.figDir,'\eyeMisalignment_Current_ByStim_',ecombName,'_Reye_',handles.figdir];
                    handles.avgMagPlot(i).normalized(ltimes).Name = [handles.figDir,'\eyeVelocity_Current_ByStim_',ecombName,'_Reye_',handles.figdir];
                end
            elseif handles.referenceE.Value
                if handles.norm.Value
                    handles.avgMisalignPlot(i).normalized(ltimes).Name = [handles.figDir,'\NormalizedeyeMisalignmentBy',normName,'P1D_Current_ByRef','_Reye_',handles.figdir];
                    handles.avgMagPlot(i).normalized(ltimes).Name = [handles.figDir,'\NormalizedeyeVelocityBy',normName,'P1D_Current_ByRef','_Reye_',handles.figdir];
                else
                    handles.avgMisalignPlot(i).normalized(ltimes).Name = [handles.figDir,'\eyeMisalignment_Current_ByRef_',normName,'_Reye_',handles.figdir];
                    handles.avgMagPlot(i).normalized(ltimes).Name = [handles.figDir,'\eyeVelocity_Current_ByRef','_Reye_',normName,handles.figdir];
                end
            end
            
        end
    end
    
    
    
    
    
    start = length(handles.axE);
    
    
    if (i == sum(handles.LRZ)) && (j == length(handles.figE))
        sameaxes([],[handles.avgMisalignPlot(:).normalized])
        sameaxes([],[handles.avgMagPlot(:).normalized])
        for figDir = 1:size(handles.avgMisalignPlot,1)
            for figSave = 1:size(handles.avgMisalignPlot(figDir,:),2)
                for figNorm = 1:length(handles.avgMisalignPlot(figDir,figSave).normalized)
                    saveas(handles.avgMisalignPlot(figDir,figSave).normalized(figNorm),[handles.avgMisalignPlot(figDir,figSave).normalized(figNorm).Name,'.svg']);
                    saveas(handles.avgMisalignPlot(figDir,figSave).normalized(figNorm),[handles.avgMisalignPlot(figDir,figSave).normalized(figNorm).Name,'.jpg']);
                    saveas(handles.avgMisalignPlot(figDir,figSave).normalized(figNorm),[handles.avgMisalignPlot(figDir,figSave).normalized(figNorm).Name,'.fig']);
                    saveas(handles.avgMagPlot(figDir,figSave).normalized(figNorm),[handles.avgMagPlot(figDir,figSave).normalized(figNorm).Name,'.svg']);
                    saveas(handles.avgMagPlot(figDir,figSave).normalized(figNorm),[handles.avgMagPlot(figDir,figSave).normalized(figNorm).Name,'.jpg']);
                    saveas(handles.avgMagPlot(figDir,figSave).normalized(figNorm),[handles.avgMagPlot(figDir,figSave).normalized(figNorm).Name,'.fig']);
                    close(handles.avgMisalignPlot(figDir,figSave).normalized(figNorm));
                    close(handles.avgMagPlot(figDir,figSave).normalized(figNorm));
                end
            end
        end
    end
end


function ePos = getePos(handles,j)
ePos = '';
switch handles.configByAnimal.Value
    case 1
    case 2
    case 3 % Nancy
        switch j
            case 1
                ePos = 'Left Posterior, Shallow';
            case 2
                ePos = 'Left Posterior, Middle';
            case 3
                ePos = 'Left Posterior, Deep';
            case 4
                ePos = 'Left Anterior, Shallow';
            case 5
                ePos = 'Left Anterior, Middle Outside';
            case 6
                ePos = 'Left Anterior, Deep';
            case 14
                ePos = 'Left Anterior, Middle Inside';
            case 7
                ePos = 'Left Horizontal, Deep';
            case 8
                ePos = 'Left Horizontal, Middle Outside';
            case 9
                ePos = 'Left Horizontal, Shallow';
            case 15
                ePos = 'Left Horizontal, Middle Inside';
            case 10
                ePos = 'Left Distant';
            case 11
                ePos = 'Left Common Crus, Deep';
            case 12
                ePos = 'Left Common Crus, Middle';
            case 13
                ePos = 'Left Common Crus, Shallow';
        end
    case 4 % Yoda
        switch j
            case 1
                ePos = 'Right Posterior, Shallow';
            case 2
                ePos = 'Right Posterior, Middle';
            case 3
                ePos = 'Right Posterior, Deep';
            case 4
                ePos = 'Right Anterior, Shallow';
            case 5
                ePos = 'Right Anterior, Middle Outside';
            case 6
                ePos = 'Right Anterior, Deep';
            case 14
                ePos = 'Right Anterior, Middle Inside';
            case 7
                ePos = 'Right Horizontal, Deep';
            case 8
                ePos = 'Right Horizontal, Middle Outside';
            case 9
                ePos = 'Right Horizontal, Shallow';
            case 15
                ePos = 'Right Horizontal, Middle Inside';
            case 10
                ePos = 'Right Distant';
            case 11
                ePos = 'Right Common Crus, Deep';
            case 12
                ePos = 'Right Common Crus, Middle';
            case 13
                ePos = 'Right Common Crus, Shallow';
        end
end
