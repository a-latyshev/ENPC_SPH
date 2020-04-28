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
% ViscMorrisContrib : Visc contribution to the momentum equation
% Based on Morris, Fox \& Zhu ,
% Modeling Low Reynolds Number Incompressible Flows Using SPH,
% Journal of Computational Physics, 136, (1997)
function F = ViscMorrisContrib(m,mu,rho_i,rho_j,dwdr,rVel,rPos)
rNorm = sqrt(rPos(:,1).*rPos(:,1)+rPos(:,2).*rPos(:,2)); 
F = zeros(size(rVel));
% COMPLETE HERE
F(:,1) = 2*m*(mu./(rho_i*rho_j)).*dwdr./rNorm.*rVel(:,1);
F(:,2) = 2*m*(mu./(rho_i*rho_j)).*dwdr./rNorm.*rVel(:,2);
% END
