function power_off(obj)
%% power off the robot
% obj: handle of the UR_object

if strcmp(obj.s1.status,'closed') % if the port is not open, then open it
    fopen(obj.s1);
    disp(fscanf(obj.s1));
end

disp(query(obj.s1,'power off'));  % sent the power off command and receive message from the robot

