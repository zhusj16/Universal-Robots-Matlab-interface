function freedrive_off(obj)
%% 关闭自由拖动模式
% obj: UR机器人对象


if strcmp(obj.s2.status,'closed')   %如果没打开端口，则打开之
    fopen(obj.s2);
end


cmd  = 'def endfreedrive():\n';
cmd  = strcat(cmd,'end\n');
fprintf(obj.s2,cmd);  
