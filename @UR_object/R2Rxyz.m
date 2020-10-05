function rxyz = R2Rxyz(obj,R)
% Convert the rotation matrix to the rotation vector
% phi = acos((trace(R)-1)/2);
% E = (R-R')/2/sin(phi);
% Rxyz = phi*[E(3,2),E(1,3),E(2,1)]';

r1 = real(dcm2rod(R'));
s = r1/norm(r1);
phi = atan(norm(r1))*2;
rxyz = s*phi;

end

