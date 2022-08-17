function ang=rot2angvel(rot)


dr = diff(rot,1,1);
r = rot(1:(end-1),:) + dr./2;
denom = (1 + dot(r,r,2) - dot(dr,dr,2));
ang = 2*(dr + cross(r,dr,2)) ./ denom(:,[1 1 1]);
