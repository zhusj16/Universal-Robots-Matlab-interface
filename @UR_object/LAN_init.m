function LAN_init(obj,ip_UR)
%% 初始化网口
delete(instrfind('Type', 'tcpip')); %删除旧的网络连接,减少卡顿,降低读数错误的风险
if nargin > 1
   obj.ip_UR = ip_UR;
end    
rport1 = 29999;               %UR机器人端口号，29999为dashboard端口，可以进行上电，解除制动，关机等操作
rport2 = 30003;               %30003为实时端口，刷新率125Hz，30001和30002端口刷新率为10Hz
rport3 = 30001;               %30001刷新率10Hz,用于读calibration data

obj.s1 = tcpip(obj.ip_UR,rport1);

obj.s2 = tcpip(obj.ip_UR,rport2);
obj.s2.ReadAsyncMode = 'manual';
obj.s2.Timeout = 0.0001;
obj.s2.InputBufferSize = 1116;
obj.s2.OutputBufferSize = 1024;

obj.s3 = tcpip(obj.ip_UR,rport3);
obj.s3.ReadAsyncMode = 'manual';
obj.s3.Timeout = 0.0001;
obj.s3.InputBufferSize = 716;  %UR5e的这个包长度是716

fopen(obj.s1); disp(fscanf(obj.s1));
fopen(obj.s2);
fopen(obj.s3);

for i=1:3  %由于未知原因,30001端口头两次读数有一定概率返回错误信息，因此在初始化的时候先读几遍
    readasync(obj.s3);
    fread(obj.s3);
end
