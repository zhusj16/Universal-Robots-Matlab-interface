function power_on(obj)
%% 初始化机器人的网络连接参数
% obj: UR机器人对象

%% 上电，解除制动
fopen(obj.s1); 
fprintf(obj.s1,'power on\n');     
pause(4);
fprintf(obj.s1,'brake release\n');  
fclose(obj.s1);

