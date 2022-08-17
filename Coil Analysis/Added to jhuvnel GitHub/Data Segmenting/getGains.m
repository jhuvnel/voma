function [GAINSR, GAINSL]=getGains(directory,gainFile)

allGains=fopen(strcat(directory,gainFile),'r');

gains=fscanf(allGains,'%f',[3 inf]);

GAINSR=[gains(:,1) gains(:,2)];
GAINSL=[gains(:,3) gains(:,4)];




