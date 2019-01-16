function [rotRhead,rotLhead,rotRReye,rotLLeye,rotrefR,rotrefL] = analyzeCoilData(coils, REF, handles, GAINSR, GAINSL, ZEROS_R, ZEROS_L)
%{
This function analyzes the coil data to convert from raw data on 4 coils, to rotation vectors of the two eyes.
NOTE: this function currently hard-codes the offset ZEROS values for analysis

INPUT:
  coils - coil data in typical format, with 4:6=right anterior, 7:9=right posterior, 10:12=left anterior, 13:15=left posterior
  REF - point for reference
  handles - contains the gain information if calling this function from the Data_GUI, else leave as []
  GAINSR - if not using with the Data_GUI, send gains for Right eye (R eye coils connected to Ch1 and Ch2
     so gains should be: [Ch1X Ch1Y Ch1Z Ch2X Ch2Y Ch2Z]
  GAINSL - if not using with the Data_GUI, send gains for Left eye (L eye coils connected to Ch3 and Ch4
     so gains should be: [Ch3X Ch3Y Ch3Z Ch4X Ch4Y Ch4Z]
  ZEROS_R = if not using with the Data_GUI, send zeroes for Right eye
  ZEROS_L = if not using with the Data_GUI, send zeroes for Left eye


OUTPUT: All these are output from gimbal proc....so notes below are copied from that function
  rotRhead -->this is what Kristin uses for her data analysis - eye in head
  rotLhead -->this is what Kristin uses for her data analysis - eye in head
  rotRReye - R eye socket coordinates
  rotLLeye - L eye socket coordinates
  rotrefR 
  rotrefL 





%}



if (~isempty(handles))
    GAINSR = [handles.ch0 handles.ch1];
    GAINSL = [handles.ch2 handles.ch3];
    
    plotAngles=true;
else
    plotAngles=false;
end

ZEROS=[0 0 0 0 0 0];

%ZEROS_R=[2e7 4.8e7 5.66e7 1.05e7 6.78e7 3.55e7]; %for Ch122 on 7/8
%ZEROS_L=[1.2e7 5.65e7 5.72e7 -2.85e7 -6.35e7 -1.15e8]; %for Ch122 on 7/8

%ZEROS_R=[-3.5e6 6.25e7 -2.78e7 -1.55e6 8.44e7 -3.5e6]; %for Ch120 on 7/1
%ZEROS_L=[1e6 8.96e7 6.5e6 -7.99e7 -6.54e7 -3e8]; %for Ch120 on 7/1

%ZEROS_R=[-8e6 5.76e7 -4.32e7 -1.25e7 8.18e7 -3.25e7]; %for Ch120 on 7/15
%ZEROS_L=[-9.5e6 8.72e7 6.4e6 -8.89e7 -4.85e7 -3.33e8]; %for Ch120 on 7/15

%ZEROS_R=[-7.5e6 9.78e7 -7.26e7 -2.2e7 1.24e8 -4.9e7]; %for Ch120 on 6/21, 6/24
%ZEROS_L=[-2.85e6 3.46e7 2.75e6 -3.57e7 -2.11e7 -1.33e8]; %for Ch120 on 6/21, 6/24

%ZEROS_R=[7.58e7 -2.2e7 -1.15e8 2.85e7 1.65e7 -4.49e7]; %for Ch104
%ZEROS_L=[5.59e7 -2.5e6 -1.27e8 -1.02e8 4.49e7 2.08e8]; %for Ch104

%ZEROS_R=[7.66e7 -5.5e6 -3.63e8 6.89e7 2.5e7 -1.21e8]; %for Ch106
%ZEROS_L=[4.23e7 7.5e6 -1.07e8 0 0 0]; %for Ch106

%ZEROS_R=[3.5e6 1.02e8 2.75e6 -4e6 6.32e7 -1.3e7]; %for Ch122 on 7/26 calc from f5 and f9
%ZEROS_L=[-4e6 6.17e7 2.49e7 -5.06e7 -7.69e7 -2.29e8]; %for Ch122 on 7/26 calc from f5 and f9

%ZEROS_R=[1.5e6 1.32e8 -9.25e6 -6.5e6 7.01e7 -1.3e7]; %for Ch122 of 7/28 calc from f3 f4
%ZEROS_L=[-2e6 7.08e7 1.47e7 -5.74e7 -1.06e8 -2.22e8]; %for Ch122 of 7/28 calc from f3 f4

%ZEROS_R = ZEROS;
%ZEROS_L = ZEROS;

%ZEROS_R = [-4.5e6 1.41e8 -1.29e7 -1.5e6 7.58e7 -1.65e7]; %for Ch122 on 8/8 
%ZEROS_L = [-5e5 7.46e7 1.55e7 -5.75e7 -1.01e8 -2.49e8]; %for Ch122 on 8/8

%ZEROS_R = [-9.5e6 6.56e7 -5.05e7 -2.12e7 8.63e7 -3.8e7]; %for Ch120 on 7/21
%ZEROS_L = [-1.15e7 9.11e7 1.9e6 -9.89e7 -5.03e7 -3.4e8]; %for Ch120 on 7/21

%ZEROS_R = [-1.15e7 7.2e7 -6.79e7 -2.04e7 1.04e8 -6.8e7]; %for Ch120 on 8/8
%ZEROS_L = [-1.1e7 1.07e8 -1.37e7 -1.01e8 -8.95e7 -3.95e8]; %for Ch120 on 8/8

%ZEROS_R = [0.042e8 1.116e6 -0.8474e8 -0.207e7 -3.9e7 1.741e8]; %for MoMo on 8/19/2016
%ZEROS_L = [0.4585e7 0.9885e7 -1.9345e8 0.014e8 -0.815e7 2.1115e8]; %for MoMo on 8/19/2016

%ZEROS_R = [0.1228e7 0.8534e7 1.39e7 -1.07e7 1.50e7 1.76e7]; %for Yaw with gimbal data
%ZEROS_R = [0.285e7 1.290e7 1.02e7 1.868e7 1.751e7 1.97e7]; %for Roll with gimbal data
%ZEROS_R = [0.24e7 1.567e7 1.819e7 0.066e7 1.53e7 1.9e7]; %for Pitch with gimbal data

%ZEROS_R = [5e5 1.34e8 7.8e6 -1.98e8 6.7e7 -8.5e6];  %For Ch122 on 9/12/16
%ZEROS_L = [-3e6 6.28e7 3.19e7 -6.2e7 -9.19e7 -2.90e8]; %For Ch122 on 9/12/16

%ZEROS_R = [3.0529e7 4.6513e7 -75811358 11535636 2219261 161836105]; %For MoMo on 09/13/2016 - gummy bear as target
%ZEROS_L = [8319066 5.2090e7 -1.4760e8 1.6869e7 -9225475 1.2406e8]; %For MoMo on 09/13/2016 - gummy bear as target

%ZEROS_R = [1.47208e+07 1.08283e+08 5.9310e+07 3.60306e+06 1.286296e+08 7.86491e+07]; %For Ch125 on 9/14
%ZEROS_L= [3.3743e+07 6.0974070e+07 7.9782e+07 -2.76472e+07 -9.081776e+07 -1.00398e+08]; %For Ch125 on 9/14

%ZEROS_R = [2.331e+07 1.201+08 6.807e+07 1.744e+07 1.457e+08 7.0617e+07]; %For Ch125 on 9/19/16
%ZEROS_L = [2.591e+07 6.697e+07 7.119e+07 -2.153e+07 -8.213e+07 -1.052e+08]; %For Ch125 on 9/19/16

%ZEROS_R =[2.052e+07 1.173e+08 6.490e+07 1.659e+07 1.380e+08 6.4408e+07]; %for Ch125 on 9/21/2016
%ZEROS_L = [2.071e+07 6.965e+07 7.800e+07 -2.247e+07 -7.934e+07 -1.040e+08]; %For Ch125 on 9/21/2106

%ZEROS_R = [2.4e7 7.9e6 -1.127e8 1.091e7 -2.3215e7 1.4465e8]; %For MoMo on 9/20/16 using goldfish as target
%ZEROS_L = [-6.432e6 1.256e7 -1.8085e8 1.985e7 -3.48e6 2.0695e8]; %For MoMo on 9/20/16 using goldfish as target

%ZEROS_R = [5.088e7 5.245e7 -7.665e7 2.862e7 -4.264e6 1.884e8]; %For MoMo on 9/22/16
%ZEROS_L = [-2.76e7 1.709e7 -1.092e8 2.831e7 4.09e7 1.75e8]; % For MoMo on 9/22/16 had trouble identifying proper place to take offsets

%ZEROS_R=[-2.056e+07 1.851e+07 1.736e+07 -1.085e+06 -7.146e+06 1.777e+07]; %For stepper motor in Yaw orientation
%ZEROS_R=[-2.056e+07 1.851e+07 0 -1.085e+06 -7.146e+06 0]; %For stepper motor in Yaw orientation
%ZEROS_L=[0 0 0 0 0 0]; %dont need zeros for stepper motor

%ZEROS_R=[1.10639e7 4.2959e6 -1.086217e8 2.30567e7 -3.45766e7 1.954312e8]; %MoMo on 9/27/16
%ZEROS_L=[-7.66973e5 7.2551e6 -1.437744e8 2.73345e7 -1.55397e7 2.120259e8]; %MoMo on 9/27/16

%ZEROS_R=[1.983e6 1.4705e7 -1.0885e8 1.0479e7 -2.4102e7 1.9092e8]; %MoMo on 9/29/16
%ZEROS_L=[-2.258e6 1.1205e7 -1.6761e8 1.759e6 9.173e6 1.2095e8]; %MoMo on 9/29/16

%ZEROS_R=[8.825e6 1.2568e7 -8.637e7 1.4689e7 -2.9756e7 1.8576e8]; %MoMo on 9/28/16
%ZEROS_L=[-3.117e6 4.914e6 -1.1951e8 1.0018e7 4.52e5 1.8312e8]; %MoMo on 9/28/16

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Chinch System Quiescent %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ZEROS_R=[2.2591e6 6.5771e6 2.1077e7 2.3083e6 1.1040e7 2.4752e7];
% ZEROS_L=[6.5106e5 7.0258e6 -6.657e6 02.1504e6 -9.6906e6 -2.0766e7];
% GAINSR=[0.1264 -0.2080 -0.2561 0.137 -0.2197 -0.2888];
% GAINSL=[-0.1014 0.1786 0.2381 -0.1166 0.2097 0.2336];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Monk System Quiescent %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ZEROS_R=[-1.1267e7 4.2079e6 -2.6734e7 8.9279e6 -3.4055e6 3.0275e7];
% ZEROS_L=[-1.5275e7 4.5374e6 -2.9700e7 1.2951e7 -4.6803e6 2.3306e7];
% GAINSR=[0.0934 0.0535 0.0953 -0.0718 -0.0410 -0.0835];
% GAINSL=[-0.0977 -0.0552 -0.1139 -0.0805 -0.0442 -0.0936];

%gimbalproc uses the zero and gain values of the coils to calculate the rotation vector of the position
%When we call for R eye data, we ignore the results for L eye...and vice
%versa. We use the rotrefR and rotrefL variables for continued analysis to
%velocity
[rotrefR, rotRReye, rotRLeye, rotR, dvectR, tvectR, dlen, tlen, rotRhead, dummy]=gimbalproc(coils(:,4:9), ZEROS_R, GAINSR, REF);
[rotrefL, rotLReye, rotLLeye, rotL, dvectL, tvectL, dlen, tlen, dummy, rotLhead]=gimbalproc(coils(:,10:15), ZEROS_L, GAINSL ,REF);

if (plotAngles==true)
    angle(1,1:length(dvectR)) = acosd(dot(dvectR,tvectR,2));
    angle(2,1:length(dvectL)) = acosd(dot(dvectL,tvectL,2));
    
    axes(handles.anglePlot);
    cla;
    plot(angle(1,:),'b')
    hold on;
    plot(angle(2,:),'g')
    legend('R', 'L', 'Location', 'northeastoutside')
    set(gca,'fontsize',6);
    meanR = mean(angle(1,:));
    meanL = mean(angle(2,:));
    text(length(angle)/2,meanR,num2str(meanR));
    text(length(angle)/2,meanL,num2str(meanL));
end

