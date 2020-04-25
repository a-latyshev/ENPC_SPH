function check = checkQuestion1b(aW1,aW2,aW3)
if abs(aW1 - 3/4)>0
    comm = sprintf('1-b) Hum... There is an issue with W... Please check W');
    disp(comm);
    check=false;
elseif eval(abs(aW1 - 3/4))==0 && eval(abs(aW2 - 7/(4*pi)))>0 
    comm = sprintf('1-b) W is correct, but something wrong with aW2...');
    disp(comm);
    comm = sprintf('Correct the 1-b i to continue...');
    disp(comm);
    check=false;
elseif eval(abs(aW1 - 3/4))==0 && eval(abs(aW2 - 7/(4*pi)))==0 && eval(abs(aW3 -21/(16*pi)))>0
    comm = sprintf('1-b) W is correct, and the result is good in 2D! but wrong in 3D...');
    disp(comm);
    comm = sprintf('Correct the 1-b ii to continue...');
    disp(comm);
    check=false;
elseif eval(abs(aW1 - 3/4))==0 && eval(abs(aW2 - 7/(4*pi)))==0 && eval(abs(aW3 -21/(16*pi))) == 0
    comm = sprintf('1-b) It is all good!');
    disp(comm);
    check=true;
    comm = sprintf('Part1 is done, go to part 2!' );
    disp(comm);
end
