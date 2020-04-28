function check = checkQuestion2b2(error)
global RHO
if abs(error-0.1196)> 0.01
    comm = sprintf('2-b) There is in your calculation of grap(p)...');
    disp(comm);
    check=false;
else
    comm = sprintf('2-b) Done with 2-b)');
    disp(comm);
    check=true;
end
