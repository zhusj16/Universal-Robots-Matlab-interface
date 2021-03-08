function LAN_init(obj,ip_UR)
%% 初始化网口
if nargin > 1
   obj.ip_UR = ip_UR;
end    
rport1 = 29999;               %UR机器人端口号，29999为dashboard端口，可以进行上电，解除制动，关机等操作
rport2 = 30002;               %30003为实时端口，刷新率125Hz，30001和30002端口刷新率为10Hz 
obj.s1 = tcpip(obj.ip_UR,rport1);
obj.s2 = tcpip(obj.ip_UR,rport2);
obj.s2.ReadAsyncMode = 'manual';
obj.s2.Timeout = 0.0001;
obj.s2.InputBufferSize = 679;