classdef UR_object < handle
    
    properties
        a_joint =  0.35; %关节空间加速度限制
        a_tool  =  0.1 ; %笛卡尔空间加速度限制
        v_joint =  2;    %关节空间速度限制
        v_tool  =  0.03; %笛卡尔空间速度限制
        ip_UR='192.168.1.111'     %机器人网口默认ip
        tcp_data;      %tcp信息，包括质量质心tcp位姿，不给初始化值 
        n_tcp;         % 当前激活的tcp的编号
        target_pose;   %tcp的目标位姿
    end
    
    properties  (SetAccess = private, GetAccess = public) 
        s1        %机器人网络端口1，用于上电，断电，接触制动等
        s2        %机器人网络端口2，用于输入运动命令，TCP配置参数等 
        pose      %当前机器人姿态
        active_tcp   %当前活动的tcp配置
    end 
   
    methods   
        function obj = UR_object(varargin)  %对象的生成函数
          % 输入为UR的ip地址，若缺省，则按照默认的ip地址执行
          % 初始化LAN参数
           LAN_init(obj,varargin{:});
          % 初始化tcp_data
           tcp_data_init(obj);
          % 默认激活1号tcp_data
           obj.n_tcp = 1;
          % 初始化target_pose
           obj.target_pose = obj.pose;
        end

        LAN_init(obj,varargin);  %初始化网络端口参数

        tcp_data_init(obj);  %载入默认的tcp参数

        set_active_tcp(obj); % 激活选定的tcp设置

        power_on(obj);  %UR初始化，上电

        power_off(obj);   %UR断电

        pose = refresh_pose(obj);  %更新UR位置信息

        move_tcp(obj,offset) %相对于工具坐标系进行移动

        set_pose(obj,tgt_pose,path_type,axis_no_rotate); %移动到基坐标系中的指定位置（笛卡尔空间或者关节空间插值）

        stop(obj); %停止当前的UR运动

        function resume(obj,varargin)% 恢复被暂停的运动      
            obj.set_pose(obj.target_pose,varargin{:});
        end
    end
   
    methods  % set和get相关
        function pose = get.pose(obj)   %当查询status属性时,运行坐标刷新函数读取新的status
           pose = obj.refresh_pose;
        end

        function set.n_tcp(obj,n_tcp)      
           obj.n_tcp = n_tcp;
           set_active_tcp(obj);
        end

        function active_tcp = get.active_tcp(obj)
           active_tcp = obj.tcp_data(obj.n_tcp);
        end
        
        function set.tcp_data(obj,tcp_data) %每次重设tcp数据时刷新UR的tcp设置
           obj.tcp_data = tcp_data;
           set_active_tcp(obj);
        end
    end
   
end