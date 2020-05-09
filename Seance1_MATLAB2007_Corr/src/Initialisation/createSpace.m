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
% Create spaces and find their neighbours 
%INFORMATIONS
%list of the space=
% 1) space center coordinate
% 2) space neigh
% 3) particle list in this space
% 4) the periodicity vectors of the space neibs
% createSpace(dr0,smthfc,lspace,xOrigin,yOrigin,xSize,ySize)
% dr0 is the particle size
% smthfc the smoothing factor
% lspace the size of the spaces to create
% xOrigin,yOrigin,xSize,ySize Origin and size of comp domain
function space = createSpace(dr0,smthfc,lspace,xOrigin,yOrigin,xSize,ySize)
%% SPACES
%INFORMATIONS
%list of the space=
% 1) space center coordinate
% 2) space neigh
% 3) particle list in this space
% 4) the periodicity vectors of the space neibs

posSpace=[];

spaceCount=1;
x0 = xOrigin+lspace/2;
y0 = yOrigin+lspace/2;

while x0 < xOrigin+xSize
  y0 = yOrigin+lspace/2;
  while y0 < yOrigin+ySize
   posSpace = [posSpace [x0, y0]'];
   y0 = y0 + lspace;
   spaceCount=spaceCount+1;
  end
  x0 = x0 + lspace;
end

posSpace=posSpace';
nSpace=size(posSpace,1);
%Create a Table
neibSpace= cell(nSpace,1);
partSpace= cell(nSpace,1);
vecPerCor= cell(nSpace,1);
%%
%Done only once :  note the neib cells in a table
t0=cputime;
for i = 1:nSpace
  neibSpace{i} = [neibSpace{i} i];
  vecPerCor{i} = [vecPerCor{i} [0 0]'];
  partSpace{i} = [0 0];
  j=i;
  while j<=nSpace
      if abs(i-j)>0 
         A=min([0 1-2*abs(posSpace(i,2)-posSpace(j,2))/lspace -abs(posSpace(i,2)-posSpace(j,2))/lspace]);
         B=min([0 1-2*abs(posSpace(i,1)-posSpace(j,1))/lspace -abs(posSpace(i,1)-posSpace(j,1))/lspace]);
         if norm(posSpace(i,:) - posSpace(j,:))^2 +...
                 (A+B)*lspace^2 < ((2*smthfc-0.0001)*dr0)^2
             neibSpace{i} = [neibSpace{i} j];
             neibSpace{j} = [neibSpace{j} i];
             vecPerCor{i} = [vecPerCor{i} [0 0]'];
             vecPerCor{j} = [vecPerCor{j} [0 0]'];  
         end
      end
      j=j+1;
  end
end
t1=cputime;
space = {posSpace,neibSpace,partSpace,vecPerCor};
