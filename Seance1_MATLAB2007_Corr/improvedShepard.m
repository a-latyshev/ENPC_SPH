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
% Test evaluation time of shepard calculation using the symmetry of w_ij
function [initTime, shepTime, totalTime,part,space] = improvedShepard(dr0,timesdr0)
global rhoF dr h smthfc POS FORCES FLUID RHO m aW d lspace xOrigin;
global yOrigin xSize ySize SPID;
t0 = cputime; % init the cputime
part=[];
dr=dr0;
h = smthfc*dr;
lspace = timesdr0*dr;
m = dr*dr*rhoF;
% Create the particles and the space
part =  createBox(part,1,1,dr,FLUID);
xSize = 1+0.4*lspace;
ySize = 1+0.4*lspace;
space = createSpace(dr,smthfc,lspace,xOrigin,yOrigin,xSize,ySize);
t1 = cputime; % end init
nPart = size(part,1);
%we do the calculation 20 times
for n = 1:20
    % start by sorting the particles
    % Note we don't really have to do it at each time step...
    [part,space] = sortPart(part,space,lspace,dr,xOrigin,yOrigin,xSize,ySize);
    part(:,FORCES(1))=zeros(size(part(:,FORCES(1))));%start by putting all to zero
    for i=1:nPart
        %GET NEIB LIST through the part spID
        spID = part(i,SPID);
        %we recover the space neib and the periodic vectors for relative pos
        listSpaces = space{2}{spID};
        vecPerCorTab = space{4}{spID};
        listNeib=[space{3}{listSpaces(:)}];
        %vector of pos
        rPosVec = [part(i,POS(1))-part(listNeib,POS(1)) part(i,POS(2))-part(listNeib,POS(2))];
        rNormVec = (rPosVec(:,1).*rPosVec(:,1)+rPosVec(:,2).*rPosVec(:,2)).^(.5);
        qVec = rNormVec/h;
        WVec = W(qVec,aW,d,h);
        VVec = m./part([space{3}{listSpaces(:)}],RHO);
        GammaVal = sum(WVec.*VVec);
        part(i,FORCES(1)) = GammaVal;
    end
end
t2 = cputime; % end loop
initTime = t1-t0;
shepTime = (t2-t1)/20;
totalTime = t2-t0;
