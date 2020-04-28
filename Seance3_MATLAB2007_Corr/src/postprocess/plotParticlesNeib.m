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
% plotParticlesNeib(fluid,space,id)
% Outline the neibs of fluid(id)
%
function plotParticlesNeib(fluid,space,id)
global dr;
global INFO SPID lspace;
global POS;

infoTab = fluid(:,6);
posTab = fluid(:,1:2);
posSpace = space{1};
iDTab = fluid(:,7);
iDTabMax=max(iDTab);

n=size(posTab,1);
%figure(1)
%clf
hold on
daspect([1,1,1])
spID = fluid(id,SPID);
listSpaces = space{2}{spID};
listNeib = [space{3}{listSpaces(:)}];
vecPerCorTab = space{4}{spID};
nNeibSpaces=size(listSpaces,2);
for jSp = 1:nNeibSpaces
    rectangle('Position',[posSpace(listSpaces(jSp),1)-lspace/2,posSpace(listSpaces(jSp),2)-lspace/2,lspace,lspace],...
    'EdgeColor','b','LineWidth',3,'LineStyle',':')
end
  
for j=listNeib
    if abs(j-id)>0
        rectangle('Position',[posTab(j,1)-dr/2,posTab(j,2)-dr/2,dr,dr],...
            'EdgeColor','y','LineWidth',1,'LineStyle',':')
    end
end
rectangle('Position',[posTab(id,1)-dr/2,posTab(id,2)-dr/2,dr,dr],...
    'EdgeColor','r','LineWidth',2)
