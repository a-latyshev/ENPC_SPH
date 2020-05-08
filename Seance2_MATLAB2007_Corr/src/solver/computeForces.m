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
% computeForces : 
% partTab = computeForces(partTab,space)
% Compute the Pressure and Viscous contribution for fluid particles
% Compute the density contribution for fluid particles
% Return part updated for the field FORCES
% FORCES(1:2) : F_Pres+F_Visc
% FORCES(3) : Density contribution
function partTab = computeForces(partTab,space)
global INFO POS VEL RHO SPID FORCES;
global c0 B gamma;
global aW d h;
global g;
global  rhoF m;
global FLUID BOUND;
global ARTVISC VISCTYPE;
global COLAGROSSIDIFF DENSDIFFTYPE;
global delta
global alpha eps;
global mu;
global dt;

global LONELY_PARTICLE FREE_BOUNDARY_PARTICLE;
global lambda_list; %list of minimal eigen numbers of renormalisation matrix 
global free_boundary_particles; %list of indexes 
global lonely_particles; %list of indexes 

nPart = size(partTab,1);
forceTab = zeros(size(partTab(:,FORCES))); %Init forceTab to zero
%VISCOUS CONTRIBUTION
if VISCTYPE == ARTVISC 
    for i=1:nPart
        if partTab(i,INFO)==FLUID
            %GET NEIB LIST through the part spID
            spID = partTab(i,SPID);
            %we recover the space neib and the periodic vectors for relative pos
            listSpaces = space{2}{spID};
            listNeib = [space{3}{listSpaces(:)}];
            listNeib=listNeib(listNeib~=i);
            
            vel_i= partTab(i,VEL);
            info_j = partTab(listNeib,INFO);
            %
            %
            vel_j = zeros(size(partTab(listNeib,VEL)));
            vel_j(:,1) = (info_j==FLUID).*partTab(listNeib,VEL(1));
            vel_j(:,2) = (info_j==FLUID).*partTab(listNeib,VEL(2));
            %
            %
            rPos = [partTab(i,POS(1))-partTab(listNeib,POS(1)) ...
                partTab(i,POS(2))-partTab(listNeib,POS(2))];
            rNorm = (rPos(:,1).*rPos(:,1)+rPos(:,2).*rPos(:,2)).^(.5);
            q=rNorm/h;
            er = [rPos(:,1)./rNorm rPos(:,2)./rNorm];
            
            %NOTE : this is useful for the other VISC MODELS
            % relative Vel for continuity
            rVelCont = [vel_i(1)-vel_j(:,1) vel_i(2)-vel_j(:,2)];
            % relative Vel for Viscosity
            rVelVisc = [partTab(i,VEL(1))-partTab(listNeib,VEL(1)) ...
                partTab(i,VEL(2))-partTab(listNeib,VEL(2))];
            % rVelCont is the one used for the continuity
            % equations and then the wall velocity is the
            % prescribed one.
            % rVelVisc is the one used for the viscous contribution
            % and then wall velocity is interpolated from the fluid
            % velocities and stored in partTab(j,VEL) in
            % interpolateBoundary
            % Gradient w_ij
            dwdr = FW(q,aW,d,h);
            
            %PRESSURE CONTRIBUTION
            rho_i = partTab(i,RHO);
            rho_j = partTab(listNeib,RHO);
            P_i = Pressure(rho_i,B,rhoF,gamma);
            P_j = Pressure(rho_j,B,rhoF,gamma);
            F_Pres = PressureContrib(m,rho_i,rho_j,P_i,P_j,dwdr,er);
            
            %Viscosity only with fluid particles (ignore walls)
            c0_i = SoundSpeed(rho_i,B,rhoF,gamma);
            c0_j = SoundSpeed(rho_j,B,rhoF,gamma);
            mu_art = rho_i*h*alpha*(rho_j.*((c0_i+c0_j)./(rho_i+rho_j)));
            mu_art(info_j==BOUND) = 0; % NO VISC CONTRIBUTIONS OF WALLS
            F_Visc = ArtViscContrib(m,mu_art,rho_i,rho_j,dwdr,rVelVisc,rPos,eps);
            
            % Detection of the surface libre
            particle_type = findParticleType(m,dwdr,rho_j,rPos);
            if particle_type(2) == LONELY_PARTICLE
                lonely_particles = [lonely_particles i];
            elseif particle_type(2) == FREE_BOUNDARY_PARTICLE 
                free_boundary_particles = [free_boundary_particles i];
            end
            lambda_list = [lambda_list particle_type(1)];


            %CONTINUITY CONTRIBUTION
            switch d
                case{2}
                    sigma=sqrt(5/18)*h;
                    nu_rho=delta*sigma*c0;
                case{3}
                    sigma=sqrt(4/15)*h;
                    nu_rho=delta*sigma*c0;
            end
            if DENSDIFFTYPE == COLAGROSSIDIFF
                dRhodt = DivergenceContribMolteniColagrossi(m,dwdr,rVelCont,rPos,nu_rho,rho_i,rho_j);
            else
                dRhodt = DivergenceContrib(m,dwdr,rVelCont,rPos);
            end
            
            %
            forceTab(i,:) = [sum(F_Pres) 0]+[sum(F_Visc) 0]+ [g 0]+ [0 0 sum(dRhodt)];
        end
    end
