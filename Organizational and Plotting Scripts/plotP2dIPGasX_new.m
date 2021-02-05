function handles = plotP2dIPGasX_new(handles,i,j,k,l)
% i = L R Z
% j = e# for figure
% k = e# for axes
% l = norm #
% 3D misalign figure by Phase 2 (1 figure per figE per norm cond)
% 3D misalign figure by IPG (1 figure per figE per norm cond)
% eye velocity plot IPGvsP2 (norm or not) (1 figure per figE per norm cond)
% misalignment plot IPGvsP2 (norm or not) (1 figure per figE per norm cond)
% handles.axName
%     handles.ldgName
if k==1
    if l == 1
        handles.avgMisalignPlot3DP2(i,j).normalize = figure('units','normalized','outerposition',[0 0 1 1]);
        sgtitle(handles.avgMisalignPlot3DP2(i,j).normalize,{['3D Angle of Misalignment, ',handles.axName,num2str(handles.figE(j)),', ',handles.figdir]; ' '},'FontSize', 22, 'FontWeight', 'Bold');
        
        handles.avgMisalignPlot3Dipg(i,j).normalize = figure('units','normalized','outerposition',[0 0 1 1]);
        sgtitle(handles.avgMisalignPlot3Dipg(i,j).normalize,{['3D Angle of Misalignment, ',handles.axName,num2str(handles.figE(j)),', ',handles.figdir]; ' '},'FontSize', 22, 'FontWeight', 'Bold');
        
        if handles.LEyeFlag.Value + handles.REyeFlag.Value == 2
            handles.fig(i,j).avgMisalign3DP2.R = subtightplot(1,2,1,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot3DP2(i,j).normalize);
            handles.fig(i,j).avgMisalign3DP2.L = subtightplot(1,2,2,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot3DP2(i,j).normalize);
            handles.fig(i,j).avgMisalign3DP2.R.XGrid = 'on';
            handles.fig(i,j).avgMisalign3DP2.R.YGrid = 'on';
            handles.fig(i,j).avgMisalign3DP2.L.XGrid = 'on';
            handles.fig(i,j).avgMisalign3DP2.L.YGrid = 'on';
            handles.fig(i,j).avgMisalign3DP2.L.Title.String = 'Left Eye 3D Misalignment';
            handles.fig(i,j).avgMisalign3DP2.L.FontSize = 13.5;
            handles.fig(i,j).avgMisalign3DP2.R.Title.String = 'Right Eye 3D Misalignment';
            handles.fig(i,j).avgMisalign3DP2.R.FontSize = 13.5;
            
        elseif handles.LEyeFlag.Value
            
            handles.fig(i,j).avgMisalign3DP2.L = axes('Parent', handles.avgMisalignPlot3DP2(i,j).normalize);
            handles.fig(i,j).avgMisalign3DP2.L.XGrid = 'on';
            handles.fig(i,j).avgMisalign3DP2.L.YGrid = 'on';
            handles.fig(i,j).avgMisalign3DP2.L.Title.String = 'Left Eye 3D Misalignment, Phase 2 Duration';
            handles.fig(i,j).avgMisalign3DP2.L.FontSize = 13.5;
            handles.fig(i,j).avgMisalign3Dipg.L = axes('Parent', handles.avgMisalignPlot3Dipg(i,j).normalize);
            handles.fig(i,j).avgMisalign3Dipg.L.XGrid = 'on';
            handles.fig(i,j).avgMisalign3Dipg.L.YGrid = 'on';
            handles.fig(i,j).avgMisalign3Dipg.L.Title.String = 'Left Eye 3D Misalignment, Interphase Gap';
            handles.fig(i,j).avgMisalign3Dipg.L.FontSize = 13.5;
        elseif handles.REyeFlag.Value
            
            handles.fig(i,j).avgMisalign3DP2.R = axes('Parent', handles.avgMisalignPlot3DP2(i,j).normalize);
            handles.fig(i,j).avgMisalign3DP2.R.XGrid = 'on';
            handles.fig(i,j).avgMisalign3DP2.R.YGrid = 'on';
            handles.fig(i,j).avgMisalign3DP2.R.Title.String = 'Right Eye 3D Misalignment';
            handles.fig(i,j).avgMisalign3DP2.R.FontSize = 13.5;
        end
        
        if handles.LEyeFlag.Value
            figure(handles.avgMisalignPlot3DP2(i,j).normalize);
            set( handles.avgMisalignPlot3DP2(i,j).normalize,'CurrentAxes',handles.fig(i,j).avgMisalign3DP2.L)
            hold(handles.fig(i,j).avgMisalign3DP2.L,'on');
            h=plot3vect([1/sqrt(2);-1/sqrt(2);0],'LARP Axis',[0 1 0],2);
            set(h,'LineStyle','--','Marker','o');
            h=plot3vect([1/sqrt(2);1/sqrt(2);0],'RALP Axis',[0 1 1],2);
            set(h,'LineStyle','--','Marker','o');
            h=plot3vect([0;0;1],'Yaw Axis',[0.68 0 0],2);
            set(h,'LineStyle','--','Marker','o');
            
            [x,y,z]=sphere();
            h=surf(0.5*x,0.5*y,0.5*z);
            set(h,'FaceColor','white')
            handles.fig(i,j).avgMisalign3DP2.L.View = [90 -0.5];
            axis vis3d
            axis equal
            box on;
            xlim([-1 1])
            ylim([-1 1])
            zlim([-1 1])
            hold(handles.fig(i,j).avgMisalign3DP2.L,'off');
            
            
            figure(handles.avgMisalignPlot3Dipg(i,j).normalize);
            set( handles.avgMisalignPlot3Dipg(i,j).normalize,'CurrentAxes',handles.fig(i,j).avgMisalign3Dipg.L)
            hold(handles.fig(i,j).avgMisalign3Dipg.L,'on');
            h=plot3vect([1/sqrt(2);-1/sqrt(2);0],'LARP Axis',[0 1 0],2);
            set(h,'LineStyle','--','Marker','o');
            h=plot3vect([1/sqrt(2);1/sqrt(2);0],'RALP Axis',[0 1 1],2);
            set(h,'LineStyle','--','Marker','o');
            h=plot3vect([0;0;1],'Yaw Axis',[0.68 0 0],2);
            set(h,'LineStyle','--','Marker','o');
            
            [x,y,z]=sphere();
            h=surf(0.5*x,0.5*y,0.5*z);
            set(h,'FaceColor','white')
            handles.fig(i,j).avgMisalign3Dipg.L.View = [90 -0.5];
            axis vis3d
            axis equal
            box on;
            xlim([-1 1])
            ylim([-1 1])
            zlim([-1 1])
            hold(handles.fig(i,j).avgMisalign3Dipg.L,'off');
            
            
        end
        
        if handles.REyeFlag.Value
            set( handles.avgMisalignPlot3DP2(i,j).normalize,'CurrentAxes',handles.fig(i,j).avgMisalign3DP2.R)
            hold(handles.fig(i,j).avgMisalign3DP2.R,'on');
            h=plot3vect([1/sqrt(2);-1/sqrt(2);0],'LARP Axis',[0 1 0],2);
            set(h,'LineStyle','--','Marker','o');
            h=plot3vect([1/sqrt(2);1/sqrt(2);0],'RALP Axis',[0 1 1],2);
            set(h,'LineStyle','--','Marker','o');
            h=plot3vect([0;0;1],'Yaw Axis',[0.68 0 0],2);
            set(h,'LineStyle','--','Marker','o');
            
            [x,y,z]=sphere();
            h=surf(0.5*x,0.5*y,0.5*z);
            set(h,'FaceColor','white')
            handles.fig(i,j).avgMisalign3DP2.R.View = [90 -0.5];
            axis vis3d
            axis equal
            box on;
            xlim([-1 1])
            ylim([-1 1])
            zlim([-1 1])
            hold(handles.fig(i,j).avgMisalign3DP2.R,'off');
            
        end
            handles.ldg3D.lines = {};
    handles.ldg3D.Defaultlines = {};
    handles.ldg3DP2.AP = {};
    handles.ldg3Dipg.AP = {};
    end
    
    handles.avgMagPlot(i,j).normalized(l) = figure('units','normalized','outerposition',[0 0 1 1]);
    handles.avgMisalignPlot(i,j).normalized(l) = figure('units','normalized','outerposition',[0 0 1 1]);
