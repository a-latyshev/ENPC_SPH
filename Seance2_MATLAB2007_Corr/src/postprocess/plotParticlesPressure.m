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
% plotParticlesPressure(fluid,nameBar,propMin,propMax)
% display the particle pressure field
function plotParticlesPressure(part,nameBar,propMin,propMax)
global dr lspace;
global INFO;
global POS RHO;
global FLUID BOUND;
global B rhoF gamma;

global free_boundary_particles;

infoTab = part(:,INFO);
fluid = part(infoTab ==FLUID,:);
bound = part(infoTab ==BOUND,:);
propTab=fluid(:,RHO);
propTab = Pressure(propTab,B,rhoF,gamma);
%CROP
propTab(propTab>=propMax) = propMax;
propTab(propTab<=propMin) = propMin;
%% CREATE COLOR MAP
Nstep=100;
c = jet(Nstep+1);
c1q = @(x) interp1([0:1/Nstep:1]',c(:,1),x);
c2q = @(x) interp1([0:1/Nstep:1]',c(:,2),x);
c3q = @(x) interp1([0:1/Nstep:1]',c(:,3),x);
f_color_map = @(value) ([c1q((value - propMin)/(propMax - propMin)),...
                            c2q((value - propMin)/(propMax - propMin)),...
                            c3q((value - propMin)/(propMax - propMin))]);

gcf.PaperUnits='inches';
gcf.PaperPosition = [0 0 5 4];
clf
hold on

%% PLOT FLUID PARTICLES
xtab = [fluid(:,POS(1))-dr/2 fluid(:,POS(1))+dr/2 fluid(:,POS(1))+dr/2 fluid(:,POS(1))-dr/2]';
ytab = [fluid(:,POS(2))-dr/2 fluid(:,POS(2))-dr/2 fluid(:,POS(2))+dr/2 fluid(:,POS(2))+dr/2]';
% Create the RGB COLORS
colorRGB = f_color_map(propTab);
if size(version,2) ==size('7.5.0.342 (R2007b)',2)
    color = zeros(1,length(xtab),3); % THIS SEEMS TO BE THE CORRECT FORMAT FOR THE MATLAB 2007
else
    color = zeros(length(xtab),1,3);
end
color(:,:,1) = colorRGB(:,1);
color(:,:,2) = colorRGB(:,2);
color(:,:,3) = colorRGB(:,3);
% display
patch(xtab,ytab,color,'Edgecolor','none');

%% PLOT BOUND PARTICLES
xtab = [bound(:,POS(1))-dr/2 bound(:,POS(1))+dr/2 bound(:,POS(1))+dr/2 bound(:,POS(1))-dr/2]';
ytab = [bound(:,POS(2))-dr/2 bound(:,POS(2))-dr/2 bound(:,POS(2))+dr/2 bound(:,POS(2))+dr/2]';
patch(xtab,ytab,'white');

% PLOT FREE BOUNDARY
N = size(free_boundary_particles);
for i = 1:N(2)
    k = free_boundary_particles(1,i);
    xtab = [part(k,POS(1))-dr/2 part(k,POS(1))+dr/2 part(k,POS(1))+dr/2 part(k,POS(1))-dr/2]';
    ytab = [part(k,POS(2))-dr/2 part(k,POS(2))-dr/2 part(k,POS(2))+dr/2 part(k,POS(2))+dr/2]';
    patch(xtab,ytab,'red');
end

%% ADD AXES
xlabel('$x$ (m)','Interpreter','latex','fontsize',18);
ylabel('$z$ (m)','Interpreter','latex','fontsize',18);

%% CREATE COLOR MAPS (DOES NOT WORK WELL WITH MAT2007...
colormap(c);
if size(version,2) ==size('7.5.0.342 (R2007b)',2)
    cbar = colorbar('YTickLabel',{[0.1:0.1:1]*(propMax-propMin)+propMin});
else
    cbar = colorbar;
    caxis([0 1]);
    cbar.Limits = [0 1];
    cbar.Ticks=0:0.2:1;
    %cbar.TickLabels = cell(size(0:0.1:1,2),1);
    for i=1:size(cbar.Ticks,2)
        cbar.TickLabels{i} = sprintf('%2.2f',cbar.Ticks(i)*(propMax-propMin)+propMin);
    end
    cbar.Label.String = nameBar;
    cbar.Label.Interpreter = 'latex';
    cbar.TickLabelInterpreter = 'latex';
end