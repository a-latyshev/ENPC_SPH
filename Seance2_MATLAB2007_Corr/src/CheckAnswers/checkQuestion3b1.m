function check = checkQuestion3b1(Div)
if abs(Div-16.7041)>0.0001
    comm = sprintf('3-b) There is an error with src/solver/DivergenceContrib.m');
    disp(comm);
    check=false;
else
    comm = sprintf('3-b) Div is correct. Evaluate the error now.');
    disp(comm);
    check=true;
end
