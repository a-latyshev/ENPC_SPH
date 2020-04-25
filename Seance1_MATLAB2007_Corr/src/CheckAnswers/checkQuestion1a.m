function check = checkQuestion1a(aW,d,h)
if  W(0,aW,d,h) == 1 && W(0.5,aW,d,h) ==  0.6328125 && W(1.5,aW,d,h) == 0.015625
    comm = sprintf('1-a) seems good!');
    disp(comm);
    check=true;
else 
    comm = sprintf('1-a) There is an error...Check W function');
    disp(comm);
    check=false;
end