function ang=rot2angvelBJM20190107(rot)


dr = [diff(rot,1,1); [false false false]];
r = rot(1:end,:) + dr./2;
denom = (1 + dot(r,r,2) - dot(dr,dr,2));
ang = 2*(dr + cross(r,dr,2)) ./ denom(:,[1 1 1]);
