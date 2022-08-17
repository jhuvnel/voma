load('R:\Morris, Brian\Monkey Data\Nancy\20191118\Cycles\CycleParams.mat')
%%
HOidd = find(ismember([tempS.stim],[8]));
HIidd = find(ismember([tempS.stim],[15]));
AOidd = find(ismember([tempS.stim],[5]));
AIidd = find(ismember([tempS.stim],[14]));
pairedH = struct();
pairedH.stim = [];
pairedH.ref = [];
pairedH.curr = [];
pairedH.MeanMag = [];
pairedH.MeanMis = [];
pairedH.MagRatio = [];
pairedH.MisRatio = [];
pairedH.MagD = [];
pairedH.MisD = [];
pairedH.facial = [];
pairedH.IDS = [];
pairedA = pairedH;

canal = {};
stimLoc = {};
refLoc = {};
current = {};
mag = [];
mis = [];

HOn = 1;
s = [];
rS = [];
c = [];
MM = [];
MMis = [];
MR = [];
MisR = [];
MD = [];
MisD = [];
f = [];
IDS = [];
while (HOn <= length(HOidd))
    r = tempS(HOidd(HOn)).ref;
    a = tempS(HOidd(HOn)).p1amp;
%     if ~any(r==[7 8 9 4 5 6])
    rs = find(ismember([tempS(HIidd).ref],r));
    as = find(ismember([tempS(HIidd(rs)).p1amp],a));
    if ~all(all(ismember(rS,r)))
       pairedH.stim = [pairedH.stim {s}];
       pairedH.ref = [pairedH.ref {rS}];
       pairedH.curr = [pairedH.curr {c}];
       pairedH.MeanMag = [pairedH.MeanMag {MM}];
       pairedH.MeanMis = [pairedH.MeanMis {MMis}];
       pairedH.MagRatio = [pairedH.MagRatio {MR}];
       pairedH.MisRatio = [pairedH.MisRatio {MisR}];
       pairedH.MagD = [pairedH.MagD {MD}];
       pairedH.MisD = [pairedH.MisD {MisD}];
       pairedH.facial = [pairedH.facial {f}];
       pairedH.IDS = [pairedH.IDS {IDS}];
        s = [];
        rS = [];
        c = [];
        MM = [];
        MMis = [];
        MR = [];
        MisR = [];
        MD = [];
        MisD = [];
        f = [];
        IDS = [];
    end
    
    if ~isempty(as)
            s = [s; tempS(HOidd(HOn)).stim tempS(HIidd(rs(as))).stim];
            rS = [rS; tempS(HOidd(HOn)).ref tempS(HIidd(rs(as))).ref];
            c = [c; tempS(HOidd(HOn)).p1amp tempS(HIidd(rs(as))).p1amp];
            MM = [MM; mean(tempS(HOidd(HOn)).MagL) mean(tempS(HIidd(rs(as))).MagL)];
            MMis = [MMis; mean(tempS(HOidd(HOn)).MisalignL) mean(tempS(HIidd(rs(as))).MisalignL)];
            MR = [MR; mean(tempS(HOidd(HOn)).MagL)/mean(tempS(HIidd(rs(as))).MagL)];
            MisR = [MisR; mean(tempS(HOidd(HOn)).MisalignL)/mean(tempS(HIidd(rs(as))).MisalignL)];
            MD = [MD; mean(tempS(HOidd(HOn)).MagL)-mean(tempS(HIidd(rs(as))).MagL)];
            MisD = [MisD; mean(tempS(HOidd(HOn)).MisalignL)-mean(tempS(HIidd(rs(as))).MisalignL)];
            f = [f; tempS(HOidd(HOn)).FacialNerve tempS(HIidd(rs(as))).FacialNerve];
            IDS = [IDS; (HOidd(HOn)) (HIidd(rs(as)))];
            if tempS(HOidd(HOn)).p1amp <= 150
                canal = [canal; {'horizontal'; 'horizontal'}];
                stimLoc = [stimLoc; {'outer'; 'inner'}];
                refLoc = [refLoc; {num2str(tempS(HOidd(HOn)).ref); num2str(tempS(HIidd(rs(as))).ref)}];
                current = [current; {num2str(tempS(HOidd(HOn)).p1amp); num2str(tempS(HIidd(rs(as))).p1amp)}];
                mag = [mag; mean(tempS(HOidd(HOn)).MagL); mean(tempS(HIidd(rs(as))).MagL)];
                mis = [mis; mean(tempS(HOidd(HOn)).MisalignL); mean(tempS(HIidd(rs(as))).MisalignL)];
            end
    end
