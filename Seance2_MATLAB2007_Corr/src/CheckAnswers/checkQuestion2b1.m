function check = checkQuestion2b1(GP)
if abs(GP(1)-8.352133868551928)+abs(GP(2)-8.352133868551928)>0.0001
    comm = sprintf('2-b) There is an error with src/solver/PressureContrib.m');
    disp(comm);
    check=false;
else
    comm = sprintf('2-b) G_i{p_j} is correct. Evaluate the error now.');
    disp(comm);
    check=true;
end
