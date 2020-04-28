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
% Init the pressure field for the Dam Break (hydrostatic)
% [partNew] = initPressFuncDB(lx,ly,Nmax,part)
% lx :  width
% ly : height
% n  : number of modes
% part :  initial part
% return the part with updated density
function [partNew] = initPressFuncDB(lx,ly,Nmax,part)
global rhoF B gamma 
global RHO POS g INFO BOUND
partNew=part;
xtab = part(:,POS(1));
ytab = part(:,POS(2));
info = part(:,INFO);
ptab =  pLaplaceNoDim(lx,ly,Nmax,xtab,ytab);
ptab(info==BOUND) = 0;
ptab = ptab*rhoF*norm(g)*ly;
partNew(:,RHO)=Density(ptab,B,rhoF,gamma);