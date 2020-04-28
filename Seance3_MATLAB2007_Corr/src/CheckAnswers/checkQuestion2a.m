function check = checkQuestion2a()
m=1;
mu=1;
rho_i=1000;
rho_j=[1000 1001 1003]';
dwdr=[1,2,3]';
rVel = [0 1;0.5 0.2;0.1 0.23];
rPos = [0.04 0.04;1 1;0.2 0.24];

FMor = ViscMorrisContrib(m,mu,rho_i,rho_j,dwdr,rVel,rPos);
FMorExp=[0,3.53553390593274e-05;1.41280076161148e-06,5.65120304644594e-07;1.91480877267541e-06,4.40406017715345e-06];

FMon = ViscMonaghanContrib(m,mu,rho_i,rho_j,dwdr,rVel,rPos);
FMonExp=[7.07106781186548e-05,7.07106781186548e-05;3.95584213251215e-06,3.95584213251215e-06;1.18027557135403e-05,1.41633068562483e-05];

if norm(FMor-FMorExp)<10^-10
    comm = sprintf('Morris is correctly implemented!');
    disp(comm);
    check1=true;
else
    comm = sprintf('Error in Morris...');
    disp(comm);
    check1=false;
end
if norm(FMon-FMonExp)<10^-10
    comm = sprintf('Monaghan is correctly implemented!');
    disp(comm);
    check2=true;
else
    comm = sprintf('Error in Monaghan...');
    disp(comm);
    check2=false;
end
if check1 && check2
    comm = sprintf('2-a) All good!');
    disp(comm);
    check=true;
else
    comm = sprintf('2-a) There is still an error...');
    disp(comm);
    check=false;
end