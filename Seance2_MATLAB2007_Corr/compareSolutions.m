clear all 
close all
restoredefaultpath
addpath('src/solver','src/postprocess','src/kernel','src/Initialisation',...
            'src/DamBreakChansonSol','src/CheckAnswers')
load('Validation_DamBreak/Data_Table_Martin_1952_n2_2.mat')

POS  = [1,2];
BOUND =2;
INFO = 6;
lx=0.5;
ly=1;
g=9.81;


folderName=strcat('Results/DamBreak_dr40');
listFiles = dir(strcat(folderName,'/Data/*.mat'));
dr = ly/40;
THXdr40=[];
for i=1:size(listFiles,1)
    load(strcat(listFiles(i).folder,'/',listFiles(i).name));
    Hmax = max(part(:,POS(2)).*(BOUND-part(:,INFO))/BOUND)+dr/2;
    Xmax = max(part(:,POS(1)).*(BOUND-part(:,INFO))/BOUND)+dr/2;
    THXdr40 = [THXdr40 [t Hmax Xmax]'];
end

folderName=strcat('Results/DamBreak_dr20');
listFiles = dir(strcat(folderName,'/Data/*.mat'));
dr = ly/20;
THXdr20=[];
for i=1:size(listFiles,1)
    load(strcat(listFiles(i).folder,'/',listFiles(i).name));
    Hmax = max(part(:,POS(2)).*(BOUND-part(:,INFO))/BOUND)+dr/2;
    Xmax = max(part(:,POS(1)).*(BOUND-part(:,INFO))/BOUND)+dr/2;
    THXdr20 = [THXdr20 [t Hmax Xmax]'];
end

folderName=strcat('Results/DamBreak_dr10');
listFiles = dir(strcat(folderName,'/Data/*.mat'));
dr = ly/10;
THXdr10=[];
for i=1:size(listFiles,1)
    load(strcat(listFiles(i).folder,'/',listFiles(i).name));
    Hmax = max(part(:,POS(2)).*(BOUND-part(:,INFO))/BOUND)+dr/2;
    Xmax = max(part(:,POS(1)).*(BOUND-part(:,INFO))/BOUND)+dr/2;
    THXdr10 = [THXdr10 [t Hmax Xmax]'];
end

fig = figure(2);
plot(damb2ZT(:,2),damb2ZT(:,1),'ks','MarkerFaceColor','k','MarkerSize',8)
hold on
plot(damb1ZT(:,2),damb1ZT(:,1),'bo','MarkerFaceColor','b','MarkerSize',8)
plot(THXdr40(1,:)*sqrt(2*norm(g)/lx),THXdr40(3,:)/lx,'-r','LineWidth',2)
plot(THXdr20(1,:)*sqrt(2*norm(g)/lx),THXdr20(3,:)/lx,'-k','LineWidth',2)
plot(THXdr10(1,:)*sqrt(2*norm(g)/lx),THXdr10(3,:)/lx,'-b','LineWidth',2)

%plot(THX(1,:)*sqrt(2*norm(g)/lx),(THX(3,:)-dr)/lx,'-k','LineWidth',1)
xlabel('$t\sqrt{2g/l_x}$','Interpreter','latex' )
ylabel('$x_{max}/l_x$','Interpreter','latex' )
legend('Exp. Martin&Moyce 1952, 1.125 in','Exp. Martin&Moyce 1952, 2.25 in',...
    'SPHLab ly/dr=40','SPHLab ly/dr=20','SPHLab ly/dr=10',...
    'Location','northwest')
xlim([0 3.2])
ylim([1 4])
drawnow
hold off
fig = figure(3);
plot(damb2HT(:,2),damb2HT(:,1),'ks','MarkerFaceColor','k','MarkerSize',8)
hold on
plot(damb1HT(:,2),damb1HT(:,1),'bo','MarkerFaceColor','b','MarkerSize',8)
plot(THXdr40(1,:)*sqrt(norm(g)/lx),THXdr40(2,:)/ly,'-r','LineWidth',2)
plot(THXdr20(1,:)*sqrt(norm(g)/lx),THXdr20(2,:)/ly,'-k','LineWidth',2)
plot(THXdr10(1,:)*sqrt(norm(g)/lx),THXdr10(2,:)/ly,'-b','LineWidth',2)
xlabel('$t\sqrt{g/l_x}$','Interpreter','latex' )
ylabel('$H_{max}/l_y$','Interpreter','latex' )
legend('Exp. Martin&Moyce 1952, 1.125 in','Exp. Martin&Moyce 1952, 2.25 in',...
    'SPHLab ly/dr=40','SPHLab ly/dr=20','SPHLab ly/dr=10',...
    'Location','northeast')
xlim([0 3.2/sqrt(2)])
ylim([0.4 1])
drawnow
hold off