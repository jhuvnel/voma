function handles = plotCurrentAsXSaveComp(handles,i,j,k,l)
ePosFig = getePos(handles,handles.figE(j));
ePosAx = getePos(handles,handles.axE(k));
animal = handles.configByAnimal.String{handles.configByAnimal.Value};

if (k == 1) && (j == 1) && (i == 1)
    handles.fBar = waitbar(0,['Processing ',num2str(length(handles.listing)),' Files'],'Name','File Progress');
handles.done = 0;
            handles.avgMisalignPlot3D = figure('units','normalized','outerposition',[0 0 1 1],'Visible','off');
        sgtitle(handles.avgMisalignPlot3D,{['3D Angle of Misalignment, ',handles.axName,ePosFig,', ',handles.figdir]; ' '},'FontSize', 22, 'FontWeight', 'Bold');
    handles.avgMagPlot = figure('units','normalized','outerposition',[0 0 1 1],'Visible','off');
    handles.avgMisalignPlot = figure('units','normalized','outerposition',[0 0 1 1],'Visible','off');
    sgtitle(handles.avgMagPlot,{['Average Eye Velocity Magnitude, ',handles.figdir] ; ' '},'FontSize', 22, 'FontWeight', 'Bold');
    sgtitle(handles.avgMisalignPlot,{['Angle of Misalignment, ',handles.figdir]; ' '},'FontSize', 22, 'FontWeight', 'Bold');
        if handles.LEyeFlag.Value + handles.REyeFlag.Value == 2
            handles.avgMisalign3D.R = subtightplot(1,2,1,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot3D);
            handles.avgMisalign3D.L = subtightplot(1,2,2,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot3D);
            handles.avgMisalign3D.R.XGrid = 'on';
            handles.avgMisalign3D.R.YGrid = 'on';
            handles.avgMisalign3D.L.XGrid = 'on';
            handles.avgMisalign3D.L.YGrid = 'on';
            handles.avgMisalign3D.L.Title.String = 'Left Eye 3D Misalignment';
            handles.avgMisalign3D.L.FontSize = 13.5;
            handles.avgMisalign3D.R.Title.String = 'Right Eye 3D Misalignment';
            handles.avgMisalign3D.R.FontSize = 13.5;
            
        handles.avgMagaxL = subtightplot(2,length(handles.figE),j,[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMagPlot);
        handles.avgMagaxR = subtightplot(2,length(handles.figE),j+length(handles.figE),[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMagPlot);
        
        handles.avgMisalignaxL = subtightplot(2,length(handles.figE),j,[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot);
        handles.avgMisalignaxR = subtightplot(2,length(handles.figE),j+length(handles.figE),[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot);
        
        handles.avgMagaxL.XTickLabel = [];
        handles.avgMagaxR.XTick = [0:50:handles.allP1a(end)];
        handles.avgMisalignaxL.XTickLabel = [];
        handles.avgMisalignaxR.XTick = [0:50:handles.allP1a(end)];
        handles.avgMagaxL.XGrid = 'on';
        handles.avgMagaxR.XGrid = 'on';
        handles.avgMagaxL.YGrid = 'on';
        handles.avgMagaxR.YGrid = 'on';
        handles.avgMisalignaxL.XGrid = 'on';
        handles.avgMisalignaxR.XGrid = 'on';
        handles.avgMisalignaxL.YGrid = 'on';
        handles.avgMisalignaxR.YGrid = 'on';
        handles.avgMagaxR.XLim = [0 handles.allP1a(end)+50];
        handles.avgMagaxL.XLim = [0 handles.allP1a(end)+50];
        handles.avgMisalignaxR.XLim = [0 handles.allP1a(end)+50];
        handles.avgMisalignaxL.XLim = [0 handles.allP1a(end)+50];
        handles.avgMagaxR.XTick = [0:50:handles.allP1a(end)];
        handles.avgMisalignaxR.XTick = [0:50:handles.allP1a(end)];
            
            
        elseif handles.LEyeFlag.Value
            
            handles.avgMisalign3D.L = axes('Parent', handles.avgMisalignPlot3D);
            handles.avgMisalign3D.L.XGrid = 'on';
            handles.avgMisalign3D.L.YGrid = 'on';
            handles.avgMisalign3D.L.Title.String = 'Left Eye 3D Misalignment, Phase 2 Duration';
            handles.avgMisalign3D.L.FontSize = 13.5;
            
            handles.avgMagaxL = subtightplot(1,length(handles.figE),j,[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMagPlot);
        handles.avgMisalignaxL = subtightplot(1,length(handles.figE),j,[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot);
        handles.avgMagaxL.XTick = [0:50:handles.allP1a(end)];
        handles.avgMisalignaxL.XTick = [0:50:handles.allP1a(end)];
        handles.avgMagaxL.XGrid = 'on';
        handles.avgMagaxL.YGrid = 'on';
        handles.avgMisalignaxL.XGrid = 'on';
        handles.avgMisalignaxL.YGrid = 'on';
        handles.avgMagaxL.XLim = [0 handles.allP1a(end)+50];
        handles.avgMisalignaxL.XLim = [0 handles.allP1a(end)+50];
        handles.avgMagaxL.XTick = [0:50:handles.allP1a(end)];
        handles.avgMisalignaxL.XTick = [0:50:handles.allP1a(end)];
        elseif handles.REyeFlag.Value
            
            handles.avgMisalign3D.R = axes('Parent', handles.avgMisalignPlot3D);
            handles.avgMisalign3D.R.XGrid = 'on';
            handles.avgMisalign3D.R.YGrid = 'on';
            handles.avgMisalign3D.R.Title.String = 'Right Eye 3D Misalignment';
            handles.avgMisalign3D.R.FontSize = 13.5;
            
            handles.avgMagaxR = subtightplot(1,length(handles.figE),j,[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMagPlot);
        handles.avgMisalignaxR = subtightplot(1,length(handles.figE),j,[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot);
        handles.avgMagaxR.XTick = [0:50:handles.allP1a(end)];
        handles.avgMisalignaxR.XTick = [0:50:handles.allP1a(end)];
        handles.avgMagaxR.XGrid = 'on';
        handles.avgMagaxR.YGrid = 'on';
        handles.avgMisalignaxR.XGrid = 'on';
        handles.avgMisalignaxR.YGrid = 'on';
        handles.avgMagaxR.XLim = [0 handles.allP1a(end)+50];
        handles.avgMisalignaxR.XLim = [0 handles.allP1a(end)+50];
        handles.avgMagaxR.XTick = [0:50:handles.allP1a(end)];
        handles.avgMisalignaxR.XTick = [0:50:handles.allP1a(end)];
        end
        
        if handles.LEyeFlag.Value
            set(0,'CurrentFigure',handles.avgMisalignPlot3D);
            set( handles.avgMisalignPlot3D,'CurrentAxes',handles.avgMisalign3D.L)
            hold(handles.avgMisalign3D.L,'on');
            h=plot3vect([1/sqrt(2);-1/sqrt(2);0],'LARP Axis',[0 1 0],2);
            set(h,'LineStyle','--','Marker','o');
            h=plot3vect([1/sqrt(2);1/sqrt(2);0],'RALP Axis',[0 1 1],2);
            set(h,'LineStyle','--','Marker','o');
            h=plot3vect([0;0;1],'Yaw Axis',[0.68 0 0],2);
            set(h,'LineStyle','--','Marker','o');
            
            [x,y,z]=sphere();
            h=surf(0.5*x,0.5*y,0.5*z);
            set(h,'FaceColor','white')
            handles.avgMisalign3D.L.View = [90 -0.5];
            axis vis3d
            axis equal
            box on;
            xlim([-1 1])
            ylim([-1 1])
            zlim([-1 1])
            hold(handles.avgMisalign3D.L,'off');
            
            
        end
        
        if handles.REyeFlag.Value
            set( handles.avgMisalignPlot3D,'CurrentAxes',handles.avgMisalign3D.R)
            hold(handles.avgMisalign3D.R,'on');
            h=plot3vect([1/sqrt(2);-1/sqrt(2);0],'LARP Axis',[0 1 0],2);
            set(h,'LineStyle','--','Marker','o');
            h=plot3vect([1/sqrt(2);1/sqrt(2);0],'RALP Axis',[0 1 1],2);
            set(h,'LineStyle','--','Marker','o');
            h=plot3vect([0;0;1],'Yaw Axis',[0.68 0 0],2);
            set(h,'LineStyle','--','Marker','o');
            
            [x,y,z]=sphere();
            h=surf(0.5*x,0.5*y,0.5*z);
            set(h,'FaceColor','white')
            handles.avgMisalign3D.R.View = [90 -0.5];
            axis vis3d
            axis equal
            box on;
            xlim([-1 1])
            ylim([-1 1])
            zlim([-1 1])
            hold(handles.avgMisalign3D.R,'off');
            
        end
end
    handles.ldgNames = {};
    handles.lines = zeros(1,length(handles.axE));
    handles.plottedInds =[];
    handles.allInds = [];
            handles.ldg3D.lines = {};
        handles.ldg3D.Defaultlines = {};
        handles.ldg3D.AP = {};



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

if handles.stimulatingE.Value
    toplotInds = find(([handles.params.stim]==handles.figE(j)) & ([handles.params.ref]==handles.axE(k)) & ([handles.params.dSp2d]<0));
elseif handles.referenceE.Value
    toplotInds = find(([handles.params.stim]==handles.axE(k)) & ([handles.params.ref]==handles.figE(j)) & ([handles.params.dSp2d]<0));
end

handles.saved(handles.savePos).names = [];

for m = 1:length(toplotInds)
    stNum = (['stim',num2str(handles.params(toplotInds(m)).stim)]);
    reNum = (['ref',num2str(handles.params(toplotInds(m)).ref)]);
    ampNum = ['amp',num2str(handles.params(toplotInds(m)).p1amp)];
    date = ['date',num2str(handles.params(toplotInds(m)).date)];
    handles.saved(handles.savePos).names = [handles.saved(handles.savePos).names; {handles.params(toplotInds(m)).name}];
    if handles.stimulatingE.Value
        term = 'source';
    elseif handles.referenceE.Value
        term = 'ref';
    end
    if handles.LEyeFlag.Value
        
        set(0,'CurrentFigure',handles.avgMisalignPlot3D);
        set(handles.avgMisalignPlot3D,'CurrentAxes',handles.avgMisalign3D.L);
        hold(handles.avgMisalign3D.L,'on');
        
            mis3DPlot = handles.params(toplotInds(m)).plotM3DL;
            handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).amp = handles.params(toplotInds(m)).p1amp;
            handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).lines.PlotL = plot3([0 mis3DPlot(1)]',[0 mis3DPlot(2)]',[0 mis3DPlot(3)]');
            set(handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).lines.PlotL,'LineWidth',2,'DisplayName','','Color',colorPlot)
            handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).lines.PlotFakeL = plot3([0 .01]',[0 .01]',[0 .01]');
            set(handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).lines.PlotFakeL,'LineWidth',2,'DisplayName','','Color',colorPlot)
            handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).lines.ldgNameL = {ePosAx};  
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

                handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).point.ldgNameL = {[num2str(handles.params(toplotInds(m)).p1amp),' uA']};
                handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).point.PlotFakeL = plot3(0,0,0,'Marker',markerToUse,'MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2,'Linestyle', 'none');
            
            handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).point.PlotL = plot3(mis3DPlot(1),mis3DPlot(2),mis3DPlot(3),'o');
            set(handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).point.PlotL,'LineWidth',2,'DisplayName','','Marker',markerToUse,'MarkerSize',10,'MarkerEdgeColor',colorPlot)
            
            if any(handles.params(toplotInds(m)).FacialNerve)
                handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).point.twitchPlotL = plot3(mis3DPlot(1),mis3DPlot(2),mis3DPlot(3),'rx','MarkerSize', 20,'LineWidth',3,'Linestyle', 'none');
            handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).point.ldgNameL = [handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).point.ldgNameL {'Cutoff Due To Facial Nerve Stimulation'}];
            
            lpfl = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).lines.PlotFakeL;
            ppfl = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).point.PlotFakeL;
            tpl = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).point.twitchPlotL;
            lll = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).lines.ldgNameL;
            lpl = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).point.ldgNameL;
            handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).ldgL = legend(handles.avgMisalign3D.L,[lpfl ppfl tpl],[lll lpl],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
            else
                handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).point.twitchPlotL = 0;
                
            lpfl = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).lines.PlotFakeL;
            ppfl = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).point.PlotFakeL;
            lll = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).lines.ldgNameL;
            lpl = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).point.ldgNameL;
            handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).ldgL = legend(handles.avgMisalign3D.L,[lpfl ppfl],[lll lpl],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);

            end
         hold(handles.avgMisalign3D.L,'off');   
        end
        
       
    
    if handles.REyeFlag.Value
        
        set(0,'CurrentFigure',handles.avgMisalignPlot3D);
        set( handles.avgMisalignPlot3D,'CurrentAxes',handles.avgMisalign3D.R);
        hold(handles.avgMisalign3D.R,'on');
        
                    mis3DPlot = handles.params(toplotInds(m)).plotM3DR;
            handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).amp = handles.params(toplotInds(m)).p1amp;
            handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).lines.PlotR = plot3([0 mis3DPlot(1)]',[0 mis3DPlot(2)]',[0 mis3DPlot(3)]');
            set(handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).lines.PlotR,'LineWidth',2,'DisplayName','','Color',colorPlot)
            handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).lines.PlotFakeR = plot3([0 .01]',[0 .01]',[0 .01]');
            set(handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).lines.PlotFakeR,'LineWidth',2,'DisplayName','','Color',colorPlot)
            handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).lines.ldgNameR = {ePosAx};  
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

                handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).point.ldgNameR = {[num2str(handles.params(toplotInds(m)).p1amp),' uA']};
                handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).point.PlotFakeR = plot3(0,0,0,'Marker',markerToUse,'MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2,'Linestyle', 'none');
            
            handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).point.PlotR = plot3(mis3DPlot(1),mis3DPlot(2),mis3DPlot(3),'o');
            set(handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).point.PlotR,'LineWidth',2,'DisplayName','','Marker',markerToUse,'MarkerSize',10,'MarkerEdgeColor',colorPlot)
            
            if any(handles.params(toplotInds(m)).FacialNerve)
                handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).point.twitchPlotR = plot3(mis3DPlot(1),mis3DPlot(2),mis3DPlot(3),'rx','MarkerSize', 20,'LineWidth',3,'Linestyle', 'none');
                       handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).point.ldgNameR = [handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).point.ldgNameR {'Cutoff Due To Facial Nerve Stimulation'}];
                       
            lpfr = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).lines.PlotFakeR;
            ppfr = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).point.PlotFakeR;
            tpr = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).point.twitchPlotR;
            llr = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).lines.ldgNameR;
            lpr = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).point.ldgNameR;
            handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).ldgR = legend(handles.avgMisalign3D.R,[lpfr ppfr tpr],[llr lpr],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);

            else
                handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).point.twitchPlotR = 0;
                lpfr = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).lines.PlotFakeR;
            ppfr = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).point.PlotFakeR;
            llr = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).lines.ldgNameR;
            lpr = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).point.ldgNameR;
            handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).mis3D(m).ldgR = legend(handles.avgMisalign3D.R,[lpfr ppfr],[llr lpr],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);

            end
        hold(handles.avgMisalign3D.R,'off');
        end
        
    
    
    if handles.LEyeFlag.Value
        set(0,'CurrentFigure',handles.avgMagPlot)
        set( handles.avgMagPlot,'CurrentAxes',handles.avgMagaxL);
        hold(handles.avgMagaxL,'on');
        handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.point(m).ampL = handles.params(toplotInds(m)).p1amp;
        handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.point(m).velL = handles.params(toplotInds(m)).meanMagL;
        handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.point(m).PlotL = plot(handles.avgMagaxL,handles.params(toplotInds(m)).p1amp,handles.params(toplotInds(m)).meanMagL,'color',colorPlot,'marker','o','MarkerSize',10,'LineWidth',2);
        handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.point(m).erPlotL = errorbar(handles.avgMagaxL,handles.params(toplotInds(m)).p1amp,handles.params(toplotInds(m)).meanMagL,handles.params(toplotInds(m)).stdMagL,'color',colorPlot,'LineWidth',2.5);
        handles.avgMagaxL.LineWidth = 2.5;
        if handles.params(toplotInds(m)).FacialNerve
            handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.point(m).twitchPlotL = plot(handles.avgMagaxL,handles.params(toplotInds(m)).p1amp,handles.params(toplotInds(m)).meanMagL,'rx','MarkerSize', 20,'LineWidth',3);
        else
            handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.point(m).twitchPlotL = 0;
        end
        hold(handles.avgMagaxL,'off');
        
        set(0,'CurrentFigure',handles.avgMisalignPlot)
        set( handles.avgMisalignPlot,'CurrentAxes',handles.avgMisalignaxL);
        hold(handles.avgMisalignaxL,'on')
        handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.point(m).ampL = handles.params(toplotInds(m)).p1amp;
        handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.point(m).misL = handles.params(toplotInds(m)).meanMisalignL;
        handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.point(m).PlotL = plot(handles.avgMisalignaxL,handles.params(toplotInds(m)).p1amp,handles.params(toplotInds(m)).meanMisalignL,'color',colorPlot,'marker','o','MarkerSize',10,'LineWidth',2);
        handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.point(m).erPlotL = errorbar(handles.avgMisalignaxL,handles.params(toplotInds(m)).p1amp,handles.params(toplotInds(m)).meanMisalignL,handles.params(toplotInds(m)).stdMisalignL,'color',colorPlot,'LineWidth',2.5);
        handles.avgMisalignaxL.LineWidth = 2.5;
        if handles.params(toplotInds(m)).FacialNerve
            handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.point(m).twitchPlotL = plot(handles.avgMisalignaxL,handles.params(toplotInds(m)).p1amp,handles.params(toplotInds(m)).meanMisalignL,'rx','MarkerSize', 20,'LineWidth',3);
        else
            handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.point(m).twitchPlotL = 0;
        end
        hold(handles.avgMisalignaxL,'off');
    end
    
    if handles.REyeFlag.Value
        set(0,'CurrentFigure',handles.avgMagPlot)
        set( handles.avgMagPlot,'CurrentAxes',handles.avgMagaxR);
        hold(handles.avgMagaxR,'on');
        handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.point(m).ampR = handles.params(toplotInds(m)).p1amp;
        handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.point(m).velR = handles.params(toplotInds(m)).meanMagR;
        handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.point(m).PlotR = plot(handles.avgMagaxR,handles.params(toplotInds(m)).p1amp,handles.params(toplotInds(m)).meanMagR,'color',colorPlot,'marker','o','MarkerSize',10,'LineWidth',2);
        handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.point(m).erPlotR = errorbar(handles.avgMagaxR,handles.params(toplotInds(m)).p1amp,handles.params(toplotInds(m)).meanMagR,handles.params(toplotInds(m)).stdMagR,'color',colorPlot,'LineWidth',2.5);
        handles.avgMagaxR.LineWidth = 2.5;
        if handles.params(toplotInds(m)).FacialNerve
            handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.point(m).twitchPlotR = plot(handles.avgMagaxR,handles.params(toplotInds(m)).p1amp,handles.params(toplotInds(m)).meanMagR,'rx','MarkerSize', 20,'LineWidth',3);
        else
            handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.point(m).twitchPlotR = 0;
        end
        hold(handles.avgMagaxR,'off');
        
        set(0,'CurrentFigure',handles.avgMisalignPlot)
        set( handles.avgMisalignPlot,'CurrentAxes',handles.avgMisalignaxR);
        hold(handles.avgMisalignaxR,'on')
        handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.point(m).ampR = handles.params(toplotInds(m)).p1amp;
        handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.point(m).misR = handles.params(toplotInds(m)).meanMisalignR;
        handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.point(m).PlotR = plot(handles.avgMisalignaxR,handles.params(toplotInds(m)).p1amp,handles.params(toplotInds(m)).meanMisalignR,'color',colorPlot,'marker','o','MarkerSize',10,'LineWidth',2);
        handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.point(m).erPlotR = errorbar(handles.avgMisalignaxR,handles.params(toplotInds(m)).p1amp,handles.params(toplotInds(m)).meanMisalignR,handles.params(toplotInds(m)).stdMisalignR,'color',colorPlot,'LineWidth',2.5);
        handles.avgMisalignaxR.LineWidth = 2.5;
        if handles.params(toplotInds(m)).FacialNerve
            handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.point(m).twitchPlotR = plot(handles.avgMisalignaxR,handles.params(toplotInds(m)).p1amp,handles.params(toplotInds(m)).meanMisalignR,'rx','MarkerSize', 20,'LineWidth',3);
        else
            handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.point(m).twitchPlotR = 0;
        end
        hold(handles.avgMisalignaxR,'off');
    end
  handles.done = handles.done +1;
      waitbar(handles.done/length(handles.listing),handles.fBar,['Processing ',num2str(handles.done),':',num2str(length(handles.listing)),' Files'])

