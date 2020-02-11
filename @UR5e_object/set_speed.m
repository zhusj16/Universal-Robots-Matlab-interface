function cmd = set_speed(obj,varargin)
% servo_cart，在机器人基坐标系中以给定速度V运动
% v: [x,y,z,rx,ry,rz],xyz单位为m/s，rx,ry,rz单位为rad/s

if strcmp(obj.s2.status,'closed')   %如果没打开端口，则打开之
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
