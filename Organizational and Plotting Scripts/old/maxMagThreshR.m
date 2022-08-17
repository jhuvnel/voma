function [avgMisalign, maxMag, w] = maxMagThreshR(s,handles,Results)
    [mag, imag] = max(sqrt((Results.rl_cyc(s,1:(100))).^2+(Results.rr_cyc(s,1:(100))).^2+(Results.rz_cyc(s,1:(100))).^2));
    if mag>40
          [mag, imag] = max(sqrt((Results.rl_cyc(s,1:(30))).^2+(Results.rr_cyc(s,1:(30))).^2+(Results.rz_cyc(s,1:(30))).^2));
    [~,maj]=min([mag-max(abs(Results.rl_cyc(s,1:(30)))) mag-max(abs(Results.rr_cyc(s,1:(30)))) mag-max(abs(Results.rz_cyc(s,1:(30))))]);
   
    switch maj
        case 1
            if (Results.rl_cyc(s,20)-Results.rl_cyc(s,1))>0
                
                if ~isempty(find(Results.rl_cyc(s,20:100)<0,1))
                    cutOff = find(Results.rl_cyc(s,20:100)<0,1)+19;
                else
                    cutOff = 100;
                end
            elseif (Results.rl_cyc(s,20)-Results.rl_cyc(s,1))<0
                if ~isempty(find(Results.rl_cyc(s,20:100)>0,1))
                    cutOff = find(Results.rl_cyc(s,20:100)>0,1)+19;
                else
                    cutOff = 100;
                end
            end
        case 2
            if (Results.rr_cyc(s,20)-Results.rr_cyc(s,1))>0
                if ~isempty(find(Results.rr_cyc(s,20:100)<0,1))
                    cutOff = find(Results.rr_cyc(s,20:100)<0,1)+19;
                else
                    cutOff = 100;
                end
            elseif (Results.rr_cyc(s,20)-Results.rr_cyc(s,1))<0
                if ~isempty(find(Results.rr_cyc(s,20:100)>0,1))
                    cutOff = find(Results.rr_cyc(s,20:100)>0,1)+19;
                else
                    cutOff = 100;
                end
            end
        case 3
            if (Results.rz_cyc(s,20)-Results.rz_cyc(s,1))>0
                if ~isempty(find(Results.rz_cyc(s,20:100)<0,1))
                    cutOff = find(Results.rz_cyc(s,20:100)<0,1)+19;
                else
                    cutOff = 100;
                end
            elseif (Results.rz_cyc(s,20)-Results.rz_cyc(s,1))<0
                if ~isempty(find(Results.rz_cyc(s,20:100)>0,1))
                    cutOff = find(Results.rz_cyc(s,20:100)>0,1)+19;
                else
                    cutOff = 100;
                end
            end
    end
        [mag, imag] = max(sqrt((Results.rl_cyc(s,1:(cutOff))).^2+(Results.rr_cyc(s,1:(cutOff))).^2+(Results.rz_cyc(s,1:(cutOff))).^2));

    end
    w = [Results.rl_cyc(s,imag) Results.rr_cyc(s,imag) Results.rz_cyc(s,imag)];
    cosT = dot(handles.pureRot,w)/(norm(handles.pureRot)*norm(w));
    avgMisalign = acosd(cosT);
    maxMag = mag;