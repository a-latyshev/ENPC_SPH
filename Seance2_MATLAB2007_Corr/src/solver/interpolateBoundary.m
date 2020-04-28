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
% Interpolate the pressure 
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
        pres = 0;
	if not(isempty(listNeibFluid))
            % FLUID NEIB
            rPos = [partTab(i,POS(1))-partTab(listNeibFluid,POS(1)) ...
            partTab(i,POS(2))-partTab(listNeibFluid,POS(2))];
            rNorm = (rPos(:,1).*rPos(:,1)+rPos(:,2).*rPos(:,2)).^(.5);
            q=rNorm/h;
            w_ij = W(q,aW,d,h);
            % We store the interpolated pressure
            rho_j = partTab(listNeibFluid,RHO);
            pres_j = Pressure(rho_j,B,rhoF,gamma);
            rho_j(rho_j<rhoF) =rhoF;
            vol_j = m./rho_j;
            rho_j = partTab(listNeibFluid,RHO);
            % COMPLETE HERE
            PressInt = (pres_j + rho_j.*(rPos*g')).*vol_j.*w_ij;
            PressInt(PressInt<0) = 0;
            shepard =w_ij.* vol_j;
            %END
            shepard = max(sum(shepard),shepardMin);
            pres = sum(PressInt)/shepard;

        end
        partTab(i,RHO) = Density(pres,B,rhoF,gamma);
    end
end




