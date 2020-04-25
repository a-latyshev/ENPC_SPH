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
%% THERE IS NO CHANGE TO MAKE IN THIS SECTION
clear all 
close all
clc
restoredefaultpath
addpath('src/solver','src/postprocess','src/kernel','src/Initialisation','src/CheckAnswers')
global rhoF; %Fluid density
global dr m ;%Particle size and mass
global lspace;
global aW d h smthfc;
global FLUID BOUND;%FLUID TYPES INFO
global INFO POS VEL RHO SPID FORCES;%PART ENTRIES
rhoF = 1000;
%INFO FLAGS
FLUID = 0;
BOUND =1;
%CELL INFO
POS  = [1,2];
VEL  = [3,4];
RHO  = 5;
INFO = 6;
SPID = 7;
FORCES= [8,9,10]; %Fx Fy dDensity
%Particle smoothing factor
smthfc=2;
%Kernel parameters
aW = 7/(4*pi);
d = 2;
%% PART 2
% Here we show in an example how expensive it is to evaluate simple sums...
% A trick will be developped in part 3 to save time!
% To see the improvement, we propose a naive approach here. 
part=[];
%We construct a box of fluids particles
dr=1/10;
h = smthfc*dr;
m = dr*dr*rhoF;
part =  createBox(part,1,1,dr,FLUID);
% Let's display the particles using the function provided in postProcess
fig = figure(1);
plotParticlesPropertyWithBound(part,POS(1),'Position x',0,1);
% It plots the particle and colors the position in x. 
%
% In SPH method, we evaluate frequently sums on all the particles. Here we
% will evaluate the following sum : 
%                  shepard_i = \sum_{j} w_{i,j} V_j
% This sum will be useful in the future for instance to evaluate the
% pressure at the wall.
% Recall that we work at constant mass. 
% Store the shepard at FORCES(1) in part.
% We start with a naive approach.
%% 2-a) 
% Complete the following loop to evaluate the shepard of all the particles.
nPart = size(part,1);
part(:,FORCES(1))=zeros(size(part(:,FORCES(1))));%start by putting all to zero
for i=1:nPart
    for j=1:nPart
            rPos = part(i,POS)-part(j,POS);
            rho_j =  part(j,RHO);
            V_j = m/rho_j;
            q = norm(rPos)/h;
            w_ij = W(q,aW,d,h);
            % COMPLETE HERE
            part(i,FORCES(1)) = part(i,FORCES(1))+V_j*w_ij;
            % END
    end
end
fig = figure(2);
plotParticlesPropertyWithBound(part,FORCES(1),'Shepard',0,1);
maxShepard = max(part(:,FORCES(1)));
minShepard = min(part(:,FORCES(1)));

if not(checkQuestion2a(maxShepard,minShepard))
    return
end

titleImage=strcat('Figures1','/shepard_0.png');
print(fig,titleImage,'-dpng','-r0')
part0=part;
%% 2-b) TIME GROWS IN N^2 
% The goal now is to evaluate the time needed to do this calculation while
% varying the number of particles.
% To this end we created a function called naiveShepard. Complete the
% function before running. 
% Check that it is correct
[tinit,tshepard,ttotal,part1]=naiveShepard(1/10);
if not(checkQuestion2b(part1,part0,FORCES))
    return
end
% It will take some time to run ... be patient!
timeNaive = [];
t00 = cputime; % init the cputime
for sqnPart=[5 10 15 20 25]
    sqnPart
    [tinit,tshepard,ttotal,part]=naiveShepard(1/sqnPart);
    timeNaive = [timeNaive [sqnPart^2 tinit,tshepard,ttotal]'];
end
t10 = cputime; % init the cputime
% Let's save the result (so we don't have to run it again...)
% and plot the figure to see the trend!
save('naiveTime.mat','timeNaive');
figure(3)
gcf.PaperUnits='inches';
gcf.PaperPosition = [0 0 5 4];
loglog(timeNaive(1,:),timeNaive(3,:),'s')
hold on
grid on
xlim([1,10000])
ylim([10^(-4),10^2])
legend('Naive approach','Location','northwest');
xlabel('number of particles','Interpreter','latex','fontsize',18);
ylabel('time (s)','Interpreter','latex','fontsize',18);

titleImage=strcat('Figures1','/computationCost_timevsnPart_nolog.pdf');
print(figure(3),titleImage,'-dpdf','-r0')
%% Verify that the time is close to \propto N^2
% COMPLETE HEREx
loglog([timeNaive(1,4)/500 timeNaive(1,4)*500],[timeNaive(3,4)/500^2 timeNaive(3,4)*500^2],'-k')
% END
%% 2-c) A SIMPLE IMPROVEMENT :  USE MATRIX MULTIPLICATIONS
% Complete function naiveShepardVect for this idea.
% You can check first that you get the same results as before :
[tinit,tshepard,ttotal,part1]=naiveShepard(1/10);
[tinit,tshepard,ttotal,part2]=naiveShepardVect(1/10);
if not(checkQuestion2c(part1,part2,FORCES))
    return
end
% Now look at the time improvement!
timeNaiveVect = [];
for sqnPart=[20 25 30 50 70]
    sqnPart
    [tinit,tshepard,ttotal,part]=naiveShepardVect(1/sqnPart);
    timeNaiveVect = [timeNaiveVect [sqnPart^2 tinit,tshepard,ttotal]'];
end
save('naiveTimeVect.mat','timeNaiveVect');
figure(3)
hold off
gcf.PaperUnits='inches';
gcf.PaperPosition = [0 0 5 4];
loglog(timeNaive(1,:),timeNaive(3,:),'bs')
hold on
loglog(timeNaiveVect(1,:),timeNaiveVect(3,:),'rs')
loglog([timeNaive(1,4)/500 timeNaive(1,4)*500],[timeNaive(3,4)/500^2 timeNaive(3,4)*500^2],'-k')
grid on
xlim([1,10000])
ylim([10^(-4),10^2])
legend('Naive approach','Using Vect.','Location','northwest');
xlabel('number of particles','Interpreter','latex','fontsize',18);
ylabel('time (s)','Interpreter','latex','fontsize',18);
titleImage=strcat('Figures1','/computationCost_timevsnPart_0.pdf');
print(figure(3),titleImage,'-dpdf','-r0')
% You should see an improvement! But it is still \propto N^2...
% This improvement will be useful for the next class. Remember this!
% We can do way better! and this is the object of the part 3 of this
% course.
comm = sprintf('You are done with part 2!');
disp(comm);