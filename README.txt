% ME 4133: Machine Design I  |  Shaper Mechanism Project
%
%-------------------------------------------------------------------------%
%
% This package is built to solve the kinematic and dynamic properties of
% the shaper mechanism 2.17 from Stanisic - Mechanisms and Machines, 1st ed.
%
% See the included PNG files for a diagram of the mechanism.
%
% Description of files contained:
%
%-------------------------------------------------------------------------%
% Readme.txt
%
% 	This File
%
%-------------------------------------------------------------------------%
% lengthdata.txt
%
%	Used to specify mechanism parameters for fixed lengths / angles and 
%   initial guesses of unknown lengths and angles.
%
%   FORMAT:
%				R1, theta1
%				R2, theta2
%				R3, theta3
%				R4, theta4
%				R5, theta5
%				R6, theta6
%
%	Units are in meters and degrees.
%
%-------------------------------------------------------------------------%
% massmoidata.txt
%
%	Used to specify rigid body masses and moments of inertia.
%
%	FORMAT:
%
%				Mass 2, Ig 2
%				Mass 3, Ig 3
%				Mass 4, Ig 4
%				Mass 5, Ig 5
%
%	Units are in kg and kg-m^2
%
%-------------------------------------------------------------------------%
% solvemechanism.m  
%
% 	Resolves position and kinematic coefficients for mechanism for a given 
% 	input theta2. Also allows for output of mean condition of Jacobian.
%
%	USE: In command window, call function:
%		
%		 [position, k1, k2, meancond] = solvemechanism(theta2)   (radians)
%
%-------------------------------------------------------------------------%
% GeneratePlots.m
%
% 	Generates plots for position; 1st and 2nd order kinematic coefficients.
%
%	USE: Script. Press F5 to run.
%	
%-------------------------------------------------------------------------%
% DrawMechanism.m
%
%	Draws the mechanism for a given input theta2. Outputs PNG files for
%   each plot in the active MATLAB directory.
%
%	USE: In command window, call function:
%		 
%		 DrawMechanism(theta2)		(radians)
%
%-------------------------------------------------------------------------%
% AnimateMechanism.m
%
%	Produces animation of mechanism through range of motion 0<theta2<2pi
%	Saves an AVI video of the mechanism in the active MATLAB directory.
%
%	USE: Script. Press F5 to run.
%
%-------------------------------------------------------------------------%
% forces_Fknown.m
%
%	Solve IDP to determine forces on mechanism links. This version solves 
%   for T2 and all other reaction forces when there is a known force 
%	applied to the output, rigid body 5.
%
%	USE: In command window, call function:
%
%		 forces_Fknown = forces_Fknown(th2, w2, a2, F5)
%
%		 See m-file for additional information.
%
%-------------------------------------------------------------------------%
% forces_Tknown.m
%
%	Solve IDP to determine forces on mechanism links. This version solves 
%   for the output force at rigid body 5 and all other reaction forces 
%	from a known input torque on link 2.
%
%	USE: In command window, call function:.
%
%		 forces_Tknown = forces_Fknown(th2, w2, a2, T2)
%
%	     See m-file for additional information.
%
%-------------------------------------------------------------------------%
% forceplot.m
%
%   Use to generate plots for IDP solutions
%
%
%-------------------------------------------------------------------------%
% Mass_MOI_Estimation_Utility.m
%
%	MATLAB Script used to estimate Moments of Inertia and masses from
%	mechanism dimensions and density.
%
%	USE: Modify parameters in m-file as needed; press F5 to solve.
%
%-------------------------------------------------------------------------%