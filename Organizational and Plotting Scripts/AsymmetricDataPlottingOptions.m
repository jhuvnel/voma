%%
load('R:\Morris, Brian\Monkey Data\GiGi\All Asymmetric Data\Cycles - Copy\CycleParams.mat');
%%
refId = find(ismember([tempS.ref],[10]));
p1dId = find(ismember([tempS.p1d],[200]));
p2dId = find(ismember([tempS.p2d],[200 300 400 800]));
dsp2dId = find(ismember([tempS.dSp2d],-1));

cut1 = refId(ismember(refId,p1dId));
cut2 = cut1(ismember(cut1,p2dId));
cut3 = cut2(ismember(cut2,dsp2dId));

m = mean([tempS(cut3).meanMagL200])
s = std([tempS(cut3).meanMagL200])

mM = mean([tempS(cut3).meanMisalignL200])
sM = std([tempS(cut3).meanMisalignL200])
%%
mag = [];
mis = [];
figure
for stim = 1:8
    stimId = find(ismember([tempS.stim],[stim]));
refId = find(ismember([tempS.ref],[10]));
p1dId = find(ismember([tempS.p1d],[200]));
p2dId = find(ismember([tempS.p2d],[100]));
dsp2dId = find(ismember([tempS.dSp2d],-1));

cut1 = refId(ismember(refId,stimId));
cut2 = cut1(ismember(cut1,p1dId));
cut3 = cut2(ismember(cut2,p2dId));
cut4 = cut3(ismember(cut3,dsp2dId));
mag = [mag; [tempS(cut4).meanMagL200]];
mis = [mis; [tempS(cut4).meanMisalignL200]];
hold on
plot([0 25 50 100 200 400 600],[tempS(cut4).meanMagL200],'-o')
end
% mean(mag)
% std(mag)
% mean(mis)
% std(mis)


mag = [];
mis = [];
figure
for stim = 1:8
    stimId = find(ismember([tempS.stim],[stim]));
refId = find(ismember([tempS.ref],[10]));
p1dId = find(ismember([tempS.p1d],[200]));
p2dId = find(ismember([tempS.p2d],[50]));
dsp2dId = find(ismember([tempS.dSp2d],-1));

cut1 = refId(ismember(refId,stimId));
cut2 = cut1(ismember(cut1,p1dId));
cut3 = cut2(ismember(cut2,p2dId));
cut4 = cut3(ismember(cut3,dsp2dId));
mag = [mag; [tempS(cut4).meanMagL200]];
mis = [mis; [tempS(cut4).meanMisalignL200]];
hold on
plot([0 25 50 100 200 400 600],[tempS(cut4).meanMagL200],'-o')

end
mean(mag)
std(mag)
mean(mis)
std(mis)
%%
load('R:\Morris, Brian\Monkey Data\Nancy\20210325\AsymmetricCycleParams.mat');
%%
refId = find(ismember([tempS.ref],[10]));
p1dId = find(ismember([tempS.p1d],[200]));
p2dId = find(ismember([tempS.p2d],[200 300 400 800]));
dsp2dId = find(ismember([tempS.dSp2d],-1));

cut1 = refId(ismember(refId,p1dId));
cut2 = cut1(ismember(cut1,p2dId));
cut3 = cut2(ismember(cut2,dsp2dId));

m = mean([tempS(cut3).meanMagR200])
s = std([tempS(cut3).meanMagR200])

mM = mean([tempS(cut3).meanMisalignR200])
sM = std([tempS(cut3).meanMisalignR200])
%%
mag = [];
mis = [];
figure
for stim = [2:9 14]
    stimId = find(ismember([tempS.stim],[stim]));
refId = find(ismember([tempS.ref],[10]));
p1dId = find(ismember([tempS.p1d],[200]));
p2dId = find(ismember([tempS.p2d],[100]));
dsp2dId = find(ismember([tempS.dSp2d],-1));

cut1 = refId(ismember(refId,stimId));
cut2 = cut1(ismember(cut1,p1dId));
cut3 = cut2(ismember(cut2,p2dId));
cut4 = cut3(ismember(cut3,dsp2dId));
mag = [mag; [tempS(cut4).meanMagR200]];
mis = [mis; [tempS(cut4).meanMisalignR200]];
hold on
plot([0 25 50 100 200 400 600],[tempS(cut4).meanMagR200],'-o')
end
% mean(mag)
% std(mag)
% mean(mis)
% std(mis)


mag = [];
mis = [];
figure
for stim = [2:9 14]
    stimId = find(ismember([tempS.stim],[stim]));
refId = find(ismember([tempS.ref],[10]));
p1dId = find(ismember([tempS.p1d],[200]));
p2dId = find(ismember([tempS.p2d],[50]));
dsp2dId = find(ismember([tempS.dSp2d],-1));

cut1 = refId(ismember(refId,stimId));
cut2 = cut1(ismember(cut1,p1dId));
cut3 = cut2(ismember(cut2,p2dId));
cut4 = cut3(ismember(cut3,dsp2dId));
mag = [mag; [tempS(cut4).meanMagR200]];
mis = [mis; [tempS(cut4).meanMisalignR200]];
hold on
plot([0 25 50 100 200 400 600],[tempS(cut4).meanMagR200],'-o')

end
mean(mag)
std(mag)
mean(mis)
std(mis)