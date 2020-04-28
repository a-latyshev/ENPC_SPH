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
% Init the pressure field Taylo Green
function [partNew] = initPressFuncTG(k,pos_0,part)
global rhoF B gamma 
global RHO POS
partNew = part;
x_i = partNew(:,POS(1));
z_i = partNew(:,POS(2));
x_0 = pos_0(1);
z_0 = pos_0(2);
% Taylor green pressure
p_i = sin(k*(x_i-x_0))+sin(k*(z_i-z_0));
%
%rho_i = zeros(size(p_i));
%
% COMPLETE HERE
rho_i = Density(p_i,B,rhoF,gamma);
% END
% Comment the line : rho_i = zeros(size(p_i)) once done
%
%
partNew(:,RHO) = rho_i;
