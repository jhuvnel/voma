function plotP1dasX(handles,i,j)
if handles.LEyeFlag.Value + handles.REyeFlag.Value == 2
    
    handles.fig(i,j).avgMagaxL = subtightplot(2,length(handles.stimNum),j,[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMagPlot(i));
    handles.fig(i,j).avgMagaxR = subtightplot(2,length(handles.stimNum),j+length(handles.stimNum),[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMagPlot(i));
    
    handles.fig(i,j).avgMisalignaxL = subtightplot(2,length(handles.stimNum),j,[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot(i));
    handles.fig(i,j).avgMisalignaxR = subtightplot(2,length(handles.stimNum),j+length(handles.stimNum),[0.015 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot(i));
    
    handles.fig(i,j).avgMagaxL.XTickLabel = [];
    handles.fig(i,j).avgMagaxR.XTick = [0:50:handles.allP1d(end)];
    handles.fig(i,j).avgMisalignaxL.XTickLabel = [];
    handles.fig(i,j).avgMisalignaxR.XTick = [0:50:handles.allP1d(end)];
    handles.fig(i,j).avgMagaxL.XGrid = 'on';
    handles.fig(i,j).avgMagaxR.XGrid = 'on';
    handles.fig(i,j).avgMagaxL.YGrid = 'on';
    handles.fig(i,j).avgMagaxR.YGrid = 'on';
    handles.fig(i,j).avgMisalignaxL.XGrid = 'on';
    handles.fig(i,j).avgMisalignaxR.XGrid = 'on';
    handles.fig(i,j).avgMisalignaxL.YGrid = 'on';
    handles.fig(i,j).avgMisalignaxR.YGrid = 'on';
    handles.fig(i,j).avgMagaxR.XLim = [0 handles.allP1d(end)+50];
    handles.fig(i,j).avgMagaxL.XLim = [0 handles.allP1d(end)+50];
    handles.fig(i,j).avgMisalignaxR.XLim = [0 handles.allP1d(end)+50];
    handles.fig(i,j).avgMisalignaxL.XLim = [0 handles.allP1d(end)+50];
    handles.fig(i,j).avgMagaxR.XTick = [0:50:handles.allP1d(end)];
    handles.fig(i,j).avgMisalignaxR.XTick = [0:50:handles.allP1d(end)];
    
    
    
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
    handles.fig(i,j).avgMagaxL.XLim = [0 handles.allP1d(end)+50];
    handles.fig(i,j).avgMisalignaxL.XLim = [0 handles.allP1d(end)+50];
    handles.fig(i,j).avgMagaxL.XTick = [0:50:handles.allP1d(end)];
    handles.fig(i,j).avgMisalignaxL.XTick = [0:50:handles.allP1d(end)];
    
    
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
    handles.fig(i,j).avgMagaxR.XLim = [0 handles.allP1d(end)+50];
    handles.fig(i,j).avgMisalignaxR.XLim = [0 handles.allP1d(end)+50];
    handles.fig(i,j).avgMagaxR.XTick = [0:50:handles.allP1d(end)];
    handles.fig(i,j).avgMisalignaxR.XTick = [0:50:handles.allP1d(end)];
    
    
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
                        toplotInds = find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(handles.returnNum(k))]));
                        
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
                            handles.fig(i,j).mis3D(l,k).lPlotL = plot3([0 mis3DPlot(1)]',[0 mis3DPlot(2)]',[0 mis3DPlot(3)]');
                            set(handles.fig(i,j).mis3D(l,k).lPlotL,'LineWidth',2,'DisplayName','','Color',colorPlot)
                            switch handles.fig(i,j).cycles(l,k).amp
                                case 20
                                    markerToUse = 'o';
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
                                case 200
                                    markerToUse = '<';
                                case 250
                                    markerToUse = 'p';
                                case 300
                                    markerToUse = 'h';
                            end
                    end
end