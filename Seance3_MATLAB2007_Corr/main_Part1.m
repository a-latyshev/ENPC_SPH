%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
global dr m shepardMin rhoMin rhoMax;%Particle size and mass
global lspace;
global aW d h smthfc;
global FLUID BOUND NEIBREFRESH;%FLUID TYPES INFO
global INFO POS VEL RHO SPID FORCES;%PART ENTRIES
global xOrigin yOrigin xSize ySize;
global ARTVISC VISCTYPE VISCMORRIS VISCMONAGHAN;
global DENSDIFFTYPE;
global alpha eps;
global c0 B gamma mu dt;
global g nBound;
global vecPer;
%INFO FLAGS
FLUID = 0;
BOUND = 1;
%CELL INFO
POS  = [1,2];
VEL  = [3,4];
RHO  = 5;
INFO = 6;
SPID = 7;
FORCES= [8,9,10]; %Fx Fy dDensity
%Particle smoothing factor
smthfc=2;
%Kernel parameters
aW = 7/(4*pi);
d = 2;

% Visc models
%VISCOUS MODEL
ARTVISC = 0;
VISCMORRIS = 1;
VISCMONAGHAN = 2;
VISCTYPE = VISCMORRIS;
% Visc Parameters
% SEE BELOW
% Boundary parameters
nBound=4;
% Periodicity parameters
vecPer = [0 0]; %NO PERIODICITY
%recalcule la liste des voisins 
NEIBREFRESH=1;
% Density diffusion (PROJECT!!!)
DENSDIFFTYPE = 0;
%% PART 1
% GOAL
%% Construction of the test case. 
% 
%Poiseuille Parameters
e  = 0.5;%half width in meters
U0 = 1; %characteristical velocity m/s
Re = 1; % Reynolds number
%Refinement
N=15; %Number of fluid particles
%Fluid information
rhoF=1000; %kg/m^3
dt = 1; %s
rhoMin = 0.5*rhoF;
rhoMax = 1.5*rhoF;
shepardMin =10^-6;


% PARTICLE SIZE AND SMTH FACTOR
dr = 2*e/(N+1);
lspace = 2*(smthfc)*dr;
h = smthfc*dr;

% PARTICLE MASS
m = rhoF*dr^2;

% STATE EQUATION
c0 = 10*U0;
gamma=7;
B = rhoF*c0^2/gamma;

% ORIGIN DOMAIN
xOrigin=0;
yOrigin=-e-nBound*dr;

