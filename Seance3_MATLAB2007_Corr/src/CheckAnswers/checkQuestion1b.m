function check = checkQuestion1b(g,mu)
comm = sprintf('You evaluated:');
disp(comm);
comm = sprintf('mu = %2.2f',mu);
disp(comm);
comm = sprintf('g = [%2.2f %2.2f]',g(1),g(2));
disp(comm);
if  mu==500 && g(1)==4
    comm = sprintf('1-a) All good!');
    disp(comm);
    check=true;
else 
    comm = sprintf('1-a) There is an error...');
    disp(comm);
    check=false;
end