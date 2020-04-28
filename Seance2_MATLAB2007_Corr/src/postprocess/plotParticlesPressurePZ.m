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
%plotParticlesPressurePZ(part,nameBar,propMin,propMax)
% Display particle pressure as a function of z
function plotParticlesPressurePZ(part,nameBar,propMin,propMax)
global dr lspace;
global INFO;
global POS RHO;
global FLUID BOUND;
global B rhoF gamma;

infoTab = part(:,INFO);
fluid = part(infoTab ==FLUID,:);
bound = part(infoTab ==BOUND,:);
propTab=fluid(:,RHO);



n=size(posTab,1);
%figure()
gcf.PaperUnits='inches';
gcf.PaperPosition = [0 0 10 5];
clf
hold on
pTab = [fluid(:,POS(2)) Pressure(propTab,B,rhoF,gamma)]';

plot(pTab(1,:),pTab(2,:),'x');
xlabel('$z$ (m)','Interpreter','latex','fontsize',18);
ylabel('$P$ (Pa)','Interpreter','latex','fontsize',18);
