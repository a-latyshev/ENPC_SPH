function check = checkQuestion2a1(sigma,h)
if sigma-sqrt(5/18)*h ==0
    check=true;
else
    comm = sprintf('2-a) sigma is not correct...');
    disp(comm);
    check=false;
end
