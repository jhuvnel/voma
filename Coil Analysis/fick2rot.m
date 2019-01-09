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