%     end
    HOn = HOn+1;
    if (HOn > length(HOidd)) && (~isempty(s))
        pairedH.stim = [pairedH.stim {s}];
       pairedH.ref = [pairedH.ref {rS}];
       pairedH.curr = [pairedH.curr {c}];
       pairedH.MeanMag = [pairedH.MeanMag {MM}];
       pairedH.MeanMis = [pairedH.MeanMis {MMis}];
       pairedH.MagRatio = [pairedH.MagRatio {MR}];
       pairedH.MisRatio = [pairedH.MisRatio {MisR}];
       pairedH.MagD = [pairedH.MagD {MD}];
       pairedH.MisD = [pairedH.MisD {MisD}];
       pairedH.facial = [pairedH.facial {f}];
       pairedH.IDS = [pairedH.IDS {IDS}];
    end
    
end

AOn = 1;
s = [];
rS = [];
c = [];
MM = [];
MMis = [];
MR = [];
MisR = [];
MD = [];
MisD = [];
f = [];
IDS = [];
while (AOn <= length(AOidd))
    r = tempS(AOidd(AOn)).ref;
    a = tempS(AOidd(AOn)).p1amp;
%     if ~any(r==[7 8 9 4 5 6])
    rs = find(ismember([tempS(AIidd).ref],r));
    as = find(ismember([tempS(AIidd(rs)).p1amp],a));
    if ~all(all(ismember(rS,r)))
       pairedA.stim = [pairedA.stim {s}];
       pairedA.ref = [pairedA.ref {rS}];
       pairedA.curr = [pairedA.curr {c}];
       pairedA.MeanMag = [pairedA.MeanMag {MM}];
       pairedA.MeanMis = [pairedA.MeanMis {MMis}];
       pairedA.MagRatio = [pairedA.MagRatio {MR}];
       pairedA.MisRatio = [pairedA.MisRatio {MisR}];
       pairedA.MagD = [pairedA.MagD {MD}];
       pairedA.MisD = [pairedA.MisD {MisD}];
       pairedA.facial = [pairedA.facial {f}];
       pairedA.IDS = [pairedA.IDS {IDS}];
        s = [];
        rS = [];
        c = [];
        MM = [];
        MMis = [];
        MR = [];
        MisR = [];
        MD = [];
        MisD = [];
        f = [];
        IDS = [];
    end
    
    if ~isempty(as)
            s = [s; tempS(AOidd(AOn)).stim tempS(AIidd(rs(as))).stim];
            rS = [rS; tempS(AOidd(AOn)).ref tempS(AIidd(rs(as))).ref];
            c = [c; tempS(AOidd(AOn)).p1amp tempS(AIidd(rs(as))).p1amp];
            MM = [MM; mean(tempS(AOidd(AOn)).MagL) mean(tempS(AIidd(rs(as))).MagL)];
            MMis = [MMis; mean(tempS(AOidd(AOn)).MisalignL) mean(tempS(AIidd(rs(as))).MisalignL)];
            MR = [MR; mean(tempS(AOidd(AOn)).MagL)/mean(tempS(AIidd(rs(as))).MagL)];
            MisR = [MisR; mean(tempS(AOidd(AOn)).MisalignL)/mean(tempS(AIidd(rs(as))).MisalignL)];
            MD = [MD; mean(tempS(AOidd(AOn)).MagL)-mean(tempS(AIidd(rs(as))).MagL)];
            MisD = [MisD; mean(tempS(AOidd(AOn)).MisalignL)-mean(tempS(AIidd(rs(as))).MisalignL)];
            f = [f; tempS(AOidd(AOn)).FacialNerve tempS(AIidd(rs(as))).FacialNerve];
            IDS = [IDS; (AOidd(AOn)) (AIidd(rs(as)))];
            
            if tempS(AOidd(AOn)).p1amp <= 150
                canal = [canal; {'anterior'; 'anterior'}];
                stimLoc = [stimLoc; {'outer'; 'inner'}];
                refLoc = [refLoc; {num2str(tempS(AOidd(AOn)).ref); num2str(tempS(AIidd(rs(as))).ref)}];
                current = [current; {num2str(tempS(AOidd(AOn)).p1amp); num2str(tempS(AIidd(rs(as))).p1amp)}];
                mag = [mag; mean(tempS(AOidd(AOn)).MagL); mean(tempS(AIidd(rs(as))).MagL)];
                mis = [mis; mean(tempS(AOidd(AOn)).MisalignL); mean(tempS(AIidd(rs(as))).MisalignL)];
            end
    end
