function resume(obj,varargin)% 恢复被暂停的运动      
    obj.set_pose(obj.target_pose,varargin{:});
end