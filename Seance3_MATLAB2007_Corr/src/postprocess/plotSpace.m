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
% PlotSpace: plot the differnt background cells used to facilitate particle
% access
% plotSpace(space) display the spaces and the space numbers
% plotSpace(space,false) display the spaces only
function plotSpace(varargin)
len = length(varargin);
if len == 1
    space =  varargin{1};
    displayNumber = 1;
elseif len == 2
    space =  varargin{1};
    displayNumber = varargin{2};
end
global lspace;
posSpace = space{1};
n=size(posSpace,1);

hold on
for i=1:n
    rectangle('Position',[posSpace(i,1)-lspace/2,posSpace(i,2)-lspace/2,lspace,lspace],...
        'EdgeColor','r')
    daspect([1,1,1])
    if displayNumber
    text(posSpace(i,1),posSpace(i,2),sprintf('%i',i),...
                'HorizontalAlignment','center',...
                'Interpreter','latex','fontsize',14);
    end
end
