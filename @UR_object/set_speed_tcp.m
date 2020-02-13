function cmd = set_speed_tcp(obj,varargin)
% v: [x,y,z,rx,ry,rz],xyz单位为m/s，rx,ry,rz单位为rad/s

if strcmp(obj.s2.status,'closed')   % 如果没打开端口，则打开之
    fopen(obj.s2);
end

v = varargin{1};

if nargin==3
    a = varargin{2};
else
    a = obj.a_tool;
end

t=100;
  
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
    % this is for force mode
    cmd =            'def speed_tcp():\n';
    cmd = strcat(cmd,'\t\t pose = get_target_tcp_pose()\n');
    cmd = strcat(cmd,'\t\t',cmd_,'\n');
    cmd = strcat(cmd,'\tend\n');
    cmd = strcat(cmd,'\tspeed_tcp()');
    cmd = sprintf(cmd);
end
