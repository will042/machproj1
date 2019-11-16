%%------------------------------------------------------------------------%
% Programmed by: William Ard
% Louisiana State University, Undergraduate
% Department of Mechanical Engineering
% ward2@lsu.edu
%-------------------------------------------------------------------------%
% Goal: Estimate mass & MOI for input file massmoidata.txt
%-------------------------------------------------------------------------%
% Use: Press F5 to run script
%
%-------------------------------------------------------------------------%
% Output:
%
%       m = masses (kg) (Rigid Bodies 2-5)
%
%      Ig = MOI's (kg*m^2) (Rigid Bodies 2-5)
%
%
%   Note: Row number corresponds to rigid body number
%
%-------------------------------------------------------------------------%

[pos, k1, k2] = solvemechanism(0);

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


rho = 7700;     % Density of Steel (kg/m^3)
  A  = .02*.02;  % Cross Sectional Area of Links (m)
  sh = .03;      % Slider Height (m)
  sw = .02;      % Slider Width (m)
  dh = .05;      % Rigid Body 5 Height (m)
  dw = .07;      % Rigid Body 5 Width (m)

  sm = .2;       % Slider Mass (kg)
  dm = 5;        % Rigid Body 5 Mass (kg)
  
  
  m = [ 0;
       rho*A*R2;
       sm;
       rho*A*R4max;
       dm]

Ig = [0;
      1/12*m(2)*R2^2;
      1/12*m(3)*(sh^2*sw^2);
      1/12*m(4)*R4max^2
      1/12*m(5)*(dh^2+dw^2)]