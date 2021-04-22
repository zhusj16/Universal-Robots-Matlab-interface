function LAN_init(obj,ip_UR)
%% Initialize the tcpip connection to the robot
delete(instrfind('Type', 'tcpip')); % delete old connections if exist
if nargin > 1
   obj.ip_UR = ip_UR;
end    
rport1 = 29999;               % dashboard server
rport2 = 30003;               % realtime interface, for robot control, 500Hz update rate
rport3 = 30001;               % primary interface, for robot state monitoring

obj.s1 = tcpip(obj.ip_UR,rport1);

obj.s2 = tcpip(obj.ip_UR,rport2);
obj.s2.ReadAsyncMode = 'manual';
obj.s2.Timeout = 0.0001;
obj.s2.InputBufferSize = 588;
obj.s2.OutputBufferSize = 1024;

obj.s3 = tcpip(obj.ip_UR,rport3);
obj.s3.ReadAsyncMode = 'manual';
obj.s3.Timeout = 0.0001;
obj.s3.InputBufferSize = 636;

fopen(obj.s1); disp(fscanf(obj.s1));
fopen(obj.s2);
fopen(obj.s3);

for i=1:1  %the fisrt frame is robot_message instead of robot_state_message, which should be discarded.
    readasync(obj.s3);
    fread(obj.s3);
end
