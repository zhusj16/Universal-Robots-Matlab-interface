function move_tcp(obj,offset)
%% movetcp����������ڹ�������ϵ�����ƶ�
%  offset: [x,y,z,rx,ry,rz],xyz��λΪ�ף�rx,ry,rz��λΪ����

% �����µ�target_pose������UR����ĸ�����
offset = offset(:); % ��������������������������ɰ�������
R = Rxyz2R(obj.pose(4:6));
R_offset = Rxyz2R(offset(4:6));
obj.target_pose(1:3) = obj.pose(1:3) + R*offset(1:3);
obj.target_pose(4:6) = R2Rxyz(R*R_offset);

% ��UR�����˶�����
if strcmp(obj.s2.status,'closed')   %���û�򿪶˿ڣ����֮
    fopen(obj.s2);
end

t=0;r=0;%Ĭ��ֵ 

cmd = sprintf(...
     'movel(pose_trans(get_target_tcp_pose(),p[%f,%f,%f,%f,%f,%f]),%f,%f,%f,%f)\n'...
     ,offset,obj.a_tool,obj.v_tool,t,r);
fprintf(obj.s2,cmd);
    

    