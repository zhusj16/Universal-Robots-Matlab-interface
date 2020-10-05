function cmd = set_speed(obj,varargin)
%% move the robot with specified speed in robot base coordinate system.
% v: the speed vector formatted as [vx,vy,vz,rx,ry,rz],v: m/s, r: rad/s

if strcmp(obj.s2.status,'closed')   % if the port is not open, then open it
    fopen(obj.s2);
end

v = varargin{1};

if nargin==3
    a = varargin{2};
else
    a = obj.a_tool;
end

t=100;
cmd = sprintf(...
     'speedl([%f,%f,%f,%f,%f,%f],%f,%f)\n'...
      ,v,a,t);

if nargout==0
    fprintf(obj.s2,cmd);
end  