%     end
    AOn = AOn+1;
    if (AOn > length(AOidd)) && (~isempty(s))
        pairedA.stim = [pairedA.stim {s}];
       pairedA.ref = [pairedA.ref {rS}];
       pairedA.curr = [pairedA.curr {c}];
       pairedA.MeanMag = [pairedA.MeanMag {MM}];
       pairedA.MeanMis = [pairedA.MeanMis {MMis}];
       pairedA.MagRatio = [pairedA.MagRatio {MR}];
       pairedA.MisRatio = [pairedA.MisRatio {MisR}];
       pairedA.MagD = [pairedA.MagD {MD}];
       pairedA.MisD = [pairedA.MisD {MisD}];
       pairedA.facial = [pairedA.facial {f}];
       pairedA.IDS = [pairedA.IDS {IDS}];
    end
    
end
T = table(canal, stimLoc, refLoc, current, mag, mis);
writetable(T,'C:\Users\Brian\Desktop\invsoutdata.csv')
%%
f=figure('units','normalized','outerposition',[0 0 1 1]);
ah = subtightplot(2,2,1,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', f);
ahm = subtightplot(2,2,3,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', f);
aa = subtightplot(2,2,2,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', f);
aam = subtightplot(2,2,4,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', f);

for i = 1:length(pairedH.stim)
    switch pairedH.ref{i}(1,1)
        case 10
            c = [0.22,0.24,0.25];
        case 11
            c = [128 147 241]/255;
        case 12
            c = [147 92 188]/255;
        case 13
            c = [129 244 149]/255;
        case 7
            c = [0.84 0.15 0.22];
        case 9
            c = [0.86,0.42,0.14];
        case 4
           c = [0.05,0.00,0.64];
        case 6
            c = [0.01,0.62,0.79];
    end
    hold(ah,'on')
    plot(ah,pairedH.curr{i}(:,1),pairedH.MagRatio{i},'Color',c,'LineWidth',4,'Marker','o','MarkerSize',15)
    hold(ah,'off')
    
    hold(ahm,'on')
    plot(ahm,pairedH.curr{i}(:,1),pairedH.MisRatio{i},'Color',c,'LineWidth',4,'Marker','o','MarkerSize',15)
    hold(ahm,'off')
    
    switch pairedA.ref{i}(1,1)
        case 10
            c = [0.22,0.24,0.25];
        case 11
            c = [128 147 241]/255;
        case 12
            c = [147 92 188]/255;
        case 13
            c = [129 244 149]/255;
        case 7
            c = [0.84 0.15 0.22];
        case 9
            c = [0.86,0.42,0.14];
        case 4
           c = [0.05,0.00,0.64];
        case 6
            c = [0.01,0.62,0.79];
    end
    hold(aa,'on')
    plot(aa,pairedA.curr{i}(:,1),pairedA.MagRatio{i},'Color',c,'LineWidth',4,'Marker','o','MarkerSize',15)
    hold(aa,'off')
    
    hold(aam,'on')
    plot(aam,pairedA.curr{i}(:,1),pairedA.MisRatio{i},'Color',c,'LineWidth',4,'Marker','o','MarkerSize',15)
    hold(aam,'off')
    
end
aaa = [pairedH.MagRatio{1}'; pairedH.MagRatio{2}'; pairedH.MagRatio{3}' NaN NaN NaN NaN; pairedH.MagRatio{4}'; pairedH.MagRatio{5}' NaN NaN NaN ; pairedH.MagRatio{6}' NaN NaN NaN NaN];
% aaa = [pairedH.MagRatio{1}' NaN NaN NaN NaN; pairedH.MagRatio{2}'; pairedH.MagRatio{3}' NaN NaN NaN ; pairedH.MagRatio{4}' NaN NaN NaN NaN];
hold(ah,'on')
plot(ah,25:25:250,mean(aaa,'omitnan'),'Color','k','LineWidth',4,'Marker','o','MarkerSize',15)
errorbar(ah,25:25:250,mean(aaa,'omitnan'),std(aaa,'omitnan'),'color','k','LineWidth',2.5);
hold(ah,'off')
m1 = mean(aaa,'omitnan');
m1s = std(aaa,'omitnan');
aaa=aaa(:,2:6);
horizontalMag = mean(aaa(:)','omitnan')
horizontalMagSTD = std(aaa(:)','omitnan')

aaam = [pairedH.MisRatio{1}'; pairedH.MisRatio{2}'; pairedH.MisRatio{3}' NaN NaN NaN NaN; pairedH.MisRatio{4}'; pairedH.MisRatio{5}' NaN NaN NaN ; pairedH.MisRatio{6}' NaN NaN NaN NaN];
% aaam = [pairedH.MisRatio{1}' NaN NaN NaN NaN; pairedH.MisRatio{2}'; pairedH.MisRatio{3}' NaN NaN NaN ; pairedH.MisRatio{4}' NaN NaN NaN NaN];
hold(ahm,'on')
plot(ahm,25:25:250,mean(aaam,'omitnan'),'Color','k','LineWidth',4,'Marker','o','MarkerSize',15)
errorbar(ahm,25:25:250,mean(aaam,'omitnan'),std(aaam,'omitnan'),'color','k','LineWidth',2.5);
hold(ahm,'off')

m1 = mean(aaam,'omitnan');
m1s = std(aaam,'omitnan');
aaam=aaam(:,2:6);
horizontalMis = mean(aaam(:)','omitnan')
horizontalMisSTD = std(aaam(:)','omitnan')

aaaa = [pairedA.MagRatio{1}'; pairedA.MagRatio{2}'; pairedA.MagRatio{3}' NaN NaN NaN; pairedA.MagRatio{4}'; pairedA.MagRatio{5}' NaN NaN; pairedA.MagRatio{6}' NaN NaN NaN];
% aaaa = [pairedA.MagRatio{1}' NaN NaN NaN; pairedA.MagRatio{2}'; pairedA.MagRatio{3}' NaN NaN; pairedA.MagRatio{4}' NaN NaN NaN];
hold(aa,'on')
plot(aa,25:25:250,mean(aaaa,'omitnan'),'Color','k','LineWidth',4,'Marker','o','MarkerSize',15)
errorbar(aa,25:25:250,mean(aaaa,'omitnan'),std(aaaa,'omitnan'),'color','k','LineWidth',2.5);
hold(aa,'off')

m1 = mean(aaaa,'omitnan');
m1s = std(aaaa,'omitnan');
aaaa=aaaa(:,2:6);
antMag = mean(aaaa(:)','omitnan')
antMagSTD = std(aaaa(:)','omitnan')

aaaam = [pairedA.MisRatio{1}'; pairedA.MisRatio{2}'; pairedA.MisRatio{3}' NaN NaN NaN; pairedA.MisRatio{4}'; pairedA.MisRatio{5}' NaN NaN; pairedA.MisRatio{6}' NaN NaN NaN];
% aaaam = [pairedA.MisRatio{1}' NaN NaN NaN; pairedA.MisRatio{2}'; pairedA.MisRatio{3}' NaN NaN; pairedA.MisRatio{4}' NaN NaN NaN];
hold(aam,'on')
plot(aam,25:25:250,mean(aaaam,'omitnan'),'Color','k','LineWidth',4,'Marker','o','MarkerSize',15)
errorbar(aam,25:25:250,mean(aaaam,'omitnan'),std(aaaam,'omitnan'),'color','k','LineWidth',2.5);
hold(aam,'off')

m1 = mean(aaaam,'omitnan');
m1s = std(aaaam,'omitnan');
aaaam=aaaam(:,2:6);
antMis = mean(aaaam(:)','omitnan')
antMisSTD = std(aaaam(:)','omitnan')

ah.XTickLabel = [];
ah.XTick = [0:50:250];
ah.XGrid = 'on';
ah.YGrid = 'on';
ah.XLim = [0 300];
ah.FontSize = 25;
ah.Title.String = 'Horizontal outer/Inner';
ah.LineWidth = 2.5;
ah.Title.FontSize = 30;
ah.YLabel.String = 'VOR Magnitude Ratio';

ahm.XTickLabel = [];
ahm.XTick = [0:50:250];
ahm.XGrid = 'on';
ahm.YGrid = 'on';
ahm.XLim = [0 300];
ahm.FontSize = 25;
ahm.LineWidth = 2.5;
ahm.Title.FontSize = 30;
ahm.XLabel.String = 'Current uA';
ahm.YLabel.String = 'Misalignment Ratio';

aa.XTickLabel = [];
aa.XTick = [0:50:250];
aa.XGrid = 'on';
aa.YGrid = 'on';
aa.XLim = [0 300];
aa.FontSize = 25;
aa.Title.String = 'Anterior outer/Inner';
aa.LineWidth = 2.5;
aa.Title.FontSize = 30;

aam.XTickLabel = [];
aam.XTick = [0:50:250];
aam.XGrid = 'on';
aam.YGrid = 'on';
aam.XLim = [0 300];
aam.FontSize = 25;
aam.LineWidth = 2.5;
aam.Title.FontSize = 30;
aam.XLabel.String = 'Current uA';

sameaxes([],[ah aa]);
sameaxes([],[ahm aam]);
%%
f=figure('units','normalized','outerposition',[0 0 1 1]);
ah = subtightplot(2,2,1,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', f);
ahm = subtightplot(2,2,3,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', f);
aa = subtightplot(2,2,2,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', f);
aam = subtightplot(2,2,4,[0.025 0.000000000005],[0.10 0.075],[.05 .05],'Parent', f);

for i = 1:length(pairedH.stim)
    switch pairedH.ref{i}(1,1)
        case 10
            c = [0.22,0.24,0.25];
        case 11
            c = [128 147 241]/255;
        case 12
            c = [147 92 188]/255;
        case 13
            c = [129 244 149]/255;
        case 7
            c = [0.84 0.15 0.22];
        case 9
            c = [0.86,0.42,0.14];
        case 4
           c = [0.05,0.00,0.64];
        case 6
            c = [0.01,0.62,0.79];
    end
    hold(ah,'on')
    plot(ah,pairedH.curr{i}(:,1),pairedH.MagD{i},'Color',c,'LineWidth',4,'Marker','o','MarkerSize',15)
    hold(ah,'off')
    
    hold(ahm,'on')
    plot(ahm,pairedH.curr{i}(:,1),pairedH.MisD{i},'Color',c,'LineWidth',4,'Marker','o','MarkerSize',15)
    hold(ahm,'off')
    
    switch pairedA.ref{i}(1,1)
        case 10
            c = [0.22,0.24,0.25];
        case 11
            c = [128 147 241]/255;
        case 12
            c = [147 92 188]/255;
        case 13
            c = [129 244 149]/255;
        case 7
            c = [0.84 0.15 0.22];
        case 9
            c = [0.86,0.42,0.14];
        case 4
           c = [0.05,0.00,0.64];
        case 6
            c = [0.01,0.62,0.79];
    end
    hold(aa,'on')
    plot(aa,pairedA.curr{i}(:,1),pairedA.MagD{i},'Color',c,'LineWidth',4,'Marker','o','MarkerSize',15)
    hold(aa,'off')
    
    hold(aam,'on')
    plot(aam,pairedA.curr{i}(:,1),pairedA.MisD{i},'Color',c,'LineWidth',4,'Marker','o','MarkerSize',15)
    hold(aam,'off')
    
end

aaa = [pairedH.MisD{1}'; pairedH.MagD{2}'; pairedH.MagD{3}' NaN NaN NaN NaN; pairedH.MagD{4}'; pairedH.MagD{5}' NaN NaN NaN ; pairedH.MagD{6}' NaN NaN NaN NaN];
hold(ah,'on')
plot(ah,pairedH.curr{1}(:,1),mean(aaa,'omitnan'),'Color','k','LineWidth',4,'Marker','o','MarkerSize',15)
errorbar(ah,pairedH.curr{1}(:,1),mean(aaa,'omitnan'),std(aaa,'omitnan'),'color','k','LineWidth',2.5);
hold(ah,'off')

aaam = [pairedH.MisD{1}'; pairedH.MisD{2}'; pairedH.MisD{3}' NaN NaN NaN NaN; pairedH.MisD{4}'; pairedH.MisD{5}' NaN NaN NaN ; pairedH.MisD{6}' NaN NaN NaN NaN];
hold(ahm,'on')
plot(ahm,pairedH.curr{1}(:,1),mean(aaam,'omitnan'),'Color','k','LineWidth',4,'Marker','o','MarkerSize',15)
errorbar(ahm,pairedH.curr{1}(:,1),mean(aaam,'omitnan'),std(aaam,'omitnan'),'color','k','LineWidth',2.5);
hold(ahm,'off')

aaaa = [pairedA.MagD{1}'; pairedA.MagD{2}'; pairedA.MagD{3}' NaN NaN NaN; pairedA.MagD{4}'; pairedA.MagD{5}' NaN NaN; pairedA.MagD{6}' NaN NaN NaN];
hold(aa,'on')
plot(aa,pairedA.curr{1}(:,1),mean(aaaa,'omitnan'),'Color','k','LineWidth',4,'Marker','o','MarkerSize',15)
errorbar(aa,pairedA.curr{1}(:,1),mean(aaaa,'omitnan'),std(aaaa,'omitnan'),'color','k','LineWidth',2.5);
hold(aa,'off')

aaaam = [pairedA.MisD{1}'; pairedA.MisD{2}'; pairedA.MisD{3}' NaN NaN NaN; pairedA.MisD{4}'; pairedA.MisD{5}' NaN NaN; pairedA.MisD{6}' NaN NaN NaN];
hold(aam,'on')
plot(aam,pairedA.curr{1}(:,1),mean(aaaam,'omitnan'),'Color','k','LineWidth',4,'Marker','o','MarkerSize',15)
errorbar(aam,pairedA.curr{1}(:,1),mean(aaaam,'omitnan'),std(aaaam,'omitnan'),'color','k','LineWidth',2.5);
hold(aam,'off')

ah.XTickLabel = [];
ah.XTick = [0:50:250];
ah.XGrid = 'on';
ah.YGrid = 'on';
ah.XLim = [0 300];
ah.FontSize = 25;
ah.Title.String = 'Horizontal outer-Inner';
ah.LineWidth = 2.5;
ah.Title.FontSize = 30;
ah.YLabel.String = 'VOR Magnitude Difference';

ahm.XTickLabel = [];
ahm.XTick = [0:50:250];
ahm.XGrid = 'on';
ahm.YGrid = 'on';
ahm.XLim = [0 300];
ahm.FontSize = 25;
ahm.LineWidth = 2.5;
ahm.Title.FontSize = 30;
ahm.XLabel.String = 'Current uA';
ahm.YLabel.String = 'Misalignment Difference';

aa.XTickLabel = [];
aa.XTick = [0:50:250];
aa.XGrid = 'on';
aa.YGrid = 'on';
aa.XLim = [0 300];
aa.FontSize = 25;
aa.Title.String = 'Anterior outer-Inner';
aa.LineWidth = 2.5;
aa.Title.FontSize = 30;

aam.XTickLabel = [];
aam.XTick = [0:50:250];
aam.XGrid = 'on';
aam.YGrid = 'on';
aam.XLim = [0 300];
aam.FontSize = 25;
aam.LineWidth = 2.5;
aam.Title.FontSize = 30;
aam.XLabel.String = 'Current uA';