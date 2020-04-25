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
% W : Kernel Wendland
% res = W(q,aW,d,h)
% INPUTS : 
%   q = r/h is the nondimensional radius and res = 0 if q>2
%       q can be a vector or a matrix.
%   aW = normalization constant 
%   d = spatial dimension
%   h = attenuation length
% OUTPUT
%   res = value of w(q)
function res = W(q,aW,d,h)
%Kernel 
q(q>2)=2; % THIS LINE FORCE q LARGER THAN 2 TO 2
%res = zeros(size(q));
% COMPLETE HERE
% Hint : use .^ and .* to make the calculation vectorial
res = aW/h^d*(1 - q/2).^4.*(1 + 2*q);
% END 
% When you are done you can comment the line:  res = zeros(size(q));