else
    for i=1:nPart
        if partTab(i,INFO)==FLUID
            %GET NEIB LIST through the part spID
            spID = partTab(i,SPID);
            %we recover the space neib and the periodic vectors for relative pos
            listSpaces = space{2}{spID};
            listNeib = [space{3}{listSpaces(:)}];
            listNeib=listNeib(listNeib~=i);
            
            vel_i= partTab(i,VEL);
            info_j = partTab(listNeib,INFO);
            %
            %
            vel_j = zeros(size(partTab(listNeib,VEL)));
            vel_j(:,1) = (info_j==FLUID).*partTab(listNeib,VEL(1));
            vel_j(:,2) = (info_j==FLUID).*partTab(listNeib,VEL(2));
            %
            %
            rPos = [partTab(i,POS(1))-partTab(listNeib,POS(1)) ...
                partTab(i,POS(2))-partTab(listNeib,POS(2))];
            rNorm = (rPos(:,1).*rPos(:,1)+rPos(:,2).*rPos(:,2)).^(.5);
            q=rNorm/h;
            er = [rPos(:,1)./rNorm rPos(:,2)./rNorm];
            
            %NOTE : this is useful for the other VISC MODELS
            % relative Vel for continuity
            rVelCont = [vel_i(1)-vel_j(:,1) vel_i(2)-vel_j(:,2)];
            % relative Vel for Viscosity
            rVelVisc = [partTab(i,VEL(1))-partTab(listNeib,VEL(1)) ...
                partTab(i,VEL(2))-partTab(listNeib,VEL(2))];
            % rVelCont is the one used for the continuity
            % equations and then the wall velocity is the
            % prescribed one.
            % rVelVisc is the one used for the viscous contribution
            % and then wall velocity is interpolated from the fluid
            % velocities and stored in partTab(j,VEL) in
            % interpolateBoundary
            % Gradient w_ij
            dwdr = FW(q,aW,d,h);
            
            %PRESSURE CONTRIBUTION
            rho_i = partTab(i,RHO);
            rho_j = partTab(listNeib,RHO);
            P_i = Pressure(rho_i,B,rhoF,gamma);
            P_j = Pressure(rho_j,B,rhoF,gamma);
            F_Pres = PressureContrib(m,rho_i,rho_j,P_i,P_j,dwdr,er);
            
            %CONTINUITY CONTRIBUTION
            switch d
                case{2}
                    sigma=sqrt(5/18)*h;
                    nu_rho=delta*sigma*c0;
                case{3}
                    sigma=sqrt(4/15)*h;
                    nu_rho=delta*sigma*c0;
            end
            if DENSDIFFTYPE == COLAGROSSIDIFF
                dRhodt = DivergenceContribMolteniColagrossi(m,dwdr,rVelCont,rPos,nu_rho,rho_i,rho_j);
            else
                dRhodt = DivergenceContrib(m,dwdr,rVelCont,rPos);
            end
            
            %
            forceTab(i,:) = [sum(F_Pres) 0]+ [g 0]+ [0 0 sum(dRhodt)];
        end
    end
end    
partTab(:,FORCES) = forceTab;




