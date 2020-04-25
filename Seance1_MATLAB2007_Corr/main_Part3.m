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
restoredefaultpath
addpath('src/solver','src/postprocess','src/kernel','src/Initialisation','src/CheckAnswers')
global rhoF; %Fluid density
global dr m ;%Particle size and mass
global lspace;
global aW d h smthfc;
global FLUID BOUND;%FLUID TYPES INFO
global INFO POS VEL RHO SPID FORCES;%PART ENTRIES
global xOrigin yOrigin xSize ySize;
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
%% PART 3
% Similarly to the part 2, we construct a simple example.
close all
part=[];
%We construct a box of fluids particles
dr=1/20;
h = smthfc*dr;
m = dr*dr*rhoF;
part =  createBox(part,1,1,dr,FLUID);
% Let's display the particles using the function provided in postProcess
fig=figure(1);
plotParticlesPropertyWithBound(part,POS(1),'Position x',0,1);
id = 8*20+9;
plotParticlesOutline(part,id,'r')
xlim([0 1])
ylim([0 1])
%
%% 3-a)  
% On top of this, outline in black the particles that influence the red
% outlined particle. How many particles do you count?
nPart = size(part,1);
count = 0;
% TO COMPLETE
for i=1:nPart
    if abs(i-id)>0
        rPos = part(id,POS)-part(i,POS);
        q = norm(rPos)/h;
        if q<=2.001
            plotParticlesOutline(part,i,'k')
            count=count+1;
        end
    end
end
% END
plotParticlesOutline(part,id,'r')
if not(checkQuestion3a(count))
    return
end


rectangle('Position',[part(id,POS(1))-4*h/2,part(id,POS(2))-4*h/2,4*h,4*h],...
    'Curvature',[1 1],'EdgeColor','b','LineWidth',4,...
    'LineStyle','--')
drawnow

titleImage=strcat('Figures1','/Neighbours.pdf');
print(fig,titleImage,'-dpdf','-r0')
%% Construction of spaces : 
% If we knew in advance, the particles in the kernel we could save time!
% This can be achieved by sorting the particles in boxes, called "space" in
% the present code. 
lspace = 2*h;
% We need to define some quantities
% the origin of the computational space.
xOrigin = 0; 
yOrigin = 0;
% And its size! All the fluid particles must be inside at all time!
xSize = 1+0.4*lspace;
ySize = 1+0.4*lspace;
% The function createSpace create the spaces. You can look at it by
% running these two commands. 
space = createSpace(dr,smthfc,lspace,xOrigin,yOrigin,xSize,ySize);
plotSpace(space)
titleImage=strcat('Figures1','/Neighbours_spaces.pdf');
print(fig,titleImage,'-dpdf','-r0')
% space contains several informations : 
%   1) in space{1} you find the coordinates of the center of the spaces
%   2) in space{2} the list of the neighbour spaces
%   3) in space{3} the IDs of the particles in the cells [1,16] means all
%   the particle from 1 to 16
%   4) in space{4} some periodicity information (you don't have to touch
%   it). For now it is only tables of zeros. 
% Take sometime to check the neighbour space list construction. Is it
% correct? Help your self with a drawing. 
% hint : think about the worst scenario for a particle in a space corner.
%% 3-b) 
% Now we need to figure out in which box are each particles and store this
% information. 
% Complete the function sortPart. You need to construct a function that
% gives the space number for a particle in that space. 
% Hint :  use the function floor and look at the numbering.
% COMPLETE FUNCTION SORTPART
[part,space] = sortPart(part,space,lspace,dr,xOrigin,yOrigin,xSize,ySize);
% END
if not(checkQuestion3b(part,SPID))
    return
end
%
%
%
id=193;%this is the new id of the preview particle if you did it right
% we can plot the particles neib and outline the cells in the figure.
%plotParticlesPropertyWithBound(part,POS(1),'Position x',0,1)
hold on
plotParticlesNeib(part,space,id)
drawnow
titleImage=strcat('Figures1','/Neighbours_spaces_2.pdf');
print(fig,titleImage,'-dpdf','-r0')
% We still look at more particles than needed, but now the number is
% bounded by the maximum number of neighbour spaces and particles in a
% space. Here we don't expect more than 16 particles per spaces and a
% maximum of 9 neighbour spaces. So now the calculation of the shepard is
% in N. and not N^2. Note that we still need to sort the particle first
% when they move! This is in NxLogN! So the total time should be in NxLogN.
% When N is large it is close to N.
%% 3-c) Time evaluation
% Let's evaluate the time required to do the shepard with this search. 
% Here you don't have to change anything. Just read the code. If you have
% any question, ask!
timesdr=2*smthfc; % lspace=timedr*dr;
timeImprove = [];
for sqnPart=[20 25 30 40 50 70 100 150]
    sqnPart
    [tinit,tshepard,ttotal,part,space]=improvedShepard(1/sqnPart,timesdr);
    timeImprove = [timeImprove [sqnPart^2 tinit,tshepard,ttotal]'];
end
save('timeImprove.mat','timeImprove');
load('naiveTime.mat');
load('naiveTimeVect.mat');
figure(3)
hold off
gcf.PaperUnits='inches';
gcf.PaperPosition = [0 0 5 4];
loglog(timeNaive(1,:),timeNaive(3,:),'bs')
hold on
loglog(timeNaiveVect(1,:),timeNaiveVect(3,:),'rs')
loglog(timeImprove(1,:),timeImprove(3,:),'ko')
loglog([timeNaive(1,4)/500 timeNaive(1,4)*500],[timeNaive(3,4)/500^2 timeNaive(3,4)*500^2],'-k')
loglog([timeImprove(1,4)/500 timeImprove(1,4)*500],[timeImprove(3,4)/500 timeImprove(3,4)*500],'--k')
grid on
xlim([1,100000])
ylim([10^(-4),10^2])
legend('Naive approach','Using Vect.','Using spaces lspace = 4 r','Location','northwest');
xlabel('number of particles','Interpreter','latex','fontsize',18);
ylabel('time (s)','Interpreter','latex','fontsize',18);
drawnow
titleImage=strcat('Figures1','/computationCost_timevsnPart_class.pdf');
print(figure(3),titleImage,'-dpdf','-r0')
comm = sprintf('You are done with part 3! See you next week!');
disp(comm);