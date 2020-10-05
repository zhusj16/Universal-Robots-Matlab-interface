function cmd = move_tcp(obj,offset,path_type)
%% move in the tcp coordinate system
%  offset: [x,y,z,rx,ry,rz],xyz: m, rx,ry,rz: radius

%   path_type :'cart' : generate trajactory in Cartesian sapce
%              'joint': generate trajactory in joint space


offset = offset(:); % convert to column vector whatever the input is

% calculate the new target_pose
R = obj.Rxyz2R(obj.pose(4:6));
R_offset =  obj.Rxyz2R(offset(4:6));
obj.target_pose(1:3) = obj.pose(1:3) + R*offset(1:3);
obj.target_pose(4:6) =  obj.R2Rxyz(R*R_offset);

if strcmp(obj.s2.status,'closed')   % if the port is not open, then open it
    fopen(obj.s2);
end

t=0;r=0; % default value

if nargin==2
    path_type = 'cart';
end

if strcmp(path_type,'cart')
    cmd = sprintf(...
         'movel(pose_trans(get_target_tcp_pose(),p[%f,%f,%f,%f,%f,%f]),%f,%f,%f,%f)\n'...
         ,offset,obj.a_tool,obj.v_tool,t,r);
elseif strcmp(path_type,'joint')
    cmd = sprintf(...
         'movej(pose_trans(get_target_tcp_pose(),p[%f,%f,%f,%f,%f,%f]),%f,%f,%f,%f)\n'...
         ,offset,obj.a_joint,obj.v_joint,t,r);    
end
 
 
 if nargout==0
     fprintf(obj.s2,cmd);
 end
    

    