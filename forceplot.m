range=linspace(0,2*pi,360);
fres = linspace(0,360,360);

range = linspace(0,2*pi,360);
findR4 = ones(500,2);
for n = 1:360
    posrange = solvemechanism(range(n));
    findR4(n,:) = posrange(4,:);
end
R4max = max(findR4(:,1));


for i = 1:360
     th = range(i);
     forces=forces_Tknown(th, 0, 0, 10, R4max);
     fres(i)=forces(12);
 end
% 
% for i = 208:333
%     th = range(i);
%     forces=forces_Fknown(th, 4, 10, R4max);
%     fres(i)=forces(12);
% end
% 
% for i = 334:360
%     th = range(i);
%     forces=forces_Fknown(th, 4, -10, R4max);
%     fres(i)=forces(12);
% end

figure(15)
plot(range./pi*180,fres)
grid
xlim([0 360])
xticks(0:30:360)