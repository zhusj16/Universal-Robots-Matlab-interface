clc;
ip = "ursim";

for i=1:5
    h = UR_object(ip);
    h.power_on;
    p0 = h.pose;
    
    if h.freedrive_status~=0
        error("failed");
    end
    h.freedrive_on;pause(1);
    if h.freedrive_status~=1
        error("failed");
    end
    h.freedrive_off;pause(0.1);
    
    h.move_tcp([0.03,0,0,0,0,0]); pause(0.5)
    p1 = h.pose;
    
    if norm(p0-p1)<0.001
        error("failed");
    end
    
    h.power_off;
    
end

disp("测试成功！");