end
handles.plottedInds = [handles.plottedInds toplotInds];
if j == length(handles.figE)
    handles.allInds = [handles.allInds handles.plottedInds];
end


if handles.LEyeFlag.Value

    set(0,'CurrentFigure',handles.avgMagPlot)
    set(handles.avgMagPlot,'CurrentAxes',handles.avgMagaxL);
    hold(handles.avgMagaxL,'on');
    handles.avgMagaxL.Title.String = [term,ePosFig];
    x = [handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.point.ampL];
    y = [handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.point.velL];
    [x,inds]=sort(x);
    y = y(inds);
    handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.line.plotL = line(handles.avgMagaxL,x,y,'color',colorPlot,'LineWidth',4);
    handles.avgMagaxL.XLabel.String = {'Current (uA)'};
    handles.avgMagaxL.XLabel.FontSize = 22;
        handles.avgMagaxL.YLabel.String = {'Velocity (dps)'};
        handles.avgMagaxL.YLabel.FontSize = 22;
    ePosAx = getePos(handles,handles.axE(k));
        if handles.stimulatingE.Value
                handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.ldgNameL = {['Return, ',ePosAx]};
        elseif handles.referenceE.Value
                handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.ldgNameL = ['Source, ',ePosAx];
        end
        
        vlpl = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.line.plotL;
        
        if any([handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.point.twitchPlotL]~=0)
                    handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.ldgNameL = [handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.ldgNameL {'Cutoff Due To Facial Nerve Stimulation'}];
        vnpl = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.ldgNameL;
        a = find([handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.point.twitchPlotL]~=0,1);
        vtpl = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.point(a).twitchPlotL;
                     handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.ldgL = legend(handles.avgMagaxL,[vlpl vtpl],[vnpl],'Orientation','horizontal');    
        else
            vnpl = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.ldgNameL;
             handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.ldgL = legend(handles.avgMagaxL,[vlpl],[vnpl],'Orientation','horizontal');      
        end
        handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.ldgL.Position = [0.4 0.01 0.1308 0.0192];
        handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.ldgL.FontSize = 13.5;
    hold(handles.avgMagaxL,'off');
    
    set(0,'CurrentFigure',handles.avgMisalignPlot)
    set( handles.avgMisalignPlot,'CurrentAxes',handles.avgMisalignaxL);
    hold(handles.avgMisalignaxL,'on')
    handles.avgMisalignaxL.Title.String = [term,ePosFig];
    x = [handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.point.ampL];
    y = [handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.point.misL];
    [x,inds]=sort(x);
    y = y(inds);
    handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.line.plotL = line(handles.avgMisalignaxL,x,y,'color',colorPlot,'LineWidth',4);
    handles.avgMisalignaxL.XLabel.String = {'Current (uA)'};
    handles.avgMisalignaxL.XLabel.FontSize = 22;
        handles.avgMisalignaxL.YLabel.String = {'Misalignment (degrees)'};
        handles.avgMisalignaxL.YLabel.FontSize = 22;
            ePosAx = getePos(handles,handles.axE(k));
        if handles.stimulatingE.Value
                handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.ldgNameL = ['Return, ',ePosAx];
        elseif handles.referenceE.Value
                handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.ldgNameL = ['Source, ',ePosAx];
        end
        mlpl = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.line.plotL;
        
        if any([handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.point.twitchPlotL]~=0)
                    handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.ldgNameL = [handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.ldgNameL {'Cutoff Due To Facial Nerve Stimulation'}];
        mnpl = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.ldgNameL;
        a = find([handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.point.twitchPlotL]~=0,1);
        mtpl = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.point(a).twitchPlotL;
                     handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.ldgL = legend(handles.avgMisalignaxL,[mlpl mtpl],[mnpl],'Orientation','horizontal');    
        else
            mnpl = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.ldgNameL;
             handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.ldgL = legend(handles.avgMisalignaxL,[mlpl],[mnpl],'Orientation','horizontal');      
        end
        handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.ldgL.Position = [0.4 0.01 0.1308 0.0192];
        handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.ldgL.FontSize = 13.5;
    hold(handles.avgMisalignaxL,'off');
