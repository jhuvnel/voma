function handles = plotCond(handles)
if any(ismember(fields(handles),'UIFigure'))
    appFlg = 1;
    mergeFlg = handles.mergeFlg;
else
    appFlg = 0;
    mergeFlg = 0;
end

animal = [];
elecByCanal = [];
Leye = 0;
Reye = 0;

normFlg = 0;
handles.listing([handles.listing.bytes]==0)=[];
% [cs,index] = sort_nat({handles.listing.name});
% handles.listing = handles.listing(index);

if isfile('CycleParams.mat')
    handles.listing(find(ismember({handles.listing.name},{'CycleParams.mat'}))) = [];
end
if isfile('Plots.mat')
    handles.listing(find(ismember({handles.listing.name},{'Plots.mat'}))) = [];
end

%listOrder = zeros(length(handles.listing),1);
place = zeros(length(handles.listing),1);
newList = struct();
names = cell(length(handles.listing),1);


if isfile('CycleParams.mat')
    if ~mergeFlg
        answer = questdlg('Would you like to overwrite the CycleParams File?', ...
            'CycleParams File Options', ...
            'Yes','No','Yes');
        % Handle response
        switch answer
            case 'Yes'
                keepCycParam = 0;
            case 'No'
                keepCycParam = 1;
        end
    else
        keepCycParam = 1;
    end
else
    keepCycParam = 0;
end

if keepCycParam
    load('CycleParams.mat');
    handles.params = tempS;
    animal = handles.params(1).animal;
    if isempty(handles.params(1).cycavgL)
        Leye = 0;
    else
        Leye = 1;
    end

    if isempty(handles.params(1).cycavgR)
        Reye = 0;
    else
        Reye = 1;
    end

    elecByCanal = handles.(animal);
    handles.elecByCanal = elecByCanal;
    if any([handles.params.dSp2d]>0)
        ids = find([handles.params.dSp2d]>0);
        vs = num2cell(unique([handles.params(ids).p1d]));
        normBy = cellfun(@num2str, vs, 'UniformOutput',0);
    else
        normBy = [];
    end
