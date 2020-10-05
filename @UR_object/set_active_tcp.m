function set_active_tcp(obj)
% Send the tcp configuration to the robot  
% n_tcp: the selected configuration number

% must use port 30002, a small delay is needed for the robot to take the commands. 
% warning: if you use the teach pendant to set the tcp data and also set
% the data throug remote pc at the same time, the result is undetermined.

% read the active tcp configuration from the UR_object.
tcp_data = obj.active_tcp;

if strcmp(obj.s2.status,'closed') % if the port is not open, then open it
    fopen(obj.s2);
end

% set the mass and center of gravity of the payload
cmd1 = sprintf('set_payload(%f,[%f,%f,%f])\n',tcp_data.mass,tcp_data.CoG);
fprintf(obj.s2,cmd1);
pause(0.02);

% set the tcp coordinate system
cmd2 = sprintf('set_tcp(p[%f,%f,%f,%f,%f,%f])\n',tcp_data.pose);
fprintf(obj.s2,cmd2);
pause(0.02);
    
    
    
    
