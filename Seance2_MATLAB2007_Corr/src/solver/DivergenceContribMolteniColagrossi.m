function F = DivergenceContribMolteniColagrossi(m,dwdr,rVel,rPos,nu_rho,rho_i,rho_j)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% DivergenceContrib
rNorm = (rPos(:,1).*rPos(:,1)+rPos(:,2).*rPos(:,2)).^(.5);
veldotpos = rVel(:,1).*rPos(:,1)+rVel(:,2).*rPos(:,2);
%F = zeros(size(dwdr));
% COMPLETE HERE
F = m*veldotpos.*dwdr./rNorm + nu_rho*2*m*(rho_i-rho_j)./rho_j.*dwdr./rNorm;
%END

end

