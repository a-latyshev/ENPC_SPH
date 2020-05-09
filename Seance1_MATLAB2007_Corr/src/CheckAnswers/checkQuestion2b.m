function check  = checkQuestion2b(part1,part,FORCES)

if max(max(abs(part1-part)))< 10^(-13) && max(max(part1(:,FORCES(1))))>0
    comm = sprintf('2-b) seems good!');
    disp(comm);
      check=true;
else 
    comm = sprintf('2-b) There is an error... Check naiveShepard function');
    disp(comm);
      check=false;
end