end
if handles.LEyeFlag.Value + handles.REyeFlag.Value == 2
    handles.fig(i,j).normalized(l).avgMagaxL(k) = subtightplot(2,length(handles.axE),k,[0.015 0.015],[0.10 0.075],[.05 .05],'Parent', handles.avgMagPlot(i,j).normalized(l));
    handles.fig(i,j).normalized(l).avgMagaxR(k) = subtightplot(2,length(handles.axE),k+length(handles.axE),[0.015 0.015],[0.10 0.075],[.05 .05],'Parent', handles.avgMagPlot(i,j).normalized(l));
    
    handles.fig(i,j).normalized(l).avgMisalignaxL(k) = subtightplot(2,length(handles.axE),k,[0.015 0.015],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot(i,j).normalized(l));
    handles.fig(i,j).normalized(l).avgMisalignaxR(k) = subtightplot(2,length(handles.axE),k+length(handles.axE),[0.015 0.015],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot(i,j).normalized(l));
    
    handles.fig(i,j).normalized(l).avgMagaxL(k).XTickLabel = [];
    handles.fig(i,j).normalized(l).avgMagaxR(k).XTick = [0:50:handles.allP2d(end)];
    handles.fig(i,j).normalized(l).avgMisalignaxL(k).XTickLabel = [];
    handles.fig(i,j).normalized(l).avgMisalignaxR(k).XTick = [0:50:handles.allP2d(end)];
    handles.fig(i,j).normalized(l).avgMagaxL(k).XGrid = 'on';
    handles.fig(i,j).normalized(l).avgMagaxR(k).XGrid = 'on';
    handles.fig(i,j).normalized(l).avgMagaxL(k).YGrid = 'on';
    handles.fig(i,j).normalized(l).avgMagaxR(k).YGrid = 'on';
    handles.fig(i,j).normalized(l).avgMisalignaxL(k).XGrid = 'on';
    handles.fig(i,j).normalized(l).avgMisalignaxR(k).XGrid = 'on';
    handles.fig(i,j).normalized(l).avgMisalignaxL(k).YGrid = 'on';
    handles.fig(i,j).normalized(l).avgMisalignaxR(k).YGrid = 'on';
    handles.fig(i,j).normalized(l).avgMagaxR(k).XLim = [0 handles.allP2d(end)+50];
    handles.fig(i,j).normalized(l).avgMagaxL(k).XLim = [0 handles.allP2d(end)+50];
    handles.fig(i,j).normalized(l).avgMisalignaxR(k).XLim = [0 handles.allP2d(end)+50];
    handles.fig(i,j).normalized(l).avgMisalignaxL(k).XLim = [0 handles.allP2d(end)+50];
    handles.fig(i,j).normalized(l).avgMagaxR(k).XTick = [0:50:handles.allP2d(end)];
    handles.fig(i,j).normalized(l).avgMisalignaxR(k).XTick = [0:50:handles.allP2d(end)];
    
elseif handles.LEyeFlag.Value
    handles.fig(i,j).normalized(l).avgMagaxL(k) = subtightplot(1,length(handles.axE),k,[0.01 0.015],[0.10 0.075],[.05 .05],'Parent', handles.avgMagPlot(i,j).normalized(l));
    handles.fig(i,j).normalized(l).avgMisalignaxL(k) = subtightplot(1,length(handles.axE),k,[0.01 0.015],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot(i,j).normalized(l));
    handles.fig(i,j).normalized(l).avgMagaxL(k).XTick = [0:50:handles.allP1d(end)];
    handles.fig(i,j).normalized(l).avgMisalignaxL(k).XTick = [0:50:handles.allP1d(end)];
    handles.fig(i,j).normalized(l).avgMagaxL(k).XGrid = 'on';
    handles.fig(i,j).normalized(l).avgMagaxL(k).YGrid = 'on';
    handles.fig(i,j).normalized(l).avgMisalignaxL(k).XGrid = 'on';
    handles.fig(i,j).normalized(l).avgMisalignaxL(k).YGrid = 'on';
    handles.fig(i,j).normalized(l).avgMagaxL(k).XLim = [0 handles.allP2d(end)+50];
    handles.fig(i,j).normalized(l).avgMisalignaxL(k).XLim = [0 handles.allP2d(end)+50];
    handles.fig(i,j).normalized(l).avgMagaxL(k).XTick = [0:50:handles.allP2d(end)];
    handles.fig(i,j).normalized(l).avgMisalignaxL(k).XTick = [0:50:handles.allP2d(end)];
    
