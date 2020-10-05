function power_on(obj)
%% power on the robot and release the brake
% obj: handle of the UR_object

if strcmp(obj.s1.status,'closed') % if the port is not open, then open it
    fopen(obj.s1);
    disp(fscanf(obj.s1));
end

disp(query(obj.s1,'power on'));     
pause(4);
disp(query(obj.s1,'brake release'));  


obj.set_active_tcp; % The TCP setup comments are only available after the 
                    % robot is power on. So the tcp data should be sent again
                    % to make sure the previously specified tcp data will take effect 


