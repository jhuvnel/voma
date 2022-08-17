function [avgMisalign, maxMag, w, imag] = maxMagThreshL(s,handles,Results)   
[mag, imag] = max(sqrt((Results.ll_cyc(s,1:(100))).^2+(Results.lr_cyc(s,1:(100))).^2+(Results.lz_cyc(s,1:(100))).^2));
    if mag>40
          [mag, imag] = max(sqrt((Results.ll_cyc(s,1:(30))).^2+(Results.lr_cyc(s,1:(30))).^2+(Results.lz_cyc(s,1:(30))).^2));
    [~,maj]=min([mag-max(abs(Results.ll_cyc(s,1:(30)))) mag-max(abs(Results.lr_cyc(s,1:(30)))) mag-max(abs(Results.lz_cyc(s,1:(30))))]);
   
    switch maj
        case 1
            if (Results.ll_cyc(s,20)-Results.ll_cyc(s,1))>0
                
                if ~isempty(find(Results.ll_cyc(s,20:100)<0,1))
                    cutOff = find(Results.ll_cyc(s,20:100)<0,1)+19;
                else
                    cutOff = 100;
                end
            elseif (Results.ll_cyc(s,20)-Results.ll_cyc(s,1))<0
                if ~isempty(find(Results.ll_cyc(s,20:100)>0,1))
                    cutOff = find(Results.ll_cyc(s,20:100)>0,1)+19;
                else
                    cutOff = 100;
                end
            end
        case 2
            if (Results.lr_cyc(s,20)-Results.lr_cyc(s,1))>0
                if ~isempty(find(Results.lr_cyc(s,20:100)<0,1))
                    cutOff = find(Results.lr_cyc(s,20:100)<0,1)+19;
                else
                    cutOff = 100;
                end
            elseif (Results.lr_cyc(s,20)-Results.lr_cyc(s,1))<0
                if ~isempty(find(Results.lr_cyc(s,20:100)>0,1))
                    cutOff = find(Results.lr_cyc(s,20:100)>0,1)+19;
                else
                    cutOff = 100;
                end
            end
        case 3
            if (Results.lz_cyc(s,20)-Results.lz_cyc(s,1))>0
                if ~isempty(find(Results.lz_cyc(s,20:100)<0,1))
                    cutOff = find(Results.lz_cyc(s,20:100)<0,1)+19;
                else
                    cutOff = 100;
                end
            elseif (Results.lz_cyc(s,20)-Results.lz_cyc(s,1))<0
                if ~isempty(find(Results.lz_cyc(s,20:100)>0,1))
                    cutOff = find(Results.lz_cyc(s,20:100)>0,1)+19;
                else
                    cutOff = 100;
                end
            end
    end
        [mag, imag] = max(sqrt((Results.ll_cyc(s,1:(cutOff))).^2+(Results.lr_cyc(s,1:(cutOff))).^2+(Results.lz_cyc(s,1:(cutOff))).^2));

    end
    pullInds(s) = imag;
    w = [Results.ll_cyc(s,imag) Results.lr_cyc(s,imag) Results.lz_cyc(s,imag)];
    cosT = dot(handles.pureRot,w)/(norm(handles.pureRot)*norm(w));
    avgMisalign = acosd(cosT);
    maxMag = mag;