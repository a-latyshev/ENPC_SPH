%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               SPH LAB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Authors :  R. Carmigniani, A. Ghaitanellis, A. Leroy, T. Fonty and D. Violeau
%Version : SPHLAB.0
%Date : Started on 28/09/2018
%Contact : remi.carmigniani@enpc.fr
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% createInitInfo(folder,caseName,physParVal,physParName)
% Generate an info file with important parameters
function createInitInfo(folder,caseName,physParVal,physParName)
%% Definitions 
global dr smthfc;
global lspace nBound;
global aW d h;
global g;
global dV0 rhoF rhoMin rhoMax m mu;
global dt;
global FLUID BOUND;
global INFO POS VEL RHO SPID FORCES NEIBREFRESH;
global c0 B gamma;
global ARTVISC VISCMORRIS VISCTYPE DENSDIFFTYPE;
global alpha eps;
global t;
global xOrigin yOrigin;
global xSize   ySize;
global vecPer;
%%
fileID = fopen(strcat(folder,'/info.txt'),'w');
fprintf(fileID, strcat(caseName,'\n\n'));
fprintf(fileID, 'Case Parameters\n');
for i =1:size(physParVal,2)
    fprintf(fileID, strcat(physParName{i},...
                    ' = %f \n'),physParVal(i));
end
%%
fprintf(fileID, '\nSimulation Parameters\n');
fprintf(fileID, 'dr = %f \n',dr);
fprintf(fileID, 'smthfc = %f \n',smthfc);
fprintf(fileID, 'nBound = %i \n',nBound);
fprintf(fileID, 'Refresh neiblist every %i iteration(s) \n',NEIBREFRESH);

fprintf(fileID, '\nFluid Parameters\n');
fprintf(fileID, '\t rhoF = %i \n',rhoF);
fprintf(fileID, '\t mu = %i \n',mu);
fprintf(fileID, '\t c_0 = %i \n',c0);
fprintf(fileID, '\t gamma = %i \n',gamma);

fprintf(fileID, '\nSimiluation Spec.\n');
fprintf(fileID, '\t rhoMin = %i \n',rhoMin);
fprintf(fileID, '\t rhoMax = %i \n',rhoMax);

fprintf(fileID, '\nViscous Model\n');
if VISCTYPE ==VISCMORRIS
    fprintf(fileID, 'Morris viscous model\n');
elseif VISCTYPE ==ARTVISC
    fprintf(fileID, 'Artificial viscosity model\n');
    fprintf(fileID, '\t alpha = %i \n',alpha);
    fprintf(fileID, '\t eps = %i \n',eps);
else
    fprintf(fileID, 'WARNING viscosity model not defined\n');
end

fprintf(fileID, '\n Density Diffusion Model\n');
fprintf(fileID, 'NONE\n');

if norm(vecPer)>0
fprintf(fileID, '\nPeriodic case\n');
end


fprintf(fileID, '\nFormat of data file\n');
fprintf(fileID, 'POS (x,y) : %i %i\n',POS(1),POS(2));
fprintf(fileID, 'VEL (x,y) : %i %i\n',VEL(1),VEL(2));
fprintf(fileID, 'RHO : %i\n',RHO);
fprintf(fileID, 'SPID : %i\n',SPID);
fprintf(fileID, 'FORCES (Fx,Fy,dRho/dt) : %i %i %i\n',...
                                FORCES(1),FORCES(2),FORCES(3));
fprintf(fileID, 'INFO : %i\n',INFO);









