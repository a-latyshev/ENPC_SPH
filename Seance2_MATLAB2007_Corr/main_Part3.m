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
addpath('src/solver','src/postprocess','src/kernel','src/Initialisation','src/CheckAnswers')
global rhoF; %Fluid density
global dr m ;%Particle size and mass
global lspace;
global aW d h smthfc;
global FLUID BOUND;%FLUID TYPES INFO
global INFO POS VEL RHO SPID FORCES;%PART ENTRIES
global xOrigin yOrigin xSize ySize;
global c0 B gamma mu dt;
global g;
%Fluid information
g=[0 -9.81];
rhoF=1000;
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
smthfc=2;
%Kernel parameters
aW = 7/(4*pi);
d = 2;
%State Eq
c0 = 1;
gamma=7;
B = rhoF*c0^2/gamma;
%% PART 3
% Evaluation of the divergence. Compare the two methods
% Similarly to the last seance, we construct a simple example.
close all
part=[];
%We construct a box of fluids particles
dr=1/20;
h = smthfc*dr;
m = dr^2*rhoF;
lspace = 2*h;
xOrigin = 0; 
yOrigin = 0;
xSize = 1+0.4*lspace;
ySize = 1+0.4*lspace;
% Create particles, spaces and sort
part =  createBox(part,1,1,dr,FLUID);
space = createSpace(dr,smthfc,lspace,xOrigin,yOrigin,xSize,ySize);
[part,space] = sortPart(part,space,lspace,dr,xOrigin,yOrigin,xSize,ySize);
%% 3-a) Construct a fictuous velocity field
%    \vec{u}(x,y) = \sin(k*(x-x_0))\vec{e}_x+\sin(k*(y-y_0))\vec{e}_y 
sigma = sqrt(5/18)*h;
% We define k = 2\pi/\lambda
k = 0.5/sigma;
i = 193;
pos_i = part(i,POS);
%COMPLETE HERE
part = initVelField(k,pos_i,part);
%END
% Let's display the particles using the function provided in postProcess
fig = figure(1);
plotParticlesPropertyWithBound(part,RHO,'Density',0,2*rhoF);
plotParticlesVector(part,VEL,0.1);
plotParticlesOutline(part,i,'r')
plotParticlesNeib(part,space,i)
xlim([0 1])
ylim([0 1])
drawnow
titleImage=strcat('Figures','/VelImage.png');
print(fig,titleImage,'-dpng','-r0')
%
%% 3-b) Calculate the divergence D^- for the particule i = 193:
% recall 
%D^-_a\left\{ \vec{u}_b \right\} = 
% -\frac{1}{\rho_a} \sum_b (\vec{v}_a-\vec{v}_b)\dot\nabla w_{ab}
% In the function DivergenceContrib.m we compute : -\rho_a D^-_a
Div = 0;
%GET NEIB LIST through the part spID
spID = part(i,SPID);
%we recover the space neib
listSpaces = space{2}{spID};
listNeib = [space{3}{listSpaces(:)}];
listNeib=listNeib(listNeib~=i);%No self contribution
% list vect relative positions
rPos =[part(i,POS(1))-part(listNeib,POS(1)) ...
            part(i,POS(2))-part(listNeib,POS(2))];
rVel = [part(i,VEL(1))-part(listNeib,VEL(1)) ...
            part(i,VEL(2))-part(listNeib,VEL(2))];
rNorm = (rPos(:,1).*rPos(:,1)+rPos(:,2).*rPos(:,2)).^(.5);
q = rNorm/h;
er=[rPos(:,1)./rNorm rPos(:,2)./rNorm];
dwdr = FW(q,aW,d,h);
rho_i = part(i,RHO);

% COMPLETE src/solver/PressureContrib.m to compute -G_i{p_j}/rho_i 
Div_ij = -1/rho_i*DivergenceContrib(m,dwdr,rVel,rPos);
% END
Div = sum(Div_ij);
comm = sprintf('Calculated Div{v} = %f',Div);
disp(comm);
comm = sprintf('Expected value about  %2.3f',16.704);
disp(comm);

if not(checkQuestion3b1(Div))
    return;
end
% The exact result is:
%COMPLETE HERE
Div_i = k*2;
% END
% and calculate the relative error : 
error = norm(Div-Div_i)/norm(Div_i);
if not(checkQuestion3b2(error))
    return;
end
%% If you correctly answered the previous questions now we compute 
% the divergence for different values of k. 
% The figure obtained should be familiar.
error_tab = [];
for kfac = [0.001 0.005 0.1 0.2 0.5 1 1.1 1.2 1.5 2 3 4]
    error= errorDivMinus(kfac/sigma,part,space);
    error_tab=[error_tab [kfac error]'];
end
figure(2)
gcf.PaperUnits='inches';
gcf.PaperPosition = [0 0 5 4];
hold off
plot(error_tab(1,:),error_tab(2,:),'ko','markerFaceColor','k')
hold on
plot([0.001:0.1:5],1-FourrierW([0.001:0.1:5]*h/sigma),'k-')
plot([0.001:0.1:5],([0.001:0.1:5]).^2/2,'k--')
xlim([0,5])
ylim([0,1.1])
legend({'Numeric','Theory','$\left(\sigma k \right)^2/2$'},'Interpreter','latex','Location','southeast')
xlabel('$k \sigma$','Interpreter','latex','fontsize',18);
ylabel('$\left|\nabla\vec{v} - D^-_a\left\{\vec{v}_b\right\} \right|/\left|\nabla \vec{v} \right| $','Interpreter','latex','fontsize',18);
drawnow
titleImage=strcat('Figures','/error_DivergenceMinus.pdf');
print(figure(2),titleImage,'-dpdf','-r0')

                