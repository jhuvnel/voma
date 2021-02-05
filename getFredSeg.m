function final = getFredSeg(Data)
final = struct();
Data.t = 0:1/Data.Fs:(length(Data.Var_x081)-1)/Data.Fs;
figure
s = filtfilt(ones(1,5)/5,1,Data.Var_x081);
plot(Data.t,s)
hold on
[a,b]=findpeaks(s,Data.t,'MinPeakHeight',18,'MinPeakDistance',.4);
tInds = find(ismember(Data.t,b));
go = 1;
searchInd = 1;
sets = 0;
setIndEnd = [];
while go
    if searchInd <length(b)
        if b(searchInd+1)-b(searchInd)<.75
        else
            sets = sets+1;
            setIndEnd = [setIndEnd searchInd];
        end
    else
        sets = sets+1;
        setIndEnd = [setIndEnd searchInd];
        go = 0;
    end
    searchInd=searchInd+1;
end
prevEnd = 0;
for i = 1:sets
    if (tInds(setIndEnd(i))+Data.Fs*.406)>length(Data.t)
        upper = length(Data.t);
    else
        upper = tInds(setIndEnd(i))+Data.Fs*.406;
    end
sfitTime = Data.t((tInds(1+prevEnd)-round(Data.Fs/8)):upper)-Data.t((tInds(1+prevEnd)-round(Data.Fs/8)));
s2 = (sin(2*pi*2*sfitTime))*6+14;
plot(Data.t((tInds(1+prevEnd)-round(Data.Fs/8)):upper),s2)
inds = [1:length(Data.t)];
pos_ind = [false; diff(s > 14)];
stim_pos_thresh_ind = inds(pos_ind > 0 )';
plot(Data.t(stim_pos_thresh_ind),s(stim_pos_thresh_ind),'r*')
[c,d] = min(sqrt((Data.t(stim_pos_thresh_ind)-Data.t((tInds(1+prevEnd)-round(Data.Fs/8))))'.^2+(s(stim_pos_thresh_ind)-s2(1)).^2));
plot(Data.t(stim_pos_thresh_ind(d)),s(stim_pos_thresh_ind(d)),'go')
tot = 1+prevEnd:setIndEnd(i);
final(i).start = stim_pos_thresh_ind(d);
if stim_pos_thresh_ind(d)+length(tot)*Data.Fs/2>length(Data.t)
    u = length(Data.t)
else
    u = stim_pos_thresh_ind(d)+length(tot)*Data.Fs/2;
end
final(i).end = u;
final(i).Inds = [stim_pos_thresh_ind(d:d+length(tot)-1)]';
sfitTime2 = Data.t(stim_pos_thresh_ind(d):u)-Data.t(stim_pos_thresh_ind(d));
s3 = (sin(2*pi*2*sfitTime2))*6+14;
plot(Data.t(stim_pos_thresh_ind(d):u),s3)
prevEnd = setIndEnd(i);
end
end