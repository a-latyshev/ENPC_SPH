function check = checkQuestion3b2(error)
if abs(error-0.1196)>0.001
    comm = sprintf('3-b) There is an error in your evaluation of div(v)');
    disp(comm);
    check=false;
else
    comm = sprintf('3-b) Done with 3-b)');
    disp(comm);
    check=true;
end
