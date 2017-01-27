function [Data] = voma__processeyemovements(filepath,filename,FieldGains,coilzeros,ref,data_rot,DAQ_code,Data_In)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Version Control
%       v1: Basic system_code
%       v2: I am now sending the raw coil data out of routine with the
%           processed angular velocities.
%       v3: Added 'system_code' to process dual coil data from two eyes. The system_code
%           will assume the LEFT eye dual coil data is located in Ch1 and Ch2,
%           while the RIGHT eye dual coil data is in Ch3 and Ch4.
%       v4: Added 'DAQ_code' input flag and support for CED/Spike2 .smr file extraction 
%       v5: Added code for processing Labyrinth Devices VOG data
%       v6: Added an option to provide a data set as an input argument.
%       v7: In addition to sending the raw-extracted data out, I will also
%           send out the processed position data. This means (for example)
%           if I am processing coil data, I will output: the raw coil
%           signals, the computed rotation vectors from the coil data, and
%           the computed angular velocity from the rotation vectors.
%           Renamed 'system_code' to 'data_rot', since the code is used to
%           indicate what coordinate system transformation needs to be
%           applied for the specific data acquisition system.
%
%   data_rot:
%       1: Apply no coordinate system transformations to raw data
%       2: Apply a -pi/2 YAW reorientation of the raw data
%       3: Apply a -pi/4 YAW reorientation of the raw data
%       4: Apply a -3*pi/4 YAW reorientation of the raw data
%
%   DAQ_code:
%       1: Lasker Coil System data acquired using ONLY the 'VORDAQ'
%          software
%       2: Lasker COil System data acquired by BOTH the VORDAQ software 
%          (for eye coil signals and ACUTROL variables) and the CED 1401 
%          DAQ (for MPU data and Pulse arrival times acquired  with Event 
%          Channels). 
%       3: Lasker Coil System data acquired using ONLY a CED and Spike 2
%          software
%       4: McGill Coil System [2D]
%       5: Labyrinth Devices VOG Goggle data files
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


switch data_rot
    
    case 1
        % Do not apply any coordinate system changes to the raw eye
        % movement data
        
        radH = 0;
        radV = 0;
        radT = 0;
        
    case 2
        % In Ross710, the coil frame cardinal axes are defined as +X =
        % Left +Y = Occipital, +Z = Up convention (which we will refer to as
        % 'FrameA')
        % We would like to use the standard coordinate system of +X = Nasal,
        % +Y = Left, +Z = Up (which we will refer to as 'FrameB')
        %
        % Thus, FrameA (the coil frame coordinate system in Ross 710) is achieved
        % by a +pi/2 Z-axis rotation of FrameB. We can thus express Ross710 data in
        % FrameB (the standard X-Y-Z convention) by applying a -pi/2 Z-axis rotation
        %
        % To make this correction, we will convert the Eye-in-FrameA rotation
        % vectors we get from the raw coil system voltages into Eye-in-FrameB
        % rotation vectors by applying a rotation vector describing
        % FrameB-in-FrameA (described below in Fick angles)
        radH = -pi/2;
        radV = 0;
        radT = 0;
    case 3
        
        radH = -pi/4;
        radV = 0;
        radT = 0;
    case 4
        
        radH = -3*pi/4;
        radV = 0;
        radT = 0;
        
end

dbdbFBinFAfick = [(radH*180/pi) (radV*180/pi) (radT*180/pi)]; % Fick angle in [H V T] convention


%% Extract and process the raw coil data

