function check = checkQuestion2a2()
global B rhoF gamma
pTest = [79.9799405907147,3.60965611178922,109.878304288508,124.045927324001,83.3678949245451,95.3469960229151,93.0920390049891,44.1517838498088,79.9414716766020,18.0233320957964];
rhoTest =[1.06557406991566,1.00357116785742,1.08491293058688,1.09339932477576,1.06787351548578,1.07577401305783,1.07431324681249,1.03922270195342,1.06554778901776,1.01711866878116]*10^3;
if sum(abs(pTest- Pressure(rhoTest,B,rhoF,gamma)))+sum(abs(rhoTest- Density(pTest,B,rhoF,gamma)))<10^-3
    check=true;
    comm = sprintf('2-a) State equations are correct.');
    disp(comm);
else
    comm = sprintf('2-a) Error in Pressure.m and/or Density.m');
    disp(comm);
    check=false;
end
