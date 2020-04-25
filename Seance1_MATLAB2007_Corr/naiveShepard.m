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
function [initTime, shepTime, totalTime,part] = naiveShepard(dr0)
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
    part(:,FORCES(1))=zeros(size(part(:,FORCES(1))));%start by putting all to zero
    for i=1:nPart
        for j=1:nPart
            rPos = part(i,POS)-part(j,POS);
            rho_j =  part(j,RHO);
            V_j = m/rho_j;
            q = norm(rPos)/h;
            w_ij = W(q,aW,d,h);
            % COMPLETE HERE
            part(i,FORCES(1)) =part(i,FORCES(1))+V_j*w_ij;
            % END
        end
    end
end
t2 = cputime; % end init
% Evaluation of the execution times
initTime = t1-t0;
shepTime = (t2-t1)/20;
totalTime = t2-t0;