% If the user supplied this function with the raw angular velocity eye
% movement data, we do not need to load any raw files and can just prep the
% data for the angular velocity computation.
%
% To do check this, we will see if the user included a 'Data_In' input variable AND that it is NOT
% empty
if exist('Data_In','var') && ~isempty(Data_In)
    
    switch DAQ_code
        
        case 1
            
        case 2
            
        case 3
            
        case 4
            
        case 5 % LD VOG Goggles - MVI Trial
            Fs = Data_In.Fs;
            
            if (isrow(Data_In.Data_LE_Pos_X))
                Data_In.Data_LE_Pos_X=Data_In.Data_LE_Pos_X';
            end
            if (isrow(Data_In.Data_LE_Pos_Y))
                Data_In.Data_LE_Pos_Y=Data_In.Data_LE_Pos_Y';
            end
            if (isrow(Data_In.Data_LE_Pos_Z))
                Data_In.Data_LE_Pos_Z=Data_In.Data_LE_Pos_Z';
            end
            if (isrow(Data_In.Data_RE_Pos_X))
                Data_In.Data_RE_Pos_X=Data_In.Data_RE_Pos_X';
            end
            if (isrow(Data_In.Data_RE_Pos_Y))
                Data_In.Data_RE_Pos_Y=Data_In.Data_RE_Pos_Y';
            end
            if (isrow(Data_In.Data_RE_Pos_Z))
                Data_In.Data_RE_Pos_Z=Data_In.Data_RE_Pos_Z';
            end
            
            rawData_L = [ Data_In.Data_LE_Pos_X  Data_In.Data_LE_Pos_Y  Data_In.Data_LE_Pos_Z ];
            rawData_R = [ Data_In.Data_RE_Pos_X  Data_In.Data_RE_Pos_Y  Data_In.Data_RE_Pos_Z ];
            
    end
    
