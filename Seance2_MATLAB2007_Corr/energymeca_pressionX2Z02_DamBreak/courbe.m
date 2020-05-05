
a01=xlsread('alpha0010_delta02');
a007=xlsread('alpha007_delta02');
a005=xlsread('alpha005_delta02');
a003=xlsread('alpha003_delta02');
a001=xlsread('alpha001_delta02');

d02=xlsread('alpha0010_delta02');
d03=xlsread('alpha0010_delta03');
d04=xlsread('alpha0010_delta04');
d05=xlsread('alpha0010_delta05');
d06=xlsread('alpha0010_delta06');

figure(1);
t=a01(:,1);
y1=(a01(:,2)-a01(1,2))/a01(1,2)*100;
y2=(a007(:,2)-a007(1,2))/a007(1,2)*100;
y3=(a005(:,2)-a005(1,2))/a005(1,2)*100;
y4=(a003(:,2)-a003(1,2))/a003(1,2)*100;
y5=(a001(:,2)-a001(1,2))/a001(1,2)*100;

c=jet(12);
plot(t,y1,'Color',c(1,:),'LineWidth',1)
hold on;
plot(t,y2,'Color',c(4,:),'LineWidth',1)
plot(t,y3,'Color',c(7,:),'LineWidth',1)
plot(t,y4,'Color',c(10,:),'LineWidth',1)
plot(t,y5,'Color',c(12,:),'LineWidth',1)
hold off;
legend('$\alpha=0.10$','$\alpha=0.07$','$\alpha=0.05$','$\alpha=0.03$',...
    '$\alpha=0.01$','Interpreter','latex');%
xlabel('$Time /s$','Interpreter','latex' );
ylabel('$Energy\ Loss\ Rate\%$','Interpreter','latex' );
title('delta=0.2 Energy Loss Rate','Interpreter','latex' );
ylim([-10,16]);

figure(2);
t=d02(:,1);
y1=(d02(:,2)-d02(1,2))/d02(1,2)*100;
y2=(d03(:,2)-d03(1,2))/d03(1,2)*100;
y3=(d04(:,2)-d04(1,2))/d04(1,2)*100;
y4=(d05(:,2)-d05(1,2))/d05(1,2)*100;
y5=(d06(:,2)-d06(1,2))/d06(1,2)*100;

c=jet(12);
plot(t,y1,'Color',c(1,:),'LineWidth',1)
hold on;
plot(t,y2,'Color',c(4,:),'LineWidth',1)
plot(t,y3,'Color',c(7,:),'LineWidth',1)
plot(t,y4,'Color',c(10,:),'LineWidth',1)
plot(t,y5,'Color',c(12,:),'LineWidth',1)
hold off;
legend('$\delta=0.2$','$\delta=0.3$','$\delta=0.4$','$\delta=0.5$',...
    '$\delta=0.6$','Interpreter','latex');%
xlabel('$Time /s$','Interpreter','latex' );
ylabel('$Energy\ Loss\ Rate\%$','Interpreter','latex' );
title('alpha=0.10 Energy Loss Rate','Interpreter','latex' );
ylim([-10,16]);



