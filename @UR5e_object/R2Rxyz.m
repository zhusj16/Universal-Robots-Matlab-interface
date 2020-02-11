function rxyz = R2Rxyz(obj,R)
% 把旋转矩阵R变成旋转矢量Rxyz = [rx,ry,rz]'的形式
% phi = acos((trace(R)-1)/2);
% E = (R-R')/2/sin(phi);
% Rxyz = phi*[E(3,2),E(1,3),E(2,1)]';
% 这个方法对于旋转180度的情况来说是个奇异位置
% 系统自带的dcm2rod也是奇异位置！！！但是他这个处理不太精确的

r1 = real(dcm2rod(R'));
s = r1/norm(r1);
phi = atan(norm(r1))*2;
rxyz = s*phi;

end