else % i.e., the user did NOT provide any angular position data into the routine, and we must load the data from the raw files.
    
    
    
    
    switch DAQ_code % Each DAQ system requires a different method of extracting raw data
        
        
        
        case 1 %vordaq / Lasker Coil system
            
            cd(filepath)
            
            f=fopen(filename);
            % Read out data as 16-bit integers.
            dRAW=fread(f,inf,'int16');
            fclose(f);
            
            % We need to skip the first 5000 integers (10,000 bytes), which is a
            % header. Then we read out the data as 16 channels (6 REye, 6 LEye, Chair
            % Position, Chair Velocity, Sled Position, and Sled Velocity)
            d=reshape(dRAW(5001:end), 16, [])';
            
            % Note that the vordaq VI saves the individual components in following
            % order: [Y Z X];
            % Swapping channels around to proper X, Y, Z order
            d = d(:, [3 1 2 6 4 5 9 7 8 12 10 11 13 14 15 16]);
            
            % Sampling Rate Extraction
            % The sampling rate is extracted as two 16bit integers. We will typecast
            % each into 8-bit integers, combine them, and typecast them back into a
            % 32-bit integer
            a = typecast(int16(dRAW(136)),'uint8');
            b = typecast(int16(dRAW(137)),'uint8');
            
            Fs = double(typecast(uint8([a(end) b(1) 0 0]),'int32'));
            
            % Assuming the 16 bit, +/-10V NI DAQ is being used
            ADCconv = (10 - (-10))/(2^16);
            AcutrolAngPosCalib = 18;
            AcutrolAngVelCalib = 20;
            
            % Extract stimulus signals
            Var_x081 = d(:,13)*ADCconv*AcutrolAngPosCalib;
            Var_x083 = d(:,14)*ADCconv*AcutrolAngVelCalib;

            
            % Extracting the LE coil data
            rawData_L = d(:,1:6);
            zeros_L = coilzeros(1:6);
            gains_L = FieldGains(1:6);
            
            % Extracting the RE coil data
            rawData_R = d(:,7:12);
            zeros_R = coilzeros(7:12);
            gains_R = FieldGains(7:12);
            
        case 2 %Lasker Coil System: 'vordaq' + CED DAQ, needs time alignment
            % I NEED TO ADD MY OLD CODE HERE
        case 3 %Lasker Coil system using CED to process
            
            chan_ElecStimTrig = 24; % NOTE: I realize these channel numbers should be setup in a configuration file...
            
            cd(filepath)
            
            % Load the data into a temporary variable
            [d]=ImportSMR_PJBv2(filename,filepath);
            % If we setup our Sampling Config file in SPike2 to have
            % non-cnosecutive channels, the output data structure of the above
            % function will produce empty entries in the array. We will remove
            % those now.
            
            % Extract all of the channel numbers
            temp = {d.chan};
            d(cellfun('isempty',temp))=[];
            
            % Check if the file contains electrical stimulation trigger pulses
            if isempty(d([d.chan]==chan_ElecStimTrig))
                ElecStimTrig = [];
            else
                ElecStimTrig = double(d([d(:).chan]==chan_ElecStimTrig).imp.tim)*d([d(:).chan]==chan_ElecStimTrig).hdr.tim.Scale*d([d(:).chan]==chan_ElecStimTrig).hdr.tim.Units;
                
            end
            
            len = min([d(3).hdr.adc.Npoints d(4).hdr.adc.Npoints d(5).hdr.adc.Npoints ...
                d(6).hdr.adc.Npoints d(7).hdr.adc.Npoints d(8).hdr.adc.Npoints ...
                d(9).hdr.adc.Npoints d(10).hdr.adc.Npoints d(11).hdr.adc.Npoints ...
                d(12).hdr.adc.Npoints d(13).hdr.adc.Npoints d(14).hdr.adc.Npoints]);
            
            Fs = 1/(d(1).hdr.adc.SampleInterval(1)*10^-6);
            
            rawData_L(:,1) = double(d(3).imp.adc(1:len))*d(3).hdr.adc.Scale + d(3).hdr.adc.DC;
            rawData_L(:,2) = double(d(4).imp.adc(1:len))*d(4).hdr.adc.Scale + d(4).hdr.adc.DC;
            rawData_L(:,3) = double(d(5).imp.adc(1:len))*d(5).hdr.adc.Scale + d(5).hdr.adc.DC;
            rawData_L(:,4) = double(d(6).imp.adc(1:len))*d(6).hdr.adc.Scale + d(6).hdr.adc.DC;
            rawData_L(:,5) = double(d(7).imp.adc(1:len))*d(7).hdr.adc.Scale + d(7).hdr.adc.DC;
            rawData_L(:,6) = double(d(8).imp.adc(1:len))*d(8).hdr.adc.Scale + d(8).hdr.adc.DC;
            
            rawData_L = rawData_L(:,[3 1 2 6 4 5]);
            
            
            zeros_L = coilzeros(1:6);
            gains_L = FieldGains(1:6);
            
            
            rawData_R(:,1) = double(d(9).imp.adc(1:len))*d(9).hdr.adc.Scale + d(9).hdr.adc.DC;
            rawData_R(:,2) = double(d(10).imp.adc(1:len))*d(10).hdr.adc.Scale + d(10).hdr.adc.DC;
            rawData_R(:,3) = double(d(11).imp.adc(1:len))*d(11).hdr.adc.Scale + d(11).hdr.adc.DC;
            rawData_R(:,4) = double(d(12).imp.adc(1:len))*d(12).hdr.adc.Scale + d(12).hdr.adc.DC;
            rawData_R(:,5) = double(d(13).imp.adc(1:len))*d(13).hdr.adc.Scale + d(13).hdr.adc.DC;
            rawData_R(:,6) = double(d(14).imp.adc(1:len))*d(14).hdr.adc.Scale + d(14).hdr.adc.DC;
            
            rawData_R = rawData_R(:,[3 1 2 6 4 5]);
            
            
            zeros_R = coilzeros(7:12);
            gains_R = FieldGains(7:12);
            
            if d(1).hdr.adc.SampleInterval(1) == d(3).hdr.adc.SampleInterval(1)
                % If the angular position and angular velocity channels are
                % sampled at the same sample rate as the coil signals, make
                % sure they have the same number of samples
                Var_x081 = double(d(1).imp.adc(1:len))*d(1).hdr.adc.Scale + d(1).hdr.adc.DC;
            else
                Var_x081 = double(d(1).imp.adc(1:len))*d(1).hdr.adc.Scale + d(1).hdr.adc.DC;
            end
            
            
            if d(2).hdr.adc.SampleInterval(2) == d(3).hdr.adc.SampleInterval(1)
                % If the angular position and angular velocity channels are
                % sampled at the same sample rate as the coil signals, make
                % sure they have the same number of samples
                Var_x083 = double(d(2).imp.adc(1:len))*d(2).hdr.adc.Scale + d(2).hdr.adc.DC;
            else
                Var_x083 = double(d(2).imp.adc(1:len))*d(2).hdr.adc.Scale + d(2).hdr.adc.DC;
            end
            
     
            
        case 4 % McGill 2D Coil System
            % I NEED TO ADD THIS
        case 5 % Labyrinth Devices VOG
            
            
            cd(filepath)
            
            
            Fs = 100;
            
            
            % These are the column indices of the relevant parameters saved to file
            % NOTE! MVI001R019 Pre-Op data was acquired without the GPIO line,
            % and thus all of the follwing indices are decremented by 1.
            HLeftIndex = 40;
            VLeftIndex = 41;
            TLeftIndex = 42;
            HRightIndex = 43;
            VRightIndex = 44;
            TRightIndex = 45;
            
            
            % Load Data
            data = dlmread(filename,' ',1,0);
            
            
            % Load raw eye position data in Fick coordinates [degrees]
            Horizontal_LE_Position = data(:,HLeftIndex);
            Vertical_LE_Position = data(:,VLeftIndex);
            Torsion_LE_Position = data(:,TLeftIndex);
            Horizontal_RE_Position = data(:,HRightIndex);
            Vertical_RE_Position = data(:,VRightIndex);
            Torsion_RE_Position = data(:,TRightIndex);
            
            
            rawData_L = [Torsion_LE_Position Vertical_LE_Position Horizontal_LE_Position];
            rawData_R = [Torsion_RE_Position Vertical_RE_Position Horizontal_RE_Position];
    end
    
    
    
