function power_off(obj)
%% UR�ϵ�
if strcmp(obj.s2.status,'open') % �ϵ�ǰ�ر�s2�˿�
    fclose(obj.s2);
end

if strcmp(obj.s1.status,'closed') % ���û�򿪶˿ڣ����֮
    fopen(obj.s1);
end
fprintf(obj.s1,'power off\n'); %���Ͷϵ�ָ��
fclose(obj.s1);

