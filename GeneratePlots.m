%%                    Kinematics Plot Generator                          %%
%%------------------------------------------------------------------------%
% Programmed by: William Ard
% Louisiana State University, Undergraduate
% Department of Mechanical Engineering
% ward2@lsu.edu
%-------------------------------------------------------------------------%
% Goal: Generate plots of position, and 1st/2nd order kinematic
% coefficients with respect to theta 2
%-------------------------------------------------------------------------%
% Use: Press F5 to run script.
%-------------------------------------------------------------------------%
% Inputs:
%
% Note: This script uses the solvemechanism() function to resolve the 
% position and kinematic coefficients of the mechanism for a full 360 
% degrees of rotation. Link lengths and initial guesses can be specified 
% in the 'position.txt' file. See 'solvemechanism.m' for more information.
%
%-------------------------------------------------------------------------%
% Outputs:
%
% A single figure window will show all plots for position, as well as 
% first and second order kinematic coefficients. Executing this script
% will also generate png files for each individual plot. Files will be
% saved in the same directory the script is executed in.
%
%-------------------------------------------------------------------------%


% Preallocate for computational efficiency

Rx = ones(6,500);
Ry = ones(6,500);
 R = ones(6,500);
th = ones(6,500);
kin1 = ones(5,500);
kin2 = ones(5,500);
    
% Generate matricies that represent polar coordinates, as well as 
% cartesian coordinates for 0 <= th2 <= 2pi

range = linspace(0,2*pi,500);


for i = 1:6
    for n = 1:500
    [pos, k1, k2, meancond] = solvemechanism(range(n));
    
    % Cartesian coordinates
    Rx(i,n) = pos(i,1)*cos(pos(i,2));
    Ry(i,n) = pos(i,1)*sin(pos(i,2));
      
    %Polar coordinates
    R(i,n) = pos(i,1);
    th(i,n) = pos(i,2);
    
    %1st order kinematic coefficients
    kin1(:,n)=k1(:,1);
    
    %2nd order kinematic coefficients
    kin2(:,n)=k2(:,1);
    
    
    meancondition(n)=meancond;
    
    end
end

range = range/pi*180;


%% Export all Plots to PNG files

VectPos = figure('visible','off');
    plot(range,R(3,:),range,R(4,:),range,R(5,:), 'LineWidth',1)
    title('Position Vector Length vs Input Angle \theta_2')
    xlabel('Input Angle \theta_2 (deg)')
    ylabel('Vector Length (m)')
    xlim([0 360])
    xticks(0:30:360)
    legend('R3','R4','R5','Location','SouthEast')
    grid
    print(VectPos,'-dpng', 'Plot - VectPos.png')
    
AnglePos = figure('visible','off');
    plot(range, th(3,:)*180/pi, 'LineWidth',1)
    title('Link Angle \theta_4 vs Input Angle \theta_2')
    xlabel('Input Angle \theta_2 (deg)')
    ylabel('Link Angle (deg)')
    xlim([0 360])
    ylim([0 180])
    xticks(0:30:360)
    yticks(0:30:180)
    grid    
    print(AnglePos,'-dpng', 'Plot - AnglePos.png')
    
VectorKin1 = figure('visible','off');
    plot(range,kin1(1,:),range,kin1(2,:),range,kin1(3,:), 'LineWidth',1)
    title('1st Order Kinematic Coefficients - Vectors')
    xlabel('Input Angular Velocity \omega_2 (deg/s)')
    ylabel('Vector Speed (m/s)')
    xlim([0 360])
    xticks(0:30:360)
    legend('f3','f4','f5','Location','NorthWest')
    grid
    print(VectorKin1,'-dpng', 'Plot - VectorKin1.png')

AngleKin1 = figure('visible','off');
    plot(range,kin1(5,:)*180/pi, 'LineWidth',1)
    title('1st Order Kinematic Coefficients - Angular')
    xlabel('Input Angular Velocity \omega_2 (deg/s)')
    ylabel('Angular Velocity (deg/s)')
    xlim([0 360])
    xticks(0:30:360)
    grid
    print(AngleKin1,'-dpng', 'Plot - AngleKin1.png')

