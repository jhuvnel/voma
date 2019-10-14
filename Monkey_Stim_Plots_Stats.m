%%
handles = struct();
handles.allAx = {'LHRH','LARP','RALP'};
[indx, tf] = listdlg('ListString',{'LHRH','LARP','RALP'},'PromptString','Choose canal corresponding to the data.','SelectionMode','single','ListSize',[200 50])
handles.chosenAx = handles.allAx{indx};
handles.allCh = 1:15;
[indx, tf] = listdlg('ListString',{'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15'},'PromptString',{['Choose stimulator channels corresponding to the ',handles.chosenAx,' canal.'];...
    'Use ctrl+click to select channels out of order.'},'SelectionMode','multiple','ListSize',[275 225]);
handles.stimNum = handles.allCh(indx);

[indx, tf] = listdlg('ListString',{'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15'},'PromptString',{['Choose all possible return channels corresponding to the ',handles.chosenAx,' canal.'];...
    'Use ctrl+click to select channels out of order.'},'SelectionMode','multiple','ListSize',[275 225]);
handles.refNum = handles.allCh(indx);

[handles.vomaFile,handles.vomaPath] = uigetfile('*.voma','Select the voma file corresponding to this dataset');
handles.cycDir = uigetdir(path,'Choose directory of cycle files')
%%
load([handles.vomaPath,handles.vomaFile],'-mat')
listing = dir(handles.cycDir);
listing(find(~([listing.bytes]>20000))) = [];
sortNames = sort_nat({listing.name})';
[listing.name] = sortNames{:};
handles.figDir = uigetdir(path,'Choose directory for saved figures')
n = 1;
while n<length({RootData(1,:).QPparams})
    if isempty(RootData(1,n).QPparams)
        RootData(:,n) = [];
        n = n -1;
    end
    n = n+1;
end
%%
cycles = struct();
%%
l_x = [237,150,33]/255;
l_y = [125,46,143]/255;
l_z = [1 0 0];
l_l = [0,128,0]/255;
l_r = [0 0 1];
%%
answer = questdlg('Would you like to plot and save angular position and velocity?', ...
	'Angular Position and Velocity', ...
	'Yes','No','Yes');
% Handle response
switch answer
    case 'Yes'
        handles.PaV = 1;

    case 'No'
handles.PaV = 0;
end

answer = questdlg('Would you like to plot and save Slope examples?', ...
	'Slope Estimation', ...
	'Yes','No','Yes');
% Handle response
switch answer
    case 'Yes'
        handles.Slope = 1;

    case 'No'
handles.Slope = 0;
end

answer = questdlg('Would you like to plot and save Velocity and Misalignment plots?', ...
	'Velocity and Misalignment', ...
	'Yes','No','Yes');
% Handle response
switch answer
    case 'Yes'
        handles.VaM = 1;

    case 'No'
