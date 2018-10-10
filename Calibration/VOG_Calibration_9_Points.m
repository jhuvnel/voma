function Polynomials = VOG_Calibration_9_Points(Eye, Distance_To_Wall, File_To_Load,RawName)

% Load left eye calib params from file
fileID = fopen(File_To_Load);
C = textscan(fileID,'%q %q', 'delimiter','\t');
H_Avg = cellfun(@str2num,C{1});
V_Avg = cellfun(@str2num,C{2});
fclose(fileID);

if (strcmp(Eye,'Left'))
    filename_to_save = [RawName '_Calibration_Left_Eye.txt'];
elseif (strcmp(Eye,'Right'))
    filename_to_save = [RawName '_Calibration_Right_Eye.txt'];
end

figure;
%subplot(1,2,1);
hold on;
grid on;
grid minor;
plot(H_Avg, V_Avg, 'ro');
title_string = strcat('Eye Averages: ', Eye);
title('Eye Averages: ');
xlabel('X Position: Pixels');
ylabel('Y Position: Pixels');

% Calculate and show horizontal distances
Starting_i1 = [0 3 6] + 1;
count = 0;
for i = 1:3
    i1 = Starting_i1(i);
    i2 = i1 + 1;
    for j = 1:2
        distance = sqrt( (H_Avg(i2) - H_Avg(i1))^2 + (V_Avg(i2) - V_Avg(i1))^2 );
        distance_txt = num2str(distance);
        H = (H_Avg(i2) + H_Avg(i1)) / 2;
        V = (V_Avg(i2) + V_Avg(i1)) / 2 + 2;
        plot([H_Avg(i1) H_Avg(i2)], [V_Avg(i1) V_Avg(i2)],'r--');
        text(H, V, distance_txt, 'Color','r');
        i1 = i1 + 1;
        i2 = i2 + 1;
        count = count + 1;
    end
end

% Calculate and show vertical distances
Starting_i1 = [0 1 2] + 1;
count = 0;
for i = 1:3
    i1 = Starting_i1(i);
    i2 = i1 + 3;
    for j = 1:2
        distance = sqrt( (H_Avg(i2) - H_Avg(i1))^2 + (V_Avg(i2) - V_Avg(i1))^2 );
        distance_txt = num2str(distance);
        H = (H_Avg(i2) + H_Avg(i1)) / 2;
        V = (V_Avg(i2) + V_Avg(i1)) / 2;
        plot([H_Avg(i1) H_Avg(i2)], [V_Avg(i1) V_Avg(i2)],'r--');
        text(H, V, distance_txt, 'Color','r');
        i1 = i1 + 3;
        i2 = i2 + 3;
        count = count + 1;
    end
end

minH = round(min(H_Avg));%, -1);
maxH = round(max(H_Avg));%, -1);
minV = round(min(V_Avg));%, -1);
maxV = round(max(V_Avg));%, -1);

deltaH = maxH - minH;
deltaV = maxV - minV;

offset = 10;

if (deltaH > deltaV)
    xlim_min = minH - offset;
    xlim_max = maxH + offset;
    difference = deltaH - deltaV;
    ylim_min = minV - difference/2 - offset;
    ylim_max = maxV + difference/2 + offset;
elseif (deltaV > deltaH)
    ylim_min = minV - offset;
    ylim_max = maxV + offset;
    difference = deltaV - deltaH;
    xlim_min = minH - difference/2 - offset;
    xlim_max = maxH + difference/2 + offset;
end

axis square
axislimit = [xlim_min xlim_max ylim_min ylim_max];
%axis(axislimit_LE);

N = 9;
A_in = zeros(2,N);
A_deg = zeros(2,N);

% distance in inches
distance_bw_laser_pts = 11.0;

%Subject_Distance_From_Targets = 90;

Subject_Distance_From_Targets = Distance_To_Wall;

A_in(2,1:3) = distance_bw_laser_pts;
A_in(2,4:6) = 0;
A_in(2,7:9) = -distance_bw_laser_pts;

for i = 1:3:N
    A_in(1,i) = -distance_bw_laser_pts;
end
for i = 2:3:N
    A_in(1,i) = 0;
end
for i = 3:3:N
    A_in(1,i) = distance_bw_laser_pts;
end

Inch_to_CM = 2.54;

A_cm = Inch_to_CM * A_in;

for i = 1:length(A_in)
    A_deg(1,i) = atand(A_in(1,i)/Subject_Distance_From_Targets);
    A_deg(2,i) = atand(A_in(2,i)/Subject_Distance_From_Targets);
end

A_deg = -A_deg;
fitting_model = 'poly22';
hvmodel = [A_deg(1,:); A_deg(2,:)];
z1 = hvmodel(1,:)';
z2 = hvmodel(2,:)';

horizontal_offset = 0;
vertical_offset = 0;
horizontal = H_Avg' - horizontal_offset;
vertical = V_Avg' - vertical_offset;

horizontal = horizontal';
vertical = vertical';

%horizontalydata = [horizontal vertical];
f1 = fit( [horizontal, vertical], z1, fitting_model )
f2 = fit( [horizontal, vertical], z2, fitting_model )

model_horizontal_fitting = zeros(length(horizontal));
model_vertical_fitting = zeros(length(vertical));
model_horizontal_fitting = f1(horizontal, vertical);
model_vertical_fitting = f2(horizontal, vertical);

figure;
hold on;
plot(model_horizontal_fitting, model_vertical_fitting, 'rx');
plot(hvmodel(1,:), hvmodel(2,:), 'bo');
title(strcat(fitting_model, Eye));
legend('Fitted Data','Position in Real Space', 'Location','NorthOutside', 'Orientation', 'Horizontal');

Polynomials = zeros(6,2);

Polynomials(1,1) = f1.p00;
Polynomials(2,1) = f1.p10;
Polynomials(3,1) = f1.p01;
Polynomials(4,1) = f1.p20;
Polynomials(5,1) = f1.p11;
Polynomials(6,1) = f1.p02;

Polynomials(1,2) = f2.p00;
Polynomials(2,2) = f2.p10;
Polynomials(3,2) = f2.p01;
Polynomials(4,2) = f2.p20;
Polynomials(5,2) = f2.p11;
Polynomials(6,2) = f2.p02;

filename_to_save

fileID = fopen(filename_to_save, 'w');
dlmwrite(filename_to_save, Polynomials, '\t')
fclose(fileID);

end