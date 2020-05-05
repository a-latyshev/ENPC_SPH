%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               SPH LAB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Authors :  R. Carmigniani, A. Ghaitanellis, A. Leroy, T. Fonty  and D. Violeau
%Version : SPHLAB.0
%Date : Started on 28/09/2018
%Contact : remi.carmigniani@enpc.fr
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% THERE IS NO CHANGE TO MAKE IN THIS SECTION
clear all 
close all
clc
restoredefaultpath
addpath('src/solver','src/postprocess','src/kernel','src/Initialisation',...
            'src/DamBreakChansonSol','src/CheckAnswers')
global rhoF; %Fluid density
global dr m ;%Particle size and mass
global lspace;
global aW d h smthfc;
global FLUID BOUND NEIBREFRESH;%FLUID TYPES INFO
global INFO POS VEL RHO SPID FORCES;%PART ENTRIES
global xOrigin yOrigin xSize ySize;
global ARTVISC VISCTYPE VISCMORRIS VISCMONAGHAN;
global COLAGROSSIDIFF DENSDIFFTYPE delta;
global alpha eps;
global c0 B gamma mu dt rhoMin rhoMax shepardMin;
global g nBound;
global vecPer;
%Fluid information
g=[0 -9.81];
rhoF=1000;
rhoMin = 0.5*rhoF;
rhoMax = 1.5*rhoF;
shepardMin =10^-6;
dt = 1;
mu=10^-6;
%INFO FLAGS
FLUID = 0;
BOUND =1;
%CELL INFO
POS  = [1,2];
VEL  = [3,4];
RHO  = 5;
INFO = 6;
SPID = 7;
FORCES= [8,9,10]; %Fx Fy dDensity
%Particle smoothing factor
smthfc=1.5;
%Kernel parameters 
aW = 7/(4*pi);
d = 2;


% Visc models
%VISCOUS MODEL
ARTVISC = 0;
VISCMORRIS = 1;
VISCMONAGHAN = 2;
VISCTYPE = ARTVISC;
% Visc Parameters
% SEE BELOW
% Boundary parameters
nBound=4;
% Periodicity parameters
vecPer = [0 0]; %NO PERIODICITY
%recalcule la liste des voisins 
NEIBREFRESH=1;
% Density diffusion (PROJECT!!!)
% if we use defaut DENSDIFFTYPE = 0;
COLAGROSSIDIFF = 1;
DENSDIFFTYPE = 1;
%diff Parameters
delta = 0.2;
%% PART 4
% The goal of this part is to run our first SPH simulation! The test case
% is a dam break. We start by building the test case. Then we move to the
% time integration. In the previous part we implemented the pressure
% contribution to the momentum equation and the divergence of the velocity 
% contribution to the continuity equation.
% An artificial viscosity contribution is provided in the function 
% src/solver/ArtViscContrib.m. You will have to complete the simplectic 
% scheme only.
%% Construction of the test case. 
% A figure of the test case is shown in Figures/sketch.pdf. You have to use
% the functions createBox, createSpace to initialized the case. It
% corresponds to a block of water of dimension 0.5x1m (width, height), in a
% 3m long channel. 
%For the dry bed, we will use the dynamic particles with a flag BOUND
%instead of FLUID in createBox. There should be nBound particles in the
%boundary.
%
%
% Size of the water domain
lx = 0.5;
ly = 1;
%State Eq
%Umax = 1.2*sqrt(norm(g)*ly);
c0 = 40;%10*Umax;
gamma=7;
B = rhoF*c0^2/gamma;
% Size of the sea bed
Lx =2;
Ly =2;
% Particle size
dr = ly/20;
h = smthfc*dr;
%Artificial visc parameters
alpha = 0.1;
eps = 10^-6*dr^2;
m = dr^2*rhoF;
lspace = 2*h;
% Domain size
xSize  = Lx + 2*nBound*dr+1*dr; 
ySize =  Ly + 2*nBound*dr+1*dr;
%ORIGIN DOMAIN
xOrigin= -nBound*dr;
yOrigin=-nBound*dr;

