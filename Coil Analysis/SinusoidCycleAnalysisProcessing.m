function handles = SinusoidCycleAnalysisProcessing(handles,Results,order)
in = handles.in;
j = handles.j;
switch order
    case 1 %Analyzing the first cycle in the list for the very first time
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
        handles.tempS(in).cycavgR = [];
        handles.tempS(in).timeR = [];
        handles.tempS(in).stdR = [];
        handles.tempS(in).MagRF = [];
        handles.tempS(in).MisalignRF = [];
        handles.tempS(in).M3DRF = [];
        handles.tempS(in).iF = [];
        handles.tempS(in).MagRS = [];
        handles.tempS(in).MisalignRS = [];
        handles.tempS(in).M3DRS = [];
        handles.tempS(in).iS = [];
        handles.tempS(in).FacialNerve = 0;
        handles.tempS(in).dir = f;
%         handles.spV.XData = [handles.spV.XData str2num(handles.a)];
%         handles.spV.YData = [handles.spV.YData handles.MagRF];
%         handles.errV.XData = str2num(handles.a);
%         handles.errV.YData = mean(handles.spV.YData(~isnan(handles.spV.YData)));
%         handles.errV.YNegativeDelta = std(handles.spV.YData(~isnan(handles.spV.YData)));
%         handles.errV.YPositiveDelta = std(handles.spV.YData(~isnan(handles.spV.YData)));
%         
%         handles.spM.XData = [handles.spM.XData str2num(handles.a)];
%         handles.spM.YData = [handles.spM.YData handles.MisRF];
%         handles.errM.XData = str2num(handles.a);
%         handles.errM.YData = mean(handles.spM.YData(~isnan(handles.spM.YData)));
%         handles.errM.YNegativeDelta = std(handles.spM.YData(~isnan(handles.spM.YData)));
%         handles.errM.YPositiveDelta = std(handles.spM.YData(~isnan(handles.spM.YData)));
        
        handles.tempS(in).MagRF = [handles.tempS(in).MagRF handles.MagRF];
        handles.tempS(in).MisalignRF = [handles.tempS(in).MisalignRF handles.MisRF];
        handles.tempS(in).M3DRF = [handles.tempS(in).M3DRF; handles.M3DRF];
        handles.tempS(in).iF = [handles.tempS(in).iF handles.iF];
        
        handles.tempS(in).MagRS = [handles.tempS(in).MagRS handles.MagRS];
        handles.tempS(in).MisalignRS = [handles.tempS(in).MisalignRS handles.MisRS];
        handles.tempS(in).M3DRS = [handles.tempS(in).M3DRS; handles.M3DRS];
        handles.tempS(in).iS = [handles.tempS(in).iS handles.iS];
        
        
        handles.tempS(in).timeR = [handles.tempS(in).timeR;handles.stim];
        handles.tempS(in).used = [handles.used Results.cyclist(j)];
        handles.cycList.String(handles.cycList.Value) = {['<HTML><FONT color="black">',handles.cycList.UserData{handles.cycList.Value},'</FONT></HTML>']};
    case 2 %Reanalyzing the first cycle in the list and it was previously rejected
%         handles.spV.XData(j) = str2num(handles.a);
%         handles.spV.YData(j) = handles.MagRF;
%         handles.errV.XData = str2num(handles.a);
%         handles.errV.YData = mean(handles.spV.YData(~isnan(handles.spV.YData)));
%         handles.errV.YNegativeDelta = std(handles.spV.YData(~isnan(handles.spV.YData)));
%         handles.errV.YPositiveDelta = std(handles.spV.YData(~isnan(handles.spV.YData)));
%         
%         handles.spM.XData(j) = str2num(handles.a);
%         handles.spM.YData(j) = handles.MisRF;
%         handles.errM.XData = str2num(handles.a);
%         handles.errM.YData = mean(handles.spM.YData(~isnan(handles.spM.YData)));
%         handles.errM.YNegativeDelta = std(handles.spM.YData(~isnan(handles.spM.YData)));
%         handles.errM.YPositiveDelta = std(handles.spM.YData(~isnan(handles.spM.YData)));
        
        handles.tempS(in).MagRF = [handles.MagRF handles.tempS(in).MagRF];
        handles.tempS(in).MisalignRF = [handles.MisRF handles.tempS(in).MisalignRF];
        handles.tempS(in).M3DRF = [handles.M3DRF; handles.tempS(in).M3DRF];
        handles.tempS(in).iF = [handles.iF handles.tempS(in).iF];
        
        handles.tempS(in).MagRS = [handles.MagRS handles.tempS(in).MagRS];
        handles.tempS(in).MisalignRS = [handles.MisRS handles.tempS(in).MisalignRS];
        handles.tempS(in).M3DRS = [handles.M3DRS; handles.tempS(in).M3DRS];
        handles.tempS(in).iS = [handles.iS handles.tempS(in).iS];
        
        
        handles.tempS(in).timeR = [handles.stim;handles.tempS(in).timeR];
        handles.tempS(in).used = [Results.cyclist(j) handles.tempS(in).used];
        handles.cycList.String(handles.cycList.Value) = {['<HTML><FONT color="black">',handles.cycList.UserData{handles.cycList.Value},'</FONT></HTML>']};
    case 3 %Reanalyzing the first cycle in the list and it was previously accepted
