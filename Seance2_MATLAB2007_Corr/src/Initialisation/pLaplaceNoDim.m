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
% p = pLaplaceNoDim(lx,ly,Nmax,x,y)
% Calculate the p/(rho*g*ly) at the position x y
% WARNING :  IT IS THE NON DIM PRESSURE!!!!!
% SEE RIGHT HAND SIDE OF EQ.9 OF TD SEANCE 2
function p = pLaplaceNoDim(lx,ly,Nmax,x,y)
pcont = zeros(size(x));
p = pcont;
for n=0:Nmax
    kn = (2*n+1)*pi/(2*lx);
    % COMPLETE HERE
    pcont = (-1)^(n+1)*2*sinh(kn*(y-ly))*sech(kn*ly)/(kn*ly).*cos(kn*x)/(kn*lx);
    % END
    p =p+pcont;  
end
