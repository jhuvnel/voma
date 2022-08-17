
max7D.M
max7CC.M
max7Inter.M
max8D.M
max8CC.M
max8Inter.M
max9D.M
max9CC.M
max9Inter.M
max15D.M
max15CC.M
max15Inter.M
max7D.V
max7CC.V
max7Inter.V
max8D.V
max8CC.V
max8Inter.V
max9D.V
max9CC.V
max9Inter.V
max15D.V
max15CC.V
max15Inter.V
%%
clc
max15D
[mean([cycles.(max15D.M).avgMisalign]') std([cycles.(max15D.M).avgMisalign]')]



[mean([cycles.(max15D.V).maxMag]') std([cycles.(max15D.V).maxMag]')]





%Table for max mag eye, min misalignment, and most ideal case
%%
[p,h,stats] = ranksum(cycles.(max7D.M).avgMisalign,cycles.(max7CC.M).avgMisalign,'alpha',0.05,'tail','left')
[p,h,stats] = ranksum(cycles.(max7D.M).avgMisalign,cycles.(max7Inter.M).avgMisalign,'alpha',0.05,'tail','right')
[p,h,stats] = ranksum(cycles.(max7Inter.M).avgMisalign,cycles.(max7CC.M).avgMisalign,'alpha',0.05,'tail','left')
%%
[p,h,stats] = ranksum(cycles.(max7D.V).maxMag,cycles.(max7CC.V).maxMag,'alpha',0.05,'tail','left')
[p,h,stats] = ranksum(cycles.(max7D.V).maxMag,cycles.(max7Inter.V).maxMag,'alpha',0.05,'tail','right')

[p,h,stats] = ranksum(cycles.(max7Inter.V).maxMag,cycles.(max7CC.V).maxMag,'alpha',0.05,'tail','left')
%% Is 15 v> and M<
[p,h,stats] = ranksum(cycles.(max15CC.V).maxMag,cycles.(max7CC.V).maxMag,'alpha',0.05,'tail','right')
[p,h,stats] = ranksum(cycles.(max15CC.V).maxMag,cycles.(max8CC.V).maxMag,'alpha',0.05,'tail','right')
[p,h,stats] = ranksum(cycles.(max15CC.V).maxMag,cycles.(max9CC.V).maxMag,'alpha',0.05,'tail','right')

[p,h,stats] = ranksum(cycles.(max15CC.M).avgMisalign,cycles.(max7CC.M).avgMisalign,'alpha',0.05,'tail','left')
[p,h,stats] = ranksum(cycles.(max15CC.M).avgMisalign,cycles.(max8CC.M).avgMisalign,'alpha',0.05,'tail','left')
[p,h,stats] = ranksum(cycles.(max15CC.M).avgMisalign,cycles.(max9CC.M).avgMisalign,'alpha',0.05,'tail','left')
%%
[p1,h,stats] = ranksum(cycles.stim7ref12amp100.maxMag,cycles.stim7ref10amp100.maxMag,'alpha',0.05,'tail','right')
% [p2,h,stats] = ranksum(cycles.stim7ref12amp100.maxMag,cycles.stim7ref13amp100.maxMag,'alpha',0.05,'tail','right')


[p3,h,stats] = ranksum(cycles.stim7ref12amp100.avgMisalign,cycles.stim7ref10amp100.avgMisalign,'alpha',0.05,'tail','left')
% [p4,h,stats] = ranksum(cycles.stim7ref12amp100.avgMisalign,cycles.stim7ref13amp100.avgMisalign,'alpha',0.05,'tail','left')
[p1 p2 p3 p4]
%%
[p1,h,stats] = ranksum(cycles.stim8ref12amp100.maxMag,cycles.stim8ref10amp100.maxMag,'alpha',0.05,'tail','right')
% [p2,h,stats] = ranksum(cycles.stim8ref12amp100.maxMag,cycles.stim8ref13amp100.maxMag,'alpha',0.05,'tail','right')


[p3,h,stats] = ranksum(cycles.stim8ref12amp100.avgMisalign,cycles.stim8ref10amp100.avgMisalign,'alpha',0.05,'tail','left')
% [p4,h,stats] = ranksum(cycles.stim8ref12amp100.avgMisalign,cycles.stim8ref13amp100.avgMisalign,'alpha',0.05,'tail','left')
[p1 p2 p3 p4]
%%
[p1,h,stats] = ranksum(cycles.stim9ref12amp100.maxMag,cycles.stim9ref10amp100.maxMag,'alpha',0.05,'tail','right')
% [p2,h,stats] = ranksum(cycles.stim9ref12amp100.maxMag,cycles.stim9ref13amp100.maxMag,'alpha',0.05,'tail','right')


[p3,h,stats] = ranksum(cycles.stim9ref12amp100.avgMisalign,cycles.stim9ref10amp100.avgMisalign,'alpha',0.05,'tail','left')
% [p4,h,stats] = ranksum(cycles.stim9ref12amp100.avgMisalign,cycles.stim9ref13amp100.avgMisalign,'alpha',0.05,'tail','left')
[p1 p2 p3 p4]
%%
[p1,h,stats] = ranksum(cycles.stim15ref12amp100.maxMag,cycles.stim15ref10amp100.maxMag,'alpha',0.05,'tail','right')
% [p2,h,stats] = ranksum(cycles.stim15ref12amp100.maxMag,cycles.stim15ref13amp100.maxMag,'alpha',0.05,'tail','right')


[p3,h,stats] = ranksum(cycles.stim15ref12amp100.avgMisalign,cycles.stim15ref10amp100.avgMisalign,'alpha',0.05,'tail','left')
% [p4,h,stats] = ranksum(cycles.stim15ref12amp100.avgMisalign,cycles.stim15ref13amp100.avgMisalign,'alpha',0.05,'tail','left')
[p1 p2 p3 p4]
%%
[p1,h,stats] = ranksum(cycles.stim15ref12amp125.maxMag,cycles.stim15ref10amp125.maxMag,'alpha',0.05,'tail','right')
[p2,h,stats] = ranksum(cycles.stim15ref12amp125.maxMag,cycles.stim15ref7amp125.maxMag,'alpha',0.05,'tail','right')


[p3,h,stats] = ranksum(cycles.stim15ref12amp125.avgMisalign,cycles.stim15ref10amp125.avgMisalign,'alpha',0.05,'tail','left')
[p4,h,stats] = ranksum(cycles.stim15ref12amp125.avgMisalign,cycles.stim15ref7amp125.avgMisalign,'alpha',0.05,'tail','left')
[p1 p2 p3 p4]
% cycles.stim7ref12amp300.maxMag
% cycles.stim7ref12amp300.avgMisalign
% cycles.stim7ref11amp300.maxMag
% cycles.stim7ref11amp300.avgMisalign
% cycles.stim7ref13amp300.maxMag
% cycles.stim7ref13amp300.avgMisalign