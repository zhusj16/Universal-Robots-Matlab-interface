classdef UR_object < handle
    
    properties
        a_joint =  0.35; %�ؽڿռ���ٶ�����
        a_tool  =  0.1 ; %�ѿ����ռ���ٶ�����
        v_joint =  2;    %�ؽڿռ��ٶ�����
        v_tool  =  0.03; %�ѿ����ռ��ٶ�����
        ip_UR='192.168.1.111'     %����������Ĭ��ip
        tcp_data;      %tcp��Ϣ��������������tcpλ�ˣ�������ʼ��ֵ 
        n_tcp;         % ��ǰ�����tcp�ı��
        target_pose;   %tcp��Ŀ��λ��
    end
    
    properties  (SetAccess = private, GetAccess = public) 
        s1        %����������˿�1�������ϵ磬�ϵ磬�Ӵ��ƶ���
        s2        %����������˿�2�����������˶����TCP���ò����� 
        pose      %��ǰ��������̬
        active_tcp   %��ǰ���tcp����
    end 
   
    methods   
        function obj = UR_object(varargin)  %��������ɺ���
          % ����ΪUR��ip��ַ����ȱʡ������Ĭ�ϵ�ip��ִַ��
          % ��ʼ��LAN����
           LAN_init(obj,varargin{:});
          % ��ʼ��tcp_data
           tcp_data_init(obj);
          % Ĭ�ϼ���1��tcp_data
           obj.n_tcp = 1;
          % ��ʼ��target_pose
           obj.target_pose = obj.pose;
        end

        LAN_init(obj,varargin);  %��ʼ������˿ڲ���

        tcp_data_init(obj);  %����Ĭ�ϵ�tcp����

        set_active_tcp(obj); % ����ѡ����tcp����

        power_on(obj);  %UR��ʼ�����ϵ�

        power_off(obj);   %UR�ϵ�

        pose = refresh_pose(obj);  %����URλ����Ϣ

        move_tcp(obj,offset) %����ڹ�������ϵ�����ƶ�

        set_pose(obj,tgt_pose,path_type,axis_no_rotate); %�ƶ���������ϵ�е�ָ��λ�ã��ѿ����ռ���߹ؽڿռ��ֵ��

        stop(obj); %ֹͣ��ǰ��UR�˶�

        function resume(obj,varargin)% �ָ�����ͣ���˶�      
            obj.set_pose(obj.target_pose,varargin{:});
        end
    end
   
    methods  % set��get���
        function pose = get.pose(obj)   %����ѯstatus����ʱ,��������ˢ�º�����ȡ�µ�status
           pose = obj.refresh_pose;
        end

        function set.n_tcp(obj,n_tcp)      
           obj.n_tcp = n_tcp;
           set_active_tcp(obj);
        end

        function active_tcp = get.active_tcp(obj)
           active_tcp = obj.tcp_data(obj.n_tcp);
        end
        
        function set.tcp_data(obj,tcp_data) %ÿ������tcp����ʱˢ��UR��tcp����
           obj.tcp_data = tcp_data;
           set_active_tcp(obj);
        end
    end
   
end