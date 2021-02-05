%% Position Plot
% Line 1120 of Monkey_Voma_Processing
f = figure('units','normalized','outerposition',[0 0 1 1]);
 a = copyobj(handles.angPos,f);
 a.FontSize = 17;
a.Position = [0.05 .08 .95 .87];
a.LineWidth = 2.5;
a.XLabel.String = 'Time (s)';
a.YLabel.String = {'Angular Position (degrees)'};
a.YLabel.FontSize = 22;
a.XLabel.FontSize = 22;
a.Title.String = 'Electrical Stimulation Cycles, Animal N, Left Eye Angular Position';
a.Title.FontSize = 25;
delete(a.Children(1:21))
set([a.Children(1:20)],'LineStyle','--') %Set 100ms cuttoff lines to new line style
set([a.Children(1:20)],'LineWidth',1.5);
set([a.Children(1:20)],'YData',[-40 40]);
a.Children(21).MarkerSize = 10;
a.Children(21).LineWidth = 1.5;
a.Children(21).YData = (a.Children(21).YData./20)-50;
a.Children(22).LineWidth = 1.5;
a.Children(22).YData = (a.Children(22).YData./20)-50;
set([a.Children(23:25)],'LineWidth',1.5)
a.XLim = [0 14];
a.YLim = [-50 50];
ps = [a.Children(25) a.Children(24) a.Children(23) a.Children(22) a.Children(21) a.Children(20)];
psName = [{'X Component of Eye Position'} {'Y Component of Eye Position'} {'Z Component of Eye Position'} {'Stimulation Sync Signal'} {'Start of New Cycle'} {'100ms After Start of New Cycle'}];
%l = legend(a,ps,psName);
%l.Position = [0.6246 0.7476 0.1455 0.1342];
figDir = 'R:\Morris, Brian\Monkey Data\Nancy\20191118\Figures\';
name = 'Nancy_Leye Position cycles';
saveas(f,[figDir,name,'.svg']);
saveas(f,[figDir,name,'.jpg']);
saveas(f,[figDir,name,'.fig']);
%% Velocity Plot 
% Line 1321 of Monkey_Voma_Processing
f = figure('units','normalized','outerposition',[0 0 1 1]);
 a = copyobj(handles.axes1,f);
a.FontSize = 17;
a.Position = [0.05 .08 .95 .87];
a.LineWidth = 2.5;
a.XLabel.String = 'Time (s)';
a.YLabel.String = {'Angular Velocity (dps)'};
a.YLabel.FontSize = 22;
a.XLabel.FontSize = 22;
a.Title.String = 'Electrical Stimulation Cycles, Animal N, Left Eye Angular Velocity'
a.Title.FontSize = 25;
a.Children(6).Color = 'r';
a.Children(18).Color = 'r';
delete([a.Children(24:41)])% Delete 30ms cycle cutoff lines
a.Children(24).LineStyle = 'none';
a.Children(25).LineStyle = 'none';
set([a.Children(26:45)],'LineStyle','--') %Set 100ms cuttoff lines to new line style
set([a.Children(26:45)],'LineWidth',1.5)
a.Children(50).LineWidth = 1.5;
a.Children(49).LineWidth = 1.5;
a.Children(48).LineWidth = 1.5;
a.Children(47).LineWidth = 1.5;
a.Children(46).MarkerSize = 10;
a.Children(46).LineWidth = 1.5;
a.Children(21).MarkerSize = 10;
a.Children(21).LineWidth = 1.5;

a.Children(22).MarkerSize = 10;
a.Children(22).LineWidth = 1.5;

a.Children(23).MarkerSize = 10;
a.Children(23).LineWidth = 1.5;
a.XLim = [0 7];
a.YLim = [-200 250];
a.Children(47).YData = (a.Children(47).YData./10)-200;
a.Children(46).YData = (a.Children(46).YData./10)-200;
ps = [a.Children(50) a.Children(49) a.Children(48) a.Children(47) a.Children(46) a.Children(21) a.Children(26) a.Children(24) a.Children(25)];
psName = [{'LARP Component of Eye Velocity'} {'RALP Component of Eye Velocity'} {'Horizontal Component of Eye Velocity'} {'Stimulation Sync Signal'} {'Start of New Cycle'} {'Position of Chosen Magnitude For Each Cycle'} {'100ms After Start of New Cycle'} {['\color{green} 1','\color{black} Accepted Cycle Number']} {['\color{red} 3','\color{black} Rejected Cycle Number']}];
%l = legend(a,ps,psName);
%l.Position = [0.5753 0.7166 0.2012 0.1996]
figDir = 'R:\Morris, Brian\Monkey Data\Nancy\20191118\Figures\';
name = 'Nancy_Leye velocity cycles';
saveas(f,[figDir,name,'.svg']);
saveas(f,[figDir,name,'.jpg']);
saveas(f,[figDir,name,'.fig']);
% 
%  1 Text    (20)
%  2 Text    (19)
%  3 Text    (18)
%  4 Text    (17)
%  5 Text    (16)
%  6 Text    (15)
%  7 Text    (14)
%  8 Text    (13)
%  9 Text    (12)
%  10 Text    (11)
%  11 Text    (10)
%  12 Text    (9)
%  13 Text    (8)
%  14 Text    (7)
%  15 Text    (6)
%  16 Text    (5)
%  17 Text    (4)
%  18 Text    (3)
%  19 Text    (2)
%  20 Text    (1)
%  21 Line
%  22 Line
%  23 Line
% %  24
% %  25
% %  26
% %  27
% %  28
% %  29
% %  30
% %  31
% %  32
% %  33
% %  34
% %  35
% %  36
% %  37
% %  38
% %  39
% %  40
% %  41
% %  42
% %  43
%  24 Line
%  25 Line
%  26 Line
%  27 Line
%  28 Line
%  29 Line
%  30 Line
%  31 Line
%  32 Line
%  33 Line
%  34 Line
%  35 Line
%  36 Line
%  37 Line
%  38 Line
%  39 Line
%  40 Line
%  41 Line
%  42 Line
%  43 Line
%  44 Line
%  45 Line
%   Line
%   Line
%   Line