elseif handles.REyeFlag.Value
    handles.fig(i,j).normalized(l).avgMagaxR(k) = subtightplot(1,length(handles.axE),k,[0.01 0.015],[0.10 0.075],[.05 .05],'Parent', handles.avgMagPlot(i,j).normalized(l));
    handles.fig(i,j).normalized(l).avgMisalignaxR(k) = subtightplot(1,length(handles.axE),k,[0.01 0.015],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot(i,j).normalized(l));
    handles.fig(i,j).normalized(l).avgMagaxR(k).XTick = [0:50:handles.allP1d(end)];
    handles.fig(i,j).normalized(l).avgMisalignaxR(k).XTick = [0:50:handles.allP1d(end)];
    handles.fig(i,j).normalized(l).avgMagaxR(k).XGrid = 'on';
    handles.fig(i,j).normalized(l).avgMagaxR(k).YGrid = 'on';
    handles.fig(i,j).normalized(l).avgMisalignaxR(k).XGrid = 'on';
    handles.fig(i,j).normalized(l).avgMisalignaxR(k).YGrid = 'on';
    handles.fig(i,j).normalized(l).avgMagaxR(k).XLim = [0 handles.allP2d(end)+50];
    handles.fig(i,j).normalized(l).avgMisalignaxR(k).XLim = [0 handles.allP2d(end)+50];
    handles.fig(i,j).normalized(l).avgMagaxR(k).XTick = [0:50:handles.allP2d(end)];
    handles.fig(i,j).normalized(l).avgMisalignaxR(k).XTick = [0:50:handles.allP2d(end)];
    
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
    handles.ldg3D.lines = {[handles.ldgName,num2str(handles.axE(k))]};
elseif any([strcmp(handles.ldg3D.lines,[handles.ldgName,num2str(handles.axE(k))])])
else
    handles.ldg3D.lines = [handles.ldg3D.lines,{[handles.ldgName,num2str(handles.axE(k))]}];
end
notOneInds = [];
if handles.axE(k) == 1
    toplotInds = oneInds;
else
    toplotInds = find(([handles.params.stim]==handles.figE(j)) & ([handles.params.ref]==handles.axE(k)) & ([handles.params.dSp2d]<0));
    toplotdS = find(([handles.params.stim]==handles.figE(j)) & ([handles.params.ref]==handles.axE(k)) & ([handles.params.dSp2d]>0));
end



