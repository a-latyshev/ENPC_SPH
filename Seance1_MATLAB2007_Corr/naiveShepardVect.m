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
% Test evaluation time of shepard calculation
function [initTime, shepTime, totalTime,part] = naiveShepardVect(dr0)
global rhoF dr h smthfc POS FORCES FLUID RHO m aW d
t0 = cputime; % init the cputime
part=[];
dr=dr0;
h = smthfc*dr;
m = dr*dr*rhoF;
part =  createBox(part,1,1,dr,FLUID);
t1 = cputime; % end init
nPart = size(part,1);
%we do the calculation 20 times
for n = 1:20
    xPosTab = part(:,POS(1))';
    yPosTab = part(:,POS(2))';
    rhoTab = part(:,RHO)';
    matXPos = zeros(length(xPosTab));
    matYPos = zeros(length(yPosTab));
    for k=1:length(xPosTab)
        matXPos(k,:) = xPosTab-xPosTab(k);
        matYPos(k,:) = yPosTab-yPosTab(k);
    end
    matQ = sqrt(matXPos.*matXPos+matYPos.*matYPos)/h;
    matW = W(matQ,aW,d,h);
    vectV = m./rhoTab';
    % COMPLETE HERE
    Gamma = matW*vectV;
    % END
    part(:,FORCES(1)) = Gamma;
end
t2 = cputime; % end init
% Evaluation of the execution times
initTime = t1-t0;
shepTime = (t2-t1)/20;
totalTime = t2-t0;
