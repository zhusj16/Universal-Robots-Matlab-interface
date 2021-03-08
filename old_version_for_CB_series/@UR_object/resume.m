        function resume(obj,path_type,axis_no_rotate)
            % 恢复被暂停的运动
            obj.set_pose(obj.target_pose,path_type)
        end