function cmd = set_joint(obj,tgt_q)
%%   SET_JOINT 移动到指定关节角度
%   tgt_q: [q1,q2,q3,q4,q5,q6],目标关节角度（单位为弧度！！！）               

if strcmp(obj.s2.status,'closed')  %如果没打开端口，则打开之
    fopen(obj.s2);
end

t=0;
r=0; % movej(q,    a=1.4, v=1.05, t=0, r=0)，默认t,r=0，优先级在a和v之前 

cmd = sprintf('movej([%f,%f,%f,%f,%f,%f],%f,%f,%f,%f)\n',...
             tgt_q, obj.a_joint, obj.v_joint, t, r);

%cmd
if nargout==0
    fprintf(obj.s2,cmd);
end
