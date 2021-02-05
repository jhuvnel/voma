%%
PY = load('R:\Morris, Brian\Monkey Data\Yoda\20191212\Cycles\Plots.mat');
%%
figDir = 'R:\Morris, Brian\Monkey Data\Yoda\20191212\MedEl Figures\';
animal = 'Yoda';
dates = [{'date20191212'}];
st = [8];
rft = [7 9 15 11 10];
directions = [{'LHRH'}];
ldgFlag = 'off';
plottype = 'InvsOut_noLDG';
name = ['Yoda_eyeMisalignmentandVelocity_LHRH_Current_ByStim_Bipolar_Leye-20200617-microtext'];
yoda = makePlots(figDir,animal,dates,st,rft,directions,PY.Plots,plottype,ldgFlag,name);
%%

%figDir = 'R:\Morris, Brian\Monkey Data\Yoda\20191212\Final Figures\';
saveas(yoda.ccLARPPlot,[figDir,name,'.svg']);
saveas(yoda.ccLARPPlot,[figDir,name,'.jpg']);
saveas(yoda.ccLARPPlot,[figDir,name,'.fig']);
%%
PN = load('R:\Morris, Brian\Monkey Data\Nancy\20191118\Cycles\Plots.mat');
%%
figDir = 'R:\Morris, Brian\Monkey Data\Nancy\20191118\MedEl Figures\';
animal = 'Nancy';
dates = [{'date20191118'} {'date20191115'}];
st = [7 8];
rft = [9 15 7 8 11 10];
directions = [{'LHRH'}];% 
ldgFlag = 'on';
plottype = 'InvsOut_noLDG';
name = ['LEGEND-Nancy_eyeMisalignmentandVelocity_LHRH_Current_ByStim_Bipolar_Leye-20200617MedEl-microtext'];
nancy = makePlots(figDir,animal,dates,st,rft,directions,PN.Plots,plottype,ldgFlag,name);
%%

%figDir = 'R:\Morris, Brian\Monkey Data\Nancy\20191118\Final Figures\';
saveas(nancy.ccLARPPlot,[figDir,name,'.svg']);
saveas(nancy.ccLARPPlot,[figDir,name,'.jpg']);
saveas(nancy.ccLARPPlot,[figDir,name,'.fig']);
%%
PG = load('R:\Morris, Brian\Monkey Data\GiGi\20190724\Spike2 Files\current sweep\Cycles\Plots.mat');
%%
figDir = 'R:\Morris, Brian\Monkey Data\GiGi\20190724\Spike2 Files\current sweep\Figures\';
animal = 'GiGi';
dates = [{'date20190724'}];
st = [4 5 6];
rft = [4 5 6 11 10];
directions = [{'LARP'}];% 
ldgFlag = 'off';
plottype = 'SMD';
name = ['LEGEND-GiGi_eyeMisalignmentandVelocity_LARP_Current_ByStim_Bipolar_Leye-microtext'];
GiGi = makePlots(figDir,animal,dates,st,rft,directions,PG.Plots,plottype,ldgFlag,name);
%%
saveas(GiGi.ccLARPPlot,[figDir,name,'.svg']);
saveas(GiGi.ccLARPPlot,[figDir,name,'.jpg']);
saveas(GiGi.ccLARPPlot,[figDir,name,'.fig']);
%%
function [plotting] = makePlots(figDir,animal,dates,st,rft,directions,Plots,plottype,ldgFlag,name)
if strcmp(ldgFlag,'on')
    plotFlag = 'off';
elseif strcmp(ldgFlag,'off')
     plotFlag = 'on';
