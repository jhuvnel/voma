%%
handles = struct();
handles.cycDir = 'R:\Dai\Research\Monkey paper 10 reference electrodes\Monkey paper 10 reference electrodes\Figures\data\2010-11-05 RhGigi-electrode characterization and location test\Cycles\';
handles.listing = dir(handles.cycDir);
handles.listing([handles.listing.bytes]==0)=[];
[cs,index] = sort_nat({handles.listing.name});
handles.listing = handles.listing(index);
if any(contains({handles.listing.name},'CycleParam'))
    di = find(contains({handles.listing.name},'CycleParam'));
    load([handles.listing(di).folder,'\',handles.listing(di).name])
    handles.tempS = tempS;
    handles.listing(di) = [];
end

handles.leFlag = 0;
handles.reFlag = 1;
handles.skipFlag = 0;
handles.yestoall = 0;
handles.notoall = 0;
handles.toFlag = 0;
handles.rewrite = 0;
handles.goBackFlag = 0;
handles.fig = figure;
set(handles.fig,...
    'WindowButtonDownFcn',   @mouseDownCallback, ...
    'WindowButtonUpFcn',     @mouseUpCallback,   ...
    'WindowButtonMotionFcn', @mouseMotionCallback,...
    'WindowKeyPressFcn', @confirmButton);
handles.ax = axes;
handles.ax.Units = 'Pixels';
handles.fig.Position = [1 41 1920 963];
handles.ax.Position = [50 107 1550 785];
handles.txa = uicontrol('style','text',...
    'string',{'To use cycle: Click Enter or right mouse button';'To reject cycle: Click shift or scroll wheel'},...
    'backgroundcolor','w');
handles.txa.Position = [20 20 250 40];
handles.cycList = uicontrol('Style','listbox','Callback',@cycListCall);
handles.cycList.Position = [1610 400 300 500];
handles.ax2 = axes;
handles.ax2.Units = 'Pixels';
handles.ax2.Position = [1620 107 135 250];
handles.ax2.Title.String = 'Eye Vel';
handles.ax3 = axes;
handles.ax3.Units = 'Pixels';
handles.ax3.Position = [1775 107 135 250];
handles.ax3.Title.String = 'Misalignment';
handles.txa2 = uicontrol('style','text','string','Blank out of a total of Blank cycles will be used','backgroundcolor','w');
handles.txa2.Position = [1610 910 300 50];
handles.txa2.FontSize = 15;
handles.back = uicontrol('style','pushbutton','String','Go Back','Callback',@backCallback);
handles.back.Position = [850 20 200 50];
handles.back.FontSize = 17;
handles.zero = uicontrol('style','pushbutton','String','Remove Offset','Callback',@zeroCallback);
handles.zero.Position = [1620 20 200 50];
handles.zero.FontSize = 17;
%handles.cycList.String(1) = {['<HTML><FONT color="red">',handles.cycList.String{1},'</FONT></HTML>']}
if handles.reFlag
    hold(handles.ax,'on')
    handles.plot.stim = plot(handles.ax,[0],[0],'k');
    handles.plot.rl = plot(handles.ax,[0],[0],'g');
    handles.plot.rr = plot(handles.ax,[0],[0],'b');
    handles.plot.rz = plot(handles.ax,[0],[0],'r');
    legend([handles.plot.rl,handles.plot.rr,handles.plot.rz],{'LARP','RALP','LHRH'})
    handles.plot.firstPt = plot(handles.ax,[0],[0],'k');
    handles.plot.secondPt = plot(handles.ax,[0],[0],'m');
    handles.t1 = text(handles.ax,1.25,handles.ax.YLim(2)*(4/5),' ');
    handles.t2 = text(handles.ax,80,handles.ax.YLim(2)*(4/5),' ');
    hold(handles.ax,'off')
    hold(handles.ax2,'on')
    handles.spV = scatter(handles.ax2,[],[],50);
    handles.errV = errorbar(handles.ax2,[0],[0],[0]);
    hold(handles.ax2,'off')
    hold(handles.ax3,'on')
    handles.spM = scatter(handles.ax3,[],[],50);
    handles.errM = errorbar(handles.ax3,[0],[0],[0]);
    hold(handles.ax3,'on')
else
end
i = 1;
while i <= length(handles.listing)
    handles.i = i;
    handles.spV.XData = [];
    handles.spV.YData = [];
    handles.errV.XData = 0;
    handles.errV.YData = 0;
    handles.errV.YNegativeDelta = 0;
    handles.errV.YPositiveDelta = 0;
    
    handles.spM.XData = [];
    handles.spM.YData = [];
    handles.errM.XData = 0;
    handles.errM.YData = 0;
    handles.errM.YNegativeDelta = 0;
    handles.errM.YPositiveDelta = 0;
    if isfield(handles,'tempS')
        if any(contains({handles.tempS.name},handles.listing(i).name))
            %if contains(handles.listing(i).name,'stim2') || contains(handles.listing(i).name,'stim3')
            if (~handles.notoall) && (~handles.yestoall)
                if (~handles.goBackFlag)
                    answer = nbuttondlg([{[handles.listing(i).name,', Number ',num2str(i)]};{'This file already exsits, would you like to overwrite it?'}],{'Yes','No','Yes To All','No To All'},'DefaultButton',2,'PromptTextHeight',50);
                else
                    answer = 'Yes';
                end
                switch answer
                    case 'Yes'
                        handles.skipFlag = 0;
                        handles.rewrite = find(contains({handles.tempS.name},handles.listing(i).name));
                        
                    case 'No'
                        handles.skipFlag = 1;
                    case 'Yes To All'
                        handles.yestoall = 1;
                        handles.skipFlag = 0;
                        handles.rewrite = find(contains({handles.tempS.name},handles.listing(i).name));
                    case 'No To All'
                        handles.notoall = 1;
                        handles.skipFlag = 1;
                        handles.rewrite = 0;
                end
                
            end
            %else
            %   handles.skipFlag = 1;
            %end
        else
            handles.yestoall = 0;
            handles.notoall = 0;
            handles.skipFlag = 0;
            handles.rewrite = 0;
        end
    end
    if ~handles.skipFlag
        load([handles.listing(i).folder,'\',handles.listing(i).name])
        handles.Results = Results;
        handles.pos = 0;
        handles.goBackFlag = 0;
        handles.used = [];
        tN = handles.listing(i).name;
        tNP = find((tN=='-'));
        handles.aN = tN(1:tNP(1)-1);
        handles.d = tN(tNP(2)+1:tNP(3)-1);
        handles.di = tN(tNP(5)+1:tNP(6)-1);
        handles.ty = tN(tNP(7)+1:tNP(8)-1);
        rP = strfind(tN,'ref');
        handles.s = tN(tNP(6)+5:rP-1);
        handles.r = tN(rP+3:tNP(7)-1);
        bP = strfind(tN,'base');
        handles.a = tN(tNP(8)+4:bP-1);
        cycString = [];
        handles.cycList.String = [];
        for k = 1:length(Results.cyclist)
            cycString = [cycString {['Cycle ',num2str(k)]}];
        end
        handles.cycList.String = cycString;
        handles.cycList.UserData = cycString;
        handles.txa2.String = [num2str(length(Results.cyclist)),' out of a total of ',num2str(length(Results.cyclist)),' cycles will be used'];
        j = 1;
        handles.j = j;
        handles.prevJ = 0;
        while j <= length(Results.cyclist)
            handles.j = j;
            handles.toFlag = 0;
            handles.cycList.Value = j;
            if handles.leFlag
                cycLeng = length(Results.ll_cycavg);
                handles.stim = Results.stim(1+(cycLeng*(j-1)):cycLeng+(cycLeng*(j-1)));
                handles.t = [1:cycLeng]./100;
                
                handles.ll = Results.ll_cyc(j,:);
                handles.lr = Results.lr_cyc(j,:);
                handles.lz = Results.lz_cyc(j,:);
                if contains(Results.name,'LARP')
                    [~,handles.firstPt]=max(handles.ll(1:250));
                    [~,handles.secondPt]=min(handles.ll(251:cycLeng));
                    handles.pureRot = [1 0 0];
                    handles.rotSign = 1;
                elseif contains(Results.name,'RALP')
                    [~,handles.firstPt]=max(handles.lr(1:250));
                    [~,handles.secondPt]=min(handles.lr(251:cycLeng));
                    handles.pureRot = [0 1 0];
                    handles.rotSign = 1;
                elseif contains(Results.name,'LHRH')
                    [~,handles.firstPt]=min(handles.lz(1:250));
                    [~,handles.secondPt]=max(handles.lz(251:cycLeng));
                    handles.pureRot = [0 0 1];
                    handles.rotSign = -1;
                end
                handles.secondPt = handles.secondPt +250;
                %                 if ~isfield(handles,'fig')
                %                     handles.fig = figure;
                %                     set(handles.fig,...
                %                         'WindowButtonDownFcn',   @mouseDownCallback, ...
                %                         'WindowButtonUpFcn',     @mouseUpCallback,   ...
                %                         'WindowButtonMotionFcn', @mouseMotionCallback);
                %                     handles.ax = axes;
                %                     handles.ax.Units = 'Pixels';
                %                     handles.fig.Position = [1 41 1920 963];
                %                     handles.ax.Position = [250 107 1488 785];
                %
                %                 else
                %                     if ~ishandle(handles.fig) || ((i == 1) && (j == 1))
                %                         handles.fig = figure;
                %                         set(handles.fig,...
                %                             'WindowButtonDownFcn',   @mouseDownCallback, ...
                %                             'WindowButtonUpFcn',     @mouseUpCallback,   ...
                %                             'WindowButtonMotionFcn', @mouseMotionCallback);
                %                         handles.ax = axes;
                %                         handles.ax.Units = 'Pixels';
                %                         handles.fig.Position = [1 41 1920 963];
                %                         handles.ax.Position = [250 107 1488 785];
                %                     end
                %                 end
                handles.plot.stim = plot(handles.t,handles.stim,'k');
                hold on
                handles.plot.ll = plot(handles.t,handles.ll,'g');
                handles.plot.lr = plot(handles.t,handles.lr,'b');
                handles.plot.lz = plot(handles.t,handles.lz,'r');
                handles.plot.firstPt = plot(repmat(handles.t(handles.firstPt),1,1000),linspace(handles.ax.YLim(1),handles.ax.YLim(2),1000),'k');
                handles.plot.secondPt = plot(repmat(handles.t(handles.secondPt),1,1000),linspace(handles.ax.YLim(1),handles.ax.YLim(2),1000),'m');
                handles.t1 = text(1.25,handles.ax.YLim(2)*(4/5),' ');
                handles.t2 = text(3.75,handles.ax.YLim(2)*(4/5),' ');
                [MagLF, MisLF, M3DLF, iF, MagLS, MisLS, M3DLS, iS] = magAndMis(handles);
                legend([handles.plot.ll,handles.plot.lr,handles.plot.lz],{'LARP','RALP','LHRH'})
                if isfield(handles,'tempS')
                    if ~(i > length(handles.tempS))
                        if ~isempty(handles.tempS(i).MagLF)
                            txt = {['Cyc Mag: ',num2str(MagLF)];['Avg Mag: ',num2str(mean(handles.tempS(i).MagLF))];['Cyc Mis: ',num2str(MisLF)];['Avg Mis: ',num2str(mean(handles.tempS(i).MisalignLF))]};
                            handles.t1.String = txt;
                            txt = {['CyC Mag: ',num2str(MagLS)];['Avg Mag: ',num2str(mean(handles.tempS(i).MagLS))];['Cyc Mis: ',num2str(MisLS)];['Avg Mis: ',num2str(mean(handles.tempS(i).MisalignLS))]};
                            handles.t2.String = txt;
                        else
                            txt = {['Cyc Mag: ',num2str(MagLF)];['Cyc Mis: ',num2str(MisLF)]};
                            handles.t1.String = txt;
                            txt = {['Cyc Mag: ',num2str(MagLS)];['Cyc Mis: ',num2str(MisLS)]};
                            handles.t2.String = txt;
                        end
                    else
                        txt = {['Cyc Mag: ',num2str(MagLF)];['Cyc Mis: ',num2str(MisLF)]};
                        handles.t1.String = txt;
                        txt = {['Cyc Mag: ',num2str(MagLS)];['Cyc Mis: ',num2str(MisLS)]};
                        handles.t2.String = txt;
                    end
                else
                    txt = {['Cyc Mag: ',num2str(MagLF)];['Cyc Mis: ',num2str(MisLF)]};
                    handles.t1.String = txt;
                    txt = {['Cyc Mag: ',num2str(MagLS)];['Cyc Mis: ',num2str(MisLS)]};
                    handles.t2.String = txt;
                end
                hold off
                handles.ax.Title.String = [handles.aN,', ',handles.di,', Stim',handles.s,', Ref',handles.r,', ',handles.a,'uA, ',num2str(j),' of ',num2str(length(Results.cyclist))];
                
                guidata(handles.fig,handles);
                uiwait
                handles = guidata(handles.fig);
                if handles.rewrite>0
                    in = handles.rewrite;
                else
                    in = i;
                end
                if handles.toFlag == 1
                    
                    if j == 1
                        a = handles.d;
                        b = str2num(handles.s);
                        c = str2num(handles.r);
                        e = handles.a;
                        f = handles.di;
                        
                        handles.tempS(in).date = a;
                        handles.tempS(in).name = handles.listing(i).name;
                        handles.tempS(in).stim = b;
                        handles.tempS(in).ref = c;
                        handles.tempS(in).eCombs = [b,c];
                        handles.tempS(in).p1d = 200;
                        handles.tempS(in).ipg = 0;
                        handles.tempS(in).p2d = 200;
                        handles.tempS(in).p1amp = e;
                        handles.tempS(in).p2amp = e;
                        handles.tempS(in).dSp2d = -1;
                        handles.tempS(in).cycavgL = [];
                        handles.tempS(in).timeL = [];
                        handles.tempS(in).stdL = [];
                        handles.tempS(in).MagLF = [];
                        handles.tempS(in).MisalignLF = [];
                        handles.tempS(in).M3DLF = [];
                        handles.tempS(in).iF = [];
                        handles.tempS(in).MagLS = [];
                        handles.tempS(in).MisalignLS = [];
                        handles.tempS(in).M3DLS = [];
                        handles.tempS(in).iS = [];
                        handles.tempS(in).FacialNerve = 0;
                        handles.tempS(in).dir = f;
                    end
                    [MagLF, MisLF, M3DLF, iF, MagLS, MisLS, M3DLS, iS] = magAndMis(handles);
                    
                    handles.tempS(in).MagLF = [handles.tempS(in).MagLF MagLF];
                    handles.tempS(in).MisalignLF = [handles.tempS(in).MisalignLF MisLF];
                    handles.tempS(in).M3DLF = [handles.tempS(in).M3DLF; M3DLF];
                    handles.tempS(in).iF = [handles.tempS(in).iF iF];
                    
                    handles.tempS(in).MagLS = [handles.tempS(in).MagLS MagLS];
                    handles.tempS(in).MisalignLS = [handles.tempS(in).MisalignLS MisLS];
                    handles.tempS(in).M3DLS = [handles.tempS(in).M3DLS; M3DLS];
                    handles.tempS(in).iS = [handles.tempS(in).iS iS];
                    
                    
                    handles.tempS(in).timeL = [handles.tempS(in).timeL;handles.stim];
                    handles.used = [handles.used Results.cyclist(j)];
                    handles.tempS(in).used = handles.used;
                elseif handles.toFlag == 3
                    close(handles.fig)
                    break
                elseif (handles.toFlag == 2) && (j == 1)
                    a = handles.d;
                    b = str2num(handles.s);
                    c = str2num(handles.r);
                    e = handles.a;
                    f = handles.di;
                    handles.tempS(in).date = a;
                    handles.tempS(in).name = handles.listing(in).name;
                    handles.tempS(in).stim = b;
                    handles.tempS(in).ref = c;
                    handles.tempS(in).eCombs = [b,c];
                    handles.tempS(in).p1d = 200;
                    handles.tempS(in).ipg = 0;
                    handles.tempS(in).p2d = 200;
                    handles.tempS(in).p1amp = e;
                    handles.tempS(in).p2amp = e;
                    handles.tempS(in).dSp2d = -1;
                    if isempty(handles.tempS(in).cycavgL)
                        handles.tempS(in).cycavgL = [];
                        handles.tempS(in).timeL = [];
                        handles.tempS(in).stdL = [];
                        handles.tempS(in).MagLF = [];
                        handles.tempS(in).MisalignLF = [];
                        handles.tempS(in).M3DLF = [];
                        handles.tempS(in).iF = [];
                        handles.tempS(in).MagLS = [];
                        handles.tempS(in).MisalignLS = [];
                        handles.tempS(in).M3DLS = [];
                        handles.tempS(in).iS = [];
                    end
                    handles.tempS(in).FacialNerve = 0;
                    handles.tempS(in).dir = f;
                end
                if j == length(Results.cyclist)
                    same = ismember(Results.cyclist,handles.tempS(in).used);
                    handles.tempS(in).cycavgL = [mean(Results.ll_cyc(same,:))' mean(Results.lr_cyc(same,:))' mean(Results.lz_cyc(same,:))'];
                    handles.tempS(in).stdL = [std(Results.ll_cyc(same,:))' std(Results.lr_cyc(same,:))' std(Results.lz_cyc(same,:))'];
                end
                cla(handles.ax)
                
                %%%%%%%%%%%%%%%%%
            elseif handles.reFlag
                cycLeng = length(Results.stim)/length(Results.cyclist);
                handles.stim = Results.stim(1+(cycLeng*(j-1)):cycLeng+(cycLeng*(j-1)));
                handles.t = [1:cycLeng];
                handles.cycList.Value = j;
                if isfield(Results,'adjusted')
                    handles.rlO = Results.adjusted.rlO;
                    handles.rrO = Results.adjusted.rrO;
                    handles.rzO = Results.adjusted.rzO;
                    handles.rl = Results.rl_cyc(j,1:cycLeng)-handles.rlO;
                    handles.rr = Results.rr_cyc(j,1:cycLeng)-handles.rrO;
                    handles.rz = Results.rz_cyc(j,1:cycLeng)-handles.rzO;
                    handles.zero.BackgroundColor = 'g';
                else
                    handles.rl = Results.rl_cyc(j,1:cycLeng);
                    handles.rr = Results.rr_cyc(j,1:cycLeng);
                    handles.rz = Results.rz_cyc(j,1:cycLeng);
                    handles.zero.BackgroundColor = [0.94 0.94 0.94];
                end
                if contains(Results.name,'LARP')
                    [~,handles.firstPt]=max(handles.rl(1:round(cycLeng/2)));
                    [~,handles.secondPt]=min(handles.rl(round(cycLeng/2)+1:cycLeng));
                    handles.pureRot = [1 0 0];
                    handles.rotSign = 1;
                elseif contains(Results.name,'RALP')
                    [~,handles.firstPt]=max(handles.rr(1:round(cycLeng/2)));
                    [~,handles.secondPt]=min(handles.rr(round(cycLeng/2)+1:cycLeng));
                    handles.pureRot = [0 1 0];
                    handles.rotSign = 1;
                elseif contains(Results.name,'LHRH')
                    [~,handles.firstPt]=min(handles.rz(1:round(cycLeng/2)));
                    [~,handles.secondPt]=max(handles.rz(round(cycLeng/2)+1:cycLeng));
                    handles.pureRot = [0 0 1];
                    handles.rotSign = -1;
                end
                handles.secondPt = handles.secondPt +round(cycLeng/2);
                %                 if ~isfield(handles,'fig')
                %                     handles.fig = figure;
                %                     set(handles.fig,...
                %                         'WindowButtonDownFcn',   @mouseDownCallback, ...
                %                         'WindowButtonUpFcn',     @mouseUpCallback,   ...
                %                         'WindowButtonMotionFcn', @mouseMotionCallback,...
                %                         'WindowKeyPressFcn', @confirmButton);
                %                     handles.ax = axes;
                %                     handles.ax.Units = 'Pixels';
                %                     handles.fig.Position = [1 41 1920 963];
                %                     handles.ax.Position = [50 107 1550 785];
                %                     handles.txa = uicontrol('style','text',...
                %                        'string',{'To use cycle: Click Enter or right mouse button';'To reject cycle: Click shift or scroll wheel'},...
                %                        'backgroundcolor','w');
                %                    handles.txa.Position = [20 20 250 40];
                %                    handles.cycList = uicontrol('Style','listbox');
                %                    handles.cycList.Position = [1610 400 300 500];
                %                    handles.ax2 = axes;
                %                    handles.ax2.Units = 'Pixels';
                %                    handles.ax2.Position = [1630 107 270 250];
                %                    handles.txa2 = uicontrol('style','text','string','Blank out of a total of Blank cycles will be used','backgroundcolor','w');
                %                     handles.txa2.Position = [1610 910 300 50];
                %                     handles.txa2.FontSize = 15;
                %                 else
                %                     if ~ishandle(handles.fig) || ((i == 1) && (j == 1))
                %                         handles.fig = figure;
                %                         set(handles.fig,...
                %                             'WindowButtonDownFcn',   @mouseDownCallback, ...
                %                             'WindowButtonUpFcn',     @mouseUpCallback,   ...
                %                             'WindowButtonMotionFcn', @mouseMotionCallback,...
                %                             'WindowKeyPressFcn', @confirmButton);
                %                         handles.ax = axes;
                %                         handles.ax.Units = 'Pixels';
                %                         handles.fig.Position = [1 41 1920 963];
                %                         handles.ax.Position = [250 107 1488 785];
                %                         handles.txa = uicontrol('style','text',...
                %                        'string',{'To use cycle: Click Enter or right mouse button';'To reject cycle: Click shift or scroll wheel'},...
                %                        'backgroundcolor','w');
                %                    handles.txa.Position = [20 20 250 40];
                %
                %                     end
                %                 end
                %                 handles.plot.stim = plot(handles.t,handles.stim,'k');
                %                 hold on
                %                 handles.plot.rl = plot(handles.t,handles.rl,'g');
                %                 handles.plot.rr = plot(handles.t,handles.rr,'b');
                %                 handles.plot.rz = plot(handles.t,handles.rz,'r');
                %                 legend([handles.plot.rl,handles.plot.rr,handles.plot.rz],{'LARP','RALP','LHRH'})
                %                 handles.plot.firstPt = plot(repmat(handles.t(handles.firstPt),1,1000),linspace(handles.ax.YLim(1),handles.ax.YLim(2),1000),'k');
                %                 handles.plot.secondPt = plot(repmat(handles.t(handles.secondPt),1,1000),linspace(handles.ax.YLim(1),handles.ax.YLim(2),1000),'m');
                %                 handles.t1 = text(1.25,handles.ax.YLim(2)*(4/5),' ');
                %                 handles.t2 = text(80,handles.ax.YLim(2)*(4/5),' ');
                if handles.rewrite>0
                    handles.rewrite = find(contains({handles.tempS.name},handles.listing(i).name));
                    handles.in = handles.rewrite;
                else
                    handles.in = i;
                end
                
                if isfield(handles,'tempS')
                    if ~(handles.in > length(handles.tempS))
                        if ~isempty(handles.tempS(handles.in).used)
                            if ismember(Results.cyclist(j),[handles.tempS(handles.in).used])
                                id = find(Results.cyclist(j)==[handles.tempS(handles.in).used]);
                                handles.firstPt = handles.tempS(handles.in).iF(id);
                                handles.secondPt = handles.tempS(handles.in).iS(id);
                            else
                            end
                        else
                        end
                    end
                end

                handles.t1.Position = [1.25 handles.ax.YLim(2)*(4/5) 0];
                handles.t2.Position = [80 handles.ax.YLim(2)*(4/5) 0];
                handles.plot.stim.XData = handles.t;
                handles.plot.stim.YData = handles.stim;
                if isfield(Results,'adjusted')
                    handles.plot.rl.YData = handles.rl-handles.rlO;
                    handles.plot.rr.YData = handles.rr-handles.rrO;
                    handles.plot.rz.YData = handles.rz-handles.rzO;
                else
                    handles.plot.rl.YData = handles.rl;
                    handles.plot.rr.YData = handles.rr;
                    handles.plot.rz.YData = handles.rz;
                end
                handles.plot.rl.XData = handles.t;
                handles.plot.rr.XData = handles.t;
                handles.plot.rz.XData = handles.t;
                
                handles.plot.firstPt.XData = repmat(handles.t(handles.firstPt),1,1000);
                handles.plot.firstPt.YData = linspace(handles.ax.YLim(1),handles.ax.YLim(2),1000);
                handles.plot.secondPt.XData = repmat(handles.t(handles.secondPt),1,1000);
                handles.plot.secondPt.YData = linspace(handles.ax.YLim(1),handles.ax.YLim(2),1000);
                [MagRF, MisRF, M3DRF, iF, MagRS, MisRS, M3DRS, iS] = magAndMisR(handles);
                if MagRF<40
                    handles.ax.YLim = [-20 40];
                else
                    handles.ax.YLim = [ -MagRF*(5/4) MagRF*(5/4)];
                end
                handles.t1.Position = [1.25 handles.ax.YLim(2)*(4/5) 0];
                handles.t2.Position = [80 handles.ax.YLim(2)*(4/5) 0];
                handles.plot.firstPt.XData = repmat(handles.t(handles.firstPt),1,1000);
                handles.plot.firstPt.YData = linspace(handles.ax.YLim(1),handles.ax.YLim(2),1000);
                handles.plot.secondPt.XData = repmat(handles.t(handles.secondPt),1,1000);
                handles.plot.secondPt.YData = linspace(handles.ax.YLim(1),handles.ax.YLim(2),1000);
                if isfield(handles,'tempS')
                    if ~(handles.in > length(handles.tempS))
                        if ~isempty(handles.tempS(handles.in).MagRF)
                            txt = {['Cyc Mag: ',num2str(MagRF)];['Avg Mag: ',num2str(mean(handles.tempS(handles.in).MagRF))];['Cyc Mis: ',num2str(MisRF)];['Avg Mis: ',num2str(mean(handles.tempS(handles.in).MisalignRF))]};
                            handles.t1.String = txt;
                            txt = {['CyC Mag: ',num2str(MagRS)];['Avg Mag: ',num2str(mean(handles.tempS(handles.in).MagRS))];['Cyc Mis: ',num2str(MisRS)];['Avg Mis: ',num2str(mean(handles.tempS(handles.in).MisalignRS))]};
                            handles.t2.String = txt;
                            handles.spV.XData = [];
                            handles.spV.YData = [];
                            handles.spM.XData = [];
                            handles.spM.YData = [];
                            for q = 1:length(Results.cyclist)
                                if ismember(Results.cyclist(q),[handles.tempS(handles.in).used])
                                    pt = find(Results.cyclist(q)==[handles.tempS(handles.in).used]);
                                    handles.spV.XData = [handles.spV.XData str2num(handles.a)];
                                    handles.spV.YData = [handles.spV.YData handles.tempS(handles.in).MagRF(pt)];
                                    handles.spM.XData = [handles.spM.XData str2num(handles.a)];
                                    handles.spM.YData = [handles.spM.YData handles.tempS(handles.in).MisalignRF(pt)];
                                else
                                    handles.spV.XData = [handles.spV.XData str2num(handles.a)];
                                    handles.spV.YData = [handles.spV.YData NaN];
                                    handles.spM.XData = [handles.spM.XData str2num(handles.a)];
                                    handles.spM.YData = [handles.spM.YData NaN];
                                    handles.cycList.String(q) = {['<HTML><FONT color="red">',handles.cycList.UserData{q},'</FONT></HTML>']};
                                end
                            end
                            
                            handles.errV.XData = str2num(handles.a);
                            handles.errV.YData = mean(handles.spV.YData(~isnan(handles.spV.YData)));
                            handles.errV.YNegativeDelta = std(handles.spV.YData(~isnan(handles.spV.YData)));
                            handles.errV.YPositiveDelta = std(handles.spV.YData(~isnan(handles.spV.YData)));
                            
                            
                            handles.errM.XData = str2num(handles.a);
                            handles.errM.YData = mean(handles.spM.YData(~isnan(handles.spM.YData)));
                            handles.errM.YNegativeDelta = std(handles.spM.YData(~isnan(handles.spM.YData)));
                            handles.errM.YPositiveDelta = std(handles.spM.YData(~isnan(handles.spM.YData)));
                            handles.txa2.String = [num2str(length(handles.tempS(handles.in).MagRS)),' out of a total of ',num2str(length(Results.cyclist)),' cycles will be used'];
                        else
                            txt = {['Cyc Mag: ',num2str(MagRF)];['Cyc Mis: ',num2str(MisRF)]};
                            handles.t1.String = txt;
                            txt = {['Cyc Mag: ',num2str(MagRS)];['Cyc Mis: ',num2str(MisRS)]};
                            handles.t2.String = txt;
                        end
                    else
                        txt = {['Cyc Mag: ',num2str(MagRF)];['Cyc Mis: ',num2str(MisRF)]};
                        handles.t1.String = txt;
                        txt = {['Cyc Mag: ',num2str(MagRS)];['Cyc Mis: ',num2str(MisRS)]};
                        handles.t2.String = txt;
                    end
                else
                    txt = {['Cyc Mag: ',num2str(MagRF)];['Cyc Mis: ',num2str(MisRF)]};
                    handles.t1.String = txt;
                    txt = {['Cyc Mag: ',num2str(MagRS)];['Cyc Mis: ',num2str(MisRS)]};
                    handles.t2.String = txt;
                end
                %                 hold off
                handles.ax.Title.String = [handles.aN,', ',handles.di,', Stim',handles.s,', Ref',handles.r,', ',handles.a,'uA, ',num2str(j),' of ',num2str(length(Results.cyclist))];
                
                if contains(handles.cycList.String(j),'red')
                    handles.fig.Color = 'r';
                else
                    handles.fig.Color = [0.94 0.94 0.94];
                end

                handles.res.cyc = Results.cyclist;
                guidata(handles.fig,handles);
                uiwait
                handles = guidata(handles.fig);
                if handles.rewrite>0
                    handles.rewrite = find(contains({handles.tempS.name},handles.listing(i).name));
                    handles.in = handles.rewrite;
                else
                    handles.in = i;
                end
                if handles.toFlag == 6
                    handles.j = 1;
                    j = 1;
                    load([handles.listing(i).folder,'\',handles.listing(i).name]);
                elseif handles.toFlag == 4
                    j = handles.j;
                elseif handles.toFlag == 5
                    handles.goBackFlag = 1;
                    handles.i = handles.i-1;
                    i = i - 1;
                    break
                elseif handles.toFlag == 1
                    [handles.MagRF, handles.MisRF, handles.M3DRF, handles.iF, handles.MagRS, handles.MisRS, handles.M3DRS, handles.iS] = magAndMisR(handles);
                    if isfield(handles,'tempS')
                        if ~(handles.in > length(handles.tempS))
                            if ~isempty(handles.tempS(handles.in).used)
                                if j == 1
                                    if ismember(Results.cyclist(j),[handles.tempS(handles.in).used])
                                        %REPLACE @ Beginning
                                        handles = SinusoidCycleAnalysisProcessing(handles,Results,3);
                                        handles.prevJ = j;
                                        j = j+1;
                                    else
                                        %Insert @ Beginning
                                        handles = SinusoidCycleAnalysisProcessing(handles,Results,2);
                                        handles.prevJ = j;
                                        j = j+1;
                                    end
                                else
                                    if ismember(Results.cyclist(j),[handles.tempS(handles.in).used])
                                        %REPLACE @ position
                                        handles = SinusoidCycleAnalysisProcessing(handles,Results,3);
                                        handles.prevJ = j;
                                        j = j+1;
                                    else
                                        %Insert @ position
                                        if handles.prevJ > j %Rejected and came back
                                            handles = SinusoidCycleAnalysisProcessing(handles,Results,5);
                                            handles.prevJ = j;
                                            j = j+1;
                                        else %first time
                                            handles = SinusoidCycleAnalysisProcessing(handles,Results,4);
                                            handles.prevJ = j;
                                            j = j+1;
                                        end
                                        
                                    end
                                end
                            else
                                handles = SinusoidCycleAnalysisProcessing(handles,Results,1);
                                handles.prevJ = j;
                                j = j+1;
                            end
                        else
                            handles = SinusoidCycleAnalysisProcessing(handles,Results,1);
                            handles.prevJ = j;
                            j = j+1;
                        end
                    else
                        handles = SinusoidCycleAnalysisProcessing(handles,Results,1);
                        handles.prevJ = j;
                        j = j+1;
                    end
                    %                     if j == 1 %First Cycle
                    %                         if handles.prevJ+1 == 1 %Analyzing for very first time
                    %                             if isempty(handles.spV.YData) %Extra confirmation, not really needed
                    %                                 handles = SinusoidCycleAnalysisProcessing(handles,Results,1);
                    %                                 handles.prevJ = j;
                    %                                 j = j+1;
                    %                             else
                    %                                 if isnan(handles.spV.YData(j)) %Cycle was previously rejected
                    %                                     handles = SinusoidCycleAnalysisProcessing(handles,Results,2);
                    %                                     handles.prevJ = j;
                    %                                     j = j+1;
                    %                                 else %Cycle was previously accepted
                    %                                     handles = SinusoidCycleAnalysisProcessing(handles,Results,3);
                    %                                     handles.prevJ = j;
                    %                                     j = j+1;
                    %                                 end
                    %                             end
                    %                         elseif handles.prevJ+1 > j %Reanalyzing
                    %                             if isnan(handles.spV.YData(j)) %Cycle was previously rejected
                    %                                 handles = SinusoidCycleAnalysisProcessing(handles,Results,2);
                    %                                 handles.prevJ = j;
                    %                                 j = j+1;
                    %                             else %Cycle was previously accepted
                    %                                 handles = SinusoidCycleAnalysisProcessing(handles,Results,3);
                    %                                 handles.prevJ = j;
                    %                                 j = j+1;
                    %                             end
                    %                         end
                    %                     else %Jth cycle
                    %                         if handles.prevJ+1 == j %like analyzing first time through
                    %                             if j>length(handles.tempS(handles.in).MagRF) %actually analyzing for first time
                    %                                 if isnan(handles.spV.YData(j)) %The cycle was previously rejected
                    %                                     handles = SinusoidCycleAnalysisProcessing(handles,Results,4);
                    %                                     handles.prevJ = j;
                    %                                     j = j+1;
                    %                                 else %The cycle was previously accepted
                    %                                     handles = SinusoidCycleAnalysisProcessing(handles,Results,4);
                    %                                     handles.prevJ = j;
                    %                                     j = j+1;
                    %                                 end
                    %                             else %Reanalyzing this cycle after reanalyzing previous cycle
                    %                                 if isnan(handles.spV.YData(j)) %The cycle was previously rejected
                    %                                     handles = SinusoidCycleAnalysisProcessing(handles,Results,5);
                    %                                     handles.prevJ = j;
                    %                                     j = j+1;
                    %                                 else %The cycle was previously accepted
                    %                                     handles = SinusoidCycleAnalysisProcessing(handles,Results,6);
                    %                                     handles.prevJ = j;
                    %                                     j = j+1;
                    %                                 end
                    %                             end
                    %                         elseif handles.prevJ+1 > j %Reanalyzing the Jth cycle in the list
                    %                             if isnan(handles.spV.YData(j)) %The cycle was previously rejected
                    %                                 handles = SinusoidCycleAnalysisProcessing(handles,Results,5);
                    %                                 handles.prevJ = j;
                    %                                 j = j+1;
                    %                             else %The cycle was previously accepted
                    %                                 handles = SinusoidCycleAnalysisProcessing(handles,Results,6);
                    %                                 handles.prevJ = j;
                    %                                 j = j+1;
                    %                             end
                    %                         end
                    %                     end
                elseif handles.toFlag == 3
                    close(handles.fig)
                    handles.prevJ = j;
                    j = j+1;
                    break
                    
                elseif (handles.toFlag == 2) && (j == 1) && (handles.prevJ+1==j)
                    if ~isempty(handles.tempS(handles.in).used)
                        if ismember(Results.cyclist(j),[handles.tempS(handles.in).used])
                            handles.cycList.String(j) = {['<HTML><FONT color="red">',handles.cycList.UserData{j},'</FONT></HTML>']};
                            pt = find(Results.cyclist(j)==[handles.tempS(handles.in).used]);
                            handles.tempS(handles.in).MagRF(pt) = [];
                            handles.tempS(handles.in).MisalignRF(pt) = [];
                            handles.tempS(handles.in).M3DRF(pt,:) = [];
                            handles.tempS(handles.in).iF(pt) = [];
                            
                            handles.tempS(handles.in).MagRS(pt) = [];
                            handles.tempS(handles.in).MisalignRS(pt) = [];
                            handles.tempS(handles.in).M3DRS(pt,:) = [];
                            handles.tempS(handles.in).iS(pt) = [];
                            
                            tb = (length(handles.stim)*(pt-1)+1):length(handles.stim)*(pt);
                            handles.tempS(handles.in).timeR(tb) = [];
                            handles.tempS(handles.in).used(pt) = [];
                        end
                    else
                        a = handles.d;
                        b = str2num(handles.s);
                        c = str2num(handles.r);
                        e = handles.a;
                        f = handles.di;
                        handles.tempS(handles.in).date = a;
                        handles.tempS(handles.in).name = handles.listing(handles.in).name;
                        handles.tempS(handles.in).stim = b;
                        handles.tempS(handles.in).ref = c;
                        handles.tempS(handles.in).eCombs = [b,c];
                        handles.tempS(handles.in).p1d = 200;
                        handles.tempS(handles.in).ipg = 0;
                        handles.tempS(handles.in).p2d = 200;
                        handles.tempS(handles.in).p1amp = e;
                        handles.tempS(handles.in).p2amp = e;
                        handles.tempS(handles.in).dSp2d = -1;
                        if isempty(handles.tempS(handles.in).cycavgR)
                            handles.tempS(handles.in).cycavgR = [];
                            handles.tempS(handles.in).timeR = [];
                            handles.tempS(handles.in).stdR = [];
                            handles.tempS(handles.in).MagRF = [];
                            handles.tempS(handles.in).MisalignRF = [];
                            handles.tempS(handles.in).M3DRF = [];
                            handles.tempS(handles.in).iF = [];
                            handles.tempS(handles.in).MagRS = [];
                            handles.tempS(handles.in).MisalignRS = [];
                            handles.tempS(handles.in).M3DRS = [];
                            handles.tempS(handles.in).iS = [];
                        end
                        handles.tempS(handles.in).FacialNerve = 0;
                        handles.tempS(handles.in).dir = f;
                        handles.cycList.String(j) = {['<HTML><FONT color="red">',handles.cycList.UserData{j},'</FONT></HTML>']};
                        %                     handles.spV.XData = [handles.spV.XData str2num(handles.a)];
                        %                     handles.spV.YData = [handles.spV.YData NaN];
                        %
                        %                     handles.spM.XData = [handles.spM.XData str2num(handles.a)];
                        %                     handles.spM.YData = [handles.spM.YData NaN];
                    end
                    handles.prevJ = j;
                    j = j+1;
                elseif handles.toFlag == 2
                    if ~ismember(Results.cyclist(j),[handles.tempS(handles.in).used])
                        handles.prevJ = j;
                        j = j+1;
                    else
                        handles.cycList.String(j) = {['<HTML><FONT color="red">',handles.cycList.UserData{j},'</FONT></HTML>']};
                        %                             handles.spV.XData(j) = str2num(handles.a);
                        %                             handles.spV.YData(j) = NaN;
                        %                             handles.errV.XData = str2num(handles.a);
                        %                             handles.errV.YData = mean(handles.spV.YData(~isnan(handles.spV.YData)));
                        %                             handles.errV.YNegativeDelta = std(handles.spV.YData(~isnan(handles.spV.YData)));
                        %                             handles.errV.YPositiveDelta = std(handles.spV.YData(~isnan(handles.spV.YData)));
                        %
                        %                             handles.spM.XData(j) = str2num(handles.a);
                        %                             handles.spM.YData(j) = NaN;
                        %                             handles.errM.XData = str2num(handles.a);
                        %                             handles.errM.YData = mean(handles.spM.YData(~isnan(handles.spM.YData)));
                        %                             handles.errM.YNegativeDelta = std(handles.spM.YData(~isnan(handles.spM.YData)));
                        %                             handles.errM.YPositiveDelta = std(handles.spM.YData(~isnan(handles.spM.YData)));
                        %
                        pt = find(Results.cyclist(j)==[handles.tempS(handles.in).used]);
                        handles.tempS(handles.in).MagRF(pt) = [];
                        handles.tempS(handles.in).MisalignRF(pt) = [];
                        handles.tempS(handles.in).M3DRF(pt,:) = [];
                        handles.tempS(handles.in).iF(pt) = [];
                        
                        handles.tempS(handles.in).MagRS(pt) = [];
                        handles.tempS(handles.in).MisalignRS(pt) = [];
                        handles.tempS(handles.in).M3DRS(pt,:) = [];
                        handles.tempS(handles.in).iS(pt) = [];
                        
                        tb = (length(handles.stim)*(pt-1)+1):length(handles.stim)*(pt);
                        handles.tempS(handles.in).timeR(tb) = [];
                        handles.tempS(handles.in).used(pt) = [];
                        handles.prevJ = j;
                        j = j+1;
                    end
                end
                if j > length(Results.cyclist)
                    same = ismember(Results.cyclist,handles.tempS(handles.in).used);
                    handles.tempS(handles.in).cycavgR = [mean(Results.rl_cyc(same,:))' mean(Results.rr_cyc(same,:))' mean(Results.rz_cyc(same,:))'];
                    handles.tempS(handles.in).stdR = [std(Results.rl_cyc(same,:))' std(Results.rr_cyc(same,:))' std(Results.rz_cyc(same,:))'];
                    tempS = handles.tempS;
                    save([handles.cycDir,'\CycleParams.mat'],'tempS')
                end
                %cla(handles.ax)
            end
            handles.txa2.String = [num2str(length(handles.tempS(handles.in).MagRS)),' out of a total of ',num2str(length(Results.cyclist)),' cycles will be used'];
        end
        if handles.toFlag == 3
            break
        end
    end
    if ~handles.skipFlag
        if (handles.toFlag ~= 3) || (handles.toFlag ~= 5)
            tempS = handles.tempS;
            save([handles.cycDir,'\CycleParams.mat'],'tempS')
        end
    end
    if ~handles.goBackFlag
        i = i+1;
    end
end
close(handles.fig)
% if (i == length(handles.listing)) && (handles.toFlag ~=3)
%     yestoall = 0;
%     skipFlag = 0;
%     notoall = 0;
%     if isfile([handles.cycDir,'\CycleParams.mat'])
%         load([handles.cycDir,'\CycleParams.mat']);
%
%         for k = 1:length(handles.tempS)
%             if any(contains({tempS.name},handles.tempS(k).name))
%                 if ~notoall || ~yestoll
%                     answer = nbuttondlg([{handles.tempS(k).name};{'This file already exsits, would you like to overwrite it?'}],{'Yes','No','Yes To All','No To All'},'DefaultButton',2,'PromptTextHeight',50);
%                     switch answer
%                         case 'Yes'
%                             skipFlag = 0;
%                         case 'No'
%                             skipFlag = 1;
%                         case 'Yes To All'
%                             yestoall = 1;
%                             skipFlag = 0;
%                         case 'No To All'
%                             notoall = 1;
%                             skipFlag = 1;
%                     end
%                 end
%             else
%                 tempS(:,end+1) = handles.tempS(:,k);
%             end
%             if ~skipFlag
%                 p = contains({tempS.name},handles.tempS(k).name);
%                 tempS(:,p) = handles.tempS(:,k);
%             end
%         end
%     else
%         tempS = struct();
%         tempS = handles.tempS;
%         save([handles.cycDir,'\CycleParams.mat'],'tempS')
%     end
%
% end
%%
function [MagLF, MisLF, M3DLF, iF, MagLS, MisLS, M3DLS, iS] = magAndMis(handles)
fI = single(handles.plot.firstPt.XData(1)*100);
sI = single(handles.plot.secondPt.XData(1)*100);

w = [handles.ll(fI) handles.lr(fI) handles.lz(fI)];
rotSign = handles.rotSign;
cosT = dot(rotSign*handles.pureRot,w)/(norm(rotSign*handles.pureRot)*norm(w));
MagLF = norm(w);
MisLF = acosd(cosT);
M3DLF = w;
iF = fI;

w = [handles.ll(sI) handles.lr(sI) handles.lz(sI)];
rotSign = -handles.rotSign;
cosT = dot(rotSign*handles.pureRot,w)/(norm(rotSign*handles.pureRot)*norm(w));
MagLS = norm(w);
MisLS = acosd(cosT);
M3DLS = w;
iS = sI;
end

function [MagRF, MisRF, M3DRF, iF, MagRS, MisRS, M3DRS, iS] = magAndMisR(handles)
fI = single(handles.plot.firstPt.XData(1));
sI = single(handles.plot.secondPt.XData(1));
if isfield(handles.Results,'adjusted')
    w = [handles.rl(fI)-handles.rlO handles.rr(fI)-handles.rrO handles.rz(fI)-handles.rzO];
rotSign = handles.rotSign;
cosT = dot(rotSign*handles.pureRot,w)/(norm(rotSign*handles.pureRot)*norm(w));
MagRF = norm(w);
MisRF = acosd(cosT);
M3DRF = w;
iF = fI;

w = [handles.rl(sI)-handles.rlO handles.rr(sI)-handles.rrO handles.rz(sI)-handles.rzO];
rotSign = -handles.rotSign;
cosT = dot(rotSign*handles.pureRot,w)/(norm(rotSign*handles.pureRot)*norm(w));
MagRS = norm(w);
MisRS = acosd(cosT);
M3DRS = w;
iS = sI;
else
w = [handles.rl(fI) handles.rr(fI) handles.rz(fI)];
rotSign = handles.rotSign;
cosT = dot(rotSign*handles.pureRot,w)/(norm(rotSign*handles.pureRot)*norm(w));
MagRF = norm(w);
MisRF = acosd(cosT);
M3DRF = w;
iF = fI;

w = [handles.rl(sI) handles.rr(sI) handles.rz(sI)];
rotSign = -handles.rotSign;
cosT = dot(rotSign*handles.pureRot,w)/(norm(rotSign*handles.pureRot)*norm(w));
MagRS = norm(w);
MisRS = acosd(cosT);
M3DRS = w;
iS = sI;
end
end

function cycListCall(figHandle,varargin)
handles = guidata(figHandle);

if handles.cycList.Value <= find(handles.tempS(handles.in).used(end)==handles.res.cyc)
    handles.prevJ = handles.j;
    handles.j = handles.cycList.Value;
    handles.toFlag = 4;
    guidata(figHandle,handles);
    uiresume
end
end

function backCallback(figHandle,varargin)
handles = guidata(figHandle);
if handles.i > 1
    handles.toFlag = 5;
    guidata(figHandle,handles);
    uiresume
end
end

function zeroCallback(figHandle,varargin)
handles = guidata(figHandle);
Results = handles.Results;
fSearch = [strrep(handles.listing(handles.i).name,'_CycleAvg.mat',''),'PRESTIM.mat'];
if isfile([strrep(handles.cycDir,'cycles','Segments'),'\',fSearch])
        subD = load([strrep(handles.cycDir,'cycles','Segments'),'\',fSearch]);
        g = post_CycleAvg_QPR_filt(subD,Results);
        Results.adjusted.name = fSearch;
        Results.adjusted.rlO = g.lO;
        Results.adjusted.rrO = g.rO;
        Results.adjusted.rzO = g.zO;
        handles.rlO = g.lO;
        handles.rrO = g.rO;
        handles.rzO = g.zO;
        Results.adjusted.boundsBegin = g.boundsBegin;
        Results.adjusted.boundsEnd = g.boundsEnd;
        save([handles.listing(handles.i).folder,'\',handles.listing(handles.i).name],'Results')
        handles.toFlag = 6;
        guidata(figHandle,handles);
        uiresume
end


% handles.rl = Results.rl_cyc(j,1:cycLeng)-handles.rlO;
%     handles.rr = Results.rr_cyc(j,1:cycLeng)-handles.rrO;
%     handles.rz = Results.rz_cyc(j,1:cycLeng)-handles.rzO;
%     if contains(Results.name,'LARP')
%         [~,handles.firstPt]=max(handles.rl(1:round(cycLeng/2)));
%         [~,handles.secondPt]=min(handles.rl(round(cycLeng/2)+1:cycLeng));
%         handles.pureRot = [1 0 0];
%         handles.rotSign = 1;
%     elseif contains(Results.name,'RALP')
%         [~,handles.firstPt]=max(handles.rr(1:round(cycLeng/2)));
%         [~,handles.secondPt]=min(handles.rr(round(cycLeng/2)+1:cycLeng));
%         handles.pureRot = [0 1 0];
%         handles.rotSign = 1;
%     elseif contains(Results.name,'LHRH')
%         [~,handles.firstPt]=min(handles.rz(1:round(cycLeng/2)));
%         [~,handles.secondPt]=max(handles.rz(round(cycLeng/2)+1:cycLeng));
%         handles.pureRot = [0 0 1];
%         handles.rotSign = -1;
%     end
%     handles.secondPt = handles.secondPt +round(cycLeng/2);
%     if handles.prevJ+1>j
%         if ~isnan(handles.spV.YData(j)) %The cycle was previously accepted
%             handles.firstPt = handles.tempS(handles.in).iF(j);
%             handles.secondPt = handles.tempS(handles.in).iS(j);
%         end
%     end
%     handles.plot.rl.YData = handles.plot.rl.YData-handles.rlO;
%     handles.plot.rr.YData = handles.plot.rr.YData-handles.rrO;
%     handles.plot.rz.YData = handles.plot.rz.YData-handles.rzO;
%     handles.plot.firstPt.XData = repmat(handles.t(handles.firstPt),1,1000);
%     handles.plot.secondPt.XData = repmat(handles.t(handles.secondPt),1,1000);
%     [MagRF, MisRF, M3DRF, iF, MagRS, MisRS, M3DRS, iS] = magAndMisR(handles);
    
    
end

function confirmButton(figHandle,varargin)
handles = guidata(figHandle);
if contains(varargin{1}.Key,'shift')
    handles.toFlag = 2;
    guidata(figHandle,handles);
    uiresume
elseif contains(varargin{1}.Key,'return')
    handles.toFlag = 1;
    handles.pos = handles.pos +1;
    guidata(figHandle,handles);
    uiresume
end
end
function mouseDownCallback(figHandle,varargin)
% get the handles structure
handles = guidata(figHandle);
% get the position where the mouse button was pressed (not released)
% within the GUI
if contains(figHandle.SelectionType,'normal')
    currentPoint = get(figHandle, 'CurrentPoint');
    x            = currentPoint(1,1);
    y            = currentPoint(1,2);
    % get the position of the axes within the GUI
    axesPos = get(handles.ax,'Position');
    minx    = axesPos(1);
    miny    = axesPos(2);
    maxx    = minx + axesPos(3);
    maxy    = miny + axesPos(4);
    % is the mouse down event within the axes?
    if x>=minx && x<=maxx && y>=miny && y<=maxy
        % do we have graphics objects?
        if isfield(handles,'plot')
            % get the position of the mouse down event within the axes
            currentPoint = get(handles.ax, 'CurrentPoint');
            x            = currentPoint(2,1);
            y            = currentPoint(2,2);
            % we are going to use the x and y data for each graphic object
            % and determine which one is closest to the mouse down event
            minDist      = Inf;
            minHndl      = 0;
            fieldN = fields(handles.plot);
            for k=5:length(fieldN)
                xData = get(handles.plot.(fieldN{k}),'XData');
                yData = get(handles.plot.(fieldN{k}),'YData');
                dist  = min((xData-x).^2+(yData-y).^2);
                if dist<minDist
                    minHndl = handles.plot.(fieldN{k});
                    minDist = dist;
                end
            end
            % if we have a graphics handle that is close to the mouse down
            % event/position, then save the data
            if minHndl~=0
                handles.mouseIsDown     = true;
                handles.movingPlotHndle = minHndl;
                handles.prevPoint       = [x y];
                guidata(figHandle,handles);
            end
        end
    else
        %         handles.toFlag = 3;
        %         guidata(figHandle,handles);
        %         uiresume
    end
elseif contains(figHandle.SelectionType,'extend')
    handles.toFlag = 2;
    guidata(figHandle,handles);
    uiresume
elseif contains(figHandle.SelectionType,'alt')
    handles.toFlag = 1;
    handles.pos = handles.pos +1;
    guidata(figHandle,handles);
    uiresume
end

end

function mouseUpCallback(figHandle,varargin)
% get the handles structure
handles = guidata(figHandle);
if isfield(handles,'mouseIsDown')
    if handles.mouseIsDown
        % reset all moving graphic fields
        handles.mouseIsDown     = false;
        handles.movingPlotHndle = [];
        handles.prevPoint       = [];
        % save the data
        guidata(figHandle,handles);
    end
end
end

function mouseMotionCallback(figHandle,varargin)
% get the handles structure
handles = guidata(figHandle);
if isfield(handles,'mouseIsDown')
    if handles.mouseIsDown
        currentPoint = get(handles.ax, 'CurrentPoint');
        x            = currentPoint(2,1);
        y            = currentPoint(2,2);
        xData = get(handles.movingPlotHndle,'XData');
        yData = get(handles.movingPlotHndle,'YData');
        % compute the displacement from previous position to current
        [a,b] = min(abs(handles.t-x));
        %xDiff = x - handles.prevPoint(1);
        xDiff = handles.t(b) - xData(1);
        yDiff = 0;
        % adjust this for the data corresponding to movingPlotHndle
        
        set(handles.movingPlotHndle,'YData',yData+yDiff,'XData',xData+xDiff);
        handles.prevPoint = [x y];
        % save the data
        i = handles.in;
        if handles.leFlag
            [MagLF, MisLF, M3DLF, iF, MagLS, MisLS, M3DLS, iS] = magAndMis(handles);
            if ~(i > length(handles.tempS))
                if ~isempty(handles.tempS(i).MagLF)
                    txt = {['Cyc Mag: ',num2str(MagLF)];['Avg Mag: ',num2str(mean(handles.tempS(i).MagLF))];['Cyc Mis: ',num2str(MisLF)];['Avg Mis: ',num2str(mean(handles.tempS(i).MisalignLF))]};
                    handles.t1.String = txt;
                    txt = {['CyC Mag: ',num2str(MagLS)];['Avg Mag: ',num2str(mean(handles.tempS(i).MagLS))];['Cyc Mis: ',num2str(MisLS)];['Avg Mis: ',num2str(mean(handles.tempS(i).MisalignLS))]};
                    handles.t2.String = txt;
                else
                    txt = {['Cyc Mag: ',num2str(MagLF)];['Cyc Mis: ',num2str(MisLF)]};
                    handles.t1.String = txt;
                    txt = {['Cyc Mag: ',num2str(MagLS)];['Cyc Mis: ',num2str(MisLS)]};
                    handles.t2.String = txt;
                end
            else
                txt = {['Cyc Mag: ',num2str(MagLF)];['Cyc Mis: ',num2str(MisLF)]};
                handles.t1.String = txt;
                txt = {['Cyc Mag: ',num2str(MagLS)];['Cyc Mis: ',num2str(MisLS)]};
                handles.t2.String = txt;
            end
        elseif handles.reFlag
            [MagRF, MisRF, M3DRF, iF, MagRS, MisRS, M3DRS, iS] = magAndMisR(handles);
            if isfield(handles,'tempS')
                if ~(i > length(handles.tempS))
                    if ~isempty(handles.tempS(i).MagRF)
                        txt = {['Cyc Mag: ',num2str(MagRF)];['Avg Mag: ',num2str(mean(handles.tempS(i).MagRF))];['Cyc Mis: ',num2str(MisRF)];['Avg Mis: ',num2str(mean(handles.tempS(i).MisalignRF))]};
                        handles.t1.String = txt;
                        txt = {['CyC Mag: ',num2str(MagRS)];['Avg Mag: ',num2str(mean(handles.tempS(i).MagRS))];['Cyc Mis: ',num2str(MisRS)];['Avg Mis: ',num2str(mean(handles.tempS(i).MisalignRS))]};
                        handles.t2.String = txt;
                    else
                        txt = {['Cyc Mag: ',num2str(MagRF)];['Cyc Mis: ',num2str(MisRF)]};
                        handles.t1.String = txt;
                        txt = {['Cyc Mag: ',num2str(MagRS)];['Cyc Mis: ',num2str(MisRS)]};
                        handles.t2.String = txt;
                    end
                else
                    txt = {['Cyc Mag: ',num2str(MagRF)];['Cyc Mis: ',num2str(MisRF)]};
                    handles.t1.String = txt;
                    txt = {['Cyc Mag: ',num2str(MagRS)];['Cyc Mis: ',num2str(MisRS)]};
                    handles.t2.String = txt;
                end
            else
                txt = {['Cyc Mag: ',num2str(MagRF)];['Cyc Mis: ',num2str(MisRF)]};
                handles.t1.String = txt;
                txt = {['Cyc Mag: ',num2str(MagRS)];['Cyc Mis: ',num2str(MisRS)]};
                handles.t2.String = txt;
            end
        end
        guidata(figHandle,handles);
    end
end
end