function handles=plot3vect(uuu,name,format,width)

%plot 3 vector  with tail at origin
%expects
%   uuu=[ux uy uz]' (a column vector)
%   name=string
%   format = plot format string (e.g., 'k:' for black dotted)

handles=plot3([0 uuu(1)]',[0 uuu(2)]',[0 uuu(3)]');
set(handles,'LineWidth',width,'DisplayName',name,'Color',format)
%text(uuu(1),uuu(2),uuu(3),name);
