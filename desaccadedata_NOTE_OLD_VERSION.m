% E = Event Based Smoothing (2) or Smoothing of Whole Data Trace (1)
% or No smoothing (0, else)
%
% Events= n x 2 matrix, where n is the number of 'events' and (n,1) is the
% indices of 
%
% Spline Val = Value used in the "smooth.m" spline routine 
%
% Fs
%
% derivVal
%
% tSacc = Time btwn saccades
%
% tSaccDur = Minimum duration of a saccade
%
% Test for lack of input arguments
%
% Splining Data
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [desaccdata]=desaccadedata(Data,time,Fs,derivVal,tSacc,tSaccDur,E,splineVal,Event)


if nargin<8
    Event=0;
    splineVal=0.0001;
end

% Check if a spline value is specified
if nargin<9
    Event=0;
end

% Conversion from ms to s
tSacc=tSacc/1000;
tSaccDur=tSaccDur/1000;

% Smooth data in each of three options
if E==2
    % Smooth Data 5s before and after each event
    for i=1:size(Event,1)
        DataSmth=Data;
        DataSmth(Event(i,1)-5*Fs:Event(i,2)+5*Fs)=smooth(1:length(Data(Event(i,1)-5*Fs:Event(i,2)+5*Fs)),Data(Event(i,1)-5*Fs:Event(i,2)+5*Fs),splineVal,1:length(Data(Event(i,1)-5*Fs:Event(i,2)+5*Fs)));
    end
elseif E==1
    DataSmth=smooth(1:length(Data),Data,splineVal,1:length(Data));
else
    DataSmth=Data;
end

% Check for NaNs in the data, which can make errors in the derivative trace
for i=1:length(DataSmth)
    if isnan(DataSmth(i))
        DataSmth(i)=0;
    end
end


% Check derivative for quick changes
clear accel findSac tempValStart tempValStop
% Calc derivative of the Data trace
accel=diff(DataSmth);

if max(accel)<derivVal
    desaccdata.results=Data;
    desaccdata.smooth=Data;
    desaccdata.time=time;
    return
end
% Pre-allocate for original mask
findSac=zeros(1,length(DataSmth)-1);

% If the derivative is greater than "derivVal", then mark that point as a 'saccade'
for i=1:(length(DataSmth)-1)
  if abs(accel(i))>derivVal 
    findSac(i)=1;
  else
    findSac(i)=0;
  end
end

% figure; hold on
% plot(time(2:end),accel)
% plot(time(2:end),findSac,'r')

  %find the index value for start and stop of each saccade
if nnz(findSac)>0 %Check if there are any saccades
    count=1;
    for i=1:(length(findSac))
      %if first value is a saccade - set start point to index value 1
      if i==1
        if findSac(i)==1
          tempValStart(count)=1;
        end

        %if increase - set start point to index value
      elseif (findSac(i)-findSac(i-1))==1
        tempValStart(count)=i;

        %if decrease - set stop point to index value
      elseif (findSac(i)-findSac(i-1))==-1
        tempValStop(count)=i;
        count=count+1;
      end

      %if still in saccade when file ends - store stop val as last index value
      if i==length(findSac)
        if findSac(i)==1
          tempValStop(count)=i;
        end
      end
    end

    %connect saccade index markers if the gap between sacaddes is less than
    %tSacc
    count=1;
    if length(tempValStart)>1
      for i=2:length(tempValStart)
        %if time between saccades is less than tSacc, most likely all one
        %saccade
        if tempValStart(i)-tempValStop(count)<(tSacc*Fs)
          tempValStop(count)=tempValStop(i);
          tempValStop(i)=NaN;
          tempValStart(i)=NaN;

        else
          count=i;
        end
        %if total detected saccade is less than tSaccDur, most likely not a saccade
        if tempValStop(i-1)-tempValStart(i-1)<(tSaccDur*Fs)
          tempValStop(i-1)=NaN;
          tempValStart(i-1)=NaN;
        end
      end
    end

    %if starting point is in middle of saccade, set value to be
    count=1;
    for i=1:length(tempValStart)
      if tempValStart(i)>=0
        range(count,1)=tempValStart(i);
        range(count,2)=tempValStop(i);
        count=count+1;
      end
    end

    %get rid of NaNs
    range(isnan(range(:,1)),:) = [];

    %reset range values to be 20 ms before and after detected sacade index
    for i=1:nnz(range(:,1))
      if range(i,1)>21
        range(i,1)=range(i,1)-20;
      end

      if range(i,2)<length(DataSmth)-21
        range(i,2)=range(i,2)+20;
      end
    end
end
  
%% Desaccade

%create mask for desaccading
desaccMask=ones(length(DataSmth),1);

%range(a,b) where a is the saccade start index, b is the saccade stop index
for j=1:nnz(range(:,1))
  desaccMask(range(j,1):range(j,2))=0;
end


% maskedData=zeros(length(DataSmth),1);

% %plot the masked Data - showing flat lines where saccade was found
% % for i=1:3
  maskedData=desaccMask.*DataSmth';
%   figure
%   hold on
%   plot(maskedData,'g')
% % end

splinefitData=DataSmth;

%use spline function to smooth over saccades
% for i=1:3
  for j=1:nnz(range(:,1))
    k1=range(j,1);
    k2=range(j,2);
    %splinefitData(k1,i+1)=median(smoothdata((k1-15):(k1+5),i+1));
    %splinefitData(k2,i+1)=median(smoothdata((k2-5):(k2+15),i+1));
    %slope1=(median(smoothdata((k1-5):(k1+5),i+1))-median(smoothdata((k1-15):(k1-5),i+1)))/(10/samprate);
    %slope2=(median(smoothdata((k2+5):(k2+15),i+1))-median(smoothdata((k2-5):(k2+5),i+1)))/(10/samprate);

    slope1=maskedData(k1)/(10/Fs);
    slope2=maskedData(k2)/(10/Fs);

    splinefitData(k1:k2)=spline([k1 k2],[slope1 splinefitData(k1) splinefitData(k2) slope2], k1:k2);
  end
% end
% 
% %plot the splined data in black
% figure
% hold on
% plot(Data.t(1:end),splinefitData,'k')
% axis([175,205,-75,100])

desaccdata.results=splinefitData;
desaccdata.smooth=DataSmth;
desaccdata.time=time;

end