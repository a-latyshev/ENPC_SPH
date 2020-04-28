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
% errorDivMinus(kfac,part,space)
% Evaluate the error of the D^- of SPH for different wave functions
% We consider the harmonic velocity v(r) = [sin(k(x-x0)) sin(k(y-y0))]
% where k = 2\pi/\lambda
% and vary k
% returns a table of the error
function error = errorDivMinus(kfac,part,space)
global  rhoF  m h gamma B aW d
global  RHO POS SPID VEL

k = kfac;
i = 193;
pos_i = part(i,POS);
part = initVelField(k,pos_i,part);

Div = 0;
%GET NEIB LIST through the part spID
spID = part(i,SPID);
%we recover the space neib
listSpaces = space{2}{spID};
listNeib = [space{3}{listSpaces(:)}];
listNeib=listNeib(listNeib~=i);
% list vect relative positions
rPos = [part(i,POS(1))-part(listNeib,POS(1)) ...
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
% Calculate the error 
Div_i = k*2;
error = norm(Div-Div_i)/norm(Div_i);