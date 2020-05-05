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
% errorGradTaylorGreen(kfac,part,space)
% Evaluate the error of the G^+ of SPH for different wave functions
% We consider the harmonic pressure p(r) = sin(k(x-x0))+sin(k(y-y0))+ where k = 2\pi/\lambda
% and vary k
% returns a table of the error
function error = errorGradTaylorGreen(kfac,part,space)
global  rhoF  m h gamma B aW d
global  RHO POS SPID
k = kfac;
i = 193;
pos_i = part(i,POS);
part = initPressFuncTG(k,pos_i,part);
  
% Calculate the pressure gradient G^+ for the particule id = 193;
Gp = 0;
%GET NEIB LIST through the part spID
spID = part(i,SPID);
%we recover the space neib
listSpaces = space{2}{spID};
listNeib = [space{3}{listSpaces(:)}];
listNeib=listNeib(listNeib~=i);
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
%
GP_ij = -rho_i*PressureContrib(m,rho_i,rho_j,P_i,P_j,dwdr,er);
%
Gp =sum(GP_ij);

% Calculate the error 
Grad_p_i = k*[1 1];
error = norm(Gp-Grad_p_i)/norm(Grad_p_i);