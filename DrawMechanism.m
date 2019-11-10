function DrawMechanism(th2)
%%------------------------------------------------------------------------%
% Programmed by: William Ard
%-------------------------------------------------------------------------%
% Goal: Draw mechanism for a given input of theta 2
%-------------------------------------------------------------------------%
% Inputs:
%
% th2 = Angle for which mechanism is to be drawn (in radians)
%
% Note: This script uses the solvemechanism() function to resolve the 
% position of the mechanism for a full 360 degrees of rotation. Link 
% lengths and initial guesses can be specified in the 'position.txt' file. 
% See 'solvemechanism.m' for more information.
%
%-------------------------------------------------------------------------%
% Output:
%
% A single figure window will display the mechanism.
%
%-------------------------------------------------------------------------%


%% Generate Cartesian Coordinates for All Vectors

Rx = ones(6,1);         %Preallocate for Computational Efficiency
Ry = ones(6,1);

point = solvemechanism(th2);

for i = 1:6
    Rx(i) = point(i,1)*cos(point(i,2));
    Ry(i) = point(i,1)*sin(point(i,2));
end


%% Produce Coordinates for Slider Mechanism

w = .2;  % Width of Slider
h = .5;  % Height of Slider

th3 = point(3,2);
P1  = [point(3,1)-h/2, point(3,2)];
P1x = Rx(1)+P1(1,1)*cos(P1(1,2));
P1y = Ry(1)+P1(1,1)*sin(P1(1,2));
P2x = P1x+w*cos(th3+pi/2);
P2y = P1y+w*sin(th3+pi/2);
P3x = P2x+h*cos(th3);
P3y = P2y+h*sin(th3);
P4x = P3x+2*w*cos(th3-pi/2);
P4y = P3y+2*w*sin(th3-pi/2);
P5x = P4x-h*cos(th3);
P5y = P4y-h*sin(th3);


%% Produce Coordinates for Box

wb = 1.2  ;   % Width of Box
hb = .8  ;   % Height of Box

Cx = Rx(1)+Rx(4); % Center of Box
Cy = Ry(1)+Ry(4);
P6x = Cx-wb/2;
P6y = Cy-hb/2;
P7x = P6x;
P7y = P6y+hb;
P8x = P7x+wb;
P8y = P7y;
P9x = P8x;
P9y = P8y-hb;


%% Determine Axes Limits

% Find the longest vector corresponding to the height of the mechanism and
% add 1 for padding. Plot is drawn on 1:1 scale, so axes limits are set 
% with one value, 'dim'.

dim = ceil(max(abs(Ry(1)), abs(Ry(6))))+1; 


%% Generate Plot

plot(   [Rx(1) Rx(1)+Rx(4)], [Ry(1) Ry(1)+Ry(4)], '-o', ...
        [0 Rx(2)], [0 Ry(2)], '-o', ...
        [-dim dim], [Ry(6)-hb/2-.1 Ry(6)-hb/2-.1], '--', ...
        [P1x P2x P3x P4x P5x P1x], [P1y P2y P3y P4y P5y P1y], ...
        [P6x P7x P8x P9x P6x], [P6y P7y P8y P9y P6y], 'LineWidth', 1)
    ylim([-dim dim]);
    xlim([-dim dim]);
    xlabel('x')
    ylabel('y')
    pbaspect([1 1 1])
    text = sprintf('\x03b8_2 = %2.0f\x00BA', th2/pi*180);     
    delete(findall(gcf,'type','annotation'))
    annotation('textbox',[.7 .0 .1 .2],'String',text,'FitBoxToText', 'on','EdgeColor', 'none')
    grid

   