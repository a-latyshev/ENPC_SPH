
function F = DivergenceContribMolteniColagrossi(m,dwdr,rVel,rPos,nu_rho,rho_i,rho_j)
    rNorm = (rPos(:,1).*rPos(:,1)+rPos(:,2).*rPos(:,2)).^(.5);
    veldotpos = rVel(:,1).*rPos(:,1)+rVel(:,2).*rPos(:,2);
    F = m*veldotpos.*dwdr./rNorm + nu_rho*2*m*(rho_i-rho_j)./rho_j.*dwdr./rNorm;
end

