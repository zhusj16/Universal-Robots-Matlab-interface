function  tcp_data_init(obj)
%% TCP_SETUP
%% 直接通过UR script调整TCP位置乃至质量设定.
% UR对象建立时赋值，对象建立后人为修改该值也可以
% 查阅scriptManual 3.4.5得到如下指令可用：
% 1. set_payload(CoG) 设置负载质心位置[x,y,z] 单位：米
% 2. set_payload_mass(m) 设置负载质量，单位：千克
% 3. set_tcp（pose） 设置tcp 坐标系, 格式是UR语言里面专用的pose类型
% tcp_data储存了质量mass,质心位置CoG,tcp坐标信息pose,以及钻头直径

RR = obj.R2Rxyz(obj.Rxyz2R([0,0,2/3*pi])*obj.Rxyz2R([pi/3,0,0]));

%% 空白TCP,开机默认是这个值,中心位于标定碗的旋转轴于法兰盘中轴的交点上
tcp_data(1).mass = 0.8;   % 工具质量（kg）
tcp_data(1).CoG = [0,0,150]*1e-3; % 工具法兰质心位置
tcp_data(1).pose = [0,0,206.5e-3,0,0,0]; % 工具端绕固定点旋转的中心点距离工具法兰的z向距离（mm）
tcp_data(1).w0 = 3.2;
tcp_data(1).str = '<1> 无工具/标定碗';

%% tcp2 导向器，3.2导管
tcp_data(2).mass = 0.5;    
tcp_data(2).CoG = [0,0,100]*1e-3;
l = -(53.45)*1e-3;
dl = -41e-3;
tcp_data(2).pose = [-(l+dl*cosd(30))*sind(120),(l+dl*cosd(30))*cosd(120),(242.42*1e-3-dl*sind(30)),RR];  %绕x轴旋转60度
% tcp_data(2).pose = [-(l+dl*cosd(30))*sind(120),(l+dl*cosd(30))*cosd(120),(238*1e-3-dl*sind(30)),RR];  %绕x轴旋转60度
tcp_data(2).w0 = 4.95;
tcp_data(2).str = '<2> 3.2mm导向器';

%% tcp3 导向器，4.1导管
tcp_data(3).mass = 0.5;    
tcp_data(3).CoG = [0,0,100]*1e-3;
l = -(53.45)*1e-3;
tcp_data(3).pose = [-l*sind(120),l*cosd(120),(242.42)*1e-3,RR];  %绕x轴旋转60度
tcp_data(3).w0 = 7.5;
tcp_data(3).str = '<3> 4.1mm导向器';

%% tcp4 钻头90度放置，伸出长度为l_drill
%l_drill=76;
tcp_data(4).mass = 1.2;    
tcp_data(4).CoG = [0,0,100]*1e-3;
%先绕x轴旋转90度，再绕z轴旋转180度
% ang_tcp = R2Rxyz(Rxyz2R([0,0,pi])*Rxyz2R([pi/2,0,0]));
% tcp_data(4).pose = [1.24e-3,(165.14+l_drill)*1e-3,122.77e-3,ang_tcp];
tcp_data(4).pose = [0,-273.75e-3,128.36e-3,pi/2,0,0];

tcp_data(4).w0 = 4.0;
tcp_data(4).str = '<4> 90°电钻(钻头平行于法兰盘)';

%% tcp5 钻头0度放置，伸出100mm
l_drill=76;
tcp_data(5).mass = 1.5;
tcp_data(5).CoG = [-45,0,130]*1e-3;
tcp_data(5).pose = [-66.82e-3,-2.1e-3,(291.54+l_drill)*1e-3,0,0,pi/2];  %绕z轴旋转90度
tcp_data(5).w0 = 4.0;
tcp_data(5).str = '<5> 0°电钻(钻头垂直于法兰盘)';

%% tcp6 工具端质量参数标定
tcp_data(6).mass = 0.8;
tcp_data(6).CoG = [0,0,130]*1e-3;
tcp_data(6).pose = [0,0,0,0,0,0];  %绕z轴旋转90度
tcp_data(6).w0 = 4.0;
tcp_data(6).str = '<6> 工具端质量参数标定';


%% tcp参数写入UR对象
obj.tcp_data = tcp_data;