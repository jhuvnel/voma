function [stim_ind] = voma__find_stim_ind(stim,Fs,t,useradjust)




stim_temp = stim;
%     keyboard
finiteind = isfinite(stim_temp);
startval = stim_temp(finiteind);
startval = ceil(startval(1)*100)/100;

mask=zeros(1,length(stim_temp)); % Creating a mask vector to mark when the stim comes on or off

for k=1:length(stim_temp)
    if stim_temp(k)>=startval
        mask(k)=1;
    end
end


% NOTE: This code is a programatic way to 'detect cycles' of stimuli.
% I realize this is not sufficient for precise timing of the stimuli
% onset, but it should be ok to get insight into the earlier data. I
% first detect the samples where the stimuli was above the threshold
% (which is determined as the 'first non 'NaN' stimuli value', truncaed
% to two decimal places). This works for most stimuli modulated from
% 'steady' baseline rates. I then determine the time duaration of each
% stimuli, and remove a stimuli presentation from the list if it is
% shorter than some duration ('minstim'). I then ID the 'positive' phase of the
% sinusoidal stimuli by combining stimuli that are within some distance
% ('mindist' from one another (i.e. if the threshold causes one stimuli
% period to be split in two with a tiny gap, it will combine them).
mindist=0.07*Fs;
minstim = 0.07*Fs; % Min duration is 70ms

% Check the DURATION of each 'stim presentation'. If it is less than
% 'minstim', then ignore it.
a = find(~mask);
for r=1:(length(a)-1)
    if (a(r+1)-a(r))<minstim
        mask(a(r):a(r+1))=0;
    end
end

% Checks if the time between two stimulus ON samples are within a
% delay, signaling that they are the SAME stimulus presentation
b = find(mask); % Indices where the stim was ON
for r=1:(length(b)-1)
    if (b(r+1)-b(r))<mindist
        mask(b(r):b(r+1))=1;
    end
end

% This was written awhile ago by me and I think this part is
% inefficient. Still, the purpose is to check where the difference in
% indices for the 'NON stimuli' points (i.e., b = find(mask==0)) is
% greater than 1 sample (indicating that the stimulus was on). Note
% that this seems inefficient because the section of code directly
% above this ENSURES that the only non-unitary index differences ARE
% actual stimuli presentations. The code works so I am leaving it for
% now.
b = find(mask==0); % Indices where the stim is OFF
stim = [];
stimcount = 0;
for r = 1:(length(b)-1)
    if (b(r+1)-b(r))>mindist% If the time between two 'OFF' points are greater than 'delay', count that as a real 'stimulus presentation'
        stimcount = stimcount + 1;
        stim = [stim ; b(r),b(r+1)];
    end
end

stim_time = t(stim);


%     plot(t,stim_temp,'k')
%     hold on
%     for k=1:length(stim)
%         plot(t(stim(k,1)),stim_temp(stim(k,1)),'go','LineWidth',2)
%         plot(t(stim(k,2)),stim_temp(stim(k,2)),'mo','LineWidth',2)
%
%     end

stim_ind = stim;

if isempty(stim_ind)
    return
end
if strcmp(useradjust,'y')
   
    h1 = figure
    plot(t,stim_temp)
    hold on
    plot(t(stim_ind(:,1)),stim_temp(stim_ind(:,1)),'kx')
    xlabel('Time [s]')
    ylabel('Inst. Pulse Rate [pps]')
    title(['PLEASE CHOSE TWO POINTS TO LIMIT THE STIMULUS INDICES'])
    
    [x1,y1] = ginput(2)

    stim_times = stim_ind(:,1)/Fs;
    
    [C1,I1] = min(abs(stim_times-x1(1)));
    [C2,I2] = min(abs(stim_times-x1(2)));
    
    stim_ind = stim_ind(I1:I2,:);
    close(h1)
end

end