function unlock(obj)
%% Unlock the robot from "protective stop"
% obj: handle of the UR_object
    if strcmp(obj.s1.status,'closed') % if the port is not open, then open it
        fopen(obj.s1);
        disp(fscanf(obj.s1));
    end
    disp(query(obj.s1,'unlock protective stop'));