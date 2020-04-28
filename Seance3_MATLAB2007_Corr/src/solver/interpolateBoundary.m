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
% interpolateBoundary :  partTab = interpolateBoundary(partTab,space)
% Interpolate the pressure and velocity tilde
% vtilde is the interpolated velocity
% Cf Adami, Hu & Adams, 2012
function partTab = interpolateBoundary(partTab,space)
global INFO POS VEL RHO SPID FORCES;
global c0 B gamma;
global aW d h;
global g;
global rhoF m shepardMin;
global FLUID BOUND;
nPart = size(partTab,1);
forceTab = partTab(:,FORCES); %Init forceTab to zero
infoTab = partTab(:,INFO);
for i=1:nPart
    if partTab(i,INFO)==BOUND
        %GET NEIB LIST through the part spID
        spID = partTab(i,SPID);
        %we recover the space neib
        listSpaces = space{2}{spID};
        listNeib = [space{3}{listSpaces(:)}];
        listNeibFluid = listNeib(find(partTab(listNeib,INFO)==FLUID));
        %
        spID_j = partTab(listNeibFluid,SPID);
        % Need to take care of the periodicity :
        vecPerCorSP = space{4}{spID};
        vecPerCorTab=zeros(length(listNeibFluid),2);
        for j_sp = 1:length(space{4}{spID})
         vecPerCorTab(spID_j==listSpaces(j_sp ),1)=vecPerCorSP(1,j_sp);
         vecPerCorTab(spID_j==listSpaces(j_sp ),2)=vecPerCorSP(2,j_sp);
        end
        
        pres = 0;
        vtildewall = [0 0];
        if not(isempty(listNeibFluid))
            % FLUID NEIB
            rPos = [partTab(i,POS(1))-(partTab(listNeibFluid,POS(1))+vecPerCorTab(:,1))...
                    partTab(i,POS(2))-(partTab(listNeibFluid,POS(2))+vecPerCorTab(:,2))];
            rNorm = (rPos(:,1).*rPos(:,1)+rPos(:,2).*rPos(:,2)).^(.5);
            q=rNorm/h;
            w_ij = W(q,aW,d,h);
            % We store the interpolated pressure
            rho_j = partTab(listNeibFluid,RHO);
            pres_j = Pressure(rho_j,B,rhoF,gamma);
            rho_j(rho_j<rhoF) =rhoF;
            vol_j = m./rho_j;
            rho_j = partTab(listNeibFluid,RHO);
            vel_j = partTab(listNeibFluid,VEL);
            PressInt = (pres_j + rho_j.*(rPos*g')).*vol_j.*w_ij;
            PressInt(PressInt<0) = 0;
            %VTildeInt = zeros(size(vel_j));
            %COMPLETE HERE
            VTildeInt = [-vel_j(:,1).*vol_j.*w_ij -vel_j(:,2).*vol_j.*w_ij];
            %END
            % COMMENT THE LINE VInt = zeros(size(vel_j)) when you are done
            shepard =w_ij.* vol_j;
            shepard = max(sum(shepard),shepardMin);
            pres = sum(PressInt)/shepard;
            vtildewall = [sum(VTildeInt(:,1))/shepard sum(VTildeInt(:,2))/shepard];
        end
        partTab(i,RHO) = Density(pres,B,rhoF,gamma);
        partTab(i,VEL) = [vtildewall(1) vtildewall(2)];
    end
end





