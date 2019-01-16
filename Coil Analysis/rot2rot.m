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
return
