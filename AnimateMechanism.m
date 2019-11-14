range = linspace(0,2*pi,200);

figure(11)
F(200) = struct('cdata',[],'colormap',[]);
for i = 1:200
    DrawMechanism(range(i))
    F(i) = getframe(gcf);
end

% 
% v = VideoWriter('2_17_new3.avi');
% open(v)
% writeVideo(v,F)
% close(v)