function [rotX3usingdegreesnotradians] =  rotX3deg(a)
rotX3usingdegreesnotradians=   [1       0        0;
                                0      cosd(a)  -sind(a);
                                0      sind(a)  cosd(a)];
   return