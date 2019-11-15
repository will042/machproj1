function forces_Tknown = forces_Tknown(th2, w2, a2, T2, R4max)
%%------------------------------------------------------------------------%
% Programmed by: William Ard, Hector Arredondo, Miranda Pepper 
%-------------------------------------------------------------------------%
% Goal: Solve IDP to determine forces on mechanism links
%-------------------------------------------------------------------------%
% Inputs:
% 
% th2 = The input angle for which the mechanism is to be solved.
%
%  w2 = Angular Velocity (rad/s) of input (+CCW);
%
%  a2 = Angular Acceleration (rad/s^2) of input link (+CCW);
%
%
%-------------------------------------------------------------------------%
% Outputs:
%
% 
%
%
%
%
%-------------------------------------------------------------------------%


%-------------------------------------------------------------------------%
% Specifications for Mass Calculations

 rho = 7700;     % Density of Steel (kg/m^3)
  A  = .02*.04;  % Cross Sectional Area of Links (m)
  sm = .5;       % Slider Mass; (kg)
  sh = .05;      % Slider Height; (m)
  dm = 1;        % Rigid Body 5 Mass (kg)
  dh = .01;        % Rigid Body 5 Height (m)
  dw = rb5 %width


  
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
  
%-------------------------------------------------------------------------%
% Mass, Moments of Intertia, Gravitational Constant
 
  m = [ 0;
       rho*A*R2;
       sm;
       rho*A*R4max;
       dm];

  g = 9.81; % (m/s^2)  


Ig = [0;
      1/12*m(2)*R2^2;
      1/12*m(3)*sh^2;
      1/12*m(4)*R4max^2
      1/12*m(5)*(dh^2+dw^2];
      
      

%-------------------------------------------------------------------------%
% Resolve angular accelerations of links


a = [0;
     a2;
     k1(4)*a2+k2(4)*w2^2;
     k1(5)*a2+k2(5)*w2^2;
     0];





%-------------------------------------------------------------------------%
% This resolves the maximum length of the R4 link to be used for CG 
% calculation

% range = linspace(0,2*pi,500);
% findR4 = ones(500,2);
% for n = 1:500
%     posrange = solvemechanism(range(n));
%     findR4(n,:) = posrange(4,:);
% end
% R4max = max(findR4(:,1));

%-------------------------------------------------------------------------%

% Center of Gravity Lengths
    
R9   = pos(2,1)/2 ;   % Link 2
    
R10  = R4max/2 ;      % Link 4
  
% % Cartesian Coordinates
% % R2G = [pos(2,1)/2 * cos(pos(2,2)) ; % Link 2
% %        pos(2,1)/2 * sin(pos(2,2))];
% % 
% % R4G = [pos(4,1)/2 * cos(pos(4,2)) ; % Link 4
% %        pos(4,1)/2 * sin(pos(4,2))];
% % 
% % RS  = [pos(2,1) * cos(pos(2,2))  ; % Slider
% %        pos(2,1) * sin(pos(2,2)) ];
% % 
% % RB  = [pos(4,1) * cos(pos(4,2))  ; % Box
% %        pos(4,1) * sin(pos(4,2)) ];
% %    


%-------------------------------------------------------------------------%
% 1st & 2nd Order Kinematic Coefficients of CGs

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

F = [1  0  0  0  0  0  1  0  0  0  0  0;
     0  1  0  0  0  0  0  1  0  0  0  0;
     0  0  0  0  0  0  -R2*sin(th2)  R2*cos(th2)  0  0  0  0;
     0  0  0  0  0  0  -1  0  0  cos(th4+pi/2)  0  0;
     0  0  0  0  0  0  0  -1  0  sin(th4+pi/2)  0  0;
     0  0  0  0  0  0  0  0  1  0  0  0;
     0  0  1  0  0  0  0  0  0  -cos(th4+pi/2)  cos(th4+pi/2)  0;
     0  0  0  1  0  0  0  0  0  -sin(th4+pi/2)  sin(th4+pi/2)  0;
     0  0  0  0  0  0  0  0  -1  -R3  R4  0;
     0  0  0  0  0  0  0  0  0  0  -cos(th4+pi/2)  1;
     0  0  0  0  1  0  0  0  0  0  -sin(th4+pi/2)  0;
     0  0  0  0  0  1  0  0  0  0  0  0];

b = [m(2)*ag(2,1);
     m(2)*ag(2,2);
     -T2+Ig(2)*a(2) + R9(1,1)*cos(th2)*m(2)*g+m(2)*R9(1,1)*(cos(th2)*ag(2,2)-sin(th2)*ag(2,1));
     m(3)*ag(3,1);
     m(3)*ag(3,2)+m(3)*g;
     Ig(3)*a(3);
     m(4)*ag(4,1);
     m(4)*ag(4,2)+m(4)*g;
     Ig(4)*a(4)+m(4)*R10(1,1)*(cos(th4)*ag(4,2)-sin(th4)*ag(4,1));
     m(5)*ag(5,1);
     m(5)*ag(5,2)+m(5)*g;
     Ig(5)*a(5)];

forces_Tknown = F\b;


end
