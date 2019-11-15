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

TFx = isnan(Rx);
TFy = isnan(Ry);
Rx(TFx) = 0;
Ry(TFy) = 0;
for i = 1:6
    if TFx(i) == 1 || TFy(i) ==1
        flag = 1;
    else
        flag = 0;
    end
end


%% Produce Coordinates for Slider

w = .024;  % Width of Slider (m)
h = .059;  % Height of Slider (m)

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


%% Produce Coordinates for Rigid Body 5

wb = .14  ;   % Width (m)
hb = .095  ;   % Height (m)

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
% add 10% for padding. Plot is drawn on 1:1 scale, so axes limits are set 
% with one value, 'dim'.

dim = max([abs(Ry(1)), abs(Ry(6)), abs(Rx(4))])+.2*max([abs(Ry(1)), abs(Ry(6)), abs(Rx(4))]); 


%% Generate Plot
if flag == 1
    plot(0,0, '--', 'LineWidth', 1)
    xlabel('x (m)')
    ylabel('y (m)')
    title('Shaper Mechanism')
    pbaspect([1 1 1])
    text = sprintf('\x03b8_2 = %2.0f\x00BA', th2/pi*180);    
    text2 = sprintf('Error: Invalid Configuration');
    delete(findall(gcf,'type','annotation'))
    annotation('textbox',[.7 .0 .1 .2],'String',text,'FitBoxToText', 'on','EdgeColor', 'none')
    annotation('textbox',[.35 .5 .1 .1],'String',text2,'EdgeColor', 'none')

else 
plot(   [Rx(1) Rx(1)+Rx(4)], [Ry(1) Ry(1)+Ry(4)], '-o', ...
        [0 Rx(2)], [0 Ry(2)], '-o', ...
        [-dim dim], [Ry(6)-hb/2 Ry(6)-hb/2], '--', ...
        [P1x P2x P3x P4x P5x P1x], [P1y P2y P3y P4y P5y P1y], ...
        [P6x P7x P8x P9x P6x], [P6y P7y P8y P9y P6y], 'LineWidth', 1)
    ylim([-dim dim]);
    xlim([-dim dim]);
    title('Shaper Mechanism')
    xlabel('x (m)')
    ylabel('y (m)')
    pbaspect([1 1 1])
    text = sprintf('\x03b8_2 = %2.0f\x00BA', th2/pi*180);     
    delete(findall(gcf,'type','annotation'))
    annotation('textbox',[.7 .0 .1 .2],'String',text,'FitBoxToText', 'on','EdgeColor', 'none')
    grid
end
   