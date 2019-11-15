function [position, k1, k2, meancond] = solvemechanism(th2)
%%------------------------------------------------------------------------%
% Programmed by: William Ard, Hector Arredondo, Miranda Pepper 
%-------------------------------------------------------------------------%
% Goal: Resolve position and kinematic coefficients for mechanism
%-------------------------------------------------------------------------%
% Inputs:
% 
% Link sizes and initial guesses may be specified in 'parameters.txt'.
% There are 6 vectors for the mechanism. Each row of the text file
% corresponds to a single vector in polar form. The first element specifies
% the magnitude of the vector, and the second specifies the angle in
% radians.
%
% th2 = The input angle (radians) for which the mechanism is to be solved.
%
%-------------------------------------------------------------------------%
% Outputs:
%
% position  =   A 6x2 matrix corresponding to the magnitude and angle of
%               each vector (angle is in radians)
%
%       k1  =   A 5x1 matrix corresponding to the first order kinematic
%               coefficients [f3; f4; f5; h3; h4]
%
%       k2  =   A 5x1 matrix corresponding to the second order kinematic
%               coefficients [f3'; f4'; f5'; h3'; h4']
%
%-------------------------------------------------------------------------%

%% Get link size and initial guesses from position.txt

fid = fopen('position.txt','r');
links = fscanf(fid,'%f, %f',[2 6]);
links = links';
fclose(fid);

R = links(:,1);
th = links(:,2)/180*pi; % Convert Degrees to Radians
th(2) = th2;

if R(2)*sin(th2) >= R(6) && th2 < pi
         position = [NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN];
               k1 = [NaN; NaN; NaN; NaN; NaN];
               k2 = [NaN; NaN; NaN; NaN; NaN];
         meancond = -50;
         fprintf('Theta 2 = %6.2f      Invalid Mechanism Configuration\n', th2*180/pi)

elseif R(2)*sin(th2) <= -1*R(1) && th2 > pi
         position = [NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN; NaN NaN];
               k1 = [NaN; NaN; NaN; NaN; NaN];
               k2 = [NaN; NaN; NaN; NaN; NaN];
         meancond = -50;
         fprintf('Theta 2 = %6.2f      Invalid Mechanism Configuration\n', th2*180/pi)

else  % Solve Mechanism
%% Vector Loops and Jacobian
%
%  Note: Each element of x corresponds to a value to be solved via
%  Newton-Raphson method. x = [R3, R4, R5, th3, th4]

f = @(x)    [R(2)*cos(th(2)) - x(1)*cos(x(4));
             R(2)*sin(th(2)) - x(1)*sin(x(4)) + R(1);
             x(3) - x(2)*cos(x(5));
             R(6) - x(2)*sin(x(5)) + R(1);
             x(5) - x(4) ];

J = @(x)    [-cos(x(4))               0      0         x(1)*sin(x(4))                    0 ;
             -sin(x(4))               0      0        -x(1)*cos(x(4))                    0 ;
                      0      -cos(x(5))      1                      0       x(2)*sin(x(5)) ;
                      0      -sin(x(5))      0                      0      -x(2)*cos(x(5)) ;
                      0               0      0                     -1                    1 ;];
               
                  
%% Solve Using Newton Raphson

tol = 1;
n = 1;
x_old = [R(3); R(4); R(5); th(3); th(4)];
while tol >= .01 % Set tolerance for solution here
    
%     if rcond(J(x_old))<.001
%           x_new=[NaN NaN NaN NaN NaN];
%           disp('invalid configuration')
%        break
%     end

    x_new = x_old - J(x_old)\(f(x_old));

    tol = norm(x_new - x_old) / norm(x_new);

    x_old = x_new;
    
    conditn(n)=cond(J(x_new));
    
    n = n+1;
    
end  

R(3)  = x_new(1);
R(4)  = x_new(2);
R(5)  = x_new(3);
th(3) = x_new(4);
th(4) = x_new(5);


meancond=nearest(mean(conditn));

if meancond>20000
    fprintf('Theta 2 = %6.2f        Mean Condition = %11d        Iterations = %2d       (WARNING: NUMERICAL SYSTEM UNSTABLE)\n', th2/pi*180, meancond, n)
else
    fprintf('Theta 2 = %6.2f        Mean Condition = %11d        Iterations = %2d\n', th2/pi*180, meancond, n)
end

position = [R, th]; % Solution for mechanism position


%% 1st Order Kinematic Coefficients

f2 = @(x)   [ R(2)*sin(th(2)) ;
             -R(2)*cos(th(2)) ;
                        0 ;
                        0 ;
                        0 ;];

k1 = J(x_new)\f2(x_new);


%% 2nd Order Kinematic Coefficients

f3 = @(x)   [R(2)*cos(th(2))-2*x(1)*x(4)*sin(th(3))-R(3)*x(4)^2*cos(th(2));
             R(2)*sin(th(2))+2*x(1)*x(4)*cos(th(3))-R(3)*x(4)^2*sin(th(2));
                            -2*x(2)*x(5)*sin(th(4))-R(4)*x(5)^2*cos(th(4));
                             2*x(2)*x(5)*cos(th(4))-R(4)*x(5)^2*sin(th(4));
                                                                        0];

k2 = J(x_new)\f3(k1);


end
end
