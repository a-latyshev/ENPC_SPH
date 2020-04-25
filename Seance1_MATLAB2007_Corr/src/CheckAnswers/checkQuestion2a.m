function check  = checkQuestion2a(maxShepard,minShepard)

if abs(maxShepard- 1.0012)<10^-4 && abs(minShepard-0.4712) <10^-4 
    comm = sprintf('2-a) seems good!');
    disp(comm);
     check=true;
else 
    comm = sprintf('2-a) There is an error... Check line 73');
    disp(comm);
    check=false;
end