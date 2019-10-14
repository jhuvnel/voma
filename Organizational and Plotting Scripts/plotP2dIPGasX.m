function handles = plotP2dIPGasX(handles,i,j,k,l)

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

if handles.returnNum(k) == 1
    toplotInds = oneInds;
else
    toplotInds = find(([handles.params.stim]==handles.stimNum(j)) & ([handles.params.ref]==handles.returnNum(k)) & ([handles.params.dSp2d]<0));
    toplotdS = find(([handles.params.stim]==handles.stimNum(j)) & ([handles.params.ref]==handles.returnNum(k)) & ([handles.params.dSp2d]>0));
end

if q>length(handles.params(toplotInds(1)).nromInd)
    
else
    
    handles.avgMisalignPlot3DP2(j).normalized(q) = figure('units','normalized','outerposition',[0 0 1 1]);
    sgtitle(handles.avgMisalignPlot3DP2(j).normalized(q),{['3D Angle of Misalignment, Stim ',num2str(handles.stimNum(j)),', ',handles.figdir]; ' '},'FontSize', 22, 'FontWeight', 'Bold');
    
    handles.avgMisalignPlot3Dipg(j).normalized(q) = figure('units','normalized','outerposition',[0 0 1 1]);
    sgtitle(handles.avgMisalignPlot3Dipg(j).normalized(q),{['3D Angle of Misalignment, Stim ',num2str(handles.stimNum(j)),', ',handles.figdir]; ' '},'FontSize', 22, 'FontWeight', 'Bold');
    
    handles.avgMagPlot(j).normalized(q) = figure('units','normalized','outerposition',[0 0 1 1]);
    handles.avgMisalignPlot(j).normalized(q) = figure('units','normalized','outerposition',[0 0 1 1]);
    a = sgtitle(handles.avgMagPlot(j).normalized(q),{['Average Eye Velocity Magnitude, Stim',num2str(handles.stimNum(j)),', ',handles.figdir] ; ' '},'FontSize', 22, 'FontWeight', 'Bold');
    sgtitle(handles.avgMisalignPlot(j).normalized(q),{['Angle of Misalignment, Stim',num2str(handles.stimNum(j)),', ',handles.figdir]; ' '},'FontSize', 22, 'FontWeight', 'Bold');
    
    if handles.LEyeFlag.Value + handles.REyeFlag.Value == 2
        handles.fig(i,j).avgMisalign3DP2(q).R = subtightplot(1,2,1,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot3DP2(j).normalized(q));
        handles.fig(i,j).avgMisalign3DP2(q).L = subtightplot(1,2,2,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot3DP2(j).normalized(q));
        handles.fig(i,j).avgMisalign3DP2(q).R.XGrid = 'on';
        handles.fig(i,j).avgMisalign3DP2(q).R.YGrid = 'on';
        handles.fig(i,j).avgMisalign3DP2(q).L.XGrid = 'on';
        handles.fig(i,j).avgMisalign3DP2(q).L.YGrid = 'on';
        handles.fig(i,j).avgMisalign3DP2(q).L.Title.String = 'Left Eye 3D Misalignment';
        handles.fig(i,j).avgMisalign3DP2(q).L.FontSize = 13.5;
        handles.fig(i,j).avgMisalign3DP2(q).R.Title.String = 'Right Eye 3D Misalignment';
        handles.fig(i,j).avgMisalign3DP2(q).R.FontSize = 13.5;
    elseif handles.LEyeFlag.Value
        
        handles.fig(i,j).avgMisalign3DP2(q).L = axes('Parent', handles.avgMisalignPlot3DP2(j).normalized(q));
        handles.fig(i,j).avgMisalign3DP2(q).L.XGrid = 'on';
        handles.fig(i,j).avgMisalign3DP2(q).L.YGrid = 'on';
        handles.fig(i,j).avgMisalign3DP2(q).L.Title.String = 'Left Eye 3D Misalignment, Phase 2 Duration';
        handles.fig(i,j).avgMisalign3DP2(q).L.FontSize = 13.5;
        handles.fig(i,j).avgMisalign3Dipg(q).L = axes('Parent', handles.avgMisalignPlot3Dipg(j).normalized(q));
        handles.fig(i,j).avgMisalign3Dipg(q).L.XGrid = 'on';
        handles.fig(i,j).avgMisalign3Dipg(q).L.YGrid = 'on';
        handles.fig(i,j).avgMisalign3Dipg(q).L.Title.String = 'Left Eye 3D Misalignment, Interphase Gap';
        handles.fig(i,j).avgMisalign3Dipg(q).L.FontSize = 13.5;
    elseif handles.REyeFlag.Value
        
        handles.fig(i,j).avgMisalign3DP2(q).R = axes('Parent', handles.avgMisalignPlot3DP2(j).normalized(q));
        handles.fig(i,j).avgMisalign3DP2(q).R.XGrid = 'on';
        handles.fig(i,j).avgMisalign3DP2(q).R.YGrid = 'on';
        handles.fig(i,j).avgMisalign3DP2(q).R.Title.String = 'Right Eye 3D Misalignment';
        handles.fig(i,j).avgMisalign3DP2(q).R.FontSize = 13.5;
    end
    
    handles.ldg3D.lines = {};
    handles.ldg3DP2.AP = {};
    handles.ldg3Dipg.AP = {};
    if handles.LEyeFlag.Value
        figure(handles.avgMisalignPlot3DP2(j).normalized(q));
        set( handles.avgMisalignPlot3DP2(j).normalized(q),'CurrentAxes',handles.fig(i,j).avgMisalign3DP2(q).L)
        hold(handles.fig(i,j).avgMisalign3DP2(q).L,'on');
        h=plot3vect([1/sqrt(2);-1/sqrt(2);0],'LARP Axis',[0 1 0],2);
        set(h,'LineStyle','--','Marker','o');
        h=plot3vect([1/sqrt(2);1/sqrt(2);0],'RALP Axis',[0 1 1],2);
        set(h,'LineStyle','--','Marker','o');
        h=plot3vect([0;0;1],'Yaw Axis',[0.68 0 0],2);
        set(h,'LineStyle','--','Marker','o');
        
        [x,y,z]=sphere();
        h=surf(0.5*x,0.5*y,0.5*z);
        set(h,'FaceColor','white')
        handles.fig(i,j).avgMisalign3DP2(q).L.View = [90 -0.5];
        axis vis3d
        axis equal
        box on;
        xlim([-1 1])
        ylim([-1 1])
        zlim([-1 1])
        hold(handles.fig(i,j).avgMisalign3DP2(q).L,'off');
        
        
        figure(handles.avgMisalignPlot3Dipg(j).normalized(q));
        set( handles.avgMisalignPlot3Dipg(j).normalized(q),'CurrentAxes',handles.fig(i,j).avgMisalign3Dipg(q).L)
        hold(handles.fig(i,j).avgMisalign3Dipg(q).L,'on');
        h=plot3vect([1/sqrt(2);-1/sqrt(2);0],'LARP Axis',[0 1 0],2);
        set(h,'LineStyle','--','Marker','o');
        h=plot3vect([1/sqrt(2);1/sqrt(2);0],'RALP Axis',[0 1 1],2);
        set(h,'LineStyle','--','Marker','o');
        h=plot3vect([0;0;1],'Yaw Axis',[0.68 0 0],2);
        set(h,'LineStyle','--','Marker','o');
        
        [x,y,z]=sphere();
        h=surf(0.5*x,0.5*y,0.5*z);
        set(h,'FaceColor','white')
        handles.fig(i,j).avgMisalign3Dipg(q).L.View = [90 -0.5];
        axis vis3d
        axis equal
        box on;
        xlim([-1 1])
        ylim([-1 1])
        zlim([-1 1])
        hold(handles.fig(i,j).avgMisalign3Dipg(q).L,'off');
        
    end
    
    if handles.REyeFlag.Value
        set( handles.avgMisalignPlot3DP2(j).normalized(q),'CurrentAxes',handles.fig(i,j).avgMisalign3DP2(q).R)
        hold(handles.fig(i,j).avgMisalign3DP2(q).R,'on');
        h=plot3vect([1/sqrt(2);-1/sqrt(2);0],'LARP Axis',[0 1 0],2);
        set(h,'LineStyle','--','Marker','o');
        h=plot3vect([1/sqrt(2);1/sqrt(2);0],'RALP Axis',[0 1 1],2);
        set(h,'LineStyle','--','Marker','o');
        h=plot3vect([0;0;1],'Yaw Axis',[0.68 0 0],2);
        set(h,'LineStyle','--','Marker','o');
        
        [x,y,z]=sphere();
        h=surf(0.5*x,0.5*y,0.5*z);
        set(h,'FaceColor','white')
        handles.fig(i,j).avgMisalign3DP2(q).R.View = [90 -0.5];
        axis vis3d
        axis equal
        box on;
        xlim([-1 1])
        ylim([-1 1])
        zlim([-1 1])
        hold(handles.fig(i,j).avgMisalign3DP2(q).R,'off');
    end
    
    % if handles.bipolarstim.Value
    %     handles.returnNum = handles.returnNum(~(handles.returnNum==handles.stimNum(j)));
    % end
    % go = 1;
    % returnTest = 1;
    % oneInds = [];
    % otherInds = [];
    %
    % while go
    %     if handles.returnNum(returnTest)==1
    %         oneInds = find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(handles.returnNum(returnTest))]));
    %         if ~isempty(find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(10)])))
    %             otherInds = [otherInds find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(10)]))];
    %         end
    %         if ~isempty(find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(11)])))
    %             otherInds = [otherInds find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(11)]))];
    %         end
    %         if ~isempty(find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(12)])))
    %             otherInds = [otherInds find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(11)]))];
    %         end
    %         if ~isempty(find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(13)])))
    %             otherInds = [otherInds find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(11)]))];
    %         end
    %         if ~isempty(find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(14)])))
    %             otherInds = [otherInds find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(11)]))];
    %         end
    %         if ~isempty(find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(15)])))
    %             otherInds = [otherInds find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(11)]))];
    %         end
    %         if isequal(oneInds,otherInds)
    %             handles.returnNum(returnTest) = [];
    %             returnTest = returnTest - 1;
    %         else
    %             oneInds = oneInds(~ismember(oneInds,otherInds));
    %         end
    %     else
    %         if ~isempty(find(contains({handles.listing.name},['stim',num2str(handles.stimNum(j)),'ref',num2str(handles.returnNum(returnTest))])))
    %
    %         else
    %             handles.returnNum(returnTest) = [];
    %             returnTest = returnTest - 1;
    %         end
    %     end
    %
    %     if returnTest == length(handles.returnNum)
    %         go = 0;
    %     end
    %     returnTest = returnTest + 1;
    % end
    %
    %     if handles.returnNum(k) == 1
    %         toplotInds = oneInds;
    %     else
    %         toplotInds = find(([handles.params.stim]==handles.stimNum(j)) & ([handles.params.ref]==handles.returnNum(k)) & ([handles.params.dSp2d]<0));
    %         toplotdS = find(([handles.params.stim]==handles.stimNum(j)) & ([handles.params.ref]==handles.returnNum(k)) & ([handles.params.dSp2d]>0));
    %     end
    
    for k = 1:length(handles.returnNum)
        
        if handles.LEyeFlag.Value + handles.REyeFlag.Value == 2
            
            handles.fig(i,j).normalized(q).avgMagaxL(k) = subtightplot(2,length(handles.returnNum),k,[0.015 0.015],[0.10 0.075],[.05 .05],'Parent', handles.avgMagPlot(j).normalized(q));
            handles.fig(i,j).normalized(q).avgMagaxR(k) = subtightplot(2,length(handles.returnNum),k+length(handles.returnNum),[0.015 0.015],[0.10 0.075],[.05 .05],'Parent', handles.avgMagPlot(j).normalized(q));
            
            handles.fig(i,j).normalized(q).avgMisalignaxL(k) = subtightplot(2,length(handles.returnNum),k,[0.015 0.015],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot(j).normalized(q));
            handles.fig(i,j).normalized(q).avgMisalignaxR(k) = subtightplot(2,length(handles.returnNum),k+length(handles.returnNum),[0.015 0.015],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot(j).normalized(q));
            
            handles.fig(i,j).normalized(q).avgMagaxL(k).XTickLabel = [];
            handles.fig(i,j).normalized(q).avgMagaxR(k).XTick = [0:50:handles.allP2d(end)];
            handles.fig(i,j).normalized(q).avgMisalignaxL(k).XTickLabel = [];
            handles.fig(i,j).normalized(q).avgMisalignaxR(k).XTick = [0:50:handles.allP2d(end)];
            handles.fig(i,j).normalized(q).avgMagaxL(k).XGrid = 'on';
            handles.fig(i,j).normalized(q).avgMagaxR(k).XGrid = 'on';
            handles.fig(i,j).normalized(q).avgMagaxL(k).YGrid = 'on';
            handles.fig(i,j).normalized(q).avgMagaxR(k).YGrid = 'on';
            handles.fig(i,j).normalized(q).avgMisalignaxL(k).XGrid = 'on';
            handles.fig(i,j).normalized(q).avgMisalignaxR(k).XGrid = 'on';
            handles.fig(i,j).normalized(q).avgMisalignaxL(k).YGrid = 'on';
            handles.fig(i,j).normalized(q).avgMisalignaxR(k).YGrid = 'on';
            handles.fig(i,j).normalized(q).avgMagaxR(k).XLim = [0 handles.allP2d(end)+50];
            handles.fig(i,j).normalized(q).avgMagaxL(k).XLim = [0 handles.allP2d(end)+50];
            handles.fig(i,j).normalized(q).avgMisalignaxR(k).XLim = [0 handles.allP2d(end)+50];
            handles.fig(i,j).normalized(q).avgMisalignaxL(k).XLim = [0 handles.allP2d(end)+50];
            handles.fig(i,j).normalized(q).avgMagaxR(k).XTick = [0:50:handles.allP2d(end)];
            handles.fig(i,j).normalized(q).avgMisalignaxR(k).XTick = [0:50:handles.allP2d(end)];
            
        elseif handles.LEyeFlag.Value
            
            handles.fig(i,j).normalized(q).avgMagaxL(k) = subtightplot(1,length(handles.returnNum),k,[0.01 0.015],[0.10 0.075],[.05 .05],'Parent', handles.avgMagPlot(j).normalized(q));
            handles.fig(i,j).normalized(q).avgMisalignaxL(k) = subtightplot(1,length(handles.returnNum),k,[0.01 0.015],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot(j).normalized(q));
            handles.fig(i,j).normalized(q).avgMagaxL(k).XTick = [0:50:handles.allP1d(end)];
            handles.fig(i,j).normalized(q).avgMisalignaxL(k).XTick = [0:50:handles.allP1d(end)];
            handles.fig(i,j).normalized(q).avgMagaxL(k).XGrid = 'on';
            handles.fig(i,j).normalized(q).avgMagaxL(k).YGrid = 'on';
            handles.fig(i,j).normalized(q).avgMisalignaxL(k).XGrid = 'on';
            handles.fig(i,j).normalized(q).avgMisalignaxL(k).YGrid = 'on';
            handles.fig(i,j).normalized(q).avgMagaxL(k).XLim = [0 handles.allP2d(end)+50];
            handles.fig(i,j).normalized(q).avgMisalignaxL(k).XLim = [0 handles.allP2d(end)+50];
            handles.fig(i,j).normalized(q).avgMagaxL(k).XTick = [0:50:handles.allP2d(end)];
            handles.fig(i,j).normalized(q).avgMisalignaxL(k).XTick = [0:50:handles.allP2d(end)];
            
        elseif handles.REyeFlag.Value
            
            handles.fig(i,j).normalized(q).avgMagaxR(k) = subtightplot(1,length(handles.returnNum),k,[0.01 0.015],[0.10 0.075],[.05 .05],'Parent', handles.avgMagPlot(j).normalized(q));
            handles.fig(i,j).normalized(q).avgMisalignaxR(k) = subtightplot(1,length(handles.returnNum),k,[0.01 0.015],[0.10 0.075],[.05 .05],'Parent', handles.avgMisalignPlot(j).normalized(q));
            handles.fig(i,j).normalized(q).avgMagaxR(k).XTick = [0:50:handles.allP1d(end)];
            handles.fig(i,j).normalized(q).avgMisalignaxR(k).XTick = [0:50:handles.allP1d(end)];
            handles.fig(i,j).normalized(q).avgMagaxR(k).XGrid = 'on';
            handles.fig(i,j).normalized(q).avgMagaxR(k).YGrid = 'on';
            handles.fig(i,j).normalized(q).avgMisalignaxR(k).XGrid = 'on';
            handles.fig(i,j).normalized(q).avgMisalignaxR(k).YGrid = 'on';
            handles.fig(i,j).normalized(q).avgMagaxR(k).XLim = [0 handles.allP2d(end)+50];
            handles.fig(i,j).normalized(q).avgMisalignaxR(k).XLim = [0 handles.allP2d(end)+50];
            handles.fig(i,j).normalized(q).avgMagaxR(k).XTick = [0:50:handles.allP2d(end)];
            handles.fig(i,j).normalized(q).avgMisalignaxR(k).XTick = [0:50:handles.allP2d(end)];
            
        end
        
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
        % if q>length(handles.params(toplotInds(1)).normInd)
        
        %else
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
                handles.params(toplotInds(l)).maxMagL = mean(maxMagL);
                handles.params(toplotInds(l)).maxMagLstd = std(maxMagL);
                handles.params(toplotInds(l)).avgMisalignL = mean(avgMisalignL);
                handles.params(toplotInds(l)).avgMisalignLstd = std(avgMisalignL);
                meanM = mean(misalign3DL);
                handles.fig(i,j).cycles(l,k).avgmisalign3DL = meanM/norm(meanM);
                rot = [cosd(-45) -sind(-45) 0;...
                    sind(-45) cosd(-45) 0;...
                    0 0 1];
                mis3DPlot = (rot*handles.fig(i,j).cycles(l,k).avgmisalign3DL')';
                
                figure(handles.avgMisalignPlot3DP2(j).normalized(q));
                set( handles.avgMisalignPlot3DP2(j).normalized(q),'CurrentAxes',handles.fig(i,j).avgMisalign3DP2(q).L);
                hold(handles.fig(i,j).avgMisalign3DP2(q).L,'on');
                if handles.norm.Value
                    if l == 1
                        mis3DPlotD = (rot*(mis3DPlotD/norm(mis3DPlotD))')';
                        
                        handles.fig(i,j).mis3DP2(l,k).lPlotLD = plot3([0 mis3DPlotD(1)]',[0 mis3DPlotD(2)]',[0 mis3DPlotD(3)]');
                        set(handles.fig(i,j).mis3DP2(l,k).lPlotLD,'LineWidth',3.5,'DisplayName','','Color','k')
                        handles.fig(i,j).mis3DP2(l,k).lPlotFakeLD = plot3([0 .01]',[0 .01]',[0 .01]');
                        set(handles.fig(i,j).mis3DP2(l,k).lPlotFakeLD,'LineWidth',3.5,'DisplayName','','Color','k','Marker','^','MarkerSize',12,'MarkerEdgeColor',colorPlot)
                        handles.fig(i,j).mis3DP2(l,k).pPlotLD = plot3(mis3DPlotD(1),mis3DPlotD(2),mis3DPlotD(3),'o');
                        set(handles.fig(i,j).mis3DP2(l,k).pPlotLD,'LineWidth',3.5,'DisplayName','','Marker','^','MarkerSize',12,'MarkerEdgeColor',colorPlot)
                        handles.ldg3D.lines = [handles.ldg3D.lines,{['Default Stimulation, Return ',num2str(handles.returnNum(k))]}];
                    end
                    
                    
                end
                handles.fig(i,j).mis3DP2(l,k).lPlotL = plot3([0 mis3DPlot(1)]',[0 mis3DPlot(2)]',[0 mis3DPlot(3)]');
                set(handles.fig(i,j).mis3DP2(l,k).lPlotL,'LineWidth',2,'DisplayName','','Color',colorPlot)
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
                    handles.fig(i,j).mis3DP2(l,k).lPlotFakeL = plot3([0 .01]',[0 .01]',[0 .01]');
                    set(handles.fig(i,j).mis3DP2(l,k).lPlotFakeL,'LineWidth',2,'DisplayName','','Color',colorPlot)
                end
                if isempty(handles.ldg3DP2.AP)
                    handles.ldg3DP2.AP = {[num2str(handles.fig(i,j).cycles(l,k).p2d),' uS']};
                    handles.fig(i,j).mis3DP2(l,k).pPlotFakeL = plot3(0,0,0,'Marker',markerToUse,'MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2,'Linestyle', 'none');
                elseif any(strcmp(handles.ldg3DP2.AP,[num2str(handles.fig(i,j).cycles(l,k).p2d),' uS']))
                else
                    handles.ldg3DP2.AP = [handles.ldg3DP2.AP,{[num2str(handles.fig(i,j).cycles(l,k).p2d),' uS']}];
                    handles.fig(i,j).mis3DP2(l,k).pPlotFakeL = plot3(0,0,0,'Marker',markerToUse,'MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2,'Linestyle', 'none');
                end
                
                handles.fig(i,j).mis3DP2(l,k).pPlotL = plot3(mis3DPlot(1),mis3DPlot(2),mis3DPlot(3),'o');
                set(handles.fig(i,j).mis3DP2(l,k).pPlotL,'LineWidth',2,'DisplayName','','Marker',markerToUse,'MarkerSize',10,'MarkerEdgeColor',colorPlot)
                
                if any(handles.fig(i,j).cycles(l,k).twitch)
                    twitchPlotLP2 = plot3(mis3DPlot(1),mis3DPlot(2),mis3DPlot(3),'rx','MarkerSize', 20,'LineWidth',3,'Linestyle', 'none');
                end
                hold(handles.fig(i,j).avgMisalign3DP2(q).L,'off');
                
                
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
                
                
                figure(handles.avgMisalignPlot3Dipg(j).normalized(q))
                set( handles.avgMisalignPlot3Dipg(j).normalized(q),'CurrentAxes',handles.fig(i,j).avgMisalign3Dipg(q).L);
                hold(handles.fig(i,j).avgMisalign3Dipg(q).L,'on');
                if handles.norm.Value
                    if l == 1
                        
                        handles.fig(i,j).mis3Dipg(l,k).lPlotLD = plot3([0 mis3DPlotD(1)]',[0 mis3DPlotD(2)]',[0 mis3DPlotD(3)]');
                        set(handles.fig(i,j).mis3Dipg(l,k).lPlotLD,'LineWidth',3.5,'DisplayName','','Color','k')
                        handles.fig(i,j).mis3Dipg(l,k).lPlotFakeLD = plot3([0 .01]',[0 .01]',[0 .01]');
                        set(handles.fig(i,j).mis3Dipg(l,k).lPlotFakeLD,'LineWidth',3.5,'DisplayName','','Color','k','Marker','s','MarkerSize',10,'MarkerEdgeColor',colorPlot)
                        handles.fig(i,j).mis3Dipg(l,k).pPlotLD = plot3(mis3DPlotD(1),mis3DPlotD(2),mis3DPlotD(3),'o');
                        set(handles.fig(i,j).mis3Dipg(l,k).pPlotLD,'LineWidth',3.5,'DisplayName','','Marker','s','MarkerSize',10,'MarkerEdgeColor',colorPlot)
                    end
                    
                    
                end
                handles.fig(i,j).mis3Dipg(l,k).lPlotL = plot3([0 mis3DPlot(1)]',[0 mis3DPlot(2)]',[0 mis3DPlot(3)]');
                set(handles.fig(i,j).mis3Dipg(l,k).lPlotL,'LineWidth',2,'DisplayName','','Color',colorPlot)
                
                if l==1
                    handles.fig(i,j).mis3Dipg(l,k).lPlotFakeL = plot3([0 .01]',[0 .01]',[0 .01]');
                    set(handles.fig(i,j).mis3Dipg(l,k).lPlotFakeL,'LineWidth',2,'DisplayName','','Color',colorPlot)
                end
                if isempty(handles.ldg3Dipg.AP)
                    handles.ldg3Dipg.AP = {[num2str(handles.fig(i,j).cycles(l,k).ipg),' uS']};
                    handles.fig(i,j).mis3Dipg(l,k).pPlotFakeL = plot3(0,0,0,'Marker',IPGmarker,'MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2,'Linestyle', 'none');
                elseif any(strcmp(handles.ldg3Dipg.AP,[num2str(handles.fig(i,j).cycles(l,k).ipg),' uS']))
                else
                    handles.ldg3Dipg.AP = [handles.ldg3Dipg.AP,{[num2str(handles.fig(i,j).cycles(l,k).ipg),' uS']}];
                    handles.fig(i,j).mis3Dipg(l,k).pPlotFakeL = plot3(0,0,0,'Marker',IPGmarker,'MarkerEdgeColor','k','MarkerSize',10,'LineWidth',2,'Linestyle', 'none');
                end
                
                handles.fig(i,j).mis3Dipg(l,k).pPlotL = plot3(mis3DPlot(1),mis3DPlot(2),mis3DPlot(3),'o');
                set(handles.fig(i,j).mis3Dipg(l,k).pPlotL,'LineWidth',2,'DisplayName','','Marker',IPGmarker,'MarkerSize',10,'MarkerEdgeColor',colorPlot)
                
                if any(handles.fig(i,j).cycles(l,k).twitch)
                    twitchPlotLipg = plot3(mis3DPlot(1),mis3DPlot(2),mis3DPlot(3),'rx','MarkerSize', 20,'LineWidth',3,'Linestyle', 'none');
                end
                hold(handles.fig(i,j).avgMisalign3Dipg(q).L,'off');
                
            end
            
            
        end
        
        if handles.LEyeFlag.Value
            figure(handles.avgMagPlot(j).normalized(q))
            set( handles.avgMagPlot(j).normalized(q),'CurrentAxes',handles.fig(i,j).normalized(q).avgMagaxL(k));
            hold(handles.fig(i,j).normalized(q).avgMagaxL(k),'on');
            x = [handles.params(toplotInds).p2d]';
            y = [handles.params(toplotInds).ipg]';
            z = [handles.params(toplotInds).maxMagL]';
            F = scatteredInterpolant(x,y,z);
            F.Method = 'natural';
            minV = min([handles.params(toplotInds).p2d handles.params(toplotInds).ipg]');
            maxV = max([handles.params(toplotInds).p2d handles.params(toplotInds).ipg]');
            [xq,yq] = meshgrid(minV:10:maxV);
            
            F.Method = 'natural';
            vq1 = F(xq,yq);
            handles.fig(i,j).p(k).ptL = plot3(x,y,z,'LineWidth',2,'DisplayName','','Marker','o','MarkerSize',13,'MarkerEdgeColor',colorPlot,'LineStyle','none')
            handles.fig(i,j).normalized(q).avgMagaxL(k).XLim = [minV max(x)];
            handles.fig(i,j).normalized(q).avgMagaxL(k).XLabel.String = 'Phase 2 Duration (uS)';
            handles.fig(i,j).normalized(q).avgMagaxL(k).XGrid = 'On';
            handles.fig(i,j).normalized(q).avgMagaxL(k).YLim = [minV max(y)];
            handles.fig(i,j).normalized(q).avgMagaxL(k).YLabel.String = 'Interphase Gap (uS)';
            handles.fig(i,j).normalized(q).avgMagaxL(k).YGrid = 'On';
            handles.fig(i,j).normalized(q).avgMagaxL(k).ZGrid = 'On';
            handles.fig(i,j).normalized(q).avgMagaxL(k).View = [-37.5000 30];
            handles.fig(i,j).normalized(q).avgMagaxL(k).CameraPositionMode = 'auto'
            handles.fig(i,j).normalized(q).avgMagaxL(k).Title.String = ['Source ', num2str(handles.stimNum(j)),' Reference ',num2str(handles.returnNum(k))];
            hold on
            for ptS = 1:length(x)
                plot3([x(ptS) x(ptS)], [y(ptS) y(ptS)], [z(ptS)-handles.params(toplotInds(ptS)).maxMagLstd z(ptS)+handles.params(toplotInds(ptS)).maxMagLstd],'Color',colorPlot,'LineWidth',2);
            end
            handles.fig(i,j).p(k).surfL = mesh(xq,yq,vq1)
            hold(handles.fig(i,j).normalized(q).avgMagaxL(k),'off');
            
            
            figure(handles.avgMisalignPlot(j).normalized(q))
            set( handles.avgMisalignPlot(j).normalized(q),'CurrentAxes',handles.fig(i,j).normalized(q).avgMisalignaxL(k));
            hold(handles.fig(i,j).normalized(q).avgMisalignaxL(k),'on');
            x = [handles.params(toplotInds).p2d]';
            y = [handles.params(toplotInds).ipg]';
            z = [handles.params(toplotInds).avgMisalignL]';
            F = scatteredInterpolant(x,y,z);
            F.Method = 'natural';
            minV = min([handles.params(toplotInds).p2d handles.params(toplotInds).ipg]');
            maxV = max([handles.params(toplotInds).p2d handles.params(toplotInds).ipg]');
            [xq,yq] = meshgrid(minV:10:maxV);
            
            F.Method = 'natural';
            vq1 = F(xq,yq);
            handles.fig(i,j).q(k).ptL = plot3(x,y,z,'LineWidth',2,'DisplayName','','Marker','o','MarkerSize',13,'MarkerEdgeColor',colorPlot,'LineStyle','none')
            handles.fig(i,j).normalized(q).avgMisalignaxL(k).XLim = [minV max(x)];
            handles.fig(i,j).normalized(q).avgMisalignaxL(k).XLabel.String = 'Phase 2 Duration (uS)';
            handles.fig(i,j).normalized(q).avgMisalignaxL(k).XGrid = 'On';
            handles.fig(i,j).normalized(q).avgMisalignaxL(k).YLim = [minV max(y)];
            handles.fig(i,j).normalized(q).avgMisalignaxL(k).YLabel.String = 'Interphase Gap (uS)';
            handles.fig(i,j).normalized(q).avgMisalignaxL(k).YGrid = 'On';
            handles.fig(i,j).normalized(q).avgMisalignaxL(k).ZGrid = 'On';
            handles.fig(i,j).normalized(q).avgMisalignaxL(k).View = [-37.5000 30];
            handles.fig(i,j).normalized(q).avgMisalignaxL(k).CameraPositionMode = 'auto'
            handles.fig(i,j).normalized(q).avgMisalignaxL(k).Title.String = ['Source ', num2str(handles.stimNum(j)),' Reference ',num2str(handles.returnNum(k))];
            hold on
            for ptS = 1:length(x)
                plot3([x(ptS) x(ptS)], [y(ptS) y(ptS)], [z(ptS)-handles.params(toplotInds(ptS)).maxMagLstd z(ptS)+handles.params(toplotInds(ptS)).maxMagLstd],'Color',colorPlot,'LineWidth',2);
            end
            handles.fig(i,j).q(k).surfL = mesh(xq,yq,vq1)
            hold(handles.fig(i,j).normalized(q).avgMisalignaxL(k),'off');
            
            sourceLab = 1;
            sameaxes([], [handles.fig(i,j).normalized(q).avgMagaxL]);
            sameaxes([], [handles.fig(i,j).normalized(q).avgMisalignaxL]);
            handles.fig(i,j).normalized(q).avgMagaxL(k).FontSize = 13.5;
            handles.fig(i,j).normalized(q).avgMisalignaxL(k).FontSize = 13.5;
            if handles.norm.Value
                if k ==1
                    zlabel(handles.fig(i,j).normalized(q).avgMagaxL(k),'Normalized Left Eye Velocity Magnitude','FontSize',22);
                    handles.fig(i,j).normalized(q).avgMagaxL(k).FontSize = 13.5;
                    zlabel(handles.fig(i,j).normalized(q).avgMisalignaxL(k),'Normalized Left Eye Velocity Misalignment','FontSize',22);
                    handles.fig(i,j).normalized(q).avgMisalignaxL(k).FontSize = 13.5;
                end
            else
                if k ==1
                    zlabel(handles.fig(i,j).normalized(q).avgMagaxL(k),'Left Eye Velocity Magnitude (dps)','FontSize',22);
                    handles.fig(i,j).normalized(q).avgMagaxL(k).FontSize = 13.5;
                    zlabel(handles.fig(i,j).normalized(q).avgMisalignaxL(k),'Left Eye Velocity Misalignment (degrees)','FontSize',22);
                    handles.fig(i,j).normalized(q).avgMisalignaxL(k).FontSize = 13.5;
                end
            end
            all = size(handles.fig(i,j).cycles);
            for m = 1:all(2)
                for n = 1:all(1)
                    if any([handles.fig(i,j).cycles(n,m).twitch])
                        figure(handles.avgMisalignPlot(j).normalized(q))
                        set( handles.avgMisalignPlot(j).normalized(q),'CurrentAxes',handles.fig(i,j).normalized(q).avgMisalignaxL(k));
                        hold(handles.fig(i,j).normalized(q).avgMisalignaxL(k),'on') %%%% Do red triangles instead of lines
                        handles.cutOff1 = plot3(handles.fig(i,j).normalized(q).avgMisalignaxL(k),handles.fig(i,j).cycles(n,m).p2d,handles.fig(i,j).cycles(n,m).ipg,mean(handles.fig(i,j).cycles(n,m).avgMisalignL),'rx','MarkerSize', 20,'LineWidth',3);
                        hold(handles.fig(i,j).normalized(q).avgMisalignaxL(k),'off')
                        
                        figure(handles.avgMagPlot(j).normalized(q))
                        set( handles.avgMagPlot(j).normalized(q),'CurrentAxes',handles.fig(i,j).normalized(q).avgMagaxL(k));
                        hold(handles.fig(i,j).normalized(q).avgMagaxL(k),'on')
                        handles.cutOff2 = plot3(handles.fig(i,j).normalized(q).avgMagaxL(k),handles.fig(i,j).cycles(n,m).p2d,handles.fig(i,j).cycles(n,m).ipg,mean(handles.fig(i,j).cycles(n,m).maxMagL),'rx','MarkerSize', 20,'LineWidth',3);
                        hold(handles.fig(i,j).normalized(q).avgMagaxL(k),'off')
                    end
                end
            end
            
            
            
        end
        
    end
    
    
    
    twitchLDG = 0;
    sourceLab = 0;
    if handles.LEyeFlag.Value
        if handles.norm.Value
            if any(handles.fig(i,j).cycles(l,k).twitch) && ~twitchLDG
                ldg3DP2 = legend(handles.fig(i,j).avgMisalign3DP2(q).L,[handles.fig(i,j).mis3DP2.lPlotFakeL handles.fig(i,j).mis3DP2.lPlotFakeLD handles.fig(i,j).mis3DP2.pPlotFakeL twitchPlotLP2],[handles.ldg3D.lines handles.ldg3DP2.AP {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
                ldg3Dipg = legend(handles.fig(i,j).avgMisalign3Dipg(q).L,[handles.fig(i,j).mis3Dipg.lPlotFakeL handles.fig(i,j).mis3Dipg.lPlotFakeLD handles.fig(i,j).mis3Dipg.pPlotFakeL twitchPlotLP2],[handles.ldg3D.lines handles.ldg3Dipg.AP {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
                
                twitchLDG = 1;
            else
                ldg3D = legend(handles.fig(i,j).avgMisalign3DP2(q).L,[handles.fig(i,j).mis3DP2.lPlotFakeL handles.fig(i,j).mis3DP2.lPlotFakeLD handles.fig(i,j).mis3DP2.pPlotFakeL],[handles.ldg3D.lines handles.ldg3DP2.AP],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
                ldg3Dipg = legend(handles.fig(i,j).avgMisalign3Dipg(q).L,[handles.fig(i,j).mis3Dipg.lPlotFakeL handles.fig(i,j).mis3Dipg.lPlotFakeLD handles.fig(i,j).mis3Dipg.pPlotFakeL],[handles.ldg3D.lines handles.ldg3Dipg.AP],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
                
                twitchLDG = 1;
            end
            
        else
            if any(handles.fig(i,j).cycles(l,k).twitch) && ~twitchLDG
                ldg3D = legend(handles.fig(i,j).avgMisalign3DP2(q).L,[handles.fig(i,j).mis3DP2.lPlotFakeL handles.fig(i,j).mis3DP2.pPlotFakeL twitchPlotLP2],[handles.ldg3D.lines handles.ldg3DP2.AP {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
                ldg3Dipg = legend(handles.fig(i,j).avgMisalign3Dipg(q).L,[handles.fig(i,j).mis3Dipg.lPlotFakeL handles.fig(i,j).mis3Dipg.pPlotFakeL twitchPlotLP2],[handles.ldg3D.lines handles.ldg3Dipg.AP {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
                
                twitchLDG = 1;
            else
                ldg3D = legend(handles.fig(i,j).avgMisalign3DP2(q).L,[handles.fig(i,j).mis3DP2.lPlotFakeL handles.fig(i,j).mis3DP2.pPlotFakeL],[handles.ldg3D.lines handles.ldg3DP2.AP],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
                ldg3Dipg = legend(handles.fig(i,j).avgMisalign3Dipg(q).L,[handles.fig(i,j).mis3Dipg.lPlotFakeL handles.fig(i,j).mis3Dipg.pPlotFakeL twitchPlotLP2],[handles.ldg3D.lines handles.ldg3Dipg.AP],'Orientation','Horizontal','Position',[0.1310    0.0243    0.7568    0.0199],'FontSize',13.5);
                
                twitchLDG = 1;
            end
            
        end
        if handles.LEyeFlag.Value && handles.REyeFlag.Value
            if handles.stimulatingE.Value
                misalgn3DP2Name = [handles.figDir,'\eyeMisalignment3D_Phase2Duration_ByStimE_R&Leye_Stim',num2str(handles.stimNum(j)),'_',handles.figdir];
                misalgn3DipgName = [handles.figDir,'\eyeMisalignment3D_InterphaseGap_ByStimE_R&Leye_Stim',num2str(handles.stimNum(j)),'_',handles.figdir];
            elseif handles.referenceE.Value
                misalgn3DP2Name = [handles.figDir,'\eyeMisalignment3D_Phase2Duration_ByRefE_R&Leye_Ref',num2str(handles.returnNum(j)),'_',handles.figdir];
                misalgn3DipgName = [handles.figDir,'\eyeMisalignment3D_InterphaseGap_ByRefE_R&Leye_Ref',num2str(handles.stimNum(j)),'_',handles.figdir];
            end
            
        elseif handles.LEyeFlag.Value
            if handles.stimulatingE.Value
                misalgn3DP2Name = [handles.figDir,'\eyeMisalignment3D_Phase2Duration_ByStimE_Leye_Stim',num2str(handles.stimNum(j)),'_',handles.figdir];
                misalgn3DipgName = [handles.figDir,'\eyeMisalignment3D_InterphaseGap_ByStimE_Leye_Stim',num2str(handles.stimNum(j)),'_',handles.figdir];
            elseif handles.referenceE.Value
                misalgn3DP2Name = [handles.figDir,'\eyeMisalignment3D_Phase2Duration_ByRefE_Leye_Ref',num2str(handles.returnNum(j)),'_',handles.figdir];
                misalgn3DipgName = [handles.figDir,'\eyeMisalignment3D_InterphaseGap_ByRefE_Leye_Ref',num2str(handles.returnNum(j)),'_',handles.figdir];
            end
        elseif handles.REyeFlag.Value
            if handles.stimulatingE.Value
                misalgn3DP2Name = [handles.figDir,'\eyeMisalignment3D_Phase2Duration_ByStimE_Reye_Stim',num2str(handles.stimNum(j)),'_',handles.figdir];
                misalgn3DipgName = [handles.figDir,'\eyeMisalignment3D_InterphaseGap_ByStimE_Reye_Stim',num2str(handles.stimNum(j)),'_',handles.figdir];
            elseif handles.referenceE.Value
                misalgn3DP2Name = [handles.figDir,'\eyeMisalignment3D_Phase2Duration_InterphaseGap_ByRefE_Reye_Ref',num2str(handles.returnNum(j)),'_',handles.figdir];
                misalgn3DipgName = [handles.figDir,'\eyeMisalignment3D_InterphaseGap_ByRefE_Reye_Ref',num2str(handles.returnNum(j)),'_',handles.figdir];
            end
        end
        saveas(handles.avgMisalignPlot3DP2(j).normalized(q),[misalgn3DP2Name,'.svg']);
        saveas(handles.avgMisalignPlot3DP2(j).normalized(q),[misalgn3DP2Name,'.jpg']);
        saveas(handles.avgMisalignPlot3DP2(j).normalized(q),[misalgn3DP2Name,'.fig']);
        close(handles.avgMisalignPlot3DP2(j).normalized(q));
        saveas(handles.avgMisalignPlot3Dipg(j).normalized(q),[misalgn3DipgName,'.svg']);
        saveas(handles.avgMisalignPlot3Dipg(j).normalized(q),[misalgn3DipgName,'.jpg']);
        saveas(handles.avgMisalignPlot3Dipg(j).normalized(q),[misalgn3DipgName,'.fig']);
        close(handles.avgMisalignPlot3Dipg(j).normalized(q));
        
    end
    handles.ldgNames = {};
    handles.lines = zeros(1,length(handles.returnNum));
    for rN = 1:length(handles.returnNum)
        handles.ldgNames{rN} = ' ';
    end
    
    
    for rN = 1:length(handles.returnNum)
        handles.ldgNames{rN} = ['Return ',num2str(handles.returnNum(rN)),' Sample Points'];
        handles.lines(rN) = [handles.fig(i,j).q(rN).ptL];
        
    end
    start = length(handles.returnNum)
    if any(strcmp(handles.ldgNames,'Interpolated Surface'))
    else
        handles.ldgNames{start+1} = 'Interpolated Surface';
        handles.lines(start+1) = handles.fig(i,j).p.surfL;
    end
    
    
    if handles.LEyeFlag.Value + handles.REyeFlag.Value == 2
        t=[];
        for tpts = 1:length(handles.fig)
            t = [t [handles.fig(tpts).cycles(:).twitch]];
        end
        if any(t)
            ldg1 = legend(handles.fig(i,j).normalized(q).avgMagaxR(k),[handles.lines handles.cutOff1],[handles.ldgNames {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','horizontal');
            ldg2 = legend(handles.fig(i,j).normalized(q).avgMisalignaxR(k),[handles.lines handles.cutOff1],[handles.ldgNames {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','horizontal');
            ldg1.Position = [0.4 0.01 0.1308 0.0192];
            ldg2.Position = [0.4 0.01 0.1308 0.0192];
            ldg1.FontSize = 13.5;
            ldg2.FontSize = 13.5;
        else
            ldg1 = legend(handles.fig(i,j).normalized(q).avgMagaxR(k),handles.lines,handles.ldgNames,'Orientation','horizontal');
            ldg2 = legend(handles.fig(i,j).normalized(q).avgMisalignaxR(k),handles.lines,handles.ldgNames,'Orientation','horizontal');
            ldg1.Position = [0.4 0.01 0.1308 0.0192];
            ldg2.Position = [0.4 0.01 0.1308 0.0192];
            ldg1.FontSize = 13.5;
            ldg2.FontSize = 13.5;
        end
        
        
        %*[0.7940    0.0297    0.1153;-0.8296    0.0283   -0.1883;0.7940    0.0297    0.1153]
        if handles.stimulatingE.Value
            misalgnName = [handles.figDir,'\eyeMisalignment_ByStim',num2str(handles.stimNum(j)),'_R&Leye_',handles.figdir];
            velName = [handles.figDir,'\eyeVelocity_ByStime',num2str(handles.stimNum(j)),'_R&Leye_',handles.figdir];
        elseif handles.referenceE.Value
            misalgnName = [handles.figDir,'\eyeMisalignment_ByRef',num2str(handles.returnNum(j)),'_R&Leye_',handles.figdir];
            velName = [handles.figDir,'\eyeVelocity_ByRef',num2str(handles.retunrNum(j)),'_R&Leye_',handles.figdir];
        end
        saveas(handles.avgMisalignPlot(j).normalized(q),[misalgnName,'.svg']);
        saveas(handles.avgMisalignPlot(j).normalized(q),[misalgnName,'.jpg']);
        saveas(handles.avgMisalignPlot(j).normalized(q),[misalgnName,'.fig']);
        saveas(handles.avgMagPlot(j).normalized(q),[velName,'.svg']);
        saveas(handles.avgMagPlot(j).normalized(q),[velName,'.jpg']);
        saveas(handles.avgMagPlot(j).normalized(q),[velName,'.fig']);
        close(handles.avgMisalignPlot(j).normalized(q));
        close(handles.avgMagPlot(j).normalized(q));
    elseif handles.LEyeFlag.Value
        t=[];
        t = find([handles.fig(j).cycles(:).twitch]);
        if any(t)
            ldg1 = legend(handles.fig(i,j).normalized(q).avgMagaxL(k),[handles.lines handles.cutOff1],[handles.ldgNames {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','horizontal','AutoUpdate','off');
            ldg2 = legend(handles.fig(i,j).normalized(q).avgMisalignaxL(k),[handles.lines handles.cutOff1],[handles.ldgNames {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','horizontal','AutoUpdate','off');
            ldg1.Position = [0.4 0.01 0.1308 0.0192];
            ldg2.Position = [0.4 0.01 0.1308 0.0192];
            ldg1.FontSize = 13.5;
            ldg2.FontSize = 13.5;
        else
            ldg1 = legend(handles.fig(i,j).normalized(q).avgMagaxL(k),handles.lines,handles.ldgNames,'Orientation','horizontal','AutoUpdate','off');
            ldg2 = legend(handles.fig(i,j).normalized(q).avgMisalignaxL(k),handles.lines,handles.ldgNames,'Orientation','horizontal','AutoUpdate','off');
            ldg1.Position = [0.4 0.01 0.1308 0.0192];
            ldg2.Position = [0.4 0.01 0.1308 0.0192];
            ldg1.FontSize = 13.5;
            ldg2.FontSize = 13.5;
        end
        
        
        %*[0.7940    0.0297    0.1153;-0.8296    0.0283   -0.1883;0.7940    0.0297    0.1153]
        if handles.stimulatingE.Value
            if handles.ipg.Value && handles.p2d.Value
                if handles.norm.Value
                    misalgnName = [handles.figDir,'\NormalizedeyeMisalignment_vs_Phase2Duration_vs_IPG_3D_ByStim',num2str(handles.stimNum(j)),'_Leye_',handles.figdir];
                    velName = [handles.figDir,'\NormalizedeyeVelocity_vs_Phase2Duration_vs_IPG_3D_ByStim',num2str(handles.stimNum(j)),'_Leye_',handles.figdir];
                else
                    misalgnName = [handles.figDir,'\eyeMisalignment_vs_Phase2Duration_vs_IPG_3D_ByStim',num2str(handles.stimNum(j)),'_Leye_',handles.figdir];
                    velName = [handles.figDir,'\eyeVelocity_vs_Phase2Duration_vs_IPG_3D_ByStim',num2str(handles.stimNum(j)),'_Leye_',handles.figdir];
                end
            elseif handles.p2d.Value
                if handles.norm.Value
                    misalgnName = [handles.figDir,'\NormalizedeyeMisalignment_vs_Phase2Duration_ByStim',num2str(handles.stimNum(j)),'_Leye_',handles.figdir];
                    velName = [handles.figDir,'\NormalizedeyeVelocity_vs_Phase2Duration_ByStim',num2str(handles.stimNum(j)),'_Leye_',handles.figdir];
                else
                    misalgnName = [handles.figDir,'\eyeMisalignment_vs_Phase2Duration_ByStim',num2str(handles.stimNum(j)),'_Leye_',handles.figdir];
                    velName = [handles.figDir,'\eyeVelocity_vs_Phase2Duration_ByStim',num2str(handles.stimNum(j)),'_Leye_',handles.figdir];
                end
            end
        elseif handles.referenceE.Value
            if handles.ipg.Value && handles.p2d.Value
                if handles.norm.Value
                    misalgnName = [handles.figDir,'\NormalizedeyeMisalignment_vs_Phase2Duration_vs_IPG_3D_ByRef',num2str(handles.returnNum(j)),'_Leye_',handles.figdir];
                    velName = [handles.figDir,'\NormalizedeyeVelocity_vs_Phase2Duration_vs_IPG_3D_ByRef',num2str(handles.returnNum(j)),'_Leye_',handles.figdir];
                else
                    misalgnName = [handles.figDir,'\eyeMisalignment_vs_Phase2Duration_vs_IPG_3D_ByRef',num2str(handles.returnNum(j)),'_Leye_',handles.figdir];
                    velName = [handles.figDir,'\eyeVelocity_vs_Phase2Duration_vs_IPG_3D_ByRef',num2str(handles.returnNum(j)),'_Leye_',handles.figdir];
                end
            elseif handles.p2d.Value
                if handles.norm.Value
                    misalgnName = [handles.figDir,'\NormalizedeyeMisalignment_vs_Phase2Duration_ByRef',num2str(handles.returnNum(j)),'_Leye_',handles.figdir];
                    velName = [handles.figDir,'\NormalizedeyeVelocity_vs_Phase2Duration_ByRef',num2str(handles.returnNum(j)),'_Leye_',handles.figdir];
                else
                    misalgnName = [handles.figDir,'\eyeMisalignment_vs_Phase2Duration_ByRef',num2str(handles.returnNum(j)),'_Leye_',handles.figdir];
                    velName = [handles.figDir,'\eyeVelocity_vs_Phase2Duration_ByRef',num2str(handles.returnNum(j)),'_Leye_',handles.figdir];
                end
            end
        end
        saveas(handles.avgMisalignPlot(j).normalized(q),[misalgnName,'.svg']);
        saveas(handles.avgMisalignPlot(j).normalized(q),[misalgnName,'.jpg']);
        saveas(handles.avgMisalignPlot(j).normalized(q),[misalgnName,'.fig']);
        saveas(handles.avgMagPlot(j).normalized(q),[velName,'.svg']);
        saveas(handles.avgMagPlot(j).normalized(q),[velName,'.jpg']);
        saveas(handles.avgMagPlot(j).normalized(q),[velName,'.fig']);
        close(handles.avgMisalignPlot(j).normalized(q));
        close(handles.avgMagPlot(j).normalized(q));
    elseif handles.REyeFlag.Value
        t=[];
        for tpts = 1:length(handles.fig)
            t = [t [handles.fig(tpts).cycles(:).twitch]];
        end
        if any(t)
            ldg1 = legend(handles.fig(i,j).normalized(q).avgMagaxR(k),[handles.lines handles.cutOff1],[handles.ldgNames {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','horizontal');
            ldg2 = legend(handles.fig(i,j).normalized(q).avgMisalignaxR(k),[handles.lines handles.cutOff1],[handles.ldgNames {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','horizontal');
            ldg1.Position = [0.4 0.01 0.1308 0.0192];
            ldg2.Position = [0.4 0.01 0.1308 0.0192];
            ldg1.FontSize = 13.5;
            ldg2.FontSize = 13.5;
        else
            ldg1 = legend(handles.fig(i,j).normalized(q).avgMagaxR(k),handles.lines,handles.ldgNames,'Orientation','horizontal');
            ldg2 = legend(handles.fig(i,j).normalized(q).avgMisalignaxR(k),handles.lines,handles.ldgNames,'Orientation','horizontal');
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
        saveas(handles.avgMisalignPlot(j).normalized(q),[misalgnName,'.svg']);
        saveas(handles.avgMisalignPlot(j).normalized(q),[misalgnName,'.jpg']);
        saveas(handles.avgMisalignPlot(j).normalized(q),[misalgnName,'.fig']);
        saveas(handles.avgMagPlot(j).normalized(q),[velName,'.svg']);
        saveas(handles.avgMagPlot(j).normalized(q),[velName,'.jpg']);
        saveas(handles.avgMagPlot(j).normalized(q),[velName,'.fig']);
        close(handles.avgMisalignPlot(j).normalized(q));
        close(handles.avgMagPlot(j).normalized(q));
    end
end