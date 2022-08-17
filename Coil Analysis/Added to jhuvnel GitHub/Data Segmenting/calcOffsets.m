function [ZEROS_R, ZEROS_L]=calcOffsets(directory,coilfileOrientation1, coilfileOrientation2, dateStatus)

%date Status just changes which columns you should usefor analysis
%If date status=1 then after 10/19 coil system change.
%If date status=0, then before 10/19 coil system change.


if (dateStatus==0)
    coilData1=readcoils(directory,coilfileOrientation1,0);
    coilData2=readcoils(directory,coilfileOrientation2,0);
    
    ch1o1=mean(coilData1(:,4:6),1);
    ch2o1=mean(coilData1(:,7:9),1);
    ch3o1=mean(coilData1(:,10:12),1);
    ch4o1=mean(coilData1(:,13:15),1);
    
    ch1o2=mean(coilData2(:,4:6),1);
    ch2o2=mean(coilData2(:,7:9),1);
    ch3o2=mean(coilData2(:,10:12),1);
    ch4o2=mean(coilData2(:,13:15),1);
else
    coilData1=readcoils(directory,coilfileOrientation1,1);
    coilData2=readcoils(directory,coilfileOrientation2,1);
    
    ch1o1=mean(coilData1(:,6:8),1);
    ch2o1=mean(coilData1(:,9:11),1);
    ch3o1=mean(coilData1(:,12:14),1);
    ch4o1=mean(coilData1(:,15:17),1);
    
    ch1o2=mean(coilData2(:,6:8),1);
    ch2o2=mean(coilData2(:,9:11),1);
    ch3o2=mean(coilData2(:,12:14),1);
    ch4o2=mean(coilData2(:,15:17),1);
    
end

ZEROS_R=[mean([ch1o1; ch1o2]) mean([ch2o1;ch2o2])];
ZEROS_L=[mean([ch3o1; ch3o2]) mean([ch4o1;ch4o2])];