%         handles.spV.XData(j) = str2num(handles.a);
%         handles.spV.YData(j) = handles.MagRF;
%         handles.errV.XData = str2num(handles.a);
%         handles.errV.YData = mean(handles.spV.YData(~isnan(handles.spV.YData)));
%         handles.errV.YNegativeDelta = std(handles.spV.YData(~isnan(handles.spV.YData)));
%         handles.errV.YPositiveDelta = std(handles.spV.YData(~isnan(handles.spV.YData)));
%         
%         handles.spM.XData(j) = str2num(handles.a);
%         handles.spM.YData(j) = handles.MisRF;
%         handles.errM.XData = str2num(handles.a);
%         handles.errM.YData = mean(handles.spM.YData(~isnan(handles.spM.YData)));
%         handles.errM.YNegativeDelta = std(handles.spM.YData(~isnan(handles.spM.YData)));
%         handles.errM.YPositiveDelta = std(handles.spM.YData(~isnan(handles.spM.YData)));
        pt = find(Results.cyclist(j)==[handles.tempS(handles.in).used]);
        handles.tempS(in).MagRF(pt) = handles.MagRF;
        handles.tempS(in).MisalignRF(pt) = handles.MisRF;
        handles.tempS(in).M3DRF(pt,:) = handles.M3DRF;
        handles.tempS(in).iF(pt) = handles.iF;
        
        handles.tempS(in).MagRS(pt) = handles.MagRS;
        handles.tempS(in).MisalignRS(pt) = handles.MisRS;
        handles.tempS(in).M3DRS(pt,:) = handles.M3DRS;
        handles.tempS(in).iS(pt) = handles.iS;
        
        tb = (length(handles.stim)*(pt-1)+1):length(handles.stim)*(pt);
        handles.tempS(in).timeR(tb) = handles.stim;
        handles.tempS(in).used(pt) = Results.cyclist(j);
        handles.cycList.String(handles.cycList.Value) = {['<HTML><FONT color="black">',handles.cycList.UserData{handles.cycList.Value},'</FONT></HTML>']};
    case 4 %Analyzing the Jth cycle in the list for the very first time
%         handles.spV.XData(j) = str2num(handles.a);
%         handles.spV.YData(j) = handles.MagRF;
%         handles.errV.XData = str2num(handles.a);
%         handles.errV.YData = mean(handles.spV.YData(~isnan(handles.spV.YData)));
%         handles.errV.YNegativeDelta = std(handles.spV.YData(~isnan(handles.spV.YData)));
%         handles.errV.YPositiveDelta = std(handles.spV.YData(~isnan(handles.spV.YData)));
%         
%         handles.spM.XData(j) = str2num(handles.a);
%         handles.spM.YData(j) = handles.MisRF;
%         handles.errM.XData = str2num(handles.a);
%         handles.errM.YData = mean(handles.spM.YData(~isnan(handles.spM.YData)));
%         handles.errM.YNegativeDelta = std(handles.spM.YData(~isnan(handles.spM.YData)));
%         handles.errM.YPositiveDelta = std(handles.spM.YData(~isnan(handles.spM.YData)));
        
        handles.tempS(in).MagRF = [handles.tempS(in).MagRF handles.MagRF];
        handles.tempS(in).MisalignRF = [handles.tempS(in).MisalignRF handles.MisRF];
        handles.tempS(in).M3DRF = [handles.tempS(in).M3DRF; handles.M3DRF];
        handles.tempS(in).iF = [handles.tempS(in).iF handles.iF];
        
        handles.tempS(in).MagRS = [handles.tempS(in).MagRS handles.MagRS];
        handles.tempS(in).MisalignRS = [handles.tempS(in).MisalignRS handles.MisRS];
        handles.tempS(in).M3DRS = [handles.tempS(in).M3DRS; handles.M3DRS];
        handles.tempS(in).iS = [handles.tempS(in).iS handles.iS];
        
        handles.tempS(in).timeR = [handles.tempS(in).timeR;handles.stim];
        handles.tempS(in).used = [handles.tempS(in).used Results.cyclist(j)];
        handles.cycList.String(handles.cycList.Value) = {['<HTML><FONT color="black">',handles.cycList.UserData{handles.cycList.Value},'</FONT></HTML>']};
    case 5 %Reanalyzing the Jth cycle in the list and it was previously rejected
