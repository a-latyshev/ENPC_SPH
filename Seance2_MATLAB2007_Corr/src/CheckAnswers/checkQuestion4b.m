function check = checkQuestion4b()
load('src/CheckAnswers/checkLap.mat')
errorVal = norm(checkres - pLaplaceNoDim(2,4,10,x,y));
comm = sprintf('4-b) Evaluate error on a test case of 100x100 positions');
disp(comm);
comm = sprintf('Error found %f ',errorVal);
disp(comm);
if errorVal > 10^-7
    comm = sprintf('Check your maths... FAILED');
    disp(comm);
    check=false;
else
    comm = sprintf('Test Passed!');
    disp(comm);
    check=true;
end