VectorKin2 = figure('visible','off');
    plot(range,kin2(1,:),range,kin2(2,:),range,kin2(3,:), 'LineWidth',1)
    title('2nd Order Kinematic Coefficients - Vectors')
    xlabel('Input Angular Acceleration \alpha_2 (deg/s^2)')
    ylabel('Vector Acceleration (m/s^2)')
    xlim([0 360])
    xticks(0:30:360)
    legend('f3p','f4p','f5p','Location','NorthWest')
    grid
    print(VectorKin2,'-dpng', 'Plot - VectorKin2.png')

AngleKin2 = figure('visible','off');
    plot(range,kin2(5,:)*180/pi, 'LineWidth',1)
    title('2nd Order Kinematic Coefficients - Angular')
    xlabel('Input Angular Acceleration \alpha_2 (deg/s^2)')
    ylabel('Angular Acceleration (deg/s^2)')
    xlim([0 360])
    xticks(0:30:360)
    grid
    print(AngleKin2,'-dpng', 'Plot - AngleKin2.png')
    
    
    
    
    
    
    
%% Display all Plots on Single Figure Window
 
figure(7)
set(gcf, 'Position',  [100, 100, 1500, 700])

VPos=subplot(2,3,1);
    plot(range,R(3,:),range,R(4,:),range,R(5,:), 'LineWidth',1)
    title('Position Vector Length vs Input Angle \theta_2')
    xlabel('Input Angle \theta_2 (deg)')
    ylabel('Vector Length (m)')
    xlim([0 360])
    xticks(0:60:360)
    legend('R3','R4','R5','Location','SouthEast')
    grid


APos=subplot(2,3,4);
    plot(range, th(3,:)*180/pi, 'LineWidth',1)
    title('Link Angle \theta_4 vs Input Angle \theta_2')
    xlabel('Input Angle \theta_2 (deg)')
    ylabel('Link Angle (deg)')
    xlim([0 360])
    ylim([0 180])
    xticks(0:60:360)    
    yticks(0:30:180)  
    grid    
    
VK1=subplot(2,3,2);
    plot(range,kin1(1,:),range,kin1(2,:),range,kin1(3,:), 'LineWidth',1)
    title('1st Order Kinematic Coefficients - Vectors')
    xlabel('Input Angular Velocity \omega_2 (deg/s)')
    ylabel('Vector Speed (m/s)')
    xlim([0 360])
    xticks(0:60:360)
    legend('f3','f4','f5','Location','NorthWest')
    grid

AK1=subplot(2,3,5);
    plot(range,kin1(5,:)*180/pi, 'LineWidth',1)
    title('1st Order Kinematic Coefficients - Angular')
    xlabel('Input Angular Velocity \omega_2 (deg/s)')
    ylabel('Angular Velocity (deg/s)')
    xlim([0 360])
    xticks(0:60:360)
    grid
    
    
VK2=subplot(2,3,3);
    plot(range,kin2(1,:),range,kin2(2,:),range,kin2(3,:), 'LineWidth',1)
    title('2nd Order Kinematic Coefficients - Vectors')
    xlabel('Input Angular Acceleration \alpha_2 (deg/s^2)')
    ylabel('Vector Acceleration (m/s^2)')
    xlim([0 360])
    xticks(0:60:360)
    legend('f3''','f4''','f5''','Location','NorthWest')
    grid

AK2=subplot(2,3,6);
    plot(range,kin2(5,:)*180/pi, 'LineWidth',1)
    title('2nd Order Kinematic Coefficients - Angular')
    xlabel('Input Angular Acceleration \alpha_2 (deg/s^2)')
    ylabel('Angular Acceleration (deg/s^2)')
    xlim([0 360])
    xticks(0:60:360)
    grid
    

% Uncomment the code below to display a plot of the average condition of
% the Jacobian to assess numerical stability of system

% figure
% plot(range,meancondition)
% title('Mean Condition')
% xlabel('Theta 2')
% ylabel('Mean Condition')
% xticks(0:30:360)
