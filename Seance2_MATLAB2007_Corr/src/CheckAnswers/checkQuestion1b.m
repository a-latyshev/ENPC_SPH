function check = checkQuestion1b(sigma,h)
if sigma-sqrt(5/18)*h ==0
    comm = sprintf('1-b) It is correct! sigma^2 = 5/18*h^2. Recall this result for the next question');
    disp(comm);
    check=true;
else
    comm = sprintf('1-b) Hum check your calculation...');
    disp(comm);
    check=false;
end
