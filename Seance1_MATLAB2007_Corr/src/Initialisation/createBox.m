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
% Create a box of particles
% createBox(part,lx,ly,dr0,TYPE) : create a box of part type TYPE of size
% lx ly starting from (0,0) with dr0 and add it to part
% createBox(part,x0,y0,lx,ly,dr0,TYPE) : create a box of part type TYPE of size
% lx ly starting from (x0,y0) with dr0 and add it to part
function [partTab] = createBox(varargin)
len = length(varargin);
if len == 5
    part =  varargin{1};
    lx   =  varargin{2};
    ly   =  varargin{3};
    dr0  =  varargin{4};
    TYPE =  varargin{5};
    x0 = 0;
    y0 = 0;
elseif len == 7
    part =  varargin{1};
    x0   =  varargin{2};
    y0   =  varargin{3};
    lx   =  varargin{4};
    ly   =  varargin{5};
    dr0  =  varargin{6};
    TYPE =  varargin{7};
end
global rhoF B gamma 


partTab=part';
partCount=size(partTab,2);
x=x0+dr0/2;
while x<=x0+lx
    y=y0+dr0/2;
    while y<=y0+ly
       vx=0;
       vy=0;
       rho =rhoF; 
       partTab=[partTab [x,y,vx,vy,rho,TYPE,0,0,0,0]'];
       partCount=partCount+1;
       y=y+dr0;
    end
    x=x+dr0;
end
partTab=partTab';
