function freedrive_off(obj)
%% disable the freedrive mode
% obj: handle of the UR_object


if strcmp(obj.s2.status,'closed')   %open the port in case it is closed
    fopen(obj.s2);
end


cmd  = 'def endfreedrive():\n';
cmd  = strcat(cmd,'end\n');
fprintf(obj.s2,cmd);  
