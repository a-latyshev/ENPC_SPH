function check = checkQuestion3b(part,SPID)
if max(part(:,SPID))== 1
    comm = sprintf('3-b) You have not changed the function yet... go to src/solver/sortPart...');
    disp(comm);
    check=false;
elseif  max(part(2:end,SPID)-part(1:end-1,SPID)) >1 
    comm = sprintf('3-b) There is an error. You seem to skip spaces...');
    disp(comm);
    check=false;
else
    comm = sprintf('3-b) It seems good!');
    disp(comm);
    check=true;
end