end

if handles.REyeFlag.Value

    set(0,'CurrentFigure',handles.avgMagPlot)
    set( handles.avgMagPlot,'CurrentAxes',handles.avgMagaxR);
    hold(handles.avgMagaxR,'on');
    handles.avgMagaxR.Title.String = [term,ePosFig];
    x = [handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.point.ampR];
    y = [handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.point.velR];
    handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.line.plotR = line(handles.avgMagaxR,x,y,'color',colorPlot,'LineWidth',4);
    handles.avgMagaxR.XLabel.String = {'Current (uA)'};
    handles.avgMagaxR.XLabel.FontSize = 22;
                ePosAx = getePos(handles,handles.axE(k));
        if handles.stimulatingE.Value
                handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.ldgNameR = ['Return, ',ePosAx];
        elseif handles.referenceE.Value
                handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.ldgNameR = ['Source, ',ePosAx];
        end
        vlpr = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.line.plotR;
        
        if any([handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.point.twitchPlotR]~=0)
                    handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.ldgNameR = [handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.ldgNameR {'Cutoff Due To Facial Nerve Stimulation'}];
        vnpr = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.ldgNameR;
        a = find([handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.point.twitchPlotR]~=0,1);
        vtpr = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.point(a).twitchPlotR;
                     handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.ldgR = legend(handles.avgMagaxR,[vlpr vtpr],[vnpr],'Orientation','horizontal');    
        else
            vnpr = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.ldgNameR;
             handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.ldgR = legend(handles.avgMagaxR,[vlpr],[vnpr],'Orientation','horizontal');      
        end
        handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.ldgR.Position = [0.4 0.01 0.1308 0.0192];
        handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magV.ldgR.FontSize = 13.5;
    hold(handles.avgMagaxR,'off');
    
    set(0,'CurrentFigure',handles.avgMisalignPlot)
    set( handles.avgMisalignPlot,'CurrentAxes',handles.avgMisalignaxR);
    hold(handles.avgMisalignaxR,'on')
    handles.avgMisalignaxR.Title.String = [term,ePosFig];
    x = [handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.point.ampR];
    y = [handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.point.misR];
    handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.line.plotR = line(handles.avgMisalignaxR,x,y,'color',colorPlot,'LineWidth',4);
    handles.avgMisalignaxR.XLabel.String = {'Current (uA)'};
    handles.avgMisalignaxR.XLabel.FontSize = 22;
                ePosAx = getePos(handles,handles.axE(k));
        if handles.stimulatingE.Value
                handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.ldgNameR = ['Return, ',ePosAx];
        elseif handles.referenceE.Value
                handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.ldgNameR = ['Source, ',ePosAx];
        end
        
        mlpr = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.line.plotR;
        
        if any([handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.point.twitchPlotR]~=0)
                    handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.ldgNameR = [handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.ldgNameR {'Cutoff Due To Facial Nerve Stimulation'}];
        mnpr = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.ldgNameR;
        a = find([handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.point.twitchPlotR]~=0,1);
        mtpr = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.point(a).twitchPlotR;
                     handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.ldgR = legend(handles.avgMisalignaxR,[mlpr mtpr],[mnpr],'Orientation','horizontal');    
        else
            mnpr = handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.ldgNameR;
             handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.ldgR = legend(handles.avgMisalignaxR,[mlpr],[mnpr],'Orientation','horizontal');      
        end
        handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.ldgR.Position = [0.4 0.01 0.1308 0.0192];
        handles.(animal).(date).(handles.figdir).(stNum).(reNum).(term).magM.ldgR.FontSize = 13.5;
    hold(handles.avgMisalignaxR,'off');
