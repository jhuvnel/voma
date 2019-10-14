function [handles, Misalign, maxMag, Misalign3D, pullInds]  = MagThreshR(handles,Results)
if isempty(Results)
    RE_LARP = handles.toUseRELARP;
    RE_RALP = handles.toUseRERALP;
    RE_Z = handles.toUseREZ;
    handles.segment(handles.segNum).pullInds = [];
    forLoop = handles.segment(handles.segNum).stim_inds;
else
temp = size(Results.rl_cyc);
forLoop = 1:temp(1);
Misalign = [];
maxMag = [];
Misalign3D = [];
pullInds = [];    
    RE_LARP = reshape(Results.rl_cyc',1,[]);
    RE_RALP = reshape(Results.rr_cyc',1,[]);
    RE_Z = reshape(Results.rz_cyc',1,[]);
    t = 1:length(Results.rl_cyc(1,:)):length(RE_LARP);
end
for i = 1:length(forLoop)
if isempty(Results)
    s = handles.segment(handles.segNum).stim_inds(i);
else

    s = t(i);
end

    [mag, imag] = max(sqrt((RE_LARP(s:(s+100))).^2+(RE_RALP(s:(s+100))).^2+(RE_Z(s:(s+100))).^2));
    if mag>40
          [mag, imag] = max(sqrt((RE_LARP(s:(s+30))).^2+(RE_RALP(s:(s+30))).^2+(RE_Z(s:(s+30))).^2));
    [~,maj]=min([mag-max(abs(RE_LARP(s:(s+30)))) mag-max(abs(RE_RALP(s:(s+30)))) mag-max(abs(RE_Z(s:(s+30))))]);
   
    switch maj
        case 1
            if (RE_LARP(s+20)-RE_LARP(s))>0
                
                if ~isempty(find(RE_LARP(s+20:s+100)<0,1))
                    cutOff = find(RE_LARP(s+20:s+100)<0,1)+19;
                else
                    cutOff = 100;
                end
            elseif (RE_LARP(s+20)-RE_LARP(s))<0
                if ~isempty(find(RE_LARP(s+20:s+100)>0,1))
                    cutOff = find(RE_LARP(s+20:s+100)>0,1)+19;
                else
                    cutOff = 100;
                end
            end
        case 2
            if (RE_RALP(s+20)-RE_RALP(s))>0
                if ~isempty(find(RE_RALP(s+20:s+100)<0,1))
                    cutOff = find(RE_RALP(s+20:s+100)<0,1)+19;
                else
                    cutOff = 100;
                end
            elseif (RE_RALP(s+20)-RE_RALP(s))<0
                if ~isempty(find(RE_RALP(s+20:s+100)>0,1))
                    cutOff = find(RE_RALP(s+20:s+100)>0,1)+19;
                else
                    cutOff = 100;
                end
            end
        case 3
            if (RE_Z(s+20)-RE_Z(s))>0
                if ~isempty(find(RE_Z(s+20:s+100)<0,1))
                    cutOff = find(RE_Z(s+20:s+100)<0,1)+19;
                else
                    cutOff = 100;
                end
            elseif (RE_Z(s+20)-RE_Z(s))<0
                if ~isempty(find(RE_Z(s+20:s+100)>0,1))
                    cutOff = find(RE_Z(s+20:s+100)>0,1)+19;
                else
                    cutOff = 100;
                end
            end
    end
        [mag, imag] = max(sqrt((RE_LARP(s:(s+cutOff))).^2+(RE_RALP(s:(s+cutOff))).^2+(RE_Z(s:(s+cutOff))).^2));
    else
        cutOff = 100;
    end
if isempty(Results)
handles.segment(handles.segNum).pullInds(i) = s+imag-1;
handles.segment(handles.segNum).Misalign3D(i,:) = [RE_LARP(s+imag-1) RE_RALP(s+imag-1) RE_Z(s+imag-1)];
w = [RE_LARP(s+imag-1) RE_RALP(s+imag-1) RE_Z(s+imag-1)];
cosT = dot(handles.pureRot,w)/(norm(handles.pureRot)*norm(w));
handles.segment(handles.segNum).Misalign(i) = acosd(cosT);
handles.segment(handles.segNum).maxMag(i) = mag;
else
pullInds = [pullInds; s+imag-1];
Misalign3D = [Misalign3D; RE_LARP(s+imag-1) RE_RALP(s+imag-1) RE_Z(s+imag-1)];
w = [RE_LARP(s+imag-1) RE_RALP(s+imag-1) RE_Z(s+imag-1)];
cosT = dot(handles.pureRot,w)/(norm(handles.pureRot)*norm(w));
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