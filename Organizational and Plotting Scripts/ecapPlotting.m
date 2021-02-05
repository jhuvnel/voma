%% To plot the dataset from GiGi collected on 20190620
% load('R:\Morris, Brian\Monkey Data\GiGi\maestro\ampGrowthandSpreadofExcit-GiGi Maestro 06-12-2019 13-29 - Copy.mat');
% g620 = load('R:\Morris, Brian\Monkey Data\GiGi\20190620\Sinusoidal Stimulation\Virtual Motion\cycles\CycleParams.mat');
% g621 = load('R:\Morris, Brian\Monkey Data\GiGi\20190621\Sinusoidal Stimulation\Virtual Motion\Cycles\CycleParams.mat');
% g624 = load('R:\Morris, Brian\Monkey Data\GiGi\20190624\Sinusoidal Stimulation\Virtual Motion\Cycles\CycleParams.mat');
% g626 = load('R:\Morris, Brian\Monkey Data\GiGi\20190626\Sinusoidal Stimulation\Virtual Motion\Cycles\CycleParams.mat');
% g628 = load('R:\Morris, Brian\Monkey Data\GiGi\20190628\Sinusoidal Stimulation\virtual motion\cycle\CycleParams.mat');

%% List of where eye movement data is located (uncomment row to plot)
%GiGi data from 20101105
% dd = load('R:\Dai\Research\Monkey paper 10 reference electrodes\Monkey paper 10 reference electrodes\Figures\data\2010-11-05 RhGigi-electrode characterization and location test\Cycles\CycleParams.mat');

%DiDi data from 20101104
%  dd = load('R:\Morris, Brian\Condensed Dai Data\2010-11-04 RhDidi-electrode characterization and location test\Cycles\CycleParams.mat');

%Fred data post correction from 20110525
dd = load('R:\Morris, Brian\Condensed Dai Data\2011-05-25-RhFred Electrode characterization\For ECAP Paper\cycles\CycleParams.mat');

%Fred data pre correction from 20100917
%dd = load('R:\Morris, Brian\Condensed Dai Data\2010-09-17-RhFred-electrode characterization test at 2 Hz\cycles\CycleParams.mat');

%*To plot Fred Pre and Post data for e1, e2, and e3 on same figure, use
%part of script starting on line 492*
%% List of where ecap data is located (uncomment rows corresponding to specific animal to plot)
%GiGi data
% path = 'R:\Morris, Brian\Papers\ECAP Paper\GiGi Data\ECAP Data\';
% name = 'GiGiCondensedECAPData.mat';
% aLetter = 'G';

%DiDi data
% path = 'R:\Morris, Brian\Condensed Dai Data\2010-11-04 RhDidi-electrode characterization and location test\MAESTRO\';
% name = 'DidiCondensedECAPData.mat';
% aLetter = 'D';

%Fred data post revision surgery
path = 'R:\Morris, Brian\Condensed Dai Data\Fred Pre-Post Revision ECAP Analysis\Post revision - Post surgery\';
name = 'Fred-PostRevision-CondensedECAPData.mat';
aLetter = 'F';

load([path,name])
%*To plot Fred Pre and Post data for e1, e2, and e3 on same figure, use
%part of script starting on line 492*
%% EXTRACT DATA FOR ANALYSIS
allN = {'G','D','F'};
for q = 1:length(allN)
    toExpAll = table({NaN},{NaN},{NaN},{NaN},{NaN},{NaN},{NaN},'VariableNames',{'Animal','Electrode','ElectrodeA','EyeV','ECAP','EyeVnorm','ECAPnorm'});
toExpMean = table({NaN},{NaN},{NaN},{NaN},{NaN},{NaN},{NaN},'VariableNames',{'Animal2','Electrode2','ElectrodeA2','EyeVmean','ECAPmean','EyeVnormmean','ECAPnormmean'});

    aLetter = allN{q};
switch aLetter
    case 'G'
        dd = load('R:\Dai\Research\Monkey paper 10 reference electrodes\Monkey paper 10 reference electrodes\Figures\data\2010-11-05 RhGigi-electrode characterization and location test\Cycles\CycleParams.mat');
        path = 'R:\Morris, Brian\Papers\ECAP Paper\GiGi Data\ECAP Data\';
        name = 'GiGiCondensedECAPData.mat';
        add = [path,'GiGi'];
        teAllName = 'toExpAllG';
        teMeanName = 'toExpMeanG';
        tp = 8;
    case 'D'
        dd = load('R:\Morris, Brian\Condensed Dai Data\2010-11-04 RhDidi-electrode characterization and location test\Cycles\CycleParams.mat');
        path = 'R:\Morris, Brian\Condensed Dai Data\2010-11-04 RhDidi-electrode characterization and location test\MAESTRO\';
        name = 'DidiCondensedECAPData.mat';
        add = [path,'DiDi'];
        teAllName = 'toExpAllD';
        teMeanName = 'toExpMeanD';
        tp = 9;
    case 'F'
        dd = load('R:\Morris, Brian\Condensed Dai Data\2011-05-25-RhFred Electrode characterization\For ECAP Paper\cycles\CycleParams.mat');
        path = 'R:\Morris, Brian\Condensed Dai Data\Fred Pre-Post Revision ECAP Analysis\Post revision - Post surgery\';
        name = 'Fred-PostRevision-CondensedECAPData.mat';
        add = [path,'Fred'];
        teAllName = 'toExpAllF';
        teMeanName = 'toExpMeanF';
        tp = 9;
        aLetter = 'Fr';
end
load([path,name])
% Plot Velocity First
d = [{'dd'}];%{'g620'},{'g621'},{'g624'},{'g626'},{'g628'}];
for i = 1:length(d)
    idNum = 1;
    for j = 1:length(getfield(eval(d{i}),'tempS'))
        
        switch getfield(eval(d{i}),'tempS',{j},'stim')
            case 1
                f = 'stim1ref2';
                el = 'stim1';
            case 2
                f = 'stim2ref1';
                el = 'stim2';
            case 3
                f = 'stim3ref2';
                el = 'stim3';
            case 4
                f = 'stim4ref5';
                el = 'stim4';
            case 5
                f = 'stim5ref4';
                el = 'stim5';
            case 6
                f = 'stim6ref5';
                el = 'stim6';
            case 7
                f = 'stim7ref8';
                el = 'stim7';
            case 8
                f = 'stim8ref7';
                el = 'stim8';
            case 9
                f = 'stim9ref8';
                el = 'stim9';
        end
        if str2num(getfield(eval(d{i}),'tempS',{j},'p1amp')) == 100
            if length(toExpAll.Animal) == 1
                EyeV = num2cell(getfield(eval(d{i}),'tempS',{j},'MagRF'));
                b = 1:length(EyeV);
                toExpAll.Animal(b) = repmat({aLetter},length(EyeV),1);
                toExpAll.Electrode(b) = repmat({[el]},length(EyeV),1);
                toExpAll.ElectrodeA(b) = repmat({[el,aLetter]},length(EyeV),1);
                toExpAll.EyeV(b) = EyeV;
                toExpAll.ECAP(b) = repmat({'NA'},length(EyeV),1);
                toExpAll.EyeVnorm(b) = repmat({'NA'},length(EyeV),1);
                toExpAll.ECAPnorm(b) = repmat({'NA'},length(EyeV),1);
                
                b = 1;
                toExpMean.Animal2(b) = {aLetter};
                toExpMean.Electrode2(b) = {[el]};
                toExpMean.ElectrodeA2(b) = {[el,aLetter]};
                toExpMean.EyeVmean(b) = {mean([getfield(eval(d{i}),'tempS',{j},'MagRF')])};
                toExpMean.ECAPmean(b) = {'NA'};
                toExpMean.EyeVnormmean(b) = {'NA'};
                toExpMean.ECAPnormmean(b) = {'NA'};
            else
                
                EyeV = num2cell(getfield(eval(d{i}),'tempS',{j},'MagRF'));
                b = length(toExpAll.Animal)+1:length(toExpAll.Animal)+length(EyeV);
                toExpAll.Animal(b) = repmat({aLetter},length(EyeV),1);
                toExpAll.Electrode(b) = repmat({[el]},length(EyeV),1);
                toExpAll.ElectrodeA(b) = repmat({[el,aLetter]},length(EyeV),1);
                toExpAll.EyeV(b) = EyeV;
                toExpAll.ECAP(b) = repmat({'NA'},length(EyeV),1);
                toExpAll.EyeVnorm(b) = repmat({'NA'},length(EyeV),1);
                toExpAll.ECAPnorm(b) = repmat({'NA'},length(EyeV),1);
                
                b = length(toExpMean.Animal2)+1;
                toExpMean.Animal2(b) = {aLetter};
                toExpMean.Electrode2(b) = {[el]};
                toExpMean.ElectrodeA2(b) = {[el,aLetter]};
                toExpMean.EyeVmean(b) = {mean([getfield(eval(d{i}),'tempS',{j},'MagRF')])};
                toExpMean.ECAPmean(b) = {'NA'};
                toExpMean.EyeVnormmean(b) = {'NA'};
                toExpMean.ECAPnormmean(b) = {'NA'};
            end
        end
        
        
        

    end
end

fs = fields(extractedData.plots);
currToPull = 7;
for h = 1:tp
    
    switch fs{h}
        case 'stim1ref2'
            el = 'stim1';
        case 'stim2ref1'
            el = 'stim2';
        case 'stim3ref2'
            el = 'stim3';
        case 'stim4ref5'
            el = 'stim4';
        case 'stim5ref4'
            el = 'stim5';
        case 'stim6ref5'
            el = 'stim6';
        case 'stim7ref8'
            el = 'stim7';
        case 'stim8ref7'
            el = 'stim8';
        case 'stim9ref8'
            el = 'stim9';
    end
    
               mTemp = [extractedData.plots.(fs{h}).pextract]; 
    tInds = find(contains(toExpAll.Electrode,el));
        t2 = mTemp(:,7);
        t2(isnan(t2)) = [];
        if length(t2)>length(tInds)
            tUpper = toExpAll(1:tInds(end),:);
            tLower = toExpAll(tInds(end)+1:end,:);
            lDif = length(t2)-length(tInds);
            b = tInds(end)+1:tInds(end)+lDif;
            b2 = tInds(1):tInds(end)+lDif;
                tUpper.Animal(b) = repmat({aLetter},length(lDif),1);
                tUpper.Electrode(b) = repmat({[el]},length(lDif),1);
                tUpper.ElectrodeA(b) = repmat({[el,aLetter]},length(lDif),1);
                tUpper.EyeV(b) = repmat({'NA'},length(lDif),1);
                tUpper.ECAP(b2) = num2cell(t2);
                tUpper.EyeVnorm(b) = repmat({'NA'},length(lDif),1);
                tUpper.ECAPnorm(b) = repmat({'NA'},length(lDif),1);
                toExpAll = [tUpper;tLower];
        else
        b = tInds(1):tInds(length(t2));
        toExpAll.ECAP(b) = num2cell(t2);
        end
        
        tInds = find(contains(toExpMean.Electrode2,el));
        toExpMean.ECAPmean(tInds) = {mean(t2)};
end
notNaN = ~strcmp(toExpAll.EyeV,'NA');
eMin = min([cell2mat(toExpAll.EyeV(notNaN))]);
toExpAll.EyeVnorm(notNaN) = num2cell([cell2mat(toExpAll.EyeV(notNaN))]-eMin);
notNaN = ~strcmp(toExpAll.ECAP,'NA');
ecapMin = min([cell2mat(toExpAll.ECAP(notNaN))]);
toExpAll.ECAPnorm(notNaN) = num2cell([cell2mat(toExpAll.ECAP(notNaN))]-ecapMin);

notNaN = ~strcmp(toExpMean.EyeVmean,'NA');
eMin = min([cell2mat(toExpMean.EyeVmean(notNaN))]);
toExpMean.EyeVnormmean(notNaN) = num2cell([cell2mat(toExpMean.EyeVmean(notNaN))]-eMin);
notNaN = ~strcmp(toExpMean.ECAPmean,'NA');
ecapMin = min([cell2mat(toExpMean.ECAPmean(notNaN))]);
toExpMean.ECAPnormmean(notNaN) = num2cell([cell2mat(toExpMean.ECAPmean(notNaN))]-ecapMin);
assignin('base',teAllName,toExpAll);
assignin('base',teMeanName,toExpMean);
writetable(eval(teAllName),[add,'exportedEyeV-100uaECAP-500cu-All.csv']);
writetable(eval(teMeanName),[add,'exportedEyeV-100uaECAP-500cu-Mean.csv']);
end
%% TO PLOT ALL ELECTRODE COMBINATIONS BOTH EYE VELOCITY AND ECAP
Letter = {'G', 'D', 'F'};
velEcap(1).cur = struct();
D = struct();
allPd = [];
for q = 1:3
aLetter = Letter{q};
velEcap(q).cur = figure('units','normalized','outerposition',[0 0 1 1]);
sgtitle(velEcap(q).cur,{['Stimulus Current vs. Eye Velocity Magnitude and eCAP, Animal ',aLetter]},'FontSize', 22, 'FontWeight', 'Bold');
switch aLetter
    case 'G'
        dd = load('R:\Dai\Research\Monkey paper 10 reference electrodes\Monkey paper 10 reference electrodes\Figures\data\2010-11-05 RhGigi-electrode characterization and location test\Cycles\CycleParams.mat');
        path = 'R:\Morris, Brian\Papers\ECAP Paper\GiGi Data\ECAP Data\';
        name = 'GiGiCondensedECAPData.mat';
        add = [path,'GiGi'];
        tp = 8;
        col = [0 1 0];
    case 'D'
        dd = load('R:\Morris, Brian\Condensed Dai Data\2010-11-04 RhDidi-electrode characterization and location test\Cycles\CycleParams.mat');
        path = 'R:\Morris, Brian\Condensed Dai Data\2010-11-04 RhDidi-electrode characterization and location test\MAESTRO\';
        name = 'DidiCondensedECAPData.mat';
        add = [path,'DiDi'];
        tp = 9;
        col = [0 0 1];
    case 'F'
        dd = load('R:\Morris, Brian\Condensed Dai Data\2011-05-25-RhFred Electrode characterization\For ECAP Paper\cycles\CycleParams.mat');
        path = 'R:\Morris, Brian\Condensed Dai Data\Fred Pre-Post Revision ECAP Analysis\Post revision - Post surgery\';
        name = 'Fred-PostRevision-CondensedECAPData.mat';
        add = [path,'Fred'];
        tp = 9;
        col = [1 0 0];
end

load([path,name])
% Plot Velocity First
toExpAll = table({NaN},{NaN},{NaN},{NaN},{NaN},{NaN},{NaN},'VariableNames',{'Animal','Electrode','ElectrodeA','EyeV','ECAP','EyeVnorm','ECAPnorm'});
toExpMean = table({NaN},{NaN},{NaN},{NaN},{NaN},{NaN},{NaN},'VariableNames',{'Animal2','Electrode2','ElectrodeA2','EyeVmean','ECAPmean','EyeVnormmean','ECAPnormmean'});

fs = fields(extractedData.plots);
axs = struct();

ax = struct();
ax(2).v = [];
ax(3).v = [];
plots = struct();
d = [{'dd'}];%{'g620'},{'g621'},{'g624'},{'g626'},{'g628'}];
tot = 1;
x = [];
x2 = [];
y = [];
y2 = [];
ldgLARP =[];
ldgRALP =[];
ldgLHRH =[];
extractData = struct();
extractData.LARP = [];
extractData.RALP = [];
extractData.LHRH = [];
exM = [];
exS = [];
minNumCycV = 0;
minNumCycE = 0;
maxNumCycV = 0;
maxNumCycE = 0;
es = 1;
for i = 1:length(d)
    idNum = 1;
    for j = 1:length(getfield(eval(d{i}),'tempS'))