part=[];
%% 4-a) Construct the domain
% COMPLETE HERE
% To add a block of particles use the command
% part =  createBox(part,x0,y0,lx,ly,dr,TYPE);
% where TYPE = FLUID OR BOUND
% as an example we give the fluid part
part =  createBox(part,0,0,lx,ly,dr,FLUID);
part =  createBox(part,-nBound*dr,-nBound*dr,Lx+2*nBound*dr,nBound*dr,dr,BOUND);
part =  createBox(part,-nBound*dr,0,nBound*dr,Ly,dr,BOUND);
part =  createBox(part,Lx,0,nBound*dr,Ly,dr,BOUND);
% END
space = createSpace(dr,smthfc,lspace,xOrigin,yOrigin,xSize,ySize);
plotParticlesPressure(part,'Pressure',0,rhoF*norm(g)*ly)

%% 4-b) Initialize the pressure/density
% Start by completing the function src/initialisation/pLaplaceNoDim.m
comm = sprintf('Calculate pressure at x= 0 and y=0 :');
disp(comm);
comm = sprintf('p(0,0)/rho g l_y =  %f ',pLaplaceNoDim(lx,ly,10,0,0));
disp(comm);
comm = sprintf('Expected result approx. 0.3701 with 10 modes');
disp(comm);
if not(checkQuestion4b())
    return;
end

part = initPressFuncDB(lx,ly,10,part);
[part,space] = sortPart(part,space,lspace,dr,xOrigin,yOrigin,xSize,ySize);
plotSpace(space,0)
plotParticlesPressure(part,'Pressure',0,rhoF*norm(g)*ly*pLaplaceNoDim(lx,ly,10,0,0)/2)
xlim([xOrigin-xSize*.05,xOrigin+xSize*1.05])
ylim([yOrigin-ySize*.05,yOrigin+ySize*1.05])

%%pour trouver la nombre du point interpolé au mur à la position x = 2 m et z = 0.2 m
[observe_point,~]=find(abs(part(:,POS(1))-2.0)<=dr/2);
[observe_point_0,~]=find(abs(part(observe_point,POS(2))-0.2)<=dr/2);
observe_point=observe_point(observe_point_0);

%% 4-c) Boundary pressure interpolation 
part = interpolateBoundary(part,space);
plotParticlesPressure(part,'Pressure',0,rhoF*norm(g)*ly)
xlim([xOrigin-xSize*.05,xOrigin+xSize*1.05])
ylim([yOrigin-ySize*.05,yOrigin+ySize*1.05])

