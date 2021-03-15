function stop(obj)
%% 停止当前的机器人运动 
if strcmp(obj.s2.status,'closed')   %如果没打开端口，则打开之
    fopen(obj.s2);
end

cmd = sprintf('stopl(%f)\n',obj.a_tool);
fprintf(obj.s2,cmd);