else

    spikePath = uigetdir(path,'Choose directory of Spike2 files');
    list = dir(spikePath);
    if isfile([spikePath,'\FileOrder.mat'])
        load([spikePath,'\FileOrder.mat'])
        list = struct();
        for ii = 1:length(FileOrder)
            list(ii).name = FileOrder{ii};
        end
    else
        list([list.bytes]<10000) = [];
        [~,lInds] = sortrows({list.date}');
        list = list(lInds);
    end
    if appFlg
        handles.ProgressBar.Title.String = ['Checking File Names'];
        drawnow
    end
    for allF = 1:length(handles.listing)
        test = load([handles.listing(allF).folder '\' handles.listing(allF).name]);
        names(allF) = {test.Results.raw_filename};

        if appFlg
            handles.PBarObj.Position(3) = allF/length(handles.listing)*1000;
            handles.PBarTxt.String = [num2str(round(allF/length(handles.listing)*100)),'%'];
            drawnow
        end
        %     toMv = find(ismember({list.name},test.Results.raw_filename));
        %     place(allF) = toMv;
        %listOrder(toMv) = allF;
    end

    if appFlg
        handles.ProgressBar.Title.String = ['Waiting'];
        handles.PBarObj.Position(3) = 0/length(handles.listing)*1000;
        handles.PBarTxt.String = 'Waiting';
        drawnow
    end

    pos = 1;
    for abh = 1:length(list)
        toMv = find(ismember(names,{list(abh).name}));
        if ~isempty(toMv)
            if isempty(fields(newList))
                newList = handles.listing(toMv);
            else
                if abh == 92
                    stp = 1;
                end
                newList(pos) = handles.listing(toMv);
            end
            pos = pos+1;
        end
    end
    handles.listing = newList;
    %handles.listing = handles.listing(listOrder);
    handles.maxNorm = 0;
    rot = [cosd(-45) -sind(-45) 0;...
        sind(-45) cosd(-45) 0;...
        0 0 1];

    normNum = 1;
    norm2Use = [];
    if appFlg
        handles.ProgressBar.Title.String = ['Processing ',num2str(length(handles.listing)),' Files'];
        drawnow
    else
        fBar = waitbar(0,['Processing ',num2str(length(handles.listing)),' Files'],'Name','File Progress');
    end
    for allF = 1:length(handles.listing)
        test = load([handles.listing(allF).folder '\' handles.listing(allF).name]);
        dateT = handles.listing(allF).name;
        sl = find(dateT=='-');
        handles.params(allF).date = dateT(sl(2)+1:sl(3)-1);
        handles.params(allF).name = handles.listing(allF).name;
        handles.params(allF).animal = test.Results.segmentData.subj;
        animal = handles.params(allF).animal;
        elecByCanal = handles.(animal);
        if isfield(test.Results, 'segmentData')
            handles.params(allF).stim = test.Results.segmentData.stim;
            handles.params(allF).ref = test.Results.segmentData.refNum;
            handles.params(allF).eCombs = [handles.params(allF).stim handles.params(allF).ref];
            handles.params(allF).p1d = test.Results.segmentData.p1d;
            handles.params(allF).ipg = test.Results.segmentData.ipg;
            handles.params(allF).p2d = test.Results.segmentData.p2d;
            handles.params(allF).p1amp = test.Results.segmentData.p1amp;
            handles.params(allF).p2amp = test.Results.segmentData.p2amp;
            if any(strfind(handles.listing(allF).name,'dSp2d'))
                normFlg = 1;
                handles.params(allF).dSp2d = normNum;%test.Results.segmentData.p1d;
                if allF >1
                    if handles.params(allF-1).dSp2d == -1
                        norm2Use = [];
                    end
                    norm2Use = [norm2Use normNum];
                else
                    norm2Use = [norm2Use normNum];
                end

                normNum = normNum +1;
            else
                handles.params(allF).dSp2d = -1;
            end

            if isfield(test.Results,'usedmaxMagL')
                handles.params(allF).timeL = test.Results.segmentData.Time_Eye;
                handles.params(allF).cycavgL = [test.Results.ll_cycavg' test.Results.lr_cycavg' test.Results.lz_cycavg'];
                handles.params(allF).stdL = [test.Results.ll_cycstd' test.Results.lr_cycstd' test.Results.lz_cycstd'];
                handles.params(allF).MagL = test.Results.usedmaxMagL;
                handles.params(allF).MisalignL = test.Results.usedMisalignL;
                handles.params(allF).M3DL = test.Results.usedMisalign3DL;

                handles.params(allF).allMagL = test.Results.allmaxMagL;
                handles.params(allF).allMisalignL = test.Results.allMisalignL;
                handles.params(allF).allM3DL = test.Results.allMisalign3DL;
                handles.params(allF).cycNum = test.Results.cycNum;

                handles.params(allF).meanMagL = mean(handles.params(allF).MagL);
                handles.params(allF).meanMisalignL = mean(handles.params(allF).MisalignL);
                handles.params(allF).stdMagL = std(handles.params(allF).MagL);
                handles.params(allF).stdMisalignL = std(handles.params(allF).MisalignL);
                handles.params(allF).meanM3DL = mean(handles.params(allF).M3DL);
                handles.params(allF).plotM3DL = (rot*(handles.params(allF).meanM3DL/norm(handles.params(allF).meanM3DL))')';
                if isfield(test.Results,'usedmaxMagL_NystagCorr')
                    handles.params(allF).cycavgL_NystagCorr = [test.Results.ll_cycavg_NystagCorr' test.Results.lr_cycavg_NystagCorr' test.Results.lz_cycavg_NystagCorr'];
                    handles.params(allF).stdL_NystagCorr = [test.Results.ll_cycstd_NystagCorr' test.Results.lr_cycstd_NystagCorr' test.Results.lz_cycstd_NystagCorr'];
                    handles.params(allF).MagL_NystagCorr = test.Results.usedmaxMagL_NystagCorr;
                    handles.params(allF).MisalignL_NystagCorr = test.Results.usedMisalignL_NystagCorr;
                    handles.params(allF).M3DL_NystagCorr = test.Results.usedMisalign3DL_NystagCorr;
                    
                    handles.params(allF).allMagL_NystagCorr = test.Results.allmaxMagL_NystagCorr;
                    handles.params(allF).allMisalignL_NystagCorr = test.Results.allMisalignL_NystagCorr;
                    handles.params(allF).allM3DL_NystagCorr = test.Results.allMisalign3DL_NystagCorr;
                    handles.params(allF).cycNum_NystagCorr = test.Results.cycNum_NystagCorr;
                    
                    handles.params(allF).meanMagL_NystagCorr = mean(handles.params(allF).MagL_NystagCorr);
                    handles.params(allF).meanMisalignL_NystagCorr = mean(handles.params(allF).MisalignL_NystagCorr);
                    handles.params(allF).stdMagL_NystagCorr = std(handles.params(allF).MagL_NystagCorr);
                    handles.params(allF).stdMisalignL_NystagCorr = std(handles.params(allF).MisalignL_NystagCorr);
                    handles.params(allF).meanM3DL_NystagCorr = mean(handles.params(allF).M3DL_NystagCorr);
                    handles.params(allF).plotM3DL_NystagCorr = (rot*(handles.params(allF).meanM3DL_NystagCorr/norm(handles.params(allF).meanM3DL_NystagCorr))')';
                end
                handles.params(allF).NystagCorr = 1;
                Leye = 1;
            else
                handles.params(allF).timeL = [];
                handles.params(allF).cycavgL = [];
                handles.params(allF).stdL = [];
                handles.params(allF).MagL = [];
                handles.params(allF).MisalignL = [];
                handles.params(allF).M3DL = [];
                handles.params(allF).meanMagL = [];
                handles.params(allF).meanMisalignL = [];
                handles.params(allF).stdMagL = [];
                handles.params(allF).stdMisalignL = [];
                handles.params(allF).meanM3DL = [];
                handles.params(allF).plotM3DL = [];

                handles.params(allF).cycavgL_NystagCorr = [];
                handles.params(allF).stdL_NystagCorr = [];
                handles.params(allF).MagL_NystagCorr = [];
                handles.params(allF).MisalignL_NystagCorr = [];
                handles.params(allF).M3DL_NystagCorr = [];
                handles.params(allF).meanMagL_NystagCorr = [];
                handles.params(allF).meanMisalignL_NystagCorr = [];
                handles.params(allF).stdMagL_NystagCorr = [];
                handles.params(allF).stdMisalignL_NystagCorr = [];
                handles.params(allF).meanM3DL_NystagCorr = [];
                handles.params(allF).plotM3DL_NystagCorr = [];
                Leye = 0;
            end

            if isfield(test.Results,'usedmaxMagR')
                handles.params(allF).timeR = test.Results.segmentData.Time_Eye;

                handles.params(allF).cycavgR = [test.Results.rl_cycavg' test.Results.rr_cycavg' test.Results.rz_cycavg'];
                handles.params(allF).stdR = [test.Results.rl_cycstd' test.Results.rr_cycstd' test.Results.rz_cycstd'];
                handles.params(allF).MagR = test.Results.usedmaxMagR;
                handles.params(allF).MisalignR = test.Results.usedMisalignR;
                handles.params(allF).M3DR = test.Results.usedMisalign3DR;

                handles.params(allF).allMagR = test.Results.allmaxMagR;
                handles.params(allF).allMisalignR = test.Results.allMisalignR;
                handles.params(allF).allM3DR = test.Results.allMisalign3DR;
                handles.params(allF).cycNum = test.Results.cycNum;

                handles.params(allF).meanMagR = mean(handles.params(allF).MagR);
                handles.params(allF).meanMisalignR = mean(handles.params(allF).MisalignR);
                handles.params(allF).stdMagR = std(handles.params(allF).MagR);
                handles.params(allF).stdMisalignR = std(handles.params(allF).MisalignR);
                handles.params(allF).meanM3DR = mean(handles.params(allF).M3DR);
                handles.params(allF).plotM3DR = (rot*(handles.params(allF).meanM3DR/norm(handles.params(allF).meanM3DR))')';
                if isfield(test.Results,'usedmaxMagR_NystagCorr')
                    handles.params(allF).cycavgR_NystagCorr = [test.Results.rl_cycavg_NystagCorr' test.Results.rr_cycavg_NystagCorr' test.Results.rz_cycavg_NystagCorr'];
                    handles.params(allF).stdR_NystagCorr = [test.Results.rl_cycstd_NystagCorr' test.Results.rr_cycstd_NystagCorr' test.Results.rz_cycstd_NystagCorr'];
                    handles.params(allF).MagR_NystagCorr = test.Results.usedmaxMagR_NystagCorr;
                    handles.params(allF).MisalignR_NystagCorr = test.Results.usedMisalignR_NystagCorr;
                    handles.params(allF).M3DR_NystagCorr = test.Results.usedMisalign3DR_NystagCorr;
                    
                    handles.params(allF).allMagR_NystagCorr = test.Results.allmaxMagR_NystagCorr;
                    handles.params(allF).allMisalignR_NystagCorr = test.Results.allMisalignR_NystagCorr;
                    handles.params(allF).allM3DR_NystagCorr = test.Results.allMisalign3DR_NystagCorr;
                    handles.params(allF).cycNum_NystagCorr = test.Results.cycNum_NystagCorr;
                    
                    handles.params(allF).meanMagR_NystagCorr = mean(handles.params(allF).MagR_NystagCorr);
                    handles.params(allF).meanMisalignR_NystagCorr = mean(handles.params(allF).MisalignR_NystagCorr);
                    handles.params(allF).stdMagR_NystagCorr = std(handles.params(allF).MagR_NystagCorr);
                    handles.params(allF).stdMisalignR_NystagCorr = std(handles.params(allF).MisalignR_NystagCorr);
                    handles.params(allF).meanM3DR_NystagCorr = mean(handles.params(allF).M3DR_NystagCorr);
                    handles.params(allF).plotM3DR_NystagCorr = (rot*(handles.params(allF).meanM3DR_NystagCorr/norm(handles.params(allF).meanM3DR_NystagCorr))')';
                end
                handles.params(allF).NystagCorr = 1;
                Reye = 1;
            else
                handles.params(allF).timeR = [];
                handles.params(allF).cycavgR = [];               
                handles.params(allF).stdR = [];
                handles.params(allF).MagR = [];
                handles.params(allF).MisalignR = [];
                handles.params(allF).M3DR = [];
                handles.params(allF).meanMagR = [];
                handles.params(allF).meanMisalignR = [];
                handles.params(allF).stdMagR = [];
                handles.params(allF).stdMisalignR = [];
                handles.params(allF).meanM3DR = [];
                handles.params(allF).plotM3DR = [];

                handles.params(allF).cycavgR_NystagCorr = [];               
                handles.params(allF).stdR_NystagCorr = [];
                handles.params(allF).MagR_NystagCorr = [];
                handles.params(allF).MisalignR_NystagCorr = [];
                handles.params(allF).M3DR_NystagCorr = [];
                handles.params(allF).meanMagR_NystagCorr = [];
                handles.params(allF).meanMisalignR_NystagCorr = [];
                handles.params(allF).stdMagR_NystagCorr = [];
                handles.params(allF).stdMisalignR_NystagCorr = [];
                handles.params(allF).meanM3DR_NystagCorr = [];
                handles.params(allF).plotM3DR_NystagCorr = [];
                Reye = 0;
            end


            handles.params(allF).FacialNerve = test.Results.FacialNerve;
            if isfield(test.Results,'AvC')
                handles.params(allF).AvC = test.Results.AvC;
            else
                handles.params(allF).AvC = 0;
            end

            if appFlg
                if normFlg
                    if any(strfind(handles.listing(allF).name,'dSp2d'))
                        handles.params(allF).normInd = [];
                    else
                        handles.params(allF).normInd = norm2Use;
                    end
                else
                    handles.params(allF).normInd = [];
                end
            else
                if handles.norm.Value
                    if any(strfind(handles.listing(allF).name,'dSp2d'))
                        handles.params(allF).normInd = [];
                    else
                        handles.params(allF).normInd = norm2Use;
                    end
                else
                    handles.params(allF).normInd = [];
                end
            end
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
                normFlg = 1;
                dSp2dPos = strfind(handles.listing(allF).name,'dSp2d');
                handles.params(allF).dSp2d = normNum;%str2num(filename(dSp2dPos+5:delin(14)-1));
                if allF >1
                    if handles.params(allF-1).dSp2d == -1
                        norm2Use = [];
                    end
                    norm2Use = [norm2Use normNum];
                else
                    norm2Use = [norm2Use normNum];
                end

                normNum = normNum +1;
            else
                handles.params(allF).dSp2d = -1;
            end

            if appFlg
                switch handles.params(allF).stim
                    case num2cell(elecByCanal{1})
                        handles.pureRot = [1 0 0];
                        handles.stimCanal = 1;
                        handles.rotSign = 1;
                    case num2cell(elecByCanal{2})
                        handles.pureRot = [0 1 0];
                        handles.stimCanal = 2;
                        handles.rotSign = 1;
                    case num2cell(elecByCanal{3})
                        handles.pureRot = [0 0 1];
                        handles.stimCanal = 3;
                        handles.rotSign = -1;
                end
            else
                switch handles.params(allF).stim
                    case num2cell(handles.larpelectrodes.Value)
                        handles.pureRot = [1 0 0];
                        handles.stimCanal = 1;
                        handles.rotSign = 1;
                    case num2cell(handles.ralpelectrodes.Value)
                        handles.pureRot = [0 1 0];
                        handles.stimCanal = 2;
                        handles.rotSign = 1;
                    case num2cell(handles.lhrhelectrodes.Value)
                        handles.pureRot = [0 0 1];
                        handles.stimCanal = 3;
                        handles.rotSign = -1;
                end
            end

            load(filename);
            handles.params(allF).cycavgL = [Results.ll_cycavg' Results.lr_cycavg' Results.lz_cycavg'];
            tL = 1/Results.Fs:1/Results.Fs:length(Results.ll_cycavg)/Results.Fs;
            handles.params(allF).timeL = [tL' tL' tL'];
            handles.params(allF).stdL = [Results.ll_cycstd' Results.lr_cycstd' Results.lz_cycstd'];

            d = diff(Results.ll_cyc');

            [handles, MisalignL, maxMagL, Misalign3DL, pullIndsL]  = MagThreshL(handles,Results);
            %                 abc = figure('units','normalized','outerposition',[0 0 1 1]);
            %                 tt = 1:length(Results.stim);
            %                 plot(tt,Results.stim,'k')
            %                     hold on
            %                     l = [];
            %                     r = [];
            %                     z = [];
            %                 for gt = 1:length(pullIndsL)
            %                     l = [l Results.ll_cyc(gt,:)];
            %                     r = [r Results.lr_cyc(gt,:)];
            %                     z = [z Results.lz_cyc(gt,:)];
            %                 end
            %                 plot(tt,l,'g')
            %                 plot(tt,r,'b')
            %                 plot(tt,z,'r')
            %                 plot(tt(pullIndsL),l(pullIndsL),'k*')
            %                 plot(tt(pullIndsL),r(pullIndsL),'k*')
            %                 plot(tt(pullIndsL),z(pullIndsL),'k*')
            %                 hold off
            %                 uiwait(abc)
            handles.params(allF).MagL = maxMagL;
            handles.params(allF).MisalignL = MisalignL;
            handles.params(allF).M3DL = Misalign3DL;
            handles.pullIndsL(allF) = {pullIndsL};
            handles.params(allF).meanMagL = mean(handles.params(allF).MagL);
            handles.params(allF).meanMisalignL = mean(handles.params(allF).MisalignL);
            handles.params(allF).stdMagL = std(handles.params(allF).MagL);
            handles.params(allF).stdMisalignL = std(handles.params(allF).MisalignL);
            handles.params(allF).meanM3DL = mean(handles.params(allF).M3DL);
            handles.params(allF).plotM3DL = (rot*(handles.params(allF).meanM3DL/norm(handles.params(allF).meanM3DL))')';

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
            handles.params(allF).meanMagR = mean(handles.params(allF).MagR);
            handles.params(allF).meanMisalignR = mean(handles.params(allF).MisalignR);
            handles.params(allF).stdMagR = std(handles.params(allF).MagR);
            handles.params(allF).stdMisalignR = std(handles.params(allF).MisalignR);
            handles.params(allF).meanM3DR = mean(handles.params(allF).M3DR);
            handles.params(allF).plotM3DR = (rot*(handles.params(allF).meanM3DR/norm(handles.params(allF).meanM3DR))')';


            handles.params(allF).FacialNerve = Results.FacialNerve;


            if appFlg
                if normFlg
                    if any(strfind(handles.listing(allF).name,'dSp2d'))
                        handles.params(allF).normInd = [];
                    else
                        handles.params(allF).normInd = norm2Use;
                    end
                else
                    handles.params(allF).normInd = [];
                end
            else
                if handles.norm.Value
                    if any(strfind(handles.listing(allF).name,'dSp2d'))
                        handles.params(allF).normInd = [];
                    else
                        handles.params(allF).normInd = norm2Use;
                    end
                else
                    handles.params(allF).normInd = [];
                end
            end

        end

        if appFlg
            handles.PBarObj.Position(3) = allF/length(handles.listing)*1000;
            handles.PBarTxt.String = [num2str(round(allF/length(handles.listing)*100)),'%'];
            drawnow
        else
            waitbar(allF/length(handles.listing),fBar,['Processing ',num2str(allF),':',num2str(length(handles.listing)),' Files'])
        end

    end


    if appFlg
        handles.ProgressBar.Title.String = ['Waiting'];
        handles.PBarObj.Position(3) = 0/length(handles.listing)*1000;
        handles.PBarTxt.String = 'Waiting';
        handles.elecByCanal = elecByCanal;
        drawnow
    else
        delete(fBar)
    end
    normBy = [];
end


if appFlg
    if normFlg
        for r = 1:length(handles.listing)
            if normFlg && ~isempty(handles.params(r).normInd)
%%%%% NEED TO CHECK WHEN WORKING WITH ANODIC VS CATHODIC
                for times = 1:length(handles.params(r).normInd)
                    corrInds = find([handles.params.dSp2d]==handles.params(r).normInd(times));
                    tempMag = handles.params(r).MagL./mean(handles.params(corrInds).MagL);
                    tempMis = handles.params(r).MisalignL./mean(handles.params(corrInds).MisalignL);
                    handles = setfield(handles,'params',{r},['MagL',num2str(handles.params(corrInds).p1d)],tempMag);
                    handles = setfield(handles,'params',{r},['MisalignL',num2str(handles.params(corrInds).p1d)],tempMis);
                    handles = setfield(handles,'params',{r},['meanMagL',num2str(handles.params(corrInds).p1d)],mean(tempMag));
                    handles = setfield(handles,'params',{r},['meanMisalignL',num2str(handles.params(corrInds).p1d)],mean(tempMis));
                    handles = setfield(handles,'params',{r},['stdMagL',num2str(handles.params(corrInds).p1d)],std(tempMag));
                    handles = setfield(handles,'params',{r},['stdMisalignL',num2str(handles.params(corrInds).p1d)],std(tempMis));

                    tempMag_NystagCorr = handles.params(r).MagL_NystagCorr./mean(handles.params(corrInds).MagL_NystagCorr);
                    tempMis_NystagCorr = handles.params(r).MisalignL_NystagCorr./mean(handles.params(corrInds).MisalignL_NystagCorr);
                    handles = setfield(handles,'params',{r},['MagL','_NystagCorr',num2str(handles.params(corrInds).p1d)],tempMag_NystagCorr);
                    handles = setfield(handles,'params',{r},['MisalignL','_NystagCorr',num2str(handles.params(corrInds).p1d)],tempMis_NystagCorr);
                    handles = setfield(handles,'params',{r},['meanMagL','_NystagCorr',num2str(handles.params(corrInds).p1d)],mean(tempMag_NystagCorr));
                    handles = setfield(handles,'params',{r},['meanMisalignL','_NystagCorr',num2str(handles.params(corrInds).p1d)],mean(tempMis_NystagCorr));
                    handles = setfield(handles,'params',{r},['stdMagL','_NystagCorr',num2str(handles.params(corrInds).p1d)],std(tempMag_NystagCorr));
                    handles = setfield(handles,'params',{r},['stdMisalignL','_NystagCorr',num2str(handles.params(corrInds).p1d)],std(tempMis_NystagCorr));

                    tempMag = handles.params(r).MagR./mean(handles.params(corrInds).MagR);
                    tempMis = handles.params(r).MisalignR./mean(handles.params(corrInds).MisalignR);
                    handles = setfield(handles,'params',{r},['MagR',num2str(handles.params(corrInds).p1d)],tempMag);
                    handles = setfield(handles,'params',{r},['MisalignR',num2str(handles.params(corrInds).p1d)],tempMis);
                    handles = setfield(handles,'params',{r},['meanMagR',num2str(handles.params(corrInds).p1d)],mean(tempMag));
                    handles = setfield(handles,'params',{r},['meanMisalignR',num2str(handles.params(corrInds).p1d)],mean(tempMis));
                    handles = setfield(handles,'params',{r},['stdMagR',num2str(handles.params(corrInds).p1d)],std(tempMag));
                    handles = setfield(handles,'params',{r},['stdMisalignR',num2str(handles.params(corrInds).p1d)],std(tempMis));

                    tempMag_NystagCorr = handles.params(r).MagR_NystagCorr./mean(handles.params(corrInds).MagR_NystagCorr);
                    tempMis_NystagCorr = handles.params(r).MisalignR_NystagCorr./mean(handles.params(corrInds).MisalignR_NystagCorr);
                    handles = setfield(handles,'params',{r},['MagR','_NystagCorr',num2str(handles.params(corrInds).p1d)],tempMag_NystagCorr);
                    handles = setfield(handles,'params',{r},['MisalignR','_NystagCorr',num2str(handles.params(corrInds).p1d)],tempMis_NystagCorr);
                    handles = setfield(handles,'params',{r},['meanMagR','_NystagCorr',num2str(handles.params(corrInds).p1d)],mean(tempMag_NystagCorr));
                    handles = setfield(handles,'params',{r},['meanMisalignR','_NystagCorr',num2str(handles.params(corrInds).p1d)],mean(tempMis_NystagCorr));
                    handles = setfield(handles,'params',{r},['stdMagR','_NystagCorr',num2str(handles.params(corrInds).p1d)],std(tempMag_NystagCorr));
                    handles = setfield(handles,'params',{r},['stdMisalignR','_NystagCorr',num2str(handles.params(corrInds).p1d)],std(tempMis_NystagCorr));

                    if isempty(normBy)
                        normBy = {num2str(handles.params(corrInds).p1d)};
                    else
                        if ~any(ismember(normBy,num2str(handles.params(corrInds).p1d)))
                            normBy = [normBy; num2str(handles.params(corrInds).p1d)];
                        end
                    end
                end
            end
        end
    end
else
    if handles.norm.Value
        for r = 1:length(handles.listing)
            if handles.norm.Value && ~isempty(handles.params(r).normInd)

                for times = 1:length(handles.params(r).normInd)
                    corrInds = find([handles.params.dSp2d]==handles.params(r).normInd(times));
                    tempMag = handles.params(r).MagL./mean(handles.params(corrInds).MagL);
                    tempMis = handles.params(r).MisalignL./mean(handles.params(corrInds).MisalignL);
                    handles = setfield(handles,'params',{r},['MagL',num2str(handles.params(corrInds).p1d)],tempMag);
                    handles = setfield(handles,'params',{r},['MisalignL',num2str(handles.params(corrInds).p1d)],tempMis);
                    handles = setfield(handles,'params',{r},['meanMagL',num2str(handles.params(corrInds).p1d)],mean(tempMag));
                    handles = setfield(handles,'params',{r},['meanMisalignL',num2str(handles.params(corrInds).p1d)],mean(tempMis));
                    handles = setfield(handles,'params',{r},['stdMagL',num2str(handles.params(corrInds).p1d)],std(tempMag));
                    handles = setfield(handles,'params',{r},['stdMisalignL',num2str(handles.params(corrInds).p1d)],std(tempMis));

                    tempMag = handles.params(r).MagR./mean(handles.params(corrInds).MagR);
                    tempMis = handles.params(r).MisalignR./mean(handles.params(corrInds).MisalignR);
                    handles = setfield(handles,'params',{r},['MagR',num2str(handles.params(corrInds).p1d)],tempMag);
                    handles = setfield(handles,'params',{r},['MisalignR',num2str(handles.params(corrInds).p1d)],tempMis);
                    handles = setfield(handles,'params',{r},['meanMagR',num2str(handles.params(corrInds).p1d)],mean(tempMag));
                    handles = setfield(handles,'params',{r},['meanMisalignR',num2str(handles.params(corrInds).p1d)],mean(tempMis));
                    handles = setfield(handles,'params',{r},['stdMagR',num2str(handles.params(corrInds).p1d)],std(tempMag));
                    handles = setfield(handles,'params',{r},['stdMisalignR',num2str(handles.params(corrInds).p1d)],std(tempMis));

                    if isempty(normBy)
                        normBy = {num2str(handles.params(corrInds).p1d)};
                    else
                        if ~any(ismember(nb,num2str(handles.params(corrInds).p1d)))
                            normBy = [normBy; num2str(handles.params(corrInds).p1d)];
                        end
                    end
                end
            end
        end
    end
end

%Add code to check for duplicate data points
if ~isfield(handles.params,'TOUSE') || ~keepCycParam
    handles.ProgressBar.Title.String = ['Checking For Duplicates'];
    handles.PBarObj.Position(3) = 0/length(handles.listing)*1000;
    handles.PBarTxt.String = 'Waiting';
    drawnow
    dupInd = [];
    tp = struct('stim', {handles.params.stim}, 'ref', {handles.params.ref},...
        'p1d', {handles.params.p1d}, 'ipg', {handles.params.ipg},...
        'p2d', {handles.params.p2d}, 'p1amp', {handles.params.p1amp},...
        'p2amp', {handles.params.p2amp}, 'dSp2d', {handles.params.dSp2d});
    for i = 1:length(handles.params)
        handles.PBarObj.Position(3) = i/length(handles.params)*1000;
        handles.PBarTxt.String = [num2str(round(i/length(handles.params)*100)),'%'];
        drawnow
        for j = 1:length(handles.params)
            if j~=i
                if isequal(tp(i),tp(j))
                    if isempty(dupInd)
                        dupInd = [dupInd; i j];
                        answer = questdlg({'Duplicate data was detected. Choose which will be used.',['FIRST: ',handles.params(i).name],['SECOND: ',handles.params(j).name]}, ...
                            'Duplicate Data', ...
                            'First','Second','Second');
                        switch answer
                            case 'First'
                                handles.params(i).TOUSE = 1;
                                handles.params(j).TOUSE = 0;
                            case 'Second'
                                handles.params(i).TOUSE = 0;
                                handles.params(j).TOUSE = 1;
                        end
                    elseif ~all(any(ismember(dupInd,[i j])))
                        dupInd = [dupInd; i j];
                        answer = questdlg({'Duplicate data was detected. Choose which will be used.',['FIRST: ',handles.params(i).name],['SECOND: ',handles.params(j).name]}, ...
                            'Duplicate Data', ...
                            'First','Second','Second');
                        switch answer
                            case 'First'
                                handles.params(i).TOUSE = 1;
                                handles.params(j).TOUSE = 0;
                            case 'Second'
                                handles.params(i).TOUSE = 0;
                                handles.params(j).TOUSE = 1;
                        end
                    end
                else
                    if ~any(any(ismember(dupInd,j)))
                        handles.params(j).TOUSE = 1;
                    end
                end
            end
        end
    end
    handles.ProgressBar.Title.String = ['Waiting'];
    handles.PBarObj.Position(3) = 0/length(handles.listing)*1000;
    handles.PBarTxt.String = 'Waiting';
    drawnow
    tempS = struct();
    tempS = handles.params;


    save('CycleParams.mat','tempS')
end

tempS = struct();
tempS = handles.params;
if ~keepCycParam
    save('CycleParams.mat','tempS')
end
tb=cell2table({handles.params.eCombs}');
[tb,ia]=unique(tb);
temp = table2cell(tb);

tpl = [];
tpr = [];
tph = [];
for o = 1:length(temp)
    handles.allCombs(o,1:2) = temp{o};
    toPlace = [num2str(temp{o}(1)),'-',num2str(temp{o}(2))];
    if appFlg
        switch temp{o}(1)
            case num2cell(handles.elecByCanal{1})
                handles.LARPCombs = [handles.LARPCombs; temp(o)];
                tpl = [tpl {toPlace}];
            case num2cell(handles.elecByCanal{2})
                handles.RALPCombs = [handles.RALPCombs; temp(o)];
                tpr = [tpr {toPlace}];
            case num2cell(handles.elecByCanal{3})
                handles.LHRHCombs = [handles.LHRHCombs; temp(o)];
                tph = [tph {toPlace}];
        end

        if normFlg
            handles.allCombs(o,3) = length(handles.params(ia(o)+1).normInd);
        else
            handles.allCombs(o,3) = 1;
        end
    else

        if handles.norm.Value
            handles.allCombs(o,3) = length(handles.params(ia(o)+1).normInd);
        else
            handles.allCombs(o,3) = 1;
        end
    end

end

if appFlg
    handles.animal = animal;
    handles.LEye = Leye;
    handles.REye = Reye;
    handles.allStim = unique([handles.params.stim]);
    handles.allRef = unique([handles.params.ref]);
    handles.allP1d = unique([handles.params.p1d]);
    handles.allP2d = unique([handles.params.p2d]);
    handles.allP1a = unique([handles.params.p1amp]);
    handles.allP2a = unique([handles.params.p2amp]);
    handles.allIPG = unique([handles.params.ipg]);
    handles.normBy = normBy;

    handles.AnimalEditField.Value = animal;
    if Leye
        handles.LeftEyeButton.BackgroundColor = 'g';
    else
        handles.LeftEyeButton.BackgroundColor = 'r';
    end
    if Reye
        handles.RightEyeButton.BackgroundColor = 'g';
    else
        handles.RightEyeButton.BackgroundColor = 'r';
    end

    handles.LarpCombs.Items = [{'None'} tpl];
    handles.RalpCombs.Items = [{'None'} tpr];
    handles.LhrhCombs.Items = [{'None'} tph];
    handles.P1D.Items = cellfun(@num2str, num2cell(handles.allP1d), 'UniformOutput', 0);
    handles.P2D.Items = cellfun(@num2str, num2cell(handles.allP2d), 'UniformOutput', 0);
    handles.P1A.Items = [{'None'} cellfun(@num2str, num2cell(handles.allP1a), 'UniformOutput', 0)];
    handles.P2A.Items = [{'None'} cellfun(@num2str, num2cell(handles.allP2a), 'UniformOutput', 0)];
    handles.IPG.Items = cellfun(@num2str, num2cell(handles.allIPG), 'UniformOutput', 0);
    if iscolumn(handles.normBy)
        handles.NormBy.Items = [{'None'} handles.normBy'];
    else
        handles.NormBy.Items = [{'None'} handles.normBy];
    end
else
    handles.allStim = unique([handles.params.stim]);
    handles.allRef = unique([handles.params.ref]);
    handles.allP1d = unique([handles.params.p1d]);
    handles.allP2d = unique([handles.params.p2d]);
    handles.allP1a = unique([handles.params.p1amp]);
    handles.allP2a = unique([handles.params.p2amp]);
    handles.allIPG = unique([handles.params.ipg]);

    handles.LRZ = [handles.larp.Value handles.ralp.Value handles.lhrh.Value];
    handles.directions = find(handles.LRZ);
end





