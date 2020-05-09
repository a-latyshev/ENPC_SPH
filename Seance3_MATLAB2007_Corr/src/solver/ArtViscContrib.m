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
% ArtViscContrib : Artificial viscosity contribution to the momentum equation
function F = ArtViscContrib(m,mu,rho_i,rho_j,dwdr,rVel,rPos,eps)
veldotpos = rVel(:,1).*rPos(:,1)+rVel(:,2).*rPos(:,2);
rNorm = sqrt((rPos(:,1).*rPos(:,1)+rPos(:,2).*rPos(:,2)));
mu(veldotpos>0) = 0; 
F = zeros(size(rVel));
F(:,1) =  m/rho_i*(mu./rho_j).*(veldotpos./(rNorm.^2+eps)).*dwdr.*rPos(:,1)./rNorm;
F(:,2) =  m/rho_i*(mu./rho_j).*(veldotpos./(rNorm.^2+eps)).*dwdr.*rPos(:,2)./rNorm;
