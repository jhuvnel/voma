function handles = Moog710Coil2Seg(hObject, eventdata,handles,fs)
segments = str2num(handles.segment_number.String);

handles.Segment(fs).DAQ_code = 7;
coilsWithProsthSync = readcoils([handles.PathNameofFiles,'\'], handles.listing(fs).name, 1);

prosthSync(:,1:2)=coilsWithProsthSync(:,4:5);
coils(:,1:3)=coilsWithProsthSync(:,1:3);
coils(:,4:15)=coilsWithProsthSync(:,6:17);
TS_idx=1+find([diff(prosthSync(:,1));0]);
TS_time = prosthSync(TS_idx, 1)-1 + prosthSync(TS_idx,2)/25000;
TS_interval = [diff(TS_time);0] / 1000;

[rotRhead,rotLhead,rotRReye,rotLLeye,rotRref,rotLref] = analyzeCoilData(coils, 1, [],handles.GAINSR,handles.GAINSL,handles.ZEROS_R,handles.ZEROS_L);
rotRlarpralp = rotRref;
rotLlarpralp = rotLref;
rotRxyz = rotRReye;
rotLxyz = rotLLeye;


[pks,locs] = findpeaks(diff(prosthSync(:,1)),'MinPeakHeight',50);

%%%%rot2fick of rotRref and rotLref gives position in yaw larp and ralp
boundaries = [1 locs(20)];%[locs(1) locs(20)];
boundaries(2) = boundaries(2) + 1500;
boundaries(1) = boundaries(1); %- 1500;
%                         boundaries(1) = 1;
%                         boundaries(2) = 5000;

coilsSplit = zeros(boundaries(2)-boundaries(1)+1,17,length(boundaries)/2);


coilsSplit(:,:,1) = coilsWithProsthSync(boundaries(1):boundaries(2),:);

rotRsplit(:,:,1) = rotRlarpralp(boundaries(1):boundaries(2),:);
rotLsplit(:,:,1) = rotLlarpralp(boundaries(1):boundaries(2),:);
rotRsplitxyz(:,:,1) = rotRxyz(boundaries(1):boundaries(2),:);
rotLsplitxyz(:,:,1) = rotLxyz(boundaries(1):boundaries(2),:);


angularPosL = rot2fick(rotLsplit(:,:,1));
angularPosR = rot2fick(rotRsplit(:,:,1));

pSync(:,1:2)=coilsSplit(:,4:5,1);
TS_idxS=1+find([diff(pSync(:,1));0]);
TS_timeS = pSync(TS_idxS, 1)-1 + pSync(TS_idxS,2)/25000;
TS_intervalS = [diff(TS_timeS);0] / 1000;
newFrameinFrame = fick2rot([45 0 0]);

rotrotL = rot2rot(newFrameinFrame,rotLsplit(:,:,1));
rotrotR = rot2rot(newFrameinFrame,rotRsplit(:,:,1));
rotrotLxyz = rot2rot(newFrameinFrame,rotLsplitxyz(:,:,1));
rotrotRxyz = rot2rot(newFrameinFrame,rotRsplitxyz(:,:,1));


AngVelL=rot2angvelBJM20190107(rotrotL)/pi*180 * 1000;
AngVelR=rot2angvelBJM20190107(rotrotR)/pi*180 * 1000;
AngVelLxyz=rot2angvelBJM20190107(rotrotLxyz)/pi*180 * 1000;
AngVelRxyz=rot2angvelBJM20190107(rotrotRxyz)/pi*180 * 1000;

t=1/1000:1/1000:(length(AngVelL)/1000);

handles.Segment(fs).LE_Position_X = angularPosL(:,3);
handles.Segment(fs).LE_Position_Y = angularPosL(:,2);
handles.Segment(fs).LE_Position_Z = angularPosL(:,1);

handles.Segment(fs).RE_Position_X = angularPosR(:,3);
handles.Segment(fs).RE_Position_Y = angularPosR(:,2);
handles.Segment(fs).RE_Position_Z = angularPosR(:,1);

handles.Segment(fs).LE_Velocity_X = AngVelLxyz(:,1);
handles.Segment(fs).LE_Velocity_Y = AngVelLxyz(:,2);
handles.Segment(fs).LE_Velocity_LARP = AngVelL(:,1);
handles.Segment(fs).LE_Velocity_RALP = AngVelL(:,2);
handles.Segment(fs).LE_Velocity_Z = AngVelL(:,3);

handles.Segment(fs).RE_Velocity_X = AngVelRxyz(:,1);
handles.Segment(fs).RE_Velocity_Y = AngVelRxyz(:,2);
handles.Segment(fs).RE_Velocity_LARP = AngVelR(:,1);
handles.Segment(fs).RE_Velocity_RALP = AngVelR(:,2);
handles.Segment(fs).RE_Velocity_Z = AngVelR(:,3);

handles.Segment(fs).segment_code_version = handles.mfilename;
handles.Segment(fs).raw_filename = handles.filename;
handles.Segment(fs).Fs = 1000;

handles.Segment(fs).Time_Eye = t';
Stim_Interp = zeros(boundaries(2)-boundaries(1)+1,1,length(boundaries)/2);
Time_Stim = TS_idxS./1000';
Stim = 1./TS_intervalS./10';
Stim(Stim>4)=20;
Stim(Stim<20)=0;

if length(Time_Stim) ~= length(handles.Segment(fs).Time_Eye)
    Time_Stim_Interp = handles.Segment(fs).Time_Eye;
    Stim_Interp = interp1(Time_Stim,Stim,Time_Stim_Interp);
end
Stim_Interp(Stim_Interp<20) = 0;


handles.Segment(fs).Time_Stim = Time_Stim_Interp;
handles.Segment(fs).Stim_Trig = Stim_Interp;

handles.Segment(fs).HeadMPUVel_X = zeros(1,length(Stim_Interp))';
handles.Segment(fs).HeadMPUVel_Y = zeros(1,length(Stim_Interp))';
handles.Segment(fs).HeadMPUVel_Z = Stim_Interp;

handles.Segment(fs).HeadMPUAccel_X = zeros(1,length(Stim_Interp))';
handles.Segment(fs).HeadMPUAccel_Y = zeros(1,length(Stim_Interp))';
handles.Segment(fs).HeadMPUAccel_Z = zeros(1,length(Stim_Interp))';

if isempty(segments==0) || (segments==0)
    handles.exp_condition.String = {'PulseTrains'};
    handles.exp_type.String = {'ElectricalStim'};
end
handles.Segment(fs).exp_condition = handles.exp_condition.String{1};
handles.Segment(fs).exp_type = handles.exp_type.String{1};

handles.Segment(fs).ecomb = ['stim',num2str(handles.Segment(fs).stim),'ref',num2str(handles.Segment(fs).refNum)];


handles.exp_ecomb.String = {['stim',num2str(handles.Segment(fs).stim),'ref',num2str(handles.Segment(fs).refNum)]};
handles.exp_p1d.String = {['phase1Dur',num2str(handles.Segment(fs).p1d)]};
handles.exp_p2d.String = {['phase2Dur',num2str(handles.Segment(fs).p2d)]};
handles.exp_ipg.String = {['IPG',num2str(handles.Segment(fs).ipg)]};
handles.exp_p1a.String = {['phase1Amp',num2str(handles.Segment(fs).p1amp)]};
handles.exp_p2a.String = {['phase2Amp',num2str(handles.Segment(fs).p2amp)]};
[handles] = update_seg_filename(handles.seg_filename, eventdata, handles, fs);
handles.Segment(fs).seg_filename = handles.seg_filename.String;

handles.Segment(fs).start_t = handles.Segment(fs).Time_Eye(1);
handles.Segment(fs).end_t = handles.Segment(fs).Time_Eye(end);

if any(isnan(handles.Segment(fs).LE_Position_X))
    if length(find(isnan(handles.Segment(fs).LE_Position_X)))<length(handles.Segment(fs).LE_Position_X)
    ind = find(isnan(handles.Segment(fs).LE_Position_X));
        handles.Segment(fs).LE_Position_X(ind) = mean([handles.Segment(fs).LE_Position_X([ind-1,ind+1])]);
    handles.Segment(fs).LE_Position_Y(ind) = mean([handles.Segment(fs).LE_Position_Y([ind-1,ind+1])]);
    handles.Segment(fs).LE_Position_Z(ind) = mean([handles.Segment(fs).LE_Position_Z([ind-1,ind+1])]);
    handles.Segment(fs).LE_Velocity_X(ind) = mean([handles.Segment(fs).LE_Velocity_X([ind-1,ind+1])]);
    handles.Segment(fs).LE_Velocity_Y(ind) = mean([handles.Segment(fs).LE_Velocity_Y([ind-1,ind+1])]);
    handles.Segment(fs).LE_Velocity_LARP(ind) = mean([handles.Segment(fs).LE_Velocity_LARP([ind-1,ind+1])]);
    handles.Segment(fs).LE_Velocity_RALP(ind) = mean([handles.Segment(fs).LE_Velocity_RALP([ind-1,ind+1])]);
    handles.Segment(fs).LE_Velocity_Z(ind) = mean([handles.Segment(fs).LE_Velocity_Z([ind-1,ind+1])]);
    else
    handles.Segment(fs).LE_Position_X = zeros(length(Segment.RE_Position_X),1);
    handles.Segment(fs).LE_Position_Y = zeros(length(Segment.RE_Position_X),1);
    handles.Segment(fs).LE_Position_Z = zeros(length(Segment.RE_Position_X),1);
    handles.Segment(fs).LE_Velocity_X = zeros(length(Segment.RE_Position_X),1);
    handles.Segment(fs).LE_Velocity_Y = zeros(length(Segment.RE_Position_X),1);
    handles.Segment(fs).LE_Velocity_LARP = zeros(length(Segment.RE_Position_X),1);
    handles.Segment(fs).LE_Velocity_RALP = zeros(length(Segment.RE_Position_X),1);
    handles.Segment(fs).LE_Velocity_Z = zeros(length(Segment.RE_Position_X),1);
    end
elseif any(isnan(handles.Segment(fs).RE_Position_X))
    handles.Segment(fs).RE_Position_X = zeros(length(Segment.LE_Position_X),1);
    handles.Segment(fs).RE_Position_Y = zeros(length(Segment.LE_Position_X),1);
    handles.Segment(fs).RE_Position_Z = zeros(length(Segment.LE_Position_X),1);
    handles.Segment(fs).RE_Velocity_X = zeros(length(Segment.LE_Position_X),1);
    handles.Segment(fs).RE_Velocity_Y = zeros(length(Segment.LE_Position_X),1);
    handles.Segment(fs).RE_Velocity_LARP = zeros(length(Segment.LE_Position_X),1);
    handles.Segment(fs).RE_Velocity_RALP = zeros(length(Segment.LE_Position_X),1);
    handles.Segment(fs).RE_Velocity_Z = zeros(length(Segment.LE_Position_X),1);
end
