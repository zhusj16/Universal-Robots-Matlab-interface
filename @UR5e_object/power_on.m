function power_on(obj)
%% UR上电，解除制动
% obj: UR机器人对象
fopen(obj.s1); 
fprintf(obj.s1,'power on\n');     
pause(4);
fprintf(obj.s1,'brake release\n');  
fclose(obj.s1);

