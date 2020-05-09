function particle_type = findParticleType(m,dwdr,rho_j,rPos)
    % R-1 = -m * A 
    global LONELY_PARTICLE FREE_BOUNDARY_PARTICLE SURROUNDED_PARTICLE;

    rNorm = sqrt(rPos(:,1).*rPos(:,1)+rPos(:,2).*rPos(:,2)); 
    a11_ij = dwdr.*rPos(:,1).*rPos(:,1)./(rho_j.*rNorm); 
    a12_ij = dwdr.*rPos(:,1).*rPos(:,2)./(rho_j.*rNorm); 
    a22_ij = dwdr.*rPos(:,2).*rPos(:,2)./(rho_j.*rNorm); 
    a11 = sum (a11_ij);
    a12 = sum (a12_ij);
    a22 = sum (a22_ij);
    trA = a11 + a22;
    detA = a11 * a22 - a12 * a12;
    if (trA * trA - 4 * detA) < 0
        disp('ATTENTION! ROOTS ARE COMPLEXE!')
    else
        lambda = -m * 0.5 * (trA + sqrt(trA * trA - 4 * detA));
    end 
    
    if lambda <= 0.2 
        particle_type = [lambda LONELY_PARTICLE];
    elseif (lambda > 0.2) && (lambda <= 0.75 ) 
        particle_type = [lambda FREE_BOUNDARY_PARTICLE];
    else 
        particle_type = [lambda SURROUNDED_PARTICLE];
    end
        