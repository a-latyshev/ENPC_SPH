function check = checkQuestion2a3(part)
global RHO
if abs(max(part(:,RHO))-1.001966563112612e+03)>0.0001*10^3
    comm = sprintf('2-a) There is an error with src/solver/Density.m');
    disp(comm);
    check=false;
else
    comm = sprintf('2-a) Done with 2-a)');
    disp(comm);
    check=true;
end
