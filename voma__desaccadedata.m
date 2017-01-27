%
% Name: desaccadedata_v3.m
%
% function [desaccdata]=desaccadedata_v3(Data,time,Fs,derivVal,tSacc,tSaccMax,tSaccMin,splineVal,E,Event)
%
% Function: This routine was adapted to be a versatile tool for removing
% quick phases (QPs) from eye velocity recordings. The function first performs
% spline smoothing on the data trace. Then, a point-by-point derivative of
% this data is taken and a threshold is set to mark saccadic points. Two
% additional parameters are used to combine individual saccades. First, if
% the QP is longer than a set time, the algorithm ignores that saccade
% since it is likely not a saccade. Second, if thwo adjacent saccades are
% within a certain time interval, the two saccades are combined. The data
% during the QP is deleted and a cubic spline is applied between the edges.
%
% Input Parameters:
%       - Data
%           This is the data trace you want to perform QP removal on.
%       - times
%           The time vector of the data trace
%       - Fs
%           Sampling rate for the input data
%       - derivVal
%           Value of the point-by-pont derivative threshold for QP detection
%       - tSacc
%           If two QPs are within this time (in ms), they are combined into
%           one QP used for removal.
%       - tSaccDur
%           Maximum duration of a QP. If a QP is longer than this, ignore
%           it.
%       - E
%           Event Based Smoothing (2) or Smoothing of Whole Data Trace (1)
%           or No smoothing (0, else)
%       - splineVal
%           Parameter used for spline smoothing. Ranges between 0-1, where
%           a value close to 1 is close to the raw trace, and a value close
%           to zero approaches a straight line
%       - Events
%           n x 2 matrix, where n is the number of 'events' and (n,1) is the
%           indices that you
%
%   NOTE: This code was adapted from code previously made from Kristin
%   Hageman
%
%   - 2015-08-04
%       Added output of the point-by-point derivative
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [desaccdata]=voma__desaccadedata(Data,time,Fs,derivVal,tSacc,tSaccMax,tSaccMin,splineVal,E,Event,QP_range)

%% Set parameters
% If no events are given, ignore them
if nargin<10
    Event=0;
end

% Convert input time parameters from ms to s
tSacc=tSacc/1000;
tSaccMax=tSaccMax/1000;

% Check if the 'raw' input data has any NaN values, which will cause the
% 'smooth' function to zero-out the data.
Data(isnan(Data)) = 0;

%% Smooth data using the chosen method in the parameter 'E'
% Smooth data for the chosen method

if isrow(Data)
    Data = Data';
end

if E==2 % 'Event based' smoothing
    % Smooth Data 5s before and after each event
    for i=1:size(Event,1)
        DataSmth=Data;
        DataSmth(Event(i,1)-5*Fs:Event(i,2)+5*Fs)=smooth(1:length(Data(Event(i,1)-5*Fs:Event(i,2)+5*Fs)),Data(Event(i,1)-5*Fs:Event(i,2)+5*Fs),splineVal,1:length(Data(Event(i,1)-5*Fs:Event(i,2)+5*Fs)));
    end
elseif E==1 % Smooth the entire trace
    DataSmth=smooth([1:length(Data)]',Data,splineVal,[1:length(Data)]');
elseif E==0 % Do nothing, do QP removal on the raw trace
    DataSmth=Data;
end

% Check for NaNs in the data, which can make errors in the derivative trace
% for i=1:length(DataSmth)
%     if isnan(DataSmth(i))
%         DataSmth(i)=0;
%     end
% end

%% QP detection

% Calc point-by-point derivative of the Data trace
    accel=diff(DataSmth);

