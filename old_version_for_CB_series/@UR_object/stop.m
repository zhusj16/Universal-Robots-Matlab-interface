function stop(obj)
%% ֹͣ��ǰ�Ļ������˶� 
if strcmp(obj.s2.status,'closed')   %���û�򿪶˿ڣ����֮
    fopen(obj.s2);
end

cmd = sprintf('stopl(%f)\n',obj.a_tool);
fprintf(obj.s2,cmd);