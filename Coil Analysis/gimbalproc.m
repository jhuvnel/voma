function [rotref,rotReye,rotLeye,rot,dvect,tvect,dlen,tlen,rotRrefEinH,rotLrefEinH] = gimbalproc(d, ZEROS, GAINS, ref)
%{
Analyze one eye at a time using this 
Computes the relative gains of the Y and Z fields to the X field for both coils. 
Should be similar relative values for both coils. rGAINS = [GAINS(1:3)/GAINS(1) GAINS(4:6)/GAINS(4)]

 vector to shift eyes by in fick need to add parameter to determine
 whether left eye or right eye
 CURRENTLY HARD CODED IN 55 degree ANGLE FOR CHINCHILLA EYE - NEED TO
 MEASURE

INPUT:
  d - Nx6, raw coil channels for N pairs of coils
  ZEROS - 1x6
  GAINS - 1x6
  ref - reference position 


OUTPUT:
  rotref - output of rot2rot
  rotReye - in right eye socket frame of reference
  rotLeye - in left eye socket frame of reference
  rot - output of raw2rot
  dvect - output of raw2rot
  tvect - output of raw2rot
  dlen - output of raw2rot
  tlen - output of raw2rot
  rotRref - right eye in head reference
  rotLref - left eye in head reference frame



%}
vec = [-55 0 0];

%NFilt = 50;
%d = filtfilt(ones(1,NFilt)/NFilt,1,d);

% dz is the 6 data columns with ZEROS subtracted out.
N = size(d,1);
dz = d - ZEROS(ones(N,1),:);

% Compute rotation vectors.
%rot = raw2rot(dz, rGAINS);
[rot dvect tvect dlen tlen] = raw2rot(dz, GAINS);

% Apply reference position (taken from first sample).
%%% OLD CODE, THIS IS NOT GOOD ASSUMPTION
rotref = rot2rot(rot,-rot(ref,:));

% for below math, please refer to
% Z:\Chow\Manuals-Datasheets\Coil-Math.doc for complete description
% find [Coil in Eye] from [Frame in Eye (socket)][Coil in Frame]
CinER = rot2rot(-fick2rot(vec),rot(ref,:));
CinEL = rot2rot(-fick2rot(-vec),rot(ref,:));

% this is [Eye in Head] = [Coil in Head][Eye in Coil]
rotRrefEinH = rot2rot(rot,-CinER);
rotLrefEinH = rot2rot(rot,-CinEL);

% To get eye rotation matrix in the EYE SOCKET reference frame:
% need to apply rotation vector for right eye axis and left eye axis
% multiply [socket in head]'[eye in head]
rotReye = rot2rot(-fick2rot(vec),rotRrefEinH);
rotLeye = rot2rot(-fick2rot(-vec),rotLrefEinH);


%%========================================================================
%%========================================================================
%
% Must have the zeros already subtracted out.
function [rot, dvect, tvect, dlen, tlen] = raw2rot(raw, gains)

N = size(raw,1);
	
dxv = (raw(:,1)) ./ gains(1);
dyv = (raw(:,2)) ./ gains(2);
dzv = (raw(:,3)) ./ gains(3);

txv = (raw(:,4)) ./ gains(4);
tyv = (raw(:,5)) ./ gains(5);
tzv = (raw(:,6)) ./ gains(6);

clear raw;

%Length of coil vectors
dlv = sqrt(dxv.^2 + dyv.^2 + dzv.^2);
tlv = sqrt(txv.^2 + tyv.^2 + tzv.^2);

% Return the two "un-orthogonalized" vectors, so we can see if the angle
% between them is changing significantly.
dvect = [dxv dyv dzv] ./ dlv(:, [1 1 1]);
tvect = [txv tyv tzv] ./ tlv(:, [1 1 1]);

% Return the vector lengths relative to the first sample, so we can see if
% the "gain" of the coils is changing significantly.
dlen = dlv ./ dlv(1);
tlen = tlv ./ tlv(1);

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
end

end