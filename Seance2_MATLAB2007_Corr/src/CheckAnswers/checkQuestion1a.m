function check = checkQuestion1a(aW,d,h)
if  FW(0,aW,d,h) == 0 && FW(0.25,aW,d,h)+0.466<0.001 && FW(0.5,aW,d,h) +0.587505551647817<0.0001
    comm = sprintf('1-a) seems good!');
    disp(comm);
    check=true;
else 
    comm = sprintf('1-a) There is an error...Check FW function');
    disp(comm);
    check=false;
end