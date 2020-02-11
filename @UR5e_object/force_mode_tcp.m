function cmd_out = force_mode_tcp(obj,varargin)
%% 启动UR的力控模式
%   varargin = tare_trigger,DoF,wrench,cmd
%   arg1: tare_trigger  =1 运行之前清零力传感器  =0 运行之前不清零
%   arg2: DoF: 6维布尔向量，1对应的自由度为柔性，0对应的为刚性
%   arg3: wrench: tcp向外界施加的6维力/力矩向量，DoF为0的自由度自动忽略
%   arg4: cmd_motion: urscript运动指令,可以通过move_tcp等命令自动生成
%                   若cmd缺省，则为力跟随，若未缺省，则在施加力的同时进行运动

damp = 0.005; %跟随阻尼  默认值0.005
gain = 1;     %跟随反馈增益  默认值1

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

cmd_fm = strcat('force_mode(get_actual_tcp_pose(),',...      %注意，力控的参考坐标系现在与工具端固联
                 arg_DoF,',',arg_wrench,',2,',arg_lim,')\n'); 

cmd =            'def myProg():\n';
cmd = strcat(cmd,'\t',cmd_tare);
cmd = strcat(cmd,'\t','thread myThread():\n');
cmd = strcat(cmd,'\t\t','while (True):\n');
cmd = strcat(cmd,'\t\t\t','force_mode_set_damping(', num2str(damp), ')\n');  %跟随阻尼  默认值0.005
cmd = strcat(cmd,'\t\t\t','force_mode_set_gain_scaling(', num2str(gain),')\n'); %跟随反馈增益  默认值1
cmd = strcat(cmd,'\t\t\t', cmd_fm);                       %力控命令
cmd = strcat(cmd,'\t\t\t','sync()\n');
cmd = strcat(cmd,'\t\t','end\n');
cmd = strcat(cmd,'\t','end\n');
cmd = strcat(cmd,'\t','thrd = run myThread()\n');
cmd = strcat(cmd,'\t',cmd_motion,'\n');        %用运动命令替换cmd4,参考move_tcp里面的的命令
cmd = strcat(cmd,'\t','join thrd\n');
% cmd = strcat(cmd,'    sleep(2)\n'); %用join thrd和sleep都可以
cmd = strcat(cmd,'end\n');
cmd_out = sprintf(cmd);

if nargout==0
    fprintf(obj.s2,cmd_out);
end