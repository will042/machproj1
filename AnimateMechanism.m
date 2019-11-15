%%------------------------------------------------------------------------%
% Programmed by: William Ard
%-------------------------------------------------------------------------%
% Goal: Produce Animation of Shaper Mechanism
%-------------------------------------------------------------------------%
% Use: Press F5 to run script.
%
%-------------------------------------------------------------------------%
% Output:
%
% A single figure window will display the mechanism; an AVI video file of
% the animation will be written to the current working MATLAB directory.
%
%-------------------------------------------------------------------------%

range = linspace(0,2*pi,200);

figure(11)
F(200) = struct('cdata',[],'colormap',[]);
for i = 1:200
    DrawMechanism(range(i))
    F(i) = getframe(gcf);
end


v = VideoWriter('2_17_Shaper_Mechanism.avi');
open(v)
writeVideo(v,F)
close(v)