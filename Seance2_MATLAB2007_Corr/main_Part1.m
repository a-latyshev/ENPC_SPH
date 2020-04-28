clear all
close all
clc
restoredefaultpath
addpath('src/solver','src/postprocess','src/kernel','src/Initialisation','src/CheckAnswers')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          SPH LAB : SEANCE 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Authors :  R. Carmigniani, A. Ghaitanellis, A. Leroy, T. Fonty  and D. Violeau
%Version : SPHLAB.0
%Date : Started on 28/09/2018
%Contact : remi.carmigniani@enpc.fr
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PART 1
% Goal :  Construction of Kernel functions and quick overview of analytical
% tools of matlab.
% In this section we start by implementing the kernel functions. 
%% 1)
% In src/kernel complete the functions FW.m.
%
aW = 7/(4*pi);%Normalization constant
d  = 2; %dimension of space
h  = 1; %attenuation length
dq = 0.01;
qtab = 0:dq:3; %vecteur q
FWtab = zeros(size(qtab)); %vecteur FWtab
FWtab=FW(qtab,aW,d,h);
figure(1)
gcf.PaperUnits='inches';
gcf.PaperPosition = [0 0 5 4];
hold off
plot(qtab,h^(d+1)*abs(FWtab)/aW,'-k')
hold on
legend('Wendland');
xlim([0,3])
ylim([0,1.2])
xlabel('$q$','Interpreter','latex','fontsize',18);
ylabel('$\left|\nabla w\right| h^{d+1}/a_w $','Interpreter','latex','fontsize',18);
drawnow
if not(checkQuestion1a(aW,d,h))
    return;
end
titleImage=strcat('Figures','/FW.pdf');
print(figure(1),titleImage,'-dpdf','-r0')

%% GO TO THE NEXT PART