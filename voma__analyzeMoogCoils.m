function [fickR, fickL, rotR, rotL, velR, velL, LRZR, LRZL, mpuAligned] = voma__analyzeMoogCoils(mpu, coils, REF, gains,zeros)
%{
Align and analyze coil data
1. align the two files with the sync signal using dutycycle(X,Fs).
2. convert raw coil data to rotation vectors using analyzeCoilData() which calls gimbalproc().
3. convert rotation vectors to eye position in Fick Coordinates for VOMA
GUI
4. convert position to velocity for VOMA GUI

INPUT:
  mpu - the mpu data containing sensor data and the saved sync signal
  coils - the eye coil data also containing the sync signal 
  REF - reference point used in gimbol proc.
  GAINSR - if not using with the Data_GUI, send gains for Right eye (R eye coils connected to Ch1 and Ch2
     so gains should be: [Ch1X Ch1Y Ch1Z Ch2X Ch2Y Ch2Z]
  GAINSL - if not using with the Data_GUI, send gains for Left eye (L eye coils connected to Ch3 and Ch4
     so gains should be: [Ch3X Ch3Y Ch3Z Ch4X Ch4Y Ch4Z]
  ZEROS_R - if not using with the Data_GUI, send zeroes in for Right eye
  ZEROS_L - if not using with the Data_GUI, send zeroes in for Left eye

OUTPUT:
  rotR - the rotation vector for right eye movements in head frame of reference, after subtracting
    offsets, and using frame of reference, gains, and reference point as provided to gimbalproc();
  rotL - the rotation vector for left eye movements in head frame of reference, after subtracting
    offsets, and using frame of reference, gains, and reference point as provided to gimbalproc();
  mpuAligned - the mpu data with any access data points pre or post
    alignment deleted
  coilsAligned - the raw coil data with any access data points pre or post
    alignment deleted

returns [d, initcross,finalcross],
where d=data of dutycycle of each pulse,
init cross is vector elements correspond to mid-crossing of initial transition of each pulse
finalcross is vector elements that correspond to final-crossing
%}


[mpuSYNC,initCrossMPU]=dutycycle(mpu(30:length(mpu),2),1000);
[coilsSYNC,initCrossCoils]=dutycycle(coils(30:length(coils),3),1000);

%pick the larger of the two starting values...then find that point where
%the larger value happened in both data sets and choose that as starting
%point.  You need to round data - chose the thousandth's place - cuz
%otherwise you won't find the matching number

isMpuAligned = true;
isCoilsAligned = true;
mpuSYNC=round(mpuSYNC*200)/200;
coilsSYNC=round(coilsSYNC*200)/200;

%if the difference in the first sync pulse  durations in the files is >0.2
if (abs(mpuSYNC(1)-coilsSYNC(1))>=0.2)
    %this means a wrap around occured before recording in one channel
    %so we want to start adding to the channel that wrapped around now,
    %and the other channel later once we see the wrap around
    if (mpuSYNC(1)<coilsSYNC(1))
        mpuSYNC=mpuSYNC+0.2;
        offsetAddMPU=0.2;
        offsetAddCoils=0;
    else
        coilsSYNC=coilsSYNC+0.2;
        offsetAddCoils=0.2;
        offsetAddMPU=0;
    end
else
    offsetAddMPU=0;
    offsetAddCoils=0;
end


for i=2:length(mpuSYNC)
    if (mpuSYNC(i)<(mpuSYNC(i-1)-offsetAddMPU))
        offsetAddMPU=offsetAddMPU+0.2;
    end
    mpuSYNC(i)=mpuSYNC(i)+offsetAddMPU;
end

for j=2:length(coilsSYNC)
    if (coilsSYNC(j)<(coilsSYNC(j-1)-offsetAddCoils))
        offsetAddCoils=offsetAddCoils+0.2;
    end
    coilsSYNC(j)=coilsSYNC(j)+offsetAddCoils;
end


if (mpuSYNC(1)<coilsSYNC(1))
    startingDutyValue=coilsSYNC(1);
    idxCOILS=round(initCrossCoils(1)*1000);
    idxMPU=round(initCrossMPU(find(mpuSYNC==startingDutyValue,1,'first'))*1000);
else
    startingDutyValue=mpuSYNC(1);
    idxCOILS=round(initCrossCoils(find(coilsSYNC==startingDutyValue,1,'first'))*1000);
    idxMPU=round(initCrossMPU(1)*1000);
end

if idxMPU == 0
    idxMPU = 1;
end
if idxCOILS == 0
    idxCOILS = 1;
end


%now that we have the starting index where the two files line up - lets pick an ending index
if ((length(mpu)-idxMPU)>(length(coils)-idxCOILS))
    totalLength=length(coils)-idxCOILS;
else
    totalLength=length(mpu)-idxMPU;
end


mpuAligned=mpu(idxMPU:(totalLength+idxMPU),:);
if isempty(mpuAligned)
    isMpuAligned = false;
end
if isMpuAligned
    %get rid of MPU offsets
    for i=3:size(mpuAligned,2)
        mpuAligned(:,i)=mpuAligned(:,i)-mpuAligned(REF,i);
    end

    
end

coilsAligned=coils(idxCOILS:(totalLength+idxCOILS),:);
if isempty(coilsAligned)
    isCoilsAligned = false;
end
if isCoilsAligned
    GAINSR = gains(1:6);
    GAINSL = gains(7:12);
    ZEROS_R = zeros(1:6);
    ZEROS_L = zeros(7:12);
    
    [rotrefR]=voma__gimbalproc(coilsAligned(:,4:9), ZEROS_R, GAINSR, REF);
    [rotrefL]=voma__gimbalproc(coilsAligned(:,10:15), ZEROS_L, GAINSL ,REF);
    
    
    rotR = rotrefR; %CHANGE MADE BY KH 2/11/16 - should be rotRref and not rotRhead
    rotL = rotrefL; %CHANGE MADE BY KH 2/11/16 - should be rotLref and not rotLhead
    
else
    rotR =[];
    rotL =[];
end

if ~isempty(rotR)
    
    fickR = rot2fick(rotR);
    fickL = rot2fick(rotL);
    
    velR = rot2angvel(rotR)*180*1000/pi;
    velL = rot2angvel(rotL)*180*1000/pi;
    
    newFrameinFrame = fick2rot([45 0 0]);
    rotrotR = rot2rot(newFrameinFrame,rotR);
    LRZR = rot2angvel(rotrotR)/pi*180*1000;
    
    rotrotL = rot2rot(newFrameinFrame,rotL);
    LRZL = rot2angvel(rotrotL)/pi*180*1000;
   
else
    fickR = [];
    fickL =[];
    velR =[];
    velL =[];
    LRZR =[];
    LRZL = [];
end
end


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
end


function ang=rot2angvel(rot)
dr = diff(rot,1,1);
r = rot(1:(end-1),:) + dr./2;
denom = (1 + dot(r,r,2) - dot(dr,dr,2));
ang = 2*(dr + cross(r,dr,2)) ./ denom(:,[1 1 1]);
end

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
end

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
end