if ~exist('QP_range','var')
    

    
    % Pre-allocate space for a 'mask' to mark QPs
    findSac=zeros(1,length(DataSmth)-1);
    
    % If the derivative is greater than "derivVal", then mark that point as a 'saccade'
    for i=1:(length(DataSmth)-1)
        if abs(accel(i))>derivVal
            findSac(i)=1;
        else
            findSac(i)=0;
        end
    end
    
    mask = abs(accel)>derivVal;
    
    % figure; hold on
    % plot(time(2:end),accel)
    % plot(time(2:end),findSac,'r')
    QP_range=[];
    %find the index value for start and stop of each saccade
    if nnz(findSac)>0 %Check if there are any marked QPs
        count=1;
        %
        %     % This section of code determines the 'start' and 'stop' value for each
        %     % marked QP. This is done by taking in the 'findSac' mask (which marks
        %     % a thresholded QP with a '1' and non-QPs as a zero. It then iterates
        %     % over all points, taking a subtraction of 'findSac' array value for
        %     % the present index and the previous. This subtraction can take values
        %     % of '0' (if the present point and the previous are either BOTH '0' or
        %     % BOTH '1'. This means that either both points are part of the same QP
        %     % or both points are not QPs. In this case, do nothing.), '+1' (which
        %     % means the QP mask transitioned from 0
        %     % to 1, meaning a quick phase has started. We will mark the present index as a
        %     % 'QP starting point'), or '-1' (and thus the mask
        %     % changes from '1' to '0', and a QP has ended then mark the previes
        %     % index as a 'QP ending point'.)
        for i=1:(length(findSac))
            %Check if the first index is marked as a QP. If it is, then mark it
            %as a starting point. If it isn't, then keep looping.
            if i==1
                if findSac(i)==1
                    tempValStart(count)=1;
                end
                
                %if the subtraction gives '+1' - set start point to index value
            elseif (findSac(i)-findSac(i-1))==1
                tempValStart(count)=i;
                
                %if decrease - set stop point to previous index value
            elseif (findSac(i)-findSac(i-1))==-1
                tempValStop(count)=(i-1);
                count=count+1;
            end
            
            %if still in saccade when file ends - store stop val as last index value
            if i==length(findSac)
                if findSac(i)==1
                    tempValStop(count)=i;
                end
            end
        end
        
        start_ind=find((diff(mask)==1)==1)+1;
        % The '(diff(mask)==1)' argument creates a logical array with a '+1' if
        % the 'mask' variable transitioned from a '0' to a '1', which
        % corresponds to a 'start' of a QP. I then find the indices of that
        % logical array to retrieve the indices of the original data trace that
        % we have marked as a QP. I add a '1' to the values of each index,
        % since we are using the 'diff' of the mask. Meaning, if we extract
        % index number '1'  after taking the 'diff', it would mean that there
        % was a 'low' to 'high' transition at sample point 2.
        
        stop_ind=find((diff(mask)==(-1))==1);
        % Here, I do a similar action, but I look for the transitions from
        % 'high' to 'low', meaning that a saccade has ended.
        
        % If the starting
        if mask(1)==1
            start_ind = [1 ; start_ind];
            
        end
        
        if length(stop_ind)<length(start_ind)
            % this likely means that the LAST QP goes to the end of the file. 
            stop_ind = [stop_ind ; length(mask)];
        end
        % This code loops over the QP start/stop time and further checks them
        % against parameters on the temproal properties of QPs (i.e., a minimum
        % duration (tSaccdDur) and a time-between-QPs (tSacc)
        %     count=1;
        %     if length(tempValStart)>1 % Check if there is more than one QP
        %       for i=2:length(tempValStart)
        %         %if time between saccades is less than tSacc, most likely all one
        %         %saccade
        %         if tempValStart(i)-tempValStop(count)<(tSacc*Fs) %
        %           tempValStop(count)=tempValStop(i);
        %           tempValStop(i)=NaN;
        %           tempValStart(i)=NaN;
        %
        %         else
        %           count=i;
        %         end
        % %         % if total detected saccade is less than tSaccDur, most likely not a saccade
        % %         % if tempValStop(i-1)-tempValStart(i-1)<(tSaccDur*Fs)
        % %         if tempValStop(i-1)-tempValStart(i-1)>(tSaccMax*Fs)
        % %           tempValStop(i-1)=NaN;
        % %           tempValStart(i-1)=NaN;
        % %         end
        %       end
        %
        %       for i=2:length(tempValStart)
        %           % if total detected saccade is less than tSaccDur, most likely not a saccade
        %           % if tempValStop(i-1)-tempValStart(i-1)<(tSaccDur*Fs)
        %           if tempValStop(i-1)-tempValStart(i-1)>(tSaccMax*Fs)
        %               tempValStop(i-1)=NaN;
        %               tempValStart(i-1)=NaN;
        %           end
        %       end
        %
        %     end
        
        count=1;
        if length(start_ind)>1 % Check if there is more than one QP
            for i=2:length(start_ind)
                %if time between saccades is less than tSacc, most likely all one
                %saccade
                if start_ind(i)-stop_ind(count)<(tSacc*Fs) %
                    try stop_ind(count)=stop_ind(i);
                    catch
                        keyboard
                    end
                    stop_ind(i)=NaN;
                    start_ind(i)=NaN;
                    
                else
                    count=i;
                end
                %         % if total detected saccade is less than tSaccDur, most likely not a saccade
                %         % if stop_ind(i-1)-start_ind(i-1)<(tSaccDur*Fs)
                %         if stop_ind(i-1)-start_ind(i-1)>(tSaccMax*Fs)
                %           stop_ind(i-1)=NaN;
                %           start_ind(i-1)=NaN;
                %         end
            end
            test = [];
            for i=1:length(start_ind)
                % if total detected saccade is less than tSaccDur, most likely not a saccade
                % if stop_ind(i-1)-start_ind(i-1)<(tSaccDur*Fs)
                
                if (stop_ind(i)-start_ind(i))>(tSaccMax*Fs) || (stop_ind(i)-start_ind(i)) >(tSaccMin*Fs)
                    test=[test i];
                    stop_ind(i)=NaN;
                    start_ind(i)=NaN;
                end
            end
            
        end
        
        %     new_ind = [true(1) (start_ind(2:end) - stop_ind(1:end-1))>(tSacc*Fs)];
        %     start_ind = start_ind(new_ind);
        %     stop_ind = stop_ind(new_ind);
        %
        %     new_ind2 = (stop_ind - start_ind)<(tSaccMax*Fs);
        %     start_ind = start_ind(new_ind2);
        %     stop_ind = stop_ind(new_ind2);
        
        %Create the
        %     count=1;
        %     for i=1:length(tempValStart)
        %       if tempValStart(i)>=0
        %         QP_range(count,1)=tempValStart(i);
        %         QP_range(count,2)=tempValStop(i);
        %         count=count+1;
        %       end
        %     end
        count=1;
        for i=1:length(start_ind)
            if start_ind(i)>0
                
                QP_range(count,1)=start_ind(i);
                QP_range(count,2)=stop_ind(i);
                count=count+1;
            end
        end
    end
    
    % Check if any QPs are present
    if isempty(QP_range)
        desaccdata.results=DataSmth;
        desaccdata.smooth=DataSmth;
        desaccdata.time=time;
        desaccdata.deriv=accel;
        desaccdata.QP_range = QP_range;
        
    else
        %get rid of NaNs
        QP_range(isnan(QP_range(:,1)),:) = [];
        
        ind2remove = [];
        %reset QP_range values to be 5 ms before and after detected sacade index
        for i=1:nnz(QP_range(:,1))
            if QP_range(i,1)> (0.006*Fs)
                QP_range(i,1)=QP_range(i,1)-round(0.005*Fs);
            end
            
            if QP_range(i,1) <= 0
                ind2remove = i;
            end
            
            if QP_range(i,2)<length(DataSmth)-(0.006*Fs)
                QP_range(i,2)=QP_range(i,2) + round(0.005*Fs);
            end
        end
        
        QP_range = QP_range(~ismember(1:size(QP_range,1), ind2remove), :);

        
        [splinefitData] = spline_over_QPs (DataSmth,QP_range,Fs);
        
        desaccdata.results=splinefitData;
        desaccdata.smooth=DataSmth;
        desaccdata.time=time;
        desaccdata.deriv=accel;
        desaccdata.QP_range = QP_range;
        
    end
    
else
    
    if isempty(QP_range)
        splinefitData=DataSmth;
        
    else
        
        [splinefitData] = spline_over_QPs (DataSmth,QP_range,Fs);
    end
    
    desaccdata.results=splinefitData;
    desaccdata.smooth=DataSmth;
    desaccdata.time=time;
    desaccdata.deriv=accel;
    desaccdata.QP_range = QP_range;
    
    
end


end

function [splinefitData] = spline_over_QPs (DataSmth,QP_range,Fs)



%% Desaccade

%create mask for desaccading
desaccMask=ones(length(DataSmth),1);




%QP_range(a,b) where a is the saccade start index, b is the saccade stop index
for j=1:nnz(QP_range(:,1))
    desaccMask(QP_range(j,1):QP_range(j,2))=0;
end


% maskedData=zeros(length(DataSmth),1);

% %plot the masked Data - showing flat lines where saccade was found
% % for i=1:3
maskedData=desaccMask.*DataSmth;
%   figure
%   hold on
%   plot(maskedData,'g')
% % end

splinefitData=DataSmth;

%use spline function to smooth over saccades
% for i=1:3
for j=1:nnz(QP_range(:,1))
    k1=QP_range(j,1);
    k2=QP_range(j,2);
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



end

