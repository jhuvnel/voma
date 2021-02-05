function [Data] = voma__processeyemovements(filepath,filename,FieldGains,coilzeros,ref,data_rot,DAQ_code,OutputFormat,Data_In)
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
%       v8: Meg is adding digital coil processing info
%       v9: Fixed bug that incorrectly applied the ordering of the
%           Frame-to-Head and Coil-to-Eye coordinate system changes.
%           Added option to choose the output format.
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
%       6: Digital Coil Moog System
%
%   OutputFormat:
%       1: Fick coord.
%       2: Rotation Vectors
%       3: Quaternions
%
%
%
%s
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Here, we are setting up the rotation needed to convert eye movement data
% presented in a COIL FRAME coordinate system, into a HEAD coordinate
% system. In particular for oculomotor data collected using a search coil
% system, in general the data computed from the raw coil signals provides
% data representing the rotations of the COILS on the eye in a COIL FRAME
% coordinate system.
% In square bracket rotation vector notation, we can say the system
% provides:
% [Coil_in_Frame].
% Typically, we care more about how the EYES are moving in a HEAD
% coordinate frame (i.e., [Eye_in_Head]. We will need to apply some coordinate system changes
% (also termed 'passive' rotations) to get there.

switch data_rot
    
    case 1
        % In cases where the coil system uses a HEAD FIXED coil frame, we often
        % assume that the HEAD coordinate system is identical to the FRAME
        % coordinate system. (Thus, we apply NO additional coordinate system
        % changes to the [Coil_in_Frame] data.
        
        radH = 0;
        radV = 0;
        radT = 0;
        
    case 2
        % Some cases in VNEL where this is NOT true:
        
        % In Ross710, the coil frame cardinal axes are defined as +X =
        % Left +Y = Occipital, +Z = Up convention (which we will refer to as
        % 'Frame')
        % We would like to use the standard coordinate system of +X = Nasal,
        % +Y = Left, +Z = Up (which we will refer to as 'Head')
        %
        % Thus, we can thus express Ross710 data in
        % 'Head' (the standard X-Y-Z convention) coordiantes by applying a -pi/2 Z-axis rotation
        %
        % To make this correction, we will convert the Coil-in-Frame rotation
        % vectors we get from the raw coil system voltages into Coil-in-Head
        % rotation vectors by applying a rotation describing
        % Head-in-Frame (described below in Fick angles)
        radH = -pi/2;
        radV = 0;
        radT = 0;
    case 3
        % When providing LARP or RALP mechanical rotations for a monkey in
        % the Ross710 Monkey Chamber, we must re-orient the monkey to be on
        % its SIDE (or its BACK, depending on how you seat the monkey in
        % the chair) and then physically apply a +pi/4 yaw rotation in HEAD
        % coordinates (so rotate the monkey's headcap within the 'ring'
        % headcap holder). For this system, our new [Head_in_Frame]
        % conversion is a -pi/4 yaw re-orientation to align the coordinate
        % systems.
        % NOTE: The correct head reorientation needed CHANGES if the monkey
        % is seated with its LEFT EAR to the chamber door, or if the BACK
        % OF THE HEAD is to the chamber door.
        % This case is used for:
        % Left Ear to Door: RALP rotation
        % Back of Head to Door: LARP rotation
        radH = -pi/4;
        radV = 0;
        radT = 0;
    case 4
        % When providing LARP or RALP mechanical rotations for a monkey in
        % the Ross710 Monkey Chamber, we must re-orient the monkey to be on
        % its SIDE (or its BACK, depending on how you seat the monkey in
        % the chair) and then physically apply a -pi/4 yaw rotation in HEAD
        % coordinates (so rotate the monkey's headcap within the 'ring'
        % headcap holder). For this system, our new [Head_in_Frame]
        % conversion is a -3pi/4 yaw re-orientation to align the coordinate
        % systems.
        % NOTE: The correct head reorientation needed CHANGES if the monkey
        % is seated with its LEFT EAR to the chamber door, or if the BACK
        % OF THE HEAD is to the chamber door.
        % This case is used for:
        % Left Ear to Door: LARP rotation
        % Back of Head to Door: RALP rotation
        radH = -3*pi/4;
        radV = 0;
        radT = 0;
        
end

HinFfick = [(radH*180/pi) (radV*180/pi) (radT*180/pi)]; % Fick angle in [H V T] convention


%% Extract and process the raw coil data

% If the user supplied this function with the raw angular position eye
% movement data, we do not need to load any raw files and can just prep the
% data for the angular velocity computation.
%
% To do check this, we will see if the user included a 'Data_In' input variable AND that it is NOT
% empty
if exist('Data_In','var') && ~isempty(Data_In)
    
    Data_In_flag = true;
    
    switch DAQ_code
        
        case 1
            
        case 2
            
        case 3 % Lasker System, CED Only
            
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
            
            zeros_L = [0 0 0 0 0 0 0 0 0 0 0 0];
            gains_L = [0 0 0 0 0 0 0 0 0 0 0 0];
            
            zeros_R = [0 0 0 0 0 0 0 0 0 0 0 0];
            gains_R = [0 0 0 0 0 0 0 0 0 0 0 0];
            
        case 4
            
        case {5,9} % LD VOG Goggles - MVI Trial
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
            
        case 7 % Digital Coil System - Moog
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
            
            % NOTE: These are FICK ANGLES NOT ROTATION VECTORS, SO SAVE AS
            % HVT (Horiz, Vert, Torsion)
            
            rawData_L = [ Data_In.Data_LE_Pos_Z  Data_In.Data_LE_Pos_Y  Data_In.Data_LE_Pos_X ];
            rawData_R = [ Data_In.Data_RE_Pos_Z  Data_In.Data_RE_Pos_Y  Data_In.Data_RE_Pos_X ];
            
            zeros_L = [0 0 0 0 0 0 0 0 0 0 0 0];
            gains_L = [0 0 0 0 0 0 0 0 0 0 0 0];
            
            zeros_R = [0 0 0 0 0 0 0 0 0 0 0 0];
            gains_R = [0 0 0 0 0 0 0 0 0 0 0 0];
            % Here need to calculate velocity now.
            %             rotR=fick2rot(rawData_R);
            %             rotL=fick2rot(rawData_L);
            
            %             velR = rot2angvel(rotR)*180*1000/pi;
            %             velL = rot2angvel(rotL)*180*1000/pi;
            %
            %             newFrameinFrame = fick2rot([45 0 0]);
            %             rotrotR = rot2rot(newFrameinFrame,rotR);
            %             LRZR = rot2angvel(rotrotR)/pi*180*1000;
            %
            %             rotrotL = rot2rot(newFrameinFrame,rotL);
            %             LRZL = rot2angvel(rotrotL)/pi*180*1000;
        case 8 %PupilLabs
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
    
    Data_In_flag = false;
    
    
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
            Var_x085 = d(:,15)*ADCconv*AcutrolAngPosCalib;
            Var_x087 = d(:,16)*ADCconv*AcutrolAngVelCalib;
            
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
            
            chan_ElecStimTrig = 25; % NOTE: I realize these channel numbers should be setup in a configuration file...
            
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
            
        case 6 %Digital coil system
            Fs = 1000;
            
            f2=fopen(char(strcat(filepath,'\',filename)), 'rb');
            
            if f2 == -1
                coils = [];
            else
                coils=fread(f2,[15,inf],'int32')';
                
                fclose(f2);
            end
            
            % Extracting the LE coil data
            %rawData_L = d(:,1:6);
            zeros_L = coilzeros(1:6);
            gains_L = FieldGains(1:6);
            
            % Extracting the RE coil data
            %rawData_R = d(:,7:12);
            zeros_R = coilzeros(7:12);
            gains_R = FieldGains(7:12);
            
            mpuFilename = filename(1:length(filename)-5);
            mpuFilename = strcat(mpuFilename,'_MPUdata.txt');
            f2=fopen(char(strcat(filepath,'\',mpuFilename)));
            if f2 == -1
                mpu = [];
            else
                mpu = fscanf(f2,'%i',[8,inf]);
                mpu = mpu';
                fclose(f2);
            end
            
            
            if isempty(mpu) || isempty(coils)
                rawData_R = [];
            else
                [rawData_R, rawData_L, rotR, rotL, velR, velL, LRZR, LRZL,mpuAligned] = voma__analyzeMoogCoils(mpu, coils, ref, FieldGains,coilzeros);
            end
            if isempty(rawData_R)
                mpuFilename
            else
                Data.LE_Pos_X = rawData_L(:,3);
                Data.LE_Pos_Y = rawData_L(:,2);
                Data.LE_Pos_Z = rawData_L(:,1);
                
                Data.RE_Pos_X = rawData_R(:,3);
                Data.RE_Pos_Y = rawData_R(:,2);
                Data.RE_Pos_Z = rawData_R(:,1);
                
                %                 Data.LE_Vel_X = velL(:,1);
                %                 Data.LE_Vel_Y = velL(:,2);
                %                 Data.LE_Vel_Z = velL(:,3);
                %                 Data.LE_Vel_LARP = LRZL(:,1);
                %                 Data.LE_Vel_RALP = LRZL(:,2);
                %
                %                 Data.RE_Vel_X = velR(:,1);
                %                 Data.RE_Vel_Y = velR(:,2);
                %                 Data.RE_Vel_Z = velR(:,3);
                %                 Data.RE_Vel_LARP = LRZR(:,1);
                %                 Data.RE_Vel_RALP = LRZR(:,2);
                Data.MPU = mpuAligned;
            end
            
            case 9 % Labyrinth Devices VOG
            
            
            cd(filepath)
            

                HLeftIndex = 47;
                VLeftIndex = 48;
                TLeftIndex = 49;
                HRightIndex = 50;
                VRightIndex = 51;
                TRightIndex = 52;

            Fs = 120;
            
            
            
            % Load Data
            data = dlmread(filename,' ',1,0);
            
            
            % Load raw eye position data in Fick coordinates [degrees]
            Horizontal_LE_Position = data(:,HLeftIndex);
            Vertical_LE_Position = data(:,VLeftIndex);
            Torsion_LE_Position = data(:,TLeftIndex);
            Horizontal_RE_Position = data(:,HRightIndex);
            Vertical_RE_Position = data(:,VRightIndex);
            Torsion_RE_Position = data(:,TRightIndex);
            
            Horizontal_LE_Position(isnan(Horizontal_LE_Position)) = 0;
        Vertical_LE_Position(isnan(Vertical_LE_Position)) = 0;
        Torsion_LE_Position(isnan(Torsion_LE_Position)) = 0;
        Horizontal_RE_Position(isnan(Horizontal_RE_Position)) = 0;
        Vertical_RE_Position(isnan(Vertical_RE_Position)) = 0;
        Torsion_RE_Position(isnan(Torsion_RE_Position)) = 0;
            
            rawData_L = [Torsion_LE_Position Vertical_LE_Position Horizontal_LE_Position];
            rawData_R = [Torsion_RE_Position Vertical_RE_Position Horizontal_RE_Position];
            
    end
    
    
    
    
end

%% Compute Angular Velocity
for j=1:2
    
    switch DAQ_code
        
        case {1,2,3,6} % Raw Coil Signals to Rotation Vectors
            
            switch j
                
                case 1 % Left Eye
                    rawData = rawData_L;
                    coilzeros = zeros_L;
                    gains = gains_L;
                case 2 % Right Eye
                    rawData = rawData_R;
                    coilzeros = zeros_R;
                    gains = gains_R;
            end
            
            if Data_In_flag
                % If the user is recalculating angular velocity for coil
                % data, we will reload the ROTATION VECTORS and not the raw
                % coil signals, so we can skip the 'raw2rot' section.
                
                rot_corr = rawData;
            elseif DAQ_code == 6
                rot = fick2rot(rawData);
            
            else
                
                % Converting raw data to rotation vectors
                % Note that the output of the raw2rot routine is a time series of
                % Eye-in-Frame rotation vectors
                options = 0;
                % Here we are converting the Eye-in-Frame rotation vectors into the
                % 'correct' Eye-in-Head by doing [Head-in-Frame]^T[Eye-in-Frame] = [Eye-in-Head]
                % From the coil system, we can compute a time series of
                % rotation vectors describing the rotation of the COIL in
                % the system FRAME [Coil_in_Frame]. To convert this into
                % [Coil_in_Head] (necessary to later compute
                % [Eye_in_Head]), we need to know the rotation vector
                % necessary to convert the two cooordinate systems.
                HinF = fick2rot(HinFfick);
                rot_corr = raw2rot(rawData - repmat(coilzeros,length(rawData),1), gains, ref,options,HinF);
            end
            
            Fick_Data = rot2fick(rot_corr);
            %             rot_corr = rot2rot(-FBinFA,rot); % Rotate the time-series rotation vector data by the correction factor to put the data in proper XYZ notation
            
            % Next, we want to rotate our position data by -pi/4 to put the data in
            % the [+LARP +RALP +Z] coordinate system
            % Thinking about this in the [Frame] nomenclature used above,
            % we now have:
            % [Eye_in_Head]
            % We want:
            % [Eye_in_LarpRalpLhrh]
            % We can describe the rotation necessary to describe the LRZ
            % Coord. system in Head coordinates via a -pi/4 yaw axis
            % rotation, or:
            % [LRZ_in_Head] = [0 0 -0.4142] (as a rotation vector)
            % We can then compute [Eye_in_LRZ] via:
            % [Eye_in_LRZ] = [LRZ_in_Head]^T[Eye_in_Head]
            LRZinHfick = [-45 0 0];
            LRZinH = fick2rot(LRZinHfick);
            rot_lr = rot2rot(-LRZinH,rot_corr);
            
            switch j
                
                case 1 % Left Eye
                    rot_L = rot_corr;
                    Fick_Data_L = Fick_Data;
                case 2 % Right Eye
                    rot_R = rot_corr;
                    Fick_Data_R = Fick_Data;
            end
            
            % The code below calculates the angular velocity using Haslwanter, 1995 eq.
            % 29 using the 2nd order central difference approximation of dr/dt
            % X,Y,Z
            drb = [diff(rot_corr);0 0 0];
            rb = rot_corr(1:(end),:) + drb./2;
            denomb = (1 + dot(rb,rb,2) - dot(drb,drb,2));
            angvel_dps_b = (2*(drb + cross(rb,drb,2)) ./ denomb(:,[1 1 1]))*(180/pi)*Fs;
            % LARP,RALP,Z
            drc = [diff(rot_lr);0 0 0];
            rc = rot_lr(1:(end),:) + drc./2;
            denomc = (1 + dot(rc,rc,2) - dot(drc,drc,2));
            angvel_dps_c = (2*(drc + cross(rc,drc,2)) ./ denomc(:,[1 1 1]))*(180/pi)*Fs;
            
        case 4 % McGill Coil System
            
        case {5,9} % Lab. Dev. VOG Goggles
            
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
        case 7 % Ross 710 Moog Coils
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
            
            % NOTE: These are FICK ANGLES NOT ROTATION VECTORS, SO SAVE AS
            % HVT (Horiz, Vert, Torsion)
            %%% fick2rot looks for Z,Y,X and spits out X,Y,Z
            rawData_L = [ Data_In.Data_LE_Pos_Z  Data_In.Data_LE_Pos_Y  Data_In.Data_LE_Pos_X ];
            rawData_R = [ Data_In.Data_RE_Pos_Z  Data_In.Data_RE_Pos_Y  Data_In.Data_RE_Pos_X ];
            
            switch j
                case 1 % Left Eye
                    rawData = rawData_L;
                case 2 % Right Eye
                    rawData = rawData_R;
            end
                        rot=fick2rot(rawData); % Spits out X,Y,Z
                        newFrameinFrame = fick2rot([45 0 0]);
                        rotrot = rot2rot(newFrameinFrame,rot);
                        rot_corr = rot;
                        rot_lr = rotrot;      
            
            % The code below calculates the angular velocity using Haslwanter, 1995 eq.
            % 29 using the 2nd order central difference approximation of dr/dt
            % X,Y,Z
            angvel_dps_b = rot2angvelBJM20190107(rot_corr)/pi*180 * 1000;
 % LARP,RALP,Z

            angvel_dps_c = rot2angvelBJM20190107(rot_lr)/pi*180 * 1000;

% 
%             
%             % NOTE: These are FICK ANGLES NOT ROTATION VECTORS, SO SAVE AS
%             % HVT (Horiz, Vert, Torsion)
%             rawData_L = [ Data_In.Data_LE_Pos_Z  Data_In.Data_LE_Pos_Y  Data_In.Data_LE_Pos_X ];
%             rawData_R = [ Data_In.Data_RE_Pos_Z  Data_In.Data_RE_Pos_Y  Data_In.Data_RE_Pos_X ];
%             
        case 8 
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
            
            % NOTE: These are FICK ANGLES NOT ROTATION VECTORS, SO SAVE AS
            % HVT (Horiz, Vert, Torsion)
            %%% fick2rot looks for Z,Y,X and spits out X,Y,Z
            rawData_L = [ Data_In.Data_LE_Pos_X  Data_In.Data_LE_Pos_Y  Data_In.Data_LE_Pos_Z ];
            rawData_R = [ Data_In.Data_RE_Pos_X  Data_In.Data_RE_Pos_Y  Data_In.Data_RE_Pos_Z ];
            
            switch j 
                case 1 % Left Eye
                    rawData = rawData_L;
                case 2 % Right Eye
                    rawData = rawData_R;
            end
                            angvel_dps_b = [[rawData(:,1)]...
                                            [diff(rawData(:,2)).*1100;false] ...
                                            [diff(rawData(:,3)).*1100;false]];
            
            angvel_dps_c = [rawData(:,1) rawData(:,1)];
            
            
    end
    
    %switch DAQ_code
    %     %{    case 6
    %             Data.LE_Vel_X = velL(:,1);
    %             Data.LE_Vel_Y = velL(:,2);
    %             Data.LE_Vel_Z = velL(:,3);
    %             Data.LE_Vel_LARP = LRZL(:,1);
    %             Data.LE_Vel_RALP = LRZL(:,2);
    %
    %             Data.RE_Vel_X = velR(:,1);
    %             Data.RE_Vel_Y = velR(:,2);
    %             Data.RE_Vel_Z = velR(:,3);
    %             Data.RE_Vel_LARP = LRZR(:,1);
    %             Data.RE_Vel_RALP = LRZR(:,2);
    %otherwise
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
    % end
    
    
    
end

if exist('Var_x081','var')
    Data.Var_x081 = Var_x081;
end
if exist('Var_x083','var')
    Data.Var_x083 = Var_x083;
end
if exist('Var_x085','var')
    Data.Var_x085 = Var_x085;
end
if exist('Var_x087','var')
    Data.Var_x087 = Var_x087;
end
if exist('ElecStimTrig','var')
    Data.ElecStimTrig = ElecStimTrig;
end

Data.Fs = Fs;


% Saving both POSITION and RAW data traces
switch DAQ_code
    case {1,2,3}
        switch OutputFormat
            
            case 1
                Data.LE_Pos_X = Fick_Data_L(:,3);
                Data.LE_Pos_Y = Fick_Data_L(:,2);
                Data.LE_Pos_Z = Fick_Data_L(:,1);
                
                Data.RE_Pos_X = Fick_Data_R(:,3);
                Data.RE_Pos_Y = Fick_Data_R(:,2);
                Data.RE_Pos_Z = Fick_Data_R(:,1);
            otherwise
                
                Data.LE_Pos_X = rot_L(:,1);
                Data.LE_Pos_Y = rot_L(:,2);
                Data.LE_Pos_Z = rot_L(:,3);
                
                Data.RE_Pos_X = rot_R(:,1);
                Data.RE_Pos_Y = rot_R(:,2);
                Data.RE_Pos_Z = rot_R(:,3);
                % Raw coil data
                Data.RawData_L = rawData_L;
                Data.RawData_R = rawData_R;
        end
    case {4}
    case {5,9}
        
        Data.LE_Pos_X = rawData_L(:,1);
        Data.LE_Pos_Y = rawData_L(:,2);
        Data.LE_Pos_Z = rawData_L(:,3);
        
        Data.RE_Pos_X = rawData_R(:,1);
        Data.RE_Pos_Y = rawData_R(:,2);
        Data.RE_Pos_Z = rawData_R(:,3);
    case 7
        Data.LE_Pos_X = rawData_L(:,3);
        Data.LE_Pos_Y = rawData_L(:,2);
        Data.LE_Pos_Z = rawData_L(:,1);
        
        Data.RE_Pos_X = rawData_R(:,3);
        Data.RE_Pos_Y = rawData_R(:,2);
        Data.RE_Pos_Z = rawData_R(:,1);
    case 8 
        Data.LE_Pos_X = rawData_L(:,1);
        Data.LE_Pos_Y = rawData_L(:,2);
        Data.LE_Pos_Z = rawData_L(:,3);
        
        Data.RE_Pos_X = rawData_R(:,1);
        Data.RE_Pos_Y = rawData_R(:,2);
        Data.RE_Pos_Z = rawData_R(:,3);
end

function ang=rot2angvel(rot)
dr = diff(rot,1,1);
r = rot(1:(end-1),:) + dr./2;
denom = (1 + dot(r,r,2) - dot(dr,dr,2));
ang = 2*(dr + cross(r,dr,2)) ./ denom(:,[1 1 1]);

function ang=rot2angvelBJM20190107(rot)

dr = [diff(rot,1,1); [false false false]];
r = rot(1:end,:) + dr./2;
denom = (1 + dot(r,r,2) - dot(dr,dr,2));
ang = 2*(dr + cross(r,dr,2)) ./ denom(:,[1 1 1]);

function rot=fick2rot(fick)

% rot = fick2rot(fick)
%
%  Generate nx3 rotation vectors from the given nx3 horizontal, vertical
% and torsional Fick angles in degrees.  +h left, +v down, +t clockwise.

% Get the tangents of half of the angles.
fick = tan(fick.*(pi/180/2));

% We make rotation vectors in the same way we would make rotation matricies,
% by simply applying the three Fick rotations (Euler "gimbal" angles) in the
% proper order.  The "straight ahead" rotation vector is just [0 0 0], and
% for a rotation about a single axis you just put the tan of half the angle
% of rotation in the X, Y, or Z component of the rotation vector.  So we
% create these three simple, single rotations, and combine them.

% We need a vector of zeros with the same number of rows as our input.
zr = zeros(size(fick,1),1);

% The X (torsion) rotation is the first and innermost rotation.
% The Y (vertical) is the middle rotation.
% The Z (horizontal) is the last and outermost rotation.
rot = rot2rot([zr zr fick(:,1)], rot2rot([zr fick(:,2) zr], [fick(:,3) zr zr]));



function EinH = raw2rot(data, gains, ref, option, HinF)

%RAW2ROT.M
%100896 version
%Purpose	Produces rotations vectors from digitized data.
%
%PJB 2017-06-15
%I am adding code to correctly process coil signals acquired where the HEAD
%and FRAME coordinate systems are not equivalent. In VNEL, the Lasker
%system head frame has been setup with a non-traditional coordinate system:
%+X = Coming out of the LEFT ear
%+Y = Coming out the BACK of the subject's head
%+Z = Coming out the TOP of the subject's head
%Thus, we will need to perform the following operations:
%
% Assumptions:
% - From the coil system, we get [Coil_in_Frame]
% - [Head] |= [Frame] (i.e, the head is NOT aligned with the frame
% coordinate system
% - [Head_in_Frame] = [0 0 -1]
% - [Coil_in_Eye] = [Coil_in_Head]_@t=0 (i.e., we are assuming the subject
% is looking forward at t=0)
%
% [Coil_in_Head] = [Head_in_Frame]^T[Coil_in_Frame]
% [Eye_in_Head] = [Coil_in_Head][Coil_in_Eye]^T (i.e., 'taking a reference
% position')
% If the user does not input a 'HinF'
%
%Description	Remark
%		The below description uses the right-hand rule with
%		the following Cartesian coordinate system:
%		x: about nasooccipital pointing forward
%		y: horizontal (interaural) pointing leftward
%		z: perpendicular to x and y pointing upward
%
%		Data format
%		Matrix with 6 cols:
%		(1) torsional field direction coil (x)
%		(2) vertical field direction coil (y)
%		(3) horizontal (interaural) field direction coil (z)
%		(4) torsional field torsion coil (x)
%		(5) vertical field torsion coil (y)
%		(6) horizontal (interaural) field torsion coil (z)
%
%		Data is A/D converted by a 12-bit converter. Numbers range
%		from 0 to 4096. Therefore 2048 have to be subtracted from
%		each data channel.
%
%		Gains format
%		Vector with 6 elements.
%		During in-vitro calibrations the signals are inverted such
%		that positive signals appear leftward, upward, and with
%		positive torsion (extorsion of the right eye, intorsion of
%		the left eye).
%		(1) Maximal signal with direction coil sensitivity vector
%		along x
%		(2) along y
%		(3) along z
%		(4) Maximal signal with torsion coil sensitivity vector
%		along x
%		(5) along y
%		(6) along z
%
%Input		data
%		gains
%		ref: reference position = 6 element vector or 0 (= first sample taken)
%		option (optional): 0 = default (compute, rotate, and plot), 1 = compute only.
%
%Output		rot:	rotation vectors (see Haustein 1989): 3 cols (x, y, z - components).
%		reg:	4 col vector (yslope, zslope, offset, stdev).
%
%Call		r = raw2rot(data, gains, option, ref_option)
%

('Checking arguments...');
if nargin < 2
    gains = [1 1 1 1 1 1];
    %  disp('  Bad argument number.');
    %  return;
end;

if nargin < 3
    option = 0;
    ref = 0;
    HinF = 0;
end;

if nargin < 4
    option = 0;
    HinF = 0;
end;

if nargin < 5
    HinF = 0;
end;

%disp('Checking input formats...');
[dr dc] = size(data);
if dc ~= 6
    disp('  Data matrix must have 6 cols.');
    return;
end;

[gr gc] = size(gains);
if (gr~= 1)
    gains = gains';
end;

[gr gc] = size(gains);
if (gc ~= 6) & (gr ~= 1)
    disp('  Gains vector must have 6 elements...');
    return;
end;

%disp('Constructing reference sample');
if (length(ref) == 6)
    data = [ref; data];
end;

%disp('Dividing all data channels with gains (sign correction included)...');

dxv = (data(:,1)) ./ gains(1);
dyv = (data(:,2)) ./ gains(2);
dzv = (data(:,3)) ./ gains(3);

txv = (data(:,4)) ./ gains(4);
tyv = (data(:,5)) ./ gains(5);
tzv = (data(:,6)) ./ gains(6);

clear data;

%Length of coil vectors
dlv = sqrt(dxv.^2 + dyv.^2 + dzv.^2);
%tlv = sqrt(txv.^2 + tyv.^2 + tzv.^2);

%Inproduct of both coil vectors
inpv = dxv.*txv + dyv.*tyv + dzv.*tzv;

%Orthogonalize torsional vector
toxv = txv - ((inpv .* dxv) ./ (dlv.^2));
clear txv;
toyv = tyv - ((inpv .* dyv) ./ (dlv.^2));
clear tyv;
tozv = tzv - ((inpv .* dzv) ./ (dlv.^2));
clear tzv inpv;

%Length of orthogonalized torsional vector
tolv = sqrt(toxv.^2 + toyv.^2 + tozv.^2);

%Construct instantaneous new orthogonal coordinate system of coils
f11 = dxv ./ dlv; clear dxv;
f12 = dyv ./ dlv; clear dyv;
f13 = dzv ./ dlv; clear dzv dlv;
f21 = toxv ./ tolv; clear toxv;
f22 = toyv ./ tolv; clear toyv;
f23 = tozv ./ tolv; clear tozv tolv;
f31 = [f12.*f23-f13.*f22];
f32 = [f13.*f21-f11.*f23];
f33 = [f11.*f22-f12.*f21];

% Create rotation vectors from rotation matrix.
denom = 1+f11+f22+f33;
rot = [(f23-f32) (f31-f13) (f12-f21)] ./ denom(:,[1 1 1]);

% NOTE: At this point, we have constructed our time series of rotation
% vectors for the COIL in the FRAME, or [Coil_in_Frame]
CinF = rot;

if length(HinF) == 3
    % If the user sent a [3x1] rotation vector describing [Head_in_Frame],
    % apply that rotation.
    CinH = rot2rot(-HinF,CinF);
else
    % Used in cases where the user is assuming the [Frame] coordinate
    % system is identical to the [Head] coordinate system.
    CinH = CinF;
end

% Apply reference position (taken from first sample).
% i.e., Compute [Eye_in_Head] from [Coil_in_Head][Coil_in_Eye]^T
%
% Where:
% - [Coil_in_Eye] = [Coil_in_Head]_@t=0 (i.e., we are assuming the subject
% is looking forward at t=0)
CinE = CinH(1,:);
EinH = rot2rot(CinH,-CinE);

if (length(ref) == 6)
    EinH = EinH(2:length(EinH),:);
end;


function nrot = rot2rot(rot1, rot2)

%ROT2ROT.M
%Order for creating eye in head = -head in space (tiltrot) o eye in space (rot)
%DSt
%
%Purpose
%Rotates rotation vectors by a constant rotation
%
%Call
%nrot = rot2rot(rot1, rot2);
%
%Arguments
%nrot: rotated rotation vectors
%rot1: input rotation vector or constant (single row) vector
%rot2: input rotation vector or constant (single row) vector
%
%  The rotation may be applied in either order, so one argument
% is the data vector (many rows) and the other is the constant
% rotation to be applied (single row).
%
%  DCR 7/22/97 Both arguments may now be many rows (# rows must
%              be equal in both args).  So it can, for instance,
%              be used to calculate eye in head from head in
%              space and eye in space.

if nargin ~= 2
    disp('Must have two arguments!')
    return
end;

[rr cc] = size(rot1);
if cc ~= 3
    disp('First arg must have 3 columns');
    return;
end;

[rr cc] = size(rot2);
if cc ~= 3
    disp('Second arg must have 3 columns');
    return
end

% Whichever argument is just a single row, expand it to the
% same number of rows as the other argument.

if size(rot1,1) == 1
    rot1 = ones(size(rot2,1),1) * rot1;
elseif size(rot2,1) == 1
    rot2 = ones(size(rot1,1),1) * rot2;
end

cr = cross(rot1',rot2')';
ir = dot(rot1', rot2')' * [1 1 1];
nrot = (rot1+rot2+cr)./(1-ir);





function fick = rot2fick(rot)
%Purpose Converts rotation vectors into Fick angles
%Algorithm from a C-program written by Th. Haslwanter in 1990.
% Essentially does rot2mat() then mat2fick(), but we only
% compute the 3 elements of the mat that we need for Fick.


x = rot(:,1);
y = rot(:,2);
z = rot(:,3);
clear rot;

scalar = sqrt(x.*x + y.*y + z.*z);
alpha = 2*atan(scalar);

% Avoid divide-by-zero errors.
zr = scalar == 0;
scalar(zr) = 1;

nx = x ./ scalar; %normalize
ny = y ./ scalar;
nz = z ./ scalar;
clear x y z

sn = sin(alpha);
cs = cos(alpha);
clear alpha

%nx2 = nx.*nx;
%ny2 = ny.*ny;
%nz2 = nz.*nz;
%f11 = nx2 + cs .* (ny2 + nz2);
%f22 = ny2 + cs .* (nz2 + nx2);
%f33 = nz2 + cs .* (nx2 + ny2);

%f12 = nx .* ny .* (1-cs) - nz .* sn;
%f23 = ny .* nz .* (1-cs) - nx .* sn;
f31 = nz .* nx .* (1-cs) - ny .* sn;

%f13 = nx .* nz .* (1-cs) + ny .* sn;
f21 = ny .* nx .* (1-cs) + nz .* sn;
f32 = nz .* ny .* (1-cs) + nx .* sn;

clear sn cs
clear nx ny nz

vert = asin(f31);
horz = asin(f21 ./ cos(vert));
tors = asin(f32 ./ cos(vert));

fick = [horz -vert tors] .* 180 / pi;
