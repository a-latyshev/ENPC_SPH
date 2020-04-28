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
% sortPart :  sort the particle based on the cells positions and generate
% the index information per cells.
% [partSorted,spaceUpDated]= sortPart(partTab,space,lspace,dr0,xOrigin,yOrigin)
% return the part list sorted and the updated space information.
% 
function [partSorted,spaceUpDated]= sortPart(partTab,space,lspace,dr0,xOrigin,yOrigin,xSize,ySize)
global SPID POS
nPart = size(partTab,1);
posTab=partTab(:,POS);
nSpace= size(space{1},1);
posSpace = space{1};
maxpos2=max(posSpace(:,2))+lspace/2;
maxpos1=max(posSpace(:,1))+lspace/2;
spID = 0; 
spIDTab  =(floor((posTab(:,2)-yOrigin)/lspace)+1)+...
                  (floor((posTab(:,1)-xOrigin)/lspace))*...
                  floor((maxpos2-yOrigin+0.5*dr0)/lspace);
spIDTab(posTab(:,2)<yOrigin) = -1000;
spIDTab(posTab(:,2)>yOrigin+ySize) = -1000;
spIDTab(posTab(:,1)<xOrigin) = -1000;
spIDTab(posTab(:,1)>xOrigin+xSize) = -1000;
partTab(:,SPID) = spIDTab;
%% Sort the Particles
%Sort the particles
[B,I] = sort(partTab(:,SPID)); %sorting in nPart*Log(nPart)
%Table I gives the transformation B = partTab(I,SPID);
partSorted = partTab(I,:);
%The table is now sorted
%
%
%% DELETE PART OUT OF DOMAIN
if partSorted(1,SPID)<0
	id = find(partSorted(:,SPID) == -1000,1,'last');
    text = sprintf('Deleted %i particles',id);
    disp(text);
else
    id = 0;
end
partSorted = partSorted(id+1:nPart,:);
%
%
%% SPACE INFORMATIONS
nPart = size(partSorted,1);
partSpace = space{3};
%put the space ID back to zero
nSpace = size(partSpace,1);
for i=1:nSpace
   partSpace{i} = find(partSorted(:,SPID) == i)'; 
end

spaceUpDated = {space{1},space{2},partSpace,space{4}};
