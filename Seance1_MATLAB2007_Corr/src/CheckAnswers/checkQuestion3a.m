function check = checkQuestion3a(count)

if count == 48
    comm = sprintf('3-a) All good!');
    disp(comm);
    check=true;
else
    comm = sprintf('3-a) There is an error. Go to line 61. Check that you do not count the particle itself too...');
    disp(comm);
    check=false;
end