%DOMAIN SIZE
xSize = 4*lspace;
ySize = 2*e+2*nBound*dr;
%ART DEFAULT
alpha=0.3;
eps=0;
% INIT PARTICLE TABLE
part=[];
%% 1-b) Evaluate mu and g
% VISCOSITY
% TO COMPLETE
mu = rhoF*U0*e/Re; %(Pa.s) such that the reynolds matches
% END
% GRAVITY
% TO COMPLETE
g=[1 0]*2*U0*mu/rhoF/(e^2);%m/s^2
% END
check = checkQuestion1b(g,mu);
%% 1-c) Construct the domain
part=[];
% COMPLETE HERE
part =  createBox(part,0,-e,4*lspace,2*e,dr,FLUID);
part =  createBox(part,0,-e-nBound*dr,4*lspace,nBound*dr,dr,BOUND);
part =  createBox(part,0,e,4*lspace,nBound*dr,dr,BOUND);
% END
check = checkQuestion1c(part,N);
%% 1-d) Periodicity and Spaces
% PERIODICITY VECTOR
vecPer = [4*lspace 0];
space = createSpace(dr,smthfc,lspace,xOrigin,yOrigin,xSize,ySize);
plotParticlesPressure(part,'Pressure',-1,1)
plotSpace(space,1)
[part,space] = sortPart(part,space,lspace,dr,xOrigin,yOrigin,xSize,ySize);
plotParticlesNeib(part,space,1)
xlim([xOrigin-xSize*.05,xOrigin+xSize*1.05]);
ylim([yOrigin-ySize*.05,yOrigin+ySize*1.05]);
%% 2-a) Complete the viscosity functions
% Go to ViscMonaghanContrib and ViscMorrisContrib
check = checkQuestion2a();
%% 2-b) Add the two methods to computeForces
% Go to computeForces and add the options VISCMONAGHAN and VISCMORRIS
%
%% Create a folder for the results
folderName=strcat('Results/Poiseuille_',datestr(clock,'yyyy_mm_dd-HHMM'));
mkdir(folderName)
mkdir(strcat(folderName,'/Data'))
mkdir(strcat(folderName,'/Images'))
createInitInfo(folderName,'Poiseuille',[e U0 Re norm(g)],{'e','U0','Re','g'});
titleImage=sprintf(strcat(folderName,'/PeriodicityNeibs.png'));
drawnow
print(figure(1),titleImage,'-dpng')
%% 
part0=part;
i=0;
count=0;
t0 = cputime;
DTPRINT=0.025*e^2*rhoF/mu;
tprint=0;
t=0;
SAVEDATA =0; %Set to 1 to save the data (but that slow down the code)
DISPPART =1; %Set to 1 to show the fluid parts(but that slow down the code)
SAVEFIG = 1;
while t<10
    t1s = cputime;
    text = sprintf('t : %f s',t);
    disp(text);
    
    %CHECK CFL CONDITIONS
    dt = CFLConditions(part);
    text = sprintf('CFL condition : dt = %s s',dt);
    disp(text);
    
    % INTERPOLATE BOUNDARY PARTICLES
    part = interpolateBoundary(part,space);
    t1e = cputime;
    text = sprintf('Boundary interpolation :  %f s',t1e-t1s);
    disp(text);
    
    %COMPUTE THE FORCES
    part = computeForces(part,space);
    t1e = cputime;
    text = sprintf('Compute forces in :  %f s',t1e-t1s);
    disp(text);
    
    %INTEGRATION STEP
    part = integrationStep(part,dt);
    text = sprintf('Integration Step : update velo, pos and rho');
    disp(text);
    
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
        text = sprintf('SAVE TIME');
        disp(text);
        %%FIGURE DISPLAY
        fig3 = figure(3);
        gcf.PaperUnits='inches';
        gcf.PaperPosition = [0 0 5 4];
        hold off
        plot(part(:,POS(2))/e,part(:,VEL(1))/U0,'bo')
        hold on
        plot(part(:,POS(2))/e,part(:,VEL(2))/U0,'ro')
        plot([-1:1/100:1],(1-([-e:e/100:e]/e).^2),'--k')
        tau = 2*e/U0;
        uan = analyticalPoiseuilleFlow([-1:1/100:1],Re,t/tau);
        plot([-1:1/100:1],uan,'--r')
        legend('U_x SPH','U_y SPH','Asymptotic','Analytical');
        plot([-1 -1],[-1 2],'-.k')
        plot([1 1],[-1 2],'-.k')
        xlim([-1-nBound*dr/e 1+nBound*dr/e])
        ylim([-0.2,1.2])
        xlabel('$z/e$','Interpreter','latex','fontsize',18);
        ylabel('$u/U_0$','Interpreter','latex','fontsize',18);
        %set(gca,'TickLabelInterpreter','latex','fontsize',18);
        drawnow
        if SAVEFIG
            titleImage=sprintf(strcat(folderName,'/Images/UV_%06i.png'),count);
            print(fig3,titleImage,'-dpng')
        end
        %%FIGURE DISPLAY
        fig2=figure(2);
        gcf.PaperUnits='inches';
        gcf.PaperPosition = [0 0 5 4];
        hold on
        plot([t*mu/rhoF/e^2],max(part(:,VEL(1))/U0),'b.')
        plot(0:1/10:5,analyticalPoiseuilleFlow(0,Re,[0:1/10:5]*rhoF/mu*e^2/tau),'--r')
        legend('SPH','Analytical','Location','southeast')
        xlim([0 3])
        ylim([0 1.2])
        xlabel('$t\nu/e^2$','Interpreter','latex','fontsize',18);
        ylabel('$u_{max}/U_0$','Interpreter','latex','fontsize',18);
        %set(gca,'TickLabelInterpreter','latex','fontsize',18);
        drawnow
        if SAVEFIG 
            titleImage=sprintf(strcat(folderName,'/Images/VelMaxDT.png'),count);
            print(fig2,titleImage,'-dpng')
        end
        %
        if DISPPART
            fig1=figure(1);
            plotParticlesProperty_ABS_FIXEDBOUND(part,VEL,...
                0,1,t,'$u/U_0$',1);
            title(['$t\nu/e^2 $=  ',sprintf('%2.2f',t*mu/rhoF/e^2)],'Interpreter','latex' )
            xlim([xOrigin-dr/2,xOrigin+xSize+dr/2])
            ylim([yOrigin-dr/2,yOrigin+ySize+dr/2])
            daspect([1,1,1])
            titleImage=sprintf(strcat(folderName,'/Images/fig_%06i.png'),count);
            drawnow
            if SAVEFIG
            print(fig1,titleImage,'-dpng')
            end
        end
        % SAVING TO FILE
        if SAVEDATA
            text =sprintf('t = %f s',t);
            disp(text);
            text =sprintf(strcat(folderName,'/Data/data_%06i.mat'),count);
            save(text,'part','t');
            t1e = cputime;
            text = sprintf('Time to save: %f s',t1e-t1s);
            disp(text);
        end
        tprint=tprint+DTPRINT;
        count=count+1;
    end
 i=i+1;
end

text = sprintf('SIMULATION IS OVER.');
disp(text);