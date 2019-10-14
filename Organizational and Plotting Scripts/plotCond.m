function handles = plotCond(handles)
handles.listing([handles.listing.bytes]==0)=[];
handles.maxNorm = 0;
for allF = 1:length(handles.listing)
    test = load([handles.listing(allF).folder '\' handles.listing(allF).name]);
    if isfield(test.Results, 'segmentData')
       handles.params(allF).stim = test.Results.segmentData.stim;
       handles.params(allF).ref = test.Results.segmentData.refNum;
       handles.params(allF).eCombs = [handles.params(allF).stim handles.params(allF).ref];
       handles.params(allF).p1d = test.Results.segmentData.p1d;
       handles.params(allF).ipg = test.Results.segmentData.ipg;
       handles.params(allF).p2d = test.Results.segmentData.p2d;
       handles.params(allF).p1amp = test.Results.segmentData.p1amp;
       handles.params(allF).p2amp = test.Results.segmentData.p2amp;
       %need to change deafault designation!!!!
           if any(strfind(handles.listing(allF).name,'dSp2d'))
        dSp2dPos = strfind(handles.listing(allF).name,'dSp2d');
        handles.params(allF).dSp2d = str2num(filename(dSp2dPos+5:delin(14)-1));
           else
        handles.params(allF).dSp2d = -1;
           end
           
           if handles.LEyeFlag.Value
        handles.params(allF).cycavgL = [test.Results.ll_cycavg' test.Results.lr_cycavg' test.Results.lz_cycavg'];
        handles.params(allF).timeL = test.Results.segmentData.Time_Eye;
        handles.params(allF).stdL = [test.Results.ll_cycstd' test.Results.lr_cycstd' test.Results.lz_cycstd'];

        handles.params(allF).MagL = test.Results.usedmaxMagL;
        
        handles.params(allF).MisalignL = test.Results.usedMisalignL;
        
        handles.params(allF).M3DL = test.Results.usedMisalignL3D;

        handles.pullIndsL(allF) = {test.Results.usedpullIndsL};
        Results = test.Results;
        save([handles.listing(allF).folder '\' handles.listing(allF).name],'Results');
           end
        if handles.REyeFlag.Value
        handles.params(allF).cycavgR = a;
        handles.params(allF).timeR = a;
        handles.params(allF).stdR = a;
        handles.params(allF).MagR =a;
        handles.params(allF).MisalignR = a;
        handles.params(allF).M3DR = a;
        handles.pullIndsR(allF) = a;
        end
        handles.params(allF).FacialNerve = test.Results.FacialNerve;
    else
    filename = handles.listing(allF).name;
    underS = find(filename=='_');
    dash = find(filename=='-');
    delin = sort([underS dash],'ascend');
    stimPos = strfind(filename,'stim');
    refPos = strfind(filename,'ref');
    ipgPos = strfind(filename,'IPG');
    dotF = find(filename=='.');
    handles.params(allF).stim = str2num(filename(stimPos+4:refPos-1));
    handles.params(allF).ref = str2num(filename(refPos+3:delin(7)-1));
    handles.params(allF).eCombs = [handles.params(allF).stim handles.params(allF).ref];
    if any(strfind(handles.listing(allF).name,'phaseDur'))
        p1dPos = strfind(handles.listing(allF).name,'pulseDur');
        handles.params(allF).p1d = str2num(filename(p1dPos+9:delin(9)-1));
        handles.params(allF).ipg = str2num(filename(ipgPos+3:delin(11)-1));
        handles.params(allF).p2d = p1d;
        amp = strfind(filename,'amp');
        nextD = find(delin>amp,1);
        handles.params(allF).p1amp = str2num(filename(amp(1)+3:delin(12)-1));
        handles.params(allF).p2amp = p1amp;
    elseif any(strfind(handles.listing(allF).name,'phase1Dur'))
        p1dPos = strfind(filename,'phase1Dur');
        handles.params(allF).p1d = str2num(filename(p1dPos+9:delin(9)-1));
        p2dPos = strfind(filename,'phase2Dur');
        handles.params(allF).p2d = str2num(filename(p2dPos+9:delin(10)-1));
        handles.params(allF).ipg = str2num(filename(ipgPos+3:delin(11)-1));
        p1aPos = strfind(filename,'phase1Amp');
        handles.params(allF).p1amp = str2num(filename(p1aPos+9:delin(12)-1));
        p2aPos = strfind(filename,'phase2Amp');
        handles.params(allF).p2amp = str2num(filename(p2aPos+9:delin(13)-1));
        
    end
    
    if any(strfind(handles.listing(allF).name,'dSp2d'))
        dSp2dPos = strfind(handles.listing(allF).name,'dSp2d');
        handles.params(allF).dSp2d = str2num(filename(dSp2dPos+5:delin(14)-1));
    else
        handles.params(allF).dSp2d = -1;
    end
    
    switch handles.params(allF).stim
        case num2cell(handles.larpelectrodes.Value)
            handles.pureRot = [1 0 0];
        case num2cell(handles.ralpelectrodes.Value)
            handles.pureRot = [0 1 0];
        case num2cell(handles.lhrhelectrodes.Value)
            handles.pureRot = [0 0 1];
    end
    
    load(filename);
    if handles.LEyeFlag.Value
        handles.params(allF).cycavgL = [Results.ll_cycavg' Results.lr_cycavg' Results.lz_cycavg'];
        tL = 1/Results.Fs:1/Results.Fs:length(Results.ll_cycavg)/Results.Fs;
        handles.params(allF).timeL = [tL' tL' tL'];
        handles.params(allF).stdL = [Results.ll_cycstd' Results.lr_cycstd' Results.lz_cycstd'];
        
        d = diff(Results.ll_cyc');
        
        [handles, MisalignL, maxMagL, Misalign3DL, pullIndsL]  = MagThreshL(handles,Results);
        handles.params(allF).MagL = maxMagL;
        handles.params(allF).MisalignL = MisalignL;
        handles.params(allF).M3DL = Misalign3DL;
        handles.pullIndsL(allF) = {pullIndsL};
    end
    if handles.REyeFlag.Value
        handles.params(allF).cycavgR = [Results.rl_cycavg' Results.rr_cycavg' Results.rz_cycavg'];
        tR = 1/Results.Fs:1/Results.Fs:length(Results.rl_cycavg)/Results.Fs;
        handles.params(allF).timeR = [tR' tR' tR'];
        handles.params(allF).stdR = [Results.rl_cycstd' Results.rr_cycstd' Results.rz_cycstd'];
        
        d = diff(Results.rl_cyc');
        
        [handles, MisalignR, maxMagR, Misalign3DR, pullIndsR]  = MagThreshR(handles,Results);
        handles.params(allF).MagR = maxMagR;
        handles.params(allF).MisalignR = MisalignR;
        handles.params(allF).M3DR = Misalign3DR;
        handles.pullIndsR(allF) = {pullIndsR};
    end
    
    handles.params(allF).FacialNerve = Results.FacialNerve;
    
    end
end

if handles.norm.Value
    
    %%% Need to add case for isfield
    if isfield(test.Results, 'segmentData')
    else
        dsInd = find([handles.params.dSp2d]>0);
        for q = 1:length(handles.listing)
            if ([handles.params(q).dSp2d]<0)
                if  any(handles.params(q).stim == [handles.params(dsInd).stim])
                    limStim = find(handles.params(q).stim == [handles.params(dsInd).stim]);
                    if any(handles.params(q).ref == [handles.params(dsInd(limStim)).ref])
                        limStimInd = dsInd(limStim);
                        limRef = find(handles.params(q).ref == [handles.params(limStimInd).ref]);
                        if any(handles.params(q).p2d==[handles.params(limStimInd(limRef)).dSp2d])
                            limRefInd = limStimInd(limRef);
                            limp2d = find(handles.params(q).p2d == [handles.params(limRefInd).dSp2d]);
                            
                            handles.params(q).normInd = limRefInd(limp2d);
                            handles.maxNorm = max(handles.maxNorm,length(limp2d));
                        else
                            corrInds = find((handles.params(q).stim == [handles.params(dsInd).stim]) & (handles.params(q).ref == [handles.params(dsInd).ref])...
                                & (handles.params(q).dSp2d<0));
                            if length(limRef)>1
                                handles.params(q).normInd = dsInd(corrInds);
                                handles.maxNorm = max(handles.maxNorm,length(corrInds));
                            else
                                handles.params(q).normInd = dsInd(corrInds(1));
                                
                            end
                        end
                    end
                else
                    
                end
            else
            end
        end
    end
    
else
    handles.maxNomr = 1;
    for q = 1:length(handles.listing)
        handles.params(q).normInd = [];
    end
end
rot = [cosd(-45) -sind(-45) 0;...
    sind(-45) cosd(-45) 0;...
    0 0 1];
for r = 1:length(handles.listing)
    if handles.LEyeFlag.Value
        if handles.norm.Value && ~isempty(handles.params(r).normInd)
            tempMag = [];
            tempMis = [];
            for times = 1:length(handles.params(r).normInd)
                tempMag(:,times) = handles.params(r).MagL./mean(handles.params(handles.params(r).normInd(times)).MagL);
                tempMis(:,times) = handles.params(r).MisalignL./mean(handles.params(handles.params(r).normInd(times)).MisalignL);
            end
            handles.params(r).MagL = tempMag;
            handles.params(r).MisalignL = tempMis;
        end
        
        handles.params(r).meanMagL = mean(handles.params(r).MagL);
        handles.params(r).meanMisalignL = mean(handles.params(r).MisalignL);
        handles.params(r).stdMagL = std(handles.params(r).MagL);
        handles.params(r).stdMisalignL = std(handles.params(r).MisalignL);
        handles.params(r).meanM3DL = mean(handles.params(r).M3DL);
        handles.params(r).plotM3DL = (rot*(handles.params(r).meanM3DL/norm(handles.params(r).meanM3DL))')';
    end
    
    if handles.REyeFlag.Value
        if handles.norm.Value && ~isempty(handles.params(r).normInd)
            handles.params(r).MagR = handles.params(r).MagR./mean(handles.params(handles.params(r).normInd).MagR);
            handles.params(r).MisalignR = handles.params(r).MisalignR./mean(handles.params(handles.params(r).normInd).MisalignR);
        end
        handles.params(r).meanMagR = mean(handles.params(r).MagR);
        handles.params(r).meanMisalignR = mean(handles.params(r).MisalignR);
        handles.params(r).stdMagR = std(handles.params(r).MagR);
        handles.params(r).stdMisalignR = std(handles.params(r).MisalignR);
        handles.params(r).meanM3DR = mean(handles.params(r).M3DR);
        handles.params(r).plotM3DR = (rot*(handles.params(r).meanM3DR/norm(handles.params(r).meanM3DR))')';
    end
end
handles.allCombs=[];
a={handles.params.eCombs}';

b={handles.params.normInd}';
b(cellfun(@isempty,b))={0};
tempb = [];
temp = [];
for q = 1:length(a)
    if handles.norm.Value
        if q>1
            if ismember(b{q-1},b{q})
            elseif b{q}(1)>0
                tempb = [tempb; b(q)];
                temp = [temp; a(q)];
            end
        else
            if b{q}(1)>0
                tempb = [tempb; b(q)];
                temp = [temp; a(q)];
            end
        end
    else
        if q>1
            if ismember(a{q-1},a{q})
            else
                temp = [temp; a(q)];
                tempb = [tempb; {1}];
            end
        else
            temp = [temp; a(q)];
            tempb = [tempb; {1}];
        end
    end
end
for o = 1:length(temp)
    handles.allCombs(o,1:2) = temp{o};
    handles.allCombs(o,3) = length(tempb{o});
end
handles.allStim = unique([handles.params.stim]);
handles.allRef = unique([handles.params.ref]);
handles.allP1d = unique([handles.params.p1d]);
handles.allP2d = unique([handles.params.p2d]);
handles.allP1a = unique([handles.params.p1amp]);
handles.allP2a = unique([handles.params.p2amp]);
handles.allIPG = unique([handles.params.ipg]);

handles.LRZ = [handles.larp.Value handles.ralp.Value handles.lhrh.Value];
handles.directions = find(handles.LRZ);


% for i = 1:sum(handles.figtomake)
%     for q = 1:maxNorm
%     handles.returnNum = [];
%     handles.ldgV = {};
%     if handles.stimulatingE.Value
%         switch handles.directions(i)
%             case 1
%                 handles.stimNum = handles.larpelectrodes.Value;
%                 handles.figdir = 'LARP';
%                 handles.pureRot = [1 0 0];
%             case 2
%                 handles.stimNum = handles.ralpelectrodes.Value;
%                 handles.figdir = 'RALP';
%                 handles.pureRot = [0 1 0];
%             case 3
%                 handles.stimNum = handles.lhrhelectrodes.Value;
%                 handles.figdir = 'LHRH';
%                 handles.pureRot = [0 0 1];
%         end
%         if handles.bipolarstim.Value
%             handles.returnNum = [handles.returnNum handles.stimNum];
%         end
%         if handles.distantstim.Value
%             handles.returnNum = [handles.returnNum handles.distant.Value];
%         end
%         if handles.ccstim.Value
%             handles.returnNum = [handles.returnNum handles.commoncrus.Value];
%         end
%
%         oneInds = [];
%         otherInds = [];
%
%         if any(handles.returnNum==1)
%             oneInds = find(contains({handles.listing.name},['ref',num2str(1)]));
%             if ~isempty(find(contains({handles.listing.name},['ref',num2str(10)])))
%                 otherInds = [otherInds find(contains({handles.listing.name},['ref',num2str(10)]))];
%             end
%             if ~isempty(find(contains({handles.listing.name},['ref',num2str(11)])))
%                 otherInds = [otherInds find(contains({handles.listing.name},['ref',num2str(11)]))];
%             end
%             if ~isempty(find(contains({handles.listing.name},['ref',num2str(12)])))
%                 otherInds = [otherInds find(contains({handles.listing.name},['ref',num2str(12)]))];
%             end
%             if ~isempty(find(contains({handles.listing.name},['ref',num2str(13)])))
%                 otherInds = [otherInds find(contains({handles.listing.name},['ref',num2str(13)]))];
%             end
%             if ~isempty(find(contains({handles.listing.name},['ref',num2str(14)])))
%                 otherInds = [otherInds find(contains({handles.listing.name},['ref',num2str(14)]))];
%             end
%             if ~isempty(find(contains({handles.listing.name},['ref',num2str(15)])))
%                 otherInds = [otherInds find(contains({handles.listing.name},['ref',num2str(15)]))];
%             end
%             if isequal(oneInds,sort(otherInds,'ascend'))
%                 handles.returnNum(handles.returnNum==1) = [];
%             end
%         end
%         go = 1;
%         checkReturn = 1;
%         while go
%             if isempty(find(contains({handles.listing.name},['ref',num2str(handles.returnNum(checkReturn))])))
%                 handles.returnNum(checkReturn) = [];
%                 checkReturn = checkReturn - 1;
%             end
%             if checkReturn == length(handles.returnNum)
%                 go = 0;
%             end
%             checkReturn = checkReturn + 1;
%         end
%         go = 1;
%         checkStim = 1;
%         while go
%             if isempty(find(contains({handles.listing.name},['stim',num2str(handles.stimNum(checkStim))])))
%                 handles.stimNum(checkStim) = [];
%                 checkStim = checkStim - 1;
%             end
%             if checkStim == length(handles.stimNum)
%                 go = 0;
%             end
%             checkStim = checkStim + 1;
%         end
%
%         handles.origreturnNum = handles.returnNum;
%         handles.ldgNames = {};
%         handles.lines = zeros(1,length(handles.origreturnNum));
%         for rN = 1:length(handles.origreturnNum)
%             handles.ldgNames{rN} = ' ';
%         end
% %         handles.avgMagPlot(i) = figure('units','normalized','outerposition',[0 0 1 1]);
% %         handles.avgMisalignPlot(i) = figure('units','normalized','outerposition',[0 0 1 1]);
% %         a = sgtitle(handles.avgMagPlot(i),{['Average Eye Velocity Magnitude, ',handles.figdir] ; ' '},'FontSize', 22, 'FontWeight', 'Bold');
% %         sgtitle(handles.avgMisalignPlot(i),{['Angle of Misalignment, ',handles.figdir]; ' '},'FontSize', 22, 'FontWeight', 'Bold');
%         for j = 1:length(handles.stimNum)
%             handles.returnNum = handles.origreturnNum;
%
%             if handles.curr.Value
%             elseif handles.ipg.Value && handles.p1d.Value
%             elseif handles.ipg.Value && handles.p2d.Value
%                 handles = plotP2dIPGasX(handles,i,j,q)
%             elseif handles.p2d.Value && handles.p1d.Value
%             elseif handles.p1d.Value
%                 plotP1dasX(handles,i,j,q)
%             elseif handles.p2d.Value
%                 handles = plotP2dasX(handles,i,j,q)
%             end
%         end
%
%     elseif handles.referenceE.Value
%         if handles.curr.Value
%         elseif handles.ipg.Value && handles.p1d.Value
%         elseif handles.ipg.Value && handles.p2d.Value
%         elseif handles.p2d.Value && handles.p1d.Value
%         elseif handles.p1d.Value
%         elseif handles.p2d.Value
%         end
%     end
% %             if handles.LEyeFlag.Value + handles.REyeFlag.Value == 2
% %             t=[];
% %             for tpts = 1:length(handles.fig)
% %                 t = [t [handles.fig(tpts).cycles(:).twitch]];
% %             end
% %             if any(t)
% %                 ldg1 = legend(handles.fig(i,j).avgMagaxR,[handles.lines handles.cutOff1],[handles.ldgNames {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','horizontal');
% %                 ldg2 = legend(handles.fig(i,j).avgMisalignaxR,[handles.lines handles.cutOff1],[handles.ldgNames {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','horizontal');
% %                 ldg1.Position = [0.4 0.01 0.1308 0.0192];
% %                 ldg2.Position = [0.4 0.01 0.1308 0.0192];
% %                 ldg1.FontSize = 13.5;
% %                 ldg2.FontSize = 13.5;
% %             else
% %                 ldg1 = legend(handles.fig(i,j).avgMagaxR,handles.lines,handles.ldgNames,'Orientation','horizontal');
% %                 ldg2 = legend(handles.fig(i,j).avgMisalignaxR,handles.lines,handles.ldgNames,'Orientation','horizontal');
% %                 ldg1.Position = [0.4 0.01 0.1308 0.0192];
% %                 ldg2.Position = [0.4 0.01 0.1308 0.0192];
% %                 ldg1.FontSize = 13.5;
% %                 ldg2.FontSize = 13.5;
% %             end
% %
% %
% %             %*[0.7940    0.0297    0.1153;-0.8296    0.0283   -0.1883;0.7940    0.0297    0.1153]
% %             if handles.stimulatingE.Value
% %                 misalgnName = [handles.figDir,'\eyeMisalignment_ByStimE_R&Leye_',handles.figdir];
% %                 velName = [handles.figDir,'\eyeVelocity_ByStimeE_R&Leye_',handles.figdir];
% %             elseif handles.referenceE.Value
% %                 misalgnName = [handles.figDir,'\eyeMisalignment_ByRefE_R&Leye_',handles.figdir];
% %                 velName = [handles.figDir,'\eyeVelocity_ByRefE_R&Leye_',handles.figdir];
% %             end
% %             saveas(handles.avgMisalignPlot(i),[misalgnName,'.svg']);
% %             saveas(handles.avgMisalignPlot(i),[misalgnName,'.jpg']);
% %             saveas(handles.avgMisalignPlot(i),[misalgnName,'.fig']);
% %             saveas(handles.avgMagPlot(i),[velName,'.svg']);
% %             saveas(handles.avgMagPlot(i),[velName,'.jpg']);
% %             saveas(handles.avgMagPlot(i),[velName,'.fig']);
% %             close(handles.avgMisalignPlot(i));
% %             close(handles.avgMagPlot(i));
% %         elseif handles.LEyeFlag.Value
% %             t=[];
% %             for tpts = 1:length(handles.fig)
% %                 t = [t [handles.fig(tpts).cycles(:).twitch]];
% %             end
% %             if any(t)
% %                 ldg1 = legend(handles.fig(i,j).avgMagaxL,[handles.lines handles.cutOff1],[handles.ldgNames {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','horizontal','AutoUpdate','off');
% %                 ldg2 = legend(handles.fig(i,j).avgMisalignaxL,[handles.lines handles.cutOff1],[handles.ldgNames {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','horizontal','AutoUpdate','off');
% %                 ldg1.Position = [0.4 0.01 0.1308 0.0192];
% %                 ldg2.Position = [0.4 0.01 0.1308 0.0192];
% %                 ldg1.FontSize = 13.5;
% %                 ldg2.FontSize = 13.5;
% %             else
% %                 ldg1 = legend(handles.fig(i,j).avgMagaxL,handles.lines,handles.ldgNames,'Orientation','horizontal','AutoUpdate','off');
% %                 ldg2 = legend(handles.fig(i,j).avgMisalignaxL,handles.lines,handles.ldgNames,'Orientation','horizontal','AutoUpdate','off');
% %                 ldg1.Position = [0.4 0.01 0.1308 0.0192];
% %                 ldg2.Position = [0.4 0.01 0.1308 0.0192];
% %                 ldg1.FontSize = 13.5;
% %                 ldg2.FontSize = 13.5;
% %             end
% %
% %
% %             %*[0.7940    0.0297    0.1153;-0.8296    0.0283   -0.1883;0.7940    0.0297    0.1153]
% %             if handles.stimulatingE.Value
% %                 if handles.ipg.Value && handles.p2d.Value
% %                     if handles.norm.Value
% %                         misalgnName = [handles.figDir,'\NormalizedeyeMisalignment_vs_Phase2Duration_vs_IPG_3D_ByStimE_Leye_',handles.figdir];
% %                         velName = [handles.figDir,'\NormalizedeyeVelocity_vs_Phase2Duration_vs_IPG_3D_ByStimeE_Leye_',handles.figdir];
% %                     else
% %                         misalgnName = [handles.figDir,'\eyeMisalignment_vs_Phase2Duration_vs_IPG_3D_ByStimE_Leye_',handles.figdir];
% %                         velName = [handles.figDir,'\eyeVelocity_vs_Phase2Duration_vs_IPG_3D_ByStimeE_Leye_',handles.figdir];
% %                     end
% %                 elseif handles.p2d.Value
% %                     if handles.norm.Value
% %                         misalgnName = [handles.figDir,'\NormalizedeyeMisalignment_vs_Phase2Duration_ByStimE_Leye_',handles.figdir];
% %                         velName = [handles.figDir,'\NormalizedeyeVelocity_vs_Phase2Duration_ByStimeE_Leye_',handles.figdir];
% %                     else
% %                         misalgnName = [handles.figDir,'\eyeMisalignment_vs_Phase2Duration_ByStimE_Leye_',handles.figdir];
% %                         velName = [handles.figDir,'\eyeVelocity_vs_Phase2Duration_ByStimeE_Leye_',handles.figdir];
% %                     end
% %                 else
% %                     misalgnName = [handles.figDir,'\eyeMisalignment_ByStimE_Leye_',handles.figdir];
% %                     velName = [handles.figDir,'\eyeVelocity_ByStimeE_Leye_',handles.figdir];
% %                 end
% %             elseif handles.referenceE.Value
% %                 if handles.ipg.Value && handles.p2d.Value
% %                     if handles.norm.Value
% %                         misalgnName = [handles.figDir,'\NormalizedeyeMisalignment_vs_Phase2Duration_vs_IPG_3D_ByRefE_Leye_',handles.figdir];
% %                         velName = [handles.figDir,'\NormalizedeyeVelocity_vs_Phase2Duration_vs_IPG_3D_ByRefE_Leye_',handles.figdir];
% %                     else
% %                         misalgnName = [handles.figDir,'\eyeMisalignment_vs_Phase2Duration_vs_IPG_3D_ByRefE_Leye_',handles.figdir];
% %                         velName = [handles.figDir,'\eyeVelocity_vs_Phase2Duration_vs_IPG_3D_ByRefE_Leye_',handles.figdir];
% %                     end
% %                 elseif handles.p2d.Value
% %                     if handles.norm.Value
% %                         misalgnName = [handles.figDir,'\NormalizedeyeMisalignment_vs_Phase2Duration_ByRefE_Leye_',handles.figdir];
% %                         velName = [handles.figDir,'\NormalizedeyeVelocity_vs_Phase2Duration_ByRefE_Leye_',handles.figdir];
% %                     else
% %                         misalgnName = [handles.figDir,'\eyeMisalignment_vs_Phase2Duration_ByRefE_Leye_',handles.figdir];
% %                         velName = [handles.figDir,'\eyeVelocity_vs_Phase2Duration_ByRefE_Leye_',handles.figdir];
% %                     end
% %                 else
% %                     misalgnName = [handles.figDir,'\eyeMisalignment_ByRefE_Leye_',handles.figdir];
% %                     velName = [handles.figDir,'\eyeVelocity_ByRefE_Leye_',handles.figdir];
% %                 end
% %             end
% %             saveas(handles.avgMisalignPlot(i),[misalgnName,'.svg']);
% %             saveas(handles.avgMisalignPlot(i),[misalgnName,'.jpg']);
% %             saveas(handles.avgMisalignPlot(i),[misalgnName,'.fig']);
% %             saveas(handles.avgMagPlot(i),[velName,'.svg']);
% %             saveas(handles.avgMagPlot(i),[velName,'.jpg']);
% %             saveas(handles.avgMagPlot(i),[velName,'.fig']);
% %             close(handles.avgMisalignPlot(i));
% %             close(handles.avgMagPlot(i));
% %         elseif handles.REyeFlag.Value
% %             t=[];
% %             for tpts = 1:length(handles.fig)
% %                 t = [t [handles.fig(tpts).cycles(:).twitch]];
% %             end
% %             if any(t)
% %                 ldg1 = legend(handles.fig(i,j).avgMagaxR,[handles.lines handles.cutOff1],[handles.ldgNames {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','horizontal');
% %                 ldg2 = legend(handles.fig(i,j).avgMisalignaxR,[handles.lines handles.cutOff1],[handles.ldgNames {'Cutoff Due To Facial Nerve Stimulation'}],'Orientation','horizontal');
% %                 ldg1.Position = [0.4 0.01 0.1308 0.0192];
% %                 ldg2.Position = [0.4 0.01 0.1308 0.0192];
% %                 ldg1.FontSize = 13.5;
% %                 ldg2.FontSize = 13.5;
% %             else
% %                 ldg1 = legend(handles.fig(i,j).avgMagaxR,handles.lines,handles.ldgNames,'Orientation','horizontal');
% %                 ldg2 = legend(handles.fig(i,j).avgMisalignaxR,handles.lines,handles.ldgNames,'Orientation','horizontal');
% %                 ldg1.Position = [0.4 0.01 0.1308 0.0192];
% %                 ldg2.Position = [0.4 0.01 0.1308 0.0192];
% %                 ldg1.FontSize = 13.5;
% %                 ldg2.FontSize = 13.5;
% %             end
% %
% %
% %             %*[0.7940    0.0297    0.1153;-0.8296    0.0283   -0.1883;0.7940    0.0297    0.1153]
% %             if handles.stimulatingE.Value
% %                 misalgnName = [handles.figDir,'\eyeMisalignment_ByStimE_Reye_',handles.figdir];
% %                 velName = [handles.figDir,'\eyeVelocity_ByStimeE_Reye_',handles.figdir];
% %             elseif handles.referenceE.Value
% %                 misalgnName = [handles.figDir,'\eyeMisalignment_ByRefE_Reye_',handles.figdir];
% %                 velName = [handles.figDir,'\eyeVelocity_ByRefE_Reye_',handles.figdir];
% %             end
% %             saveas(handles.avgMisalignPlot(i),[misalgnName,'.svg']);
% %             saveas(handles.avgMisalignPlot(i),[misalgnName,'.jpg']);
% %             saveas(handles.avgMisalignPlot(i),[misalgnName,'.fig']);
% %             saveas(handles.avgMagPlot(i),[velName,'.svg']);
% %             saveas(handles.avgMagPlot(i),[velName,'.jpg']);
% %             saveas(handles.avgMagPlot(i),[velName,'.fig']);
% %             close(handles.avgMisalignPlot(i));
% %             close(handles.avgMagPlot(i));
% %         end
%     end
%  end