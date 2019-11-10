% function forces = forces([th2 w2 a2)
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
%-------------------------------------------------------------------------%

th2 = pi/4;
w2 = 1;
a2 = 0;

[pos, k1, k2] = solvemechanism(th2);




%% This resolves the maximum length of the R4 link to be used for CG calculation

range = linspace(0,2*pi,500);
R4 = ones(500,2);
for n = 1:500
    posrange = solvemechanism(range(n));
    R4(n,:) = posrange(4,:);
end
R4max = max(R4(:,1));



%% Center of Gravity Locations
    
R2G = [pos(2,1)/2 pos(2,2)] ;   % Link 2
    
R4G = [R4max/2 pos(4,2)] ;      % Link 4

RS  = [pos(2,1) pos(2,2)]  ;    % Slider

RB  = [pos(4,1) pos(4,2)]  ;    % Box
   
  
% R2G = [pos(2,1)/2 * cos(pos(2,2)) ; % Link 2
%        pos(2,1)/2 * sin(pos(2,2))];
% 
% R4G = [pos(4,1)/2 * cos(pos(4,2)) ; % Link 4
%        pos(4,1)/2 * sin(pos(4,2))];
% 
% RS  = [pos(2,1) * cos(pos(2,2))  ; % Slider
%        pos(2,1) * sin(pos(2,2)) ];
% 
% RB  = [pos(4,1) * cos(pos(4,2))  ; % Box
%        pos(4,1) * sin(pos(4,2)) ];
%    