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
% CFLConditions : 
% Evaluate the CFL and say what limits the time
function [dt,text] = CFLConditions(part)
global VEL;
global c0 h;
global g;
global rhoF mu;
CFL=0.1;
vmax = max(sqrt(part(:,VEL(1)).*part(:,VEL(1))+part(:,VEL(2)).*part(:,VEL(2))));
dt = CFL*h/(c0+vmax);
text='SOUND SPEED';
if dt>CFL*sqrt(h/norm(g))
    dt = CFL*sqrt(h/norm(g));
    text='BODY FORCES';
elseif dt>CFL*0.5*rhoF*h^2/mu
    dt =CFL*0.5*rhoF*h^2/mu;
    text='VISCOUS FORCES';
end

