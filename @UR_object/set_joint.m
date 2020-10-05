function cmd = set_joint(obj,tgt_q)
%%  move the robot joints to the specified angles
%   tgt_q: [q1,q2,q3,q4,q5,q6], target joint angles in radius               

if strcmp(obj.s2.status,'closed')  % if the port is not open, then open it
    fopen(obj.s2);
end

t=0;
r=0; 

cmd = sprintf('movej([%f,%f,%f,%f,%f,%f],%f,%f,%f,%f)\n',...
             tgt_q, obj.a_joint, obj.v_joint, t, r);

if nargout==0
    fprintf(obj.s2,cmd);
end
