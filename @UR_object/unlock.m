function unlock(obj)
%% 解除保护性停止
% obj: UR机器人对象
    fopen(obj.s1); 
    fprintf(obj.s1,'unlock protective stop');
    fclose(obj.s1);