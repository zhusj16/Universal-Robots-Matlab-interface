%程序适用于UR5
%新买的UR10读数会出现错误
%使用方法：

%% 初始化
h_UR = UR_object; %新建一个UR5的对象,使用默认ip:192.168.1.111
%或使用h_UR = UR_object('指定的ip地址');

%% 机器人通电与断电
h_UR.power_on; %机器人上电
h_UR.power_off;%机器人下电

%% 设置工具端
% example1:用命令修改tcp参数
h_UR.tcp_data(1).mass = 1; 
% example2:指定当前活跃的tcp
h_UR.n_tcp = 1;
% example3:直接在tcp_data_init文件中修改tcp参数
% 注1：每次指定n_tcp或者通过命令修改tcp参数后，会自动向机器人发送指令刷新tcp参数
% 注2：可以把tcp参数放在等号右边直接读取感兴趣的tcp参数

%% 移动机器人
% example1:指定机械臂在基坐标系中的位姿
current_pose = h_UR.pose; %读取当前机器人再基坐标系中的位姿[x,y,z,rx,ry,rz]',单位为米、弧度;
tgt_pose = current_pose + [0,0,0.02,0,0,0]';
path_type = 'joint'; %joint:关节空间规划，cart:笛卡尔空间规划
% 若指定axis_no_rotate = [1,0,0], 则机器人结束为止与初始位置相比，不沿[1,0,0]方向转动
% 若不指定axis_no_rotate,或者axis_no_rotate = [0,0,0],则直接运动到tgt_pose
% 若不指定path_type,则默认按照关节空间'joint'规划
% h_UR.set_pose(tgt_pose,path_type,axis_no_rotate);
h_UR.set_pose(tgt_pose,path_type); 

% example2:指定机械臂在工具坐标系中的运动量
offset = [0,0,0.02,0,0,0]; %工具坐标系中的运动量[x,y,z,rx,ry,rz],单位为米、弧度，采用笛卡尔空间规划;
h_UR.move_tcp(offset);

% example3:运动过程中暂停与继续
h_UR.stop; %暂停机器人的运动
h_UR.resume; %恢复机器人的运动。此时机器人会运动到最近一次执行的move_tcp或者set_pose命令所指定的目标位置
%h_UR.resume('cart',[0,1,0]);
%恢复运动还可以指定规划模式和axis_no_rotate,如果不指定，则默认‘join’规划

