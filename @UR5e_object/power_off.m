function power_off(obj)
%% UR断电
if strcmp(obj.s2.status,'open') % 断电前关闭s2端口
    fclose(obj.s2);
end

if strcmp(obj.s1.status,'closed') % 如果没打开端口，则打开之
    fopen(obj.s1);
end
fprintf(obj.s1,'power off\n'); %发送断电指令
fclose(obj.s1);

