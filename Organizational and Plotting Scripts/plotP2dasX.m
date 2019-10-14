function handles = plotP2dasX(handles,i,j)
            handles.avgMisalignPlot3D(j) = figure('units','normalized','outerposition',[0 0 1 1]);
            sgtitle(handles.avgMisalignPlot3D(j),{['3D Angle of Misalignment, Stim ',num2str(handles.stimNum(j)),', ',handles.figdir]; ' '},'FontSize', 22, 'FontWeight', 'Bold');
if handles.LEyeFlag.Value + handles.REyeFlag.Value == 2
    
    handles.fig(i,j).avgMagaxL = subtightplot(2,length(handles.stimNum),j,[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMagPlot(i));
    handles.fig(i,j).avgMagaxR = subtightplot(2,length(handles.stimNum),j+length(handles.stimNum),[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMagPlot(i));
    
    handles.fig(i,j).avgMisalignaxL = subtightplot(2,length(handles.stimNum),j,[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot(i));
    handles.fig(i,j).avgMisalignaxR = subtightplot(2,length(handles.stimNum),j+length(handles.stimNum),[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot(i));
    
    handles.fig(i,j).avgMagaxL.XTickLabel = [];
    handles.fig(i,j).avgMagaxR.XTick = [0:50:handles.allP2d(end)];
    handles.fig(i,j).avgMisalignaxL.XTickLabel = [];
    handles.fig(i,j).avgMisalignaxR.XTick = [0:50:handles.allP2d(end)];
    handles.fig(i,j).avgMagaxL.XGrid = 'on';
    handles.fig(i,j).avgMagaxR.XGrid = 'on';
    handles.fig(i,j).avgMagaxL.YGrid = 'on';
    handles.fig(i,j).avgMagaxR.YGrid = 'on';
    handles.fig(i,j).avgMisalignaxL.XGrid = 'on';
    handles.fig(i,j).avgMisalignaxR.XGrid = 'on';
    handles.fig(i,j).avgMisalignaxL.YGrid = 'on';
    handles.fig(i,j).avgMisalignaxR.YGrid = 'on';
    handles.fig(i,j).avgMagaxR.XLim = [0 handles.allP2d(end)+50];
    handles.fig(i,j).avgMagaxL.XLim = [0 handles.allP2d(end)+50];
    handles.fig(i,j).avgMisalignaxR.XLim = [0 handles.allP2d(end)+50];
    handles.fig(i,j).avgMisalignaxL.XLim = [0 handles.allP2d(end)+50];
    handles.fig(i,j).avgMagaxR.XTick = [0:50:handles.allP2d(end)];
    handles.fig(i,j).avgMisalignaxR.XTick = [0:50:handles.allP2d(end)];
    
    
    
    handles.fig(i,j).avgMisalign3D.R = subtightplot(1,2,1,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot3D(j));
    handles.fig(i,j).avgMisalign3D.L = subtightplot(1,2,2,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot3D(j));
    handles.fig(i,j).avgMisalign3D.R.XGrid = 'on';
    handles.fig(i,j).avgMisalign3D.R.YGrid = 'on';
    handles.fig(i,j).avgMisalign3D.L.XGrid = 'on';
    handles.fig(i,j).avgMisalign3D.L.YGrid = 'on';
    handles.fig(i,j).avgMisalign3D.L.Title.String = 'Left Eye 3D Misalignment';
    handles.fig(i,j).avgMisalign3D.L.FontSize = 13.5;
    handles.fig(i,j).avgMisalign3D.R.Title.String = 'Right Eye 3D Misalignment';
    handles.fig(i,j).avgMisalign3D.R.FontSize = 13.5;
elseif handles.LEyeFlag.Value
    
    handles.fig(i,j).avgMagaxL = subtightplot(1,length(handles.stimNum),j,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMagPlot(i));
    handles.fig(i,j).avgMisalignaxL = subtightplot(1,length(handles.stimNum),j,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot(i));
    handles.fig(i,j).avgMagaxL.XTick = [0:50:handles.allP1d(end)];
    handles.fig(i,j).avgMisalignaxL.XTick = [0:50:handles.allP1d(end)];
    handles.fig(i,j).avgMagaxL.XGrid = 'on';
    handles.fig(i,j).avgMagaxL.YGrid = 'on';
    handles.fig(i,j).avgMisalignaxL.XGrid = 'on';
    handles.fig(i,j).avgMisalignaxL.YGrid = 'on';
    handles.fig(i,j).avgMagaxL.XLim = [0 handles.allP2d(end)+50];
    handles.fig(i,j).avgMisalignaxL.XLim = [0 handles.allP2d(end)+50];
    handles.fig(i,j).avgMagaxL.XTick = [0:50:handles.allP2d(end)];
    handles.fig(i,j).avgMisalignaxL.XTick = [0:50:handles.allP2d(end)];
    
    
    handles.fig(i,j).avgMisalign3D.L = axes('Parent', handles.avgMisalignPlot3D(j));
    handles.fig(i,j).avgMisalign3D.L.XGrid = 'on';
    handles.fig(i,j).avgMisalign3D.L.YGrid = 'on';
    handles.fig(i,j).avgMisalign3D.L.Title.String = 'Left Eye 3D Misalignment';
    handles.fig(i,j).avgMisalign3D.L.FontSize = 13.5;
elseif handles.REyeFlag.Value
    
    handles.fig(i,j).avgMagaxR = subtightplot(1,length(handles.stimNum),j,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMagPlot(i));
    handles.fig(i,j).avgMisalignaxR = subtightplot(1,length(handles.stimNum),j,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot(i));
    handles.fig(i,j).avgMagaxR.XTick = [0:50:handles.allP1d(end)];
    handles.fig(i,j).avgMisalignaxR.XTick = [0:50:handles.allP1d(end)];
    handles.fig(i,j).avgMagaxR.XGrid = 'on';
    handles.fig(i,j).avgMagaxR.YGrid = 'on';
    handles.fig(i,j).avgMisalignaxR.XGrid = 'on';
    handles.fig(i,j).avgMisalignaxR.YGrid = 'on';
    handles.fig(i,j).avgMagaxR.XLim = [0 handles.allP2d(end)+50];
    handles.fig(i,j).avgMisalignaxR.XLim = [0 handles.allP2d(end)+50];
    handles.fig(i,j).avgMagaxR.XTick = [0:50:handles.allP2d(end)];
    handles.fig(i,j).avgMisalignaxR.XTick = [0:50:handles.allP2d(end)];
    
    
    handles.fig(i,j).avgMisalign3D.R = axes('Parent', handles.avgMisalignPlot3D(j));
    handles.fig(i,j).avgMisalign3D.R.XGrid = 'on';
    handles.fig(i,j).avgMisalign3D.R.YGrid = 'on';
    handles.fig(i,j).avgMisalign3D.R.Title.String = 'Right Eye 3D Misalignment';
    handles.fig(i,j).avgMisalign3D.R.FontSize = 13.5;
end
handles.ldg3D.lines = {};
handles.ldg3D.AP = {};

if handles.LEyeFlag.Value
    set( handles.avgMisalignPlot3D(j),'CurrentAxes',handles.fig(i,j).avgMisalign3D.L)
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
    
    if j>1
        handles.fig(i,j).avgMagaxL.YTickLabel = [];
        handles.fig(i,j).avgMisalignaxL.YTickLabel = [];
    end
end

if handles.REyeFlag.Value
    set( handles.avgMisalignPlot3D(j),'CurrentAxes',handles.fig(i,j).avgMisalign3D.R)
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
    if j>1
        handles.fig(i,j).avgMagaxR.YTickLabel = [];
        handles.fig(i,j).avgMisalignaxR.YTickLabel = [];
    end
end

if handles.bipolarstim.Value
    handles.returnNum = handles.returnNum(~(handles.returnNum==handles.stimNum(j)));
end
go = 1;
returnTest = 1;
oneInds = [];
otherInds = [];

while go
    if handles.returnNum(returnTest)==1
        oneInds = find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(handles.returnNum(returnTest))]));
        if ~isempty(find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(10)])))
            otherInds = [otherInds find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(10)]))];
        end
        if ~isempty(find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(11)])))
            otherInds = [otherInds find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(11)]))];
        end
        if ~isempty(find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(12)])))
            otherInds = [otherInds find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(11)]))];
        end
        if ~isempty(find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(13)])))
            otherInds = [otherInds find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(11)]))];
        end
        if ~isempty(find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(14)])))
            otherInds = [otherInds find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(11)]))];
        end
        if ~isempty(find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(15)])))
            otherInds = [otherInds find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(11)]))];
        end
        if isequal(oneInds,otherInds)
            handles.returnNum(returnTest) = [];
            returnTest = returnTest - 1;
        else
            oneInds = oneInds(~ismember(oneInds,otherInds));
        end
    else
        if ~isempty(find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(handles.returnNum(returnTest))])))
            
        else
            handles.returnNum(returnTest) = [];
            returnTest = returnTest - 1;
        end
    end
    
    if returnTest == length(handles.returnNum)
        go = 0;
    end
    returnTest = returnTest + 1;
