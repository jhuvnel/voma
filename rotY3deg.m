function [rotY3usingdegreesnotradians] =  rotY3deg(a)
rotY3usingdegreesnotradians=   [cosd(a)  0  sind(a)  ;
                                   0     1     0     ;
                                -sind(a) 0   cosd(a)];
   return
   