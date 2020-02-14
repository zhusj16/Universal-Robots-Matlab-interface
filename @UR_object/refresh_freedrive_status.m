function freedrive_status = refresh_freedrive_status(obj)
    %% read data from realtime interface 30001
    %% get the raw data from the tcpip server
    
%     if strcmp(obj.s3.status,'closed')  %if not opened, then open it
%         fopen(obj.s3);
%         pause(0.1);
%     end

    readasync(obj.s3);
    msg = fread(obj.s3);
    if  size(msg,1)<4
        warning('s3 connection error, reconnecting');
        fclose(obj.s3);
        LAN_init(obj,obj.ip_UR);
        freedrive_status = obj.freedrive_status;  
        return;
    end
    len = msg(3)*256+msg(4);
    if len ~= length(msg)
        warning('s3 data error, rereading');
        freedrive_status = obj.freedrive_status;
        return;
    end

    %% retrieve data from the received binary package
    ct = 5; %counter initialization
    while(ct<len)
        pkg_len = msg(ct+3)*256+msg(ct+4); %length of the package
        pkg_type = msg(ct+5);
        if (pkg_type == 0)
            freedrive_status = msg(ct+22);
            break;
        end
        ct = ct+pkg_len;          
    end


   
