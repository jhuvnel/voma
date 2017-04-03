function [rotZ3usingdegreesnotradians] =  rotZ3deg(a)
rotZ3usingdegreesnotradians=   [cosd(a) -sind(a) 0;
                                sind(a)  cosd(a) 0;
                                  0        0     1];
   return
   