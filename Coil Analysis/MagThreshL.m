function [handles, Misalign, maxMag, Misalign3D, pullInds]  = MagThreshL(handles,Results)
if isempty(Results)
    LE_LARP = handles.toUseLELARP;
    LE_RALP = handles.toUseLERALP;
    LE_Z = handles.toUseLEZ;
    handles.segment(handles.segNum).pullIndsL = [];
    forLoop = handles.segment(handles.segNum).stim_inds;
else
    temp = size(Results.ll_cyc);
    forLoop = 1:temp(1);
    Misalign = [];
    maxMag = [];
    Misalign3D = [];
    pullInds = [];
    LE_LARP = reshape(Results.ll_cyc',1,[]);
    LE_RALP = reshape(Results.lr_cyc',1,[]);
    LE_Z = reshape(Results.lz_cyc',1,[]);
    t = 1:length(Results.ll_cyc(1,:)):length(LE_LARP);
end
for i = 1:length(forLoop)
    if isempty(Results)
        s = handles.segment(handles.segNum).stim_inds(i);
    else
        
        s = t(i);
    end
    
    [mag, imag] = max(sqrt((LE_LARP(s:(s+100))).^2+(LE_RALP(s:(s+100))).^2+(LE_Z(s:(s+100))).^2));
    if mag>40
        [mag, imag] = max(sqrt((LE_LARP(s:(s+30))).^2+(LE_RALP(s:(s+30))).^2+(LE_Z(s:(s+30))).^2));
        [~,maj]=min([mag-max(abs(LE_LARP(s:(s+30)))) mag-max(abs(LE_RALP(s:(s+30)))) mag-max(abs(LE_Z(s:(s+30))))]);
        if ~isempty(handles.stimCanal)
            maj = handles.stimCanal;
        end
        switch maj
            case 1
                if ~isempty(handles.rotSign)
                    toUse = handles.rotSign;
                else
                    toUse = (LE_LARP(s+15)-LE_LARP(s));
                end
                
                if toUse>0
                    
                    %                 if ~isempty(find(LE_LARP(s+20:s+100)<0,1))
                    %                     cutOff = find(LE_LARP(s+20:s+100)<0,1)+19;
                    %                 else
                    %                     cutOff = 100;
                    %                 end
                    [TF,p] = islocalmin(-LE_LARP(s:s+30));
                    [TF1,p1] = islocalmin(-LE_LARP(s:s+100));
                    if ~(any(p>20))
                        [TF,p] = islocalmin(-LE_LARP(s:s+100));
                    elseif (any(p1>200))
                        TF = TF1;
                        p = p1;
                    end
                    if any(TF)
                        [~,ind] = max(p);
                        cutOff = ind+1;
                    else
                        cutOff = 100;
                    end
                    if cutOff ~= 100
                        compare = (LE_LARP(s+cutOff+10:s+100)-LE_LARP(s+cutOff))>1;
                        if any(compare)
                            cutOff = max(find((LE_LARP(s+cutOff+10:s+100)-LE_LARP(s+cutOff))>1))+9+cutOff;
                        end
                    end
                elseif toUse<0
                    %                 if ~isempty(find(LE_LARP(s+20:s+100)>0,1))
                    %                     cutOff = find(LE_LARP(s+20:s+100)>0,1)+19;
                    %                 else
                    %                     cutOff = 100;
                    %                 end
                    [TF,p] = islocalmin(LE_LARP(s:s+30));
                    [TF1,p1] = islocalmin(LE_LARP(s:s+100));
                    if ~(any(p>20))
                        [TF,p] = islocalmin(LE_LARP(s:s+100));
                    elseif (any(p1>200))
                        TF = TF1;
                        p = p1;
                    end
                    if any(TF)
                        [~,ind] = max(p);
                        cutOff = ind+1;
                    else
                        cutOff = 100;
                    end
                    if cutOff ~= 100
                        compare = (LE_LARP(s+cutOff+10:s+100)-LE_LARP(s+cutOff))<1;
                        if any(compare)
                            cutOff = max(find((LE_LARP(s+cutOff+10:s+100)-LE_LARP(s+cutOff))<1))+9+cutOff;
                        end
                    end
                    
                end
            case 2
                if ~isempty(handles.rotSign)
                    toUse = handles.rotSign;
                else
                    toUse = (LE_RALP(s+15)-LE_RALP(s));
                end
                if toUse>0
                    %                 if ~isempty(find(LE_RALP(s+20:s+100)<0,1))
                    %                     cutOff = find(LE_RALP(s+20:s+100)<0,1)+19;
                    %                 else
                    %                     cutOff = 100;
                    %                 end
                    [TF,p] = islocalmin(-LE_RALP(s:s+30));
                    [TF1,p1] = islocalmin(-LE_RALP(s:s+100));
                    if ~(any(p>20))
                        [TF,p] = islocalmin(-LE_RALP(s:s+100));
                    elseif (any(p1>200))
                        TF = TF1;
                        p = p1;
                    end
                    if any(TF)
                        [~,ind] = max(p);
                        cutOff = ind+1;
                    else
                        cutOff = 100;
                    end
                    if cutOff ~= 100
                        compare = (LE_RALP(s+cutOff+10:s+100)-LE_RALP(s+cutOff))>1;
                        if any(compare)
                            cutOff = max(find(compare))+9+cutOff;
                        end
                    end
                elseif toUse<0
                    %                 if ~isempty(find(LE_RALP(s+20:s+100)>0,1))
                    %                     cutOff = find(LE_RALP(s+20:s+100)>0,1)+19;
                    %                 else
                    %                     cutOff = 100;
                    %                 end
                    [TF,p] = islocalmin(LE_RALP(s:s+30));
                    [TF1,p1] = islocalmin(LE_RALP(s:s+100));
                    if ~(any(p>20))
                        [TF,p] = islocalmin(LE_RALP(s:s+100));
                    elseif (any(p1>200))
                        TF = TF1;
                        p = p1;
                    end
                    if any(TF)
                        [~,ind] = max(p);
                        cutOff = ind+1;
                    else
                        cutOff = 100;
                    end
                    if cutOff ~= 100
                        compare = (LE_RALP(s+cutOff+10:s+100)-LE_RALP(s+cutOff))<1;
                        if any(compare)
                            cutOff = max(find(compare))+9+cutOff;
                        end
                    end
                end
            case 3
                if ~isempty(handles.rotSign)
                    toUse = handles.rotSign;
                else
                    toUse = (LE_Z(s+15)-LE_Z(s));
                end
                if toUse>0
                    %                 if ~isempty(find(LE_Z(s+20:s+100)<0,1))
                    %                     cutOff = find(LE_Z(s+20:s+100)<0,1)+19;
                    %                 else
                    %                     cutOff = 100;
                    %                 end
                    [TF,p] = islocalmin(-LE_Z(s:s+30));
                    [TF1,p1] = islocalmin(-LE_Z(s:s+100));
                    if ~(any(p>20))
                        [TF,p] = islocalmin(-LE_Z(s:s+100));
                    elseif (any(p1>200))
                        TF = TF1;
                        p = p1;
                    end
                    if any(TF)
                        [~,ind] = max(p);
                        cutOff = ind+1;
                    else
                        cutOff = 100;
                    end
                    if cutOff ~= 100
                        compare = (LE_Z(s+cutOff+10:s+100)-LE_Z(s+cutOff))>1;
                        if any(compare)
                            cutOff = max(find(compare))+9+cutOff;
                        end
                    end
                elseif toUse<0
                    %                 if ~isempty(find(LE_Z(s+20:s+100)>0,1))
                    %                     cutOff = find(LE_Z(s+20:s+100)>0,1)+19;
                    %                 else
                    %                     cutOff = 100;
                    %                 end
                    [TF,p] = islocalmin(LE_Z(s:s+30));
                    [TF1,p1] = islocalmin(LE_Z(s:s+100));
                    if ~(any(p>20))
                        [TF,p] = islocalmin(LE_Z(s:s+100));
                    elseif (any(p1>200))
                        TF = TF1;
                        p = p1;
                    end
                    if any(TF)
                        [~,ind] = max(p);
                        cutOff = ind+1;
                    else
                        cutOff = 100;
                    end
                    if cutOff ~= 100
                        compare = (LE_Z(s+cutOff+10:s+100)-LE_Z(s+cutOff))<1;
                        if any(compare)
                            cutOff = max(find(compare))+9+cutOff;
                        end
                    end
                end
        end
        switch maj
            case 1
                if ~isempty(handles.rotSign)
                    toUse = handles.rotSign;
                else
                    toUse = (LE_LARP(s+15)-LE_LARP(s));
                end
                if toUse >0
                        [~,imag] = max(LE_LARP(s:(s+cutOff)));
                        [mag, ~] = max(sqrt((LE_LARP(s+imag-1)).^2+(LE_RALP(s+imag-1)).^2+(LE_Z(s+imag-1)).^2));
                    elseif toUse <0
                        [~,imag] = min(LE_LARP(s:(s+cutOff)));
                        [mag, ~] = max(sqrt((LE_LARP(s+imag-1)).^2+(LE_RALP(s+imag-1)).^2+(LE_Z(s+imag-1)).^2));
                    end
            case 2
                if ~isempty(handles.rotSign)
                    toUse = handles.rotSign;
                else
                    toUse = (LE_RALP(s+15)-LE_RALP(s));
                end
                if toUse >0
                        [~,imag] = max(LE_RALP(s:(s+cutOff)));
                        [mag, ~] = max(sqrt((LE_LARP(s+imag-1)).^2+(LE_RALP(s+imag-1)).^2+(LE_Z(s+imag-1)).^2));
                    elseif toUse <0
                        [~,imag] = min(LE_RALP(s:(s+cutOff)));
                        [mag, ~] = max(sqrt((LE_LARP(s+imag-1)).^2+(LE_RALP(s+imag-1)).^2+(LE_Z(s+imag-1)).^2));
                    end
            case 3
                if ~isempty(handles.rotSign)
                    toUse = handles.rotSign;
                else
                    toUse = (LE_Z(s+15)-LE_Z(s));
                end
                if toUse >0
                        [~,imag] = max(LE_Z(s:(s+cutOff)));
                        [mag, ~] = max(sqrt((LE_LARP(s+imag-1)).^2+(LE_RALP(s+imag-1)).^2+(LE_Z(s+imag-1)).^2));
                    elseif toUse <0
                        [~,imag] = min(LE_Z(s:(s+cutOff)));
                        [mag, ~] = max(sqrt((LE_LARP(s+imag-1)).^2+(LE_RALP(s+imag-1)).^2+(LE_Z(s+imag-1)).^2));
                    end
        end
        %[mag, imag] = max(sqrt((LE_LARP(s:(s+cutOff))).^2+(LE_RALP(s:(s+cutOff))).^2+(LE_Z(s:(s+cutOff))).^2));
        if mag<20
            switch maj
                case 1
                    if ~isempty(handles.rotSign)
                        toUse = handles.rotSign;
                    else
                        toUse = (LE_LARP(s+15)-LE_LARP(s));
                    end
                    if toUse >0
                        [~,imag] = max(LE_LARP(s:(s+100)));
                        [mag, ~] = max(sqrt((LE_LARP(s+imag-1)).^2+(LE_RALP(s+imag-1)).^2+(LE_Z(s+imag-1)).^2));
                    elseif toUse <0
                        [~,imag] = min(LE_LARP(s:(s+100)));
                        [mag, ~] = max(sqrt((LE_LARP(s+imag-1)).^2+(LE_RALP(s+imag-1)).^2+(LE_Z(s+imag-1)).^2));
                    end
                case 2
                    if ~isempty(handles.rotSign)
                        toUse = handles.rotSign;
                    else
                        toUse = (LE_RALP(s+15)-LE_RALP(s));
                    end
                    if toUse >0
                        [~,imag] = max(LE_RALP(s:(s+100)));
                        [mag, ~] = max(sqrt((LE_LARP(s+imag-1)).^2+(LE_RALP(s+imag-1)).^2+(LE_Z(s+imag-1)).^2));
                    elseif toUse <0
                        [~,imag] = min(LE_RALP(s:(s+100)));
                        [mag, ~] = max(sqrt((LE_LARP(s+imag-1)).^2+(LE_RALP(s+imag-1)).^2+(LE_Z(s+imag-1)).^2));
                    end
                case 3
                    if ~isempty(handles.rotSign)
                        toUse = handles.rotSign;
                    else
                        toUse = (LE_Z(s+15)-LE_Z(s));
                    end
                    if toUse >0
                        [~,imag] = max(LE_Z(s:(s+100)));
                        [mag, ~] = max(sqrt((LE_LARP(s+imag-1)).^2+(LE_RALP(s+imag-1)).^2+(LE_Z(s+imag-1)).^2));
                    elseif toUse <0
                        [~,imag] = min(LE_Z(s:(s+100)));
                        [mag, ~] = max(sqrt((LE_LARP(s+imag-1)).^2+(LE_RALP(s+imag-1)).^2+(LE_Z(s+imag-1)).^2));
                    end
            end
        end
        
    elseif mag<20
        [~,maj]=min([mag-max(abs(LE_LARP(s:(s+30)))) mag-max(abs(LE_RALP(s:(s+30)))) mag-max(abs(LE_Z(s:(s+30))))]);
        if ~isempty(handles.stimCanal)
            maj = handles.stimCanal;
        end
        switch maj
            case 1
                if ~isempty(handles.rotSign)
                    toUse = handles.rotSign;
                else
                    toUse = (LE_LARP(s+15)-LE_LARP(s));
                end
                if toUse >0
                    [~,imag] = max(LE_LARP(s:(s+100)));
                    [mag, ~] = max(sqrt((LE_LARP(s+imag-1)).^2+(LE_RALP(s+imag-1)).^2+(LE_Z(s+imag-1)).^2));
                elseif toUse <0
                    [~,imag] = min(LE_LARP(s:(s+100)));
                    [mag, ~] = max(sqrt((LE_LARP(s+imag-1)).^2+(LE_RALP(s+imag-1)).^2+(LE_Z(s+imag-1)).^2));
                end
            case 2
                if ~isempty(handles.rotSign)
                    toUse = handles.rotSign;
                else
                    toUse = (LE_RALP(s+15)-LE_RALP(s));
                end
                if toUse >0
                    [~,imag] = max(LE_RALP(s:(s+100)));
                    [mag, ~] = max(sqrt((LE_LARP(s+imag-1)).^2+(LE_RALP(s+imag-1)).^2+(LE_Z(s+imag-1)).^2));
                elseif toUse <0
                    [~,imag] = min(LE_RALP(s:(s+100)));
                    [mag, ~] = max(sqrt((LE_LARP(s+imag-1)).^2+(LE_RALP(s+imag-1)).^2+(LE_Z(s+imag-1)).^2));
                end
            case 3
                if ~isempty(handles.rotSign)
                    toUse = handles.rotSign;
                else
                    toUse = (LE_Z(s+15)-LE_Z(s));
                end
                if toUse >0
                    [~,imag] = max(LE_Z(s:(s+100)));
                    [mag, ~] = max(sqrt((LE_LARP(s+imag-1)).^2+(LE_RALP(s+imag-1)).^2+(LE_Z(s+imag-1)).^2));
                elseif toUse <0
                    [~,imag] = min(LE_Z(s:(s+100)));
                    [mag, ~] = max(sqrt((LE_LARP(s+imag-1)).^2+(LE_RALP(s+imag-1)).^2+(LE_Z(s+imag-1)).^2));
                end
        end
    else
        cutOff = 100;
    end
    if isempty(Results)
        handles.segment(handles.segNum).pullIndsL(i) = s+imag-1;
        handles.segment(handles.segNum).Misalign3DL(i,:) = [LE_LARP(s+imag-1) LE_RALP(s+imag-1) LE_Z(s+imag-1)];
        w = [LE_LARP(s+imag-1) LE_RALP(s+imag-1) LE_Z(s+imag-1)];
        [~,maxPos] = max(abs(w));
        if ~isempty(handles.stimCanal)
            maxPos = handles.stimCanal;
        end
        if w(maxPos)>0
            rotSign  = 1;
        elseif w(maxPos)<0
            rotSign = -1;
        end
        if ~isempty(handles.rotSign)
            rotSign = handles.rotSign;
        end
        cosT = dot(rotSign*handles.pureRot,w)/(norm(rotSign*handles.pureRot)*norm(w));
        handles.segment(handles.segNum).MisalignL(i) = acosd(cosT);
        handles.segment(handles.segNum).maxMagL(i) = mag;
    else
        pullInds = [pullInds; s+imag-1];
        Misalign3D = [Misalign3D; LE_LARP(s+imag-1) LE_RALP(s+imag-1) LE_Z(s+imag-1)];
        w = [LE_LARP(s+imag-1) LE_RALP(s+imag-1) LE_Z(s+imag-1)];
        [~,maxPos] = max(abs(w));
        if ~isempty(handles.stimCanal)
            maxPos = handles.stimCanal;
        end
        if w(maxPos)>0
            rotSign  = 1;
        elseif w(maxPos)<0
            rotSign = -1;
        end
        cosT = dot(rotSign*handles.pureRot,w)/(norm(rotSign*handles.pureRot)*norm(w));
        Misalign = [Misalign; acosd(cosT)];
        maxMag = [maxMag; mag];
    end
    
    
end
% figure('units','normalized','outerposition',[0 0 1 1]);
%     t = 1:length(Results.stim);
%     plot(t,Results.stim,'k')
%     hold on
%     l=reshape(Results.ll_cyc',1,[]);
%     r=reshape(Results.lr_cyc',1,[]);
%     z=reshape(Results.lz_cyc',1,[]);
%     plot(t,l,'g')
%     plot(t,r,'b')
%     plot(t,z,'r')
%     plot(t(pullInds),l(pullInds),'k*')
%     plot(t(pullInds),r(pullInds),'k*')
%     plot(t(pullInds),z(pullInds),'k*')
%     hold off
%     pause(2)
%     close(gcf)