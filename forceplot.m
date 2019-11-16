range = linspace(0,2*pi,360);

for i = 1:360
     th = range(i);
     forces=forces_Fknown(th, 0, 0, 10);
     fres(:,i)=forces;
 end


figure(15)
plot(range./pi*180,fres,'LineWidth',1)
title('Required Torque for 5kg Mass')
grid
xlim([0 360])
xticks(0:30:360)
xlabel('\theta_2 (deg)')
ylabel('Torque (N-m)')
legend('F12x', 'F12y', 'F14x', 'F14y', 'F15', 'R8_F15', 'F23x', 'F23y', 'R7_F34', 'F34', 'F45', 'T2')