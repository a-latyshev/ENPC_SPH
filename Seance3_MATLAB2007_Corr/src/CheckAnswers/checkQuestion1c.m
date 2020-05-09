function check = checkQuestion1c(part,N)
global INFO FLUID BOUND
if N==15
    comm = sprintf('You created %i particles',size(part,1));
    disp(comm);
    comm = sprintf('%i FLUID',size(part(part(:,INFO)==FLUID),1));
    disp(comm);
    comm = sprintf('%i BOUND',size(part(part(:,INFO)==BOUND),1));
    disp(comm);
    
    if  size(part(part(:,INFO)==BOUND),1)==128 && size(part(part(:,INFO)==FLUID),1)==256
        comm = sprintf('1-b) All good!');
        disp(comm);
        check=true;
    else
        comm = sprintf('1-b) There is an error...');
        disp(comm);
        check=false;
    end
end
check = true;