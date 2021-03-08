function rxyz = R2Rxyz(R)
% ����ת����R�����תʸ��Rxyz = [rx,ry,rz]'����ʽ
% phi = acos((trace(R)-1)/2);
% E = (R-R')/2/sin(phi);
% Rxyz = phi*[E(3,2),E(1,3),E(2,1)]';
% �������������ת180�ȵ������˵�Ǹ�����λ��
% ϵͳ�Դ���dcm2rodҲ������λ�ã������������������̫��ȷ��

r1 = real(dcm2rod(R'));
s = r1/norm(r1);
phi = atan(norm(r1))*2;
rxyz = s*phi;

end

