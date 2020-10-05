%This demo is for UR5e, tested on V5.4.2

% How to use:
% Run section by section and see how the robot reacts and 
% what massages are returned in the command line window.

%% Initialization
h_UR = UR_object; % create a new UR_object object, 
                  % which will establish the TCPIP connection with the robot
                  % the default ip address is 192.168.1.111
                  
% if this is IP is not correct, the user should manually specify the IP or hostname as follows:
% h_UR = UR_object('ip address or hostname of the robot');

%% power control of the robot
h_UR.power_on; % power on the robot
% h_UR.power_off; % power off the robot

%% Configure the TCP parameters

% example1: specify the TCP parameters
h_UR.tcp_data(1).mass = 0;                  % mass of the payload
h_UR.tcp_data(1).CoG  = [0,0,0];            % center of gravity of the payload
h_UR.tcp_data(1).pose = [0,0,0,0,0,0];      % pose of the tcp coordinate frame
h_UR.tcp_data(1).str = 'user defined tcp';  % name the defined tcp parameters 
                                            % You can define several set of different tcp parameters with h_UR.tcp_data(i).xx = xx

% example2: activate the specified tcp configuration
h_UR.n_tcp = 1;
% example3:
% you can also defined the default tcp data in "tcp_data_init.m"
% every time the UR_object is created, tcp_data(1) defined in "tcp_data_init.m" will be uploaded to the robot
% every time you assign a new value to the tcp_data, it will also be immediately uploaded to the robot automatically.

%% move the robot
%% example1: Assign a desired pose in the robot base coordinate system.
current_pose = h_UR.pose; % read current pose of the robot, which is defined in the robot base coordinate system, 
                          % formatted as [x,y,z,rx,ry,rz]' by meter and radius;
tgt_pose = current_pose + [0,0,0.02,0,0,0]';  % offset the current pose
path_type = 'joint'; % joint: generate the path in the joint space
                     % cart:  generate the path in the cartesian space
                     % if path_type is not specifed, 'joint' will be used.
h_UR.set_pose(tgt_pose,path_type); % move the robot to the target pose

%% example2: Assign a movement in the tcp coordinate frame
offset = [0,0,0.02,0,0,0]; % pose transformation in tcp coordinate frame, formatted as [x,y,z,rx,ry,rz], by meter and radius
                           % the path is generate in Cartesian space
h_UR.move_tcp(offset);     % move the robot according to the specified tcp offset.

%% example3: pause and resume
h_UR.stop;   % you can stop the robot from moving whenever you want with this command
h_UR.resume; % the robot will continue moving to the pose most resently specifed move_tcp/set_pose 

%% example4: freedrive mode
h_UR.freedrive_on;   % activate the freedrive mode
disp(h_UR.freedrive_status);  % query the freedrive status: 1-freedrive on 0-freedrive off
h_UR.freedrive_off;  % disable the freedrive mode


