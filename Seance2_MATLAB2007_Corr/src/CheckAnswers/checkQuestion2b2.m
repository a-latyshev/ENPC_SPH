function check = checkQuestion2b2(error)
if abs(error-0.1196)>0.001
    comm = sprintf('2-b) There is an error in your evaluation of grad(p)');
    disp(comm);
    check=false;
else
    comm = sprintf('2-b) Done with 2-b)');
    disp(comm);
    check=true;
end