%% 4-d) Time integration
% Here we show a single time step 
% To advance in time we will proceed as follow 
% STEP 0 : Check the CFL
dt = 0.1*CFLConditions(part);
% STEP 1 : Evaluate the Pressure at the wall particles and update rho_walls
part = interpolateBoundary(part,space);
% STEP 2 : Compute the forces and density contributions
part = computeForces(part,space);
% STEP 3 : Update the time
% COMPLETE HERE
part = integrationStep(part,dt);
% END
%% Create a folder for the results
folderName=strcat('Results/DamBreak_',datestr(clock,'yyyy_mm_dd-HHMM'));
mkdir(folderName)
mkdir(strcat(folderName,'/Data'))
mkdir(strcat(folderName,'/Images/velocity'))
mkdir(strcat(folderName,'/Images/pressure'))
createInitInfo(folderName,'Dam Break',[lx ly Lx],{'lx','ly','Lx'});
%% Load the experimental data
load('Validation_DamBreak/Data_Table_Martin_1952_n2_2.mat')
%This load four tables of experimental data dambiHT dambiZT with the data
% dambiZT column: Z/lx  t\sqrt(2g/lx)
% dambiHT column: H/ly  t\sqrt(g/lx)
% We will use this as a validation 
% Extract the maximum particle height :
Hmax = max(part(:,POS(2)).*(BOUND-part(:,INFO))/BOUND)+dr/2;
Xmax = max(part(:,POS(1)).*(BOUND-part(:,INFO))/BOUND)+dr/2;
THX=[];
t=0;
THX = [THX [t Hmax Xmax]'];
%% 
part0=part;
i=0;
count=0;
t0 = cputime;
DTPRINT=2/100*sqrt(ly/norm(g));
tprint=0;
close all
SAVEIM=1;%1save0notsave
SAVEMAT=0;%1save0notsave
EnergyMeca0=[0 1/2*m*(part0(:,VEL(1))'*part0(:,VEL(1))+part0(:,VEL(2))'*part0(:,VEL(2)))-m*g(2)*sum(part0(:,POS(2)))];
pressionX2Z02 = [];
t_em=0.00:0.001:1.5;
kk=1;
while t<1.51 %10
    t1s = cputime;
    text = sprintf('t : %f s',t);
    disp(text);
    
    %CHECK CFL CONDITIONS
    [dt,limitedby] = CFLConditions(part);
    text = sprintf(strcat('CFL condition,',limitedby,', : dt = %s s'),dt);
    disp(text);
    
    
    % INTERPOLATE BOUNDARY PARTICLES
    part = interpolateBoundary(part,space);
    t1e = cputime;
    text = sprintf('Boundary interpolation :  %f s',t1e-t1s);
    disp(text);
    
    %COMPUTE THE FORCES AND DENSITY
    part = computeForces(part,space);
    t1e = cputime;
    text = sprintf('Compute forces in :  %f s',t1e-t1s);
    disp(text);
    
    %INTEGRATION STEP STEP
    part = integrationStep(part,dt);
    text = sprintf('Integration: update velo, pos then rho');
    disp(text);
    EnergyMeca=1/2*m*(part(:,VEL(1))'*part(:,VEL(1))+part(:,VEL(2))'*part(:,VEL(2)))-m*g(2)*sum(part(:,POS(2)));
    
    %WRAPPING
    t1e = cputime;
    text = sprintf('Execution time : %f s',t1e-t1s);
    disp(text);
    text = sprintf('Simulation runing since : %f s',t1e-t0);
    disp(text);

    %REFRESH NEIB LIST
    if mod(i,NEIBREFRESH)==0
        t1s = cputime;
        text = sprintf('REFRESH NEIB LIST',t1e-t0);
        disp(text);
        [part,space] = sortPart(part,space,lspace,dr,xOrigin,yOrigin,xSize,ySize);
        t1e = cputime;
        text = sprintf('Time to refresh neiblist : %f s',t1e-t1s);
        disp(text);
    end
    %%%
    %UPDATE TIME
    t=t+dt;
    %SAVE TO FILES AND DISPLAY
    if t>=tprint
        t1s = cputime;
        text = sprintf('SAVE TIME',t1e-t0);
        disp(text);
%         fig1 = figure(1);
%         %Plot the velocity field
%         plotParticlesProperty_ABS_FIXEDBOUND(part,VEL,...
%                 0,1,t,'$\left|V\right|/\sqrt{g h}$',sqrt(norm(g)*ly));
%         title(['$t*(\frac{g}{H})^{1/2} $=  ',sprintf('%2.2f',t*sqrt(norm(g)/ly))],'Interpreter','latex' )
%         xlim([xOrigin-dr/2,xOrigin+xSize+dr/2])
%         ylim([yOrigin-dr/2,yOrigin+ySize+dr/2])
%         titleImage1=sprintf(strcat(folderName,'/Images/velocity/fig_%06i.png'),count);
%         drawnow
%         text =sprintf('saving at t = %f s',t);
%         disp(text);
%         textMat =sprintf(strcat(folderName,'/Data/data_%06i.mat'),count);
%         count=count+1;
%         tprint = tprint+DTPRINT;

        fig1 = figure(1);
        %Plot the pressure field
        plotParticlesPressure(part,'Pressure',0,rhoF*norm(g)*ly*pLaplaceNoDim(lx,ly,10,0,0)/.4);%
        title(['$t*(\frac{g}{H})^{1/2} $=  ',sprintf('%2.2f',t*sqrt(norm(g)/ly))],'Interpreter','latex' )
        xlim([xOrigin-dr/2,xOrigin+xSize+dr/2])
        ylim([yOrigin-dr/2,yOrigin+ySize+dr/2])
        titleImage1=sprintf(strcat(folderName,'/Images/pressure/fig_%06i.png'),count);
        drawnow
        text =sprintf('saving at t = %f s',t);
        disp(text);
        textMat =sprintf(strcat(folderName,'/Data/data_%06i.mat'),count);
        count=count+1;
        tprint = tprint+DTPRINT;
        
%         %save the mecanic energy/the pression x=2.0m z=0.2m
%         if kk<size(t_em,2)
%             if abs(t-t_em(kk))<1e-3
%                 EnergyMeca0 = [EnergyMeca0;t_em(kk) EnergyMeca];
%                 pressure = Pressure(part(observe_point,RHO),B,rhoF,gamma);
%                 pressionX2Z02 = [pressionX2Z02;t_em(kk) pressure];
%                 kk=kk+1;
%             end
%         end
        
%         % Extract the maximum particle height : 
%         Hmax = max(part(:,POS(2)).*(BOUND-part(:,INFO))/BOUND)+dr/2;
%         Xmax = max(part(:,POS(1)).*(BOUND-part(:,INFO))/BOUND)+dr/2;
%         THX = [THX [t Hmax Xmax]'];
%         fig2 = figure(2);
%         plot(damb2ZT(:,2),damb2ZT(:,1),'ks','MarkerFaceColor','k','MarkerSize',8)
%         hold on
%         plot(damb1ZT(:,2),damb1ZT(:,1),'bo','MarkerFaceColor','b','MarkerSize',8)
%         plot(THX(1,:)*sqrt(2*norm(g)/lx),THX(3,:)/lx,'-k','LineWidth',2)
%         
%         xlabel('$t\sqrt{2g/l_x}$','Interpreter','latex' )
%         ylabel('$x_{max}/l_x$','Interpreter','latex' )
%         legend('Exp. Martin&Moyce 1952, 1.125 in','Exp. Martin&Moyce 1952, 2.25 in','SPHLab','Location','northwest')
%         xlim([0 3.2])
%         ylim([1 4])
%         drawnow
%         hold off
%         titleImage2=sprintf(strcat(folderName,'/XT.png'),count);
%         fig3 = figure(3);
%         plot(damb2HT(:,2),damb2HT(:,1),'ks','MarkerFaceColor','k','MarkerSize',8)
%         hold on
%         plot(damb1HT(:,2),damb1HT(:,1),'bo','MarkerFaceColor','b','MarkerSize',8)
%         plot(THX(1,:)*sqrt(norm(g)/lx),THX(2,:)/ly,'-k','LineWidth',2)
%         xlabel('$t\sqrt{g/l_x}$','Interpreter','latex' )
%         ylabel('$H_{max}/l_y$','Interpreter','latex' )
%         legend('Exp. Martin&Moyce 1952, 1.125 in','Exp. Martin&Moyce 1952, 2.25 in','SPHLab','Location','northeast')
%         xlim([0 3.2/sqrt(2)])
%         ylim([0.4 1])
%         drawnow
%         hold off
%         titleImage3=sprintf(strcat(folderName,'/HT.png'),count);
        if SAVEIM
            print(fig1,titleImage1,'-dpng');
%             print(fig2,titleImage2,'-dpng');
%             print(fig3,titleImage3,'-dpng');
            if SAVEMAT
                save(textMat,'part','t');
            end
            t1e = cputime;
            text = sprintf('Time to save: %f s',t1e-t1s);
            disp(text);
        else
            t1e = cputime;
            text = sprintf('Time to display: %f s',t1e-t1s);
            disp(text);
        end
    end
 i=i+1;
end

% filenm = ['alpha00'    num2str(round(100*alpha))    '_delta0'    num2str(round(10*delta))];
% xlswrite(filenm,EnergyMeca0);%[folderName, filenm]
% 
% filenm = 'pressionX2Z02';
% xlswrite(filenm,pressionX2Z02);%[folderName, filenm]

% fig1 = figure(1);
% %Plot the pressure field
% plotParticlesPressure(part,'Pressure',0,rhoF*norm(g)*ly*pLaplaceNoDim(lx,ly,10,0,0)/.4);%
% title(['$t*(\frac{g}{H})^{1/2} $=  ',sprintf('%2.2f',t*sqrt(norm(g)/ly))],'Interpreter','latex' )
% xlim([xOrigin-dr/2,xOrigin+xSize+dr/2])
% ylim([yOrigin-dr/2,yOrigin+ySize+dr/2])
% titleImage1=sprintf(strcat(folderName,'/Images/pressure/fig_%06i.png'),count);
% drawnow
% text =sprintf('saving at t = %f s',t);
% disp(text);
% textMat =sprintf(strcat(folderName,'/Data/data_%06i.mat'),count);
% count=count+1;
% tprint = tprint+DTPRINT;

text = sprintf('SIMULATION IS OVER.');
disp(text);
                