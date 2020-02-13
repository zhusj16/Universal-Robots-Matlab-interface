classdef UR_object < handle
% a class for Universal Robot control
% support modules: e-series, tested on version 5.4
% author: Shijie Zhu

%% public parameters
    properties
        a_joint =  0.35; % join acceleration limit
        a_tool  =  0.5 ;   % tcp acceleration limit
        v_joint =  0.15/180*pi;  % join velocity limit
        v_tool  =  0.05;  % tcp velocity limit
        ip_UR='192.168.1.111'     %default ip/hostname of the robot
        tcp_data;        % tcp information including tcp offset, mass and center of gravity 
        n_tcp;           % number of active tcp
        target_pose;     % target tcp pose
    end
    
%% privately accessable parameters    
    properties  (SetAccess = private, GetAccess = public) 
        s1        % handles of port1 (dashborad 29999 for power control)
        s2        % handles of port2 (realtime interface 30003 for motion/force control and tcp setup) 
        s3        % handles of port3 (primary interface 30001, for robot moving status acquisition, i.e. in teachmode or not)
        pose      % current tcp pose
        q         % current joint position
        force     % current tcp force
        active_tcp   %active tcp data
        freedrive_status % boolean, is in teachmode or not
    end 
  
%% function definations and syntaxes 
    methods   
        function obj = UR_object(varargin)  %class constructor
          % If no ip adress/hostname is input, the default one is used.
          % Initialize the LAN connection
           LAN_init(obj,varargin{:});
          % Initialize tcp_data
           tcp_data_init(obj);
          % Activate the #1 tcp
           obj.n_tcp = 1;
          % Initialize the target pose
           obj.target_pose = obj.pose;
        end

        LAN_init(obj,varargin);  %Initialize the LAN connection

        tcp_data_init(obj);  % Initialize and upload the tcp data to the robot

        set_active_tcp(obj); % Upload the active tcp data to the robot

        power_on(obj);  % power on the robot and release the brake

        power_off(obj);   % power of the robot
        
        unlock(obj);    % unlock protective stop
        
        freedrive_on(obj); % activate teachmode
        
        freedrive_off(obj); % end teachmode
        
        [pose,q,force] = refresh_status(obj);  % read current tcp pose, joint position and tcp force
        
        freedrive_status = refresh_freedrive_status(obj); % query the robot status: is in teachmode(1) or not(0)

        cmd = move_tcp(obj,offset,path_type) % move tcp in tcp coordinate frame

        cmd = set_pose(obj,tgt_pose,path_type,axis_no_rotate); % move tcp to a pose defined in base coordinate frame
        
        cmd = set_joint(obj,tgt_q); % move the joint to a give joint position
        
        cmd = set_speed(obj,varargin); % set the tcp speed (in base coordinate frame)
        
        cmd = set_speed_tcp(obj,varargin); % set the tcp speed (in tcp coordinate frame)
        
        cmd = force_mode_tcp(obj,varargin) % start force mode (in tcp coordinate frame)

        cmd = stop(obj); % stop moving
        
        resume(obj,varargin)% resume the stopped movement 
        
        Rxyz = R2Rxyz(obj,R);  % convert rotation matrix to rotation vector 
        
        R = Rxyz2R(obj,Rxyz);  % convert rotation vector to rotation matrix 

    end
   
    methods  % automatic set&get
        
        % when pose,q,force and freedrive_status are queried, they are updated from robot
        function pose = get.pose(obj)    
           [pose,~,~] = obj.refresh_status;
        end
        
        function q = get.q(obj)          
           [~,q,~] = obj.refresh_status;
        end
        
        function force = get.force(obj)    
           [~,~,force] = obj.refresh_status;
        end

        function freedrive_status = get.freedrive_status(obj)  
           freedrive_status = obj.refresh_freedrive_status;
        end
        
        % when n_tcp is assigned, the correponding tcp data is upload to the robot
        function set.n_tcp(obj,n_tcp)      
           obj.n_tcp = n_tcp;
           set_active_tcp(obj);
        end
        
        % when active_tcp is queried, it will be refreshed according to current active tcp number
        function active_tcp = get.active_tcp(obj)
           active_tcp = obj.tcp_data(obj.n_tcp);
        end
        
        % when tcp_data is changed, the change will be also sent to the robot
        function set.tcp_data(obj,tcp_data) 
           obj.tcp_data = tcp_data;
           set_active_tcp(obj);
        end
        
    end
   
end
