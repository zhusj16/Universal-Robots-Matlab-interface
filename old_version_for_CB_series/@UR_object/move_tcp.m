function move_tcp(obj,offset)
%% movetcp，根据相对于工具坐标系进行移动
%  offset: [x,y,z,rx,ry,rz],xyz单位为米，rx,ry,rz单位为弧度

% 计算新的target_pose并更新UR对象的该属性
offset = offset(:); % 不管是行向量还是列向量都变成按列排列
R = Rxyz2R(obj.pose(4:6));
R_offset = Rxyz2R(offset(4:6));
obj.target_pose(1:3) = obj.pose(1:3) + R*offset(1:3);
obj.target_pose(4:6) = R2Rxyz(R*R_offset);

% 向UR发送运动命令
if strcmp(obj.s2.status,'closed')   %如果没打开端口，则打开之
    fopen(obj.s2);
end

t=0;r=0;%默认值 

cmd = sprintf(...
     'movel(pose_trans(get_target_tcp_pose(),p[%f,%f,%f,%f,%f,%f]),%f,%f,%f,%f)\n'...
     ,offset,obj.a_tool,obj.v_tool,t,r);
fprintf(obj.s2,cmd);
    

    