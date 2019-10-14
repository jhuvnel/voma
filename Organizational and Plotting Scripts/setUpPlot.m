function setUpPlot(figNum,numSubs,lim,R,LEN)

if nargin<4
LEN = 1;
R = 0.5;
end
figure(figNum)

if(exist('lim','var') == 0)
    lim=5;
end

for i=1:numSubs
    subplot(numSubs/2,2,i) %%%RIGHT EYE
    hold on;
    %handles=plot3vect([LEN;0;0],'Roll Axis',[0 0 0.6],2);
    %set(handles,'LineStyle','--','Marker','o');
    %handles=plot3vect([0;LEN;0],'Pitch Axis',[0 0.45 0],2);
    %set(handles,'LineStyle','--','Marker','o');
    handles=plot3vect([LEN/sqrt(2);-LEN/sqrt(2);0],'LARP Axis',[0 1 0],2);
    set(handles,'LineStyle','--','Marker','o');
    handles=plot3vect([LEN/sqrt(2);LEN/sqrt(2);0],'RALP Axis',[0 1 1],2);
    set(handles,'LineStyle','--','Marker','o');
    handles=plot3vect([0;0;LEN],'Yaw Axis',[0.68 0 0],2);
    set(handles,'LineStyle','--','Marker','o');
    

    
    grid on;
    [x,y,z]=sphere();
    h=surf(R*x,R*y,R*z);
    set(h,'FaceColor','white')
    axis vis3d
    axis equal
    box on;
    xlim([-lim lim])
    ylim([-lim lim])
    zlim([-lim lim])
end
legend('LARP','RALP','Yaw');
end