end

for k = 1:length(handles.returnNum)
                    switch handles.returnNum(k)
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
                        handles.ldg3D.lines = {['Return ',num2str(handles.returnNum(k))]};
                    elseif strcmp(handles.ldg3D.lines,['Return ',num2str(handles.returnNum(k))])
                    else
                        handles.ldg3D.lines = [handles.ldg3D.lines,{['Return ',num2str(handles.returnNum(k))]}];
                    end
                    notOneInds = [];
                    if handles.returnNum(k) == 1
                        toplotInds = oneInds;
                    else
                        toplotInds = find(([handles.params.stim]==handles.stimNum(j)) & ([handles.params.ref]==handles.returnNum(k)) & ([handles.params.dSp2d]<0));
                        toplotdS = find(([handles.params.stim]==handles.stimNum(j)) & ([handles.params.ref]==handles.returnNum(k)) & ([handles.params.dSp2d]>0));
                    end
                    for z = 1:length(toplotdS)
                        load(handles.listing(toplotdS(z)).name)
                        if handles.LEyeFlag.Value
                            cycavgL = [Results.ll_cycavg' Results.lr_cycavg' Results.lz_cycavg'];
                            tL = 1/Results.Fs:1/Results.Fs:length(Results.ll_cycavg)/Results.Fs;
                            timeL = [tL' tL' tL'];
                            stdL = [Results.ll_cycstd' Results.lr_cycstd' Results.lz_cycstd'];
                            
                            d = diff(Results.ll_cyc');
                            
                            maxMagL = [];
                            avgMisalignL = [];
                            misalign3DL = [];
                            for s = 1:size(d,2)
                                [avgMisalignCycL, maxMagCycL, wL] = maxMagThreshL(s,handles,Results);
                                avgMisalignL = [avgMisalignL; avgMisalignCycL];
                                maxMagL = [maxMagL; maxMagCycL];
                                misalign3DL = [misalign3DL; wL];
                            end
                        end
                        handles.params(toplotdS(z)).maxMagL = maxMagL;
                        handles.params(toplotdS(z)).avgMisalignL = avgMisalignL;
                        handles.params(toplotdS(z)).meanM3DL = misalign3DL;
                        if handles.REyeFlag.Value
                            cycavgR = [Results.rl_cycavg' Results.rr_cycavg' Results.rz_cycavg'];
                            tR = 1/Results.Fs:1/Results.Fs:length(Results.rl_cycavg)/Results.Fs;
                            timeR = [tL' tL' tL'];
                            stdR = [Results.rl_cycstd' Results.rr_cycstd' Results.rz_cycstd'];
                            
                            d = diff(Results.rl_cyc');
                            
                            maxMagR = [];
                            avgMisalignR = [];
                            misalign3DR = [];
                            for s = 1:size(d,2)
                                [avgMisalignCycR, maxMagCycR, wR] = maxMagThreshR(s,handles,Results);
                                avgMisalignR = [avgMisalignR; avgMisalignCycR];
                                maxMagR = [maxMagR; maxMagCycR];
                                misalign3DR = [misalign3DR; wR];
                            end
                            handles.params(toplotdS(z)).maxMagR = maxMagR;
                            handles.params(toplotdS(z)).avgMisalignR = avgMisalignR;
                            handles.params(toplotdS(z)).meanM3DR = misalign3DR;
                            
                        end
                    end
                    for l = 1:length(toplotInds)
                        load(handles.listing(toplotInds(l)).name)
                        filename = handles.listing(toplotInds(l)).name;
                        handles.fig(i,j).cycles(l,k).stim = handles.stimNum(j);
                        handles.fig(i,j).cycles(l,k).ref = handles.returnNum(k);
                        handles.fig(i,j).cycles(l,k).axis = handles.figdir;
                        handles.fig(i,j).cycles(l,k).p1amp = handles.params(toplotInds(l)).p1amp;
                        handles.fig(i,j).cycles(l,k).p2amp = handles.params(toplotInds(l)).p2amp;
                        handles.fig(i,j).cycles(l,k).p1d = handles.params(toplotInds(l)).p1d;
                        handles.fig(i,j).cycles(l,k).p2d = handles.params(toplotInds(l)).p2d;
                        handles.fig(i,j).cycles(l,k).ipg = handles.params(toplotInds(l)).ipg;
                        handles.fig(i,j).cycles(l,k).dSp2d = handles.params(toplotInds(l)).dSp2d;
                        handles.fig(i,j).cycles(l,k).twitch = Results.FacialNerve;
                        
                        if handles.LEyeFlag.Value
                            handles.fig(i,j).cycles(l,k).cycavgL = [Results.ll_cycavg' Results.lr_cycavg' Results.lz_cycavg'];
                            tL = 1/Results.Fs:1/Results.Fs:length(Results.ll_cycavg)/Results.Fs;
                            handles.fig(i,j).cycles(l,k).timeL = [tL' tL' tL'];
                            handles.fig(i,j).cycles(l,k).stdL = [Results.ll_cycstd' Results.lr_cycstd' Results.lz_cycstd'];
                            
                            d = diff(Results.ll_cyc');
                            
                            maxMagL = [];
                            avgMisalignL = [];
                            misalign3DL = [];
                            for s = 1:size(d,2)
                                [avgMisalignCycL, maxMagCycL, wL] = maxMagThreshL(s,handles,Results);
                                avgMisalignL = [avgMisalignL; avgMisalignCycL];
                                maxMagL = [maxMagL; maxMagCycL];
                                misalign3DL = [misalign3DL; wL];
                            end
                            if handles.norm.Value
                                avgMisalignL = avgMisalignL./mean(handles.params(handles.params(toplotInds(l)).normInd).avgMisalignL);
                                maxMagL = maxMagL./mean(handles.params(handles.params(toplotInds(l)).normInd).maxMagL);
                                 mis3DPlotD = mean(handles.params(handles.params(toplotInds(l)).normInd).meanM3DL);
                            
                            end
                            handles.fig(i,j).cycles(l,k).maxMagL = maxMagL;
                            handles.fig(i,j).cycles(l,k).avgMisalignL = avgMisalignL;
                            meanM = mean(misalign3DL);
                            handles.fig(i,j).cycles(l,k).avgmisalign3DL = meanM/norm(meanM);
                            rot = [cosd(-45) -sind(-45) 0;...
                                sind(-45) cosd(-45) 0;...
                                0 0 1];
                            mis3DPlot = (rot*handles.fig(i,j).cycles(l,k).avgmisalign3DL')';
                            set( handles.avgMisalignPlot3D(j),'CurrentAxes',handles.fig(i,j).avgMisalign3D.L);
                            hold(handles.fig(i,j).avgMisalign3D.L,'on');
                            if handles.norm.Value
                                if l == 1
                                    mis3DPlotD = (rot*(mis3DPlotD/norm(mis3DPlotD))')';
                                    
                                    handles.fig(i,j).mis3D(l,k).lPlotLD = plot3([0 mis3DPlotD(1)]',[0 mis3DPlotD(2)]',[0 mis3DPlotD(3)]');
                                    set(handles.fig(i,j).mis3D(l,k).lPlotLD,'LineWidth',3,'DisplayName','','Color','k')
                                    handles.fig(i,j).mis3D.lPlotFakeLD = plot3([0 .01]',[0 .01]',[0 .01]');
                                set(handles.fig(i,j).mis3D(l,k).lPlotFakeLD,'LineWidth',3,'DisplayName','','Color','k')
                                handles.fig(i,j).mis3D(l,k).pPlotLD = plot3(mis3DPlotD(1),mis3DPlotD(2),mis3DPlotD(3),'o');
                                set(handles.fig(i,j).mis3D(l,k).pPlotLD,'LineWidth',3,'DisplayName','','Marker','^','MarkerSize',10,'MarkerEdgeColor','k')
                                handles.ldg3D.lines = [handles.ldg3D.lines,{['Default Stimulation, Return ',num2str(handles.returnNum(k))]}];
                                end
                                
                                
                            end
                            handles.fig(i,j).mis3D(l,k).lPlotL = plot3([0 mis3DPlot(1)]',[0 mis3DPlot(2)]',[0 mis3DPlot(3)]');
                            set(handles.fig(i,j).mis3D(l,k).lPlotL,'LineWidth',2,'DisplayName','','Color',colorPlot)
                            switch handles.fig(i,j).cycles(l,k).p2d
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
                            if l==1
                                handles.fig(i,j).mis3D(l,k).lPlotFakeL = plot3([0 .01]',[0 .01]',[0 .01]');
                                set(handles.fig(i,j).mis3D(l,k).lPlotFakeL,'LineWidth',2,'DisplayName','','Color',colorPlot)
                            end
                            if isempty(handles.ldg3D.AP)
                                handles.ldg3D.AP = {[num2str(handles.fig(i,j).cycles(l,k).p2d),' uS']};
                                handles.fig(i,j).mis3D(l,k).pPlotFakeL = plot3(0,0,0,'Marker',markerToUse,'MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2,'Linestyle', 'none');
                            elseif any(strcmp(handles.ldg3D.AP,[num2str(handles.fig(i,j).cycles(l,k).p2d),' uS']))
                            else
                                handles.ldg3D.AP = [handles.ldg3D.AP,{[num2str(handles.fig(i,j).cycles(l,k).p2d),' uS']}];
                                handles.fig(i,j).mis3D(l,k).pPlotFakeL = plot3(0,0,0,'Marker',markerToUse,'MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2,'Linestyle', 'none');
                            end
                            
                            handles.fig(i,j).mis3D(l,k).pPlotL = plot3(mis3DPlot(1),mis3DPlot(2),mis3DPlot(3),'o');
                            set(handles.fig(i,j).mis3D(l,k).pPlotL,'LineWidth',2,'DisplayName','','Marker',markerToUse,'MarkerSize',10,'MarkerEdgeColor',colorPlot)
                            
                            if any(handles.fig(i,j).cycles(l,k).twitch)
                                twitchPlotL = plot3(mis3DPlot(1),mis3DPlot(2),mis3DPlot(3),'rx','MarkerSize', 20,'LineWidth',3,'Linestyle', 'none');
                            end
                            hold(handles.fig(i,j).avgMisalign3D.L,'off');
                            
                            switch handles.fig(i,j).cycles(l,k).ipg
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
                   
                            set( handles.avgMagPlot(i),'CurrentAxes',handles.fig(i,j).avgMagaxL);
                            hold(handles.fig(i,j).avgMagaxL,'on');
                            handles.fig(i,j).p(k).ptL(l) = plot(handles.fig(i,j).avgMagaxL,handles.fig(i,j).cycles(l,k).p2d,mean(handles.fig(i,j).cycles(l,k).maxMagL),'color',colorPlot,'marker',IPGmarker,'MarkerSize',10,'LineWidth',2);
                            handles.fig(i,j).cycles(l,k).VstdevL =  std(handles.fig(i,j).cycles(l,k).maxMagL);
                            errorbar(handles.fig(i,j).avgMagaxL,handles.fig(i,j).cycles(l,k).p2d,mean(handles.fig(i,j).cycles(l,k).maxMagL),handles.fig(i,j).cycles(l,k).VstdevL,'color',colorPlot,'LineWidth',2.5);
                            handles.fig(i,j).avgMagaxL.LineWidth = 2.5;
                            if any(strcmp(handles.ldgV,[num2str(handles.fig(i,j).cycles(l,k).ipg),' uS IPG']))
                            else
                                handles.ldgV = [handles.ldgV,{[num2str(handles.fig(i,j).cycles(l,k).ipg),' uS IPG']}];
                                handles.fig(i,j).p(k).ptLFake(l) = plot(handles.fig(i,j).avgMagaxL,-10,0,'Marker',IPGmarker,'MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2,'Linestyle', 'none');
                            end
                            hold(handles.fig(i,j).avgMagaxL,'off');
                            
                            set( handles.avgMisalignPlot(i),'CurrentAxes',handles.fig(i,j).avgMisalignaxL);
                            hold(handles.fig(i,j).avgMisalignaxL,'on');
                            handles.fig(i,j).q(k).ptL(l) = plot(handles.fig(i,j).avgMisalignaxL,handles.fig(i,j).cycles(l,k).p2d,mean(handles.fig(i,j).cycles(l,k).avgMisalignL),'color',colorPlot,'marker',IPGmarker,'MarkerSize',10,'LineWidth',2);
                            
                            handles.fig(i,j).cycles(l,k).MstdevL =  std(handles.fig(i,j).cycles(l,k).avgMisalignL);
                            errorbar(handles.fig(i,j).avgMisalignaxL,handles.fig(i,j).cycles(l,k).p2d,mean(handles.fig(i,j).cycles(l,k).avgMisalignL),handles.fig(i,j).cycles(l,k).MstdevL,'color',colorPlot,'LineWidth',2.5);
                            
                            handles.fig(i,j).avgMisalignaxL.LineWidth = 2.5;
                            hold(handles.fig(i,j).avgMisalignaxL,'off');
                            
                        end
                        
                    end
                    if handles.LEyeFlag.Value
                        set( handles.avgMagPlot(i),'CurrentAxes',handles.fig(i,j).avgMagaxL);
                        hold(handles.fig(i,j).avgMagaxL,'on');
                        handles.fig(i,j).p(k).LFake(k) = line(handles.fig(i,j).avgMagaxL,[-10 -10],[handles.fig(i,j).p(k).ptL(1:2).YData],'color',colorPlot,'LineWidth',4)
                        hold(handles.fig(i,j).avgMagaxL,'off');
                        handles.fig(i,j).avgMagaxL.XLabel.String = {'Second Phase Duration (uS)'};
                        handles.fig(i,j).avgMagaxL.XLabel.FontSize = 22;
                        
                        handles.fig(i,j).avgMisalignaxL.XLabel.String = {'Second Phase Duration (uS)'};
                        handles.fig(i,j).avgMisalignaxL.XLabel.FontSize = 22;
                    end
                    if handles.REyeFlag.Value
                        set( handles.avgMagPlot(i),'CurrentAxes',handles.fig(i,j).avgMagaxR);
                        hold(handles.fig(i,j).avgMagaxR,'on');
                        handles.fig(i,j).p(k).RFake(k) = line(handles.fig(i,j).avgMagaxR,[-10 -10],[handles.fig(i,j).p(k).ptR.YData],'color',colorPlot,'LineWidth',4)
                        hold(handles.fig(i,j).avgMagaxR,'off');
                        handles.fig(i,j).avgMagaxR.XLabel.String = {'Second Phase Duration (uS)'};
                        handles.fig(i,j).avgMagaxR.XLabel.FontSize = 22;

                        handles.fig(i,j).avgMisalignaxR.XLabel.String = {'Second Phase Duration (uS)'};
                        handles.fig(i,j).avgMisalignaxR.XLabel.FontSize = 22;
                    end
                    if handles.REyeFlag.Value && handles.LEyeFlag.Value
                        handles.fig(i,j).avgMagaxL.XLabel.String = '';
                        handles.fig(i,j).avgMisalignaxL.XLabel.String = '';
                    end
                    
end
twitchLDG = 0;
                sourceLab = 0;
                if handles.LEyeFlag.Value
                    if handles.norm.Value
                        if any(handles.fig(i,j).cycles(l,k).twitch) && ~twitchLDG
                            ldg3D = legend(handles.fig(i,j).avgMisalign3D.L,[handles.fig(i,j).mis3D.lPlotFakeL handles.fig(i,j).mis3D.lPlotFakeLD handles.fig(i,j).mis3D.pPlotFakeL twitchPlotL],[handles.ldg3D.lines handles.ldg3D.AP {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
                            twitchLDG = 1;
                        else
                            ldg3D = legend(handles.fig(i,j).avgMisalign3D.L,[handles.fig(i,j).mis3D.lPlotFakeL handles.fig(i,j).mis3D.lPlotFakeLD handles.fig(i,j).mis3D.pPlotFakeL],[handles.ldg3D.lines handles.ldg3D.AP],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
                            twitchLDG = 1;
                        end
                        
                        if j ==1
                            ylabel(handles.fig(i,j).avgMagaxL,'Normalized Left Eye Velocity Magnitude','FontSize',22);
                            handles.fig(i,j).avgMagaxL.FontSize = 13.5;
                            ylabel(handles.fig(i,j).avgMisalignaxL,'Normalized Left Eye Velocity Misalignment','FontSize',22);
                            handles.fig(i,j).avgMisalignaxL.FontSize = 13.5;
                        end
                        
                    else
                        if any(handles.fig(i,j).cycles(l,k).twitch) && ~twitchLDG
                            ldg3D = legend(handles.fig(i,j).avgMisalign3D.L,[handles.fig(i,j).mis3D.lPlotFakeL handles.fig(i,j).mis3D.pPlotFakeL twitchPlotL],[handles.ldg3D.lines handles.ldg3D.AP {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
                            twitchLDG = 1;
                        else
                            ldg3D = legend(handles.fig(i,j).avgMisalign3D.L,[handles.fig(i,j).mis3D.lPlotFakeL handles.fig(i,j).mis3D.pPlotFakeL],[handles.ldg3D.lines handles.ldg3D.AP],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
                            twitchLDG = 1;
                        end
                        
                        if j ==1
                            ylabel(handles.fig(i,j).avgMagaxL,'Left Eye Velocity Magnitude (dps)','FontSize',22);
                            handles.fig(i,j).avgMagaxL.FontSize = 13.5;
                            ylabel(handles.fig(i,j).avgMisalignaxL,'Left Eye Velocity Misalignment (degrees)','FontSize',22);
                            handles.fig(i,j).avgMisalignaxL.FontSize = 13.5;
                        end
                    end
                    if handles.LEyeFlag.Value && handles.REyeFlag.Value
                    if handles.stimulatingE.Value
                        misalgn3DName = [handles.figDir,'\eyeMisalignment3D_ByStimE_R&Leye_Stim',num2str(handles.stimNum(j)),'_',handles.figdir];
                    elseif handles.referenceE.Value
                        misalgn3DName = [handles.figDir,'\eyeMisalignment3D_ByRefE_R&Leye_Ref',num2str(handles.returnNum(j)),'_',handles.figdir];
                    end
                    
                elseif handles.LEyeFlag.Value
                    if handles.stimulatingE.Value
                        misalgn3DName = [handles.figDir,'\eyeMisalignment3D_ByStimE_Leye_Stim',num2str(handles.stimNum(j)),'_',handles.figdir];
                    elseif handles.referenceE.Value
                        misalgn3DName = [handles.figDir,'\eyeMisalignment3D_ByRefE_Leye_Ref',num2str(handles.returnNum(j)),'_',handles.figdir];
                    end
                elseif handles.REyeFlag.Value
                    if handles.stimulatingE.Value
                        misalgn3DName = [handles.figDir,'\eyeMisalignment3D_ByStimE_Reye_Stim',num2str(handles.stimNum(j)),'_',handles.figdir];
                    elseif handles.referenceE.Value
                        misalgn3DName = [handles.figDir,'\eyeMisalignment3D_ByRefE_Reye_Ref',num2str(handles.returnNum(j)),'_',handles.figdir];
                    end
                end
                saveas(handles.avgMisalignPlot3D(j),[misalgn3DName,'.svg']);
                saveas(handles.avgMisalignPlot3D(j),[misalgn3DName,'.jpg']);
                saveas(handles.avgMisalignPlot3D(j),[misalgn3DName,'.fig']);
                close(handles.avgMisalignPlot3D(j));
                    handles.fig(i,j).avgMagaxL.Title.String = ['Source ', num2str(handles.stimNum(j))];
                    handles.fig(i,j).avgMisalignaxL.Title.String = ['Source ', num2str(handles.stimNum(j))];
                    sourceLab = 1;
                    sameaxes([], [handles.fig(i,:).avgMagaxL]);
                    sameaxes([], [handles.fig(i,:).avgMisalignaxL]);
                    handles.fig(i,j).avgMagaxL.FontSize = 13.5;
                    handles.fig(i,j).avgMisalignaxL.FontSize = 13.5;
                    for rN = 1:length(handles.returnNum)
                        ldgPos = find(handles.origreturnNum == handles.returnNum(rN));
                        if handles.ldgNames{ldgPos} == ' '
                            handles.ldgNames{ldgPos} = ['Return ',num2str(handles.returnNum(rN))];
                            handles.lines(ldgPos) = [handles.fig(i,j).p(rN).LFake];
                        end
                    end
                    start = length(handles.allRef)
                    for pts = 1:length(handles.ldgV)
                        if any(strcmp(handles.ldgNames,handles.ldgV{pts}))
                        else
                        handles.ldgNames{start+pts} = handles.ldgV{pts};
                        handles.lines(start+pts) = handles.fig(i,j).p(k).ptLFake(pts);
                        end
                    end
                    
                    all = size(handles.fig(i,j).cycles);
                    for m = 1:all(2)
                        for n = 1:all(1)
                            if any([handles.fig(i,j).cycles(n,m).twitch])
                                
                                set( handles.avgMisalignPlot(i),'CurrentAxes',handles.fig(i,j).avgMisalignaxL);
                                hold(handles.fig(i,j).avgMisalignaxL,'on') %%%% Do red triangles instead of lines
                                handles.cutOff1 = plot(handles.fig(i,j).avgMisalignaxL,handles.fig(i,j).cycles(n,m).p2d,mean(handles.fig(i,j).cycles(n,m).avgMisalignL),'rx','MarkerSize', 20,'LineWidth',3);
                                hold(handles.fig(i,j).avgMisalignaxL,'off')
                                
                                set( handles.avgMagPlot(i),'CurrentAxes',handles.fig(i,j).avgMagaxL);
                                hold(handles.fig(i,j).avgMagaxL,'on')
                                handles.cutOff2 = plot(handles.fig(i,j).avgMagaxL,handles.fig(i,j).cycles(n,m).p2d,mean(handles.fig(i,j).cycles(n,m).maxMagL),'rx','MarkerSize', 20,'LineWidth',3);
                                hold(handles.fig(i,j).avgMagaxL,'off')
                            end
                        end
                    end
                end