%         handles.spV.XData = [handles.spV.XData(b1) str2num(handles.a) handles.spV.XData(b2)];
%         handles.spV.YData = [handles.spV.YData(b1) handles.MagRF handles.spV.YData(b2)];
%         handles.errV.XData = str2num(handles.a);
%         handles.errV.YData = mean(handles.spV.YData(~isnan(handles.spV.YData)));
%         handles.errV.YNegativeDelta = std(handles.spV.YData(~isnan(handles.spV.YData)));
%         handles.errV.YPositiveDelta = std(handles.spV.YData(~isnan(handles.spV.YData)));
%         
%         handles.spM.XData = [handles.spM.XData(b1) str2num(handles.a) handles.spM.XData(b2)];
%         handles.spM.YData = [handles.spM.YData(b1) handles.MisRF handles.spM.YData(b2)];
%         handles.errM.XData = str2num(handles.a);
%         handles.errM.YData = mean(handles.spM.YData(~isnan(handles.spM.YData)));
%         handles.errM.YNegativeDelta = std(handles.spM.YData(~isnan(handles.spM.YData)));
%         handles.errM.YPositiveDelta = std(handles.spM.YData(~isnan(handles.spM.YData)));
        wNew = sort([Results.cyclist(j) handles.tempS(handles.in).used]);
        MagRF = [];
        MisalignRF = [];
        M3DRF = [];
        iF = [];
        
        MagRS = [];
        MisalignRS = [];
        M3DRS = [];
        iS = [];
        timeR = [];
        for q = 1:length(wNew)
            if wNew(q) == Results.cyclist(j)
                MagRF = [MagRF handles.MagRF];
                MisalignRF = [MisalignRF handles.MisRF];
                M3DRF = [M3DRF; handles.M3DRF];
                iF = [iF handles.iF];
                
                MagRS = [MagRS handles.MagRS];
                MisalignRS = [MisalignRS handles.MisRS];
                M3DRS = [M3DRS; handles.M3DRS];
                iS = [iS handles.iS];
                timeR = [timeR; handles.stim];
            else
                pt = find(handles.tempS(in).used==wNew(q));
                MagRF = [MagRF handles.tempS(in).MagRF(pt)];
                MisalignRF = [MisalignRF handles.tempS(in).MisalignRF(pt)];
                M3DRF = [M3DRF; handles.tempS(in).M3DRF(pt,:)];
                iF = [iF handles.tempS(in).iF(pt)];
                
                MagRS = [MagRS handles.tempS(in).MagRS(pt)];
                MisalignRS = [MisalignRS handles.tempS(in).MisalignRS(pt)];
                M3DRS = [M3DRS; handles.tempS(in).M3DRS(pt,:)];
                iS = [iS handles.tempS(in).iS(pt)];
                
                tb2 = (length(handles.stim)*(pt-1)+1):length(handles.stim)*(pt);
                
                timeR = [timeR; handles.tempS(in).timeR(tb2)];
            end
        end
        
        handles.tempS(in).MagRF = MagRF;
        handles.tempS(in).MisalignRF = MisalignRF;
        handles.tempS(in).M3DRF = M3DRF;
        handles.tempS(in).iF = iF;
        
        handles.tempS(in).MagRS = MagRS;
        handles.tempS(in).MisalignRS = MisalignRS;
        handles.tempS(in).M3DRS = M3DRS;
        handles.tempS(in).iS = iS;

        handles.tempS(in).timeR = timeR;
        handles.tempS(in).used = wNew;
        handles.cycList.String(handles.cycList.Value) = {['<HTML><FONT color="black">',handles.cycList.UserData{handles.cycList.Value},'</FONT></HTML>']};
    case 6
%         handles.spV.XData(j) = str2num(handles.a);
%         handles.spV.YData(j) = handles.MagRF;
%         handles.errV.XData = str2num(handles.a);
%         handles.errV.YData = mean(handles.spV.YData(~isnan(handles.spV.YData)));
%         handles.errV.YNegativeDelta = std(handles.spV.YData(~isnan(handles.spV.YData)));
%         handles.errV.YPositiveDelta = std(handles.spV.YData(~isnan(handles.spV.YData)));
%         
%         handles.spM.XData(j) = str2num(handles.a);
%         handles.spM.YData(j) = handles.MisRF;
%         handles.errM.XData = str2num(handles.a);
%         handles.errM.YData = mean(handles.spM.YData(~isnan(handles.spM.YData)));
%         handles.errM.YNegativeDelta = std(handles.spM.YData(~isnan(handles.spM.YData)));
%         handles.errM.YPositiveDelta = std(handles.spM.YData(~isnan(handles.spM.YData)));
        
        handles.tempS(in).MagRF(j) = handles.MagRF;
        handles.tempS(in).MisalignRF(j) = handles.MisRF;
        handles.tempS(in).M3DRF(j,:) = handles.M3DRF;
        handles.tempS(in).iF(j) = handles.iF;
        
        handles.tempS(in).MagRS(j) = handles.MagRS;
        handles.tempS(in).MisalignRS(j) = handles.MisRS;
        handles.tempS(in).M3DRS(j,:) = handles.M3DRS;
        handles.tempS(in).iS(j) = handles.iS;
        
        tb = (length(handles.stim)*(j-1)+1):length(handles.stim)*(j);
        handles.tempS(in).timeR(tb) = handles.stim;
        handles.tempS(in).used(j) = Results.cyclist(j);
        handles.cycList.String(handles.cycList.Value) = {['<HTML><FONT color="black">',handles.cycList.UserData{handles.cycList.Value},'</FONT></HTML>']};
        
end