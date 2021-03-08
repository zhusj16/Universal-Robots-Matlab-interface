function set_pose(obj,tgt_pose,path_type,axis_no_rotate)
%%   SET_pose ��ָ����ʽ�ƶ���ָ��λ��
%   tgt_pose: UR���߶��ڻ�����ϵ�е�Ŀ��λ�� [x,y,z,ax,ay,az]  ��λ��!!!�Ƕ��ǻ���!!!               
%   path_type :'cart' �ѿ����ռ����Բ�ֵ
%              'joint'�ؽڿռ����Բ�ֵ
%   axis_no_rotate : ���ߵ����߷���tcp����ϵ�У�����ָ���˸÷������˶������в��Ƹ�����ת

obj.target_pose = tgt_pose; %����UR�����Ŀ��λ������

if  (nargin==4) && (norm(axis_no_rotate)>0)
    axis_no_rotate = axis_no_rotate(:); %��ת��������
    R_mez = Rxyz2R(obj.pose(4:6)); %��ǰ����̬����
    R_tgt = Rxyz2R(tgt_pose(4:6)); %��������̬����
    n_mez = R_mez*axis_no_rotate; %���߷����ڻ�����ϵ�еĵ�ǰλ��
    n_tgt = R_tgt*axis_no_rotate; %���߷����ڻ�����ϵ�е�����λ��
    r_cross = cross(n_mez,n_tgt);
    r_mez2tgt = r_cross/norm(r_cross)*asin(norm(r_cross)); 
    %ʹ����ת������λ�õ���Сת������תʸ���������ߴ�ֱ�����ظ����߷���û��ת����
    tgt_pose(4:6) = R2Rxyz((Rxyz2R(r_mez2tgt)*R_mez)); %���µ�Ŀ��λ����תʸ��
end

if nargin==2
    path_type = 'joint';
end

if strcmp(obj.s2.status,'closed')  %���û�򿪶˿ڣ����֮
    fopen(obj.s2);
end

t=0;
r=0; % movej(q,    a=1.4, v=1.05, t=0, r=0)��Ĭ��t,r=0�����ȼ���a��v֮ǰ 

if  strcmp(path_type,'cart')
    cmd = sprintf('movel(p[%f,%f,%f,%f,%f,%f],%f,%f,%f,%f)\n',...
                 tgt_pose, obj.a_tool,  obj.v_tool,  t, r);
elseif strcmp(path_type,'joint')
    cmd = sprintf('movej(p[%f,%f,%f,%f,%f,%f],%f,%f,%f,%f)\n',...
                 tgt_pose, obj.a_joint, obj.v_joint, t, r);
end

%cmd
fprintf(obj.s2,cmd);
end