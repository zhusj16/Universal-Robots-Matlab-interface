function cmd = set_speed_tcp(obj,varargin)
% set the tcp speed in tcp coordinate frame
% v: [x,y,z,rx,ry,rz]    x,y,z:m/s    rx,ry,rz:rad/s

if strcmp(obj.s2.status,'closed')   % if s2 is not open then open it
    fopen(obj.s2);
end

v = varargin{1};

if nargin==3
    a = varargin{2};
else
    a = obj.a_tool;
end

t=1;
  
cmd_ = sprintf(...
     ' speedl(wrench_trans(p[0,0,0,pose[3],pose[4],pose[5]],[%f,%f,%f,%f,%f,%f]),%f,%f)\n'...
      ,v,a,t);

cmd =            'def speed_tcp():\n';
cmd = strcat(cmd,'\t pose = get_target_tcp_pose()\n');
cmd = strcat(cmd,'\t',cmd_,'\n');
cmd = strcat(cmd,'end\n');
cmd = sprintf(cmd);
  
if nargout==0
    fprintf(obj.s2,cmd);
else
    % this is for force mode/move_collision_test
    cmd = 'pose = get_target_tcp_pose()\n';
    cmd = [cmd,cmd_,'\n'];
    cmd = sprintf(cmd);
end