for m = 1:length(toplotInds)
    filename = handles.listing(toplotInds(m)).name;
    
    if handles.LEyeFlag.Value
        
        figure(handles.avgMisalignPlot3DP2(i,j).normalize);
        set( handles.avgMisalignPlot3DP2(i,j).normalize,'CurrentAxes',handles.fig(i,j).avgMisalign3DP2.L);
        hold(handles.fig(i,j).avgMisalign3DP2.L,'on');
        if handles.norm.Value
            if m == 1
                mis3DPlotD = handles.params(handles.params(toplotInds(m)).normInd(l)).plotM3DL;
                switch handles.params(handles.params(toplotInds(m)).normInd(l)).p1d
                    case 25
                        DmarkerToUse = 'o';
                    case 50
                        DmarkerToUse = '+';
                    case 100
                        DmarkerToUse = '*';
                    case 200
                        DmarkerToUse = '^';
                    case 300
                        DmarkerToUse = 's';
                    case 400
                        DmarkerToUse = 'd';
                    case 800
                        DmarkerToUse = '<';
                end
                handles.fig(i,j).mis3DP2(m,k).lPlotLD(l) = plot3([0 mis3DPlotD(1)]',[0 mis3DPlotD(2)]',[0 mis3DPlotD(3)]');
                set(handles.fig(i,j).mis3DP2(m,k).lPlotLD(l),'LineWidth',3.5,'DisplayName','','Color','k')
                handles.fig(i,j).mis3DP2(m,k).pPlotLD(l) = plot3(mis3DPlotD(1),mis3DPlotD(2),mis3DPlotD(3),'o');
                set(handles.fig(i,j).mis3DP2(m,k).pPlotLD(l),'LineWidth',3.5,'DisplayName','','Marker',DmarkerToUse,'MarkerSize',15,'MarkerEdgeColor',colorPlot)
                if ~isempty(handles.ldg3D.Defaultlines)
                    if any([contains(handles.ldg3D.Defaultlines,num2str(handles.params(handles.params(toplotInds(m)).normInd(l)).p1d))])
                    else
                        handles.ldg3D.Defaultlines = [handles.ldg3D.Defaultlines,{['Default Stimulation, ',num2str(handles.params(handles.params(toplotInds(m)).normInd(l)).p1d),'p1d']}];
                        handles.fig(i,j).mis3DP2(m,k).lPlotFakeLD(l) = plot3([0 .01]',[0 .01]',[0 .01]');
                        set(handles.fig(i,j).mis3DP2(m,k).lPlotFakeLD(l),'LineWidth',3.5,'DisplayName','','Color','k','Marker',DmarkerToUse,'MarkerSize',15,'MarkerEdgeColor','k')
                        
                    end
                else
                    handles.ldg3D.Defaultlines = [handles.ldg3D.Defaultlines,{['Default Stimulation, ',num2str(handles.params(handles.params(toplotInds(m)).normInd(l)).p1d),'p1d']}];
                    handles.fig(i,j).mis3DP2(m,k).lPlotFakeLD(l) = plot3([0 .01]',[0 .01]',[0 .01]');
                    set(handles.fig(i,j).mis3DP2(m,k).lPlotFakeLD(l),'LineWidth',3.5,'DisplayName','','Color','k','Marker',DmarkerToUse,'MarkerSize',15,'MarkerEdgeColor','k')
                end
            end
            
        end
        if l == 1
            mis3DPlot = handles.params(toplotInds(m)).plotM3DL;
            handles.fig(i,j).mis3DP2(m,k).lPlotL = plot3([0 mis3DPlot(1)]',[0 mis3DPlot(2)]',[0 mis3DPlot(3)]');
            set(handles.fig(i,j).mis3DP2(m,k).lPlotL,'LineWidth',2,'DisplayName','','Color',colorPlot)
            switch handles.params(toplotInds(m)).p2d
                case 25
                    markerToUse = 'o';
                case 50
                    markerToUse = '+';
                case 100
                    markerToUse = '*';
                case 200
                    markerToUse = '^';
                case 300
                    markerToUse = 's';
                case 400
                    markerToUse = 'd';
                case 800
                    markerToUse = '<';
            end
            if m==1
                handles.fig(i,j).mis3DP2(m,k).lPlotFakeL = plot3([0 .01]',[0 .01]',[0 .01]');
                set(handles.fig(i,j).mis3DP2(m,k).lPlotFakeL,'LineWidth',2,'DisplayName','','Color',colorPlot)
            end
            if isempty(handles.ldg3DP2.AP)
                handles.ldg3DP2.AP = {[num2str(handles.params(toplotInds(m)).p2d),' uS']};
                handles.fig(i,j).mis3DP2(m,k).pPlotFakeL = plot3(0,0,0,'Marker',markerToUse,'MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2,'Linestyle', 'none');
            elseif any(strcmp(handles.ldg3DP2.AP,[num2str(handles.params(toplotInds(m)).p2d),' uS']))
            else
                handles.ldg3DP2.AP = [handles.ldg3DP2.AP,{[num2str(handles.params(toplotInds(m)).p2d),' uS']}];
                handles.fig(i,j).mis3DP2(m,k).pPlotFakeL = plot3(0,0,0,'Marker',markerToUse,'MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2,'Linestyle', 'none');
            end
            
            handles.fig(i,j).mis3DP2(m,k).pPlotL = plot3(mis3DPlot(1),mis3DPlot(2),mis3DPlot(3),'o');
            set(handles.fig(i,j).mis3DP2(m,k).pPlotL,'LineWidth',2,'DisplayName','','Marker',markerToUse,'MarkerSize',10,'MarkerEdgeColor',colorPlot)
            
            if any(handles.params(toplotInds(m)).FacialNerve)
                twitchPlotLP2 = plot3(mis3DPlot(1),mis3DPlot(2),mis3DPlot(3),'rx','MarkerSize', 20,'LineWidth',3,'Linestyle', 'none');
            end
        end
        hold(handles.fig(i,j).avgMisalign3DP2.L,'off');
        
        
        switch handles.params(toplotInds(m)).ipg
            case 0
                IPGmarker = 'o';
            case 25
                IPGmarker = '+';
            case 50
                IPGmarker = '*';
            case 100
                IPGmarker = '^';
            case 200
                IPGmarker = 's';
            case 400
                IPGmarker = 'd';
            case 600
                IPGmarker = '<';
            case 800
                IPGmarker = 'p';
        end
        
        
        figure(handles.avgMisalignPlot3Dipg(i,j).normalize)
        set( handles.avgMisalignPlot3Dipg(i,j).normalize,'CurrentAxes',handles.fig(i,j).avgMisalign3Dipg.L);
        hold(handles.fig(i,j).avgMisalign3Dipg.L,'on');
        if handles.norm.Value
            if m == 1
                handles.fig(i,j).mis3Dipg(m,k).lPlotLD(l) = plot3([0 mis3DPlotD(1)]',[0 mis3DPlotD(2)]',[0 mis3DPlotD(3)]');
                set(handles.fig(i,j).mis3Dipg(m,k).lPlotLD(l),'LineWidth',3.5,'DisplayName','','Color','k')
               handles.fig(i,j).mis3Dipg(m,k).pPlotLD(l) = plot3(mis3DPlotD(1),mis3DPlotD(2),mis3DPlotD(3),'o');
                set(handles.fig(i,j).mis3Dipg(m,k).pPlotLD(l),'LineWidth',3.5,'DisplayName','','Marker',DmarkerToUse,'MarkerSize',15,'MarkerEdgeColor',colorPlot)
            end
            
            
        end
        
        if l == 1
        handles.fig(i,j).mis3Dipg(m,k).lPlotL = plot3([0 mis3DPlot(1)]',[0 mis3DPlot(2)]',[0 mis3DPlot(3)]');
        set(handles.fig(i,j).mis3Dipg(m,k).lPlotL,'LineWidth',2,'DisplayName','','Color',colorPlot)
        
        if m==1
            handles.fig(i,j).mis3Dipg(m,k).lPlotFakeL = plot3([0 .01]',[0 .01]',[0 .01]');
            set(handles.fig(i,j).mis3Dipg(m,k).lPlotFakeL,'LineWidth',2,'DisplayName','','Color',colorPlot)
        end
        if isempty(handles.ldg3Dipg.AP)
            handles.ldg3Dipg.AP = {[num2str(handles.params(toplotInds(m)).ipg),' uS']};
            handles.fig(i,j).mis3Dipg(m,k).pPlotFakeL = plot3(0,0,0,'Marker',IPGmarker,'MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2,'Linestyle', 'none');
        elseif any(strcmp(handles.ldg3Dipg.AP,[num2str(handles.params(toplotInds(m)).ipg),' uS']))
        else
            handles.ldg3Dipg.AP = [handles.ldg3Dipg.AP,{[num2str(handles.params(toplotInds(m)).ipg),' uS']}];
            handles.fig(i,j).mis3Dipg(m,k).pPlotFakeL = plot3(0,0,0,'Marker',IPGmarker,'MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2,'Linestyle', 'none');
        end
        
        handles.fig(i,j).mis3Dipg(m,k).pPlotL = plot3(mis3DPlot(1),mis3DPlot(2),mis3DPlot(3),'o');
        set(handles.fig(i,j).mis3Dipg(m,k).pPlotL,'LineWidth',2,'DisplayName','','Marker',IPGmarker,'MarkerSize',10,'MarkerEdgeColor',colorPlot)
        
        if any(handles.params(toplotInds(m)).FacialNerve)
            twitchPlotLipg = plot3(mis3DPlot(1),mis3DPlot(2),mis3DPlot(3),'rx','MarkerSize', 20,'LineWidth',3,'Linestyle', 'none');
        end
        end
        hold(handles.fig(i,j).avgMisalign3Dipg.L,'off');
        
    end
    
    
end

if l == 1
handles.plottedInds = [handles.plottedInds toplotInds];
handles.allInds = [handles.allInds handles.plottedInds];
end
c2Use = 
if handles.LEyeFlag.Value
    figure(handles.avgMagPlot(i,j).normalized(l))
    set( handles.avgMagPlot(i,j).normalized(l),'CurrentAxes',handles.fig(i,j).normalized(l).avgMagaxL(k));
    hold(handles.fig(i,j).normalized(l).avgMagaxL(k),'on');
    x = [handles.params(toplotInds).p2d]';
    y = [handles.params(toplotInds).ipg]';
    tempz = vertcat(handles.params(toplotInds).meanMagL);
    z = tempz(:,l);
    F = scatteredInterpolant(x,y,z);
    F.Method = 'natural';
    minV = min([handles.params(toplotInds).p2d handles.params(toplotInds).ipg]');
    maxV = max([handles.params(toplotInds).p2d handles.params(toplotInds).ipg]');
    [xq,yq] = meshgrid(minV:10:maxV);
    
    F.Method = 'natural';
    vq1 = F(xq,yq);
    handles.fig(i,j).p(k).ptL = plot3(x,y,z,'LineWidth',2,'DisplayName','','Marker','o','MarkerSize',13,'MarkerEdgeColor',colorPlot,'LineStyle','none');
    handles.fig(i,j).normalized(l).avgMagaxL(k).XLim = [minV max(x)];
    handles.fig(i,j).normalized(l).avgMagaxL(k).XLabel.String = 'Phase 2 Duration (uS)';
    handles.fig(i,j).normalized(l).avgMagaxL(k).XGrid = 'On';
    handles.fig(i,j).normalized(l).avgMagaxL(k).YLim = [minV max(y)];
    handles.fig(i,j).normalized(l).avgMagaxL(k).YLabel.String = 'Interphase Gap (uS)';
    handles.fig(i,j).normalized(l).avgMagaxL(k).YGrid = 'On';
    handles.fig(i,j).normalized(l).avgMagaxL(k).ZGrid = 'On';
    handles.fig(i,j).normalized(l).avgMagaxL(k).View = [-37.5000 30];
    handles.fig(i,j).normalized(l).avgMagaxL(k).CameraPositionMode = 'auto';
    handles.fig(i,j).normalized(l).avgMagaxL(k).Title.String = ['Source ', num2str(handles.figE(j)),' Reference ',num2str(handles.axE(k))];
    handles.fig(i,j).normalized(l).avgMagaxL(k).YTick = unique(y);
    handles.fig(i,j).normalized(l).avgMagaxL(k).XTick = unique(x);
    hold on
    zlimmin = 10;
    zlimmax = -10;
    for ptS = 1:length(x)
        plot3([x(ptS) x(ptS)], [y(ptS) y(ptS)], [z(ptS)-handles.params(toplotInds(ptS)).stdMagL(l) z(ptS)+handles.params(toplotInds(ptS)).stdMagL(l)],'Color',colorPlot,'LineWidth',2);
        zlimmin = min(zlimmin,z(ptS)-handles.params(toplotInds(ptS)).stdMagL(l));
        zlimmax = max(zlimmax,z(ptS)+handles.params(toplotInds(ptS)).stdMagL(l));
    
    end
    handles.fig(i,j).p(k).surfL = mesh(xq,yq,vq1);
    handles.fig(i,j).normalized(l).avgMagaxL(k).ZLim = [round(zlimmin)-1 round(zlimmax+1)];
    hold(handles.fig(i,j).normalized(l).avgMagaxL(k),'off');
    
    
    figure(handles.avgMisalignPlot(i,j).normalized(l))
    set( handles.avgMisalignPlot(i,j).normalized(l),'CurrentAxes',handles.fig(i,j).normalized(l).avgMisalignaxL(k));
    hold(handles.fig(i,j).normalized(l).avgMisalignaxL(k),'on');
    x = [handles.params(toplotInds).p2d]';
    y = [handles.params(toplotInds).ipg]';
    tempz = vertcat(handles.params(toplotInds).meanMisalignL)
    z = tempz(:,l);
    F = scatteredInterpolant(x,y,z);
    F.Method = 'natural';
    minV = min([handles.params(toplotInds).p2d handles.params(toplotInds).ipg]');
    maxV = max([handles.params(toplotInds).p2d handles.params(toplotInds).ipg]');
    [xq,yq] = meshgrid(minV:10:maxV);
    
    F.Method = 'natural';
    vq1 = F(xq,yq);
    handles.fig(i,j).q(k).ptL = plot3(x,y,z,'LineWidth',2,'DisplayName','','Marker','o','MarkerSize',13,'MarkerEdgeColor',colorPlot,'LineStyle','none');
    handles.fig(i,j).normalized(l).avgMisalignaxL(k).XLim = [minV max(x)];
    handles.fig(i,j).normalized(l).avgMisalignaxL(k).XLabel.String = 'Phase 2 Duration (uS)';
    handles.fig(i,j).normalized(l).avgMisalignaxL(k).XGrid = 'On';
    handles.fig(i,j).normalized(l).avgMisalignaxL(k).YLim = [minV max(y)];
    handles.fig(i,j).normalized(l).avgMisalignaxL(k).YLabel.String = 'Interphase Gap (uS)';
    handles.fig(i,j).normalized(l).avgMisalignaxL(k).YGrid = 'On';
    handles.fig(i,j).normalized(l).avgMisalignaxL(k).ZGrid = 'On';
    handles.fig(i,j).normalized(l).avgMisalignaxL(k).View = [-37.5000 30];
    handles.fig(i,j).normalized(l).avgMisalignaxL(k).CameraPositionMode = 'auto';
    handles.fig(i,j).normalized(l).avgMisalignaxL(k).Title.String = ['Source ', num2str(handles.figE(j)),' Reference ',num2str(handles.axE(k))];
    handles.fig(i,j).normalized(l).avgMisalignaxL(k).YTick = unique(y);
    handles.fig(i,j).normalized(l).avgMisalignaxL(k).XTick = unique(x);
    hold on
        zlimmin = 10;
    zlimmax = -10;
    for ptS = 1:length(x)
        plot3([x(ptS) x(ptS)], [y(ptS) y(ptS)], [z(ptS)-handles.params(toplotInds(ptS)).stdMisalignL(l) z(ptS)+handles.params(toplotInds(ptS)).stdMisalignL(l)],'Color',colorPlot,'LineWidth',2);
            zlimmin = min(zlimmin,z(ptS)-handles.params(toplotInds(ptS)).stdMisalignL(l));
        zlimmax = max(zlimmax,z(ptS)+handles.params(toplotInds(ptS)).stdMisalignL(l));
    end
    handles.fig(i,j).q(k).surfL = mesh(xq,yq,vq1);
        handles.fig(i,j).normalized(l).avgMisalignaxL(k).ZLim = [round(zlimmin)-1 round(zlimmax+1)];
    hold(handles.fig(i,j).normalized(l).avgMisalignaxL(k),'off');
    
    sourceLab = 1;
%     sameaxes([], [handles.fig(i,j).normalized(l).avgMagaxL]);
%     sameaxes([], [handles.fig(i,j).normalized(l).avgMisalignaxL]);
    handles.fig(i,j).normalized(l).avgMagaxL(k).FontSize = 13.5;
    handles.fig(i,j).normalized(l).avgMisalignaxL(k).FontSize = 13.5;
    if handles.norm.Value
        if k ==1
                a = sgtitle(handles.avgMagPlot(i,j).normalized(l),{['Average Eye Velocity Magnitude, Normalized By ',num2str(handles.params(handles.params(toplotInds(1)).normInd(l)).p1d),'us First Phase Duration, ',handles.axName,num2str(handles.figE(j)),', ',handles.figdir] ; ' '},'FontSize', 22, 'FontWeight', 'Bold');
                    sgtitle(handles.avgMisalignPlot(i,j).normalized(l),{['Angle of Misalignment, Normalized By ',num2str(handles.params(handles.params(toplotInds(1)).normInd(l)).p1d),'us First Phase Duration, ',handles.axName,num2str(handles.figE(j)),', ',handles.figdir]; ' '},'FontSize', 22, 'FontWeight', 'Bold');
            zlabel(handles.fig(i,j).normalized(l).avgMagaxL(k),['Normalized Left Eye Velocity Magnitude'],'FontSize',22);
            handles.fig(i,j).normalized(l).avgMagaxL(k).FontSize = 13.5;
            zlabel(handles.fig(i,j).normalized(l).avgMisalignaxL(k),['Normalized Left Eye Velocity Misalignment'],'FontSize',22);
            handles.fig(i,j).normalized(l).avgMisalignaxL(k).FontSize = 13.5;
        end
    else
        if k ==1
                   a = sgtitle(handles.avgMagPlot(i,j).normalized(l),{['Average Eye Velocity Magnitude, ',handles.axName,num2str(handles.figE(j)),', ',handles.figdir] ; ' '},'FontSize', 22, 'FontWeight', 'Bold');
                    sgtitle(handles.avgMisalignPlot(i,j).normalized(l),{['Angle of Misalignment, ',handles.axName,num2str(handles.figE(j)),', ',handles.figdir]; ' '},'FontSize', 22, 'FontWeight', 'Bold');
            zlabel(handles.fig(i,j).normalized(l).avgMagaxL(k),'Left Eye Velocity Magnitude (dps)','FontSize',22);
            handles.fig(i,j).normalized(l).avgMagaxL(k).FontSize = 13.5;
            zlabel(handles.fig(i,j).normalized(l).avgMisalignaxL(k),'Left Eye Velocity Misalignment (degrees)','FontSize',22);
            handles.fig(i,j).normalized(l).avgMisalignaxL(k).FontSize = 13.5;
        end
    end
            if any([handles.params(toplotInds).FacialNerve])
                trueFace = find([handles.params(toplotInds).FacialNerve]);
                for xs = 1:length(trueFace)
                figure(handles.avgMisalignPlot(i,j).normalized(l))
                set( handles.avgMisalignPlot(i,j).normalized(l),'CurrentAxes',handles.fig(i,j).normalized(l).avgMisalignaxL(k));
                hold(handles.fig(i,j).normalized(l).avgMisalignaxL(k),'on') 
                handles.cutOff1 = plot3(handles.fig(i,j).normalized(l).avgMisalignaxL(k),handles.params(toplotInds(trueFace(xs))).p2d,handles.params(toplotInds(trueFace(xs))).ipg,handles.params(toplotInds(trueFace(xs))).meanMisalignL,'rx','MarkerSize', 20,'LineWidth',3);
                hold(handles.fig(i,j).normalized(l).avgMisalignaxL(k),'off')
                
                figure(handles.avgMagPlot(i,j).normalized(l))
                set( handles.avgMagPlot(i,j).normalized(l),'CurrentAxes',handles.fig(i,j).normalized(l).avgMagaxL(k));
                hold(handles.fig(i,j).normalized(l).avgMagaxL(k),'on')
                handles.cutOff2 = plot3(handles.fig(i,j).normalized(l).avgMagaxL(k),handles.params(toplotInds(trueFace(xs))).p2d,handles.params(toplotInds(trueFace(xs))).ipg,handles.params(toplotInds(trueFace(xs))).meanMagL,'rx','MarkerSize', 20,'LineWidth',3);
                hold(handles.fig(i,j).normalized(l).avgMagaxL(k),'off')
                end
            end
    
    
    
end



if (k == length(handles.axE)) && (l == handles.currmaxNorm)
    twitchLDG = 0;
    sourceLab = 0;
    if handles.LEyeFlag.Value
        if handles.norm.Value
            if any([handles.params(handles.plottedInds).FacialNerve]) && ~twitchLDG
                ldg3DP2 = legend(handles.fig(i,j).avgMisalign3DP2.L,[handles.fig(i,j).mis3DP2.lPlotFakeL handles.fig(i,j).mis3DP2.lPlotFakeLD handles.fig(i,j).mis3DP2.pPlotFakeL twitchPlotLP2],[handles.ldg3D.lines handles.ldg3D.Defaultlines handles.ldg3DP2.AP {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
                ldg3Dipg = legend(handles.fig(i,j).avgMisalign3Dipg.L,[handles.fig(i,j).mis3Dipg.lPlotFakeL handles.fig(i,j).mis3DP2.lPlotFakeLD handles.fig(i,j).mis3Dipg.pPlotFakeL twitchPlotLP2],[handles.ldg3D.lines handles.ldg3D.Defaultlines handles.ldg3Dipg.AP {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
                
                twitchLDG = 1;
            else
                ldg3D = legend(handles.fig(i,j).avgMisalign3DP2.L,[handles.fig(i,j).mis3DP2.lPlotFakeL handles.fig(i,j).mis3DP2.lPlotFakeLD handles.fig(i,j).mis3DP2.pPlotFakeL],[handles.ldg3D.lines handles.ldg3D.Defaultlines handles.ldg3DP2.AP],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
                ldg3Dipg = legend(handles.fig(i,j).avgMisalign3Dipg.L,[handles.fig(i,j).mis3Dipg.lPlotFakeL handles.fig(i,j).mis3DP2.lPlotFakeLD handles.fig(i,j).mis3Dipg.pPlotFakeL],[handles.ldg3D.lines handles.ldg3D.Defaultlines handles.ldg3Dipg.AP],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
                
                twitchLDG = 1;
            end
            
        else
            if any(handles.params(toplotInds).FacialNerve) && ~twitchLDG
                ldg3D = legend(handles.fig(i,j).avgMisalign3DP2.L,[handles.fig(i,j).mis3DP2.lPlotFakeL handles.fig(i,j).mis3DP2.pPlotFakeL twitchPlotLP2],[handles.ldg3D.lines handles.ldg3DP2.AP {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
                ldg3Dipg = legend(handles.fig(i,j).avgMisalign3Dipg.L,[handles.fig(i,j).mis3Dipg.lPlotFakeL handles.fig(i,j).mis3Dipg.pPlotFakeL twitchPlotLP2],[handles.ldg3D.lines handles.ldg3Dipg.AP {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
                
                twitchLDG = 1;
            else
                ldg3D = legend(handles.fig(i,j).avgMisalign3DP2.L,[handles.fig(i,j).mis3DP2.lPlotFakeL handles.fig(i,j).mis3DP2.pPlotFakeL],[handles.ldg3D.lines handles.ldg3DP2.AP],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
                ldg3Dipg = legend(handles.fig(i,j).avgMisalign3Dipg.L,[handles.fig(i,j).mis3Dipg.lPlotFakeL handles.fig(i,j).mis3Dipg.pPlotFakeL twitchPlotLP2],[handles.ldg3D.lines handles.ldg3Dipg.AP],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
                
                twitchLDG = 1;
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
                misalgn3DP2Name = [handles.figDir,'\eyeMisalignment3D_Phase2Duration_ByStimE_R&Leye_Stim',num2str(handles.figE(j)),'_',ecombName,handles.figdir];
                misalgn3DipgName = [handles.figDir,'\eyeMisalignment3D_InterphaseGap_ByStimE_R&Leye_Stim',num2str(handles.figE(j)),'_',ecombName,handles.figdir];
            elseif handles.referenceE.Value
                misalgn3DP2Name = [handles.figDir,'\eyeMisalignment3D_Phase2Duration_ByRefE_R&Leye_Ref',num2str(handles.axE(j)),'_',ecombName,handles.figdir];
                misalgn3DipgName = [handles.figDir,'\eyeMisalignment3D_InterphaseGap_ByRefE_R&Leye_Ref',num2str(handles.figE(j)),'_',ecombName,handles.figdir];
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
                    misalgn3DP2Name = [handles.figDir,'\eyeMisalignment3D_Default',normName,'P1D_Phase2Duration_ByStimE_Leye_Stim',num2str(handles.figE(j)),'_',ecombName,handles.figdir];
                    misalgn3DipgName = [handles.figDir,'\eyeMisalignment3D_Default',normName,'P1D_InterphaseGap_ByStimE_Leye_Stim',num2str(handles.figE(j)),'_',ecombName,handles.figdir];
                elseif handles.referenceE.Value
                    misalgn3DP2Name = [handles.figDir,'\eyeMisalignment3D_Default',normName,'P1D_Phase2Duration_ByRefE_Leye_Ref',num2str(handles.axE(j)),'_',ecombName,handles.figdir];
                    misalgn3DipgName = [handles.figDir,'\eyeMisalignment3D_Default',normName,'P1D_InterphaseGap_ByRefE_Leye_Ref',num2str(handles.axE(j)),'_',ecombName,handles.figdir];
                end
            else
                if handles.stimulatingE.Value
                    misalgn3DP2Name = [handles.figDir,'\eyeMisalignment3D_Phase2Duration_ByStimE_Leye_Stim',num2str(handles.figE(j)),'_',ecombName,handles.figdir];
                    misalgn3DipgName = [handles.figDir,'\eyeMisalignment3D_InterphaseGap_ByStimE_Leye_Stim',num2str(handles.figE(j)),'_',ecombName,handles.figdir];
                elseif handles.referenceE.Value
                    misalgn3DP2Name = [handles.figDir,'\eyeMisalignment3D_Phase2Duration_ByRefE_Leye_Ref',num2str(handles.axE(j)),'_',ecombName,handles.figdir];
                    misalgn3DipgName = [handles.figDir,'\eyeMisalignment3D_InterphaseGap_ByRefE_Leye_Ref',num2str(handles.axE(j)),'_',ecombName,handles.figdir];
                end
            end
        elseif handles.REyeFlag.Value
            if handles.stimulatingE.Value
                misalgn3DP2Name = [handles.figDir,'\eyeMisalignment3D_Phase2Duration_ByStimE_Reye_Stim',num2str(handles.figE(j)),'_',handles.figdir];
                misalgn3DipgName = [handles.figDir,'\eyeMisalignment3D_InterphaseGap_ByStimE_Reye_Stim',num2str(handles.figE(j)),'_',handles.figdir];
            elseif handles.referenceE.Value
                misalgn3DP2Name = [handles.figDir,'\eyeMisalignment3D_Phase2Duration_InterphaseGap_ByRefE_Reye_Ref',num2str(handles.axE(j)),'_',handles.figdir];
                misalgn3DipgName = [handles.figDir,'\eyeMisalignment3D_InterphaseGap_ByRefE_Reye_Ref',num2str(handles.axE(j)),'_',handles.figdir];
            end
        end
        saveas(handles.avgMisalignPlot3DP2(i,j).normalize,[misalgn3DP2Name,'.svg']);
        saveas(handles.avgMisalignPlot3DP2(i,j).normalize,[misalgn3DP2Name,'.jpg']);
        saveas(handles.avgMisalignPlot3DP2(i,j).normalize,[misalgn3DP2Name,'.fig']);
        close(handles.avgMisalignPlot3DP2(i,j).normalize);
        saveas(handles.avgMisalignPlot3Dipg(i,j).normalize,[misalgn3DipgName,'.svg']);
        saveas(handles.avgMisalignPlot3Dipg(i,j).normalize,[misalgn3DipgName,'.jpg']);
        saveas(handles.avgMisalignPlot3Dipg(i,j).normalize,[misalgn3DipgName,'.fig']);
        close(handles.avgMisalignPlot3Dipg(i,j).normalize);
        
    end
    handles.ldgNames = {};
    handles.lines = zeros(1,length(handles.axE));
    for rN = 1:length(handles.axE)
        handles.ldgNames{rN} = ' ';
    end
    
    
    for rN = 1:length(handles.axE)
        handles.ldgNames{rN} = ['Return ',num2str(handles.axE(rN)),' Sample Points'];
        handles.lines(rN) = [handles.fig(i,j).q(rN).ptL];
        
    end
    start = length(handles.axE);
    if any(strcmp(handles.ldgNames,'Interpolated Surface'))
    else
        handles.ldgNames{start+1} = 'Interpolated Surface';
        handles.lines(start+1) = handles.fig(i,j).p.surfL;
    end
    normName = [];
    for ltimes = 1:length([handles.params(handles.params(toplotInds(1)).normInd).p1d])
                            temp = {handles.params(handles.params(toplotInds(1)).normInd).p1d};
                        normName = num2str(temp{ltimes});
                        
    if handles.LEyeFlag.Value + handles.REyeFlag.Value == 2
        t=[handles.params(handles.plottedInds).FacialNerve];
        if any(t)
            ldg1 = legend(handles.fig(i,j).normalized(l).avgMagaxR(k),[handles.lines handles.cutOff1],[handles.ldgNames {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','horizontal');
            ldg2 = legend(handles.fig(i,j).normalized(l).avgMisalignaxR(k),[handles.lines handles.cutOff1],[handles.ldgNames {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','horizontal');
            ldg1.Position = [0.4 0.01 0.1308 0.0192];
            ldg2.Position = [0.4 0.01 0.1308 0.0192];
            ldg1.FontSize = 13.5;
            ldg2.FontSize = 13.5;
        else
            ldg1 = legend(handles.fig(i,j).normalized(l).avgMagaxR(k),handles.lines,handles.ldgNames,'Orientation','horizontal');
            ldg2 = legend(handles.fig(i,j).normalized(l).avgMisalignaxR(k),handles.lines,handles.ldgNames,'Orientation','horizontal');
            ldg1.Position = [0.4 0.01 0.1308 0.0192];
            ldg2.Position = [0.4 0.01 0.1308 0.0192];
            ldg1.FontSize = 13.5;
            ldg2.FontSize = 13.5;
        end
        
        
        %*[0.7940    0.0297    0.1153;-0.8296    0.0283   -0.1883;0.7940    0.0297    0.1153]
        if handles.stimulatingE.Value
            misalgnName = [handles.figDir,'\eyeMisalignment_ByStim',num2str(handles.figE(j)),'_R&Leye_',handles.figdir];
            velName = [handles.figDir,'\eyeVelocity_ByStime',num2str(handles.figE(j)),'_R&Leye_',handles.figdir];
        elseif handles.referenceE.Value
            misalgnName = [handles.figDir,'\eyeMisalignment_ByRef',num2str(handles.axE(j)),'_R&Leye_',handles.figdir];
            velName = [handles.figDir,'\eyeVelocity_ByRef',num2str(handles.retunrNum(j)),'_R&Leye_',handles.figdir];
        end
        
    elseif handles.LEyeFlag.Value
        t=[handles.params(handles.plottedInds).FacialNerve];
        if any(t)
            ldg1 = legend(handles.fig(i,j).normalized(l).avgMagaxL(k),[handles.lines handles.cutOff1],[handles.ldgNames {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','horizontal','AutoUpdate','off');
            ldg2 = legend(handles.fig(i,j).normalized(l).avgMisalignaxL(k),[handles.lines handles.cutOff1],[handles.ldgNames {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','horizontal','AutoUpdate','off');
            ldg1.Position = [0.4 0.01 0.1308 0.0192];
            ldg2.Position = [0.4 0.01 0.1308 0.0192];
            ldg1.FontSize = 13.5;
            ldg2.FontSize = 13.5;
        else
                ldg1 = legend(handles.fig(i,j).normalized(ltimes).avgMagaxL(k),handles.lines,handles.ldgNames,'Orientation','horizontal','AutoUpdate','off');
                ldg2 = legend(handles.fig(i,j).normalized(ltimes).avgMisalignaxL(k),handles.lines,handles.ldgNames,'Orientation','horizontal','AutoUpdate','off');
                ldg1.Position = [0.4 0.01 0.1308 0.0192];
                ldg2.Position = [0.4 0.01 0.1308 0.0192];
                ldg1.FontSize = 13.5;
                ldg2.FontSize = 13.5;
        end
        
        
        %*[0.7940    0.0297    0.1153;-0.8296    0.0283   -0.1883;0.7940    0.0297    0.1153]
        if handles.stimulatingE.Value
            if handles.norm.Value
                handles.avgMisalignPlot(i,j).normalized(ltimes).Name = [handles.figDir,'\NormalizedeyeMisalignmentBy',normName,'P1D_vs_Phase2Duration_vs_IPG_3D_ByStim',num2str(handles.figE(j)),ecombName,'_Leye_',handles.figdir];
                handles.avgMagPlot(i,j).normalized(ltimes).Name = [handles.figDir,'\NormalizedeyeVelocityBy',normName,'P1D_vs_Phase2Duration_vs_IPG_3D_ByStim',num2str(handles.figE(j)),ecombName,'_Leye_',handles.figdir];
            else
                handles.avgMisalignPlot(i,j).normalized(ltimes).Name = [handles.figDir,'\eyeMisalignment_vs_Phase2Duration_vs_IPG_3D_ByStim',num2str(handles.figE(j)),ecombName,'_Leye_',handles.figdir];
                handles.avgMagPlot(i,j).normalized(ltimes).Name = [handles.figDir,'\eyeVelocity_vs_Phase2Duration_vs_IPG_3D_ByStim',num2str(handles.figE(j)),ecombName,'_Leye_',handles.figdir];
            end
        elseif handles.referenceE.Value
            if handles.norm.Value
                handles.avgMisalignPlot(i,j).normalized(ltimes).Name = [handles.figDir,'\NormalizedeyeMisalignmentBy',normName,'P1D_vs_Phase2Duration_vs_IPG_3D_ByRef',num2str(handles.axE(j)),'_Leye_',handles.figdir];
                handles.avgMagPlot(i,j).normalized(ltimes).Name = [handles.figDir,'\NormalizedeyeVelocityBy',normName,'P1D_vs_Phase2Duration_vs_IPG_3D_ByRef',num2str(handles.axE(j)),'_Leye_',handles.figdir];
            else
                handles.avgMisalignPlot(i,j).normalized(ltimes).Name = [handles.figDir,'\eyeMisalignment_vs_Phase2Duration_vs_IPG_3D_ByRef',num2str(handles.axE(j)),'_Leye_',handles.figdir];
                handles.avgMagPlot(i,j).normalized(ltimes).Name = [handles.figDir,'\eyeVelocity_vs_Phase2Duration_vs_IPG_3D_ByRef',num2str(handles.axE(j)),'_Leye_',handles.figdir];
            end
        end
        
        
    elseif handles.REyeFlag.Value
        t=[];
        for tpts = 1:length(handles.fig)
            t = [t [handles.fig(tpts).cycles(:).twitch]];
        end
        if any(t)
            ldg1 = legend(handles.fig(i,j).normalized(l).avgMagaxR(k),[handles.lines handles.cutOff1],[handles.ldgNames {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','horizontal');
            ldg2 = legend(handles.fig(i,j).normalized(l).avgMisalignaxR(k),[handles.lines handles.cutOff1],[handles.ldgNames {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','horizontal');
            ldg1.Position = [0.4 0.01 0.1308 0.0192];
            ldg2.Position = [0.4 0.01 0.1308 0.0192];
            ldg1.FontSize = 13.5;
            ldg2.FontSize = 13.5;
        else
            ldg1 = legend(handles.fig(i,j).normalized(l).avgMagaxR(k),handles.lines,handles.ldgNames,'Orientation','horizontal');
            ldg2 = legend(handles.fig(i,j).normalized(l).avgMisalignaxR(k),handles.lines,handles.ldgNames,'Orientation','horizontal');
            ldg1.Position = [0.4 0.01 0.1308 0.0192];
            ldg2.Position = [0.4 0.01 0.1308 0.0192];
            ldg1.FontSize = 13.5;
            ldg2.FontSize = 13.5;
        end
        
        
        %*[0.7940    0.0297    0.1153;-0.8296    0.0283   -0.1883;0.7940    0.0297    0.1153]
        if handles.stimulatingE.Value
            misalgnName = [handles.figDir,'\eyeMisalignment_ByStimE_Reye_',handles.figdir];
            velName = [handles.figDir,'\eyeVelocity_ByStimeE_Reye_',handles.figdir];
        elseif handles.referenceE.Value
            misalgnName = [handles.figDir,'\eyeMisalignment_ByRefE_Reye_',handles.figdir];
            velName = [handles.figDir,'\eyeVelocity_ByRefE_Reye_',handles.figdir];
        end
    end
    end
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
