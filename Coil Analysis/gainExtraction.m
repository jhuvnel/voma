function gainmatrix = gainExtraction(directory,fileCh1Ch2,fileCh3Ch4)
gainX = [];
gainY = [];
gainZ = [];

if ~isempty(fileCh1Ch2) && ~isempty(fileCh3Ch4)
    total = 2;
    toPlot = 3;
    files = {fileCh1Ch2,fileCh3Ch4};
elseif isempty(fileCh1Ch2)
    total = 1;
    toPlot = 2;
    files = {fileCh3Ch4};
    gainX(2,1) = 0;
    gainY(2,1) = 0;
    gainZ(2,1) = 0;
    gainX(2,2) = 0;
    gainY(2,2) = 0;
    gainZ(2,2) = 0;
elseif isempty(fileCh3Ch4)
    total = 1;
    toPlot = 1;
    files = {fileCh1Ch2};
    gainX(1,1) = 0;
    gainY(1,1) = 0;
    gainZ(1,1) = 0;
    gainX(1,2) = 0;
    gainY(1,2) = 0;
    gainZ(1,2) = 0;
end

if isempty(fileCh1Ch2) && isempty(fileCh3Ch4)
else
    
    % ranges = [ +X1 +X2; -X1 -X2; +Y1 +Y2; -Y1 -Y2; +Z1 +Z2; -Z1 -Z2]; ch1ch2
    % ranges(:,:,2) = same format ch3ch4
    
    for i = 1:total
        coils = [];
        coilsWithProsthSync=readcoils(directory,files{i}, true);
        coils(:,1:3)=coilsWithProsthSync(:,1:3);
        
        
        coils(:,4:15)=coilsWithProsthSync(:,6:17);
        confirmFig = figure;
        if toPlot == 3
            if i == 1
            inds2plot = 4:6;
            toUse = coils(:,4);
            plotTitle = 'Ch1Ch2';
            else
                inds2plot = 10:12;

                toUse = coils(:,10);
                plotTitle = 'Ch3Ch4';
            end
        elseif toPlot == 2
            inds2plot = 10:12;

            toUse = coils(:,10);
            plotTitle = 'Ch3Ch4';
        elseif toPlot == 1
            inds2plot = 4:6;

            toUse = coils(:,4);
            plotTitle = 'Ch1Ch2';
        end
        plot(coils(:,inds2plot));grid on;zoom on
        title(plotTitle)
        hold on

        f=filtfilt(ones(1,415)/415,1,gradient(toUse));
        ff = gradient(f);
        mask = zeros(1,length(ff));
        mask(abs(ff)<15) = 1;
        inds = [1:length(mask)];
        onset_inds = inds([false diff(mask)>0]); % take the backward difference but keep the values greater than zero, disregard the first index, find the index value which corresponds to those positive differences
        
        end_inds = inds([false diff(mask)<0]); % take the backward difference but keep the values less than zero, disregard the first index, find the index value which corresponds to those negative differences
        if length(onset_inds)~=length(end_inds)
            go = 1;
            steps = 1;
            while go
                if length(onset_inds)==length(end_inds)
                    go = 0;
                else
                    if steps>length(onset_inds)
                        end_inds(steps:end) =[];
                        go = 0;
                    elseif steps>length(end_inds)
                        onset_inds(steps:end) =[];
                        go = 0;
                    else
                        if (end_inds(steps)-onset_inds(steps))<0
                            end_inds(steps) = [];
                            steps = steps-1;
                        elseif ((end_inds(steps)-onset_inds(steps))>0) && (onset_inds(steps+1)<end_inds(steps))
                            onset_inds(steps) = [];
                            steps = steps-1;
                        end
                        
                    end
                end
                steps = steps +1;
            end
        end
        oFinal = onset_inds((end_inds-onset_inds)>1500);
        eFinal = end_inds((end_inds-onset_inds)>1500);
        toDel = [];
        pos = 1;
        ap = 1;
        go = 1;
        while go
            dist = [];
            for c = 1:length(oFinal)-1
                dist = [dist oFinal(c+1)-eFinal(c)];
            end
            [minDist,r] = min(dist);
            check1 = mean(diff(coils(oFinal(r):eFinal(r),inds2plot(1))));
            check2 = mean(diff(coils(oFinal(r+1):eFinal(r+1),inds2plot(1))));
            if minDist<1000
            if check1>check2
                oFinal(r) = [];
                eFinal(r) = [];
            else
                oFinal(r+1) = [];
                eFinal(r+1) = [];
            end
            end
                                        [~,maxPos]=max(abs(coils(oFinal(ap),inds2plot)));
                switch pos
                    case {1,2}
                        if maxPos == 1
                            pos = pos + 1;
                        else
                            toDel = [toDel ap];
                        end
                    case {3,4}
                        if maxPos == 2
                            pos = pos + 1;
                        else
                            toDel = [toDel ap];
                        end
                    case {5,6}
                        if maxPos == 3
                            pos = pos + 1;
                        else
                            toDel = [toDel ap];
                        end
                end
                ap = ap + 1;
                if ap == length(oFinal)
                    go = 0;
                elseif length(oFinal) == 6
                    go = 0;
                end
        end
        oFinal(toDel) = [];
        eFinal(toDel) = [];

        plot(repmat(oFinal',1,3),coils(oFinal,inds2plot),'bx','MarkerSize',5)
        plot(repmat(eFinal',1,3),coils(eFinal,inds2plot),'kx','MarkerSize',5)
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
    dashes = find(files{1}=='-');
    uscore = find(files{1}=='_');
    if isempty(dashes)
        name = [files{1}(1:uscore(1)-1),'-GainsToUse.txt'];
    else
        name = [files{1}(1:dashes(1)-1),'-GainsToUse.txt'];
    end

        dlmwrite([directory, name] ,gainmatrix,'delimiter',' ')
end