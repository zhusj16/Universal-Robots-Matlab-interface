function  tcp_data_init(obj)
%% predifined tool center point configurations

% 
% 1. set_payload(CoG) 设置负载质心位置[x,y,z] 单位：米
% 2. set_payload_mass(m) 设置负载质量，单位：千克
% 3. set_tcp（pose） 设置tcp 坐标系, 格式是UR语言里面专用的pose类型
% tcp_data储存了质量mass,质心位置CoG,tcp坐标信息pose,以及钻头直径

%% TCP datas. You can replace the values as you like 
% These data will sent to the robot when you power on the robot, and will
% be refreshed automatically when you assigne new values to these
% parameters.

% mass : mass of the payload (Kg)
% CoG : center of gravity of the payload. [x,y,z] coordinate defined in tcp
% coordinate system. (m)
% pose: pose of the tcp coordinate system, defined as [x,y,z,rx,ry,rz],
% i.e., the transformation from the default tcp coordinate system (the tool
% flange).(m and radius)
% str: name of the tcp configuration

%% TCP1 (default)
tcp_data(1).mass = 0;   
tcp_data(1).CoG = [0,0,0]; 
tcp_data(1).pose = [0,0,0,0,0,0]; 
tcp_data(1).str = '<1> default tcp';

%% TCP2
tcp_data(2).mass = 0;    
tcp_data(2).CoG = [0,0,0];
tcp_data(2).pose = [0,0,0,0,0,0];
tcp_data(2).str = '<2> user defined tcp';


%% tcp参数写入UR对象
obj.tcp_data = tcp_data;