end

%% Compute Angular Velocity
for j=1:2
    
    switch DAQ_code
        
        case {1,2,3} % Raw Coil Signals to Rotation Vectors
            
            switch j
                
                case 1 % Left Eye
                    rawData = rawData_L;
                    coilzeros = zeros_L;
                    gains = gains_L;
                case 2 % Right Eye
                    rawData = rawData_R;
                    coilzeros = zeros_R([3 1 2 6 4 5]);
                    gains = gains_R;
            end
            
            % Converting raw data to rotation vectors
            % Note that the output of the raw2rot routine is a time series of
            % Eye-in-FrameA rotation vectors
            rot = raw2rot(rawData - repmat(coilzeros,length(rawData),1), gains, ref);
            
            % Here we are converting the Eye-in-FrameA rotation vectors into the
            % 'correct' Eye-in-FrameB by doing [FrameB-in-FrameA]^T[Eye-in-FrameA] = [Eye-in-FrameB]
            FBinFA = fick2rot(FBinFAfick);
            rot_corr = rot2rot(-FBinFA,rot); % Rotate the time-series rotation vector data by the correction factor to put the data in proper XYZ notation
            
            % Next, we want to rotate our position data by -pi/4 to put the data in
            % the [+LARP +RALP +Z] coordinate system (i.e., FrameC)
            FCinFBfick = [-45 0 0];
            FCinFB = fick2rot(FCinFBfick);
            rot_lr = rot2rot(-FCinFB,rot_corr);
            
            switch j
                
                case 1 % Left Eye
                    rot_L = rot_corr;
                    
                case 2 % Right Eye
                    rot_R = rot_corr;
            end
            
            % The data_rot below calculates the angular velocity using Haslwanter, 1995 eq.
            % 29 using the 2nd order central difference approximation of dr/dt
            % X,Y,Z
            [dcolb,drb] = gradient(rot_corr);
            rb = rot_corr(1:(end),:) + drb./2;
            denomb = (1 + dot(rb,rb,2) - dot(drb,drb,2));
            angvel_dps_b = (2*(drb + cross(rb,drb,2)) ./ denomb(:,[1 1 1]))*(180/pi)*Fs;
            % LARP,RALP,Z
            [dcolc,drc] = gradient(rot_lr);
            rc = rot_lr(1:(end),:) + drc./2;
            denomc = (1 + dot(rc,rc,2) - dot(drc,drc,2));
            angvel_dps_c = (2*(drc + cross(rc,drc,2)) ./ denomc(:,[1 1 1]))*(180/pi)*Fs;
            
        case 4 % McGill Coil System
            
        case 5 % Lab. Dev. VOG Goggles
            
            switch j
                
                case 1 % Left Eye
                    rawData = rawData_L;
                    
                case 2 % Right Eye
                    rawData = rawData_R;
            end
            
            psi = rawData(:,1);
            phi = rawData(:,2);
            theta = rawData(:,3);
            
            % Computing angular velocity from Fick angular position angles
            angvel_dps_b = [(gradient(psi)*Fs.*cosd(theta).*cosd(phi)) - (gradient(phi)*Fs.*sind(theta)) ...
                (gradient(psi)*Fs.*sind(theta).*cosd(phi)) + (gradient(phi)*Fs.*cosd(theta)) ...
                (gradient(theta)*Fs) - (gradient(psi)*Fs.*sind(phi))];
            
            % We want to rotate our data from an [X,Y,Z] coordinate system,
            % into a [LARP,RALP,LHRH] coordinate system, where Z = LHRH. To
            % accomplish this, we will perform a PASSIVE (i.e., 'alias' or
            % 'coordinate system') rotation of -45 degrees. In order to realize
            % this rotation, I will generate a -45deg rotation matrix and
            % RIGHT multiple our data by the TRANSPOSE of this rotation
            % matrix. Note that rotation matrices are orthonormal, and
            % their inverses are equivalent to their transpose. -PJB
            angvel_dps_c = [rotZ3deg(-45)'*angvel_dps_b']';
            

            
    end
    
    switch j
        case 1
            % Store Data
            Data.LE_Vel_X = angvel_dps_b(:,1);
            Data.LE_Vel_Y = angvel_dps_b(:,2);
            Data.LE_Vel_Z = angvel_dps_b(:,3);
            Data.LE_Vel_LARP = angvel_dps_c(:,1);
            Data.LE_Vel_RALP = angvel_dps_c(:,2);
            
        case 2
            % Store Data
            Data.RE_Vel_X = angvel_dps_b(:,1);
            Data.RE_Vel_Y = angvel_dps_b(:,2);
            Data.RE_Vel_Z = angvel_dps_b(:,3);
            Data.RE_Vel_LARP = angvel_dps_c(:,1);
            Data.RE_Vel_RALP = angvel_dps_c(:,2);
            
    end
    
    
    
end

if exist('Var_x081','var')
    Data.Var_x081 = Var_x081;
end
if exist('Var_x083','var')
    Data.Var_x083 = Var_x083;
end

if exist('ElecStimTrig','var')
    Data.ElecStimTrig = ElecStimTrig;
end

Data.Fs = Fs;


% Saving both POSITION and RAW data traces
switch DAQ_code
    case {1,2,3}
        Data.LE_Pos_X = rot_L(:,1);
        Data.LE_Pos_Y = rot_L(:,2);
        Data.LE_Pos_Z = rot_L(:,3);
        
        Data.RE_Pos_X = rot_R(:,1);
        Data.RE_Pos_Y = rot_R(:,2);
        Data.RE_Pos_Z = rot_R(:,3);
        % Raw coil data
        Data.RawData_L = rawData_L;
        Data.RawData_R = rawData_R;
    case {4}
    case {5}
        
        Data.LE_Pos_X = rawData_L(:,1);
        Data.LE_Pos_Y = rawData_L(:,2);
        Data.LE_Pos_Z = rawData_L(:,3);
        
        Data.RE_Pos_X = rawData_R(:,1);
        Data.RE_Pos_Y = rawData_R(:,2);
        Data.RE_Pos_Z = rawData_R(:,3);
end