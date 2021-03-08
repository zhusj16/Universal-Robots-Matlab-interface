function R = Rxyz2R(Rxyz)
% ��Rxyz = [rx,ry,rz]'ת������ת����;
phi = norm(Rxyz);
if (phi == 0)
    e = [1,0,0]';
else
    e = Rxyz/phi;
end

E = [0    -e(3)  e(2)
     e(3)  0    -e(1)
    -e(2)  e(1)   0 ];
R = eye(3)+sin(phi)*E+(1-cos(phi))*E*E;
end