end
plotting = struct();
plotting.ccLARPPlot = figure('units','normalized','outerposition',[0 0 1 1]);
an = animal(1);
ax = 1;
plotting.names = [];
coFlag = 0;
for s = 1:length(st)
    rf = rft(rft~=st(s));
    for r = 1:length(rf)
        
        stim = ['stim',num2str(st(s))];
        ref = ['ref',num2str(rf(r))];
        skipFlag = 0;
        if length(directions)>1
        else
            direction = directions{1};
        end
        breakFlag = 0;
        fromRef = 0;
        if length(dates)>1 || length(directions)>1
            for dirs = 1:length(directions)
                for dts = 1:length(dates)
                        if isfield(Plots.(animal).(dates{dts}),directions{dirs})
                            if isfield(Plots.(animal).(dates{dts}).(directions{dirs}),stim)
                                direction = directions{dirs};
                                if isfield(Plots.(animal).(dates{dts}).(direction).(stim),ref)
                                    date = dates{dts};
                                    breakFlag = 1;
                                    break
                                else
                                    fromRef = 1;
                                    if dts == length(dates)
                                    skipFlag = 1;
                                    breakFlag = 1;
                                    break
                                    end
                                end
                            else
                                
                            end
                        else
                            if fromRef
                            if dts == length(dates)
                                skipFlag = 1;
                                breakFlag = 1;
                                break
                            end
                            end
                        end
                end
                if breakFlag
                    break
                end
            end
        else
            date = dates{1};
        end
        if ~isfield(Plots.(animal).(date).(direction).(stim),ref)
            skipFlag = 1;
        end
        
        if skipFlag
        else
        if length(directions)>1
            plotDir = [];
            for dirs = 1:length(directions)
                if dirs>1
                    plotDir = append(plotDir,' and ',directions{dirs});
                else
                plotDir = [plotDir directions{dirs}];
                end
            end
        else
            plotDir = direction;
        end
        %sgtitle(plotting.ccLARPPlot,{['Average Left Eye Velocity and Misalignment Magnitude, Animal ',an,' ',plotDir]; ' '},'FontSize', 22, 'FontWeight', 'Bold');
        ePos = getePos(animal,st(s));
        plotting.ccLARPV(ax).axs = subtightplot(2,length(st),ax,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', plotting.ccLARPPlot,'visible',plotFlag);
        plotting.ccLARPVData(s,r).line = copyobj(Plots.(animal).(date).(direction).(stim).(ref).source.magV.line.plotL,plotting.ccLARPV(ax).axs);
        plotting.ccLARPVData(s,r).points = copyobj([Plots.(animal).(date).(direction).(stim).(ref).source.magV.point.PlotL],plotting.ccLARPV(ax).axs);
        t = [Plots.(animal).(date).(direction).(stim).(ref).source.magV.point.twitchPlotL]~=0;
        plotting.ccLARPVData(s,r).error = copyobj([Plots.(animal).(date).(direction).(stim).(ref).source.magV.point.erPlotL],plotting.ccLARPV(ax).axs);  
        plotting.ccLARPVData(s,r).co = plotting.ccLARPVData(s,r).line.XData(max(find((plotting.ccLARPVData(s,r).line.YData<20))));
         set(plotting.ccLARPVData(s,r).error,'LineWidth',4)
         set(plotting.ccLARPVData(s,r).error,'CapSize',12)
         if any(t)
        plotting.ccLARPVData(s,r).tw = copyobj([Plots.(animal).(date).(direction).(stim).(ref).source.magV.point(t).twitchPlotL],plotting.ccLARPV(ax).axs);
        set(plotting.ccLARPVData(s,r).tw,'MarkerSize',25)
         end
        
        cz= [180 227 61];
         cy=   [255 196 61];
         cv=   [239 160 11];
         cx = [183 184 104];
         cw = [104 78 50];
         ca = [255 166 158];
        switch rf(r)
            case 11
                c = [128 147 241];
                plotting.ccLARPVData(s,r).line.Color = [c]/255;
                set(plotting.ccLARPVData(s,r).points,'Color',[c]/255);
                set(plotting.ccLARPVData(s,r).error,'Color',[c]/255);%97 15 127
                
            case 12
                plotting.ccLARPVData(s,r).line.Color = [147 92 188]/255;
                set(plotting.ccLARPVData(s,r).points,'Color',[147 92 188]/255);
                set(plotting.ccLARPVData(s,r).error,'Color',[147 92 188]/255);
            case 13
                c = [129 244 149];
                plotting.ccLARPVData(s,r).line.Color = [c]/255;
                set(plotting.ccLARPVData(s,r).points,'Color',[c]/255);
                set(plotting.ccLARPVData(s,r).error,'Color',[c]/255);
            case 14
                plotting.ccLARPVData(s,r).line.Color = [cz]/255;
                set(plotting.ccLARPVData(s,r).points,'Color',[cz]/255);
                set(plotting.ccLARPVData(s,r).error,'Color',[cz]/255);
            case 5
                plotting.ccLARPVData(s,r).line.Color = [cy]/255;
                set(plotting.ccLARPVData(s,r).points,'Color',[cy]/255);
                set(plotting.ccLARPVData(s,r).error,'Color',[cy]/255);
            case 8
                plotting.ccLARPVData(s,r).line.Color = [cx]/255;
                set(plotting.ccLARPVData(s,r).points,'Color',[cx]/255);
                set(plotting.ccLARPVData(s,r).error,'Color',[cx]/255);
                case 3
                plotting.ccLARPVData(s,r).line.Color = [cw]/255;
                set(plotting.ccLARPVData(s,r).points,'Color',[cw]/255);
                set(plotting.ccLARPVData(s,r).error,'Color',[cw]/255);
                case 1
                plotting.ccLARPVData(s,r).line.Color = [ca]/255;
                set(plotting.ccLARPVData(s,r).points,'Color',[ca]/255);
                set(plotting.ccLARPVData(s,r).error,'Color',[ca]/255);
        end
            
        plotting.ccLARPV(ax).axs.XTickLabel = [];
        plotting.ccLARPV(ax).axs.XTick = [0:50:300];
        plotting.ccLARPV(ax).axs.XGrid = 'on';
        plotting.ccLARPV(ax).axs.YGrid = 'on';
        plotting.ccLARPV(ax).axs.XLim = [0 350];
        plotting.ccLARPV(ax).axs.FontSize = 25;
        plotting.ccLARPV(ax).axs.Title.String = ePos;
        plotting.ccLARPV(ax).axs.LineWidth = 2.5;
        plotting.ccLARPV(ax).axs.Title.FontSize = 30;
        set(plotting.ccLARPVData(s,r).points,'MarkerSize',15,'LineWidth',3)
        
        plotting.ccLARPM(ax).axs = subtightplot(2,length(st),ax+length(st),[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', plotting.ccLARPPlot,'visible',plotFlag);
        plotting.ccLARPMData(s,r).line = copyobj(Plots.(animal).(date).(direction).(stim).(ref).source.magM.line.plotL,plotting.ccLARPM(ax).axs);
        plotting.ccLARPMData(s,r).points = copyobj([Plots.(animal).(date).(direction).(stim).(ref).source.magM.point.PlotL],plotting.ccLARPM(ax).axs);
        t = [Plots.(animal).(date).(direction).(stim).(ref).source.magM.point.twitchPlotL]~=0;
                plotting.ccLARPMData(s,r).error = copyobj([Plots.(animal).(date).(direction).(stim).(ref).source.magM.point.erPlotL],plotting.ccLARPM(ax).axs); 
                        set(plotting.ccLARPMData(s,r).error,'LineWidth',4)
         set(plotting.ccLARPMData(s,r).error,'CapSize',12)
         if any(t)
        plotting.ccLARPMData(s,r).tw = copyobj([Plots.(animal).(date).(direction).(stim).(ref).source.magM.point(t).twitchPlotL],plotting.ccLARPM(ax).axs);
        set(plotting.ccLARPMData(s,r).tw,'MarkerSize',25)
         end
        
 
        
       
        plotting.ccLARPM(ax).axs.XTick = [0:50:300];
        plotting.ccLARPM(ax).axs.XGrid = 'on';
        plotting.ccLARPM(ax).axs.YGrid = 'on';
        plotting.ccLARPM(ax).axs.XLim = [0 350];
        plotting.ccLARPM(ax).axs.FontSize = 25;
        plotting.ccLARPM(ax).axs.XLabel.String = {'Current (uA)'};
        plotting.ccLARPM(ax).axs.XLabel.FontSize = 30;
        plotting.ccLARPM(ax).axs.LineWidth = 2.5;
        set(plotting.ccLARPMData(s,r).points,'MarkerSize',15,'LineWidth',3)

        
                 cz= [180 227 61];
         cy=   [255 196 61];
         cv=   [239 160 11];
        switch rf(r)
            case 11
                c = [128 147 241];
                plotting.ccLARPMData(s,r).line.Color = [c]/255;
                set(plotting.ccLARPMData(s,r).points,'Color',[c]/255);
                set(plotting.ccLARPMData(s,r).error,'Color',[c]/255);%97 15 127
                
            case 12
                plotting.ccLARPMData(s,r).line.Color = [147 92 188]/255;
                set(plotting.ccLARPMData(s,r).points,'Color',[147 92 188]/255);
                set(plotting.ccLARPMData(s,r).error,'Color',[147 92 188]/255);
            case 13
                c = [129 244 149];
                plotting.ccLARPMData(s,r).line.Color = [c]/255;
                set(plotting.ccLARPMData(s,r).points,'Color',[c]/255);
                set(plotting.ccLARPMData(s,r).error,'Color',[c]/255);
            case 14
                plotting.ccLARPMData(s,r).line.Color = [cz]/255;
                set(plotting.ccLARPMData(s,r).points,'Color',[cz]/255);
                set(plotting.ccLARPMData(s,r).error,'Color',[cz]/255);
            case 5
                plotting.ccLARPMData(s,r).line.Color = [cy]/255;
                set(plotting.ccLARPMData(s,r).points,'Color',[cy]/255);
                set(plotting.ccLARPMData(s,r).error,'Color',[cy]/255);
                case 8
                plotting.ccLARPMData(s,r).line.Color = [cx]/255;
                set(plotting.ccLARPMData(s,r).points,'Color',[cx]/255);
                set(plotting.ccLARPMData(s,r).error,'Color',[cx]/255);
                case 3
                plotting.ccLARPMData(s,r).line.Color = [cw]/255;
                set(plotting.ccLARPMData(s,r).points,'Color',[cw]/255);
                set(plotting.ccLARPMData(s,r).error,'Color',[cw]/255);
                case 1
                plotting.ccLARPMData(s,r).line.Color = [ca]/255;
                set(plotting.ccLARPMData(s,r).points,'Color',[ca]/255);
                set(plotting.ccLARPMData(s,r).error,'Color',[ca]/255);
        end

        if ax>1
            plotting.ccLARPV(ax).axs.YTickLabel = [];
            plotting.ccLARPM(ax).axs.YTickLabel = [];
        else
            plotting.ccLARPV(ax).axs.YLabel.String = {'Velocity (dps)'};
            plotting.ccLARPV(ax).axs.YLabel.FontSize = 30;
            plotting.ccLARPM(ax).axs.YLabel.String = {'Misalignment (degrees)'};
            plotting.ccLARPM(ax).axs.YLabel.FontSize = 30;
            
        end
        tn = Plots.(animal).(date).(direction).(stim).(ref).source.magM.ldgNameL;

        if length(tn)==2
            co = tn(2);
            coFlag = 1;
            coIDS = [s];
            coIDR = [r];
            if ~isempty(plotting.names)
                if ~ismember(tn(1),plotting.names)
                    plotting.names = [plotting.names tn(1)];
                end
            else
                plotting.names = [plotting.names tn(1)];
            end
        else
            if ~isempty(plotting.names)
                if ~ismember(tn,plotting.names)
                    plotting.names = [plotting.names {tn}];
                end
            else
                plotting.names = [plotting.names {tn}];
            end
        end
        end     
    end
    if s<length(st)
    ax = ax+1;
    end
end
sameaxes([],[plotting.ccLARPV.axs]);
%plotting.ccLARPM(1).axs.YLim = [0 160];
sameaxes([],[plotting.ccLARPM.axs]);
xP = [25 50 75 100 125 150 175 200 225 250];
% for patchP = 1:length(st)
%     if ~isempty([plotting.ccLARPVData(patchP,:).co])
%     pos = max(find(xP<mean([plotting.ccLARPVData(patchP,:).co])));
%     x = [0 xP(pos) xP(pos) 0];
%     yV = [plotting.ccLARPV(patchP).axs.YLim(1) plotting.ccLARPV(patchP).axs.YLim(1) plotting.ccLARPV(patchP).axs.YLim(2) plotting.ccLARPV(patchP).axs.YLim(2)];
%     yM = [plotting.ccLARPM(patchP).axs.YLim(1) plotting.ccLARPM(patchP).axs.YLim(1) plotting.ccLARPM(patchP).axs.YLim(2) plotting.ccLARPM(patchP).axs.YLim(2)];
%     patch(plotting.ccLARPV(patchP).axs,x,yV,[152 152 152]/255,'FaceAlpha',.7,'EdgeColor','none')
%     p = patch(plotting.ccLARPM(patchP).axs,x,yM,[152 152 152]/255,'FaceAlpha',.7,'EdgeColor','none');
%     end
% end
set([plotting.ccLARPV.axs],'Layer','Top');
set([plotting.ccLARPM.axs],'Layer','Top');
if strcmp(ldgFlag,'on')
    ldglines = [];
    ldgNames = [];
    for thr = 1:s
        for thr1 = 1:length([plotting.ccLARPMData(thr,:)])
            if ~isempty(plotting.ccLARPMData(thr,thr1).line)
                if contains(plotting.ccLARPMData(thr,thr1).line.DisplayName,'Left')
                    ph = strrep(plotting.ccLARPMData(thr,thr1).line.DisplayName,', Left','');
                else
                    ph = strrep(plotting.ccLARPMData(thr,thr1).line.DisplayName,', Right','');
                end
                if contains(ph,'Return, ')
                    ph = strrep(ph,'Return, ','');
                elseif contains(ph,'Return ')
                    ph = strrep(ph,'Return ','');
                end
                if (thr == 1) && (thr1 == 1)
                    ldglines = [ldglines plotting.ccLARPMData(thr,thr1).line];
                    ldgNames = [ldgNames {ph}];
                elseif ~ismember(ldgNames,ph)
                    ldglines = [ldglines plotting.ccLARPMData(thr,thr1).line];
                    ldgNames = [ldgNames {ph}];
                end
            end
        end
    end
    %tHl = [ldglines([12 11 13 10 8 9 7 5 6 1:4])];
    %tHn = [ldgNames([12 11 13 10 8 9 7 5 6 1:4])];
    %tHl = [ldglines([7 5 6 1:4])];
    %tHn = [ldgNames([7 5 6 1:4])];
%     tHl = [ldglines([1:3 6 4 5])];
%     tHn = [ldgNames([1:3 6 4 5])];
%     tAl = [ldglines([9 10 12 11])];
%     tAn = [ldgNames([9 10 12 11])];
%     tCCDl = [ldglines(4:7)];
%     tCCDn = [ldgNames(4:7)];
    tHl = [ldglines(2) ldglines(1) ldglines(3:end)];
    tHn = [ldgNames(2) ldgNames(1) ldgNames(3:end)];

if coFlag
    plotting.ldg = legend(plotting.ccLARPM(ax).axs,[tHl plotting.ccLARPMData(coIDS,coIDR).tw(1)],[tHn co],'Orientation','vertical','AutoUpdate','off');
plotting.ldg.Position = [0.3079 0.2987 0.1744 0.2214];
else
    %plotting.ldg = legend(plotting.ccLARPM(ax).axs,[plotting.ccLARPMData(s,:).line p],[plotting.names 'Sub-20dps Threshold'],'Orientation','vertical','AutoUpdate','off');
end
end
%name = [animal,'_eyeMisalignmentandVelocity_Current_ByStim_',direction,'_',plottype,'_Leye_'];
%saveas(plotting.ccLARPPlot,[figDir,name,'.svg']);
%saveas(plotting.ccLARPPlot,[figDir,name,'.jpg']);
%saveas(plotting.ccLARPPlot,[figDir,name,'.fig']);
%close(plotting.ccLARPPlot);
% myBox = uicontrol('style','text');
% myBox.Units = 'normalized';
% myBox.Position = [myBox.Parent.Position(1) -0.001 myBox.Parent.Position(3) 0.0212];
% myBox.HorizontalAlignment = 'left';
% myBox.Max = 5;
% myBox.FontSize = 5.5;
% crtScript = 'Created using Coil_data_Segmenting.m (labdata\Morris, Brian\MATLAB\VNEL), Monkey_Voma_Processing.m (labdata\Morris, Brian\MATLAB\VNEL\Coil Analysis), generateSubplotFigures.m (labdata\Morris, Brian\MATLAB\VNEL\Organizational and Plotting Scripts), PlotfromMfile.m(labdata\Morris, Brian\MATLAB\VNEL\Organizational and Plotting Scripts)';
% animalI = ['   Animals: ',animal];
% sl = find(figDir == '\');
% basefolder = ['labdata',figDir(sl(1):sl(5))];
% rawDataI = ['   Base Raw Files: ',basefolder,'Spike2 Files,  Processed Segment Files: ',basefolder,'Segments,   Processed VOMA Files: ',basefolder,'Voma,    Processed Cycle Files: ',basefolder,'Cycles,   File generated by generateSubplotFigures.m to be used in PlotfromMfile.m: ',basefolder,'Cycles\Plots.m,   Figures saved: ',basefolder,'Final Figures'];
% filename = ['   Figure Saved as: ',name,' (.jpg, .mat, and .svg)'];
% if contains(animal,'Nancy') 
% note = [' DATA ALSO IN: labdata',figDir(sl(1):sl(4)),dates{2}]; 
% myBox.String = [crtScript,animalI,rawDataI,filename,note];
% else
%     myBox.String = [crtScript,animalI,rawDataI,filename];
% end

end
% %%
% plotting.ccRALPlot = figure('units','normalized','outerposition',[0 0 1 1]);
% sgtitle(plotting.ccRALPlot,{'Average Left Eye Velocity and Misalignment Magnitude, Animal N, RALP'; ' '},'FontSize', 22, 'FontWeight', 'Bold');
% st = [4 5 14 6];
% rf = [10 11 12 13];
% ax = 1;
% plotting.names = [];
% coFlag = 0;
% for s = 1:length(st)
%     for r = 1:length(rf)
%         date = 'date20191118';
%         stim = ['stim',num2str(st(s))];
%         ref = ['ref',num2str(rf(r))];
%         ePos = getePos('(animal)',st(s));
%         plotting.ccRALPV(ax).axs = subtightplot(2,length(st),ax,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', plotting.ccRALPlot);
%         plotting.ccRALPVData(s,r).line = copyobj(Plots.(animal).(date).RALP.(stim).(ref).source.magV.line.plotL,plotting.ccRALPV(ax).axs);
%         plotting.ccRALPVData(s,r).points = copyobj([Plots.(animal).(date).RALP.(stim).(ref).source.magV.point.PlotL],plotting.ccRALPV(ax).axs);
%         t = [Plots.(animal).(date).RALP.(stim).(ref).source.magV.point.twitchPlotL]~=0;
%         if any(t)
%         plotting.ccRALPVData(s,r).tw = copyobj([Plots.(animal).(date).RALP.(stim).(ref).source.magV.point(t).twitchPlotL],plotting.ccRALPV(ax).axs);
%         end
%         plotting.ccRALPVData(s,r).error = copyobj([Plots.(animal).(date).RALP.(stim).(ref).source.magV.point.erPlotL],plotting.ccRALPV(ax).axs);  
%         plotting.ccRALPVData(s,r).co = plotting.ccRALPVData(s,r).line.XData(max(find((plotting.ccRALPVData(s,r).line.YData<20))));
%         switch rf(r)
%             case 11
%                 plotting.ccRALPVData(s,r).line.Color = [115 98 138]/255;
%                 set(plotting.ccRALPVData(s,r).points,'Color',[115 98 138]/255);
%                 set(plotting.ccRALPVData(s,r).error,'Color',[115 98 138]/255);
%                 
%             case 12
%                 plotting.ccRALPVData(s,r).line.Color = [147 92 188]/255;
%                 set(plotting.ccRALPVData(s,r).points,'Color',[147 92 188]/255);
%                 set(plotting.ccRALPVData(s,r).error,'Color',[147 92 188]/255);
%             case 13
%                 plotting.ccRALPVData(s,r).line.Color = [53 0 36]/255;
%                 set(plotting.ccRALPVData(s,r).points,'Color',[53 0 36]/255);
%                 set(plotting.ccRALPVData(s,r).error,'Color',[53 0 36]/255);
%         end
%             
%         plotting.ccRALPV(ax).axs.XTickLabel = [];
%         plotting.ccRALPV(ax).axs.XTick = [0:50:250];
%         plotting.ccRALPV(ax).axs.XGrid = 'on';
%         plotting.ccRALPV(ax).axs.YGrid = 'on';
%         plotting.ccRALPV(ax).axs.XLim = [0 300];
%         plotting.ccRALPV(ax).axs.FontSize = 13.5;
%         plotting.ccRALPV(ax).axs.Title.String = ePos;
%         plotting.ccRALPV(ax).axs.LineWidth = 2.5;
%         
%         plotting.ccRALPM(ax).axs = subtightplot(2,length(st),ax+length(st),[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', plotting.ccRALPlot);
%         plotting.ccRALPMData(s,r).line = copyobj(Plots.(animal).(date).RALP.(stim).(ref).source.magM.line.plotL,plotting.ccRALPM(ax).axs);
%         plotting.ccRALPMData(s,r).points = copyobj([Plots.(animal).(date).RALP.(stim).(ref).source.magM.point.PlotL],plotting.ccRALPM(ax).axs);
%         t = [Plots.(animal).(date).RALP.(stim).(ref).source.magM.point.twitchPlotL]~=0;
%         if any(t)
%         plotting.ccRALPMData(s,r).tw = copyobj([Plots.(animal).(date).RALP.(stim).(ref).source.magM.point(t).twitchPlotL],plotting.ccRALPM(ax).axs);
%         end
%         
%         plotting.ccRALPMData(s,r).error = copyobj([Plots.(animal).(date).RALP.(stim).(ref).source.magM.point.erPlotL],plotting.ccRALPM(ax).axs);  
%         plotting.ccRALPM(ax).axs.XTick = [0:50:250];
%         plotting.ccRALPM(ax).axs.XGrid = 'on';
%         plotting.ccRALPM(ax).axs.YGrid = 'on';
%         plotting.ccRALPM(ax).axs.XLim = [0 300];
%         plotting.ccRALPM(ax).axs.FontSize = 13.5;
%         plotting.ccRALPM(ax).axs.XLabel.String = {'Current (uA)'};
%         plotting.ccRALPM(ax).axs.LineWidth = 2.5;
%         
%         switch rf(r)
%             case 11
%                 plotting.ccRALPMData(s,r).line.Color = [115 98 138]/255;
%                 set(plotting.ccRALPMData(s,r).points,'Color',[115 98 138]/255);
%                 set(plotting.ccRALPMData(s,r).error,'Color',[115 98 138]/255);
%                 
%             case 12
%                 plotting.ccRALPMData(s,r).line.Color = [147 92 188]/255;
%                 set(plotting.ccRALPMData(s,r).points,'Color',[147 92 188]/255);
%                 set(plotting.ccRALPMData(s,r).error,'Color',[147 92 188]/255);
%             case 13
%                 plotting.ccRALPMData(s,r).line.Color = [53 0 36]/255;
%                 set(plotting.ccRALPMData(s,r).points,'Color',[53 0 36]/255);
%                 set(plotting.ccRALPMData(s,r).error,'Color',[53 0 36]/255);
%         end
% 
%         if ax>1
%             plotting.ccRALPV(ax).axs.YTickLabel = [];
%             plotting.ccRALPM(ax).axs.YTickLabel = [];
%         else
%             plotting.ccRALPV(ax).axs.YLabel.String = {'Velocity (dps)'};
%             plotting.ccRALPV(ax).axs.YLabel.FontSize = 22;
%             plotting.ccRALPM(ax).axs.YLabel.String = {'Misalignment (degrees)'};
%             plotting.ccRALPM(ax).axs.YLabel.FontSize = 22;
%         end
%         tn = Plots.(animal).(date).RALP.(stim).(ref).source.magM.ldgNameL;
%         if length(tn)==2
%             co = tn(2);
%             coFlag = 1;
%             coID = [s,r];
%             if ~isempty(plotting.names)
%                 if ~ismember(tn(1),plotting.names)
%                     plotting.names = [tn(1) plotting.names];
%                 end
%             else
%                 plotting.names = [tn(1) plotting.names];
%             end
%         else
%             if ~isempty(plotting.names)
%                 if ~ismember(tn,plotting.names)
%                     plotting.names = [{tn} plotting.names];
%                 end
%             else
%                 plotting.names = [{tn} plotting.names];
%             end
%         end
%             
%     end
%     if s<length(st)
%     ax = ax+1;
%     end
% end
% sameaxes([],[plotting.ccRALPV.axs]);
% sameaxes([],[plotting.ccRALPM.axs]);
% xP = [25 50 75 100 125 150 175 200 225 250];
% for patchP = 1:length(st)
%     pos = max(find(xP<mean([plotting.ccRALPVData(patchP,:).co])));
%     x = [0 xP(pos) xP(pos) 0];
%     yV = [plotting.ccRALPV(patchP).axs.YLim(1) plotting.ccRALPV(patchP).axs.YLim(1) plotting.ccRALPV(patchP).axs.YLim(2) plotting.ccRALPV(patchP).axs.YLim(2)];
%     yM = [plotting.ccRALPM(patchP).axs.YLim(1) plotting.ccRALPM(patchP).axs.YLim(1) plotting.ccRALPM(patchP).axs.YLim(2) plotting.ccRALPM(patchP).axs.YLim(2)];
%     patch(plotting.ccRALPV(patchP).axs,x,yV,[105 105 105]/255,'FaceAlpha',.7,'EdgeColor','none')
%     p = patch(plotting.ccRALPM(patchP).axs,x,yM,[105 105 105]/255,'FaceAlpha',.7,'EdgeColor','none');
% end
% set([plotting.ccRALPV.axs],'Layer','Top');
% set([plotting.ccRALPM.axs],'Layer','Top');
% if coFlag
%     plotting.ldg = legend(plotting.ccRALPM(ax).axs,[plotting.ccRALPMData(s,end:-1:1).line p plotting.ccRALPMData(coID).tw],[plotting.names 'Sub-20dps Threshold' co],'Orientation','horizontal','AutoUpdate','off');
% plotting.ldg.Position = [0.4 0.01 0.1308 0.0192];
% else
%     plotting.ldg = legend(plotting.ccRALPM(ax).axs,[plotting.ccRALPMData(s,end:-1:1).line p],[plotting.names 'Sub-20dps Threshold'],'Orientation','horizontal','AutoUpdate','off');
% end
% name = 'eyeMisalignmentandVelocity_Current_ByStim_RALP_DistantCC_Leye_';
% saveas(plotting.ccRALPlot,[figDir,name,'.svg']);
% saveas(plotting.ccRALPlot,[figDir,name,'.jpg']);
% saveas(plotting.ccRALPlot,[figDir,name,'.fig']);
% %close(plotting.ccRALPlot);
% %%
% plotting.ccLHRHlot = figure('units','normalized','outerposition',[0 0 1 1]);
% sgtitle(plotting.ccLHRHlot,{'Average Left Eye Velocity and Misalignment Magnitude, Animal N, LHRH'; ' '},'FontSize', 22, 'FontWeight', 'Bold');
% st = [9 8 15 7];
% rf = [10 11 12 13];
% ax = 1;
% plotting.names = [];
% coFlag = 0;
% for s = 1:length(st)
%     for r = 1:length(rf)
%             date = 'date20191118';
%         stim = ['stim',num2str(st(s))];
%         ref = ['ref',num2str(rf(r))];
%         ePos = getePos('(animal)',st(s));
%         plotting.ccLHRHV(ax).axs = subtightplot(2,length(st),ax,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', plotting.ccLHRHlot);
%         plotting.ccLHRHVData(s,r).line = copyobj(Plots.(animal).(date).LHRH.(stim).(ref).source.magV.line.plotL,plotting.ccLHRHV(ax).axs);
%         plotting.ccLHRHVData(s,r).points = copyobj([Plots.(animal).(date).LHRH.(stim).(ref).source.magV.point.PlotL],plotting.ccLHRHV(ax).axs);
%         t = [Plots.(animal).(date).LHRH.(stim).(ref).source.magV.point.twitchPlotL]~=0;
%         if any(t)
%         plotting.ccLHRHVData(s,r).tw = copyobj([Plots.(animal).(date).LHRH.(stim).(ref).source.magV.point(t).twitchPlotL],plotting.ccLHRHV(ax).axs);
%         end
%         plotting.ccLHRHVData(s,r).error = copyobj([Plots.(animal).(date).LHRH.(stim).(ref).source.magV.point.erPlotL],plotting.ccLHRHV(ax).axs);  
%         plotting.ccLHRHVData(s,r).co = plotting.ccLHRHVData(s,r).line.XData(max(find((plotting.ccLHRHVData(s,r).line.YData<20))));
%         switch rf(r)
%             case 11
%                 plotting.ccLHRHVData(s,r).line.Color = [115 98 138]/255;
%                 set(plotting.ccLHRHVData(s,r).points,'Color',[115 98 138]/255);
%                 set(plotting.ccLHRHVData(s,r).error,'Color',[115 98 138]/255);
%                 
%             case 12
%                 plotting.ccLHRHVData(s,r).line.Color = [147 92 188]/255;
%                 set(plotting.ccLHRHVData(s,r).points,'Color',[147 92 188]/255);
%                 set(plotting.ccLHRHVData(s,r).error,'Color',[147 92 188]/255);
%             case 13
%                 plotting.ccLHRHVData(s,r).line.Color = [53 0 36]/255;
%                 set(plotting.ccLHRHVData(s,r).points,'Color',[53 0 36]/255);
%                 set(plotting.ccLHRHVData(s,r).error,'Color',[53 0 36]/255);
%         end
%             
%         plotting.ccLHRHV(ax).axs.XTickLabel = [];
%         plotting.ccLHRHV(ax).axs.XTick = [0:50:250];
%         plotting.ccLHRHV(ax).axs.XGrid = 'on';
%         plotting.ccLHRHV(ax).axs.YGrid = 'on';
%         plotting.ccLHRHV(ax).axs.XLim = [0 300];
%         plotting.ccLHRHV(ax).axs.FontSize = 13.5;
%         plotting.ccLHRHV(ax).axs.Title.String = ePos;
%         plotting.ccLHRHV(ax).axs.LineWidth = 2.5;
%         
%         plotting.ccLHRHM(ax).axs = subtightplot(2,length(st),ax+length(st),[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', plotting.ccLHRHlot);
%         plotting.ccLHRHMData(s,r).line = copyobj(Plots.(animal).(date).LHRH.(stim).(ref).source.magM.line.plotL,plotting.ccLHRHM(ax).axs);
%         plotting.ccLHRHMData(s,r).points = copyobj([Plots.(animal).(date).LHRH.(stim).(ref).source.magM.point.PlotL],plotting.ccLHRHM(ax).axs);
%         t = [Plots.(animal).(date).LHRH.(stim).(ref).source.magM.point.twitchPlotL]~=0;
%         if any(t)
%         plotting.ccLHRHMData(s,r).tw = copyobj([Plots.(animal).(date).LHRH.(stim).(ref).source.magM.point(t).twitchPlotL],plotting.ccLHRHM(ax).axs);
%         end
%         
%         plotting.ccLHRHMData(s,r).error = copyobj([Plots.(animal).(date).LHRH.(stim).(ref).source.magM.point.erPlotL],plotting.ccLHRHM(ax).axs);  
%         plotting.ccLHRHM(ax).axs.XTick = [0:50:250];
%         plotting.ccLHRHM(ax).axs.XGrid = 'on';
%         plotting.ccLHRHM(ax).axs.YGrid = 'on';
%         plotting.ccLHRHM(ax).axs.XLim = [0 300];
%         plotting.ccLHRHM(ax).axs.FontSize = 13.5;
%         plotting.ccLHRHM(ax).axs.XLabel.String = {'Current (uA)'};
%         plotting.ccLHRHM(ax).axs.LineWidth = 2.5;
%         
%         switch rf(r)
%             case 11
%                 plotting.ccLHRHMData(s,r).line.Color = [115 98 138]/255;
%                 set(plotting.ccLHRHMData(s,r).points,'Color',[115 98 138]/255);
%                 set(plotting.ccLHRHMData(s,r).error,'Color',[115 98 138]/255);
%                 
%             case 12
%                 plotting.ccLHRHMData(s,r).line.Color = [147 92 188]/255;
%                 set(plotting.ccLHRHMData(s,r).points,'Color',[147 92 188]/255);
%                 set(plotting.ccLHRHMData(s,r).error,'Color',[147 92 188]/255);
%             case 13
%                 plotting.ccLHRHMData(s,r).line.Color = [53 0 36]/255;
%                 set(plotting.ccLHRHMData(s,r).points,'Color',[53 0 36]/255);
%                 set(plotting.ccLHRHMData(s,r).error,'Color',[53 0 36]/255);
%         end
% 
%         if ax>1
%             plotting.ccLHRHV(ax).axs.YTickLabel = [];
%             plotting.ccLHRHM(ax).axs.YTickLabel = [];
%         else
%             plotting.ccLHRHV(ax).axs.YLabel.String = {'Velocity (dps)'};
%             plotting.ccLHRHV(ax).axs.YLabel.FontSize = 22;
%             plotting.ccLHRHM(ax).axs.YLabel.String = {'Misalignment (degrees)'};
%             plotting.ccLHRHM(ax).axs.YLabel.FontSize = 22;
%         end
%         tn = Plots.(animal).(date).LHRH.(stim).(ref).source.magM.ldgNameL;
%         if length(tn)==2
%             co = tn(2);
%             coFlag = 1;
%             coID = [s,r];
%             if ~isempty(plotting.names)
%                 if ~ismember(tn(1),plotting.names)
%                     plotting.names = [tn(1) plotting.names];
%                 end
%             else
%                 plotting.names = [tn(1) plotting.names];
%             end
%         else
%             if ~isempty(plotting.names)
%                 if ~ismember(tn,plotting.names)
%                     plotting.names = [{tn} plotting.names];
%                 end
%             else
%                 plotting.names = [{tn} plotting.names];
%             end
%         end
%             
%     end
%     if s<length(st)
%     ax = ax+1;
%     end
% end
% sameaxes([],[plotting.ccLHRHV.axs]);
% sameaxes([],[plotting.ccLHRHM.axs]);
%     
%         xP = [25 50 75 100 125 150 175 200 225 250];
% for patchP = 1:length(st)
%     if ~isempty([plotting.ccLHRHVData(patchP,:).co])
%     pos = max(find(xP<mean([plotting.ccLHRHVData(patchP,:).co])));
%     x = [0 xP(pos) xP(pos) 0];
%     x = [0 min([plotting.ccLHRHVData(patchP,:).co]) min([plotting.ccLHRHVData(patchP,:).co]) 0];
%     yV = [plotting.ccLHRHV(patchP).axs.YLim(1) plotting.ccLHRHV(patchP).axs.YLim(1) plotting.ccLHRHV(patchP).axs.YLim(2) plotting.ccLHRHV(patchP).axs.YLim(2)];
%     yM = [plotting.ccLHRHM(patchP).axs.YLim(1) plotting.ccLHRHM(patchP).axs.YLim(1) plotting.ccLHRHM(patchP).axs.YLim(2) plotting.ccLHRHM(patchP).axs.YLim(2)];
%     patch(plotting.ccLHRHV(patchP).axs,x,yV,[105 105 105]/255,'FaceAlpha',.7,'EdgeColor','none')
%     p = patch(plotting.ccLHRHM(patchP).axs,x,yM,[105 105 105]/255,'FaceAlpha',.7,'EdgeColor','none');
%     end
% end
% set([plotting.ccLHRHV.axs],'Layer','Top');
% set([plotting.ccLHRHM.axs],'Layer','Top');
% if coFlag
%     plotting.ldg = legend(plotting.ccLHRHM(ax).axs,[plotting.ccLHRHMData(s,end:-1:1).line p plotting.ccLHRHMData(coID).tw],[plotting.names 'Sub-20dps Threshold' co],'Orientation','horizontal','AutoUpdate','off');
% plotting.ldg.Position = [0.4 0.01 0.1308 0.0192];
% else
%     plotting.ldg = legend(plotting.ccLHRHM(ax).axs,[plotting.ccLHRHMData(s,end:-1:1).line p],[plotting.names 'Sub-20dps Threshold'],'Orientation','horizontal','AutoUpdate','off');
% end
% name = 'eyeMisalignmentandVelocity_Current_ByStim_LHRH_DistantCC_Leye_';
% saveas(plotting.ccLHRHlot,[figDir,name,'.svg']);
% saveas(plotting.ccLHRHlot,[figDir,name,'.jpg']);
% saveas(plotting.ccLHRHlot,[figDir,name,'.fig']);
% %close(plotting.ccLHRHlot);
%%
function ePos = getePos(animal,j)
ePos = '';
switch animal
    case 1
    case 2
    case 'Nancy'
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
    case 'Yoda'
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
            case 'GiGi'
        switch j
            case 1
                ePos = 'Left Posterior, Shallow';
            case 2
                ePos = 'Left Posterior, Middle';
            case 3
                ePos = 'Left Posterior, Deep';
            case 4
                ePos = 'Shallow';
            case 5
                ePos = 'Middle';
            case 6
                ePos = 'Deep';
            case 7
                ePos = 'Deep';
            case 8
                ePos = 'Middle';
            case 9
                ePos = 'Shallow';
            case 10
                ePos = 'Distant';
            case 11
                ePos = 'Common Crus';
        end
end
end