handles.VaM = 0;
end
typePlot = [];
ampNum = 1;
ch7Num = 1;
ch8Num = 1;
ch9Num = 1;
ch15Num = 1;
newStim = 1;
vomaStart = 1;
blue = [0 0 1];
green = [1 0 0];
cMap = jet(8);
totNum = 1;
newPlot = 1;
figNum = 1;
twitch = 0;
title = 1;
prevMaxM = 1;
prevMaxV = 1;
oneTime = 1;
max7D = struct('V',[],'M',[]);
max7CC = struct('V',[],'M',[]);
max7Inter = struct('V',[],'M',[]);
max8D = struct('V',[],'M',[]);
max8CC = struct('V',[],'M',[]);
max8Inter = struct('V',[],'M',[]);
max9D = struct('V',[],'M',[]);
max9CC = struct('V',[],'M',[]);
max9Inter = struct('V',[],'M',[]);
max15D = struct('V',[],'M',[]);
max15CC = struct('V',[],'M',[]);
max15Inter = struct('V',[],'M',[]);
stimGo = 1;
refGo = 1;
ampGo = 1;
stimInd = 1;
refInd = 1;
ampInd = 1;
total = 1;
prevRef = 0;
prevStim = 0;
while stimGo
    currentStim = handles.stimNum(stimInd);
    PlotName = ['Plot',num2str(currentStim)];
    AxName = ['magAx',num2str(currentStim)];
    a={listing(:).name};
    b=a(:);
    f = find(contains(b,['stim',num2str(currentStim)]))
    ts = 0;
    for q=1:length(handles.refNum)
        if any(contains(b(f),['ref',handles.refNum(q)]))
            ts = ts+1
        end
    end
    figNum = 1;
    title = 1;
    handles.avMagP.(PlotName) = figure('units','normalized','outerposition',[0 0 1 1]);
    handles.avMagA.(AxName)= subtightplot(1,ts,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avMagP.(PlotName));
    handles.avgMisP.(PlotName) = figure('units','normalized','outerposition',[0 0 1 1]);
    handles.avgMisA.(AxName) = subtightplot(1,ts,figNum,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', handles.avgMisP.(PlotName));
    handles.avMagA.(AxName).XTick = [0:50:300];
     handles.avgMisA.(AxName).XTick = [0:50:300];
    handles.avMagA.(AxName).XGrid = 'on'
   handles.avMagA.(AxName).YGrid = 'on'
    handles.avgMisA.(AxName).XGrid = 'on'
     handles.avgMisA.(AxName).YGrid = 'on'
    while refGo
        currentRef = handles.refNum(handles.refNum~=currentStim);
        ampGo = 1;
        while ampGo
             if contains(listing(total).name,{'stim'}) && (listing(total).bytes>0)
                        directory = [listing(i).folder,'\'];
                        filename = listing(i).name;
                        load(filename);
                        dashes = find(filename=='-');
                        dotF = find(filename=='.');
                        ch = strfind(filename,'stim');
                        amp = strfind(filename,'amp');
                         axis = handles.chosenAx;
                        n = [filename(dashes(6)+1:dashes(7)-1) filename(dashes(8)+1:dotF(1)-10)];
                        r = strfind(filename,'ref');
                        cycles.(n).stim = str2num(filename(ch+4:r-1));
                        cycles.(n).ref = str2num(filename(r+3:dashes(find((dashes-r)>0,1))-1));
                        cycles.(n).amp = str2num(filename(amp(1)+3:dotF-10));
                        cycles.(n).cycavg = [Results.ll_cycavg' Results.lr_cycavg' Results.lz_cycavg'];
                        t = 1/Results.Fs:1/Results.Fs:length(Results.ll_cycavg)/Results.Fs;
                        cycles.(n).time = [t' t' t'];
                        cycles.(n).std = [Results.ll_cycstd' Results.lr_cycstd' Results.lz_cycstd'];
                        d = diff(Results.ll_cyc');
                        ind = [];
                        slopel = [];
                        sloper = [];
                        slopez = [];
                        maxIndl = [];
                        maxIndr = [];
                        maxIndz = [];
                        maxVall = [];
                        maxValr = [];
                        maxValz = [];
                        maxMag = [];
                        avgMisalign = [];
                        ang = [];
                        if handles.Pav
                        posFig = figure;
                        posFig.Units = 'normalized'
                        posFig.Position = [0 0 1 1];
                        posAx = axes(posFig);
                        allCycfig = figure;
                        allCycfig.Units = 'normalized'
                        allCycfig.Position = [0 0 1 1];
                        allCycAx = axes(allCycfig);
                        end
                        t = t';
                        allYaw = [0 0 1];
                        if handles.Slope
                        slopeFig = figure;
                        ax3 = axes(slopeFig);
                        end
                        for s = 1:size(d,2)
                            [Y Il] = min(abs(diff(Results.ll_cyc(s,1:30)')));
                            [Y Ir] = min(abs(diff(Results.lr_cyc(s,1:30)')));
                            [Y Iz] = min(abs(diff(Results.lz_cyc(s,1:30)')));
                            if Il<10
                                [r e2] = min([Results.ll_cyc(s,1:30)]);
                                [r e3] = max([Results.ll_cyc(s,1:30)]);
                                dlmax = max(e2,e3);
                            else
                                dlmax = Il;
                            end
                            if Ir<10
                                [r e2r] = min([Results.lr_cyc(s,1:30)]);
                                [r e3r] = max([Results.lr_cyc(s,1:30)]);
                                drmax = max(e2r,e3r);
                            else
                                drmax = Ir;
                            end
                            if Iz<10
                                [r e2z] = min([Results.lz_cyc(s,1:30)]);
                                [r e3z] = max([Results.lz_cyc(s,1:30)]);
                                dzmax = max(e2z,e3z);
                            else
                                dzmax = Iz;
                            end
                            ipt = findchangepts(Results.ll_cyc(s,1:dlmax)','Statistic','linear');
                            iptr = findchangepts(Results.lr_cyc(s,1:drmax)','Statistic','linear');
                            iptz = findchangepts(Results.lz_cyc(s,1:dzmax)','Statistic','linear');
                            dl = ipt-1;
                            dr = iptr-1;
                            dz = iptz-1;
                            pl = polyfit(cycles.(n).time(1:(dl),1),Results.ll_cyc(s,1:(dl))',1);
                            pr = polyfit(cycles.(n).time(1:(dr),1),Results.lr_cyc(s,1:(dr))',1);
                            pz = polyfit(cycles.(n).time(1:(dz),1),Results.lz_cyc(s,1:(dz))',1);
                            slopel = [slopel; pl];
                            sloper = [sloper; pr];
                            slopez = [slopez; pz];
                            [mag, imag] = max(sqrt((Results.ll_cyc(s,1:(30))).^2+(Results.lr_cyc(s,1:(30))).^2+(Results.lz_cyc(s,1:(30))).^2))
                            w = [Results.ll_cyc(s,imag) Results.lr_cyc(s,imag) Results.lz_cyc(s,imag)]./mag
                            avgMisalign = [avgMisalign; atan2d(norm(cross(allYaw,w)), dot(allYaw,w))]
                            [yl, il] = max(abs(Results.ll_cyc(s,1:(30))));
                            [yr, ir] = max(abs(Results.lr_cyc(s,1:(30))));
                            [yz, iz] = max(abs(Results.lz_cyc(s,1:(30))));
                            maxIndl = [maxIndl; il];
                            maxIndr = [maxIndr; ir];
                            maxIndz = [maxIndz; iz];
                            maxVall = [maxVall; Results.ll_cyc(s,il)];
                            maxValr = [maxValr; Results.lr_cyc(s,ir)];
                            maxValz = [maxValz; Results.lz_cyc(s,iz)];
                            maxMag = [maxMag; mag];
                            if handles.PaV

                            hold(allCycAx,'on');
                            plot(t,Results.stim(1,:),'k','LineWidth',1,'Parent',allCycAx,'LineWidth',4);
                            plot(t,Results.ll_cyc(s,:)','color',l_l,'LineWidth',1,'Parent',allCycAx,'LineWidth',4);
                            plot(t,Results.lr_cyc(s,:)','color',l_r,'LineWidth',1,'Parent',allCycAx,'LineWidth',4);
                            plot(t,Results.lz_cyc(s,:)','color',l_z,'LineWidth',1,'Parent',allCycAx,'LineWidth',4);
                            range = RootData(i).VOMA_data.stim_ind(Results.cyclist(s)):RootData(i).VOMA_data.stim_ind(Results.cyclist(s))+length(Results.ll_cycavg)-1;
                            patchline(t,RootData(i).VOMA_data.Data_LE_Vel_LARP(range),'edgecolor',l_l,'facecolor',l_l,'facealpha',0.5,'LineWidth',0.05,'edgealpha',0.5,'Parent',allCycAx,'LineWidth',4);
                            patchline(t,RootData(i).VOMA_data.Data_LE_Vel_RALP(range),'edgecolor',l_r,'facecolor',l_r,'facealpha',0.5,'LineWidth',0.05,'edgealpha',0.5,'Parent',allCycAx,'LineWidth',4);
                            patchline(t,RootData(i).VOMA_data.Data_LE_Vel_Z(range),'edgecolor',l_z,'facecolor',l_z,'facealpha',0.5,'LineWidth',0.05,'edgealpha',0.5,'Parent',allCycAx,'LineWidth',4);
                            p1 = plot(t(imag,1),Results.ll_cyc(s,imag)','color',l_l,'Marker','*','Parent',allCycAx,'MarkerSize',15);
                            p2 = plot(t(imag,1),Results.lr_cyc(s,imag)','color',l_r,'Marker','*','Parent',allCycAx,'MarkerSize',15);
                            p3 = plot(t(imag,1),Results.lz_cyc(s,imag)','color',l_z,'Marker','*','Parent',allCycAx,'MarkerSize',15);
                            t = t+0.5;
                            hold(allCycAx,'off');
                            
                            hold(posAx,'on')
                            RootData(i).VOMA_data.Stim_Trace(isnan(RootData(i).VOMA_data.Stim_Trace))=0
                            plot(posAx,RootData(i).VOMA_data.Stim_t,RootData(i).VOMA_data.Stim_Trace,'k','LineWidth',4)
                            plot(posAx,RootData(i).VOMA_data.Eye_t,RootData(i).VOMA_data.Filtered.Data_LE_Pos_X,'color',l_x,'LineWidth',4)
                            plot(posAx,RootData(i).VOMA_data.Eye_t,RootData(i).VOMA_data.Filtered.Data_LE_Pos_Y,'color',l_y,'LineWidth',4)
                            plot(posAx,RootData(i).VOMA_data.Eye_t,RootData(i).VOMA_data.Filtered.Data_LE_Pos_Z,'color',l_z,'LineWidth',4)
                            patchline(RootData(i).VOMA_data.Eye_t',RootData(i).VOMA_data.Data_LE_Pos_X,'edgecolor',l_x,'facecolor',l_x,'facealpha',0.5,'LineWidth',0.05,'edgealpha',0.5,'Parent',posAx,'LineWidth',4);
                            patchline(RootData(i).VOMA_data.Eye_t',RootData(i).VOMA_data.Data_LE_Pos_Y,'edgecolor',l_y,'facecolor',l_y,'facealpha',0.5,'LineWidth',0.05,'edgealpha',0.5,'Parent',posAx,'LineWidth',4);
                            patchline(RootData(i).VOMA_data.Eye_t',RootData(i).VOMA_data.Data_LE_Pos_Z,'edgecolor',l_z,'facecolor',l_z,'facealpha',0.5,'LineWidth',0.05,'edgealpha',0.5,'Parent',posAx,'LineWidth',4);

                            hold(posAx,'off')
                            end
                            if handles.Slope
                            xlabel(ax3,'Time (s)');
                            ylabel(ax3, 'Left Eye Velocity (dps)');
                            hold(ax3,'on');
                            plot(ax3,cycles.(n).time(1:30,1),Results.ll_cyc(s,1:30)','color',l_l);
                            plot(ax3,cycles.(n).time(1:30,1),Results.lr_cyc(s,1:30)','color',l_r);
                            plot(ax3,cycles.(n).time(1:30,1),Results.lz_cyc(s,1:30)','color',l_z);
                            plot(ax3,cycles.(n).time(1:15,1),polyval(pl,cycles.(n).time(1:15,2)),'k--');
                            plot(ax3,cycles.(n).time(1:15,1),polyval(pr,cycles.(n).time(1:15,2)),'k:');
                            plot(ax3,cycles.(n).time(1:15,1),polyval(pz,cycles.(n).time(1:15,2)),'k-.');
                            hold(ax3,'off');
                            end
                            

                        end
                        if handles.PaV
                                  allCycAx.FontSize = 24;
                                  posAx.FontSize = 24;
                            allCycAx.Title.String = 'Left Eye Angular Velocity'
                            allCycAx.XLabel.String = 'Time (s)'
                            allCycAx.YLabel.String = 'Velocity (dps)'
                           leg = legend(allCycAx,'Stimulus Trigger','LARP','RALP','LHRH','Orientation','horizontal');
                            grid(allCycAx,'on')
                            ylim(allCycAx,[-300 300])
                            posAx.Title.String = 'Left Eye Angular Position'
                            posAx.XLabel.String = 'Time (s)'
                            posAx.YLabel.String = 'Position (degrees)'
                           leg = legend(posAx,'Stimulus Trigger','X','Y','Z','Orientation','horizontal');
                            grid(posAx,'on')
                            leg.Position = [0.6304 0.1440 0.2429 0.2000];
                            sameaxes('x', [posFig,allCycfig]);
                            saveas(allCycfig,[handles.figDir,'Stim',num2str(cycles.(n).stim), 'Ref',num2str(cycles.(n).ref),'amp',num2str(cycles.(n).amp),'AllCycles'])
                            saveas(posFig,[handles.figDir,'Stim',num2str(cycles.(n).stim), 'Ref',num2str(cycles.(n).ref),'amp',num2str(cycles.(n).amp),'POS'])
                        end
                        if handles.Slope
                            saveas(slopeFig,[handles.figDir,'Stim',num2str(cycles.(n).stim), 'Ref',num2str(cycles.(n).ref),'amp',num2str(cycles.(n).amp),'CheckSlope', cycles.(n).axis,'.fig'])
                            
                            cycles.(n).slope = [slopel sloper slopez];
                        end
                        cycles.(n).maxMag = maxMag;
                        cycles.(n).avgMisalign = avgMisalign;
             end
             if str2num(nextFilename(namp(1)+3:ndot-10))<cycles.(n).amp
                 ampInd = 1;
                 ampGo = 0;
             end
             
        end
        if currentRef ~= prevRef
            hold(handles.avMagA.(AxName),'on');
            handles.p(total,ampInd) = plot(handles.avMagA.(AxName),cycles.(n).amp,mean(cycles.(n).maxMag),'color',colorPlot,'marker','o','MarkerSize',10,'LineWidth',2);
            cycles.(n).Vstdev =  std(cycles.(n).maxMag);
            errorbar(handles.avMagA.(AxName),cycles.(n).amp,mean(cycles.(n).maxMag),cycles.(n).Vstdev,'color',colorPlot,'LineWidth',2.5)
%             if twitch==1
%                 cutOff2 = line(handles.avMag.(AxName),[cycles.(n).amp cycles.(n).amp],handles.avMag.(AxName).YLim,'color',[1 0 0],'LineWidth',3)
%                 
%                 ldg2 = legend(handles.avMag.(AxName),[cutOff2],'Cutoff Due To Facial Nerve Stimulation','AutoUpdate','off')
%                 ldg2.Position = [0.8105 0.9494 0.1308 0.0192];
%                 ldg2.FontSize = 13.5;
%                 
%             end
            handles.avMagA.(AxName).LineWidth = 2.5;
            hold(handles.avMagA.(AxName),'off');
            hold(handles.avgMisA.(AxName),'on');
            handles.q(total,ampInd) = plot(handles.avgMisA.(AxName),cycles.(n).amp,mean(cycles.(n).avgMisalign),'color',colorPlot,'marker','o','MarkerSize',10,'LineWidth',2);
            
            cycles.(n).Mstdev =  std(cycles.(n).avgMisalign);
            errorbar(handles.avgMisA.(AxName),cycles.(n).amp,mean(cycles.(n).avgMisalign),cycles.(n).Mstdev,'color',colorPlot,'LineWidth',2.5);
%             if twitch==1
%                 cutOff1 = line(handles.avgMis.(AxName),[cycles.(n).amp cycles.(n).amp],handles.avgMis.(AxName).YLim,'color',[1 0 0],'LineWidth',3)
%                 
%                 ldg1 = legend(handles.avgMis.(AxName),[cutOff1],'Cutoff Due To Facial Nerve Stimulation','AutoUpdate','off')
%                 ldg1.Position = [0.8105 0.9494 0.1308 0.0192];
%                 ldg1.FontSize = 13.5;
%                 twitch = 0;
%             end
            handles.avgMisA.(AxName).LineWidth = 2.5;
            hold(handles.avgMisA.(AxName),'off');
            handles.typePlot(total,ampInd) = cycles.(n).stim;
            ylabel(handles.avMag.(AxName),'Left Eye Velocity Magnitude (dps)','FontSize',22);
            handles.avMagA.(AxName).FontSize = 13.5;
            ylabel(handles.avgMisA.(AxName),'Misalignment (degrees)','FontSize',22);
            handles.avgMisA.(AxName).FontSize = 13.5;
                sgtitle(figMagUse,['Average Eye Velocity Magnitude, Source Electrode ',num2str(cycles.(n).stim)],'FontSize', 26, 'FontWeight', 'Bold');
                sgtitle(figAlgnUse,['Angle of Misalignment, Source Electrode ',num2str(cycles.(n).stim)],'FontSize', 26, 'FontWeight', 'Bold');
            if str2num(nextFilename(namp(1)+3:ndot-10))<cycles.(n).amp
                hold(handles.avMagA.(AxName),'on');
                line(handles.avMagA.(AxName),[p(totNum,1:ampNum).XData],[p(totNum,1:ampNum).YData],'color',colorPlot,'LineWidth',4)
                hold(handles.avMagA.(AxName),'off');
                handles.avMagA.(AxName).XLabel.String = {'Current (uA)';['Return Electrode ',num2str(cycles.(n).ref)]}
                handles.avMagA.(AxName).XLabel.FontSize = 22;
                hold(handles.avgMisA.(AxName),'on');
                line(handles.avgMisA.(AxName),[q(totNum,1:ampNum).XData],[q(totNum,1:ampNum).YData],'color',colorPlot,'LineWidth',4)
                hold(handles.avgMisA.(AxName),'off');
                handles.avgMisA.(AxName).XLabel.String = {'Current (uA)';['Return Electrode ',num2str(cycles.(n).ref)]}
                handles.avgMisA.(AxName).XLabel.FontSize = 22;
                if any(strfind(labString{2},'15'))
                    lngofPlots = length(get(figMagUse,'Children'))
                    Vch = get(figMagUse,'Children')
                    movePosV = get(Vch(lngofPlots-2),'Position');
                    Mch = get(figAlgnUse,'Children')
                    movePosM = get(Mch(lngofPlots-2),'Position');
                    V =get(figMagUse,'Children');
                    M = get(figAlgnUse,'Children');
                    for movPlot = lngofPlots-2:-1:2
                        V(movPlot).Position = V(movPlot-1).Position;
                        M(movPlot).Position = M(movPlot-1).Position;
                    end
                    V(1).Position = movePosV;
                    M(1).Position = movePosM;
                    set(figMagUse,'Children',V)
                    set(figAlgnUse,'Children',M)
                end
                handles.avMagA.(AxName).FontSize = 13.5;
                handles.avgMisA.(AxName).FontSize = 13.5;
                 currentRef = handles.refNum(handles.refNum~=currentStim);
                total = 1+ total;
                ampInd = 1+ampInd;
            else
                ampInd = 1+ampInd;
            end
        else
            hold(handles.avMagA.(AxName),'on');
            handles.p(total,ampInd) = plot(handles.avMagA.(AxName),cycles.(n).amp,mean(cycles.(n).maxMag),'color',colorPlot,'marker','o','MarkerSize',10,'LineWidth',2);
            cycles.(n).Vstdev =  std(cycles.(n).maxMag);
            errorbar(handles.avMagA.(AxName),cycles.(n).amp,mean(cycles.(n).maxMag),cycles.(n).Vstdev,'color',colorPlot,'LineWidth',2.5)
%             if twitch==1
%                 cutOff2 = line(handles.avMag.(AxName),[cycles.(n).amp cycles.(n).amp],[0 300],'color',[1 0 0],'LineWidth',3,'LineStyle','--')
%                 
%                 ldg2 = legend(handles.avMag.(AxName),[cutOff2],'Cutoff Due To Facial Nerve Stimulation','AutoUpdate','off')
%                 ldg2.Position = [0.8105 0.9494 0.1308 0.0192];
%                 ldg2.FontSize = 13.5;
%             end
            handles.avMagA.(AxName).LineWidth = 2.5;
            hold(handles.avMagA.(AxName),'off');
            hold(handles.avMisA.(AxName),'on');
            handles.q(total,ampInd) = plot(handles.avMisA.(AxName),cycles.(n).amp,mean(cycles.(n).avgMisalign),'color',colorPlot,'marker','o','MarkerSize',10,'LineWidth',2);
            cycles.(n).Mstdev =  std(cycles.(n).avgMisalign);
            errorbar(handles.avMisA.(AxName),cycles.(n).amp,mean(cycles.(n).avgMisalign),cycles.(n).Mstdev,'color',colorPlot,'LineWidth',2.5);
            if twitch==1
                cutOff1 = line(handles.avMis.(AxName),[cycles.(n).amp cycles.(n).amp],[0 180],'color',[1 0 0],'LineWidth',3,'LineStyle','--')
                
                ldg1 = legend(handles.avMis.(AxName),[cutOff1],'Cutoff Due To Facial Nerve Stimulation','AutoUpdate','off')
                ldg1.Position = [0.8105 0.9494 0.1308 0.0192];
                ldg1.FontSize = 13.5;
                twitch = 0;
            end
            handles.avMis.(AxName).LineWidth = 2.5;
            hold(handles.avMis.(AxName),'off');
            typePlot(totNum,ampNum) = cycles.(n).stim;
            if str2num(nextFilename(namp(1)+3:ndot-10))<cycles.(n).amp
                hold(handles.avMag.(AxName),'on');
                line(handles.avMag.(AxName),[p(totNum,1:ampNum).XData],[p(totNum,1:ampNum).YData],'color',colorPlot,'LineWidth',4)
                hold(handles.avMag.(AxName),'off');
                handles.avMag.(AxName).XLabel.String = {'Current (uA)';['Return Electrode ',num2str(cycles.(n).ref)]}
                
                
                hold(handles.avMis.(AxName),'on');
                line(handles.avMis.(AxName),[q(totNum,1:ampNum).XData],[q(totNum,1:ampNum).YData],'color',colorPlot,'LineWidth',4)
                hold(handles.avMis.(AxName),'off');
                handles.avMis.(AxName).XLabel.String = {'Current (uA)';['Return Electrode ',num2str(cycles.(n).ref)]};
                
                labString = get(get(handles.avMag.(AxName),'XLabel'),'String');
                
                if any(strfind(labString{2},'15'))
                    lngofPlots = length(findobj(figMagUse.Children,'Type','axes'))
                    Vch = get(figMagUse,'Children')
                    movePosV = get(Vch(lngofPlots-2),'Position');
                    Mch = get(figAlgnUse,'Children')
                    movePosM = get(Mch(lngofPlots-2),'Position');
                    V = findobj(figMagUse.Children,'Type','axes');
                    M = findobj(figAlgnUse.Children,'Type','axes');
                    plotN = 7;
                    for limRep = length(get(figMagUse,'Children')):-1:1
                        if isgraphics(figMagUse.Children(limRep),'Axes')
                            
                            if plotN<6
                                if plotN==5
                                    movePosV = figAlgnUse.Children(limRep).Position;
                                    movePosM = figMagUse.Children(limRep).Position;
                                end
                                if limRep>1
                                    figAlgnUse.Children(limRep).Position = M(plotN-1).Position;
                                    figMagUse.Children(limRep).Position = V(plotN-1).Position;
                                else
                                    figAlgnUse.Children(limRep).Position = movePosV;
                                    figMagUse.Children(limRep).Position = movePosM;
                                end
                                
                                
                            end
                            
                            
                            plotN = plotN-1;
                        end
                    end
                    
                    
                    
                end
                
                handles.avMag.(AxName).XGrid = 'on'
                handles.avMag.(AxName).YGrid = 'on'
                handles.avMis.(AxName).XGrid = 'on'
                handles.avMis.(AxName).YGrid = 'on'
                handles.avMag.(AxName).XLim = [0 350];
                handles.avMis.(AxName).XLim = [0 350];
                handles.avMag.(AxName).XTick = [0:50:300]
                handles.avMis.(AxName).XTick = [0:50:300]
                axM = findobj(figMagUse.Children,'Type','axes');
                axA = findobj(figAlgnUse.Children,'Type','axes');
                upperYMag = max([axM.YLim]);
                upperYMisalign = max([axA.YLim]);
                if oneTime==1
                    prevMaxM =  upperYMisalign;
                    PrevMaxV = upperYMag;
                    oneTime = 0;
                else
                    if prevMaxM>upperYMisalign
                        upperYMisalign = prevMaxM;
                    else
                        prevMaxM =  upperYMisalign;
                    end
                    if prevMaxV>upperYMag
                        upperYMag = prevMaxV;
                    else
                        PrevMaxV = upperYMag;
                    end
                end
                
                handles.avMag.(AxName).FontSize = 13.5;
                handles.avMis.(AxName).FontSize = 13.5;
                newPlot = 1;
                totNum = 1+ totNum;
                ampNum = 1;
                
            else
                if i==length(listing)
                    hold(handles.avMag.(AxName),'on');
                    line(handles.avMag.(AxName),[p(totNum,1:ampNum).XData],[p(totNum,1:ampNum).YData],'color',colorPlot,'LineWidth',4)
                    hold(handles.avMag.(AxName),'off');
                    handles.avMag.(AxName).XLabel.String = {'Current amplitude (uA)';['Return Electrode ',num2str(cycles.(n).ref)]}
                    
                    hold(handles.avMis.(AxName),'on');
                    line(handles.avMis.(AxName),[q(totNum,1:ampNum).XData],[q(totNum,1:ampNum).YData],'color',colorPlot,'LineWidth',4)
                    hold(handles.avMis.(AxName),'off');
                    handles.avMis.(AxName).XLabel.String = {'Current amplitude (uA)';['Return Electrode ',num2str(cycles.(n).ref)]};
                    labString = get(get(handles.avMag.(AxName),'XLabel'),'String');
                    handles.avMag.(AxName).XGrid = 'on'
                    handles.avMag.(AxName).YGrid = 'on'
                    handles.avMis.(AxName).XGrid = 'on'
                    handles.avMis.(AxName).YGrid = 'on'
                    handles.avMag.(AxName).XLim = [0 350];
                    handles.avMis.(AxName).XLim = [0 350];
                    handles.avMag.(AxName).XTick = [0:50:300];
                    handles.avMis.(AxName).XTick = [0:50:300];
                    sameaxes([], [avgMagPlot7,avgMagPlot8,avgMagPlot9,avgMagPlot15]);
                    sameaxes([], [avgMisalignPlot7,avgMisalignPlot8,avgMisalignPlot9,avgMisalignPlot15]);
                    
                    
                    axM = findobj(figMagUse.Children,'Type','axes');
                    axA = findobj(figAlgnUse.Children,'Type','axes');
                    upperYMag = max([axM.YLim]);
                    upperYMisalign = max([axA.YLim]);
                    for limRep = 1:length(figAlgnUse.Children)
                        if isgraphics(figMagUse.Children(limRep),'Axes')
                            figAlgnUse.Children(limRep).YLim = [0 upperYMisalign];
                            figMagUse.Children(limRep).YLim = [0 upperYMag];
                            for vertY = 1:length(figMagUse.Children(limRep).Children)
                                if all(figMagUse.Children(limRep).Children(vertY).Color==[1 0 0])
                                    figMagUse.Children(limRep).Children(vertY).YData = figMagUse.Children(limRep).YLim;
                                    figAlgnUse.Children(limRep).Children(vertY).YData = figAlgnUse.Children(limRep).YLim;
                                    
                                end
                            end
                        end
                    end
                    handles.avMag.(AxName).FontSize = 13.5;
                    handles.avMis.(AxName).FontSize = 13.5;
                    newPlot = 1;
                    
                    saveas(avgMisalignPlot7,[handles.figDir,'stim7Misalignment','.svg']);
                    saveas(avgMisalignPlot7,[handles.figDir,'stim7Misalignment','.jpg']);
                    saveas(avgMagPlot7,[handles.figDir,'stim7velMag','.svg']);
                    saveas(avgMagPlot7,[handles.figDir,'stim7velMag','.jpg']);
                    saveas(avgMisalignPlot8,[handles.figDir,'stim8Misalignment','.svg']);
                    saveas(avgMisalignPlot8,[handles.figDir,'stim8Misalignment','.jpg']);
                    saveas(avgMagPlot8,[handles.figDir,'stim8velMag','.svg']);
                    saveas(avgMagPlot8,[handles.figDir,'stim8velMag','.jpg']);
                    saveas(avgMisalignPlot9,[handles.figDir,'stim9Misalignment','.svg']);
                    saveas(avgMisalignPlot9,[handles.figDir,'stim9Misalignment','.jpg']);
                    saveas(avgMagPlot9,[handles.figDir,'stim9velMag','.svg']);
                    saveas(avgMagPlot9,[handles.figDir,'stim9velMag','.jpg']);
                    saveas(avgMisalignPlot15,[handles.figDir,'stim15Misalignment','.svg']);
                    saveas(avgMisalignPlot15,[handles.figDir,'stim15Misalignment','.jpg']);
                    saveas(avgMagPlot15,[handles.figDir,'stim15velMag','.svg']);
                    saveas(avgMagPlot15,[handles.figDir,'stim15velMag','.jpg']);
                    
                end

                
                
            end
            
        end
    end
end





%%


for i = 1:length(listing)
    if contains(listing(i).name,{'stim'}) && (listing(i).bytes>0)
                        directory = [listing(i).folder,'\'];
                        filename = listing(i).name;
                        load(filename);
                        dashes = find(filename=='-');
                        dotF = find(filename=='.');
                        ch = strfind(filename,'stim');
                        amp = strfind(filename,'amp');
                         axis = handles.chosenAx;
                        n = [filename(dashes(6)+1:dashes(7)-1) filename(dashes(8)+1:dotF(1)-10)];
                        r = strfind(filename,'ref');
                        cycles.(n).stim = str2num(filename(ch+4:r-1));
                        cycles.(n).ref = str2num(filename(r+3:dashes(find((dashes-r)>0,1))-1));
                        cycles.(n).amp = str2num(filename(amp(1)+3:dotF-10));
                        cycles.(n).cycavg = [Results.ll_cycavg' Results.lr_cycavg' Results.lz_cycavg'];
                        t = 1/Results.Fs:1/Results.Fs:length(Results.ll_cycavg)/Results.Fs;
                        cycles.(n).time = [t' t' t'];
                        cycles.(n).std = [Results.ll_cycstd' Results.lr_cycstd' Results.lz_cycstd'];
                        d = diff(Results.ll_cyc');
                        ind = [];
                        slopel = [];
                        sloper = [];
                        slopez = [];
                        maxIndl = [];
                        maxIndr = [];
                        maxIndz = [];
                        maxVall = [];
                        maxValr = [];
                        maxValz = [];
                        maxMag = [];
                        avgMisalign = [];
                        ang = [];
                        if handles.Pav
                        posFig = figure;
                        posFig.Units = 'normalized'
                        posFig.Position = [0 0 1 1];
                        posAx = axes(posFig);
                        allCycfig = figure;
                        allCycfig.Units = 'normalized'
                        allCycfig.Position = [0 0 1 1];
                        allCycAx = axes(allCycfig);
                        end
                        t = t';
                        allYaw = [0 0 1];
                        if handles.Slope
                        slopeFig = figure;
                        ax3 = axes(slopeFig);
                        end
                        for s = 1:size(d,2)
                            [Y Il] = min(abs(diff(Results.ll_cyc(s,1:30)')));
                            [Y Ir] = min(abs(diff(Results.lr_cyc(s,1:30)')));
                            [Y Iz] = min(abs(diff(Results.lz_cyc(s,1:30)')));
                            if Il<10
                                [r e2] = min([Results.ll_cyc(s,1:30)]);
                                [r e3] = max([Results.ll_cyc(s,1:30)]);
                                dlmax = max(e2,e3);
                            else
                                dlmax = Il;
                            end
                            if Ir<10
                                [r e2r] = min([Results.lr_cyc(s,1:30)]);
                                [r e3r] = max([Results.lr_cyc(s,1:30)]);
                                drmax = max(e2r,e3r);
                            else
                                drmax = Ir;
                            end
                            if Iz<10
                                [r e2z] = min([Results.lz_cyc(s,1:30)]);
                                [r e3z] = max([Results.lz_cyc(s,1:30)]);
                                dzmax = max(e2z,e3z);
                            else
                                dzmax = Iz;
                            end
                            ipt = findchangepts(Results.ll_cyc(s,1:dlmax)','Statistic','linear');
                            iptr = findchangepts(Results.lr_cyc(s,1:drmax)','Statistic','linear');
                            iptz = findchangepts(Results.lz_cyc(s,1:dzmax)','Statistic','linear');
                            dl = ipt-1;
                            dr = iptr-1;
                            dz = iptz-1;
                            pl = polyfit(cycles.(n).time(1:(dl),1),Results.ll_cyc(s,1:(dl))',1);
                            pr = polyfit(cycles.(n).time(1:(dr),1),Results.lr_cyc(s,1:(dr))',1);
                            pz = polyfit(cycles.(n).time(1:(dz),1),Results.lz_cyc(s,1:(dz))',1);
                            slopel = [slopel; pl];
                            sloper = [sloper; pr];
                            slopez = [slopez; pz];
                            [mag, imag] = max(sqrt((Results.ll_cyc(s,1:(30))).^2+(Results.lr_cyc(s,1:(30))).^2+(Results.lz_cyc(s,1:(30))).^2))
                            w = [Results.ll_cyc(s,imag) Results.lr_cyc(s,imag) Results.lz_cyc(s,imag)]./mag
                            avgMisalign = [avgMisalign; atan2d(norm(cross(allYaw,w)), dot(allYaw,w))]
                            [yl, il] = max(abs(Results.ll_cyc(s,1:(30))));
                            [yr, ir] = max(abs(Results.lr_cyc(s,1:(30))));
                            [yz, iz] = max(abs(Results.lz_cyc(s,1:(30))));
                            maxIndl = [maxIndl; il];
                            maxIndr = [maxIndr; ir];
                            maxIndz = [maxIndz; iz];
                            maxVall = [maxVall; Results.ll_cyc(s,il)];
                            maxValr = [maxValr; Results.lr_cyc(s,ir)];
                            maxValz = [maxValz; Results.lz_cyc(s,iz)];
                            maxMag = [maxMag; mag];
                            if handles.PaV

                            hold(allCycAx,'on');
                            plot(t,Results.stim(1,:),'k','LineWidth',1,'Parent',allCycAx,'LineWidth',4);
                            plot(t,Results.ll_cyc(s,:)','color',l_l,'LineWidth',1,'Parent',allCycAx,'LineWidth',4);
                            plot(t,Results.lr_cyc(s,:)','color',l_r,'LineWidth',1,'Parent',allCycAx,'LineWidth',4);
                            plot(t,Results.lz_cyc(s,:)','color',l_z,'LineWidth',1,'Parent',allCycAx,'LineWidth',4);
                            range = RootData(i).VOMA_data.stim_ind(Results.cyclist(s)):RootData(i).VOMA_data.stim_ind(Results.cyclist(s))+length(Results.ll_cycavg)-1;
                            patchline(t,RootData(i).VOMA_data.Data_LE_Vel_LARP(range),'edgecolor',l_l,'facecolor',l_l,'facealpha',0.5,'LineWidth',0.05,'edgealpha',0.5,'Parent',allCycAx,'LineWidth',4);
                            patchline(t,RootData(i).VOMA_data.Data_LE_Vel_RALP(range),'edgecolor',l_r,'facecolor',l_r,'facealpha',0.5,'LineWidth',0.05,'edgealpha',0.5,'Parent',allCycAx,'LineWidth',4);
                            patchline(t,RootData(i).VOMA_data.Data_LE_Vel_Z(range),'edgecolor',l_z,'facecolor',l_z,'facealpha',0.5,'LineWidth',0.05,'edgealpha',0.5,'Parent',allCycAx,'LineWidth',4);
                            p1 = plot(t(imag,1),Results.ll_cyc(s,imag)','color',l_l,'Marker','*','Parent',allCycAx,'MarkerSize',15);
                            p2 = plot(t(imag,1),Results.lr_cyc(s,imag)','color',l_r,'Marker','*','Parent',allCycAx,'MarkerSize',15);
                            p3 = plot(t(imag,1),Results.lz_cyc(s,imag)','color',l_z,'Marker','*','Parent',allCycAx,'MarkerSize',15);
                            t = t+0.5;
                            hold(allCycAx,'off');
                            
                            hold(posAx,'on')
                            RootData(i).VOMA_data.Stim_Trace(isnan(RootData(i).VOMA_data.Stim_Trace))=0
                            plot(posAx,RootData(i).VOMA_data.Stim_t,RootData(i).VOMA_data.Stim_Trace,'k','LineWidth',4)
                            plot(posAx,RootData(i).VOMA_data.Eye_t,RootData(i).VOMA_data.Filtered.Data_LE_Pos_X,'color',l_x,'LineWidth',4)
                            plot(posAx,RootData(i).VOMA_data.Eye_t,RootData(i).VOMA_data.Filtered.Data_LE_Pos_Y,'color',l_y,'LineWidth',4)
                            plot(posAx,RootData(i).VOMA_data.Eye_t,RootData(i).VOMA_data.Filtered.Data_LE_Pos_Z,'color',l_z,'LineWidth',4)
                            patchline(RootData(i).VOMA_data.Eye_t',RootData(i).VOMA_data.Data_LE_Pos_X,'edgecolor',l_x,'facecolor',l_x,'facealpha',0.5,'LineWidth',0.05,'edgealpha',0.5,'Parent',posAx,'LineWidth',4);
                            patchline(RootData(i).VOMA_data.Eye_t',RootData(i).VOMA_data.Data_LE_Pos_Y,'edgecolor',l_y,'facecolor',l_y,'facealpha',0.5,'LineWidth',0.05,'edgealpha',0.5,'Parent',posAx,'LineWidth',4);
                            patchline(RootData(i).VOMA_data.Eye_t',RootData(i).VOMA_data.Data_LE_Pos_Z,'edgecolor',l_z,'facecolor',l_z,'facealpha',0.5,'LineWidth',0.05,'edgealpha',0.5,'Parent',posAx,'LineWidth',4);

                            hold(posAx,'off')
                            end
                            if handles.Slope
                            xlabel(ax3,'Time (s)');
                            ylabel(ax3, 'Left Eye Velocity (dps)');
                            hold(ax3,'on');
                            plot(ax3,cycles.(n).time(1:30,1),Results.ll_cyc(s,1:30)','color',l_l);
                            plot(ax3,cycles.(n).time(1:30,1),Results.lr_cyc(s,1:30)','color',l_r);
                            plot(ax3,cycles.(n).time(1:30,1),Results.lz_cyc(s,1:30)','color',l_z);
                            plot(ax3,cycles.(n).time(1:15,1),polyval(pl,cycles.(n).time(1:15,2)),'k--');
                            plot(ax3,cycles.(n).time(1:15,1),polyval(pr,cycles.(n).time(1:15,2)),'k:');
                            plot(ax3,cycles.(n).time(1:15,1),polyval(pz,cycles.(n).time(1:15,2)),'k-.');
                            hold(ax3,'off');
                            end
                            

                        end
                        if handles.PaV
                                  allCycAx.FontSize = 24;
                                  posAx.FontSize = 24;
                            allCycAx.Title.String = 'Left Eye Angular Velocity'
                            allCycAx.XLabel.String = 'Time (s)'
                            allCycAx.YLabel.String = 'Velocity (dps)'
                           leg = legend(allCycAx,'Stimulus Trigger','LARP','RALP','LHRH','Orientation','horizontal');
                            grid(allCycAx,'on')
                            ylim(allCycAx,[-300 300])
                            posAx.Title.String = 'Left Eye Angular Position'
                            posAx.XLabel.String = 'Time (s)'
                            posAx.YLabel.String = 'Position (degrees)'
                           leg = legend(posAx,'Stimulus Trigger','X','Y','Z','Orientation','horizontal');
                            grid(posAx,'on')
                            leg.Position = [0.6304 0.1440 0.2429 0.2000];
                            sameaxes('x', [posFig,allCycfig]);
                            saveas(allCycfig,[handles.figDir,'Stim',num2str(cycles.(n).stim), 'Ref',num2str(cycles.(n).ref),'amp',num2str(cycles.(n).amp),'AllCycles'])
                            saveas(posFig,[handles.figDir,'Stim',num2str(cycles.(n).stim), 'Ref',num2str(cycles.(n).ref),'amp',num2str(cycles.(n).amp),'POS'])
                        end
                        if handles.Slope
                            saveas(slopeFig,[handles.figDir,'Stim',num2str(cycles.(n).stim), 'Ref',num2str(cycles.(n).ref),'amp',num2str(cycles.(n).amp),'CheckSlope', cycles.(n).axis,'.fig'])
                            
                            cycles.(n).slope = [slopel sloper slopez];
                        end
                        cycles.(n).maxMag = maxMag;
                        cycles.(n).avgMisalign = avgMisalign;
                        
%                         if handles.VaM
%                               if i<length(listing)
%                              nextFilename = listing(i+1).name;
%                              ndot = find(nextFilename=='.');
%                         namp = strfind(nextFilename,'amp');
%                               else
%                                   nextFilename = 'amp500ppppppppp.';
%                                   ndot = find(nextFilename=='.');
%                         namp = strfind(nextFilename,'amp');
%                         
%                               end
                              

                       
                           
                                             
                                          
                              if (newStim==2) && (totNum>1)
                                  axMagUse.XLim = [0 350];
                                              axAlgnUse.XLim = [0 350];
                                              axMagUse.XTick = [0:50:300]
                                              axAlgnUse.XTick = [0:50:300]
                                              axM = findobj(figMagUse.Children,'Type','axes');
                                              axA = findobj(figAlgnUse.Children,'Type','axes');
                                          upperYMag = max([axM.YLim]);
                                          upperYMisalign = max([axA.YLim]);
                                          for limRep = 1:length(figAlgnUse.Children)
                                             if isgraphics(figMagUse.Children(limRep),'Axes')
                                              figAlgnUse.Children(limRep).YLim = [0 upperYMisalign];
                                              figMagUse.Children(limRep).YLim = [0 upperYMag];
                                              for vertY = 1:length(figMagUse.Children(limRep).Children)
                                                  if all(figMagUse.Children(limRep).Children(vertY).Color==[1 0 0])
                                                      figMagUse.Children(limRep).Children(vertY).YData = figMagUse.Children(limRep).YLim;
                                                  end
                                              end
                                             end
                                          end
                                          axMagUse.XGrid = 'on'
                                          axMagUse.YGrid = 'on'
                                          axAlgnUse.XGrid = 'on'
                                          axAlgnUse.YGrid = 'on'
                                         
                                          
                                              
                              end
                              c = [l_l; l_r; l_z];
                              switch cycles.(n).stim
                                  case 7
                                      if ch7Num==1
%                                           figNum = 1;
%                                           title = 1;
%                                           avgMagPlot7 = figure('units','normalized','outerposition',[0 0 1 1]);
%                                           avgMagax7 = subtightplot(1,7,figNum,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', avgMagPlot7);
%                                           refName = {'Channel 8'; 'Channel 9'; 'Channel 15'; 'Channel 10'; 'Channel 11'; 'Channel 12'; 'Channel 13'};
%                                           yPts.ypts7 = struct('c8',[],'c9',[],'c15',[],'c10',[],'c11',[],'c12',[],'c13',[]);
%                                           avgMisalignPlot7 = figure('units','normalized','outerposition',[0 0 1 1]);
%                                           avgMisalignax7 = subtightplot(1,7,figNum,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', avgMisalignPlot7);
%                                           fNames = fieldnames(yPts.ypts7);
%                                           avgMagax7.XTick = [0:50:300];
%                                           avgMisalignax7.XTick = [0:50:300];
%                                           avgMagax7.XGrid = 'on'
%                                           avgMagax7.YGrid = 'on'
%                                           avgMisalignax7.XGrid = 'on'
%                                           avgMisalignax7.YGrid = 'on'
                                      elseif newPlot == 1
                                          avgMagax7.XLim = [0 350];
                                              avgMisalignax7.XLim = [0 350];
                                              avgMagax7.XTick = [0:50:300]
                                              avgMisalignax7.XTick = [0:50:300]

                                              axM = findobj(figMagUse.Children,'Type','axes');
                                              axA = findobj(figAlgnUse.Children,'Type','axes');
                                          upperYMag = max([axM.YLim]);
                                          upperYMisalign = max([axA.YLim]);
                                          for limRep = 1:length(figAlgnUse.Children)
                                             if isgraphics(figMagUse.Children(limRep),'Axes')
                                              figAlgnUse.Children(limRep).YLim = [0 upperYMisalign];
                                              figMagUse.Children(limRep).YLim = [0 upperYMag];
                                              for vertY = 1:length(figMagUse.Children(limRep).Children)
                                                  if all(figMagUse.Children(limRep).Children(vertY).Color==[1 0 0])
                                                      figMagUse.Children(limRep).Children(vertY).YData = figMagUse.Children(limRep).YLim;
                                                  end
                                              end
                                             end
                                          end
                                          avgMagax7.XGrid = 'on'
                                          avgMagax7.YGrid = 'on'
                                          avgMisalignax7.XGrid = 'on'
                                          avgMisalignax7.YGrid = 'on'
                                          figNum = figNum +1;
                                          avgMagax7 = subtightplot(1,7,figNum,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', avgMagPlot7);
                                          refName = {'Channel 8'; 'Channel 9'; 'Channel 15'; 'Channel 10'; 'Channel 11'; 'Channel 12'; 'Channel 13'};
                                          yPts.ypts7 = struct('c8',[],'c9',[],'c15',[],'c10',[],'c11',[],'c12',[],'c13',[]);
                                          avgMisalignax7 = subtightplot(1,7,figNum,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', avgMisalignPlot7);
                                          fNames = fieldnames(yPts.ypts7);

                                          avgMagax7.YTickLabel = [];

                                          avgMisalignax7.YTickLabel = [];
                                          newPlot = 0;
                                          
                                          
                                      end
                                      subPts = 'ypts7';
                                      switch cycles.(n).ref
                                          case 8
                                              
                                              refNameUse = fNames{1};
                                              plotPosUse = 1+(0.4)*rand(1)-0.2;
                                              ch7Num = ch7Num+1;
                                              figMagUse = avgMagPlot7;
                                              figAlgnUse = avgMisalignPlot7;
                                              axMagUse = avgMagax7;
                                              axAlgnUse = avgMisalignax7;
                                              newStim = ch7Num;
                                              colorPlot = [0 0 153]/255;
                                              if twitch==0
                                              if ~isempty(max7Inter.M)
                                                  if mean(cycles.(n).maxMag)>mean(cycles.(max7Inter.V).maxMag)
                                                      max7Inter.V = n;
                                                  end
                                                  if mean(cycles.(n).avgMisalign)<mean(cycles.(max7Inter.M).avgMisalign)
                                                      max7Inter.M = n;
                                                  end
                                              else
                                                  max7Inter.M = n; 
                                                  max7Inter.V = n
                                                  
                                              end
                                              end
                                          case 9
                                              refNameUse = fNames{2};
                                              plotPosUse = 2+(0.4)*rand(1)-0.2;
                                              ch7Num = ch7Num+1;
                                              figMagUse = avgMagPlot7;
                                              figAlgnUse = avgMisalignPlot7;
                                              axMagUse = avgMagax7;
                                              axAlgnUse = avgMisalignax7;
                                              newStim = ch7Num;
                                              colorPlot = [255 164 0]/255;
                                              if twitch==0
                                              if ~isempty(max7Inter.M)
                                                  if mean(cycles.(n).maxMag)>mean(cycles.(max7Inter.V).maxMag)
                                                      max7Inter.V = n;
                                                  end
                                                  if mean(cycles.(n).avgMisalign)<mean(cycles.(max7Inter.M).avgMisalign)
                                                      max7Inter.M = n;
                                                  end
                                              else
                                                  max7Inter.M = n; 
                                                  max7Inter.V = n
                                                  
                                              end
                                              end
                                              
                                          case 15
                                              refNameUse = fNames{3};
                                              plotPosUse = 3+(0.4)*rand(1)-0.2;
                                              ch7Num = ch7Num+1;
                                              figMagUse = avgMagPlot7;
                                              figAlgnUse = avgMisalignPlot7;
                                              axMagUse = avgMagax7;
                                              axAlgnUse = avgMisalignax7;
                                              newStim = ch7Num;
                                              colorPlot = [60 55 68]/255;
                                              if twitch==0
                                              if ~isempty(max7Inter.M)
                                                  if mean(cycles.(n).maxMag)>mean(cycles.(max7Inter.V).maxMag)
                                                      max7Inter.V = n;
                                                  end
                                                  if mean(cycles.(n).avgMisalign)<mean(cycles.(max7Inter.M).avgMisalign)
                                                      max7Inter.M = n;
                                                  end
                                              else
                                                  max7Inter.M = n; 
                                                  max7Inter.V = n
                                                  
                                              end
                                              end
                                              
                                          case 10
                                              
                                              refNameUse = fNames{4};
                                              plotPosUse = 4+(0.4)*rand(1)-0.2;
                                              ch7Num = ch7Num+1;
                                              figMagUse = avgMagPlot7;
                                              figAlgnUse = avgMisalignPlot7;
                                              axMagUse = avgMagax7;
                                              axAlgnUse = avgMisalignax7;
                                              newStim = ch7Num;
                                              colorPlot = [255 107 107]/255;
                                              if cycles.(n).amp == 125
                                                  twitch = 1;
                                              end
                                              if twitch==0
                                              if ~isempty(max7D.M)
                                                  if mean(cycles.(n).maxMag)>mean(cycles.(max7D.V).maxMag)
                                                      max7D.V = n;
                                                  end
                                                  if mean(cycles.(n).avgMisalign)<mean(cycles.(max7D.M).avgMisalign)
                                                      max7D.M = n;
                                                  end
                                              else
                                                  max7D.M = n; 
                                                  max7D.V = n
                                              end
                                              end
                                          case 11
                                              
                                              refNameUse = fNames{5};
                                              plotPosUse = 5+(0.4)*rand(1)-0.2;
                                              ch7Num = ch7Num+1;
                                              figMagUse = avgMagPlot7;
                                              figAlgnUse = avgMisalignPlot7;
                                              axMagUse = avgMagax7;
                                              axAlgnUse = avgMisalignax7;
                                              newStim = ch7Num;
                                              colorPlot = [23 37 90]/255;
                                              if twitch==0
                                              if ~isempty(max7CC.M)
                                                  if mean(cycles.(n).maxMag)>mean(cycles.(max7CC.V).maxMag)
                                                      max7CC.V = n;
                                                  end
                                                  if mean(cycles.(n).avgMisalign)<mean(cycles.(max7CC.M).avgMisalign)
                                                      max7CC.M = n;
                                                  end
                                              else
                                                  max7CC.V = n
                                                  max7CC.M = n
                                              end
                                              end
                                          case 12
                                              refNameUse = fNames{6};
                                              ch7Num = ch7Num+1;
                                              figMagUse = avgMagPlot7;
                                              figAlgnUse = avgMisalignPlot7;
                                              axMagUse = avgMagax7;
                                              axAlgnUse = avgMisalignax7;
                                              newStim = ch7Num;
                                              colorPlot = [126 161 107]/255;
                                              if twitch==0
                                              if ~isempty(max7CC.M)
                                                  if mean(cycles.(n).maxMag)>mean(cycles.(max7CC.V).maxMag)
                                                      max7CC.V = n;
                                                  end
                                                  if mean(cycles.(n).avgMisalign)<mean(cycles.(max7CC.M).avgMisalign)
                                                      max7CC.M = n;
                                                  end
                                              else
                                                  max7CC.V = n
                                                  max7CC.M = n
                                              end
                                              end
                                          case 13
                                              refNameUse = fNames{7};
                                              plotPosUse = 7+(0.4)*rand(1)-0.2;
                                              ch7Num = ch7Num+1;
                                              figMagUse = avgMagPlot7;
                                              figAlgnUse = avgMisalignPlot7;
                                              axMagUse = avgMagax7;
                                              axAlgnUse = avgMisalignax7;
                                              newStim = ch7Num;
                                              colorPlot = [76 6 29]/255;
                                              if cycles.(n).amp == 250
                                                  twitch = 1;
                                              end
                                              if twitch==0
                                              if ~isempty(max7CC.M)
                                                  if mean(cycles.(n).maxMag)>mean(cycles.(max7CC.V).maxMag)
                                                      max7CC.V = n;
                                                  end
                                                  if mean(cycles.(n).avgMisalign)<mean(cycles.(max7CC.M).avgMisalign)
                                                      max7CC.M = n;
                                                  end
                                              else
                                                  max7CC.V = n
                                                  max7CC.M = n
                                              end
                                              end
                                              
                                      end
                                      
                                  case 8
                                      if ch8Num==1
                                          title = 1;
                                          figNum = 1;
                                          avgMagPlot8 = figure('units','normalized','outerposition',[0 0 1 1]);
                                          avgMagax8 = subtightplot(1,7,figNum,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', avgMagPlot8);
                                          refName = {'Channel 8'; 'Channel 9'; 'Channel 15'; 'Channel 10'; 'Channel 11'; 'Channel 12'; 'Channel 13'};
                                          yPts.ypts8 = struct('c8',[],'c9',[],'c15',[],'c10',[],'c11',[],'c12',[],'c13',[]);
                                          avgMisalignPlot8 = figure('units','normalized','outerposition',[0 0 1 1]);
                                          avgMisalignax8 = subtightplot(1,7,figNum,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', avgMisalignPlot8);
                                          fNames = fieldnames(yPts.ypts8);
                                          avgMagax8.XTick = [0:50:300];
                                          avgMisalignax8.XTick = [0:50:300];
                                          avgMagax8.XGrid = 'on'
                                          avgMagax8.YGrid = 'on'
                                          avgMisalignax8.XGrid = 'on'
                                          avgMisalignax8.YGrid = 'on'
                                      elseif newPlot == 1
                                          avgMagax8.XLim = [0 350];
                                              avgMisalignax8.XLim = [0 350];
                                              avgMagax8.XTick = [0:50:300]
                                              avgMisalignax8.XTick = [0:50:300]

                                              axM = findobj(figMagUse.Children,'Type','axes');
                                              axA = findobj(figAlgnUse.Children,'Type','axes');
                                          upperYMag = max([axM.YLim]);
                                          upperYMisalign = max([axA.YLim]);
                                          for limRep = 1:length(figAlgnUse.Children)
                                             if isgraphics(figMagUse.Children(limRep),'Axes')
                                              figAlgnUse.Children(limRep).YLim = [0 upperYMisalign];
                                              figMagUse.Children(limRep).YLim = [0 upperYMag];
                                              for vertY = 1:length(figMagUse.Children(limRep).Children)
                                                  if all(figMagUse.Children(limRep).Children(vertY).Color==[1 0 0])
                                                      figMagUse.Children(limRep).Children(vertY).YData = figMagUse.Children(limRep).YLim;
                                                  end
                                              end
                                             end
                                          end
                                          avgMagax8.XGrid = 'on'
                                          avgMagax8.YGrid = 'on'
                                          avgMisalignax8.XGrid = 'on'
                                          avgMisalignax8.YGrid = 'on'
                                          figNum = figNum +1;
                                          avgMagax8 = subtightplot(1,7,figNum,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', avgMagPlot8);
                                          yPts.ypts8 = struct('c7',[],'c9',[],'c15',[],'c10',[],'c11',[],'c12',[],'c13',[]);
                                          avgMisalignax8 = subtightplot(1,7,figNum,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', avgMisalignPlot8);
                                          fNames = fieldnames(yPts.ypts8);

                                          avgMagax8.YTickLabel = [];

                                          avgMisalignax8.YTickLabel = [];
                                          newPlot = 0;
                                          
                                          
                                      end
                                      subPts = 'ypts8';
                                      switch cycles.(n).ref
                                          case 7
                                              
                                              refNameUse = fNames{1};
                                              plotPosUse = 1+(0.4)*rand(1)-0.2;
                                              ch8Num = ch8Num+1;
                                              figMagUse = avgMagPlot8;
                                              figAlgnUse = avgMisalignPlot8;
                                              axMagUse = avgMagax8;
                                              axAlgnUse = avgMisalignax8;
                                              newStim = ch8Num;
                                              colorPlot = [23 126 137]/255;
                                              if twitch==0
                                               if ~isempty(max8Inter.M)
                                                  if mean(cycles.(n).maxMag)>mean(cycles.(max8Inter.V).maxMag)
                                                      max8Inter.V = n;
                                                  end
                                                  if mean(cycles.(n).avgMisalign)<mean(cycles.(max8Inter.M).avgMisalign)
                                                      max8Inter.M = n;
                                                  end
                                               else
                                                   max8Inter.M = n
                                                   max8Inter.V = n
                                               end
                                              end
                                          case 9
                                              refNameUse = fNames{2};
                                              plotPosUse = 2+(0.4)*rand(1)-0.2;
                                              ch8Num = ch8Num+1;
                                              figMagUse = avgMagPlot8;
                                              figAlgnUse = avgMisalignPlot8;
                                              axMagUse = avgMagax8;
                                              axAlgnUse = avgMisalignax8;
                                              newStim = ch8Num;
                                              colorPlot = [255 164 0]/255;
                                              if twitch==0
                                               if ~isempty(max8Inter.M)
                                                  if mean(cycles.(n).maxMag)>mean(cycles.(max8Inter.V).maxMag)
                                                      max8Inter.V = n;
                                                  end
                                                  if mean(cycles.(n).avgMisalign)<mean(cycles.(max8Inter.M).avgMisalign)
                                                      max8Inter.M = n;
                                                  end
                                               else
                                                   max8Inter.M = n
                                                   max8Inter.V = n
                                               end
                                              end
                                          case 15
                                              refNameUse = fNames{3};
                                              plotPosUse = 3+(0.4)*rand(1)-0.2;
                                              ch8Num = ch8Num+1;
                                              figMagUse = avgMagPlot8;
                                              figAlgnUse = avgMisalignPlot8;
                                              axMagUse = avgMagax8;
                                              axAlgnUse = avgMisalignax8;
                                              newStim = ch8Num;
                                              colorPlot = [60 55 68]/255;
                                              if twitch==0
                                               if ~isempty(max8Inter.M)
                                                  if mean(cycles.(n).maxMag)>mean(cycles.(max8Inter.V).maxMag)
                                                      max8Inter.V = n;
                                                  end
                                                  if mean(cycles.(n).avgMisalign)<mean(cycles.(max8Inter.M).avgMisalign)
                                                      max8Inter.M = n;
                                                  end
                                               else
                                                   max8Inter.M = n
                                                   max8Inter.V = n
                                               end
                                              end
                                          case 10
                                              refNameUse = fNames{4};
                                              plotPosUse = 4+(0.4)*rand(1)-0.2;
                                              ch8Num = ch8Num+1;
                                              figMagUse = avgMagPlot8;
                                              figAlgnUse = avgMisalignPlot8;
                                              axMagUse = avgMagax8;
                                              axAlgnUse = avgMisalignax8;
                                              newStim = ch8Num;
                                              colorPlot = [255 107 107]/255;
                                              if cycles.(n).amp == 150
                                                  twitch = 1;
                                              end
                                              if twitch==0
                                              if ~isempty(max8D.M)
                                                  if mean(cycles.(n).maxMag)>mean(cycles.(max8D.V).maxMag)
                                                      max8D.V = n;
                                                  end
                                                  if mean(cycles.(n).avgMisalign)<mean(cycles.(max8D.M).avgMisalign)
                                                      max8D.M = n;
                                                  end
                                               else
                                                   max8D.V=n;
                                                   max8D.M=n;
                                              end
                                              end
                                          case 11
                                              refNameUse = fNames{5};
                                              plotPosUse = 5+(0.4)*rand(1)-0.2;
                                              ch8Num = ch8Num+1;
                                              figMagUse = avgMagPlot8;
                                              figAlgnUse = avgMisalignPlot8;
                                              axMagUse = avgMagax8;
                                              axAlgnUse = avgMisalignax8;
                                              newStim = ch8Num;
                                              colorPlot = [23 37 90]/255;
                                              if twitch==0
                                              if ~isempty(max8CC.M)
                                                  if mean(cycles.(n).maxMag)>mean(cycles.(max8CC.V).maxMag)
                                                      max8CC.V = n;
                                                  end
                                                  if mean(cycles.(n).avgMisalign)<mean(cycles.(max8CC.M).avgMisalign)
                                                      max8CC.M = n;
                                                  end
                                               else
                                                   max8CC.V = n;
                                                   max8CC.M = n;
                                              end
                                              end
                                          case 12
                                              refNameUse = fNames{6};
                                              plotPosUse = 6+(0.4)*rand(1)-0.2;
                                              ch8Num = ch8Num+1;
                                              figMagUse = avgMagPlot8;
                                              figAlgnUse = avgMisalignPlot8;
                                              axMagUse = avgMagax8;
                                              axAlgnUse = avgMisalignax8;
                                              newStim = ch8Num;
                                              colorPlot = [126 161 107]/255;
                                             if twitch==0
                                              if ~isempty(max8CC.M)
                                                  if mean(cycles.(n).maxMag)>mean(cycles.(max8CC.V).maxMag)
                                                      max8CC.V = n;
                                                  end
                                                  if mean(cycles.(n).avgMisalign)<mean(cycles.(max8CC.M).avgMisalign)
                                                      max8CC.M = n;
                                                  end
                                               else
                                                   max8CC.V = n;
                                                   max8CC.M = n;
                                              end
                                              end
                                          case 13
                                              refNameUse = fNames{7};
                                              plotPosUse = 7+(0.4)*rand(1)-0.2;
                                              ch8Num = ch8Num+1;
                                              figMagUse = avgMagPlot8;
                                              figAlgnUse = avgMisalignPlot8;
                                              axMagUse = avgMagax8;
                                              axAlgnUse = avgMisalignax8;
                                              newStim = ch8Num;
                                              colorPlot = [76 6 29]/255;
                                              if twitch==0
                                              if ~isempty(max8CC.M)
                                                  if mean(cycles.(n).maxMag)>mean(cycles.(max8CC.V).maxMag)
                                                      max8CC.V = n;
                                                  end
                                                  if mean(cycles.(n).avgMisalign)<mean(cycles.(max8CC.M).avgMisalign)
                                                      max8CC.M = n;
                                                  end
                                               else
                                                   max8CC.V = n;
                                                   max8CC.M = n;
                                              end
                                              end
                                      end
                                  case 9
                                      if ch9Num==1
                                          title = 1;
                                          figNum = 1;
                                          avgMagPlot9 = figure('units','normalized','outerposition',[0 0 1 1]);
                                          avgMagax9 = subtightplot(1,7,figNum,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', avgMagPlot9);
                                          yPts.ypts9 = struct('c7',[],'c8',[],'c15',[],'c10',[],'c11',[],'c12',[],'c13',[]);
                                          avgMisalignPlot9 = figure('units','normalized','outerposition',[0 0 1 1]);
                                          avgMisalignax9 = subtightplot(1,7,figNum,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', avgMisalignPlot9);
                                          fNames = fieldnames(yPts.ypts9);
                                          avgMagax9.XTick = [0:50:300];
                                          avgMisalignax9.XTick = [0:50:300];
                                          avgMagax9.XGrid = 'on'
                                          avgMagax9.YGrid = 'on'
                                          avgMisalignax9.XGrid = 'on'
                                          avgMisalignax9.YGrid = 'on'
                                      elseif newPlot == 1
                                          avgMagax9.XLim = [0 350];
                                              avgMisalignax9.XLim = [0 350];
                                              avgMagax9.XTick = [0:50:300]
                                              avgMisalignax9.XTick = [0:50:300]

                                               axM = findobj(figMagUse.Children,'Type','axes');
                                              axA = findobj(figAlgnUse.Children,'Type','axes');
                                          upperYMag = max([axM.YLim]);
                                          upperYMisalign = max([axA.YLim]);
                                          for limRep = 1:length(figAlgnUse.Children)
                                             if isgraphics(figMagUse.Children(limRep),'Axes')
                                              figAlgnUse.Children(limRep).YLim = [0 upperYMisalign];
                                              figMagUse.Children(limRep).YLim = [0 upperYMag];
                                              for vertY = 1:length(figMagUse.Children(limRep).Children)
                                                  if all(figMagUse.Children(limRep).Children(vertY).Color==[1 0 0])
                                                      figMagUse.Children(limRep).Children(vertY).YData = figMagUse.Children(limRep).YLim;
                                                  end
                                              end
                                             end
                                          end
                                          avgMagax9.XGrid = 'on'
                                          avgMagax9.YGrid = 'on'
                                          avgMisalignax9.XGrid = 'on'
                                          avgMisalignax9.YGrid = 'on'
                                          figNum = figNum +1;
                                          avgMagax9 = subtightplot(1,7,figNum,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', avgMagPlot9);
                                          yPts.ypts9 = struct('c7',[],'c8',[],'c15',[],'c10',[],'c11',[],'c12',[],'c13',[]);
                                          avgMisalignax9 = subtightplot(1,7,figNum,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', avgMisalignPlot9);
                                          fNames = fieldnames(yPts.ypts9);

                                          avgMagax9.YTickLabel = [];

                                          avgMisalignax9.YTickLabel = [];
                                          newPlot = 0;
                                          
                                          
                                      end
                                      subPts = 'ypts9';
                                      switch cycles.(n).ref
                                          case 7
                                              refNameUse = fNames{1};
                                              plotPosUse = 1+(0.4)*rand(1)-0.2;
                                              ch9Num = ch9Num+1;
                                              figMagUse = avgMagPlot9;
                                              figAlgnUse = avgMisalignPlot9;
                                              axMagUse = avgMagax9;
                                              axAlgnUse = avgMisalignax9;
                                              newStim = ch9Num;
                                              colorPlot = [23 126 137]/255;
                                              if twitch==0
                                              if ~isempty(max9Inter.M)
                                                  if mean(cycles.(n).maxMag)>mean(cycles.(max9Inter.V).maxMag)
                                                      max9Inter.V = n;
                                                  end
                                                  if mean(cycles.(n).avgMisalign)<mean(cycles.(max9Inter.M).avgMisalign)
                                                      max9Inter.M = n;
                                                  end
                                               else
                                                   max9Inter.V = n;
                                                   max9Inter.M = n;
                                              end
                                              end
                                          case 8
                                              refNameUse = fNames{2};
                                              plotPosUse = 2+(0.4)*rand(1)-0.2;
                                              ch9Num = ch9Num+1;
                                              figMagUse = avgMagPlot9;
                                              figAlgnUse = avgMisalignPlot9;
                                              axMagUse = avgMagax9;
                                              axAlgnUse = avgMisalignax9;
                                              newStim = ch9Num;
                                              colorPlot =[0 0 153]/255;
                                              if twitch==0
                                              if ~isempty(max9Inter.M)
                                                  if mean(cycles.(n).maxMag)>mean(cycles.(max9Inter.V).maxMag)
                                                      max9Inter.V = n;
                                                  end
                                                  if mean(cycles.(n).avgMisalign)<mean(cycles.(max9Inter.M).avgMisalign)
                                                      max9Inter.M = n;
                                                  end
                                               else
                                                   max9Inter.V = n;
                                                   max9Inter.M = n;
                                              end
                                              end
                                          case 15
                                              refNameUse = fNames{3};
                                              plotPosUse = 3+(0.4)*rand(1)-0.2;
                                              ch9Num = ch9Num+1;
                                              figMagUse = avgMagPlot9;
                                              figAlgnUse = avgMisalignPlot9;
                                              axMagUse = avgMagax9;
                                              axAlgnUse = avgMisalignax9;
                                              newStim = ch9Num;
                                              colorPlot = [60 55 68]/255;
                                              if twitch==0
                                              if ~isempty(max9Inter.M)
                                                  if mean(cycles.(n).maxMag)>mean(cycles.(max9Inter.V).maxMag)
                                                      max9Inter.V = n;
                                                  end
                                                  if mean(cycles.(n).avgMisalign)<mean(cycles.(max9Inter.M).avgMisalign)
                                                      max9Inter.M = n;
                                                  end
                                               else
                                                   max9Inter.V = n;
                                                   max9Inter.M = n;
                                              end
                                              end
                                          case 10
                                              refNameUse = fNames{4};
                                              plotPosUse = 4+(0.4)*rand(1)-0.2;
                                              ch9Num = ch9Num+1;
                                              figMagUse = avgMagPlot9;
                                              figAlgnUse = avgMisalignPlot9;
                                              axMagUse = avgMagax9;
                                              axAlgnUse = avgMisalignax9;
                                              newStim = ch9Num;
                                              colorPlot = [255 107 107]/255;
                                              if cycles.(n).amp == 200
                                                  twitch = 1;
                                              end
                                              if twitch==0
                                              if ~isempty(max9D.M)
                                                  if mean(cycles.(n).maxMag)>mean(cycles.(max9D.V).maxMag)
                                                      max9D.V = n;
                                                  end
                                                  if mean(cycles.(n).avgMisalign)<mean(cycles.(max9D.M).avgMisalign)
                                                      max9D.M = n;
                                                  end
                                               else
                                                   max9D.M = n;
                                                   max9D.V = n;
                                              end
                                              end
                                          case 11
                                              refNameUse = fNames{5};
                                              plotPosUse = 5+(0.4)*rand(1)-0.2;
                                              ch9Num = ch9Num+1;
                                              figMagUse = avgMagPlot9;
                                              figAlgnUse = avgMisalignPlot9;
                                              axMagUse = avgMagax9;
                                              axAlgnUse = avgMisalignax9;
                                              newStim = ch9Num;
                                              colorPlot = [23 37 90]/255;
                                              if twitch==0
                                              if ~isempty(max9CC.M)
                                                  if mean(cycles.(n).maxMag)>mean(cycles.(max9CC.V).maxMag)
                                                      max9CC.V = n;
                                                  end
                                                  if mean(cycles.(n).avgMisalign)<mean(cycles.(max9CC.M).avgMisalign)
                                                      max9CC.M = n;
                                                  end
                                               else
                                                   max9CC.V = n;
                                                   max9CC.M = n;
                                              end
                                              end
                                          case 12
                                              refNameUse = fNames{6};
                                              plotPosUse = 6+(0.4)*rand(1)-0.2;
                                              ch9Num = ch9Num+1;
                                              figMagUse = avgMagPlot9;
                                              figAlgnUse = avgMisalignPlot9;
                                              axMagUse = avgMagax9;
                                              axAlgnUse = avgMisalignax9;
                                              newStim = ch9Num;
                                              colorPlot = [126 161 107]/255;
                                              if twitch==0
                                              if ~isempty(max9CC.M)
                                                  if mean(cycles.(n).maxMag)>mean(cycles.(max9CC.V).maxMag)
                                                      max9CC.V = n;
                                                  end
                                                  if mean(cycles.(n).avgMisalign)<mean(cycles.(max9CC.M).avgMisalign)
                                                      max9CC.M = n;
                                                  end
                                               else
                                                   max9CC.V = n;
                                                   max9CC.M = n;
                                              end
                                              end
                                          case 13
                                              refNameUse = fNames{7};
                                              plotPosUse = 7+(0.4)*rand(1)-0.2;
                                              ch9Num = ch9Num+1;
                                              figMagUse = avgMagPlot9;
                                              figAlgnUse = avgMisalignPlot9;
                                              axMagUse = avgMagax9;
                                              axAlgnUse = avgMisalignax9;
                                              newStim = ch9Num;
                                              colorPlot = [76 6 29]/255;
                                              if twitch==0
                                              if ~isempty(max9CC.M)
                                                  if mean(cycles.(n).maxMag)>mean(cycles.(max9CC.V).maxMag)
                                                      max9CC.V = n;
                                                  end
                                                  if mean(cycles.(n).avgMisalign)<mean(cycles.(max9CC.M).avgMisalign)
                                                      max9CC.M = n;
                                                  end
                                               else
                                                   max9CC.V = n;
                                                   max9CC.M = n;
                                              end
                                              end
                                      end
                                  case 15
                                     if ch15Num==1
                                         title = 1;
                                         figNum = 1;
                                          avgMagPlot15 = figure('units','normalized','outerposition',[0 0 1 1]);
                                          avgMagax15 = subtightplot(1,7,figNum,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', avgMagPlot15);
                                          yPts.ypts15 = struct('c7',[],'c8',[],'c9',[],'c10',[],'c11',[],'c12',[],'c13',[]);
                                          avgMisalignPlot15 = figure('units','normalized','outerposition',[0 0 1 1]);
                                          avgMisalignax15 = subtightplot(1,7,figNum,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', avgMisalignPlot15);
                                          fNames = fieldnames(yPts.ypts15);
                                          avgMagax15.XTick = [0:50:300];
                                          avgMisalignax15.XTick = [0:50:300];
                                          avgMagax15.XGrid = 'on'
                                          avgMagax15.YGrid = 'on'
                                          avgMisalignax15.XGrid = 'on'
                                          avgMisalignax15.YGrid = 'on'
                                        
                                      elseif newPlot == 1
                                          avgMagax15.XLim = [0 350];
                                              avgMisalignax15.XLim = [0 350];
                                              avgMagax15.XTick = [0:50:300]
                                              avgMisalignax15.XTick = [0:50:300]

                                              axM = findobj(figMagUse.Children,'Type','axes');
                                              axA = findobj(figAlgnUse.Children,'Type','axes');
                                          upperYMag = max([axM.YLim]);
                                          upperYMisalign = max([axA.YLim]);
                                          for limRep = 1:length(figAlgnUse.Children)
                                             if isgraphics(figMagUse.Children(limRep),'Axes')
                                              figAlgnUse.Children(limRep).YLim = [0 upperYMisalign];
                                              figMagUse.Children(limRep).YLim = [0 upperYMag];
                                              for vertY = 1:length(figMagUse.Children(limRep).Children)
                                                  if all(figMagUse.Children(limRep).Children(vertY).Color==[1 0 0])
                                                      figMagUse.Children(limRep).Children(vertY).YData = figMagUse.Children(limRep).YLim;
                                                  end
                                              end
                                             end
                                          end
                                          avgMagax15.XGrid = 'on'
                                          avgMagax15.YGrid = 'on'
                                          avgMisalignax15.XGrid = 'on'
                                          avgMisalignax15.YGrid = 'on'
                                          figNum = figNum +1;
                                          avgMagax15 = subtightplot(1,7,figNum,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', avgMagPlot15);
                                          yPts.ypts15 = struct('c7',[],'c8',[],'c9',[],'c10',[],'c11',[],'c12',[],'c13',[]);
                                          avgMisalignax15 = subtightplot(1,7,figNum,[0.01 0.000000000005],[0.10 0.075],[.05 .05],'Parent', avgMisalignPlot15);
                                          fNames = fieldnames(yPts.ypts15);

                                          avgMagax15.YTickLabel = [];

                                          avgMisalignax15.YTickLabel = [];
                                          newPlot = 0;
                                          
                                          
                                      end
                                      subPts = 'ypts15';
                                      switch cycles.(n).ref
                                          case 7
                                              refNameUse = fNames{1};
                                              plotPosUse = 1+(0.4)*rand(1)-0.2;
                                              ch15Num = ch15Num+1;
                                              figMagUse = avgMagPlot15;
                                              figAlgnUse = avgMisalignPlot15;
                                              axMagUse = avgMagax15;
                                              axAlgnUse = avgMisalignax15;
                                              newStim = ch15Num;
                                              colorPlot = [23 126 137]/255;
                                              if twitch==0
                                              if ~isempty(max15Inter.M)
                                                  if mean(cycles.(n).maxMag)>mean(cycles.(max15Inter.V).maxMag)
                                                      max15Inter.V = n;
                                                  end
                                                  if mean(cycles.(n).avgMisalign)<mean(cycles.(max15Inter.M).avgMisalign)
                                                      max15Inter.M = n;
                                                  end
                                               else
                                                   max15Inter.V = n;
                                                   max15Inter.M = n;
                                              end
                                              end
                                          case 8
                                              refNameUse = fNames{2};
                                              plotPosUse = 2+(0.4)*rand(1)-0.2;
                                              ch15Num = ch15Num+1;
                                              figMagUse = avgMagPlot15;
                                              figAlgnUse = avgMisalignPlot15;
                                              axMagUse = avgMagax15;
                                              axAlgnUse = avgMisalignax15;
                                              newStim = ch15Num;
                                              colorPlot =[0 0 153]/255;
                                              if twitch==0
                                              if ~isempty(max15Inter.M)
                                                  if mean(cycles.(n).maxMag)>mean(cycles.(max15Inter.V).maxMag)
                                                      max15Inter.V = n;
                                                  end
                                                  if mean(cycles.(n).avgMisalign)<mean(cycles.(max15Inter.M).avgMisalign)
                                                      max15Inter.M = n;
                                                  end
                                               else
                                                   max15Inter.V = n;
                                                   max15Inter.M = n;
                                              end
                                              end
                                          case 9
                                              refNameUse = fNames{3};
                                              plotPosUse = 3+(0.4)*rand(1)-0.2;
                                              ch15Num = ch15Num+1;
                                              figMagUse = avgMagPlot15;
                                              figAlgnUse = avgMisalignPlot15;
                                              axMagUse = avgMagax15;
                                              axAlgnUse = avgMisalignax15;
                                              newStim = ch15Num;
                                              colorPlot = [255 164 0]/255;
                                              if twitch==0
                                              if ~isempty(max15Inter.M)
                                                  if mean(cycles.(n).maxMag)>mean(cycles.(max15Inter.V).maxMag)
                                                      max15Inter.V = n;
                                                  end
                                                  if mean(cycles.(n).avgMisalign)<mean(cycles.(max15Inter.M).avgMisalign)
                                                      max15Inter.M = n;
                                                  end
                                               else
                                                   max15Inter.V = n;
                                                   max15Inter.M = n;
                                              end
                                              end
                                          case 10
                                              refNameUse = fNames{4};
                                              plotPosUse = 4+(0.4)*rand(1)-0.2;
                                              ch15Num = ch15Num+1;
                                              figMagUse = avgMagPlot15;
                                              figAlgnUse = avgMisalignPlot15;
                                              axMagUse = avgMagax15;
                                              axAlgnUse = avgMisalignax15;
                                              newStim = ch15Num;
                                              colorPlot = [255 107 107]/255;
                                              if cycles.(n).amp == 150
                                                  twitch = 1;
                                              end
                                              if twitch==0
                                              if ~isempty(max15D.M)
                                                  if mean(cycles.(n).maxMag)>mean(cycles.(max15D.V).maxMag)
                                                      max15D.V = n;
                                                  end
                                                  if mean(cycles.(n).avgMisalign)<mean(cycles.(max15D.M).avgMisalign)
                                                      max15D.M = n;
                                                  end
                                               else
                                                   max15D.V = n;
                                                   max15D.M = n;
                                              end
                                              end
                                          case 11
                                              refNameUse = fNames{5};
                                              plotPosUse = 5+(0.4)*rand(1)-0.2;
                                              ch15Num = ch15Num+1;
                                              figMagUse = avgMagPlot15;
                                              figAlgnUse = avgMisalignPlot15;
                                              axMagUse = avgMagax15;
                                              axAlgnUse = avgMisalignax15;
                                              newStim = ch15Num;
                                              colorPlot = [23 37 90]/255;
                                              if twitch==0
                                              if ~isempty(max15CC.M)
                                                  if mean(cycles.(n).maxMag)>mean(cycles.(max15CC.V).maxMag)
                                                      max15CC.V = n;
                                                  end
                                                  if mean(cycles.(n).avgMisalign)<mean(cycles.(max15CC.M).avgMisalign)
                                                      max15CC.M = n;
                                                  end
                                               else
                                                   max15CC.V = n;
                                                   max15CC.M = n;
                                              end
                                              end
                                          case 12
                                              refNameUse = fNames{6};
                                              plotPosUse = 6+(0.4)*rand(1)-0.2;
                                              ch15Num = ch15Num+1;
                                              figMagUse = avgMagPlot15;
                                              figAlgnUse = avgMisalignPlot15;
                                              axMagUse = avgMagax15;
                                              axAlgnUse = avgMisalignax15;
                                              newStim = ch15Num;
                                              colorPlot = [126 161 107]/255;
                                              if twitch==0
                                              if ~isempty(max15CC.M)
                                                  if mean(cycles.(n).maxMag)>mean(cycles.(max15CC.V).maxMag)
                                                      max15CC.V = n;
                                                  end
                                                  if mean(cycles.(n).avgMisalign)<mean(cycles.(max15CC.M).avgMisalign)
                                                      max15CC.M = n;
                                                  end
                                               else
                                                   max15CC.V = n;
                                                   max15CC.M = n;
                                              end
                                              end
                                          case 13
                                              refNameUse = fNames{7};
                                              plotPosUse = 7+(0.4)*rand(1)-0.2;
                                              ch15Num = ch15Num+1;
                                              figMagUse = avgMagPlot15;
                                              figAlgnUse = avgMisalignPlot15;
                                              axMagUse = avgMagax15;
                                              axAlgnUse = avgMisalignax15;
                                              newStim = ch15Num;
                                              colorPlot = [76 6 29]/255;
                                              if cycles.(n).amp == 300
                                                  twitch = 1;
                                              end
                                              if twitch==0
                                              if ~isempty(max15CC.M)
                                                  if mean(cycles.(n).maxMag)>mean(cycles.(max15CC.V).maxMag)
                                                      max15CC.V = n;
                                                  end
                                                  if mean(cycles.(n).avgMisalign)<mean(cycles.(max15CC.M).avgMisalign)
                                                      max15CC.M = n;
                                                  end
                                               else
                                                   max15CC.V = n;
                                                   max15CC.M = n;
                                              end
                                              end
                                      end
                              end
                              
                              if newStim == 2
                                      hold(axMagUse,'on');
                                      p(totNum,ampNum) = plot(axMagUse,cycles.(n).amp,mean(cycles.(n).maxMag),'color',colorPlot,'marker','o','MarkerSize',10,'LineWidth',2);
                                      cycles.(n).Vstdev =  std(cycles.(n).maxMag);
                                      errorbar(axMagUse,cycles.(n).amp,mean(cycles.(n).maxMag),cycles.(n).Vstdev,'color',colorPlot,'LineWidth',2.5)
                                      if twitch==1
                                          cutOff2 = line(axMagUse,[cycles.(n).amp cycles.(n).amp],axMagUse.YLim,'color',[1 0 0],'LineWidth',3)

                                           ldg2 = legend(axMagUse,[cutOff2],'Cutoff Due To Facial Nerve Stimulation','AutoUpdate','off')
                                    ldg2.Position = [0.8105 0.9494 0.1308 0.0192];
                                    ldg2.FontSize = 13.5;

                                     end
                                      axMagUse.LineWidth = 2.5;
                                      hold(axMagUse,'off');
                                      hold(axAlgnUse,'on');
                                      q(totNum,ampNum) = plot(axAlgnUse,cycles.(n).amp,mean(cycles.(n).avgMisalign),'color',colorPlot,'marker','o','MarkerSize',10,'LineWidth',2);

                                      cycles.(n).Mstdev =  std(cycles.(n).avgMisalign);
                                      errorbar(axAlgnUse,cycles.(n).amp,mean(cycles.(n).avgMisalign),cycles.(n).Mstdev,'color',colorPlot,'LineWidth',2.5);
                                      if twitch==1
                                          cutOff1 = line(axAlgnUse,[cycles.(n).amp cycles.(n).amp],axAlgnUse.YLim,'color',[1 0 0],'LineWidth',3)

                                          ldg1 = legend(axAlgnUse,[cutOff1],'Cutoff Due To Facial Nerve Stimulation','AutoUpdate','off')
                                    ldg1.Position = [0.8105 0.9494 0.1308 0.0192];
                                    ldg1.FontSize = 13.5;
                                    twitch = 0;
                                     end
                                      axAlgnUse.LineWidth = 2.5;
                                      hold(axAlgnUse,'off');
                                      typePlot(totNum,ampNum) = cycles.(n).stim;
                                          ylabel(axMagUse,'Left Eye Velocity Magnitude (dps)','FontSize',22);
                                          axMagUse.FontSize = 13.5;
                                          ylabel(axAlgnUse,'Misalignment (degrees)','FontSize',22);
                                          axAlgnUse.FontSize = 13.5;
                                          if title == 1
                                          sgtitle(figMagUse,['Average Eye Velocity Magnitude, Source Electrode ',num2str(cycles.(n).stim)],'FontSize', 26, 'FontWeight', 'Bold');                               
                                          sgtitle(figAlgnUse,['Angle of Misalignment, Source Electrode ',num2str(cycles.(n).stim)],'FontSize', 26, 'FontWeight', 'Bold');                            
                                          title = 0;
                                          end
                                          newPlot = 0;
                                      if str2num(nextFilename(namp(1)+3:ndot-10))<cycles.(n).amp
                                          hold(axMagUse,'on');
                                          line(axMagUse,[p(totNum,1:ampNum).XData],[p(totNum,1:ampNum).YData],'color',colorPlot,'LineWidth',4)
                                          hold(axMagUse,'off');
                                          axMagUse.XLabel.String = {'Current (uA)';['Return Electrode ',num2str(cycles.(n).ref)]}
                                          axMagUse.XLabel.FontSize = 22;
                                          hold(axAlgnUse,'on');
                                          line(axAlgnUse,[q(totNum,1:ampNum).XData],[q(totNum,1:ampNum).YData],'color',colorPlot,'LineWidth',4)
                                          hold(axAlgnUse,'off');
                                          axAlgnUse.XLabel.String = {'Current (uA)';['Return Electrode ',num2str(cycles.(n).ref)]}
                                          axAlgnUse.XLabel.FontSize = 22;
                                          if any(strfind(labString{2},'15'))
                                              lngofPlots = length(get(figMagUse,'Children'))
                                              Vch = get(figMagUse,'Children')
                                              movePosV = get(Vch(lngofPlots-2),'Position');
                                              Mch = get(figAlgnUse,'Children')
                                              movePosM = get(Mch(lngofPlots-2),'Position');
                                              V =get(figMagUse,'Children');
                                              M = get(figAlgnUse,'Children');
                                              for movPlot = lngofPlots-2:-1:2
                                                  V(movPlot).Position = V(movPlot-1).Position;
                                                  M(movPlot).Position = M(movPlot-1).Position;
                                              end
                                              V(1).Position = movePosV;
                                              M(1).Position = movePosM;
                                              set(figMagUse,'Children',V)
                                              set(figAlgnUse,'Children',M)
                                          end
                                          axMagUse.FontSize = 13.5;
                                          axAlgnUse.FontSize = 13.5;
                                          newPlot = 1;
                                          totNum = 1+ totNum;
                                      ampNum = 1;
                                      else
                                          ampNum = 1+ampNum;
                                      end
                              else
                                  hold(axMagUse,'on');
                                      p(totNum,ampNum) = plot(axMagUse,cycles.(n).amp,mean(cycles.(n).maxMag),'color',colorPlot,'marker','o','MarkerSize',10,'LineWidth',2);
                                      cycles.(n).Vstdev =  std(cycles.(n).maxMag);
                                      errorbar(axMagUse,cycles.(n).amp,mean(cycles.(n).maxMag),cycles.(n).Vstdev,'color',colorPlot,'LineWidth',2.5)
                                      if twitch==1
                                          cutOff2 = line(axMagUse,[cycles.(n).amp cycles.(n).amp],[0 300],'color',[1 0 0],'LineWidth',3,'LineStyle','--')

                                          ldg2 = legend(axMagUse,[cutOff2],'Cutoff Due To Facial Nerve Stimulation','AutoUpdate','off')
                                    ldg2.Position = [0.8105 0.9494 0.1308 0.0192];
                                    ldg2.FontSize = 13.5;
                                     end
                                      axMagUse.LineWidth = 2.5;
                                      hold(axMagUse,'off');
                                      hold(axAlgnUse,'on');
                                      q(totNum,ampNum) = plot(axAlgnUse,cycles.(n).amp,mean(cycles.(n).avgMisalign),'color',colorPlot,'marker','o','MarkerSize',10,'LineWidth',2);
                                      cycles.(n).Mstdev =  std(cycles.(n).avgMisalign);
                                      errorbar(axAlgnUse,cycles.(n).amp,mean(cycles.(n).avgMisalign),cycles.(n).Mstdev,'color',colorPlot,'LineWidth',2.5);
                                     if twitch==1
                                          cutOff1 = line(axAlgnUse,[cycles.(n).amp cycles.(n).amp],[0 180],'color',[1 0 0],'LineWidth',3,'LineStyle','--')

                                          ldg1 = legend(axAlgnUse,[cutOff1],'Cutoff Due To Facial Nerve Stimulation','AutoUpdate','off')
                                    ldg1.Position = [0.8105 0.9494 0.1308 0.0192];
                                    ldg1.FontSize = 13.5;
                                    twitch = 0;
                                     end
                                      axAlgnUse.LineWidth = 2.5;
                                      hold(axAlgnUse,'off');
                                      typePlot(totNum,ampNum) = cycles.(n).stim;
                                      if str2num(nextFilename(namp(1)+3:ndot-10))<cycles.(n).amp
                                          hold(axMagUse,'on');
                                          line(axMagUse,[p(totNum,1:ampNum).XData],[p(totNum,1:ampNum).YData],'color',colorPlot,'LineWidth',4)
                                          hold(axMagUse,'off');
                                          axMagUse.XLabel.String = {'Current (uA)';['Return Electrode ',num2str(cycles.(n).ref)]}
                                          

                                          hold(axAlgnUse,'on');
                                          line(axAlgnUse,[q(totNum,1:ampNum).XData],[q(totNum,1:ampNum).YData],'color',colorPlot,'LineWidth',4)
                                          hold(axAlgnUse,'off');
                                          axAlgnUse.XLabel.String = {'Current (uA)';['Return Electrode ',num2str(cycles.(n).ref)]};
                                          
                                          labString = get(get(axMagUse,'XLabel'),'String');
                                          
                                          if any(strfind(labString{2},'15'))
                                              lngofPlots = length(findobj(figMagUse.Children,'Type','axes'))
                                              Vch = get(figMagUse,'Children')
                                              movePosV = get(Vch(lngofPlots-2),'Position');
                                              Mch = get(figAlgnUse,'Children')
                                              movePosM = get(Mch(lngofPlots-2),'Position');
                                              V = findobj(figMagUse.Children,'Type','axes');
                                              M = findobj(figAlgnUse.Children,'Type','axes');
                                              plotN = 7;
                                              for limRep = length(get(figMagUse,'Children')):-1:1
                                             if isgraphics(figMagUse.Children(limRep),'Axes')
                                                     
                                                 if plotN<6
                                                     if plotN==5
                                                       movePosV = figAlgnUse.Children(limRep).Position;
                                                       movePosM = figMagUse.Children(limRep).Position;
                                                     end
                                                     if limRep>1
                                                     figAlgnUse.Children(limRep).Position = M(plotN-1).Position;
                                                     figMagUse.Children(limRep).Position = V(plotN-1).Position;
                                                     else
                                                         figAlgnUse.Children(limRep).Position = movePosV;
                                                     figMagUse.Children(limRep).Position = movePosM;
                                                     end
                                                         
                                                         
                                                 end
   
                                                     
                                                plotN = plotN-1;
                                             end
                                              end
                                             
                                              
                                              
                                          end
                                          
                                          axMagUse.XGrid = 'on'
                                          axMagUse.YGrid = 'on'
                                          axAlgnUse.XGrid = 'on'
                                          axAlgnUse.YGrid = 'on'
                                          axMagUse.XLim = [0 350];
                                              axAlgnUse.XLim = [0 350];
                                              axMagUse.XTick = [0:50:300]
                                              axAlgnUse.XTick = [0:50:300]
                                              axM = findobj(figMagUse.Children,'Type','axes');
                                              axA = findobj(figAlgnUse.Children,'Type','axes');
                                          upperYMag = max([axM.YLim]);
                                          upperYMisalign = max([axA.YLim]);
                                          if oneTime==1
                                              prevMaxM =  upperYMisalign;
                                              PrevMaxV = upperYMag;
                                              oneTime = 0;
                                          else
                                          if prevMaxM>upperYMisalign
                                              upperYMisalign = prevMaxM;
                                          else
                                              prevMaxM =  upperYMisalign;
                                          end
                                          if prevMaxV>upperYMag
                                              upperYMag = prevMaxV;
                                          else
                                              PrevMaxV = upperYMag;
                                          end
                                          end

                                          axMagUse.FontSize = 13.5;
                                          axAlgnUse.FontSize = 13.5;
                                          newPlot = 1;
                                      totNum = 1+ totNum;
                                      ampNum = 1;
                                      
                                      else
                                          if i==length(listing)
                                              hold(axMagUse,'on');
                                          line(axMagUse,[p(totNum,1:ampNum).XData],[p(totNum,1:ampNum).YData],'color',colorPlot,'LineWidth',4)
                                          hold(axMagUse,'off');
                                          axMagUse.XLabel.String = {'Current amplitude (uA)';['Return Electrode ',num2str(cycles.(n).ref)]}

                                          hold(axAlgnUse,'on');
                                          line(axAlgnUse,[q(totNum,1:ampNum).XData],[q(totNum,1:ampNum).YData],'color',colorPlot,'LineWidth',4)
                                          hold(axAlgnUse,'off');
                                          axAlgnUse.XLabel.String = {'Current amplitude (uA)';['Return Electrode ',num2str(cycles.(n).ref)]};
                                          labString = get(get(axMagUse,'XLabel'),'String');
                                          axMagUse.XGrid = 'on'
                                          axMagUse.YGrid = 'on'
                                          axAlgnUse.XGrid = 'on'
                                          axAlgnUse.YGrid = 'on'
                                          axMagUse.XLim = [0 350];
                                              axAlgnUse.XLim = [0 350];
                                              axMagUse.XTick = [0:50:300];
                                              axAlgnUse.XTick = [0:50:300];
                                               sameaxes([], [avgMagPlot7,avgMagPlot8,avgMagPlot9,avgMagPlot15]);
                                          sameaxes([], [avgMisalignPlot7,avgMisalignPlot8,avgMisalignPlot9,avgMisalignPlot15]);
                 

                                          axM = findobj(figMagUse.Children,'Type','axes');
                                              axA = findobj(figAlgnUse.Children,'Type','axes');
                                          upperYMag = max([axM.YLim]);
                                          upperYMisalign = max([axA.YLim]);
                                          for limRep = 1:length(figAlgnUse.Children)
                                             if isgraphics(figMagUse.Children(limRep),'Axes')
                                              figAlgnUse.Children(limRep).YLim = [0 upperYMisalign];
                                              figMagUse.Children(limRep).YLim = [0 upperYMag];
                                              for vertY = 1:length(figMagUse.Children(limRep).Children)
                                                  if all(figMagUse.Children(limRep).Children(vertY).Color==[1 0 0])
                                                      figMagUse.Children(limRep).Children(vertY).YData = figMagUse.Children(limRep).YLim;
                                                      figAlgnUse.Children(limRep).Children(vertY).YData = figAlgnUse.Children(limRep).YLim;

                                                  end
                                              end
                                             end
                                          end
                                          axMagUse.FontSize = 13.5;
                                          axAlgnUse.FontSize = 13.5;
                                          newPlot = 1;
                                         
                                      saveas(avgMisalignPlot7,[handles.figDir,'stim7Misalignment','.svg']);
                                      saveas(avgMisalignPlot7,[handles.figDir,'stim7Misalignment','.jpg']);
                                      saveas(avgMagPlot7,[handles.figDir,'stim7velMag','.svg']);
                                      saveas(avgMagPlot7,[handles.figDir,'stim7velMag','.jpg']);
                                      saveas(avgMisalignPlot8,[handles.figDir,'stim8Misalignment','.svg']);
                                      saveas(avgMisalignPlot8,[handles.figDir,'stim8Misalignment','.jpg']);
                                      saveas(avgMagPlot8,[handles.figDir,'stim8velMag','.svg']);
                                      saveas(avgMagPlot8,[handles.figDir,'stim8velMag','.jpg']);
                                      saveas(avgMisalignPlot9,[handles.figDir,'stim9Misalignment','.svg']);
                                      saveas(avgMisalignPlot9,[handles.figDir,'stim9Misalignment','.jpg']);
                                      saveas(avgMagPlot9,[handles.figDir,'stim9velMag','.svg']);
                                      saveas(avgMagPlot9,[handles.figDir,'stim9velMag','.jpg']);
                                      saveas(avgMisalignPlot15,[handles.figDir,'stim15Misalignment','.svg']);
                                      saveas(avgMisalignPlot15,[handles.figDir,'stim15Misalignment','.jpg']);
                                      saveas(avgMagPlot15,[handles.figDir,'stim15velMag','.svg']);
                                      saveas(avgMagPlot15,[handles.figDir,'stim15velMag','.jpg']);
                                          
                                          end
                                          ampNum = 1+ampNum;

                                          
                                      end
                                      
                              end
                        end
                  
    end
