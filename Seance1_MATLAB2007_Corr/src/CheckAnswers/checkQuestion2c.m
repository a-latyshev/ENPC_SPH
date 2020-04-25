function check  = checkQuestion2c(part1,part2,FORCES)
if max(max(abs(part1-part2))) < 10^(-13) && max(max(part1(:,FORCES(1))))>0
    comm = sprintf('2-c) seems good!');
    disp(comm);
    check=true;
else 
    comm = sprintf('2-c) There is an error... Check naiveShepardVect');
    disp(comm);
    check=false;
end