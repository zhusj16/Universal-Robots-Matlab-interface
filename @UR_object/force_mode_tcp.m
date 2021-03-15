function cmd_out = force_mode_tcp(obj,varargin)
%% enable force mode
%   varargin = tare_trigger,DoF,wrench,cmd
%   arg1: tare_trigger:  1-zero the sensor before start  0-don't zero the sensor before start 
%   arg2: DoF: 6-by-1 boolean vector, 1-compliant dof, 0-rigid dof
%   arg3: wrench: 6-by-1 force/torque vector the tool apply to the
%         environment. The rigid dofs are automatically ignored.
%   arg4: cmd_motion: urscript moving commands, generated with moving 
%         functions like "move_tcp". 
%         If not specified, the robot just moves along the compliant dofs to
%         maintain the required force.
%         If specified, the robot moves according to "cmd_motion" while
%         regulating the required force.

damp = 0.005; %force follow damping factor
gain = 1;     %force follow feedback gain

tare_trigger = varargin{1};
DoF          = varargin{2};
wrench       = varargin{3};
if nargin==5
    cmd_motion = varargin{4};
else
    cmd_motion = [];
end

if tare_trigger == 1
    cmd_tare = 'zero_ftsensor()\n';
else
    cmd_tare = [];
end

arg_DoF = sprintf('[%d,%d,%d,%d,%d,%d]',DoF);
arg_wrench = sprintf('[%f,%f,%f,%f,%f,%f]',wrench);
lim = ones(6,1);
lim(DoF==1) = obj.v_tool;
arg_lim = sprintf('[%f,%f,%f,%f,%f,%f]',lim);

% The force mode reference coordinate system is fixed to the tcp coordinate frame.
cmd_fm = strcat('force_mode(get_actual_tcp_pose(),',...      
                 arg_DoF,',',arg_wrench,',2,',arg_lim,')\n'); 

cmd =            'def myProg():\n';
cmd = strcat(cmd,'\t',cmd_tare);
cmd = strcat(cmd,'\t','thread myThread():\n');
cmd = strcat(cmd,'\t\t','while (True):\n');
cmd = strcat(cmd,'\t\t\t','force_mode_set_damping(', num2str(damp), ')\n');  %set the damping factor
cmd = strcat(cmd,'\t\t\t','force_mode_set_gain_scaling(', num2str(gain),')\n'); %set the feedback gain
cmd = strcat(cmd,'\t\t\t', cmd_fm);                       %force control command
cmd = strcat(cmd,'\t\t\t','sync()\n');
cmd = strcat(cmd,'\t\t','end\n');
cmd = strcat(cmd,'\t','end\n');
cmd = strcat(cmd,'\t','thrd = run myThread()\n');
cmd = strcat(cmd,'\t',cmd_motion,'\n');        %motion control command
cmd = strcat(cmd,'\t','join thrd\n');
% cmd = strcat(cmd,'    sleep(2)\n'); 
cmd = strcat(cmd,'end\n');
cmd_out = sprintf(cmd);

if nargout==0
    fprintf(obj.s2,cmd_out);
end