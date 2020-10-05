function freedrive_on(obj)
%% activate the freedrive mode/ teach mode
% obj: handle of the UR_object

if strcmp(obj.s2.status,'closed')   %open the port in case it is closed
    fopen(obj.s2);
end


cmd  = 'def freedrive():\n';
cmd  = strcat(cmd,'freedrive_mode()\n');
cmd  = strcat(cmd,'sleep(100)\n');
cmd  = strcat(cmd,'end\n');
fprintf(obj.s2,cmd);   

