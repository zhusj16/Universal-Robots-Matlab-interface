function LAN_init(obj,ip_UR)
%% ��ʼ������
if nargin > 1
   obj.ip_UR = ip_UR;
end    
rport1 = 29999;               %UR�����˶˿ںţ�29999Ϊdashboard�˿ڣ����Խ����ϵ磬����ƶ����ػ��Ȳ���
rport2 = 30002;               %30003Ϊʵʱ�˿ڣ�ˢ����125Hz��30001��30002�˿�ˢ����Ϊ10Hz 
obj.s1 = tcpip(obj.ip_UR,rport1);
obj.s2 = tcpip(obj.ip_UR,rport2);
obj.s2.ReadAsyncMode = 'manual';
obj.s2.Timeout = 0.0001;
obj.s2.InputBufferSize = 679;