%         c1 = [0.6 0.6 0.6];
%         c2 = [0.3 0.3 0.3];
%         c3 = [0 0 0];
            c3 = [0 0 0];
            c2 = [0 0 0];
            c1 = [0 0 0];
            mkSIZE = 8;
        switch getfield(eval(d{i}),'tempS',{j},'stim')
            case 1
                %ca = [255 166 158];
                %Color = [ca]/255;
                Color = c1;
                mk = 'd'; 
                f = 'stim1ref2';
                el = 'stim1';
                ldgName = 'Stimulating Electrode, Shallow';%'Stimulating Electrode Posterior, Shallow';
                a = 1;
                c = [1 0 0];
            shift = -200;
            case 2
                %Color = [72 169 60]/255;
                Color = c2;
                mk = 'o';
                f = 'stim2ref1';
                el = 'stim2';
                ldgName = 'Stimulating Electrode, Middle';%'Stimulating Electrode Posterior, Middle';
                a = 1;
                c = [0 1 0];
            shift = 200;
            case 3
                %cw = [104 78 50];
                %Color = [cw]/255;
                Color = c3;
                mk = '>';
                f = 'stim3ref2';
                el = 'stim3';
                ldgName = 'Stimulating Electrode, Deep';%'Stimulating Electrode Posterior, Deep';
                a = 1;
                c = [0 0 1];
            shift = 0;
            case 4
                %Color = [13 0 164]/255;
                Color = c1;
                mk = 'X';
                f = 'stim4ref5';
                el = 'stim4';
                ldgName = 'Stimulating Electrode, Shallow';%'Stimulating Electrode Anterior, Shallow';
                a = 2;
                c = [1 0 0];
            shift = -200;
            case 5
                %cy=   [255 196 61];
                %Color = [cy]/255;
                Color = c2;
                mk =  'p';
                f = 'stim5ref4';
                el = 'stim5';
                ldgName = 'Stimulating Electrode, Middle';%'Stimulating Electrode Anterior, Middle';
                a = 2;
                c = [0 1 0];
            shift = 200;
            case 6
                %Color = [3 157 201]/255;
                Color = c3;
                mk = 'v';
                f = 'stim6ref5';
                el = 'stim6';
                ldgName = 'Stimulating Electrode, Deep';%'Stimulating Electrode Anterior, Deep';
                a = 2;
                c = [0 0 1];
            shift = 0;
            case 7
                %Color = [215 38 56]/255;
                Color = c3;
                mk =  '<';
                f = 'stim7ref8';
                el = 'stim7';
                ldgName = 'Stimulating Electrode, Deep';%'Stimulating Electrode Horizontal, Deep';
                a = 3;
                c = [0 0 1];
            shift = -200;
            case 8
                %cx = [183 184 104];
                %Color = [cx]/255;
                Color = c2;
                mk = 's';
                f = 'stim8ref7';
                el = 'stim8';
                ldgName = 'Stimulating Electrode, Middle';%'Stimulating Electrode Horizontal, Middle';
                a = 3;
                c = [0 1 0];
            shift = 200;
            case 9
                %Color = [219 108 35]/255;
                Color = c1;
                mk = '^';
                f = 'stim9ref8';
                el = 'stim9';
                ldgName = 'Stimulating Electrode, Shallow';%'Stimulating Electrode Horizontal, Shallow';
                a = 3;
                c = [1 0 0];
            shift = 0;
            case 10
                Color = [57 61 63]/255;
            case 11
                c = [128 147 241];
                Color = [c]/255;
        end
        
        if minNumCycV == 0
            minNumCycV = length([getfield(eval(d{i}),'tempS',{j},'MagRF')]);
        else
            minNumCycV = min([minNumCycV length([getfield(eval(d{i}),'tempS',{j},'MagRF')])]);
        end
        maxNumCycV = max([maxNumCycV length([getfield(eval(d{i}),'tempS',{j},'MagRF')])]);
        
        if strcmp(getfield(eval(d{i}),'tempS',{j},'dir'),'RALP')
            if isempty(ax(1).v)
                
                ax(1).v = subtightplot(2,3,1,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', velEcap(q).cur);
                ax(1).v.LineWidth = 2.5;
                ax(1).v.XGrid = 'on';
                ax(1).v.YGrid = 'on';
                ax(1).v.FontSize = 12;
                ax(1).v.XLabel.String = {'Current (uA)'};
                ax(1).v.XLabel.FontSize = 22;
                ax(1).v.YLabel.String = {'Velocity (dps)'};
                ax(1).v.YLabel.FontSize = 22;
                ax(1).v.XLim = [0 200+10];
                ax(1).v.XTick = [0:20:200];
                ax(1).v.Title.String = 'RALP';
                
            else
                set([ax(1).v],'Layer','Top');
            end
            x = [x str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'))];
            
            y = [y mean([getfield(eval(d{i}),'tempS',{j},'MagRF')])];
            y2 = [y2 [getfield(eval(d{i}),'tempS',{j},'MagRF')]];
            ly2 = length([getfield(eval(d{i}),'tempS',{j},'MagRF')]);
            x2 = [x2 repmat(str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'))*getfield(eval(d{i}),'tempS',{j},'p1d'),1,ly2)];
            e = ['e',num2str(getfield(eval(d{i}),'tempS',{j},'stim'))];
            %if str2num(getfield(eval(d{i}),'tempS',{j},'p1amp')) == 120
                extractData.RALP.(e)(idNum).amp = str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'));
                extractData.RALP.(e)(idNum).v = mean([getfield(eval(d{i}),'tempS',{j},'MagRF')]);
                extractData.RALP.(e)(idNum).sd = std([getfield(eval(d{i}),'tempS',{j},'MagRF')]);
                 [a,b] = max(abs([getfield(eval(d{i}),'tempS',{j},'M3DRF')]));
                extractData.RALP.(e)(idNum).v3d = [getfield(eval(d{i}),'tempS',{j},'M3DRF',{b(1),1}) getfield(eval(d{i}),'tempS',{j},'M3DRF',{b(2),2}) getfield(eval(d{i}),'tempS',{j},'M3DRF',{b(3),3})];
                
                
            %end
            hold(ax(1).v,'on')
            %plots.vP(tot) = plot(ax(1).v,str2num(getfield(eval(d{i}),'tempS',{j},'p1amp')),mean([getfield(eval(d{i}),'tempS',{j},'MagRF')]),'color',Color,'LineWidth',3,'marker',mk,'MarkerSize',9);
            plots.vPEB(tot) = errorbar(ax(1).v,str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'))+shift/400,mean([getfield(eval(d{i}),'tempS',{j},'MagRF')]),std([getfield(eval(d{i}),'tempS',{j},'MagRF')]),'color','k','LineWidth',2);
            if str2num(getfield(eval(d{i}),'tempS',{j},'p1amp')) == 100
                extractedData.plots.(f).eyeVel = mean([getfield(eval(d{i}),'tempS',{j},'MagRF')]);
                extractedData.plots.(f).eyeVelSTD = std([getfield(eval(d{i}),'tempS',{j},'MagRF')]);
            end
            tot = tot +1;
            if j<length(getfield(eval(d{i}),'tempS'))
                if getfield(eval(d{i}),'tempS',{j},'stim')~=getfield(eval(d{i}),'tempS',{j+1},'stim')
                    ldgRALP = [ldgRALP, {ldgName}];%[ldgRALP, {['Stim ',num2str(getfield(eval(d{i}),'tempS',{j},'stim'))]}];
                    plots.vPLRALP(length(ldgRALP)) = line(ax(1).v,x,y,'color',c,'LineWidth',2,'marker',mk,'MarkerSize',mkSIZE);
                    %plots.vR(length(ldgRALP)) = {ns};
                    extractedData.plots.(f).all.v = y2;
                    extractedData.plots.(f).all.vAmp = x2;
                    D = setfield(D,aLetter,{es},'Electrode',el);
                    D = setfield(D,aLetter,{es},'XV',x);
                    D = setfield(D,aLetter,{es},'YV',y);
                    D = setfield(D,aLetter,{es},'depth',ldgName);
                    es = es+1;
                    x2 = [];
                    y2 = [];
                    x = [];
                    y = [];
                    idNum = 1;
                else
                    idNum = idNum + 1;
                end
            elseif (j==length(getfield(eval(d{i}),'tempS')))
                ldgRALP = [ldgRALP, {ldgName}];%[ldgRALP, {['Stim ',num2str(getfield(eval(d{i}),'tempS',{j},'stim'))]}];
                plots.vPLRALP(length(ldgRALP)) = line(ax(1).v,x,y,'color',c,'LineWidth',2,'marker',mk,'MarkerSize',mkSIZE);
                    %plots.vR(length(ldgRALP)) = {ns};
                    extractedData.plots.(f).all.v = y2;
                    extractedData.plots.(f).all.vAmp = x2;
                    D = setfield(D,aLetter,{es},'Electrode',el);
                    D = setfield(D,aLetter,{es},'XV',x);
                    D = setfield(D,aLetter,{es},'YV',y);
                    D = setfield(D,aLetter,{es},'depth',ldgName);
                    es = es+1;
                    x2 = [];
                    y2 = [];
                        x = [];
                        y = [];
            end
            hold(ax(1).v,'off')
            
        elseif strcmp(getfield(eval(d{i}),'tempS',{j},'dir'),'LARP')
            if isempty(ax(2).v)
                ax(2).v = subtightplot(2,3,2,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', velEcap(q).cur);
                ax(2).v.LineWidth = 2.5;
                ax(2).v.XGrid = 'on';
                ax(2).v.YGrid = 'on';
                ax(2).v.FontSize = 12;
                ax(2).v.XLabel.String = {'Current (uA)'};
                ax(2).v.XLabel.FontSize = 22;
                ax(2).v.XLim = [0 200+10];
                ax(2).v.XTick = [0:20:200];
                ax(2).v.YTickLabel = [];
                ax(2).v.Title.String = 'LARP';
                
            else
                set([ax(2).v],'Layer','Top');
            end
            x = [x str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'))];
            y = [y mean([getfield(eval(d{i}),'tempS',{j},'MagRF')])];
            y2 = [y2 [getfield(eval(d{i}),'tempS',{j},'MagRF')]];
            ly2 = length([getfield(eval(d{i}),'tempS',{j},'MagRF')]);
            x2 = [x2 repmat(str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'))*getfield(eval(d{i}),'tempS',{j},'p1d'),1,ly2)];
            
            %if str2num(getfield(eval(d{i}),'tempS',{j},'p1amp')) == 120
                e = ['e',num2str(getfield(eval(d{i}),'tempS',{j},'stim'))];
                extractData.LARP.(e)(idNum).amp = str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'));
                extractData.LARP.(e)(idNum).v = mean([getfield(eval(d{i}),'tempS',{j},'MagRF')]);
                extractData.LARP.(e)(idNum).sd = std([getfield(eval(d{i}),'tempS',{j},'MagRF')]);
                 [a,b] = max(abs([getfield(eval(d{i}),'tempS',{j},'M3DRF')]));
                extractData.LARP.(e)(idNum).v3d = [getfield(eval(d{i}),'tempS',{j},'M3DRF',{b(1),1}) getfield(eval(d{i}),'tempS',{j},'M3DRF',{b(2),2}) getfield(eval(d{i}),'tempS',{j},'M3DRF',{b(3),3})];

                
            %end
            hold(ax(2).v,'on')
            %plots.vP(tot) = plot(ax(2).v,str2num(getfield(eval(d{i}),'tempS',{j},'p1amp')),mean([getfield(eval(d{i}),'tempS',{j},'MagRF')]),'color',Color,'LineWidth',3,'marker',mk,'MarkerSize',9);
            plots.vPEB(tot) = errorbar(ax(2).v,str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'))+shift/400,mean([getfield(eval(d{i}),'tempS',{j},'MagRF')]),std([getfield(eval(d{i}),'tempS',{j},'MagRF')]),'color','k','LineWidth',2);
            if str2num(getfield(eval(d{i}),'tempS',{j},'p1amp')) == 100
                     extractedData.plots.(f).eyeVel = mean([getfield(eval(d{i}),'tempS',{j},'MagRF')]);
                extractedData.plots.(f).eyeVelSTD = std([getfield(eval(d{i}),'tempS',{j},'MagRF')]);
            end
            tot = tot +1;
            if getfield(eval(d{i}),'tempS',{j},'stim') == 4
                mkSIZE = 15;
            end
            if j<length(getfield(eval(d{i}),'tempS'))
                if getfield(eval(d{i}),'tempS',{j},'stim')~=getfield(eval(d{i}),'tempS',{j+1},'stim')
                    ldgLARP = [ldgLARP, {ldgName}];%[ldgLARP, {['Stim ',num2str(getfield(eval(d{i}),'tempS',{j},'stim'))]}];
                    plots.vPLLARP(length(ldgLARP)) = line(ax(2).v,x,y,'color',c,'LineWidth',2,'marker',mk,'MarkerSize',mkSIZE);
                    %plots.vL(length(ldgLARP)) = {ns};
                    extractedData.plots.(f).all.v = y2;
                    extractedData.plots.(f).all.vAmp = x2;
                    D = setfield(D,aLetter,{es},'Electrode',el);
                    D = setfield(D,aLetter,{es},'XV',x);
                    D = setfield(D,aLetter,{es},'YV',y);
                    D = setfield(D,aLetter,{es},'depth',ldgName);
                    es = es+1;
                    x2 = [];
                    y2 = [];
                    x = [];
                    y = [];
                    idNum = 1;
                else
                    idNum = idNum +1;
                end
            elseif (j==length(getfield(eval(d{i}),'tempS')))
                ldgLARP = [ldgLARP, {ldgName}];%[ldgLARP, {['Stim ',num2str(getfield(eval(d{i}),'tempS',{j},'stim'))]}];
                plots.vPLLARP(length(ldgLARP)) = line(ax(2).v,x,y,'color',c,'LineWidth',2,'marker',mk,'MarkerSize',mkSIZE);
                    %plots.vL(length(ldgLARP)) = {ns};
                    extractedData.plots.(f).all.v = y2;
                    extractedData.plots.(f).all.vAmp = x2;
                    D = setfield(D,aLetter,{es},'Electrode',el);
                    D = setfield(D,aLetter,{es},'XV',x);
                    D = setfield(D,aLetter,{es},'YV',y);
                    D = setfield(D,aLetter,{es},'depth',ldgName);
                    es = es+1;
                    x2 = [];
                    y2 = [];
                x = [];
                y = [];
            end
            hold(ax(2).v,'off')
        elseif strcmp(getfield(eval(d{i}),'tempS',{j},'dir'),'LHRH')
            if isempty(ax(3).v)
                ax(3).v = subtightplot(2,3,3,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', velEcap(q).cur);
                ax(3).v.LineWidth = 2.5;
                ax(3).v.XGrid = 'on';
                ax(3).v.YGrid = 'on';
                ax(3).v.FontSize = 12;
                ax(3).v.XLabel.String = {'Current (uA)'};
                ax(3).v.XLabel.FontSize = 22;
                ax(3).v.XLim = [0 200+10];
                ax(3).v.XTick = [0:20:200];
                ax(3).v.YTickLabel = [];
                ax(3).v.Title.String = 'LHRH';
            else
                set([ax(3).v],'Layer','Top');
            end
            x = [x str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'))];
            y = [y mean([getfield(eval(d{i}),'tempS',{j},'MagRF')])];
            y2 = [y2 [getfield(eval(d{i}),'tempS',{j},'MagRF')]];
            ly2 = length([getfield(eval(d{i}),'tempS',{j},'MagRF')]);
            x2 = [x2 repmat(str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'))*getfield(eval(d{i}),'tempS',{j},'p1d'),1,ly2)];
            
            %if str2num(getfield(eval(d{i}),'tempS',{j},'p1amp')) == 120
                e = ['e',num2str(getfield(eval(d{i}),'tempS',{j},'stim'))];
                extractData.LHRH.(e)(idNum).amp = str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'));
                extractData.LHRH.(e)(idNum).v = mean([getfield(eval(d{i}),'tempS',{j},'MagRF')]);
                extractData.LHRH.(e)(idNum).sd = std([getfield(eval(d{i}),'tempS',{j},'MagRF')]);
                 [a,b] = max(abs([getfield(eval(d{i}),'tempS',{j},'M3DRF')]));
                extractData.LHRH.(e)(idNum).v3d = [getfield(eval(d{i}),'tempS',{j},'M3DRF',{b(1),1}) getfield(eval(d{i}),'tempS',{j},'M3DRF',{b(2),2}) getfield(eval(d{i}),'tempS',{j},'M3DRF',{b(3),3})];

            %end
            hold(ax(3).v,'on')
            %plots.vP(tot) = plot(ax(3).v,str2num(getfield(eval(d{i}),'tempS',{j},'p1amp')),mean([getfield(eval(d{i}),'tempS',{j},'MagRF')]),'color',Color,'LineWidth',2,'marker',mk,'MarkerSize',9);
            plots.vPEB(tot) = errorbar(ax(3).v,str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'))+shift/400,mean([getfield(eval(d{i}),'tempS',{j},'MagRF')]),std([getfield(eval(d{i}),'tempS',{j},'MagRF')]),'color','k','LineWidth',2);
            if str2num(getfield(eval(d{i}),'tempS',{j},'p1amp')) == 100
                extractedData.plots.(f).eyeVel = mean([getfield(eval(d{i}),'tempS',{j},'MagRF')]);
                extractedData.plots.(f).eyeVelSTD = std([getfield(eval(d{i}),'tempS',{j},'MagRF')]);
            end
            tot = tot +1;
            if j<length(getfield(eval(d{i}),'tempS'))
                if getfield(eval(d{i}),'tempS',{j},'stim')~=getfield(eval(d{i}),'tempS',{j+1},'stim')
                    ldgLHRH = [ldgLHRH, {ldgName}];%[ldgLHRH, {['Stim ',num2str(getfield(eval(d{i}),'tempS',{j},'stim'))]}];
                    plots.vPLLHRH(length(ldgLHRH)) = line(ax(3).v,x,y,'color',c,'LineWidth',2,'marker',mk,'MarkerSize',mkSIZE);
                    %plots.vZ(length(ldgLHRH)) = {ns};
                    extractedData.plots.(f).all.v = y2;
                    extractedData.plots.(f).all.vAmp = x2;
                    D = setfield(D,aLetter,{es},'Electrode',el);
                    D = setfield(D,aLetter,{es},'XV',x);
                    D = setfield(D,aLetter,{es},'YV',y);
                    D = setfield(D,aLetter,{es},'depth',ldgName);
                    es = es+1;
                    x2 = [];
                    y2 = [];
                    x = [];
                    y = [];
                    idNum = 1;
                else
                    idNum = idNum +1;
                end
            elseif (j==length(getfield(eval(d{i}),'tempS')))
                ldgLHRH = [ldgLHRH, {ldgName}];%[ldgLHRH, {['Stim ',num2str(getfield(eval(d{i}),'tempS',{j},'stim'))]}];
                plots.vPLLHRH(length(ldgLHRH)) = line(ax(3).v,x,y,'color',c,'LineWidth',2,'marker',mk,'MarkerSize',mkSIZE);
                    %plots.vZ(length(ldgLHRH)) = {ns};
                    D = setfield(D,aLetter,{es},'Electrode',el);
                    D = setfield(D,aLetter,{es},'XV',x);
                    D = setfield(D,aLetter,{es},'YV',y);
                    D = setfield(D,aLetter,{es},'depth',ldgName);
                    es = es+1;
                x = [];
                y = [];
            end
            hold(ax(3).v,'off')
        end

    end
    if i == length(d)
        lR = legend(ax(1).v,[plots.vPLRALP],[ldgRALP]);
        lR.Position = [0.0703    0.8471    0.13    0.0583];
        lL = legend(ax(2).v,[plots.vPLLARP],[ldgLARP]);  
        lL.Position = [0.3688    0.8471    0.13    0.0583];
        lZ = legend(ax(3).v,flip([plots.vPLLHRH]),flip([ldgLHRH]));  
        lZ.Position = [0.6696    0.8471    0.13    0.0583];
        sameaxes([],[ax(1).v ax(2).v ax(3).v])
        uistack(ax(2).v, 'top')
        uistack(ax(3).v, 'top')
        
    end
end

ax(4).v = [];
ax(5).v = [];
ax(6).v = [];
x = [];
y = [];
x2 = [];
y2 = [];
ldgLARP =[];
ldgRALP =[];
ldgLHRH =[];
ecapM = [];
ecapS = [];
tot = 1;
fs = fields(extractedData.plots);
currToPull = 7;
for h = 1:tp
%     c1 = [0.6 0.6 0.6];
%         c2 = [0.3 0.3 0.3];
%         c3 = [0 0 0];
            c1 = [1 0 0];
        c2 = [0 1 0];
        c3 = [0 0 1];
        mkSIZE = 8;
    switch fs{h}
        case 'stim1ref2'
%             ca = [255 166 158];
%             Color = [ca]/255;
            Color = c1;
            mk = 'd';
            el = 'stim1';
            num = '1';
            shift = 3;
            if isempty(ax(4).v)
                ax(4).v = subtightplot(2,3,4,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', velEcap(q).cur);
                ax(4).v.LineWidth = 2.5;
                ax(4).v.XGrid = 'on';
                ax(4).v.YGrid = 'on';
                ax(4).v.FontSize = 12;
                ax(4).v.XLabel.String = {'Current (cu)'};
                ax(4).v.XLabel.FontSize = 22;
                ax(4).v.YLabel.String = {'eCAP (uV)'};
                ax(4).v.YLabel.FontSize = 22;
                ax(4).v.XLim = [0 750+50];
                ax(4).v.XTick = [0:50:750];
                ax(4).v.Position = [ax(4).v.Position(1) 0.06 ax(4).v.Position(3) ax(4).v.Position(4)]; 
                a = ax(4).v;
                
            else
                set([ax(4).v],'Layer','Top');
                a = ax(4).v;
            end
            
        case 'stim2ref1'
%             Color = [72 169 60]/255;
            Color = c2;
            mk = 'o';
            el = 'stim2';
            num = '2';
            shift = -3;
            if isempty(ax(4).v)
                ax(4).v = subtightplot(2,3,4,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', velEcap(q).cur);
                ax(4).v.LineWidth = 2.5;
                ax(4).v.XGrid = 'on';
                ax(4).v.YGrid = 'on';
                ax(4).v.XLabel.String = {'Current (cu)'};
                ax(4).v.XLabel.FontSize = 22;
                ax(4).v.YLabel.String = {'eCAP (uV)'};
                ax(4).v.YLabel.FontSize = 22;
                ax(4).v.XLim = [0 750+50];
                ax(4).v.XTick = [0:50:750];
                ax(4).v.Position = [ax(4).v.Position(1) 0.06 ax(4).v.Position(3) ax(4).v.Position(4)];
                a = ax(4).v;
            else
                set([ax(4).v],'Layer','Top');
                a = ax(4).v;
            end
        case 'stim3ref2'
%             cw = [104 78 50];
%             Color = [cw]/255;
            Color = c3;
            mk = '>';
            el = 'stim3';
            num = '3';
            shift = 0;
            if isempty(ax(4).v)
                ax(4).v = subtightplot(2,3,4,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', velEcap(q).cur);
                ax(4).v.LineWidth = 2.5;
                ax(4).v.XGrid = 'on';
                ax(4).v.YGrid = 'on';
                ax(4).v.XLabel.String = {'Current (cu)'};
                ax(4).v.XLabel.FontSize = 22;
                ax(4).v.YLabel.String = {'eCAP (uV)'};
                ax(4).v.YLabel.FontSize = 22;
                ax(4).v.XLim = [0 750+50];
                ax(4).v.XTick = [0:50:750];
                ax(4).v.Position = [ax(4).v.Position(1) 0.06 ax(4).v.Position(3) ax(4).v.Position(4)];
                a = ax(4).v;
            else
                set([ax(4).v],'Layer','Top');
                a = ax(4).v;
            end
        case 'stim4ref5'
%             Color = [13 0 164]/255;
            Color = c1;
            mk = 'X';
            el = 'stim4';
            num = '4';
            mkSIZE = 15;
            shift = 3;
            if isempty(ax(5).v)
                ax(5).v = subtightplot(2,3,5,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', velEcap(q).cur);
                ax(5).v.LineWidth = 2.5;
                ax(5).v.XGrid = 'on';
                ax(5).v.YGrid = 'on';
                ax(5).v.FontSize = 12;
                ax(5).v.XLabel.String = {'Current (cu)'};
                ax(5).v.XLabel.FontSize = 22;
                ax(5).v.XLim = [0 750+50];
                ax(5).v.XTick = [0:50:750];
                ax(5).v.YTickLabel = [];
                ax(5).v.Position = [ax(5).v.Position(1) 0.06 ax(5).v.Position(3) ax(5).v.Position(4)];
                a = ax(5).v;
            else
                set([ax(5).v],'Layer','Top');
                a = ax(5).v;
            end
        case 'stim5ref4'
%             cy=   [255 196 61];
%             Color = [cy]/255;
            Color = c2;
            mk = 'p';
            el = 'stim5';
            num = '5';
            shift = -3;
            if isempty(ax(5).v)
                ax(5).v = subtightplot(2,3,5,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', velEcap(q).cur);
                ax(5).v.LineWidth = 2.5;
                ax(5).v.XGrid = 'on';
                ax(5).v.YGrid = 'on';
                ax(5).v.XLabel.String = {'Current (cu)'};
                ax(5).v.XLabel.FontSize = 22;
                ax(5).v.XLim = [0 750+50];
                ax(5).v.XTick = [0:50:750];
                ax(5).v.YTickLabel = [];
                ax(5).v.Position = [ax(5).v.Position(1) 0.06 ax(5).v.Position(3) ax(5).v.Position(4)];
                a = ax(5).v;
            else
                set([ax(5).v],'Layer','Top');
                a = ax(5).v;
            end
        case 'stim6ref5'
%             Color = [3 157 201]/255;
            Color = c3;
            mk = 'v';
            el = 'stim6';
            num = '6';
            shift = 0;
            if isempty(ax(5).v)
                ax(5).v = subtightplot(2,3,5,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', velEcap(q).cur);
                ax(5).v.LineWidth = 2.5;
                ax(5).v.XGrid = 'on';
                ax(5).v.YGrid = 'on';
                ax(5).v.XLabel.String = {'Current (cu)'};
                ax(5).v.XLabel.FontSize = 22;
                ax(5).v.XLim = [0 750+50];
                ax(5).v.XTick = [0:50:750];
                ax(5).v.YTickLabel = [];
                ax(5).v.Position = [ax(5).v.Position(1) 0.06 ax(5).v.Position(3) ax(5).v.Position(4)];
                a = ax(5).v;
            else
                set([ax(5).v],'Layer','Top');
                a = ax(5).v;
            end
        case 'stim7ref8'
%             Color = [215 38 56]/255;
            Color = c3;
            mk = '<';
            el = 'stim7';
            num = '7';
            shift = 3;
            if isempty(ax(6).v)
                ax(6).v = subtightplot(2,3,6,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', velEcap(q).cur);
                ax(6).v.LineWidth = 2.5;
                ax(6).v.XGrid = 'on';
                ax(6).v.YGrid = 'on';
                ax(6).v.FontSize = 12;
                ax(6).v.XLabel.String = {'Current (cu)'};
                ax(6).v.XLabel.FontSize = 22;
                ax(6).v.XLim = [0 750+50];
                ax(6).v.XTick = [0:50:750];
                ax(6).v.YTickLabel = [];
                ax(6).v.Position = [ax(6).v.Position(1) 0.06 ax(6).v.Position(3) ax(6).v.Position(4)];
                a = ax(6).v;
            else
                set([ax(6).v],'Layer','Top');
                a = ax(6).v;
            end
        case 'stim8ref7'
%             cx = [183 184 104];
%             Color = [cx]/255;
            Color = c2;
            mk = 's';
            el = 'stim8';
            num = '8';
            shift = -3;
            if isempty(ax(6).v)
                ax(6).v = subtightplot(2,3,6,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', velEcap(q).cur);
                ax(6).v.LineWidth = 2.5;
                ax(6).v.XGrid = 'on';
                ax(6).v.YGrid = 'on';
                ax(6).v.XLabel.String = {'Current (cu)'};
                ax(6).v.XLabel.FontSize = 22;
                ax(6).v.XLim = [0 750+50];
                ax(6).v.XTick = [0:50:750];
                ax(6).v.YTickLabel = [];
                ax(6).v.Position = [ax(6).v.Position(1) 0.06 ax(6).v.Position(3) ax(6).v.Position(4)];
                a = ax(6).v;
            else
                set([ax(6).v],'Layer','Top');
                a = ax(6).v;
            end
        case 'stim9ref8'
            %             Color = [219 108 35]/255;
            Color = c1;
            mk = '^';
            el = 'stim9';
            num = '9';
            shift = 0;
            if isempty(ax(6).v)
                ax(6).v = subtightplot(2,3,6,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', velEcap(q).cur);
                ax(6).v.LineWidth = 2.5;
                ax(6).v.XGrid = 'on';
                ax(6).v.YGrid = 'on';
                ax(6).v.XLabel.String = {'Current (cu)'};
                ax(6).v.XLabel.FontSize = 22;
                ax(6).v.XLim = [0 750+50];
                ax(6).v.XTick = [0:50:750];
                ax(6).v.YTickLabel = [];
                ax(6).v.Position = [ax(6).v.Position(1) 0.06 ax(6).v.Position(3) ax(6).v.Position(4)];
                a = ax(6).v;
            else
                set([ax(6).v],'Layer','Top');
                a = ax(6).v;
            end
        case 10
            Color = [57 61 63]/255;
        case 11
            c = [128 147 241];
            Color = [c]/255;
    end
    
    
    if isfield(extractedData.plots.(fs{h}),'pextractTrustUse')
        toChg = find(~[extractedData.plots.(fs{h}).pextractTrustUse]);
        mTemp(toChg) = NaN;
    else
        mTemp = extractedData.plots.(fs{h}).pextract;
    end
    m = mean(mTemp,'omitnan');
    extractedData.plots.(fs{h}).mean = m;
    s = std([mTemp],'omitnan');
    extractedData.plots.(fs{h}).sd = s;
    x = extractedData.plots.(fs{h}).Amp;
    allPd = [allPd extractedData.plots.(fs{h}).all.eAmp(end)/750];
    extractedData.plots.(fs{h}).all.eAmp = [extractedData.plots.(fs{h}).ampCalc(~isnan(mTemp))'];
    extractedData.plots.(fs{h}).all.e = [mTemp(~isnan(mTemp))'];
    hold(a,'on')
    
    %plot(a,x,m,'color',Color,'marker','o','MarkerSize',10,'LineWidth',2);
    errorbar(a,x+shift,m,s,'color','k','LineWidth',2,'LineStyle','none');%,'marker','o','MarkerSize',10)
    plots.eP(tot) = line(a,x,m,'color',Color,'LineWidth',2,'marker',mk,'MarkerSize',mkSIZE);
    es = find(ismember({D.(aLetter).Electrode},el));
    D = setfield(D,aLetter,{es},'XE',x);
    D = setfield(D,aLetter,{es},'YE',m);


    tot = tot +1;
    hold(a,'off')
    if minNumCycE == 0
        minNumCycE = min([sum(~isnan(mTemp))]);
    else
        minNumCycE = min([minNumCycE min([sum(~isnan(mTemp))])]);
    end
    maxNumCycE = max([maxNumCycE max([sum(~isnan(mTemp))])]);
        
end

sameaxes([],[ax(4).v ax(5).v ax(6).v])
ax(4).v.YLim = [0 800];
ax(5).v.YLim = [0 800]; 
ax(6).v.YLim = [0 800];
% save([path,name],'extractedData')
% saveas(velEcap(q).cur,[add,'currentVsEyeVelocity_currentVsECAP.svg']);
% saveas(velEcap(q).cur,[add,'currentVsEyeVelocity_currentVsECAP.jpg']);
% saveas(velEcap(q).cur,[add,'currentVsEyeVelocity_currentVsECAP.fig']);
end
%%
fse = length(D.G);
xVP = unique([D.G(6:8).XV]);
xVA = unique([D.G(1:3).XV]);
xVH = unique([D.G(4:5).XV]);
xEP = unique([D.G(6:8).XE]);
xEA = unique([D.G(1:3).XE]);
xEH = unique([D.G(4:5).XE]);
aV =[];
pV =[];
hV =[];
aE =[];
pE =[];
hE =[];
vPos = 1;
ePos = 1;
p=0;
a=0;
h=0;
    for i = 1:fse
        switch D.G(i).Electrode
            case {'stim1' 'stim2' 'stim3'}
                can='p';
                p=p+1;
                num = p;
                lV = xVP;
                lE = xEP;
                pV = [pV;lV];
                sameV = ismember(lV,[D.G(i).XV]);
                pV(num,sameV) = [D.G(i).YV];
                pV(num,~sameV) = NaN;
                
                pE = [pE;lE];
                sameE = ismember(lE,[D.G(i).XE]);
                pE(num,sameE) = [D.G(i).YE];
                pE(num,~sameE) = NaN;
            case {'stim4' 'stim5' 'stim6'}
                can='a';
               a=a+1;
               num = a;
               lV = xVA;
               lE = xEA;
               aV = [aV;lV];
                sameV = ismember(lV,[D.G(i).XV]);
                aV(num,sameV) = [D.G(i).YV];
                aV(num,~sameV) = NaN;
                
                aE = [aE;lE];
                sameE = ismember(lE,[D.G(i).XE]);
                aE(num,sameE) = [D.G(i).YE];
                aE(num,~sameE) = NaN;
            case {'stim7' 'stim8' 'stim9'}
                can='h';
                h=h+1;
                num = h;
                lV = xVH;
                lE = xEH;
                
                hV = [hV;lV];
                sameV = ismember(lV,[D.G(i).XV]);
                hV(num,sameV) = [D.G(i).YV];
                hV(num,~sameV) = NaN;
                
                hE = [hE;lE];
                sameE = ismember(lE,[D.G(i).XE]);
                hE(num,sameE) = [D.G(i).YE];
                hE(num,~sameE) = NaN;
        end
        
    end
rmvVa = sum(isnan(aV))>0;
rmvVp = sum(isnan(pV))>0;
rmvVh = sum(isnan(hV))>0;
rmvEa = sum(isnan(aE))>0;
rmvEp = sum(isnan(pE))>0;
rmvEh = sum(isnan(hE))>0;

xVA(rmvVa) = [];
aV(:,rmvVa) = [];
xVP(rmvVp) = [];
pV(:,rmvVp) = [];
xVH(rmvVh) = [];
hV(:,rmvVh) = [];

xEA(rmvEa) = [];
aE(:,rmvEa) = [];
xEP(rmvEp) = [];
pE(:,rmvEp) = [];
xEH(rmvEh) = [];
hE(:,rmvEh) = [];

[~,q]=sort(aV,1);
orderVa=zeros(size(aV));
for i = 1:size(aV,2)
    orderVa(q(:,i),i) = [1:size(aV,1)]';
end

[~,q]=sort(pV,1);
orderVp=zeros(size(pV));
for i = 1:size(aV,2)
    orderVa(q(:,i),i) = [1:size(aV,1)]';
end
figure
plot(xV,orderV)
figure
plot(xE,orderE)
%%
Letter = {'G', 'D', 'F'};
ax2 = struct();
subG = [];
impPlots = [];
allData = struct();
allData.G.V = [];
allData.G.VM = [];
allData.G.VSD = [];
allData.G.E = [];
allData.G.EM = [];
allData.G.ESD = [];
allData.G.PTS = [];
allData.G.I = [];
allData.D.V = [];
allData.D.VM = [];
allData.D.VSD = [];
allData.D.E = [];
allData.D.EM = [];
allData.D.ESD = [];
allData.D.PTS = [];
allData.D.I = [];
allData.F.V = [];
allData.F.VM = [];
allData.F.VSD = [];
allData.F.E = [];
allData.F.EM = [];
allData.F.ESD = [];
allData.F.PTS = [];
allData.F.I = [];
allData.G.mk(1) = {''};
allData.D.mk(1) = {''};
allData.F.mk(1) = {''};
allData.G.mk2 = [];
allData.D.mk2 = [];
allData.F.mk2 = [];
velEcap = struct();
gridStat = 'off';
for j = 1:3
    aLetter = Letter{j};
    
velEcap(j).fig = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
sgtitle(velEcap(j).fig,{['Stimulus Charge vs. Eye Velocity Magnitude and eCAP, Animal ',aLetter]},'FontSize', 22, 'FontWeight', 'Bold');
switch aLetter
    case 'G'
        dd = load('R:\Dai\Research\Monkey paper 10 reference electrodes\Monkey paper 10 reference electrodes\Figures\data\2010-11-05 RhGigi-electrode characterization and location test\Cycles\CycleParams.mat');
        path = 'R:\Morris, Brian\Papers\ECAP Paper\GiGi Data\ECAP Data\';
        name = 'GiGiCondensedECAPData.mat';
        add = [path,'GiGi'];
        tp = 8;
        col = [0 1 0];
    case 'D'
        dd = load('R:\Morris, Brian\Condensed Dai Data\2010-11-04 RhDidi-electrode characterization and location test\Cycles\CycleParams.mat');
        path = 'R:\Morris, Brian\Condensed Dai Data\2010-11-04 RhDidi-electrode characterization and location test\MAESTRO\';
        name = 'DidiCondensedECAPData.mat';
        add = [path,'DiDi'];
        tp = 9;
        col = [0 0 1];
    case 'F'
        dd = load('R:\Morris, Brian\Condensed Dai Data\2011-05-25-RhFred Electrode characterization\For ECAP Paper\cycles\CycleParams.mat');
        path = 'R:\Morris, Brian\Condensed Dai Data\Fred Pre-Post Revision ECAP Analysis\Post revision - Post surgery\';
        name = 'Fred-PostRevision-CondensedECAPData.mat';
        add = [path,'Fred'];
        tp = 9;
        col = [1 0 0];
end

load([path,name])
fs = fields(extractedData.plots);
axs = struct();
impPlots = [];
impMk = [];
subG = [];
for i = 1:tp
    vAmpUn = unique(extractedData.plots.(fs{i}).all.vAmp);
    eAmpUn = round(unique(extractedData.plots.(fs{i}).all.eAmp));
    vAmp = ismember(vAmpUn,eAmpUn);
    eAmp = ismember(eAmpUn,vAmpUn);    
    for qt = 1:length(vAmpUn)
        if vAmpUn(qt)>max(eAmpUn)
            break
        end
        sp = find((abs(vAmpUn(qt)-eAmpUn)<=500));
        if vAmp(qt) == 0
            if isempty(sp)
            elseif length(sp)==1
                
                vAmp(qt) = 1;
                eAmp(sp) = 1;
            elseif length(sp)>1
                
                difs = abs(vAmpUn(qt)-eAmpUn);
                [p,o]=min(abs(vAmpUn(qt)-eAmpUn));
                comp = logical(ones(1,length(difs)));
                comp(o) = 0;
                if any(ismember(p,difs(comp)))
                else
                    vAmp(qt) = 1;
                    eAmp(o) = 1;
                end
            end
        end
    end
    switch i
        case {1, 2, 3}
            a = 1;
            t = 'LP';
        case {4, 5, 6}
            a = 2;
            t = 'LA';
        case {7, 8, 9}
            a = 3;
            t = 'LH';
    end
    switch i
        case 1
            mk = char(9680);%'d';
            c = [34 113 178]/255;
            shift = -200;
            ldgName = 'Shallow';
        case 2
            mk = char(9679);%'o';
            c = [53 155 115]/255;
            shift = 200;
            ldgName = 'Middle';
        case 3
            mk = char(9681);%'>';
            c = [213 94 0]/255;
            shift = 0;
            ldgName = 'Deep';
        case 4
            mk = char(9703);%'x';
            c = [34 113 178]/255;
            shift = -200;
            ldgName = 'Shallow';
        case 5
            mk = char(9632);%'p';
            c = [53 155 115]/255;
            shift = 200;
            ldgName = 'Middle';
        case 6
            mk = char(9704);%'v';
            c = [213 94 0]/255;
            shift = 0;
            ldgName = 'Deep';
        case 7
            mk = char(9710);%'<';
            c = [213 94 0]/255;
            shift = -200;
            ldgName = 'Deep';
        case 8
            mk = char(9650);%'s';
            c = [53 155 115]/255;
            shift = 200;
            ldgName = 'Middle';
        case 9
            mk = char(9709);%'^';
            c = [34 113 178]/255;
            shift = 0;
            ldgName = 'Shallow';
    end
    set(0,'CurrentFigure',velEcap(j).fig)
    axs(a).b = subtightplot(2,3,a,[0.025 0.000000000005],[0.10 0.075],[.05 .05]);
    axs(a).b.LineWidth = 2.5;
    axs(a).b.XGrid = gridStat;
    axs(a).b.YGrid = gridStat;
    axs(a).b.FontSize = 12;
    axs(a).b.XLabel.FontSize = 22;
    
    axs(a).b.XLim = [0 40000+1000];
    axs(a).b.XTick = [0:8000:40000];
    axs(a).b.XTickLabel = [];
    axs(a).b.YAxis.Color = [0.14 0.14 0.14];
    axs(a).b.XAxis.Color = [0.16 0.16 0.16];
    if a == 1
        axs(a).b.YLabel.String = {'Velocity (°/s)'};
        axs(a).b.YLabel.FontSize = 22;
    else
        axs(a).b.YTickLabel = [];
    end
    axs(a).b.Title.String = t;
    x = extractedData.plots.(fs{i}).all.vAmp;
    y = extractedData.plots.(fs{i}).all.v;
%      toPull = [20000];
    toPull = vAmpUn(vAmp);
    tempV = [];
    tempVM = [];
    tempVSD = [];
    tempI = [];
    for q = 1:length(toPull)
        impInd = ismember([x],toPull(q));
        tempV = [tempV {[y(impInd)];[x(impInd)]}];
        tempVM = [tempVM {mean([y(impInd)]);[unique(x(impInd))]}];
        tempVSD = [tempVSD {std([y(impInd)]);[unique(x(impInd))]}];
        tempI = [tempI i];
    end
    allData.(aLetter).V = [allData.(aLetter).V tempV];
    allData.(aLetter).VM = [allData.(aLetter).VM tempVM];
    allData.(aLetter).VSD = [allData.(aLetter).VSD tempVSD];
    allData.(aLetter).I = [allData.(aLetter).I tempI];
    
         [x,l]=sort(x);
     y = y(l);
    xU = unique(extractedData.plots.(fs{i}).all.vAmp);
yM = [];
ySD = [];
w = [];
for z = 1:length(xU)
    uI = find(ismember([x],xU(z)));
    yM = [yM mean(y(uI))];
    ySD = [ySD std(y(uI))];
    for z2 = 1:length(uI)
        w = [w (length(uI)/length(y))/sum(ismember(y(uI),y(uI(z2))))];
        
    end
end

    [xData, yData, weights] = prepareCurveData( x, y, w );
    
    % Set up fittype and options.
    ft = fittype( 'a+(-a/(1+exp((x-b)/c)))', 'independent', 'x', 'dependent', 'y' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.Robust = 'Bisquare';
    opts.Upper = [max(y)*1.5 Inf Inf];
    if (aLetter == 'F') && any(ismember([2 3 5 7],i))
        opts.StartPoint = [1 7000 5000];
    else
    opts.StartPoint = [1 7000 1000];
    end
    opts.Weights = weights;
    
    % Fit model to data.
    extractedData.plots.(fs{i}).all.vf = fit( xData, yData, ft, opts );
    
    hold(axs(a).b,'on')
    jitterAmt = randi([-400,400],1,length(extractedData.plots.(fs{i}).all.vAmp));
    text(extractedData.plots.(fs{i}).all.vAmp+jitterAmt,extractedData.plots.(fs{i}).all.v,mk,'FontSize',10,'Color',c,'HorizontalAlignment','center')
%     scatter(extractedData.plots.(fs{i}).all.vAmp,extractedData.plots.(fs{i}).all.v,40,c,mk,'jitter','on','jitterAmount',400)
    errorbar(xU+shift,yM,ySD,'Color','k','LineStyle','none','LineWidth',1.5)
    plot(xData,extractedData.plots.(fs{i}).all.vf(xData),'Color',c,'LineWidth',2)
%     if i == 4
%         mkSize2 = 13;
%     else
%         mkSize2 = 7;
%     end
    impPlots = [impPlots plot(NaN,NaN,'Color',c,'LineWidth',2)];%,'Marker',mk,'MarkerSize',mkSize2)];
    impMk = [impMk {mk}];
    subG = [subG {ldgName}];
    hold(axs(a).b,'off')
    
    
    axs(a+3).b = subtightplot(2,3,a+3,[0.025 0.000000000005],[0.10 0.075],[.05 .05]);
    axs(a+3).b.LineWidth = 2.5;
    axs(a+3).b.XGrid = gridStat;
    axs(a+3).b.YGrid = gridStat;
    axs(a+3).b.FontSize = 12;
    axs(a+3).b.XLabel.String = {'Charge (pC)'};
    axs(a+3).b.XLabel.FontSize = 22;
    
    axs(a+3).b.XLim = [0 40000+1000];
    axs(a+3).b.XTick = [0:8000:40000];
    axs(a+3).b.XAxis.Color = [0.13 0.13 0.13];
    axs(a+3).b.YAxis.Color = [0.17 0.17 0.17];
    if a == 1
        axs(a+3).b.YLabel.String = {'eCAP (µV)'};
        axs(a+3).b.YLabel.FontSize = 22;
    else
        axs(a+3).b.YTickLabel = [];
    end
    
    y = extractedData.plots.(fs{i}).all.e;
    x = extractedData.plots.(fs{i}).all.eAmp;
         [x,l]=sort(x);
     y = y(l);

    toPull = eAmpUn(eAmp);
    tempE = [];
    tempEM = [];
    tempESD = [];
%      toPull = [20000];
    for q = 1:length(toPull)
        impInd = ismember(round([x]),toPull(q));
        tempE = [tempE {[y(impInd)];[x(impInd)]}];
        tempEM = [tempEM {mean([y(impInd)]);[unique(x(impInd))]}];
        tempESD = [tempESD {std([y(impInd)]);[unique(x(impInd))]}];
        
    end
    allData.(aLetter).E = [allData.(aLetter).E tempE];
    allData.(aLetter).EM = [allData.(aLetter).EM tempEM];
    allData.(aLetter).ESD = [allData.(aLetter).ESD tempESD];
    
    xU = unique(extractedData.plots.(fs{i}).all.eAmp);
yM = [];
ySD = [];
w = [];
for z = 1:length(xU)
    uI = find(ismember([x],xU(z)));
    yM = [yM mean(y(uI))];
    ySD = [ySD std(y(uI))];
    for z2 = 1:length(uI)
        w = [w (length(uI)/length(y))/sum(ismember(y(uI),y(uI(z2))))];
        
    end
end
    [xData, yData, weights] = prepareCurveData( x, y, w );
    
    % Set up fittype and options.
    ft = fittype( 'a+(-a/(1+exp((x-b)/c)))', 'independent', 'x', 'dependent', 'y' );
    %a+(-a/(1+exp((x-b)/c)))a+(b/(1+exp(-(x-c)/d)))
    opts = fitoptions( 'Method', 'NonLinearLeastSquares' );
     opts.Display = 'Off';
     opts.Robust = 'Bisquare';
     opts.StartPoint = [1 8000 1000];
    %opts.StartPoint = [1 1 max(x)/2 1000];
    %opts.Upper = [max(y)*1.25 Inf Inf];
     opts.Upper = [Inf Inf Inf];
    opts.Weights = weights;
    
    % Fit model to data.
    extractedData.plots.(fs{i}).all.ef = fit( xData, yData, ft, opts );
    
    hold(axs(a+3).b,'on')
    jitterAmt = randi([-400,400],1,length(extractedData.plots.(fs{i}).all.eAmp));
    text(extractedData.plots.(fs{i}).all.eAmp+jitterAmt,extractedData.plots.(fs{i}).all.e,mk,'FontSize',10,'Color',c,'HorizontalAlignment','center')
%     scatter(extractedData.plots.(fs{i}).all.eAmp,extractedData.plots.(fs{i}).all.e,40,c,mk,'jitter','on','jitterAmount',400)
    errorbar(xU+shift,yM,ySD,'Color','k','LineStyle','none','LineWidth',1.5)
    plot(xData,extractedData.plots.(fs{i}).all.ef(xData),'Color',c,'LineWidth',2)
    
    hold(axs(a+3).b,'off')
    

    
end
if j == 3
    axs(1).b.YLim(2) = 400;
end
sameaxes([],[axs(1).b axs(2).b axs(3).b])
sameaxes([],[axs(4).b axs(5).b axs(6).b])
axs(4).b.YLim(1) = 0;
axs(5).b.YLim(1) = 0;
axs(6).b.YLim(1) = 0;
    [lP,iconsP,plotsP,legend_textP] =legend(axs(1).b,[impPlots(1:3)],[subG(1:3)],'Position',[0.07 0.8471 0 0]);
        lP.Position(1) = 0.070;
        lP.Position(2) = 0.8471;
        
        %a1 = annotation('textbox','String',char(mk2(1)),'FitBoxToText','on','LineStyle','none')
        lA = legend(axs(2).b,[impPlots(4:6)],[subG(4:6)]);  
        lA.Position(1) = 0.3685;
        lA.Position(2) = 0.8471;
        lH = legend(axs(3).b,[impPlots(end:-1:7)],[subG(end:-1:7)]);  
        lH.Position(1) = 0.6693;
        lH.Position(2) = 0.8471;
        
velEcap(j).fig2 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
ax2(j).a = axes(velEcap(j).fig2);
set(0,'CurrentFigure',velEcap(j).fig2)
hold(ax2(j).a,'on')
subG = [];
impPlots = [];
maxY = 0;
for i = 1:length(allData.(aLetter).VM)%tp
    
    for q = 1%:size(allData.(aLetter).VM,2)
        col2 = 'k';
        %         if i == 1
        %
        %                     impPlots = [impPlots plot(0,0,'Color',col2)];
        %                     subG = [subG {'20000 pC'}];
        %         end
        
        switch allData.(aLetter).I(i)%i
            case 1
                mk = char(9680);%'d';
                 subG = [subG {['LP, Shallow']}];
                %subG = [subG {['1',aLetter]}];
            case 2
                mk = char(9679);%'o';
                subG = [subG {['LP, Middle']}];
%                 subG = [subG {['2',aLetter]}];
            case 3
                mk = char(9681);%'>';
                subG = [subG {['LP, Deep']}];
%                 subG = [subG {['3',aLetter]}];
            case 4
                mk = char(9703);%'x';
                subG = [subG {['LA, Shallow']}];
%                 subG = [subG {['4',aLetter]}];
            case 5
                mk = char(9632);%'p';
                subG = [subG {['LA, Middle']}];
%                 subG = [subG {['5',aLetter]}];
            case 6
                mk = char(9704);%'v';
                subG = [subG {['LA, Deep']}];
%                 subG = [subG {['6',aLetter]}];
            case 7
                mk = char(9710);%'<';
                subG = [subG {['LH, Deep']}];
%                 subG = [subG {['7',aLetter]}];
            case 8
                mk = char(9650);%'s';
                  subG = [subG {['LH, Middle']}];
%                 subG = [subG {['8',aLetter]}];
            case 9
                mk = char(9709);%'^';
                 subG = [subG {['LH, Shallow']}];
%                 subG = [subG {['9',aLetter]}];
        end
%         xm = allData.(aLetter).EM{1+2*(i-1),q};
%         ym = allData.(aLetter).VM{1+2*(i-1),q};
%         xerr = allData.(aLetter).ESD{1+2*(i-1),q};
%         yerr = allData.(aLetter).VSD{1+2*(i-1),q};
%         errorbar(xm,ym,yerr,yerr,xerr,xerr,'LineWidth',2,'Color',col2);%,'o','MarkerSize',15);
%         impPlots = [impPlots plot(allData.(aLetter).EM{1+2*(i-1),q},allData.(aLetter).VM{1+2*(i-1),q},'marker',mk,'Color',col2,'MarkerSize',15,'LineWidth',3)];
%         
        xm = allData.(aLetter).EM{1,i};
        ym = allData.(aLetter).VM{1,i};
        xerr = allData.(aLetter).ESD{1,i};
        yerr = allData.(aLetter).VSD{1,i};
        %errorbar(xm,ym,yerr,yerr,xerr,xerr,'LineWidth',2,'Color',col2);%,'o','MarkerSize',15);
        text(xm,ym,mk,'FontSize',17,'Color',col2)
        %impPlots = [impPlots plot(allData.(aLetter).EM{1,i},allData.(aLetter).VM{1,i},'marker',mk,'Color',col2,'MarkerSize',15,'LineWidth',3)];
        maxY = max(maxY,ym);
        
    allData.(aLetter).PTS = [allData.(aLetter).PTS ; [allData.(aLetter).EM{1,i},allData.(aLetter).VM{1,i}]];
    allData.(aLetter).mk(allData.(aLetter).I(i)) = {[mk,'   ', subG{end}]};
    allData.(aLetter).mk2 = [allData.(aLetter).mk2 {mk}];
    end
end
[PSortX,l]=sort(allData.(aLetter).PTS(:,1));
     pfit = polyfit(allData.(aLetter).PTS(:,1),allData.(aLetter).PTS(:,2),1);
f = polyval(pfit,PSortX);
plot(PSortX,f,'r--','LineWidth',4.5);
impPlots = [impPlots plot(PSortX(1),f(1),'b','LineWidth',4.5)];
[r,rsquare] = calcRSquare(allData.(aLetter).PTS(:,1),allData.(aLetter).PTS(:,2));
caption = sprintf('y = %.2f * x + %.2f\nr = %.2f', round(pfit(1),2), round(pfit(2),2),round(r,2));
drawnow
b1 = ax2(j).a.Position(1);
b2 = ax2(j).a.Position(2);
b3 = ax2(j).a.Position(3);
b4 = ax2(j).a.Position(4);
ttt = annotation('textbox',[b1*1.25  b4*0.95 0 0], 'String', caption, 'FitBoxToText', 'on','FontSize', 25, 'Color', 'k', 'FontWeight', 'bold','LineStyle','none');
subG = [subG {'Linear Fit'}];
ax2(j).a.LineWidth = 3.5;
ax2(j).a.XGrid = gridStat;
ax2(j).a.YGrid = gridStat;
ax2(j).a.YLim = [-20 210];
ax2(j).a.FontSize = 16;
ax2(j).a.XLabel.String = {'eCAP (µV)'};
ax2(j).a.XLabel.FontSize = 22;
ax2(j).a.YLabel.String = {'Eye Velocity Magnitude (°/s)'};
ax2(j).a.YLabel.FontSize = 22;
ax2(j).a.Title.String = ['eCAP vs. Eye Velocity, Animal ',aLetter];
hold(ax2(j).a,'off')
 ax2(j).a.YLim(2) = 220;
if j == 3
    ldgFig = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
%     axFake = axes(ldgFig);
%     axFake.LineWidth = 3.5;
% axFake.XGrid = gridStat;
% axFake.YGrid = gridStat;
% axFake.FontSize = 16;
% axFake.XLabel.FontSize = 22;
% axFake.YLabel.FontSize = 22;
cap = sprintf('%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s',allData.(aLetter).mk{1},...
    allData.(aLetter).mk{2},allData.(aLetter).mk{3},allData.(aLetter).mk{4},...
    allData.(aLetter).mk{5},allData.(aLetter).mk{6},allData.(aLetter).mk{9},...
    allData.(aLetter).mk{8},allData.(aLetter).mk{7},'        Linear Fit');
%     axFake.Visible = 'off';
    ttt = annotation('textbox',[b1*1.25  b4*0.95 0 0], 'String', cap, 'FitBoxToText', 'on','FontSize', 25, 'Color', 'k', 'FontWeight', 'bold','LineStyle','-','LineWidth',3.5,'BackgroundColor',[1 1 1]);
    %ldg = legend(axFake,[impPlots(1:6) impPlots(9:-1:7) impPlots(end)],[subG(1:6) subG(9:-1:7) subG(end)],'FontSize',19);
    drawnow
    ttt.Position(3) = 0.137;
    drawnow
    ttt2 = annotation('rectangle',[.5 .2 .1 0],'Color','red','LineWidth',4.5);
    drawnow
    ttt2.Position(1) = .167;
    drawnow
    ttt2.Position(2) = .365;
    drawnow
    ttt2.Position(3) = .035;
    drawnow
%     bL = ldg.Position(4);
%     ldg.Position(1) = 0.5;
%     ldg.Position(2) = b4+b2-bL; 
%     drawnow
end
% % sortMat = [];
% % for i = 1:length(yV)
% %     [~,ii]=sort(sub(:,i),'Descend');
% %     [~,r]=sort(ii);
% %     sortMat = [sortMat r];
% % end
% % sub = yE-yV;
% % subG = {'1','2','3','4','5','6','7','8'};
% % sub = sub';
end

velEcap(1).fig.Visible = 'On';
velEcap(2).fig.Visible = 'On';
velEcap(3).fig.Visible = 'On';
velEcap(1).fig2.Visible = 'On';
velEcap(2).fig2.Visible = 'On';
velEcap(3).fig2.Visible = 'On';
sameaxes([],[ax2(1).a ax2(2).a ax2(3).a])


saveas(velEcap(1).fig,['R:\Morris, Brian\Papers\ECAP Paper\EyeVandECAPbyCharge\AnimalG_New_EyeVandECAPvsCharge_SigmoidFit.svg']);
saveas(velEcap(1).fig,['R:\Morris, Brian\Papers\ECAP Paper\EyeVandECAPbyCharge\AnimalG_New_EyeVandECAPvsCharge_SigmoidFit.jpg']);
saveas(velEcap(1).fig,['R:\Morris, Brian\Papers\ECAP Paper\EyeVandECAPbyCharge\AnimalG_New_EyeVandECAPvsCharge_SigmoidFit.fig']);
saveas(velEcap(2).fig,['R:\Morris, Brian\Papers\ECAP Paper\EyeVandECAPbyCharge\AnimalD_New_EyeVandECAPvsCharge_SigmoidFit.svg']);
saveas(velEcap(2).fig,['R:\Morris, Brian\Papers\ECAP Paper\EyeVandECAPbyCharge\AnimalD_New_EyeVandECAPvsCharge_SigmoidFit.jpg']);
saveas(velEcap(2).fig,['R:\Morris, Brian\Papers\ECAP Paper\EyeVandECAPbyCharge\AnimalD_New_EyeVandECAPvsCharge_SigmoidFit.fig']);
saveas(velEcap(3).fig,['R:\Morris, Brian\Papers\ECAP Paper\EyeVandECAPbyCharge\AnimalF_New_EyeVandECAPvsCharge_SigmoidFit.svg']);
saveas(velEcap(3).fig,['R:\Morris, Brian\Papers\ECAP Paper\EyeVandECAPbyCharge\AnimalF_New_EyeVandECAPvsCharge_SigmoidFit.jpg']);
saveas(velEcap(3).fig,['R:\Morris, Brian\Papers\ECAP Paper\EyeVandECAPbyCharge\AnimalF_New_EyeVandECAPvsCharge_SigmoidFit.fig']);

saveas(velEcap(1).fig2,['R:\Morris, Brian\Papers\ECAP Paper\EyeVandECAPbyCharge\AnimalG_New_EyeVvsECAPAllpC.svg']);
saveas(velEcap(1).fig2,['R:\Morris, Brian\Papers\ECAP Paper\EyeVandECAPbyCharge\AnimalG_New_EyeVvsECAPAllpC.jpg']);
saveas(velEcap(1).fig2,['R:\Morris, Brian\Papers\ECAP Paper\EyeVandECAPbyCharge\AnimalG_New_EyeVvsECAPAllpC.fig']);
saveas(velEcap(2).fig2,['R:\Morris, Brian\Papers\ECAP Paper\EyeVandECAPbyCharge\AnimalD_New_EyeVvsECAPAllpC.svg']);
saveas(velEcap(2).fig2,['R:\Morris, Brian\Papers\ECAP Paper\EyeVandECAPbyCharge\AnimalD_New_EyeVvsECAPAllpC.jpg']);
saveas(velEcap(2).fig2,['R:\Morris, Brian\Papers\ECAP Paper\EyeVandECAPbyCharge\AnimalD_New_EyeVvsECAPAllpC.fig']);
saveas(velEcap(3).fig2,['R:\Morris, Brian\Papers\ECAP Paper\EyeVandECAPbyCharge\AnimalF_New_EyeVvsECAPAllpC.svg']);
saveas(velEcap(3).fig2,['R:\Morris, Brian\Papers\ECAP Paper\EyeVandECAPbyCharge\AnimalF_New_EyeVvsECAPAllpC.jpg']);
saveas(velEcap(3).fig2,['R:\Morris, Brian\Papers\ECAP Paper\EyeVandECAPbyCharge\AnimalF_New_EyeVvsECAPAllpC.fig']);
saveas(ldgFig,['R:\Morris, Brian\Papers\ECAP Paper\EyeVandECAPbyCharge\LDGfor_New_EyeVvsECAPAllpC.svg']);
saveas(ldgFig,['R:\Morris, Brian\Papers\ECAP Paper\EyeVandECAPbyCharge\LDGfor_New_EyeVvsECAPAllpC.jpg']);
saveas(ldgFig,['R:\Morris, Brian\Papers\ECAP Paper\EyeVandECAPbyCharge\LDGfor_New_EyeVvsECAPAllpC.fig']);
%%
velEcap = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
ab = struct();

% ab.Animal(1) = {''};
% ab.Electrode(1) = {''};
% ab.Amplitude(1) = {''};
% ab.Velocity(1) = {''};
% ab.eCAP(1) = {''};
n = 1;
for i = 1:length(allData.D.PTS(:,1))
    xm = allData.D.PTS(i,1);
    ym = allData.D.PTS(i,2);
    xerr = allData.D.ESD{1,i};
    yerr = allData.D.VSD{1,i};
    mk = allData.D.mk2{i};
    col2 = [0 0 1];
    text(xm,ym,mk,'FontSize',17,'Color',col2)
    ab.Animal(n) = {'D'};
    ab.Electrode(n) = {allData.D.I(i)};
    ab.Amplitude(n) = allData.D.VM(2,i);
    ab.Velocity(n) = allData.D.VM(1,i);
    ab.eCAP(n) = allData.D.EM(2,i);
    n = n+1;
%     errorbar(xm,ym,yerr,yerr,xerr,xerr,'LineWidth',2,'Color',[0 0 1],'Marker',allData.D.mk{i},'MarkerSize',15);
% plot(allData.D.PTS(i,1),allData.D.PTS(:,2),'bo','MarkerSize',15,'LineWidth',3)
hold on
end

for i = 1:length(allData.F.PTS(:,1))
    xm = allData.F.PTS(i,1);
    ym = allData.F.PTS(i,2);
    xerr = allData.F.ESD{1,i};
    yerr = allData.F.VSD{1,i};
        mk = allData.F.mk2{i};
    col2 = [0 0.75 0];
    text(xm,ym,mk,'FontSize',17,'Color',col2)
    ab.Animal(n) = {'F'};
    ab.Electrode(n) = {allData.F.I(i)};
    ab.Amplitude(n) = allData.F.VM(2,i);
    ab.Velocity(n) = allData.F.VM(1,i);
    ab.eCAP(n) = allData.F.EM(2,i);
    n = n+1;
%     errorbar(xm,ym,yerr,yerr,xerr,xerr,'LineWidth',2,'Color',[0 1 0],'Marker',allData.F.mk{i},'MarkerSize',15);
end

for i = 1:length(allData.G.PTS(:,1))
    xm = allData.G.PTS(i,1);
    ym = allData.G.PTS(i,2);
    xerr = allData.G.ESD{1,i};
    yerr = allData.G.VSD{1,i};
        mk = allData.G.mk2{i};
    col2 = [1 0 0];
    text(xm,ym,mk,'FontSize',17,'Color',col2)
    ab.Animal(n) = {'G'};
    ab.Electrode(n) = {allData.G.I(i)};
    ab.Amplitude(n) = allData.G.VM(2,i);
    ab.Velocity(n) = allData.G.VM(1,i);
    ab.eCAP(n) = allData.G.EM(2,i);
    n = n+1;
%     errorbar(xm,ym,yerr,yerr,xerr,xerr,'LineWidth',2,'Color',[1 0 0],'Marker',allData.G.mk{i},'MarkerSize',15);
end
drawnow

AX = velEcap.Children;

% x = [allData.D.PTS(:,1)];
% y = [allData.D.PTS(:,2)];
%     [PSortX,l]=sort(x);
%      pfit = polyfit(x,y,1);
% f = polyval(pfit,PSortX);
% plot(PSortX,f,'b--','LineWidth',4.5);
% [r,rsquare] = calcRSquare(x,y);
% caption = sprintf('Slope = %.2f\n r = %.2f', round(pfit(1),2),round(r,2));
% drawnow
% Xrange=(AX.Position(3))/(AX.XLim(2)-AX.XLim(1))
% Yrange=(AX.Position(4))/(AX.YLim(2)-AX.YLim(1))
% X=PSortX(end)*Xrange+AX.Position(1)
% Y=f(end)*Yrange+AX.Position(2)
% ttt = annotation('textbox',[X Y 0 0], 'String', caption, 'FitBoxToText', 'on','FontSize', 25, 'Color', 'k', 'FontWeight', 'bold','LineStyle','none');
% drawnow
% ttt.Position(2) = ttt.Position(2)+ttt.Position(4)/2;

% x = [allData.F.PTS(:,1)];
% y = [allData.F.PTS(:,2)];
%     [PSortX,l]=sort(x);
%      pfit = polyfit(x,y,1);
% f = polyval(pfit,PSortX);
% plot(PSortX,f,'g--','LineWidth',4.5);
% [r,rsquare] = calcRSquare(x,y);
% caption = sprintf('Slope = %.2f\n r = %.2f', round(pfit(1),2),round(r,2));
% drawnow
% Xrange=(AX.Position(3))/(AX.XLim(2)-AX.XLim(1))
% Yrange=(AX.Position(4))/(AX.YLim(2)-AX.YLim(1))
% X=PSortX(end)*Xrange+AX.Position(1)
% Y=f(end)*Yrange+AX.Position(2)
% ttt = annotation('textbox',[X Y 0 0], 'String', caption, 'FitBoxToText', 'on','FontSize', 25, 'Color', 'k', 'FontWeight', 'bold','LineStyle','none');
% drawnow
% ttt.Position(2) = ttt.Position(2)+ttt.Position(4)/2;

% x = [allData.G.PTS(:,1)];
% y = [allData.G.PTS(:,2)];
%     [PSortX,l]=sort(x);
%      pfit = polyfit(x,y,1);
% f = polyval(pfit,PSortX);
% plot(PSortX,f,'r--','LineWidth',4.5);
% [r,rsquare] = calcRSquare(x,y);
% caption = sprintf('Slope = %.2f\n r = %.2f', round(pfit(1),2),round(r,2));
% drawnow
% Xrange=(AX.Position(3))/(AX.XLim(2)-AX.XLim(1))
% Yrange=(AX.Position(4))/(AX.YLim(2)-AX.YLim(1))
% X=PSortX(end)*Xrange+AX.Position(1)
% Y=f(end)*Yrange+AX.Position(2)
% ttt = annotation('textbox',[X Y 0 0], 'String', caption, 'FitBoxToText', 'on','FontSize', 25, 'Color', 'k', 'FontWeight', 'bold','LineStyle','none');
% drawnow
% ttt.Position(2) = ttt.Position(2)+ttt.Position(4)/2;

% plot(allData.F.PTS(:,1),allData.F.PTS(:,2),'go','MarkerSize',15,'LineWidth',3)
% plot(allData.G.PTS(:,1),allData.G.PTS(:,2),'ro','MarkerSize',15,'LineWidth',3)

x = [allData.D.PTS(:,1);allData.F.PTS(:,1);allData.G.PTS(:,1)];
y = [allData.D.PTS(:,2);allData.F.PTS(:,2);allData.G.PTS(:,2)];
    [PSortX,l]=sort(x);
     pfit = polyfit(x,y,1);
f = polyval(pfit,PSortX);
plot(PSortX,f,'k--','LineWidth',4.5);
[r,rsquare] = calcRSquare(x,y);
caption = sprintf('y = %.2f * x + %.2f\nr = %.2f', round(pfit(1),2), round(pfit(2),2),round(r,2));
drawnow
 ttt = annotation('textbox',[b1*1.25  b4*0.95 0 0], 'String', caption, 'FitBoxToText', 'on','FontSize', 25, 'Color', 'k', 'FontWeight', 'bold','LineStyle','none');
drawnow
AX.YLim(2) = 220;
AX.FontSize = 16;
AX.XLabel.String = {'eCAP (µV)'};
AX.XLabel.FontSize = 22;
AX.YLabel.String = {'Eye Velocity Magnitude (°/s)'};
AX.YLabel.FontSize = 22;
AX.Title.String = ['Eye Velocity vs. eCAP, All Animals'];
velEcap2 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
cap = sprintf('%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s',allData.(aLetter).mk{1},...
    allData.(aLetter).mk{2},allData.(aLetter).mk{3},allData.(aLetter).mk{4},...
    allData.(aLetter).mk{5},allData.(aLetter).mk{6},allData.(aLetter).mk{9},...
    allData.(aLetter).mk{8},allData.(aLetter).mk{7},'        Animal D','        Animal F','        Animal G','        Linear Fit');
ttt = annotation('textbox',[b1*1.25  b4*0.95 0 0], 'String', cap, 'FitBoxToText', 'on','FontSize', 25, 'Color', 'k', 'FontWeight', 'bold','LineStyle','-','LineWidth',3.5,'BackgroundColor',[1 1 1]);
    drawnow
    ttt.Position(3) = 0.137;
    drawnow
    ttt2 = annotation('rectangle',[.5 .2 .1 0],'Color',[0 0 1],'LineWidth',4.5);
    drawnow
    ttt2.Position(1) = .167;
    drawnow
    ttt2.Position(2) = .365;
    drawnow
    ttt2.Position(3) = .035;
    drawnow
    
    ttt2 = annotation('rectangle',[.5 .2 .1 0],'Color',[0 .75 0],'LineWidth',4.5);
    drawnow
    ttt2.Position(1) = .167;
    drawnow
    ttt2.Position(2) = .3225;
    drawnow
    ttt2.Position(3) = .035;
    drawnow
    
    ttt2 = annotation('rectangle',[.5 .2 .1 0],'Color',[1 0 0],'LineWidth',4.5);
    drawnow
    ttt2.Position(1) = .167;
    drawnow
    ttt2.Position(2) = .28;
    drawnow
    ttt2.Position(3) = .035;
    drawnow
    
    ttt2 = annotation('rectangle',[.5 .2 .1 0],'Color',[0 0 0],'LineWidth',4.5);
    drawnow
    ttt2.Position(1) = .167;
    drawnow
    ttt2.Position(2) = .237;
    drawnow
    ttt2.Position(3) = .035;
    drawnow
saveas(velEcap,['R:\Morris, Brian\Papers\ECAP Paper\EyeVandECAPbyCharge\AllAnimal_New_EyeVvsECAP.svg']);
saveas(velEcap,['R:\Morris, Brian\Papers\ECAP Paper\EyeVandECAPbyCharge\AllAnimal_New_EyeVvsECAP.jpg']);
saveas(velEcap,['R:\Morris, Brian\Papers\ECAP Paper\EyeVandECAPbyCharge\AllAnimal_New_EyeVvsECAP.fig']);
saveas(velEcap2,['R:\Morris, Brian\Papers\ECAP Paper\EyeVandECAPbyCharge\AllAnimal_New_EyeVvsECAP_LDG.svg']);
saveas(velEcap2,['R:\Morris, Brian\Papers\ECAP Paper\EyeVandECAPbyCharge\AllAnimal_New_EyeVvsECAP_LDG.jpg']);
saveas(velEcap2,['R:\Morris, Brian\Papers\ECAP Paper\EyeVandECAPbyCharge\AllAnimal_New_EyeVvsECAP_LDG.fig']);
Animal = ab.Animal';
Electrode = ab.Electrode';
Amplitude = ab.Amplitude';
Velocity = ab.Velocity';
eCAP = ab.eCAP';
extData = table(Animal,Electrode,Amplitude,Velocity,eCAP);
writetable(extData,['R:\Morris, Brian\Papers\ECAP Paper\EyeVandECAPbyCharge\allAnimals_exportedEyeV_eCAP.csv']);
%%
[r,rsquare] = calcRSquare(x,newY3)

%% ONLY FOR PLOTTING PRE AND POST FRED ELECTRODE ADJUSTMENT EYE MOVEMENT AND ECAP TOGETHER 
toExpIntraOpEyeV = table({NaN},{NaN},{NaN},{NaN},{NaN},{NaN},'VariableNames',{'Animal','Electrode','TimeRecorded','Amp','EyeV','EyeVnorm'});
toExpIntraOpECAP = table({NaN},{NaN},{NaN},{NaN},{NaN},{NaN},'VariableNames',{'Animal','Electrode','TimeRecorded','Amp','ECAP','ECAPnorm'});

dd2 = load('R:\Morris, Brian\Condensed Dai Data\2011-05-25-RhFred Electrode characterization\For ECAP Paper\cycles\CycleParams.mat');
dd = load('R:\Morris, Brian\Condensed Dai Data\2010-09-17-RhFred-electrode characterization test at 2 Hz\cycles\CycleParams.mat');
velEcap = struct();
velEcap.cur = figure('units','normalized','outerposition',[0 0 1 1]);
sgtitle(velEcap.cur,{'Current vs. Eye Velocity Magnitude and Intra-Operative Ecap, Animal F';''},'FontSize', 22, 'FontWeight', 'Bold');
velEcap.chg = figure('units','normalized','outerposition',[0 0 1 1]);
sgtitle(velEcap.chg,{'Charge vs. Eye Velocity Magnitude and Intra-Operative Ecap, Animal F';''},'FontSize', 22, 'FontWeight', 'Bold');

% Plot Velocity First
ax = struct();
ax(2).v = [];
ax(2).c = [];
plots = struct();
d = [{'dd'}, {'dd2'}];
tot = 1;
totc = 1;
x = [];
xc = [];
y = [];
ldgRALPPRE =[];
ldgRALPPOST =[];
ldgRALPPREc =[];
ldgRALPPOSTc =[];
extractData = struct();
extractData.RALP = [];
eyeV = struct();
eCAP = struct();
eyeV(3).PreXAll = [];
eyeV(3).PreYAll = [];
eyeV(3).PostXAll = [];
eyeV(3).PostYAll = [];
exM = [];
exS = [];
    c1 = [1 0 0];
        c2 = [0 1 0];
        c3 = [0 0 1];
for i = 1:length(d)
    idNum = 1;
    for j = 1:length(getfield(eval(d{i}),'tempS'))
        if strcmp(getfield(eval(d{i}),'tempS',{j},'dir'),'RALP')
        switch getfield(eval(d{i}),'tempS',{j},'stim')
            case 1
%                 ca = [255 166 158];
%                 Color = [ca]/255;
                Color = c1;
                f = 'stim1ref11';
                ldgName = 'Stimulating Electrode, Shallow';
                toTop = 1;
                ns = '1';
                mk = 'd';
                shift = -200;
            case 2
%                 Color = [72 169 60]/255;
                Color = c2;
                f = 'stim2ref11';
                ldgName = 'Stimulating Electrode, Middle';
                toTop = 0;
                ns = '2';
                mk = 'o';
                shift = 200;
            case 3
%                 cw = [104 78 50];
%                 Color = [cw]/255;
                Color = c3;
                f = 'stim3ref11';
                ldgName = 'Stimulating Electrode, Deep';
                toTop = 0;
                ns = '3';
                mk = '>';
                shift = 0;
        end
        
   

         
        
        if i == 1
            if isempty(ax(1).v)
                ax(1).v = subtightplot(2,2,1,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', velEcap.cur);
                ax(1).v.LineWidth = 2.5;
                ax(1).v.XGrid = 'on';
                ax(1).v.YGrid = 'on';
                ax(1).v.FontSize = 13;
                ax(1).v.XLabel.String = {'Current (uA)'};
                ax(1).v.XLabel.FontSize = 22;
                ax(1).v.YLabel.String = {'Velocity (dps)'};
                ax(1).v.YLabel.FontSize = 22;
                ax(1).v.XLim = [0 200+10];
                ax(1).v.XTick = [0:20:200];
                
                ax(1).c = subtightplot(2,2,1,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', velEcap.chg);
                ax(1).c.LineWidth = 2.5;
                ax(1).c.XGrid = 'on';
                ax(1).c.YGrid = 'on';
                ax(1).c.FontSize = 13;
                ax(1).c.XLabel.String = {'Current (uA)'};
                ax(1).c.XLabel.FontSize = 22;
                ax(1).c.YLabel.String = {'Velocity (dps)'};
                ax(1).c.YLabel.FontSize = 22;
                ax(1).c.XLim = [0 40000+2000];
                ax(1).c.XTick = [0:4000:40000];
            else
                set([ax(1).v],'Layer','Top');
                set([ax(1).c],'Layer','Top');
            end
            x = [x str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'))];
            xc = [xc str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'))*getfield(eval(d{i}),'tempS',{j},'p1d')];
            y = [y mean([getfield(eval(d{i}),'tempS',{j},'MagRF')])]; 
            e = ['e',num2str(getfield(eval(d{i}),'tempS',{j},'stim'))];
            %if str2num(getfield(eval(d{i}),'tempS',{j},'p1amp')) == 120
                extractData.RALPPRE.(e)(idNum).amp = str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'));
                extractData.RALPPRE.(e)(idNum).v = mean([getfield(eval(d{i}),'tempS',{j},'MagRF')]);
                extractData.RALPPRE.(e)(idNum).sd = std([getfield(eval(d{i}),'tempS',{j},'MagRF')]);
                 [a,b] = max(abs([getfield(eval(d{i}),'tempS',{j},'M3DRF')]));
                extractData.RALPPRE.(e)(idNum).v3d = [getfield(eval(d{i}),'tempS',{j},'M3DRF',{b(1),1}) getfield(eval(d{i}),'tempS',{j},'M3DRF',{b(2),2}) getfield(eval(d{i}),'tempS',{j},'M3DRF',{b(3),3})];
                el = getfield(eval(d{i}),'tempS',{j},'stim');
                yV = [getfield(eval(d{i}),'tempS',{j},'MagRF')];
                eyeV(el).PreXAll = [eyeV(el).PreXAll repmat(str2num(getfield(eval(d{i}),'tempS',{j},'p1amp')),1,length(yV))];
                eyeV(el).PreYAll = [eyeV(el).PreYAll yV];
            %end
            set(0,'CurrentFigure',velEcap.cur)
            hold(ax(1).v,'on')
            %plots.vPPRE(tot) = plot(ax(1).v,str2num(getfield(eval(d{i}),'tempS',{j},'p1amp')),mean([getfield(eval(d{i}),'tempS',{j},'MagRF')]),'color',Color,'LineWidth',2,'marker',mk,'MarkerSize',8);
            plots.vPEBPRE(tot) = errorbar(ax(1).v,str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'))+shift/400,mean([getfield(eval(d{i}),'tempS',{j},'MagRF')]),std([getfield(eval(d{i}),'tempS',{j},'MagRF')]),'color','k','LineWidth',1.5);
                        hold(ax(1).v,'off')
                        
                        chg = str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'))*getfield(eval(d{i}),'tempS',{j},'p1d');
            set(0,'CurrentFigure',velEcap.chg)
                        hold(ax(1).c,'on')
            plots.vPEBPREc(tot) = errorbar(ax(1).c,chg+shift/400,mean([getfield(eval(d{i}),'tempS',{j},'MagRF')]),std([getfield(eval(d{i}),'tempS',{j},'MagRF')]),'color','k','LineWidth',1.5);
                        hold(ax(1).c,'off')
            if ~toTop
                %uistack(plots.vPPRE(tot),'bottom')
                uistack(plots.vPEBPRE(tot),'bottom')
                uistack(plots.vPEBPREc(tot),'bottom')
            end
            if str2num(getfield(eval(d{i}),'tempS',{j},'p1amp')) == 100
                extractedData.plots.(f).eyeVel = mean([getfield(eval(d{i}),'tempS',{j},'MagRF')]);
                extractedData.plots.(f).eyeVelSTD = std([getfield(eval(d{i}),'tempS',{j},'MagRF')]);
            end
            tot = tot +1;

            aLetter = 'F';
            el = getfield(eval(d{i}),'tempS',{j},'stim');

            if j<length(getfield(eval(d{i}),'tempS'))
                if getfield(eval(d{i}),'tempS',{j},'stim')~=getfield(eval(d{i}),'tempS',{j+1},'stim')
                    ldgRALPPRE = [ldgRALPPRE, {ldgName}];%[ldgRALPPRE, {['Stim ',num2str(getfield(eval(d{i}),'tempS',{j},'stim'))]}];
                    set(0,'CurrentFigure',velEcap.cur)            
                    hold(ax(1).v,'on')
                    plots.vPLRALPPRE(length(ldgRALPPRE)) = line(ax(1).v,x,y,'color',Color,'LineWidth',2,'marker',mk,'MarkerSize',8);
                                hold(ax(1).v,'off')
                                set(0,'CurrentFigure',velEcap.chg)
                                hold(ax(1).c,'on')
                    plots.vPLRALPPREc(length(ldgRALPPRE)) = line(ax(1).c,xc,y,'color',Color,'LineWidth',2,'marker',mk,'MarkerSize',8);
                                hold(ax(1).c,'off')
                                eyeV(el).PreX = x;
                                eyeV(el).PreY = y;
                    if ~toTop
                        
                        uistack(plots.vPLRALPPRE(length(ldgRALPPRE)),'bottom')
                        uistack(plots.vPLRALPPREc(length(ldgRALPPRE)),'bottom')
                    else
                    end
                    x = [];
                    xc = [];
                    y = [];
                    idNum = 1;
                else
                    idNum = idNum + 1;
                end
            elseif (j==length(getfield(eval(d{i}),'tempS')))
                ldgRALPPRE = [ldgRALPPRE, {ldgName}];%[ldgRALPPRE, {['Stim ',num2str(getfield(eval(d{i}),'tempS',{j},'stim'))]}];
                set(0,'CurrentFigure',velEcap.cur)            
                hold(ax(1).v,'on')
                plots.vPLRALPPRE(length(ldgRALPPRE)) = line(ax(1).v,x,y,'color',Color,'LineWidth',2,'marker',mk,'MarkerSize',8);
                            hold(ax(1).v,'off')
                            set(0,'CurrentFigure',velEcap.chg)
                            hold(ax(1).c,'on')
                plots.vPLRALPPREc(length(ldgRALPPRE)) = line(ax(1).c,xc,y,'color',Color,'LineWidth',2,'marker',mk,'MarkerSize',8);
                            hold(ax(1).c,'off')
                            eyeV(el).PreX = x;
                                eyeV(el).PreY = y;
                if ~toTop
                   
                   uistack(plots.vPLRALPPRE(length(ldgRALPPRE)),'bottom')
                   uistack(plots.vPLRALPPREc(length(ldgRALPPRE)),'bottom')
                   else
                end        
                x = [];
                xc = [];
                        y = [];
            end

            
            
        elseif i == 2
            if isempty(ax(2).v)
                ax(2).v = subtightplot(2,2,2,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', velEcap.cur);
                ax(2).v.LineWidth = 2.5;
                ax(2).v.XGrid = 'on';
                ax(2).v.YGrid = 'on';
                ax(2).v.FontSize = 13;
                ax(2).v.XLabel.String = {'Current (uA)'};
                ax(2).v.XLabel.FontSize = 22;
                ax(2).v.XLim = [0 200+10];
                ax(2).v.XTick = [0:20:200];
                ax(2).v.YTickLabel = [];
                
                ax(2).c = subtightplot(2,2,2,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', velEcap.chg);
                ax(2).c.LineWidth = 2.5;
                ax(2).c.XGrid = 'on';
                ax(2).c.YGrid = 'on';
                ax(2).c.FontSize = 13;
                ax(2).c.XLabel.String = {'Current (uA)'};
                ax(2).c.XLabel.FontSize = 22;
                ax(2).c.XLim = [0 40000+2000];
                ax(2).c.XTick = [0:4000:40000];
                ax(2).c.YTickLabel = [];
            else
                set([ax(2).v],'Layer','Top');
                set([ax(2).c],'Layer','Top');
            end
            
            x = [x str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'))];
            xc = [xc str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'))*getfield(eval(d{i}),'tempS',{j},'p1d')];
            y = [y mean([getfield(eval(d{i}),'tempS',{j},'MagRF')])]; 
            e = ['e',num2str(getfield(eval(d{i}),'tempS',{j},'stim'))];
            %if str2num(getfield(eval(d{i}),'tempS',{j},'p1amp')) == 120
                extractData.RALPPOST.(e)(idNum).amp = str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'));
                extractData.RALPPOST.(e)(idNum).v = mean([getfield(eval(d{i}),'tempS',{j},'MagRF')]);
                extractData.RALPPOST.(e)(idNum).sd = std([getfield(eval(d{i}),'tempS',{j},'MagRF')]);
                 [a,b] = max(abs([getfield(eval(d{i}),'tempS',{j},'M3DRF')]));
                extractData.RALPPOST.(e)(idNum).v3d = [getfield(eval(d{i}),'tempS',{j},'M3DRF',{b(1),1}) getfield(eval(d{i}),'tempS',{j},'M3DRF',{b(2),2}) getfield(eval(d{i}),'tempS',{j},'M3DRF',{b(3),3})];
                el = getfield(eval(d{i}),'tempS',{j},'stim');
                yV = [getfield(eval(d{i}),'tempS',{j},'MagRF')];
                eyeV(el).PostXAll = [eyeV(el).PostXAll repmat(str2num(getfield(eval(d{i}),'tempS',{j},'p1amp')),1,length(yV))];
                eyeV(el).PostYAll = [eyeV(el).PostYAll yV];
            %end
            set(0,'CurrentFigure',velEcap.cur)
            hold(ax(2).v,'on')
            %plots.vPPOST(tot) = plot(ax(2).v,str2num(getfield(eval(d{i}),'tempS',{j},'p1amp')),mean([getfield(eval(d{i}),'tempS',{j},'MagRF')]),'color',Color,'LineWidth',2,'marker','o','MarkerSize',8);
            plots.vPEBPOST(tot) = errorbar(ax(2).v,str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'))+shift/400,mean([getfield(eval(d{i}),'tempS',{j},'MagRF')]),std([getfield(eval(d{i}),'tempS',{j},'MagRF')]),'color','k','LineWidth',1.5);
            hold(ax(2).v,'off')
            
            set(0,'CurrentFigure',velEcap.chg)
            chg = str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'))*getfield(eval(d{i}),'tempS',{j},'p1d');
            hold(ax(2).c,'on')
            plots.vPEBPOSTc(tot) = errorbar(ax(2).c,chg+shift/400,mean([getfield(eval(d{i}),'tempS',{j},'MagRF')]),std([getfield(eval(d{i}),'tempS',{j},'MagRF')]),'color','k','LineWidth',1.5);
            hold(ax(2).c,'off')
            if ~toTop
                %uistack(plots.vPPOST(tot),'bottom')
                uistack(plots.vPEBPOST(tot),'bottom')
                uistack(plots.vPEBPOSTc(tot),'bottom')
            end
            if str2num(getfield(eval(d{i}),'tempS',{j},'p1amp')) == 100
                extractedData.plots.(f).eyeVel = mean([getfield(eval(d{i}),'tempS',{j},'MagRF')]);
                extractedData.plots.(f).eyeVelSTD = std([getfield(eval(d{i}),'tempS',{j},'MagRF')]);
            end
            tot = tot +1;
            aLetter = 'F';
            el = getfield(eval(d{i}),'tempS',{j},'stim');
%             if length(toExpIntraOpEyeV.Animal) == 1
%                 EyeV = num2cell(getfield(eval(d{i}),'tempS',{j},'MagRF'));
%                 b = 1:length(EyeV);
%                 toExpIntraOpEyeV.Animal(b) = repmat({aLetter},length(EyeV),1);
%                 toExpIntraOpEyeV.Electrode(b) = repmat({[el]},length(EyeV),1);
%                 toExpIntraOpEyeV.TimeRecorded(b) = repmat({'Post'},length(EyeV),1);
%                 toExpIntraOpEyeV.Amp(b) = repmat({str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'))},length(EyeV),1);
%                 toExpIntraOpEyeV.EyeV(b) = EyeV;
%                 toExpIntraOpEyeV.EyeVnorm(b) = repmat({'NA'},length(EyeV),1);
%             else
%                 EyeV = num2cell(getfield(eval(d{i}),'tempS',{j},'MagRF'));
%                 b = length(toExpIntraOpEyeV.Animal)+1:length(toExpIntraOpEyeV.Animal)+length(EyeV);
%                 toExpIntraOpEyeV.Animal(b) = repmat({aLetter},length(EyeV),1);
%                 toExpIntraOpEyeV.Electrode(b) = repmat({[el]},length(EyeV),1);
%                 toExpIntraOpEyeV.TimeRecorded(b) = repmat({'Post'},length(EyeV),1);
%                 toExpIntraOpEyeV.Amp(b) = repmat({str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'))},length(EyeV),1);
%                 toExpIntraOpEyeV.EyeV(b) = EyeV;
%                 toExpIntraOpEyeV.EyeVnorm(b) = repmat({'NA'},length(EyeV),1);
%             end
            if j<length(getfield(eval(d{i}),'tempS'))
                if getfield(eval(d{i}),'tempS',{j},'stim')~=getfield(eval(d{i}),'tempS',{j+1},'stim')
                    ldgRALPPOST = [ldgRALPPOST, {ldgName}];%[ldgRALPPOST, {['Stim ',num2str(getfield(eval(d{i}),'tempS',{j},'stim'))]}];
                    set(0,'CurrentFigure',velEcap.cur)
            hold(ax(2).v,'on')
                    plots.vPLRALPPOST(length(ldgRALPPOST)) = line(ax(2).v,x,y,'color',Color,'LineWidth',2,'marker',mk,'MarkerSize',8);
                   hold(ax(2).v,'off')
                   
                   set(0,'CurrentFigure',velEcap.chg)
            hold(ax(2).c,'on')
                    plots.vPLRALPPOSTc(length(ldgRALPPOST)) = line(ax(2).c,xc,y,'color',Color,'LineWidth',2,'marker',mk,'MarkerSize',8);
                   hold(ax(2).c,'off')
                   eyeV(el).PostX = x;
                                eyeV(el).PostY = y;
                    if ~toTop
                    
                uistack(plots.vPLRALPPOST(length(ldgRALPPOST)),'bottom')
                uistack(plots.vPLRALPPOSTc(length(ldgRALPPOST)),'bottom')
                else
            end
                    x = [];
                    xc = [];
                    y = [];
                    idNum = 1;
                else
                    idNum = idNum + 1;
                end
            elseif (j==length(getfield(eval(d{i}),'tempS')))
                ldgRALPPOST = [ldgRALPPOST, {ldgName}];%[ldgRALPPOST, {['Stim ',num2str(getfield(eval(d{i}),'tempS',{j},'stim'))]}];
                set(0,'CurrentFigure',velEcap.cur)
            hold(ax(2).v,'on')
                plots.vPLRALPPOST(length(ldgRALPPOST)) = line(ax(2).v,x,y,'color',Color,'LineWidth',2,'marker',mk,'MarkerSize',8);
                hold(ax(2).v,'off')
                
                set(0,'CurrentFigure',velEcap.chg)
            hold(ax(2).c,'on')
                plots.vPLRALPPOSTc(length(ldgRALPPOST)) = line(ax(2).c,xc,y,'color',Color,'LineWidth',2,'marker',mk,'MarkerSize',8);
                hold(ax(2).c,'off')
                eyeV(el).PostX = x;
                                eyeV(el).PostY = y;
                if ~toTop
                    
                uistack(plots.vPLRALPPOST(length(ldgRALPPOST)),'bottom')
                uistack(plots.vPLRALPPOSTc(length(ldgRALPPOST)),'bottom')
                else
            end       
                x = [];
                xc = [];
                        y = [];
            end
        end

        end
        
    end
    if i == length(d)
        lR = legend(ax(1).v,[plots.vPLRALPPRE],[ldgRALPPRE]);
        drawnow
        lR.Position(1) = 0.0682;
        drawnow
        lR.Position(2) = 0.81;
        drawnow
        lR.Position(4) = 0.088;
        drawnow
        lL = legend(ax(2).v,[plots.vPLRALPPOST],[ldgRALPPOST]);  
        drawnow
        lL.Position(1) = 0.5206;
        drawnow
        lL.Position(2) = 0.81;
        drawnow
        lL.Position(4) = 0.088;
        drawnow
        sameaxes([],[ax(1).v ax(2).v])
        drawnow
        
        lR = legend(ax(1).c,[plots.vPLRALPPREc],[ldgRALPPRE]);
        drawnow
        lR.Position(1) = 0.0682;
        drawnow
        lR.Position(2) = 0.81;
        drawnow
        lR.Position(4) = 0.088;
        drawnow
        lL = legend(ax(2).c,[plots.vPLRALPPOSTc],[ldgRALPPOST]);  
        drawnow
        lL.Position(1) = 0.5206;
        drawnow
        lL.Position(2) = 0.81;
        drawnow
        lL.Position(4) = 0.088;
        drawnow
        sameaxes([],[ax(1).c ax(2).c])
        drawnow
    end
end
ax(1).v.Title.String = 'Pre-Electrode Array Adjustment';
ax(2).v.Title.String = 'Post-Electrode Array Adjustment';
ax(1).v.Title.FontSize = 22;
ax(2).v.Title.FontSize = 22;

ax(1).c.Title.String = 'Pre-Electrode Array Adjustment';
ax(2).c.Title.String = 'Post-Electrode Array Adjustment';
ax(1).c.Title.FontSize = 22;
ax(2).c.Title.FontSize = 22;

ax(3).v = [];
ax(4).v = [];
ax(3).c = [];
ax(4).c = [];
x = [];
xc = [];
y = [];
ldgRALPPRE =[];
ldgRALPPOST =[];
ecapM = [];
ecapS = [];
tot = 1;
path = 'R:\Morris, Brian\Condensed Dai Data\Fred Pre-Post Revision ECAP Analysis\Intra-Op ECAP\';
name = 'Fred20100117-Intra-op-Preadjustment-CondensedECAPData.mat';
load([path,name])
fs = fields(extractedData.plots);
currToPull = 7;
            
for h = 1:3
    switch fs{h}
        case 'stim1ref2'
%             ca = [255 166 158];
%             Color = [ca]/255;
                Color = c1;
            if isempty(ax(3).v)
                ax(3).v = subtightplot(2,2,3,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', velEcap.cur);
                ax(3).v.LineWidth = 2.5;
                ax(3).v.XGrid = 'on';
                ax(3).v.YGrid = 'on';
                ax(3).v.FontSize = 13;
                ax(3).v.XLabel.String = {'Current (cu)'};
                ax(3).v.XLabel.FontSize = 22;
                ax(3).v.YLabel.String = {'eCAP (uV)'};
                ax(3).v.YLabel.FontSize = 22;
                ax(3).v.XLim = [0 250+50];
                ax(3).v.XTick = [0:50:250];
                ax(3).v.Position = [ax(3).v.Position(1) 0.06 ax(3).v.Position(3) ax(3).v.Position(4)]; 
                a = ax(3).v;
                
                ax(3).c = subtightplot(2,2,3,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', velEcap.chg);
                ax(3).c.LineWidth = 2.5;
                ax(3).c.XGrid = 'on';
                ax(3).c.YGrid = 'on';
                ax(3).c.FontSize = 13;
                ax(3).c.XLabel.String = {'Charge (pC)'};
                ax(3).c.XLabel.FontSize = 22;
                ax(3).c.YLabel.String = {'eCAP (uV)'};
                ax(3).c.YLabel.FontSize = 22;

                
            else
                set([ax(3).v],'Layer','Top');
                set([ax(3).c],'Layer','Top');
                a = ax(3).v;
            end
            el = 1;
            toTop = 1;
            mk = 'd';
            shift = -200;
        case 'stim2ref1'
%             Color = [72 169 60]/255;
            Color = c2;
                set([ax(3).v],'Layer','Top');
                set([ax(3).c],'Layer','Top');
                a = ax(3).v;
                toTop = 0;
                el = 2;
                mk = 'o';
                shift = 200;
        case 'stim3ref2'
%             cw = [104 78 50];
%             Color = [cw]/255;
            Color = c3;
                set([ax(3).v],'Layer','Top');
                set([ax(3).c],'Layer','Top');
                a = ax(3).v;
                toTop = 0;
                el = 3;
                mk = '>';
                shift = 0;
    end
        
        
        
        mTemp = [extractedData.plots.(fs{h}).pextract];
        if isfield(extractedData.plots.(fs{h}),'pextractTrustUse')
        toChg = find(~[extractedData.plots.(fs{h}).pextractTrustUse]);
        mTemp(toChg) = NaN;
        end
        m = mean(mTemp,'omitnan');
        extractedData.plots.(fs{h}).mean = m;
        s = std([mTemp],'omitnan');
        extractedData.plots.(fs{h}).sd = s;
        x = extractedData.plots.(fs{h}).Amp;
        xc = extractedData.plots.(fs{h}).ampCalc(1,:);
        set(0,'CurrentFigure',velEcap.cur)
            hold(a,'on')
            bars = errorbar(a,x+shift/400,m,s,'color','k','LineWidth',1.5,'LineStyle','none');%,'marker','o','MarkerSize',10);
            plots.eP(tot) = plot(a,x,m,'color',Color,'marker',mk,'MarkerSize',8,'LineWidth',2);  
            hold(a,'off')
            
            set(0,'CurrentFigure',velEcap.chg)
            hold(ax(3).c,'on')
            barsc = errorbar(ax(3).c,xc+shift/400,m,s,'color','k','LineWidth',1.5,'LineStyle','none');%,'marker','o','MarkerSize',10);
            plots.ePc(tot) = plot(ax(3).c,xc,m,'color',Color,'marker',mk,'MarkerSize',8,'LineWidth',2);  
            hold(ax(3).c,'off')
            eCAP(el).PreX = x;
            eCAP(el).PreY = m;
                if ~toTop
                    
                uistack(bars,'bottom')
                uistack(plots.eP(tot),'bottom')
                
                uistack(barsc,'bottom')
                uistack(plots.ePc(tot),'bottom')
                else                
            end
                tot = tot +1;

            aLetter = 'F';
%             nE = [];
%             nX = num2cell(repmat([x],1,size(mTemp,1)));
%             for bla = 1:size(mTemp,1)
%                 nE = [nE mTemp(bla,:)];
%             end
%             if length(toExpIntraOpECAP.Animal) == 1
%                 b = 1:length(nE);
%                 toExpIntraOpECAP.Animal(b) = repmat({aLetter},length(nE),1);
%                 toExpIntraOpECAP.Electrode(b) = repmat({[el]},length(nE),1);
%                 toExpIntraOpECAP.TimeRecorded(b) = repmat({'Pre'},length(nE),1);
%                 toExpIntraOpECAP.Amp(b) = nX;
%                 toExpIntraOpECAP.ECAP(b) = num2cell(nE);
%                 toExpIntraOpECAP.ECAPnorm(b) = repmat({'NA'},length(nE),1);
%             else
%                 b = length(toExpIntraOpECAP.Animal)+1:length(toExpIntraOpECAP.Animal)+length(nE);
%                 toExpIntraOpECAP.Animal(b) = repmat({aLetter},length(nE),1);
%                 toExpIntraOpECAP.Electrode(b) = repmat({[el]},length(nE),1);
%                 toExpIntraOpECAP.TimeRecorded(b) = repmat({'Pre'},length(nE),1);
%                 toExpIntraOpECAP.Amp(b) = nX;
%                 toExpIntraOpECAP.ECAP(b) = num2cell(nE);
%                 toExpIntraOpECAP.ECAPnorm(b) = repmat({'NA'},length(nE),1);
%             end
        
end
save([path,name],'extractedData')

x = [];
xc = [];
y = [];
ecapM = [];
ecapS = [];
tot = 1;
path = 'R:\Morris, Brian\Condensed Dai Data\Fred Pre-Post Revision ECAP Analysis\Intra-Op ECAP\';
name = 'Fred20100117-Intra-op-Postadjustment-CondensedECAPData.mat';
load([path,name])
fs = fields(extractedData.plots);
currToPull = 7;
for h = 1:3
    switch fs{h}
        case 'stim1ref2'
%             ca = [255 166 158];
%             Color = [ca]/255;
            Color = c1;
            if isempty(ax(4).v)
                ax(4).v = subtightplot(2,2,4,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', velEcap.cur);
                ax(4).v.LineWidth = 2.5;
                ax(4).v.XGrid = 'on';
                ax(4).v.YGrid = 'on';
                ax(4).v.FontSize = 13;
                ax(4).v.XLabel.String = {'Current (cu)'};
                ax(4).v.XLabel.FontSize = 22;
                ax(4).v.XLim = [0 250+50];
                ax(4).v.XTick = [0:50:250];
                ax(4).v.YTickLabel = [];
                ax(4).v.Position = [ax(4).v.Position(1) 0.06 ax(4).v.Position(3) ax(4).v.Position(4)]; 
                a = ax(4).v;
                
                ax(4).c = subtightplot(2,2,4,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', velEcap.chg);
                ax(4).c.LineWidth = 2.5;
                ax(4).c.XGrid = 'on';
                ax(4).c.YGrid = 'on';
                ax(4).c.FontSize = 13;
                ax(4).c.XLabel.String = {'Charge (pC)'};
                ax(4).c.XLabel.FontSize = 22;
                ax(4).c.XLim = [0 11250+2250];
                ax(4).c.XTick = [0:2250:11250];
                ax(4).c.YTickLabel = [];
                
            else
                set([ax(4).v],'Layer','Top');
                set([ax(4).c],'Layer','Top');
                a = ax(4).v;
            end
            toTop = 1;
            el = 1;
            mk = 'd';
            shift = -200;
        case 'stim2ref1'
%             Color = [72 169 60]/255;
            Color = c2;
                set([ax(4).v],'Layer','Top');
                set([ax(4).c],'Layer','Top');
                a = ax(4).v;
                toTop = 0;
                el = 2;
                mk = 'o';
                shift = 200;
        case 'stim3ref2'
%             cw = [104 78 50];
%             Color = [cw]/255;
            Color = c3;
                set([ax(4).v],'Layer','Top');
                set([ax(4).c],'Layer','Top');
                a = ax(4).v;
                toTop = 0;
                el = 3;
                mk = '>';
                shift = 0;
    end
        
        
        
        mTemp = [extractedData.plots.(fs{h}).pextract];
        if isfield(extractedData.plots.(fs{h}),'pextractTrustUse')
        toChg = find(~[extractedData.plots.(fs{h}).pextractTrustUse]);
        mTemp(toChg) = NaN;
        end
        m = mean(mTemp,'omitnan');
        extractedData.plots.(fs{h}).mean = m;
        s = std([mTemp],'omitnan');
        extractedData.plots.(fs{h}).sd = s;
        x = extractedData.plots.(fs{h}).Amp;
        xc = extractedData.plots.(fs{h}).ampCalc(1,:);
        set(0,'CurrentFigure',velEcap.cur)
            hold(a,'on')
            bars = errorbar(a,x+shift/400,m,s,'color','k','LineWidth',1.5,'LineStyle','none');%,'marker','o','MarkerSize',10);
            plots.eP(tot) = plot(a,x,m,'color',Color,'marker',mk,'MarkerSize',8,'LineWidth',2);                
            hold(a,'off')
            
            set(0,'CurrentFigure',velEcap.chg)
            hold(ax(4).c,'on')
            barsc = errorbar(ax(4).c,xc+shift/400,m,s,'color','k','LineWidth',1.5,'LineStyle','none');%,'marker','o','MarkerSize',10);
            plots.ePc(tot) = plot(ax(4).c,xc,m,'color',Color,'marker',mk,'MarkerSize',8,'LineWidth',2);  
            hold(ax(4).c,'off')
            eCAP(el).PostX = x;
            eCAP(el).PostY = m;
                if ~toTop
                    
                uistack(bars,'bottom')
                uistack(plots.eP(tot),'bottom')
                
                uistack(barsc,'bottom')
                uistack(plots.ePc(tot),'bottom')
                else  
                
            end
                tot = tot +1;

            
            aLetter = 'F';
            nE = [];
            nXT = repmat([x],size(mTemp,1),1);
            nanIds = isnan(mTemp);
            nXT(nanIds) = NaN;
            nX = [];
            for bla = 1:size(mTemp,1)
                nE = [nE mTemp(bla,:)];
                nX = [nX nXT(bla,:)];
            end
%             nE(isnan(nE)) = [];
%             nX(isnan(nX)) = [];
%             if length(toExpIntraOpECAP.Animal) == 1
%                 b = 1:length(nE);
%                 toExpIntraOpECAP.Animal(b) = repmat({aLetter},length(nE),1);
%                 toExpIntraOpECAP.Electrode(b) = repmat({[el]},length(nE),1);
%                 toExpIntraOpECAP.TimeRecorded(b) = repmat({'Post'},length(nE),1);
%                 toExpIntraOpECAP.Amp(b) = num2cell(nX);
%                 toExpIntraOpECAP.ECAP(b) = num2cell(nE);
%                 toExpIntraOpECAP.ECAPnorm(b) = repmat({'NA'},length(nE),1);
%             else
%                 b = length(toExpIntraOpECAP.Animal)+1:length(toExpIntraOpECAP.Animal)+length(nE);
%                 toExpIntraOpECAP.Animal(b) = repmat({aLetter},length(nE),1);
%                 toExpIntraOpECAP.Electrode(b) = repmat({[el]},length(nE),1);
%                 toExpIntraOpECAP.TimeRecorded(b) = repmat({'Post'},length(nE),1);
%                 toExpIntraOpECAP.Amp(b) = num2cell(nX);
%                 toExpIntraOpECAP.ECAP(b) = num2cell(nE);
%                 toExpIntraOpECAP.ECAPnorm(b) = repmat({'NA'},length(nE),1);
%             end
        
end
save([path,name],'extractedData')

sameaxes([],[ax(3).v ax(4).v])
sameaxes([],[ax(1).c ax(2).c ax(3).c ax(4).c])
%  writetable(toExpIntraOpEyeV,[path,'Fred-IntraOp-PreandPost-EyeV.csv'])
%  writetable(toExpIntraOpECAP,[path,'Fred-IntraOp-PreandPost-ECAP.csv'])

saveas(velEcap.cur,[path,'Fred-IntraOp-PreandPostcurrentVsEyeVelocity_currentVsECAP.svg']);
saveas(velEcap.cur,[path,'Fred-IntraOp-PreandPostcurrentVsEyeVelocity_currentVsECAP.jpg']);
saveas(velEcap.cur,[path,'Fred-IntraOp-PreandPostcurrentVsEyeVelocity_currentVsECAP.fig']);
%%
toPull = 40:20:160;
preI = ismember(eyeV(1).PreX,toPull);
postI = ismember(eyeV(1).PostX,toPull);
[p,h,stats] = signrank(eyeV(1).PostY(postI),eyeV(1).PreY(preI),'alpha',0.01,'tail','right')


[p,h,stats] = signrank(eCAP(1).PostY,eCAP(1).PreY,'alpha',0.01,'tail','right')

[p,h,stats] = signrank(eCAP(2).PostY,eCAP(2).PreY,'alpha',0.01,'tail','right')

[p,h,stats] = signrank(eCAP(3).PostY,eCAP(3).PreY,'alpha',0.01,'tail','right')

%% TO PLOT ALL ELECTRODE COMBINATIONS BOTH EYE VELOCITY AND ECAP
Letter = {'G', 'D', 'F'};
velEcap = struct();
allPd = [];
for q = 1:3
aLetter = Letter{q};
velEcap(q).cur = figure('units','normalized','outerposition',[0 0 1 1]);
sgtitle(velEcap(q).cur,{['Stimulus Current vs. Eye Velocity Magnitude and eCAP, Animal ',aLetter]},'FontSize', 22, 'FontWeight', 'Bold');
switch aLetter
    case 'G'
        dd = load('R:\Dai\Research\Monkey paper 10 reference electrodes\Monkey paper 10 reference electrodes\Figures\data\2010-11-05 RhGigi-electrode characterization and location test\Cycles\CycleParams.mat');
        path = 'R:\Morris, Brian\Papers\ECAP Paper\GiGi Data\ECAP Data\';
        name = 'GiGiCondensedECAPData.mat';
        add = [path,'GiGi'];
        tp = 8;
        col = [0 1 0];
    case 'D'
        dd = load('R:\Morris, Brian\Condensed Dai Data\2010-11-04 RhDidi-electrode characterization and location test\Cycles\CycleParams.mat');
        path = 'R:\Morris, Brian\Condensed Dai Data\2010-11-04 RhDidi-electrode characterization and location test\MAESTRO\';
        name = 'DidiCondensedECAPData.mat';
        add = [path,'DiDi'];
        tp = 9;
        col = [0 0 1];
    case 'F'
        dd = load('R:\Morris, Brian\Condensed Dai Data\2011-05-25-RhFred Electrode characterization\For ECAP Paper\cycles\CycleParams.mat');
        path = 'R:\Morris, Brian\Condensed Dai Data\Fred Pre-Post Revision ECAP Analysis\Post revision - Post surgery\';
        name = 'Fred-PostRevision-CondensedECAPData.mat';
        add = [path,'Fred'];
        tp = 9;
        col = [1 0 0];
end

load([path,name])
% Plot Velocity First
toExpAll = table({NaN},{NaN},{NaN},{NaN},{NaN},{NaN},{NaN},'VariableNames',{'Animal','Electrode','ElectrodeA','EyeV','ECAP','EyeVnorm','ECAPnorm'});
toExpMean = table({NaN},{NaN},{NaN},{NaN},{NaN},{NaN},{NaN},'VariableNames',{'Animal2','Electrode2','ElectrodeA2','EyeVmean','ECAPmean','EyeVnormmean','ECAPnormmean'});

fs = fields(extractedData.plots);
axs = struct();

ax = struct();
ax(2).v = [];
ax(3).v = [];
plots = struct();
d = [{'dd'}];%{'g620'},{'g621'},{'g624'},{'g626'},{'g628'}];
tot = 1;
x = [];
x2 = [];
y = [];
y2 = [];
ldgLARP =[];
ldgRALP =[];
ldgLHRH =[];
extractData = struct();
extractData.LARP = [];
extractData.RALP = [];
extractData.LHRH = [];
exM = [];
exS = [];
minNumCycV = 0;
minNumCycE = 0;
maxNumCycV = 0;
maxNumCycE = 0;
for i = 1:length(d)
    idNum = 1;
    for j = 1:length(getfield(eval(d{i}),'tempS'))
%         c1 = [0.6 0.6 0.6];
%         c2 = [0.3 0.3 0.3];
%         c3 = [0 0 0];
            c3 = [0 0 0];
            c2 = [0 0 0];
            c1 = [0 0 0];
            mkSIZE = 8;
        switch getfield(eval(d{i}),'tempS',{j},'stim')
            case 1
                %ca = [255 166 158];
                %Color = [ca]/255;
                Color = c1;
                mk = 'd'; 
                f = 'stim1ref2';
                el = 'stim1';
                ldgName = 'Stimulating Electrode, Shallow';%'Stimulating Electrode Posterior, Shallow';
                a = 1;
                c = [1 0 0];
            shift = -200;
            case 2
                %Color = [72 169 60]/255;
                Color = c2;
                mk = 'o';
                f = 'stim2ref1';
                el = 'stim2';
                ldgName = 'Stimulating Electrode, Middle';%'Stimulating Electrode Posterior, Middle';
                a = 1;
                c = [0 1 0];
            shift = 200;
            case 3
                %cw = [104 78 50];
                %Color = [cw]/255;
                Color = c3;
                mk = '>';
                f = 'stim3ref2';
                el = 'stim3';
                ldgName = 'Stimulating Electrode, Deep';%'Stimulating Electrode Posterior, Deep';
                a = 1;
                c = [0 0 1];
            shift = 0;
            case 4
                %Color = [13 0 164]/255;
                Color = c1;
                mk = 'X';
                f = 'stim4ref5';
                el = 'stim4';
                ldgName = 'Stimulating Electrode, Shallow';%'Stimulating Electrode Anterior, Shallow';
                a = 2;
                c = [1 0 0];
            shift = -200;
            case 5
                %cy=   [255 196 61];
                %Color = [cy]/255;
                Color = c2;
                mk =  'p';
                f = 'stim5ref4';
                el = 'stim5';
                ldgName = 'Stimulating Electrode, Middle';%'Stimulating Electrode Anterior, Middle';
                a = 2;
                c = [0 1 0];
            shift = 200;
            case 6
                %Color = [3 157 201]/255;
                Color = c3;
                mk = 'v';
                f = 'stim6ref5';
                el = 'stim6';
                ldgName = 'Stimulating Electrode, Deep';%'Stimulating Electrode Anterior, Deep';
                a = 2;
                c = [0 0 1];
            shift = 0;
            case 7
                %Color = [215 38 56]/255;
                Color = c3;
                mk =  '<';
                f = 'stim7ref8';
                el = 'stim7';
                ldgName = 'Stimulating Electrode, Deep';%'Stimulating Electrode Horizontal, Deep';
                a = 3;
                c = [0 0 1];
            shift = -200;
            case 8
                %cx = [183 184 104];
                %Color = [cx]/255;
                Color = c2;
                mk = 's';
                f = 'stim8ref7';
                el = 'stim8';
                ldgName = 'Stimulating Electrode, Middle';%'Stimulating Electrode Horizontal, Middle';
                a = 3;
                c = [0 1 0];
            shift = 200;
            case 9
                %Color = [219 108 35]/255;
                Color = c1;
                mk = '^';
                f = 'stim9ref8';
                el = 'stim9';
                ldgName = 'Stimulating Electrode, Shallow';%'Stimulating Electrode Horizontal, Shallow';
                a = 3;
                c = [1 0 0];
            shift = 0;
            case 10
                Color = [57 61 63]/255;
            case 11
                c = [128 147 241];
                Color = [c]/255;
        end
        
        if minNumCycV == 0
            minNumCycV = length([getfield(eval(d{i}),'tempS',{j},'MagRF')]);
        else
            minNumCycV = min([minNumCycV length([getfield(eval(d{i}),'tempS',{j},'MagRF')])]);
        end
        maxNumCycV = max([maxNumCycV length([getfield(eval(d{i}),'tempS',{j},'MagRF')])]);
        
        if strcmp(getfield(eval(d{i}),'tempS',{j},'dir'),'RALP')
            if isempty(ax(1).v)
                
                ax(1).v = subtightplot(2,3,1,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', velEcap(q).cur);
                ax(1).v.LineWidth = 2.5;
                ax(1).v.XGrid = 'on';
                ax(1).v.YGrid = 'on';
                ax(1).v.FontSize = 12;
                ax(1).v.XLabel.String = {'Current (uA)'};
                ax(1).v.XLabel.FontSize = 22;
                ax(1).v.YLabel.String = {'Velocity (dps)'};
                ax(1).v.YLabel.FontSize = 22;
                ax(1).v.XLim = [0 200+10];
                ax(1).v.XTick = [0:20:200];
                ax(1).v.Title.String = 'RALP';
                
            else
                set([ax(1).v],'Layer','Top');
            end
            x = [x str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'))];
            
            y = [y mean([getfield(eval(d{i}),'tempS',{j},'MisalignRF')])];
            y2 = [y2 [getfield(eval(d{i}),'tempS',{j},'MisalignRF')]];
            ly2 = length([getfield(eval(d{i}),'tempS',{j},'MisalignRF')]);
            x2 = [x2 repmat(str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'))*getfield(eval(d{i}),'tempS',{j},'p1d'),1,ly2)];
            e = ['e',num2str(getfield(eval(d{i}),'tempS',{j},'stim'))];
            %if str2num(getfield(eval(d{i}),'tempS',{j},'p1amp')) == 120
                extractData.RALP.(e)(idNum).amp = str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'));
                extractData.RALP.(e)(idNum).v = mean([getfield(eval(d{i}),'tempS',{j},'MisalignRF')]);
                extractData.RALP.(e)(idNum).sd = std([getfield(eval(d{i}),'tempS',{j},'MisalignRF')]);
                 [a,b] = max(abs([getfield(eval(d{i}),'tempS',{j},'M3DRF')]));
                extractData.RALP.(e)(idNum).v3d = [getfield(eval(d{i}),'tempS',{j},'M3DRF',{b(1),1}) getfield(eval(d{i}),'tempS',{j},'M3DRF',{b(2),2}) getfield(eval(d{i}),'tempS',{j},'M3DRF',{b(3),3})];
                
                
            %end
            hold(ax(1).v,'on')
            %plots.vP(tot) = plot(ax(1).v,str2num(getfield(eval(d{i}),'tempS',{j},'p1amp')),mean([getfield(eval(d{i}),'tempS',{j},'MisalignRF')]),'color',Color,'LineWidth',3,'marker',mk,'MarkerSize',9);
            plots.vPEB(tot) = errorbar(ax(1).v,str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'))+shift/400,mean([getfield(eval(d{i}),'tempS',{j},'MisalignRF')]),std([getfield(eval(d{i}),'tempS',{j},'MisalignRF')]),'color','k','LineWidth',2);
            if str2num(getfield(eval(d{i}),'tempS',{j},'p1amp')) == 100
                extractedData.plots.(f).eyeVel = mean([getfield(eval(d{i}),'tempS',{j},'MisalignRF')]);
                extractedData.plots.(f).eyeVelSTD = std([getfield(eval(d{i}),'tempS',{j},'MisalignRF')]);
            end
            tot = tot +1;
            if j<length(getfield(eval(d{i}),'tempS'))
                if getfield(eval(d{i}),'tempS',{j},'stim')~=getfield(eval(d{i}),'tempS',{j+1},'stim')
                    ldgRALP = [ldgRALP, {ldgName}];%[ldgRALP, {['Stim ',num2str(getfield(eval(d{i}),'tempS',{j},'stim'))]}];
                    plots.vPLRALP(length(ldgRALP)) = line(ax(1).v,x,y,'color',c,'LineWidth',2,'marker',mk,'MarkerSize',mkSIZE);
                    %plots.vR(length(ldgRALP)) = {ns};
                    extractedData.plots.(f).all.v = y2;
                    extractedData.plots.(f).all.vAmp = x2;
                    x2 = [];
                    y2 = [];
                    x = [];
                    y = [];
                    idNum = 1;
                else
                    idNum = idNum + 1;
                end
            elseif (j==length(getfield(eval(d{i}),'tempS')))
                ldgRALP = [ldgRALP, {ldgName}];%[ldgRALP, {['Stim ',num2str(getfield(eval(d{i}),'tempS',{j},'stim'))]}];
                plots.vPLRALP(length(ldgRALP)) = line(ax(1).v,x,y,'color',c,'LineWidth',2,'marker',mk,'MarkerSize',mkSIZE);
                    %plots.vR(length(ldgRALP)) = {ns};
                    extractedData.plots.(f).all.v = y2;
                    extractedData.plots.(f).all.vAmp = x2;
                    x2 = [];
                    y2 = [];
                        x = [];
                        y = [];
            end
            hold(ax(1).v,'off')
            
        elseif strcmp(getfield(eval(d{i}),'tempS',{j},'dir'),'LARP')
            if isempty(ax(2).v)
                ax(2).v = subtightplot(2,3,2,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', velEcap(q).cur);
                ax(2).v.LineWidth = 2.5;
                ax(2).v.XGrid = 'on';
                ax(2).v.YGrid = 'on';
                ax(2).v.FontSize = 12;
                ax(2).v.XLabel.String = {'Current (uA)'};
                ax(2).v.XLabel.FontSize = 22;
                ax(2).v.XLim = [0 200+10];
                ax(2).v.XTick = [0:20:200];
                ax(2).v.YTickLabel = [];
                ax(2).v.Title.String = 'LARP';
                
            else
                set([ax(2).v],'Layer','Top');
            end
            x = [x str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'))];
            y = [y mean([getfield(eval(d{i}),'tempS',{j},'MisalignRF')])];
            y2 = [y2 [getfield(eval(d{i}),'tempS',{j},'MisalignRF')]];
            ly2 = length([getfield(eval(d{i}),'tempS',{j},'MisalignRF')]);
            x2 = [x2 repmat(str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'))*getfield(eval(d{i}),'tempS',{j},'p1d'),1,ly2)];
            
            %if str2num(getfield(eval(d{i}),'tempS',{j},'p1amp')) == 120
                e = ['e',num2str(getfield(eval(d{i}),'tempS',{j},'stim'))];
                extractData.LARP.(e)(idNum).amp = str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'));
                extractData.LARP.(e)(idNum).v = mean([getfield(eval(d{i}),'tempS',{j},'MisalignRF')]);
                extractData.LARP.(e)(idNum).sd = std([getfield(eval(d{i}),'tempS',{j},'MisalignRF')]);
                 [a,b] = max(abs([getfield(eval(d{i}),'tempS',{j},'M3DRF')]));
                extractData.LARP.(e)(idNum).v3d = [getfield(eval(d{i}),'tempS',{j},'M3DRF',{b(1),1}) getfield(eval(d{i}),'tempS',{j},'M3DRF',{b(2),2}) getfield(eval(d{i}),'tempS',{j},'M3DRF',{b(3),3})];

                
            %end
            hold(ax(2).v,'on')
            %plots.vP(tot) = plot(ax(2).v,str2num(getfield(eval(d{i}),'tempS',{j},'p1amp')),mean([getfield(eval(d{i}),'tempS',{j},'MisalignRF')]),'color',Color,'LineWidth',3,'marker',mk,'MarkerSize',9);
            plots.vPEB(tot) = errorbar(ax(2).v,str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'))+shift/400,mean([getfield(eval(d{i}),'tempS',{j},'MisalignRF')]),std([getfield(eval(d{i}),'tempS',{j},'MisalignRF')]),'color','k','LineWidth',2);
            if str2num(getfield(eval(d{i}),'tempS',{j},'p1amp')) == 100
                     extractedData.plots.(f).eyeVel = mean([getfield(eval(d{i}),'tempS',{j},'MisalignRF')]);
                extractedData.plots.(f).eyeVelSTD = std([getfield(eval(d{i}),'tempS',{j},'MisalignRF')]);
            end
            tot = tot +1;
            if getfield(eval(d{i}),'tempS',{j},'stim') == 4
                mkSIZE = 15;
            end
            if j<length(getfield(eval(d{i}),'tempS'))
                if getfield(eval(d{i}),'tempS',{j},'stim')~=getfield(eval(d{i}),'tempS',{j+1},'stim')
                    ldgLARP = [ldgLARP, {ldgName}];%[ldgLARP, {['Stim ',num2str(getfield(eval(d{i}),'tempS',{j},'stim'))]}];
                    plots.vPLLARP(length(ldgLARP)) = line(ax(2).v,x,y,'color',c,'LineWidth',2,'marker',mk,'MarkerSize',mkSIZE);
                    %plots.vL(length(ldgLARP)) = {ns};
                    extractedData.plots.(f).all.v = y2;
                    extractedData.plots.(f).all.vAmp = x2;
                    x2 = [];
                    y2 = [];
                    x = [];
                    y = [];
                    idNum = 1;
                else
                    idNum = idNum +1;
                end
            elseif (j==length(getfield(eval(d{i}),'tempS')))
                ldgLARP = [ldgLARP, {ldgName}];%[ldgLARP, {['Stim ',num2str(getfield(eval(d{i}),'tempS',{j},'stim'))]}];
                plots.vPLLARP(length(ldgLARP)) = line(ax(2).v,x,y,'color',c,'LineWidth',2,'marker',mk,'MarkerSize',mkSIZE);
                    %plots.vL(length(ldgLARP)) = {ns};
                    extractedData.plots.(f).all.v = y2;
                    extractedData.plots.(f).all.vAmp = x2;
                    x2 = [];
                    y2 = [];
                x = [];
                y = [];
            end
            hold(ax(2).v,'off')
        elseif strcmp(getfield(eval(d{i}),'tempS',{j},'dir'),'LHRH')
            if isempty(ax(3).v)
                ax(3).v = subtightplot(2,3,3,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', velEcap(q).cur);
                ax(3).v.LineWidth = 2.5;
                ax(3).v.XGrid = 'on';
                ax(3).v.YGrid = 'on';
                ax(3).v.FontSize = 12;
                ax(3).v.XLabel.String = {'Current (uA)'};
                ax(3).v.XLabel.FontSize = 22;
                ax(3).v.XLim = [0 200+10];
                ax(3).v.XTick = [0:20:200];
                ax(3).v.YTickLabel = [];
                ax(3).v.Title.String = 'LHRH';
            else
                set([ax(3).v],'Layer','Top');
            end
            x = [x str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'))];
            y = [y mean([getfield(eval(d{i}),'tempS',{j},'MisalignRF')])];
            y2 = [y2 [getfield(eval(d{i}),'tempS',{j},'MisalignRF')]];
            ly2 = length([getfield(eval(d{i}),'tempS',{j},'MisalignRF')]);
            x2 = [x2 repmat(str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'))*getfield(eval(d{i}),'tempS',{j},'p1d'),1,ly2)];
            
            %if str2num(getfield(eval(d{i}),'tempS',{j},'p1amp')) == 120
                e = ['e',num2str(getfield(eval(d{i}),'tempS',{j},'stim'))];
                extractData.LHRH.(e)(idNum).amp = str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'));
                extractData.LHRH.(e)(idNum).v = mean([getfield(eval(d{i}),'tempS',{j},'MisalignRF')]);
                extractData.LHRH.(e)(idNum).sd = std([getfield(eval(d{i}),'tempS',{j},'MisalignRF')]);
                 [a,b] = max(abs([getfield(eval(d{i}),'tempS',{j},'M3DRF')]));
                extractData.LHRH.(e)(idNum).v3d = [getfield(eval(d{i}),'tempS',{j},'M3DRF',{b(1),1}) getfield(eval(d{i}),'tempS',{j},'M3DRF',{b(2),2}) getfield(eval(d{i}),'tempS',{j},'M3DRF',{b(3),3})];

            %end
            hold(ax(3).v,'on')
            %plots.vP(tot) = plot(ax(3).v,str2num(getfield(eval(d{i}),'tempS',{j},'p1amp')),mean([getfield(eval(d{i}),'tempS',{j},'MisalignRF')]),'color',Color,'LineWidth',2,'marker',mk,'MarkerSize',9);
            plots.vPEB(tot) = errorbar(ax(3).v,str2num(getfield(eval(d{i}),'tempS',{j},'p1amp'))+shift/400,mean([getfield(eval(d{i}),'tempS',{j},'MisalignRF')]),std([getfield(eval(d{i}),'tempS',{j},'MisalignRF')]),'color','k','LineWidth',2);
            if str2num(getfield(eval(d{i}),'tempS',{j},'p1amp')) == 100
                extractedData.plots.(f).eyeVel = mean([getfield(eval(d{i}),'tempS',{j},'MisalignRF')]);
                extractedData.plots.(f).eyeVelSTD = std([getfield(eval(d{i}),'tempS',{j},'MisalignRF')]);
            end
            tot = tot +1;
            if j<length(getfield(eval(d{i}),'tempS'))
                if getfield(eval(d{i}),'tempS',{j},'stim')~=getfield(eval(d{i}),'tempS',{j+1},'stim')
                    ldgLHRH = [ldgLHRH, {ldgName}];%[ldgLHRH, {['Stim ',num2str(getfield(eval(d{i}),'tempS',{j},'stim'))]}];
                    plots.vPLLHRH(length(ldgLHRH)) = line(ax(3).v,x,y,'color',c,'LineWidth',2,'marker',mk,'MarkerSize',mkSIZE);
                    %plots.vZ(length(ldgLHRH)) = {ns};
                    extractedData.plots.(f).all.v = y2;
                    extractedData.plots.(f).all.vAmp = x2;
                    x2 = [];
                    y2 = [];
                    x = [];
                    y = [];
                    idNum = 1;
                else
                    idNum = idNum +1;
                end
            elseif (j==length(getfield(eval(d{i}),'tempS')))
                ldgLHRH = [ldgLHRH, {ldgName}];%[ldgLHRH, {['Stim ',num2str(getfield(eval(d{i}),'tempS',{j},'stim'))]}];
                plots.vPLLHRH(length(ldgLHRH)) = line(ax(3).v,x,y,'color',c,'LineWidth',2,'marker',mk,'MarkerSize',mkSIZE);
                    %plots.vZ(length(ldgLHRH)) = {ns};
                x = [];
                y = [];
            end
            hold(ax(3).v,'off')
        end

    end
    if i == length(d)
        lR = legend(ax(1).v,[plots.vPLRALP],[ldgRALP]);
        lR.Position = [0.0703    0.8471    0.13    0.0583];
        lL = legend(ax(2).v,[plots.vPLLARP],[ldgLARP]);  
        lL.Position = [0.3688    0.8471    0.13    0.0583];
        lZ = legend(ax(3).v,flip([plots.vPLLHRH]),flip([ldgLHRH]));  
        lZ.Position = [0.6696    0.8471    0.13    0.0583];
        sameaxes([],[ax(1).v ax(2).v ax(3).v])
        uistack(ax(2).v, 'top')
        uistack(ax(3).v, 'top')
        
    end
end
end
%%
function [r,rsquare] = calcRSquare(x,y)
Xsum = sum(x);
Ysum = sum(y);
XY = sum(x.*y);
XSquare = sum(x.^2);
YSquare = sum(y.^2);
n = length(x);
r = ((n*XY)-(Xsum*Ysum))/sqrt((n*XSquare-(Xsum^2))*(n*YSquare-(Ysum^2)));
rsquare = r^2;
end