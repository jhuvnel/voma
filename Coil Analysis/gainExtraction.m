function [gainmatrix, gainFileName] = gainExtraction(directory,fileCh1Ch2,fileCh3Ch4)
gainX = [];
gainY = [];
gainZ = [];

if ~isempty(fileCh1Ch2) && ~isempty(fileCh3Ch4)
    total = 1:2;
    toPlot = 3;
    files = {fileCh1Ch2,fileCh3Ch4};
elseif isempty(fileCh1Ch2)
    total = 2;
    toPlot = 2;
    files = {'',fileCh3Ch4};
    gainX(1,1) = 0;
    gainY(1,1) = 0;
    gainZ(1,1) = 0;
    gainX(1,2) = 0;
    gainY(1,2) = 0;
    gainZ(1,2) = 0;
elseif isempty(fileCh3Ch4)
    total = 1;
    toPlot = 1;
    files = {fileCh1Ch2,''};
    gainX(2,1) = 0;
    gainY(2,1) = 0;
    gainZ(2,1) = 0;
    gainX(2,2) = 0;
    gainY(2,2) = 0;
    gainZ(2,2) = 0;
end

if isempty(fileCh1Ch2) && isempty(fileCh3Ch4)
else
    
    % ranges = [ +X1 +X2; -X1 -X2; +Y1 +Y2; -Y1 -Y2; +Z1 +Z2; -Z1 -Z2]; ch1ch2
    % ranges(:,:,2) = same format ch3ch4
    
    for i = total
        coils = [];
        coilsWithProsthSync=readcoils(directory,files{i}, true);
        coils(:,1:3)=coilsWithProsthSync(:,1:3);
        
        
        coils(:,4:15)=coilsWithProsthSync(:,6:17);
        confirmFig = figure;
        if toPlot == 3
            if i == 1
            inds2plot = 4:6;
            toUse = coils(:,inds2plot);
            plotTitle = 'Ch1Ch2';
            else
                inds2plot = 10:12;

                toUse = coils(:,inds2plot);
                plotTitle = 'Ch3Ch4';
            end
        elseif toPlot == 2
            inds2plot = 10:12;

            toUse = coils(:,inds2plot);
            plotTitle = 'Ch3Ch4';
        elseif toPlot == 1
            inds2plot = 4:6;

            toUse = coils(:,inds2plot);
            plotTitle = 'Ch1Ch2';
        end
        plot(coils(:,inds2plot));grid on;zoom on
        title(plotTitle)
        hold on

        f1=filtfilt(ones(1,415)/415,1,gradient(toUse(:,1)));
        f2=filtfilt(ones(1,415)/415,1,gradient(toUse(:,2)));
        f3=filtfilt(ones(1,415)/415,1,gradient(toUse(:,3)));
        ff1 = gradient(f1);
        ff2 = gradient(f2);
        ff3 = gradient(f3);
        mask1 = zeros(1,length(ff1));
        mask2 = zeros(1,length(ff2));
        mask3 = zeros(1,length(ff3));
        mask1(abs(ff1)<15) = 1;
        mask2(abs(ff2)<15) = 1;
        mask3(abs(ff3)<15) = 1;
        inds1 = [1:length(mask1)];
        inds2 = [1:length(mask2)];
        inds3 = [1:length(mask3)];
        onset_inds1 = inds1([false diff(mask1)>0]); % take the backward difference but keep the values greater than zero, disregard the first index, find the index value which corresponds to those positive differences
        
        end_inds1 = inds1([false diff(mask1)<0]); % take the backward difference but keep the values less than zero, disregard the first index, find the index value which corresponds to those negative differences
        
        onset_inds2 = inds2([false diff(mask2)>0]); % take the backward difference but keep the values greater than zero, disregard the first index, find the index value which corresponds to those positive differences
        
        end_inds2 = inds2([false diff(mask2)<0]); % take the backward difference but keep the values less than zero, disregard the first index, find the index value which corresponds to those negative differences
        
        onset_inds3 = inds3([false diff(mask3)>0]); % take the backward difference but keep the values greater than zero, disregard the first index, find the index value which corresponds to those positive differences
        
        end_inds3 = inds3([false diff(mask3)<0]); % take the backward difference but keep the values less than zero, disregard the first index, find the index value which corresponds to those negative differences

        if length(onset_inds1)~=length(end_inds1)
            go = 1;
            steps = 1;
            while go
                if length(onset_inds1)==length(end_inds1)
                    go = 0;
                else
                    if steps>length(onset_inds1)
                        end_inds1(steps:end) =[];
                        go = 0;
                    elseif steps>length(end_inds1)
                        onset_inds1(steps:end) =[];
                        go = 0;
                    else
                        if (end_inds1(steps)-onset_inds1(steps))<0
                            end_inds1(steps) = [];
                            steps = steps-1;
                        elseif ((end_inds1(steps)-onset_inds1(steps))>0) && (onset_inds1(steps+1)<end_inds1(steps))
                            onset_inds1(steps) = [];
                            steps = steps-1;
                        end
                        
                    end
                end
                steps = steps +1;
            end
        end
        
        if length(onset_inds2)~=length(end_inds2)
            go = 1;
            steps = 1;
            while go
                if length(onset_inds2)==length(end_inds2)
                    go = 0;
                else
                    if steps>length(onset_inds2)
                        end_inds2(steps:end) =[];
                        go = 0;
                    elseif steps>length(end_inds2)
                        onset_inds2(steps:end) =[];
                        go = 0;
                    else
                        if (end_inds2(steps)-onset_inds2(steps))<0
                            end_inds2(steps) = [];
                            steps = steps-1;
                        elseif ((end_inds2(steps)-onset_inds2(steps))>0) && (onset_inds2(steps+1)<end_inds2(steps))
                            onset_inds2(steps) = [];
                            steps = steps-1;
                        end
                        
                    end
                end
                steps = steps +1;
            end
        end
        
        if length(onset_inds3)~=length(end_inds3)
            go = 1;
            steps = 1;
            while go
                if length(onset_inds3)==length(end_inds3)
                    go = 0;
                else
                    if steps>length(onset_inds3)
                        end_inds3(steps:end) =[];
                        go = 0;
                    elseif steps>length(end_inds3)
                        onset_inds3(steps:end) =[];
                        go = 0;
                    else
                        if (end_inds3(steps)-onset_inds3(steps))<0
                            end_inds3(steps) = [];
                            steps = steps-1;
                        elseif ((end_inds3(steps)-onset_inds3(steps))>0) && (onset_inds3(steps+1)<end_inds3(steps))
                            onset_inds3(steps) = [];
                            steps = steps-1;
                        end
                        
                    end
                end
                steps = steps +1;
            end
        end
        oFinal1 = onset_inds1((end_inds1-onset_inds1)>500);
        eFinal1 = end_inds1((end_inds1-onset_inds1)>500);
        oFinal2 = onset_inds2((end_inds2-onset_inds2)>500);
        eFinal2 = end_inds2((end_inds2-onset_inds2)>500);
        oFinal3 = onset_inds3((end_inds3-onset_inds3)>500);
        eFinal3 = end_inds3((end_inds3-onset_inds3)>500);
        if any(diff(oFinal1)>10000)
            oFinal1(1) = [];
            eFinal1(1) = [];
        end
        if any(diff(oFinal2)>10000)
            oFinal2(1) = [];
            eFinal2(1) = [];
        end
         if any(diff(oFinal3)>10000)
            oFinal3(1) = [];
            eFinal3(1) = [];
        end
        toDel = [];
        pos = 1;
        ap = 1;
        go = 1;
        while go
            dist = [];
            for c = 1:length(oFinal1)-1
                dist = [dist oFinal1(c+1)-eFinal1(c)];
            end
            [minDist,r] = min(dist);
            check1 = mean(diff(coils(oFinal1(r):eFinal1(r),inds2plot(1))));
            check2 = mean(diff(coils(oFinal1(r+1):eFinal1(r+1),inds2plot(1))));
            if minDist<1000
            if check1>check2
                oFinal1(r) = [];
                eFinal1(r) = [];
            else
                oFinal1(r+1) = [];
                eFinal1(r+1) = [];
            end
            end
                                        [~,maxPos]=max(abs(coils(oFinal1(ap),inds2plot)));
                switch pos
                    case {1,2}
                        if maxPos == 1
                            if pos >1
                                if coils(oFinal1(ap-1),inds2plot(1))>0
                                    if coils(oFinal1(ap),inds2plot(1))>0
                                        toDel = [toDel ap];
                                    else
                                        pos = pos + 1;
                                    end
                                else
                                    if coils(oFinal1(ap),inds2plot(1))<0
                                        toDel = [toDel ap];
                                    else
                                       pos = pos + 1; 
                                    end
                                end
                            else
                                pos = pos + 1;
                            end
                            
                        else
                            toDel = [toDel ap];
                        end
                    case {3,4}
                        if maxPos == 2
                            if pos >3
                                if coils(oFinal1(ap-1),inds2plot(2))>0
                                    if coils(oFinal1(ap),inds2plot(2))>0
                                        toDel = [toDel ap];
                                    else
                                        pos = pos + 1;
                                    end
                                else
                                    if coils(oFinal1(ap),inds2plot(2))<0
                                        toDel = [toDel ap];
                                    else
                                       pos = pos + 1; 
                                    end
                                end
                                else
                                pos = pos + 1;
                            end
                        else
                            toDel = [toDel ap];
                        end
                    case {5,6}
                        if maxPos == 3
                         if pos >5
                                if coils(oFinal1(ap-1),inds2plot(3))>0
                                    if coils(oFinal1(ap),inds2plot(3))>0
                                        toDel = [toDel ap];
                                    else
                                        pos = pos + 1;
                                    end
                                else
                                    if coils(oFinal1(ap),inds2plot(3))<0
                                        toDel = [toDel ap];
                                    else
                                       pos = pos + 1; 
                                    end
                                end
                                else
                                pos = pos + 1;
                            end

                        else
                            toDel = [toDel ap];
                        end
                end
                ap = ap + 1;
                if ap == length(oFinal1)
                    go = 0;
                elseif length(oFinal1) == 6
                    go = 0;
                end
        end
        oFinal1(toDel) = [];
        eFinal1(toDel) = [];
        if length(oFinal1)>6
            oFinal1(7:end) = [];
        end
        if length(eFinal1)>6
            eFinal1(7:end) = [];
        end
        
        toDel = [];
        pos = 1;
        ap = 1;
        go = 1;
        while go
            dist = [];
            for c = 1:length(oFinal2)-1
                dist = [dist oFinal2(c+1)-eFinal2(c)];
            end
            [minDist,r] = min(dist);
            check1 = mean(diff(coils(oFinal2(r):eFinal2(r),inds2plot(1))));
            check2 = mean(diff(coils(oFinal2(r+1):eFinal2(r+1),inds2plot(1))));
            if minDist<1000
            if check1>check2
                oFinal2(r) = [];
                eFinal2(r) = [];
            else
                oFinal2(r+1) = [];
                eFinal2(r+1) = [];
            end
            end
                                        [~,maxPos]=max(abs(coils(oFinal2(ap),inds2plot)));
                switch pos
                    case {1,2}
                        if maxPos == 1
                            if pos >1
                                if coils(oFinal2(ap-1),inds2plot(1))>0
                                    if coils(oFinal2(ap),inds2plot(1))>0
                                        toDel = [toDel ap];
                                    else
                                        pos = pos + 1;
                                    end
                                else
                                    if coils(oFinal2(ap),inds2plot(1))<0
                                        toDel = [toDel ap];
                                    else
                                       pos = pos + 1; 
                                    end
                                end
                                else
                                pos = pos + 1;
                            end
                        else
                            toDel = [toDel ap];
                        end
                    case {3,4}
                        if maxPos == 2
                            if pos >3
                                if coils(oFinal2(ap-1),inds2plot(2))>0
                                    if coils(oFinal2(ap),inds2plot(2))>0
                                        toDel = [toDel ap];
                                    else
                                        pos = pos + 1;
                                    end
                                else
                                    if coils(oFinal2(ap),inds2plot(2))<0
                                        toDel = [toDel ap];
                                    else
                                       pos = pos + 1; 
                                    end
                                end
                                else
                                pos = pos + 1;
                            end
                        else
                            toDel = [toDel ap];
                        end
                    case {5,6}
                        if maxPos == 3
                            if pos >5
                                if coils(oFinal2(ap-1),inds2plot(3))>0
                                    if coils(oFinal2(ap),inds2plot(3))>0
                                        toDel = [toDel ap];
                                    else
                                        pos = pos + 1;
                                    end
                                else
                                    if coils(oFinal2(ap),inds2plot(3))<0
                                        toDel = [toDel ap];
                                    else
                                       pos = pos + 1; 
                                    end
                                end
                                else
                                pos = pos + 1;
                            end
                        else
                            toDel = [toDel ap];
                        end
                end
                ap = ap + 1;
                if ap == length(oFinal2)
                    go = 0;
                elseif length(oFinal2) == 6
                    go = 0;
                end
        end
        oFinal2(toDel) = [];
        eFinal2(toDel) = [];
        if length(oFinal2)>6
            oFinal2(7:end) = [];
        end
        if length(eFinal2)>6
            eFinal2(7:end) = [];
        end
        
        toDel = [];
        pos = 1;
        ap = 1;
        go = 1;
        while go
            dist = [];
            for c = 1:length(oFinal3)-1
                dist = [dist oFinal3(c+1)-eFinal3(c)];
            end
            [minDist,r] = min(dist);
            check1 = mean(diff(coils(oFinal3(r):eFinal3(r),inds2plot(1))));
            check2 = mean(diff(coils(oFinal3(r+1):eFinal3(r+1),inds2plot(1))));
            if minDist<1000
            if check1>check2
                oFinal3(r) = [];
                eFinal3(r) = [];
            else
                oFinal3(r+1) = [];
                eFinal3(r+1) = [];
            end
            end
                                        [~,maxPos]=max(abs(coils(oFinal3(ap),inds2plot)));
                switch pos
                    case {1,2}
                        if maxPos == 1
                            if pos >1
                                if coils(oFinal3(ap-1),inds2plot(1))>0
                                    if coils(oFinal3(ap),inds2plot(1))>0
                                        toDel = [toDel ap];
                                    else
                                        pos = pos + 1;
                                    end
                                else
                                    if coils(oFinal3(ap),inds2plot(1))<0
                                        toDel = [toDel ap];
                                    else
                                       pos = pos + 1; 
                                    end
                                end
                                else
                                pos = pos + 1;
                            end
                        else
                            toDel = [toDel ap];
                        end
                    case {3,4}
                        if maxPos == 2
                            if pos >3
                                if coils(oFinal3(ap-1),inds2plot(2))>0
                                    if coils(oFinal3(ap),inds2plot(2))>0
                                        toDel = [toDel ap];
                                    else
                                        pos = pos + 1;
                                    end
                                else
                                    if coils(oFinal3(ap),inds2plot(2))<0
                                        toDel = [toDel ap];
                                    else
                                       pos = pos + 1; 
                                    end
                                end
                                else
                                pos = pos + 1;
                            end
                        else
                            toDel = [toDel ap];
                        end
                    case {5,6}
                        if maxPos == 3
                            if pos >5
                                if coils(oFinal3(ap-1),inds2plot(3))>0
                                    if coils(oFinal3(ap),inds2plot(3))>0
                                        toDel = [toDel ap];
                                    else
                                        pos = pos + 1;
                                    end
                                else
                                    if coils(oFinal3(ap),inds2plot(3))<0
                                        toDel = [toDel ap];
                                    else
                                       pos = pos + 1; 
                                    end
                                end
                                else
                                pos = pos + 1;
                            end
                        else
                            toDel = [toDel ap];
                        end
                end
                ap = ap + 1;
                if ap == length(oFinal3)
                    go = 0;
                elseif length(oFinal3) == 6
                    go = 0;
                end
        end
        oFinal3(toDel) = [];
        eFinal3(toDel) = [];
        if length(oFinal3)>6
            oFinal3(7:end) = [];
        end
        if length(eFinal3)>6
            eFinal3(7:end) = [];
        end

        plot(repmat(oFinal1',1,3),coils(oFinal1,inds2plot(1)),'bx','MarkerSize',5)
        plot(repmat(eFinal1',1,3),coils(eFinal1,inds2plot(1)),'kx','MarkerSize',5)
        plot(repmat(oFinal2',1,3),coils(oFinal2,inds2plot(2)),'bx','MarkerSize',5)
        plot(repmat(eFinal2',1,3),coils(eFinal2,inds2plot(2)),'kx','MarkerSize',5)
        plot(repmat(oFinal3',1,3),coils(oFinal3,inds2plot(3)),'bx','MarkerSize',5)
        plot(repmat(eFinal3',1,3),coils(eFinal3,inds2plot(3)),'kx','MarkerSize',5)
       
        oFinal = [];
        eFinal = [];
        for ch = 1:6
            chMat = [mean(abs(gradient(coils(oFinal1(ch):eFinal1(ch),inds2plot(1))))) mean(abs(gradient(coils(oFinal1(ch):eFinal1(ch),inds2plot(2))))) mean(abs(gradient(coils(oFinal1(ch):eFinal1(ch),inds2plot(3)))));...
                         mean(abs(gradient(coils(oFinal2(ch):eFinal2(ch),inds2plot(1))))) mean(abs(gradient(coils(oFinal2(ch):eFinal2(ch),inds2plot(2))))) mean(abs(gradient(coils(oFinal2(ch):eFinal2(ch),inds2plot(3)))));...
                         mean(abs(gradient(coils(oFinal3(ch):eFinal3(ch),inds2plot(1))))) mean(abs(gradient(coils(oFinal3(ch):eFinal3(ch),inds2plot(2))))) mean(abs(gradient(coils(oFinal3(ch):eFinal3(ch),inds2plot(3)))));];
                     [mean(chMat(1,:)); mean(chMat(2,:)); mean(chMat(3,:))];
                     [~,k]=min([mean(chMat(1,:)); mean(chMat(2,:)); mean(chMat(3,:))]);    
            switch mode(k)
                case 1
                  oFinal = [oFinal;oFinal1(ch)];
                  eFinal = [eFinal;eFinal1(ch)];  
                case 2
                    oFinal = [oFinal;oFinal2(ch)];
                  eFinal = [eFinal;eFinal2(ch)];
                case 3
                    oFinal = [oFinal;oFinal3(ch)];
                  eFinal = [eFinal;eFinal3(ch)];
            end
        end
        plot(eFinal,linspace(3500000,3500000,6),'r*')
        plot(oFinal,linspace(3500000,3500000,6),'g*')
         hold off
        legend('X field','Y field','Z field')
        ranges = [];
        
        for t = 1:length(oFinal)
            ranges = [ranges; oFinal(t) eFinal(t)];
        end
        coils = [];
        coils = readcoils(directory,files{i}, true);
        for j = 1:2
            posX(i,j) = mean(coils(ranges(1,1):ranges(1,2),6 + 3*(j-1)+6*(i-1)));
            negX(i,j) = mean(coils(ranges(2,1):ranges(2,2),6 + 3*(j-1)+6*(i-1)));
            posY(i,j) = mean(coils(ranges(3,1):ranges(3,2),7 + 3*(j-1)+6*(i-1)));
            negY(i,j) = mean(coils(ranges(4,1):ranges(4,2),7 + 3*(j-1)+6*(i-1)));
            posZ(i,j) = mean(coils(ranges(5,1):ranges(5,2),8 + 3*(j-1)+6*(i-1)));
            negZ(i,j) = mean(coils(ranges(6,1):ranges(6,2),8 + 3*(j-1)+6*(i-1)));
            
            offsetX(i,j) = (posX(i,j) + negX(i,j))/2;
            offsetY(i,j) = (posY(i,j) + negY(i,j))/2;
            offsetZ(i,j) = (posZ(i,j) + negZ(i,j))/2;
            
            gainX(i,j) = (posX(i,j) - offsetX(i,j))/2^30;
            gainY(i,j) = (posY(i,j) - offsetY(i,j))/2^30;
            gainZ(i,j) = (posZ(i,j) - offsetZ(i,j))/2^30;
        end
    end
    gainmatrix = [gainX(1,1) gainY(1,1) gainZ(1,1); gainX(1,2) gainY(1,2) gainZ(1,2); gainX(2,1) gainY(2,1) gainZ(2,1); gainX(2,2) gainY(2,2) gainZ(2,2)];
    listing = dir(directory);
    if toPlot == 2
        dashes = find(files{2}=='-');
    uscore = find(files{2}=='_'); 
    if isempty(dashes)
        name = [files{2}(1:uscore(2)-1),'-GainsToUse.txt'];
    else
        name = [files{2}(1:dashes(2)-1),'-GainsToUse.txt'];
    end
    else
        dashes = find(files{1}=='-');
    uscore = find(files{1}=='_');
    if isempty(dashes)
        name = [files{1}(1:uscore(2)-1),'-GainsToUse.txt'];
    else
        name = [files{1}(1:dashes(2)-1),'-GainsToUse.txt'];
    end
    end
    
    gainFileName = name;

        dlmwrite([directory, name] ,gainmatrix,'delimiter',' ','newline','pc')
end