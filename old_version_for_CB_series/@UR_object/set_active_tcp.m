function set_active_tcp(obj)
% --- ����tcpλ�ã�����λ�ã��غ������Ȳ���  
% n_tcp����ѡtcp_data�ı��

% ����scriptManual 3.4.5�õ�����ָ����ã�
% 1. set_payload(CoG) ���ø�������λ��[x,y,z] ��λ����
% 2. set_payload_mass(m) ���ø�����������λ��ǧ��
% 3. set_tcp��pose�� ����tcp ����ϵ, ��ʽ��UR��������ר�õ�pose����

%ע�⣬����Ҫ��30002�˿ڣ��������֮�����Ҫ��ʱ�������Ӱ������ִ�У�
%������tcp֮��ֻҪ����ʾ�����Ͻ���tcp����ҳ������ˢһ�£���ʾ�����н����ƶ�����ʱ��Ȼ���ճ�������͵�tcp������ִ�У�

% ��UR�����tcp_data�����ж�ȡtcp����
tcp_data = obj.active_tcp;

if strcmp(obj.s2.status,'closed')
    fopen(obj.s2);
end

% ���ø�������������λ��
cmd1 = sprintf('set_payload(%f,[%f,%f,%f])\n',tcp_data.mass,tcp_data.CoG);
fprintf(obj.s2,cmd1);
pause(0.1);

% ���ù�������ϵλ��
cmd2 = sprintf('set_tcp(p[%f,%f,%f,%f,%f,%f])\n',tcp_data.pose);
fprintf(obj.s2,cmd2);
pause(0.1);
    
    
    
    
