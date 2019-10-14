function handles = LaskerSpike2Seg(hObject, eventdata,handles,fs)
segments = str2num(handles.segment_number.String);
% This will use the first data point as a reference position
            ref = 0;
            % Don't put a smapling rate param. in, we will extract it from the
            % CED file.
            Fs = [];
            if segments == 0
            handles.LaskerSystPanel.BackgroundColor = 'y';
            uiwait(handles.figure1)
            handles.LaskerSystPanel.BackgroundColor = [0.94 0.94 0.94];
            drawnow
            end
            % Mark the 'system_code'
            switch handles.Lasker_param2.Value
                case 1 % Head is upright, but we still need to correct the coil signals into proper X, Y, Z coordinates
                    system_code = 2;
                case 2
                    system_code = 3;
                case 3
                    system_code = 4;
            end
            % Indicate the DAQ code
            handles.Segment(fs).DAQ_code = 3; % Lasker System as recorded by a CED 1401 device
            
            
            [RawData] = voma__processeyemovements(handles.Segment(fs).directory,handles.filename,handles.FieldGains,handles.coilzeros,ref,system_code,handles.Segment(fs).DAQ_code,1);
            
            % Attempt to
            
            if ((handles.eye_rec.Value == 3) && (strcmp(handles.EyeCh,'Ch3Ch4'))) || ((handles.eye_rec.Value == 4) && (strcmp(handles.EyeCh,'Ch1Ch2')))
                handles.Segment(fs).RE_Position_X = RawData.LE_Pos_X;
                handles.Segment(fs).RE_Position_Y = RawData.LE_Pos_Y;
                handles.Segment(fs).RE_Position_Z = RawData.LE_Pos_Z;
                
                handles.Segment(fs).LE_Position_X = RawData.RE_Pos_X;
                handles.Segment(fs).LE_Position_Y = RawData.RE_Pos_Y;
                handles.Segment(fs).LE_Position_Z = RawData.RE_Pos_Z;
                
                handles.Segment(fs).RE_Velocity_X = RawData.LE_Vel_X;
                handles.Segment(fs).RE_Velocity_Y = RawData.LE_Vel_Y;
                handles.Segment(fs).RE_Velocity_LARP = RawData.LE_Vel_LARP;
                handles.Segment(fs).RE_Velocity_RALP = RawData.LE_Vel_RALP;
                handles.Segment(fs).RE_Velocity_Z = RawData.LE_Vel_Z;
                
                handles.Segment(fs).LE_Velocity_X = RawData.RE_Vel_X;
                handles.Segment(fs).LE_Velocity_Y = RawData.RE_Vel_Y;
                handles.Segment(fs).LE_Velocity_LARP = RawData.RE_Vel_LARP;
                handles.Segment(fs).LE_Velocity_RALP = RawData.RE_Vel_RALP;
                handles.Segment(fs).LE_Velocity_Z = RawData.RE_Vel_Z;
            else
                handles.Segment(fs).LE_Position_X = RawData.LE_Pos_X;
                handles.Segment(fs).LE_Position_Y = RawData.LE_Pos_Y;
                handles.Segment(fs).LE_Position_Z = RawData.LE_Pos_Z;
                
                handles.Segment(fs).RE_Position_X = RawData.RE_Pos_X;
                handles.Segment(fs).RE_Position_Y = RawData.RE_Pos_Y;
                handles.Segment(fs).RE_Position_Z = RawData.RE_Pos_Z;
                
                handles.Segment(fs).LE_Velocity_X = RawData.LE_Vel_X;
                handles.Segment(fs).LE_Velocity_Y = RawData.LE_Vel_Y;
                handles.Segment(fs).LE_Velocity_LARP = RawData.LE_Vel_LARP;
                handles.Segment(fs).LE_Velocity_RALP = RawData.LE_Vel_RALP;
                handles.Segment(fs).LE_Velocity_Z = RawData.LE_Vel_Z;
                
                handles.Segment(fs).RE_Velocity_X = RawData.RE_Vel_X;
                handles.Segment(fs).RE_Velocity_Y = RawData.RE_Vel_Y;
                handles.Segment(fs).RE_Velocity_LARP = RawData.RE_Vel_LARP;
                handles.Segment(fs).RE_Velocity_RALP = RawData.RE_Vel_RALP;
                handles.Segment(fs).RE_Velocity_Z = RawData.RE_Vel_Z;
            end
            handles.Segment(fs).segment_code_version = handles.mfilename;
            handles.Segment(fs).raw_filename = handles.filename;
            
            handles.Segment(fs).Fs = RawData.Fs;
            
            
            
            
            handles.Segment(fs).Time_Eye = [0:length(RawData.LE_Vel_LARP)-1]/handles.Segment(fs).Fs;
            handles.Segment(fs).Time_Stim = RawData.ElecStimTrig';
            
            if isempty(RawData.ElecStimTrig)
                
                handles.Segment(fs).Stim_Trig = [];
                handles.Segment(fs).Time_Stim = handles.Segment(fs).Time_Eye;
            else
                % We will calculate PR using a first order backwards difference
                % instantaneous rate approx. We are not using a central
                % difference, since it will smear/smooth the Pulse rate values
                PR = 1./diff(RawData.ElecStimTrig(:,1));
                % To have the same number of PR values as pulse times, we will
                % copy the first entry in the array, and append the PR array in
                % the front. The first value in the PR array is really
                % "PulseTime(2)-PulseTime(1)". The actual value plotted/saved
                % here is for graphical purposes only and the actual pulse
                % times themselves will be used for analysis.
                handles.Segment(fs).Stim_Trig = [PR(1) PR'];
                
            end
            
            % Kludge for now!
            handles.Segment(fs).HeadMPUVel_X = zeros(length(handles.Segment(fs).Time_Eye),1);
            handles.Segment(fs).HeadMPUVel_Y = zeros(length(handles.Segment(fs).Time_Eye),1);
            handles.Segment(fs).HeadMPUVel_Z = RawData.Var_x083;
            
            handles.Segment(fs).HeadMPUAccel_X = zeros(length(handles.Segment(fs).Time_Eye),1);
            handles.Segment(fs).HeadMPUAccel_Y = zeros(length(handles.Segment(fs).Time_Eye),1);
            handles.Segment(fs).HeadMPUAccel_Z = zeros(length(handles.Segment(fs).Time_Eye),1);
            
            if isempty(segments==0) || (segments==0)
                handles.exp_condition.String = {'PulseTrains'};
                handles.exp_type.String = {'ElectricalStim'};
            end
            handles.Segment(fs).exp_condition = handles.exp_condition.String{1};
            handles.Segment(fs).exp_type = handles.exp_type.String{1};

            
%             if ~strcmp(handles.prevStimCanal,handles.stim_axis.String) && (str2num(handles.segment_number.String)>1)
%                 if handles.timesExported ==0
%                     if ~isempty(handles.exp_spread_sheet_name.String) && ~strcmp([handles.subj_id.String{handles.subj_id.Value} '_ExperimentRecords.mat'],handles.exp_spread_sheet_name.String)
%                         handles.exportCond = 2;
%                         handles = export_data_Callback(handles.export_data, eventdata, handles);
%                     else
%                         handles.ss_FileName = [handles.subj_id.String{handles.subj_id.Value} '_ExperimentRecords'];
%                         set(handles.exp_spread_sheet_name,'String',[handles.ss_FileName '.mat']);
%                         handles.exportCond = 3;
%                         handles = export_data_Callback(handles.export_data, eventdata, handles);
%                     end
%                 else
%                     handles.exportCond = 2;
%                     handles = export_data_Callback(handles.export_data, eventdata, handles);
%                 end
%                 
%             end
            
            handles.Segment(fs).ecomb = ['stim',num2str(handles.Segment(fs).stim),'ref',num2str(handles.Segment(fs).refNum)];
            
            
            handles.exp_ecomb.String = {['stim',num2str(handles.Segment(fs).stim),'ref',num2str(handles.Segment(fs).refNum)]};
            handles.exp_p1d.String = {['phase1Dur',num2str(handles.Segment(fs).p1d)]};
            handles.exp_p2d.String = {['phase2Dur',num2str(handles.Segment(fs).p2d)]};
            handles.exp_ipg.String = {['IPG',num2str(handles.Segment(fs).ipg)]};
            handles.exp_p1a.String = {['phase1Amp',num2str(handles.Segment(fs).p1amp)]};
            handles.exp_p2a.String = {['phase2Amp',num2str(handles.Segment(fs).p2amp)]};
            [handles] = update_seg_filename(handles.seg_filename, eventdata, handles, fs);
            handles.Segment(fs).seg_filename = handles.seg_filename.String;
            
            t = handles.Segment(fs).Time_Eye;
            handles.Segment(fs).start_t = t(1);
            handles.Segment(fs).end_t = t(end);

            if any(isnan(handles.Segment(fs).LE_Position_X))
                handles.Segment(fs).LE_Position_X = zeros(length(handles.Segment(fs).RE_Position_X),1);
                handles.Segment(fs).LE_Position_Y = zeros(length(handles.Segment(fs).RE_Position_X),1);
                handles.Segment(fs).LE_Position_Z = zeros(length(handles.Segment(fs).RE_Position_X),1);
                handles.Segment(fs).LE_Velocity_X = zeros(length(handles.Segment(fs).RE_Position_X),1);
                handles.Segment(fs).LE_Velocity_Y = zeros(length(handles.Segment(fs).RE_Position_X),1);
                handles.Segment(fs).LE_Velocity_LARP = zeros(length(handles.Segment(fs).RE_Position_X),1);
                handles.Segment(fs).LE_Velocity_RALP = zeros(length(handles.Segment(fs).RE_Position_X),1);
                handles.Segment(fs).LE_Velocity_Z = zeros(length(handles.Segment(fs).RE_Position_X),1);
            elseif any(isnan(handles.Segment(fs).RE_Position_X))
                handles.Segment(fs).RE_Position_X = zeros(length(handles.Segment(fs).LE_Position_X),1);
                handles.Segment(fs).RE_Position_Y = zeros(length(handles.Segment(fs).LE_Position_X),1);
                handles.Segment(fs).RE_Position_Z = zeros(length(handles.Segment(fs).LE_Position_X),1);
                handles.Segment(fs).RE_Velocity_X = zeros(length(handles.Segment(fs).LE_Position_X),1);
                handles.Segment(fs).RE_Velocity_Y = zeros(length(handles.Segment(fs).LE_Position_X),1);
                handles.Segment(fs).RE_Velocity_LARP = zeros(length(handles.Segment(fs).LE_Position_X),1);
                handles.Segment(fs).RE_Velocity_RALP = zeros(length(handles.Segment(fs).LE_Position_X),1);
                handles.Segment(fs).RE_Velocity_Z = zeros(length(handles.Segment(fs).LE_Position_X),1);
            end
            handles.Segment(fs).Time_Eye = t';
            
            Time_Stim = handles.Segment(fs).Time_Stim;
            Stim = handles.Segment(fs).Stim_Trig;
                Stim(Stim>100)=200;
                Stim(Stim<200)=0;
            if length(Time_Stim) ~= length(handles.Segment(fs).Time_Eye)
                Time_Stim_Interp = handles.Segment(fs).Time_Eye;
                Stim_Interp = interp1(Time_Stim,Stim,Time_Stim_Interp);
                Stim_Interp(Stim_Interp<200) = 0;
            handles.Segment(fs).Time_Stim = Time_Stim_Interp;
            handles.Segment(fs).Stim_Trig = Stim_Interp;
                
            end

            
            handles.Segment(fs).HeadMPUVel_X = zeros(1,length(Stim_Interp))';
            handles.Segment(fs).HeadMPUVel_Y = zeros(1,length(Stim_Interp))';
            handles.Segment(fs).HeadMPUVel_Z = handles.Segment(fs).Stim_Trig;
            
            handles.Segment(fs).HeadMPUAccel_X = zeros(1,length(Stim_Interp))';
            handles.Segment(fs).HeadMPUAccel_Y = zeros(1,length(Stim_Interp))';
            handles.Segment(fs).HeadMPUAccel_Z = zeros(1,length(Stim_Interp))';