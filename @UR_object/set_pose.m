function cmd = set_pose(obj,tgt_pose,path_type,axis_no_rotate)
%%   move the robot to the target pose defined in the robot base coordinate system
%   tgt_pose: [x,y,z,ax,ay,az] m and radius. target tcp pose in robot base coordinate system               
%   path_type :'cart' : generate trajactory in Cartesian sapce
%              'joint': generate trajactory in joint space
%   axis_no_rotate : axial direction of the tool (in tcp coordinate system)
%                    if specified, rotation along this axis will be
%                    cancelled.

if  (nargin==4) && (norm(axis_no_rotate)>0)
    axis_no_rotate = axis_no_rotate(:); % convert ot column vector
    R_mez = obj.Rxyz2R(obj.pose(4:6));  % current attitude matrix
    R_tgt = obj.Rxyz2R(tgt_pose(4:6));  % desired attitude matrix
    n_mez = R_mez*axis_no_rotate;       % current axial direction in robot base coordinate system
    n_tgt = R_tgt*axis_no_rotate;       % desired axial direction in robot base coordinate system
    r_cross = cross(n_mez,n_tgt);
    r_mez2tgt = r_cross/norm(r_cross)*asin(norm(r_cross)); 
    % minimal rotation from the current attitude to the desired attitude
    tgt_pose(4:6) = obj.R2Rxyz((obj.Rxyz2R(r_mez2tgt)*R_mez)); %refresh the modified target pose
end

obj.target_pose = tgt_pose; % refresh the target pose store in the UR_object

if nargin==2
    path_type = 'joint';
end

if strcmp(obj.s2.status,'closed')  % if the port is not open, then open it
    fopen(obj.s2);
end

t=0;
r=0; 

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
