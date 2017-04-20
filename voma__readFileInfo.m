function [direction, frequency, amplitude, theta, phi] = voma__readFileInfo(directory,file)
%need to put in directory somewhere.
%need to feed in 'file'
direction = '';
frequency = [];
amplitude = [];
theta = [];
phi = [];
if ~isempty(strfind(file, '.coil'))
    search = file(1, 1:(length(file)-5));
    %Search only mpu files
    mfile = dir(strcat(directory,'\*_MPUdata.txt'));
    for i = 1:length(mfile)
        if ~isempty(strfind(mfile(i).name,search))
            mpufile = mfile(i).name;
            break;
        end
    end
    if isempty(mpufile) %if mpu file isn't found
        
    end
else
    
end

% Find the direction
directions = {'Yaw' 'Pitch' 'Roll' 'LARP' 'RALP' 'Heave' 'Surge' 'Lateral' 'ObliqueAngle' 'AnyAxis' 'NU' 'ND' 'RED' 'LED' 'RA' 'LP' 'LA' 'RP'};
for j = 1:length(directions)
    if (~isempty(strfind(file,char(directions(j)))))
        direction = char(directions(j));
        break;
    end
end

if (~isempty(strfind(direction, 'NU'))||~isempty(strfind(direction,'ND'))||~isempty(strfind(direction, 'LED'))||~isempty(strfind(direction,'RED')) ||~isempty(strfind(file,'Impulse')))
    
else %if not static, need frequency and amp
    % Find the frequency for visual display
    index = strfind(file, 'hz');
    if isempty(index)
        frequency = [];
    else
        i = 2;
        while ~(strcmp(file(index(1)-i),'-'))
            i = i + 1;
        end
        i = i-1;
        string = file(index(1)-i:index(1)-1);
        split = strsplit(string,'p');
        if length(split) ~= 1
            string = strcat(split(1),'.',split(2));
        end
        frequency = str2double(string);
    end
    
    % For rotation, need dps and no degrees
    if (strcmp(direction, 'Yaw') || strcmp(direction, 'Pitch') || strcmp(direction,'Roll') || strcmp(direction,'LARP') || strcmp(direction,'RALP'))
        index = strfind(file,'dps');
        if isempty(index)
            amplitude = [];
        else
            i = 2;
            while ~(strcmp(file(index(1)-i),'-'))
                i = i + 1;
            end
            i = i-1;
            string = file(index(1)-i:index(1)-1);
            split = strsplit(string,'p');
            if length(split) ~= 1
                string = strcat(split(1),'.',split(2));
            end
            amplitude = str2double(string);
        end
    else % translational
        %Find amplitude in mpsq
        index = strfind(file, 'mpsq');
        if isempty(index)
            amplitude = [];
        else
            i = 2;
            while ~(strcmp(file(index(1)-i),'-'))
                i = i + 1;
            end
            i = i-1;
            string = file(index(1)-i:index(1)-1);
            split = strsplit(string,'p');
            if length(split) ~= 1
                string = strcat(split(1),'.',split(2));
            end
            amplitude = str2double(string);
        end
        %Find Oblique Angle
        if strcmp(direction,'ObliqueAngle') ||strcmp(direction,'ObliqueAngleHorizontal')
            index = strfind(file,'deg');
            if isempty(index)
                theta = 0;
                phi = 0;
            else
                for i = 1:length(index)
                    deg = str2double(file(index(i)-3:index(i)-1));
                    if isnan(deg)
                        deg = str2double(file(index(i)-2:index(i)-1));
                        if isnan(deg)
                            deg = str2double(file(index(i)-1));
                        end
                    end
                    if i == 1
                        theta = deg;
                    else
                        phi = deg;
                    end
                end
            end

        else % For all translational motions (except oblique) need mpsq and no angle
        end
    end

end