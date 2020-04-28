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
% DivergenceContrib
function F = DivergenceContribMolteniColagrossi(m,dwdr,rVel,rPos, nu, rho_i, rho_j)
rNorm = (rPos(:,1).*rPos(:,1)+rPos(:,2).*rPos(:,2)).^(.5);
veldotpos = rVel(:,1).*rPos(:,1)+rVel(:,2).*rPos(:,2);
%F = zeros(size(dwdr));
% COMPLETE HERE
F = m*veldotpos.*dwdr./rNorm + nu * 2*m*(rho_i - rho_j)./rho_j.*dwdr./rNorm;
%END


% ViscMonaghanContrib : Visc contribution to the momentum equation
% Based on Monaghan \& Gingold, 
% Shock Simulation by the Particle Method SPH, 
% Journal of Computational Physics, 52, (1983)
% function F = ViscMonaghanContrib(m,mu,rho_i,rho_j,dwdr,rVel,rPos)
%     veldotpos = rVel(:,1).*rPos(:,1)+rVel(:,2).*rPos(:,2);
%     rNorm = sqrt(rPos(:,1).*rPos(:,1)+rPos(:,2).*rPos(:,2));
%     F = zeros(size(rVel));
%     % COMPLETE HERE
%     F(:,1) = 2*(2+2)*m*mu./rho_i./rho_j.*veldotpos./rNorm.^2.*dwdr.*rPos(:,1)./rNorm;
%     F(:,2) = 2*(2+2)*m*mu./rho_i./rho_j.*veldotpos./rNorm.^2.*dwdr.*rPos(:,2)./rNorm;
%     % END
    
    