function set_active_tcp(obj)
% --- 设置tcp位置，重心位置，载荷质量等参数  
% n_tcp是所选tcp_data的编号

% 查阅scriptManual 3.4.5得到如下指令可用：
% 1. set_payload(CoG) 设置负载质心位置[x,y,z] 单位：米
% 2. set_payload_mass(m) 设置负载质量，单位：千克
% 3. set_tcp（pose） 设置tcp 坐标系, 格式是UR语言里面专用的pose类型

%注意，必须要用30002端口，命令发送完之后必须要延时，否则会影响命令执行！
%设置完tcp之后，只要不在示教器上进入tcp配置页面重新刷一下，在示教器中进行移动操作时依然按照程序最后发送的tcp配置来执行！

% 从UR对象的tcp_data属性中读取tcp参数
tcp_data = obj.active_tcp;

if strcmp(obj.s2.status,'closed')
    fopen(obj.s2);
end

% 设置负载质量和重心位置
cmd1 = sprintf('set_payload(%f,[%f,%f,%f])\n',tcp_data.mass,tcp_data.CoG);
fprintf(obj.s2,cmd1);
pause(0.1);

% 设置工具坐标系位置
cmd2 = sprintf('set_tcp(p[%f,%f,%f,%f,%f,%f])\n',tcp_data.pose);
fprintf(obj.s2,cmd2);
pause(0.1);
    
    
    
    
