function power_on(obj)
%% UR上电，解除制动
% obj: UR机器人对象
% fopen(obj.s1); 
disp(query(obj.s1,'power on'));     
pause(4);
disp(query(obj.s1,'brake release'));  
% fclose(obj.s1);

obj.set_active_tcp; %TCP设置命令仅在上电后才有效。上电后自动刷新TCP


