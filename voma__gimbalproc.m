function [rotref,rot,dvect,tvect,dlen,tlen] = voma__gimbalproc(d, ZEROS, GAINS, ref)
%{
Analyze one eye at a time using this
Computes the relative gains of the Y and Z fields to the X field for both coils.
Should be similar relative values for both coils. rGAINS = [GAINS(1:3)/GAINS(1) GAINS(4:6)/GAINS(4)]


INPUT:
  d - Nx6, raw coil channels for N pairs of coils
  ZEROS - 1x6
  GAINS - 1x6
  ref - reference position


OUTPUT:
  rotref - output of rot2rot eye movement wrt first eye position
  rot - output of raw2rot
  dvect - output of raw2rot
  tvect - output of raw2rot
  dlen - output of raw2rot
  tlen - output of raw2rot



%}
vec = [0 0 0];

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


end