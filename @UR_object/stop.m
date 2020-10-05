function cmd = stop(obj)
%% stop the robot movement 
if strcmp(obj.s2.status,'closed')   %open the port in case it is closed
    fopen(obj.s2);
end

cmd = sprintf('stopl(%f)\n',3*obj.a_tool);

if nargout==0
    fprintf(obj.s2,cmd);
end