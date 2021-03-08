function pose = refresh_pose(obj)
    %% ��30002�˿ڶ�ȡUR�����˵ĸ�����Ϣ
    %% ����readasync�����ȡԭʼ�Ķ�����״̬��Ϣ
    
% pose = [0,0,0,0,0,0]';    
    if strcmp(obj.s2.status,'closed')  %���û�򿪶˿ڣ����֮
        fopen(obj.s2);
        pause(0.1);
    end
    readasync(obj.s2);
    msg = fread(obj.s2);
    if  size(msg,1)<4
%         aa = msgbox('UR���Ӵ���,����������');
%         uiwait(aa);
        disp('UR���Ӵ���,����������');
        fclose(obj.s2);
        pose = obj.pose;  %����ֵ֮ǰҪ��pose��ֵ����Ȼ���᷵�ظ���Ա����
        return;
    end
    len = msg(3)*256+msg(4);
    if len ~= length(msg)
%         aa = msgbox('UR�������󣬽����¶���');
%         uiwait(aa); 
        disp('UR�������󣬽����¶���');
        pose = obj.pose;
        return;
    end

    %% ��ԭʼ������״̬��Ϣ����ȡ����Ȥ����Ϣ
    % �������ȡ"joint data"(type1)��"Cartesion Info"(type4)
    ct = 5; %��������ʼ��
    pose = zeros(6,1);
    while(ct<len)
        pkg_len = msg(ct+3)*256+msg(ct+4); %���ݰ�����
        pkg_type = msg(ct+5);
       if (pkg_type == 4)
            for i=1:1:6
                tmp = msg(ct+6+(i-1)*8:ct+13+(i-1)*8);
                tmp = dec2hex(tmp)';
                tmp = strcat(tmp(:)');
                pose(i) = hex2num(tmp);
            end
        end
        ct = ct+pkg_len;          
    end
   
