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
%% Analytical Dam Break
function tab = dambreakChanson(t,D,g,x0)
global rhoF mu;
% Evaluate wave front celerity
b=2*sqrt(g*D);
a=0;
gr = (sqrt(5)+1)/2;
tol=10^-5;
%GoldenSearch
c= b - (b-a)/gr;
d = a+(b-a)/gr;
while abs(c-d) > tol
    fc = eq15(c,g,D,t,rhoF,mu);
    fd = eq15(d,g,D,t,rhoF,mu);
    if fc<fd
        b=d;
    else
        a=c;
    end
    c= b - (b-a)/gr;
    d = a+(b-a)/gr;
end
U = (b+a)/2;
ReD = rhoF*sqrt(g*D^3)/mu;
G=2.5*10^-3/(ReD*U/sqrt(g*D));
% Evaluate xs
xs = (3/2*U/sqrt(g*D)-1)*sqrt(g/D)*t+...
        32/9*1/(G^(1/4)*(U/sqrt(g*D))^2)*...
            (1-1/2*U/sqrt(g*D))^(9/2);
xs = xs*D;
%Evaluate x1 x2 
x1 = t*sqrt(g*D)*(3/2*U/sqrt(g*D)-1);
x2 =-t*sqrt(g*D);
tab=[];
tab = [tab [x0 1]'];
tab = [tab [x2 1]'];
dx = (x1-x2)/101;
x =x2+dx;

while x<=x1
    tab = [tab [x 1/9*(2-x/(t*sqrt(g*D)))^2]'];
    x=x+dx;
end
dx = (xs-x1)/51;
x=x1+dx;
while x<=xs
    tab = [tab [x (9/32*G^(1/4)*(U/sqrt(g*D))^2*(xs-x)/D)^(4/9)]'];
    x=x+dx;
end
tab = [tab [xs 0]'];
    