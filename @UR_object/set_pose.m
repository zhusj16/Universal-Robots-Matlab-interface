function cmd = set_pose(obj,tgt_pose,path_type,axis_no_rotate)
%%   SET_pose 以指定方式移动到指定位置
%   tgt_pose: UR工具端在基坐标系中的目标位置 [x,y,z,ax,ay,az]  单位米!!!角度是弧度!!!               
%   path_type :'cart' 笛卡尔空间线性插值
%              'joint'关节空间线性插值
%   axis_no_rotate : 工具的轴线方向（tcp坐标系中），若指定了该方向，则运动过程中不绕该轴旋转

obj.target_pose = tgt_pose; %跟新UR对象的目标位置属性

if  (nargin==4) && (norm(axis_no_rotate)>0)
    axis_no_rotate = axis_no_rotate(:); %先转成列向量
    R_mez = obj.Rxyz2R(obj.pose(4:6)); %当前的姿态矩阵
    R_tgt = obj.Rxyz2R(tgt_pose(4:6)); %期望的姿态矩阵
    n_mez = R_mez*axis_no_rotate; %轴线方向在基坐标系中的当前位置
    n_tgt = R_tgt*axis_no_rotate; %轴线方向在基坐标系中的期望位置
    r_cross = cross(n_mez,n_tgt);
    r_mez2tgt = r_cross/norm(r_cross)*asin(norm(r_cross)); 
    %使轴线转到期望位置的最小转动的旋转矢量（与轴线垂直，即沿该轴线方向没有转动）
    tgt_pose(4:6) = obj.R2Rxyz((obj.Rxyz2R(r_mez2tgt)*R_mez)); %更新的目标位姿旋转矢量
end

if nargin==2
    path_type = 'joint';
end

if strcmp(obj.s2.status,'closed')  %如果没打开端口，则打开之
    fopen(obj.s2);
end

t=0;
r=0; % movej(q,    a=1.4, v=1.05, t=0, r=0)，默认t,r=0，优先级在a和v之前 

if  strcmp(path_type,'cart')
    cmd = sprintf('movel(p[%f,%f,%f,%f,%f,%f],%f,%f,%f,%f)\n',...
                 tgt_pose, obj.a_tool,  obj.v_tool,  t, r);
elseif strcmp(path_type,'joint')
    cmd = sprintf('movej(p[%f,%f,%f,%f,%f,%f],%f,%f,%f,%f)\n',...
                 tgt_pose, obj.a_joint, obj.v_joint, t, r);
end

%cmd
if nargout==0
    fprintf(obj.s2,cmd);
end
