function  tcp_data_init(obj)
%% TCP_SETUP
%% ֱ��ͨ��UR script����TCPλ�����������趨.
% UR������ʱ��ֵ������������Ϊ�޸ĸ�ֵҲ����
% ����scriptManual 3.4.5�õ�����ָ����ã�
% 1. set_payload(CoG) ���ø�������λ��[x,y,z] ��λ����
% 2. set_payload_mass(m) ���ø�����������λ��ǧ��
% 3. set_tcp��pose�� ����tcp ����ϵ, ��ʽ��UR��������ר�õ�pose����
% tcp_data����������mass,����λ��CoG,tcp������Ϣpose,�Լ���ͷֱ��

RR = R2Rxyz(Rxyz2R([0,0,2/3*pi])*Rxyz2R([pi/3,0,0]));

%% �հ�TCP,����Ĭ�������ֵ,����λ�ڱ궨�����ת���ڷ���������Ľ�����
tcp_data(1).mass = 0.5;   
tcp_data(1).CoG = [0,0,100]*1e-3;
tcp_data(1).pose = [0,0,206.5e-3,0,0,0];
tcp_data(1).w0 = 3.2;
tcp_data(1).str = '<1> �޹���/�궨��';

%% tcp2 ��������3.2����
tcp_data(2).mass = 0.5;    
tcp_data(2).CoG = [0,0,100]*1e-3;
l = -(53.45)*1e-3;
dl = -41e-3;
tcp_data(2).pose = [-(l+dl*cosd(30))*sind(120),(l+dl*cosd(30))*cosd(120),(242.42*1e-3-dl*sind(30)),RR];  %��x����ת60��
% tcp_data(2).pose = [-(l+dl*cosd(30))*sind(120),(l+dl*cosd(30))*cosd(120),(238*1e-3-dl*sind(30)),RR];  %��x����ת60��
tcp_data(2).w0 = 4.95;
tcp_data(2).str = '<2> 3.2mm������';

%% tcp3 ��������4.1����
tcp_data(3).mass = 0.5;    
tcp_data(3).CoG = [0,0,100]*1e-3;
l = -(53.45)*1e-3;
tcp_data(3).pose = [-l*sind(120),l*cosd(120),(242.42)*1e-3,RR];  %��x����ת60��
tcp_data(3).w0 = 7.5;
tcp_data(3).str = '<3> 4.1mm������';

%% tcp4 ��ͷ90�ȷ��ã��������Ϊl_drill
l_drill=76;
tcp_data(4).mass = 1.2;    
tcp_data(4).CoG = [0,0,100]*1e-3;
%����x����ת90�ȣ�����z����ת180��
% ang_tcp = R2Rxyz(Rxyz2R([0,0,pi])*Rxyz2R([pi/2,0,0]));
% tcp_data(4).pose = [1.24e-3,(165.14+l_drill)*1e-3,122.77e-3,ang_tcp];
tcp_data(4).pose = [0,-273.75e-3,128.36e-3,pi/2,0,0];

tcp_data(4).w0 = 4.0;
tcp_data(4).str = '<4> 90�����(��ͷƽ���ڷ�����)';

%% tcp5 ��ͷ0�ȷ��ã����100mm
l_drill=76;
tcp_data(5).mass = 1.5;
tcp_data(5).CoG = [-45,0,130]*1e-3;
tcp_data(5).pose = [-66.82e-3,-2.1e-3,(291.54+l_drill)*1e-3,0,0,pi/2];  %��z����ת90��
tcp_data(5).w0 = 4.0;
tcp_data(5).str = '<5> 0�����(��ͷ��ֱ�ڷ�����)';

%% tcp����д��UR����
obj.tcp_data = tcp_data;