% if (dateStatus==0)
%     
%     figure;
%     subplot(1,3,1)
%     plot(coilData1(:,4));
%     hold on;
%     plot(coilData2(:,4));
%     plot(repmat(ZEROS_R(1),1,length(coilData2)));
%     legend('O1','O2','Mean')
%     title('Channel 1 - X Field')
%     subplot(1,3,2)
%     plot(coilData1(:,5));
%     hold on;
%     plot(coilData2(:,5));
%     plot(repmat(ZEROS_R(2),1,length(coilData2)));
%     legend('O1','O2','Mean')
%     title('Channel 1 - Y Field')
%     subplot(1,3,3)
%     plot(coilData1(:,6));
%     hold on;
%     plot(coilData2(:,6));
%     plot(repmat(ZEROS_R(3),1,length(coilData2)));
%     legend('O1','O2','Mean')
%     title('Channel 1 - Z Field')
%     pause(1)
%     close(gcf)
%     
%     
%     
%     
%     
%     figure;
%     subplot(1,3,1)
%     plot(coilData1(:,7));
%     hold on;
%     plot(coilData2(:,7));
%     plot(repmat(ZEROS_R(4),1,length(coilData2)));
%     legend('O1','O2','Mean')
%     title('Channel 2 - X Field')
%     subplot(1,3,2)
%     plot(coilData1(:,8));
%     hold on;
%     plot(coilData2(:,8));
%     plot(repmat(ZEROS_R(5),1,length(coilData2)));
%     legend('O1','O2','Mean')
%     title('Channel 2 - Y Field')
%     subplot(1,3,3)
%     plot(coilData1(:,9));
%     hold on;
%     plot(coilData2(:,9));
%     plot(repmat(ZEROS_R(6),1,length(coilData2)));
%     legend('O1','O2','Mean')
%     title('Channel 2 - Z Field')
%     pause(1)
%     close(gcf)
%     
%     
%     
%     %Channel 3 Figures
%     figure;
%     subplot(1,3,1)
%     plot(coilData1(:,10));
%     hold on;
%     plot(coilData2(:,10));
%     plot(repmat(ZEROS_L(1),1,length(coilData2)));
%     legend('O1','O2','Mean')
%     title('Channel 3 - X Field')
%     subplot(1,3,2)
%     plot(coilData1(:,11));
%     hold on;
%     plot(coilData2(:,11));
%     plot(repmat(ZEROS_L(2),1,length(coilData2)));
%     legend('O1','O2','Mean')
%     title('Channel 3 - Y Field')
%     subplot(1,3,3)
%     plot(coilData1(:,12));
%     hold on;
%     plot(coilData2(:,12));
%     plot(repmat(ZEROS_L(3),1,length(coilData2)));
%     legend('O1','O2','Mean')
%     title('Channel 3 - Z Field')
%     pause(1)
%     close(gcf)
%     
%     %Channel 4 Figures
%     figure;
%     subplot(1,3,1)
%     plot(coilData1(:,13));
%     hold on;
%     plot(coilData2(:,13));
%     plot(repmat(ZEROS_L(4),1,length(coilData2)));
%     legend('O1','O2','Mean')
%     title('Channel 4 - X Field')
%     subplot(1,3,2)
%     plot(coilData1(:,14));
%     hold on;
%     plot(coilData2(:,14));
%     plot(repmat(ZEROS_L(5),1,length(coilData2)));
%     legend('O1','O2','Mean')
%     title('Channel 4 - Y Field')
%     subplot(1,3,3)
%     plot(coilData1(:,15));
%     hold on;
%     plot(coilData2(:,15));
%     plot(repmat(ZEROS_L(6),1,length(coilData2)));
%     legend('O1','O2','Mean')
%     title('Channel 4 - Z Field')
%     pause(1)
%     close(gcf)
% else
%     
%     figure;
%     subplot(1,3,1)
%     plot(coilData1(:,6));
%     hold on;
%     plot(coilData2(:,6));
%     plot(repmat(ZEROS_R(1),1,length(coilData2)));
%     legend('O1','O2','Mean')
%     title('Channel 1 - X Field')
%     subplot(1,3,2)
%     plot(coilData1(:,7));
%     hold on;
%     plot(coilData2(:,7));
%     plot(repmat(ZEROS_R(2),1,length(coilData2)));
%     legend('O1','O2','Mean')
%     title('Channel 1 - Y Field')
%     subplot(1,3,3)
%     plot(coilData1(:,8));
%     hold on;
%     plot(coilData2(:,8));
%     plot(repmat(ZEROS_R(3),1,length(coilData2)));
%     legend('O1','O2','Mean')
%     title('Channel 1 - Z Field')
%     pause(1)
%     close(gcf)
%     
%     
%     
%     
%     figure;
%     subplot(1,3,1)
%     plot(coilData1(:,9));
%     hold on;
%     plot(coilData2(:,9));
%     plot(repmat(ZEROS_R(4),1,length(coilData2)));
%     legend('O1','O2','Mean')
%     title('Channel 2 - X Field')
%     subplot(1,3,2)
%     plot(coilData1(:,10));
%     hold on;
%     plot(coilData2(:,10));
%     plot(repmat(ZEROS_R(5),1,length(coilData2)));
%     legend('O1','O2','Mean')
%     title('Channel 2 - Y Field')
%     subplot(1,3,3)
%     plot(coilData1(:,11));
%     hold on;
%     plot(coilData2(:,11));
%     plot(repmat(ZEROS_R(6),1,length(coilData2)));
%     legend('O1','O2','Mean')
%     title('Channel 2 - Z Field')
%     pause(1)
%     close(gcf)
%     
%     
%     
%     %Channel 3 Figures
%     figure;
%     subplot(1,3,1)
%     plot(coilData1(:,12));
%     hold on;
%     plot(coilData2(:,12));
%     plot(repmat(ZEROS_L(1),1,length(coilData2)));
%     legend('O1','O2','Mean')
%     title('Channel 3 - X Field')
%     subplot(1,3,2)
%     plot(coilData1(:,13));
%     hold on;
%     plot(coilData2(:,13));
%     plot(repmat(ZEROS_L(2),1,length(coilData2)));
%     legend('O1','O2','Mean')
%     title('Channel 3 - Y Field')
%     subplot(1,3,3)
%     plot(coilData1(:,14));
%     hold on;
%     plot(coilData2(:,14));
%     plot(repmat(ZEROS_L(3),1,length(coilData2)));
%     legend('O1','O2','Mean')
%     title('Channel 3 - Z Field')
%     pause(1)
%     close(gcf)
%     
%     %Channel 4 Figures
%     figure;
%     subplot(1,3,1)
%     plot(coilData1(:,15));
%     hold on;
%     plot(coilData2(:,15));
%     plot(repmat(ZEROS_L(4),1,length(coilData2)));
%     legend('O1','O2','Mean')
%     title('Channel 4 - X Field')
%     subplot(1,3,2)
%     plot(coilData1(:,16));
%     hold on;
%     plot(coilData2(:,16));
%     plot(repmat(ZEROS_L(5),1,length(coilData2)));
%     legend('O1','O2','Mean')
%     title('Channel 4 - Y Field')
%     subplot(1,3,3)
%     plot(coilData1(:,17));
%     hold on;
%     plot(coilData2(:,17));
%     plot(repmat(ZEROS_L(6),1,length(coilData2)));
%     legend('O1','O2','Mean')
%     title('Channel 4 - Z Field')
%     pause(1)
%     close(gcf)
% end
end
