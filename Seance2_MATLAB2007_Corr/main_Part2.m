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
%% PART 2
% Evaluation of the pressure gradient
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
%% 2-a) Construct an harmonic pressure field of the form :
%               p(x,y) = sin(k*(x-x_0)) + sin(k*(y-y_0)) 
% typical of the Taylor Green Vorticies. 
%COMPLETE HERE
sigma = sqrt(5/18)*h; %MODIFY the 1 for the correct value
%END
if not(checkQuestion2a1(sigma,h))
    return;
end
%% 
% In WCSPH, we model polytropic gases. This enables to link the pressure
% and density through a state equation.
% We define : B = \frac{\rho_0c_0^2}{\gamma} (see line 49) 
% COMPLETE HERE
p = Pressure(rhoF*1.01,B,rhoF,gamma);
% END
% COMPLETE HERE
rho = Density(p,B,rhoF,gamma);
% END
comm = sprintf('We calculate p(1.01*rhoF) = %f Pa',p);
disp(comm);
comm = sprintf('We calculate rho(p) = %f kg/m^3',rho);
disp(comm);
if not(checkQuestion2a2())
    return;
end
%%
k = 0.5/sigma;
i = 193;
pos_i = part(i,POS);
% COMPLETE HERE
part = initPressFuncTG(k,pos_i,part);
% END
if not(checkQuestion2a3(part))
    return;
end
% Let's display the particles using the function provided in postProcess
rhomin = Density(-2,B,rhoF,gamma);
rhomax = Density(2,B,rhoF,gamma);
fig = figure(1);
plotParticlesPropertyWithBound(part,RHO,'Density',rhomin,rhomax);
plotParticlesOutline(part,i,'r')
plotParticlesNeib(part,space,i)
xlim([0 1])
ylim([0 1])
drawnow
titleImage=strcat('Figures','/PressureImage.png');
print(fig,titleImage,'-dpng','-r0')
%
%% 2-b) Calculate the pressure gradient G^+ for the particule i = 193;
%
Gp = 0;
%GET NEIB LIST through the part spID
spID = part(i,SPID);
%we recover the space neib
listSpaces = space{2}{spID};
listNeib = [space{3}{listSpaces(:)}];
listNeib=listNeib(listNeib~=i); %No self contribution

% list vect relative positions
rPos = [part(i,POS(1))-part(listNeib,POS(1)) ...
            part(i,POS(2))-part(listNeib,POS(2))];
rNorm = (rPos(:,1).*rPos(:,1)+rPos(:,2).*rPos(:,2)).^(.5);
q = rNorm/h;
er=[rPos(:,1)./rNorm rPos(:,2)./rNorm];
dwdr = FW(q,aW,d,h);
%PRESSURE CONTRIBUTION
rho_i = part(i,RHO);
rho_j = part(listNeib,RHO);
P_i = Pressure(rho_i,B,rhoF,gamma);
P_j = Pressure(rho_j,B,rhoF,gamma);
GP_ij = zeros(size(er));
% COMPLETE src/solver/PressureContrib.m to compute -G_i{p_j}/rho_i 
GP_ij = -rho_i*PressureContrib(m,rho_i,rho_j,P_i,P_j,dwdr,er);
% END
Gp =sum(GP_ij);
comm = sprintf('Calculated G{p} = [%f %f]',Gp(1),Gp(2));
disp(comm);
comm = sprintf('Expected value about  [%2.3f %2.3f]',8.352,8.352);
disp(comm);

if not(checkQuestion2b1(Gp))
    return;
end

% let's calculate the error. For this compute the real gradient of p  at
% x_0 and y_0 : 
%                 p(x,y) = sin(k*(x-x_0)) + sin(k*(y-y_0)) 
% COMPLETE HERE
% Grad_p_i = [0 0];%???
Grad_p_i = k*[1 1];
% END
% and calculate the relative error : 
error = norm(Gp-Grad_p_i)/norm(Grad_p_i);
if not(checkQuestion2b2(error))
    return;
end

%% To finish we now evaluate the error for different k values :
% The figure obtained should be familiar.
error_tab = [];
for kfac = [0.001 0.005 0.1 0.2 0.5 1 1.1 1.2 1.5 2 3 4]
    error= errorGradTaylorGreen(kfac/sigma,part,space);
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
ylabel('$\left|\nabla p - G_a\left\{p_b\right\} \right|/\left|\nabla p \right| $','Interpreter','latex','fontsize',18);
drawnow
titleImage=strcat('Figures','/error_PressureGradient.pdf');
print(figure(2),titleImage,'-dpdf','-r0')
                