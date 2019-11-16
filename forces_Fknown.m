function forces_Fknown = forces_Fknown(th2, w2, a2, F5)
%%------------------------------------------------------------------------%
% Programmed by: William Ard
% Louisiana State University, Undergraduate
% Department of Mechanical Engineering
% ward2@lsu.edu
%-------------------------------------------------------------------------%
% Goal: Solve IDP to determine forces on mechanism links
%       This version solves for T2 for a known force applied to the
%       output, rigid body 5.
%-------------------------------------------------------------------------%
% Inputs:
% 
% NOTE: Specify mass and MOI Data in 'massmoidata.txt'. 
%       Format is:     Mass 2, Ig 2    (kg), (kg-m^2)
%                      Mass 3, Ig 3
%                      Mass 4, Ig 4
%                      Mass 5, Ig 5
%
% th2 = The input angle for which the mechanism is to be solved.
%
%  w2 = Angular Velocity (rad/s) of input (+CCW);
%
%  a2 = Angular Acceleration (rad/s^2) of input link (+CCW);
%
%  F5 = Applied force on output. (x-direction, left to right is positive)
%
%
%-------------------------------------------------------------------------%
% Outputs:
%
% A 12x1 matrix of resultant forces:
%
%       [F12x;
%        F12y;
%        F14x;
%        F14y;
%        F15;
%        R8_F15;
%        F23x;
%        F23y;
%        R7_F34;
%        F34;
%        F45;
%        T2]
%
%-------------------------------------------------------------------------%


%-------------------------------------------------------------------------%
% Solve for Position Vectors

[pos, k1, k2] = solvemechanism(th2);

R1 = pos(1,1);
R2 = pos(2,1);
R3 = pos(3,1);
R4 = pos(4,1);
R5 = pos(5,1);
R6 = pos(6,1);
th1 = pos(1,2);
th2 = pos(2,2);
th3 = pos(3,2);
th4 = pos(4,2);
th5 = pos(5,2);
th6 = pos(6,2);
  
R4max = (R1+R6)/cos(asin(R2/R1));


% Read Mass & MOI Data from Text File and Import

fid = fopen('massmoidata.txt','r');
data = fscanf(fid,'%f, %f',[2 4]);
data = data';
fclose(fid);

 m = [0; 0; 0; 0; 0];
Ig = [0; 0; 0; 0; 0];

m(2:5,1) = data(:,1);
Ig(2:5,1) = data(:,2);

 g = 9.81; %(m/s^2)

 
 
 
% Resolve angular accelerations of links
a = [0;
     a2;
     k1(4)*a2+k2(4)*w2^2;
     k1(5)*a2+k2(5)*w2^2;
     0];



% Center of Gravity Lengths   
R9   = pos(2,1)/2 ;   % Link 2
R10  = R4max/2 ;      % Link 4
  




%-------------------------------------------------------------------------%
% 1st & 2nd Order Kinematic Coefficients of CGs

% Format is X,Y

Fg  = [                       0                           0;
                   -R9*sin(th2)                 R9*cos(th2);
                   -R2*sin(th2)                 R2*cos(th2);
       -R10*sin(pos(4,2))*k1(5)     R10*cos(pos(4,2))*k1(5);
                          k1(3)                           0];
       
Fgp = [          0            0;
      -R9*cos(th2) -R9*sin(th2);
      -R2*cos(th2) -R2*sin(th2);
      -R10*cos(pos(4,2))*k1(5)^2-R10*sin(pos(4,2))*k2(5)  -R10*sin(pos(4,2))*k1(5)^2+R10*cos(pos(4,2))*k2(5);
       k2(3)  0];

   
%-------------------------------------------------------------------------%
% Curvilinear Accelerations for CG's

ag=ones(5,2);

for i = 2:5
    ag(i,1) = Fg(i,1)*a2 + Fgp(i,1)*w2^2;
    ag(i,2) = Fg(i,2)*a2 + Fgp(i,2)*w2^2;
end



%-------------------------------------------------------------------------%
% IDP Solution

F = [1  0  0  0  0  0  1  0  0  0  0  0; %Constant Coefficient Matrix
     0  1  0  0  0  0  0  1  0  0  0  0;
     0  0  0  0  0  0  -R2*sin(th2)  R2*cos(th2)  0  0  0  1;
     0  0  0  0  0  0  -1  0  0  cos(th4+pi/2)  0  0;
     0  0  0  0  0  0  0  -1  0  sin(th4+pi/2)  0  0;
     0  0  0  0  0  0  0  0  1  0  0  0;
     0  0  1  0  0  0  0  0  0  -cos(th4+pi/2)  cos(th4+pi/2)  0;
     0  0  0  1  0  0  0  0  0  -sin(th4+pi/2)  sin(th4+pi/2)  0;
     0  0  0  0  0  0  0  0  -1  -R3  R4  0;
     0  0  0  0  0  0  0  0  0  0  -cos(th4+pi/2)  0;
     0  0  0  0  1  0  0  0  0  0  -sin(th4+pi/2)  0;
     0  0  0  0  0  1  0  0  0  0  0  0];

b = [m(2)*ag(2,1);  %RHS of IDP
     m(2)*ag(2,2);
     Ig(2)*a2 + R9*cos(th2)*m(2)*g+m(2)*R9*(cos(th2)*ag(2,2)-sin(th2)*ag(2,1));
     m(3)*ag(3,1);
     m(3)*ag(3,2)+m(3)*g;
     Ig(3)*a(3);
     m(4)*ag(4,1);
     m(4)*ag(4,2)+m(4)*g;
     Ig(4)*a(4)+m(4)*R10*(cos(th4)*ag(4,2)-sin(th4)*ag(4,1));
     -F5+m(5)*ag(5,1);
     m(5)*ag(5,2)+m(5)*g;
     Ig(5)*a(5)];

forces_Fknown = F\b; % Solve Linear System


end
