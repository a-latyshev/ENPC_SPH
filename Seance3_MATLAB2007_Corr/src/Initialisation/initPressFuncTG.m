%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               SPH LAB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Authors :  R. Carmigniani, A. Ghaitanellis, A. Leroy, T. Fonty  and D. Violeau
%Version : SPHLAB.0
%Date : Started on 28/09/2018
%Contact : remi.carmigniani@enpc.fr
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Init the pressure field Taylo Green
function [partNew] = initPressFuncTG(k,pos_0,part)
global rhoF B gamma 
global RHO POS
partNew=part;
for i=1:size(part,1)
   pos_i = partNew(i,POS);
   % Taylor green pressure 
   p_i = sin(k*(pos_i(1)-pos_0(1)))+sin(k*(pos_i(2)-pos_0(2)));
   %
   % COMPLETE
   rho_i = Density(p_i,B,rhoF,gamma);% rho_i = 0;%??
   % END
   partNew(i,RHO) = rho_i;
end
