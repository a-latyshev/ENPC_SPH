function [lonely_particles free_boundary_particles lambda_list] = separateParticles(partTab,space)
global m;
global aW d h;
global INFO POS VEL RHO SPID FORCES;
global LONELY_PARTICLE FREE_BOUNDARY_PARTICLE;
global FLUID BOUND;

lambda_list = []; 
free_boundary_particles = []; 
lonely_particles = []; 

nPart = size(partTab,1);

    for i=1:nPart
        if partTab(i,INFO)==FLUID
            %GET NEIB LIST through the part spID
            spID = partTab(i,SPID);
            %we recover the space neib and the periodic vectors for relative pos
            listSpaces = space{2}{spID};
            listNeib = [space{3}{listSpaces(:)}];
            listNeib=listNeib(listNeib~=i);
            
            rPos = [partTab(i,POS(1))-partTab(listNeib,POS(1)) ...
                partTab(i,POS(2))-partTab(listNeib,POS(2))];
            rNorm = (rPos(:,1).*rPos(:,1)+rPos(:,2).*rPos(:,2)).^(.5);
            q=rNorm/h;
            % Gradient w_ij
            dwdr = FW(q,aW,d,h);
            
            rho_j = partTab(listNeib,RHO);

            % Detection of the surface libre
            particle_type = findParticleType(m,dwdr,rho_j,rPos);
            if particle_type(2) == LONELY_PARTICLE
                lonely_particles = [lonely_particles i];
            elseif particle_type(2) == FREE_BOUNDARY_PARTICLE 
                free_boundary_particles = [free_boundary_particles i];
            end
            lambda_list = [lambda_list particle_type(1)];
        end
    end
end