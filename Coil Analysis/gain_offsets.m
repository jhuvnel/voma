directory = {'R:\Morris, Brian\Monkey Data\GiGi\20190425\'};
files = {'20190425_ch1ch2_gains.coil', '20190425_ch3ch4_gains.coil'};
% ranges = [ +X1 +X2; -X1 -X2; +Y1 +Y2; -Y1 -Y2; +Z1 +Z2; -Z1 -Z2]; ch1ch2
% ranges(:,:,2) = same format ch3ch4
ranges = [14485 17769; 21774 24761; 28062 31789; 36380 38731; 42128 44197; 47312 54463];
ranges(:,:,2) = [891 5087; 13283 15519; 19585 21880; 26666 29476; 32080 34644; 37161 41270];
for i = 1:2
    coils = readcoils(directory,char(files{i}), true);
    for j = 1:2
        posX(i,j) = mean(coils(ranges(1,1,i):ranges(1,2,i),6 + 3*(j-1)+6*(i-1)));
        negX(i,j) = mean(coils(ranges(2,1,i):ranges(2,2,i),6 + 3*(j-1)+6*(i-1)));
        posY(i,j) = mean(coils(ranges(3,1,i):ranges(3,2,i),7 + 3*(j-1)+6*(i-1)));
        negY(i,j) = mean(coils(ranges(4,1,i):ranges(4,2,i),7 + 3*(j-1)+6*(i-1)));
        posZ(i,j) = mean(coils(ranges(5,1,i):ranges(5,2,i),8 + 3*(j-1)+6*(i-1)));
        negZ(i,j) = mean(coils(ranges(6,1,i):ranges(6,2,i),8 + 3*(j-1)+6*(i-1)));

        offsetX(i,j) = (posX(i,j) + negX(i,j))/2;
        offsetY(i,j) = (posY(i,j) + negY(i,j))/2;
        offsetZ(i,j) = (posZ(i,j) + negZ(i,j))/2;
    
        gainX(i,j) = (posX(i,j) - offsetX(i,j))/2^30;
        gainY(i,j) = (posY(i,j) - offsetY(i,j))/2^30;
        gainZ(i,j) = (posZ(i,j) - offsetZ(i,j))/2^30;
    end
end
gainmatrix = [gainX(1,1) gainY(1,1) gainZ(1,1); gainX(1,2) gainY(1,2) gainZ(1,2); gainX(2,1) gainY(2,1) gainZ(2,1); gainX(2,2) gainY(2,2) gainZ(2,2)];
%%
dlmwrite([directory{1}, '20190402-Yoda-Ch3Ch4.txt'] ,gainmatrix,'delimiter',' ')