end
handles.saved(handles.savePos).animal = animal;
handles.saved(handles.savePos).date = date;
handles.saved(handles.savePos).dir = handles.figdir;
handles.saved(handles.savePos).stim = stNum;
handles.saved(handles.savePos).ref = reNum;
handles.saved(handles.savePos).ePlot = term;
% if (k==length(handles.axE))
% if isfile('Plots.mat')
%     load('Plots.mat')
%     for q = 1:length(handles.saved)
%         eqA = [];
%         for q2 = 1:length(Plots.saved)
%             if isequal(handles.saved(q),Plots.saved(q2))
%                 eqA = [eqA 1];
%             else
%                 eqA = [eqA 0];
%             end
%         end
%         if ~(any(eqA))
%             a = handles.saved(q).animal;
%             d = handles.saved(q).date;
%             fd = handles.saved(q).dir;
%             s = handles.saved(q).stim;
%             r = handles.saved(q).ref;
%             e = handles.saved(q).ePlot;
%             Plots.(a).(d).(fd).(s).(r).(e) = handles.(a).(d).(fd).(s).(r).(e);
%             Plots.saved = [Plots.saved handles.saved(q)];
%             if q == length(handles.saved)
%                 save('Plots.mat','Plots')
%             end
%         end
%         
%     end
% else
%     Plots = struct();
%     Plots.(animal) = handles.(animal);
%     Plots.saved = handles.saved;
%     save('Plots.mat','Plots')
% end
% if handles.LEyeFlag.Value
% cla(handles.avgMisalign3D.L)
% cla(handles.avgMagaxL)
% cla(handles.avgMisalignaxL)
% end
% if handles.REyeFlag.Value
% cla(handles.avgMisalign3D.R)
% cla(handles.avgMagaxR)
% cla(handles.avgMisalignaxR)
% end
% end
    handles.savePos = handles.savePos+1;
% if (k == length(handles.axE)) && (j == length(handles.figE))
%     close(handles.avgMisalignPlot3D)
%     close(handles.avgMagPlot)
%     close(handles.avgMisalignPlot)
% end

function ePos = getePos(handles,j)
ePos = '';
switch handles.configByAnimal.Value
    case 1%GiGi
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
                ePos = 'Left Anterior, Middle';
            case 6
                ePos = 'Left Anterior, Deep';
            case 7
                ePos = 'Left Horizontal, Deep';
            case 8
                ePos = 'Left Horizontal, Middle';
            case 9
                ePos = 'Left Horizontal, Shallow';
            case 10
                ePos = 'Distant';
            case 11
                ePos = 'Common Crus';
        end
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
