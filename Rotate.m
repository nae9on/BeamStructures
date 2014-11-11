
%{ 
This file is a part of the project that we did in our 
Masters Program COSSE - Computer Simulations for Science and Engineering
at the Technische Universität Berlin.

Advisor 
Dr. Michael Karow 

Students
1. Ali Kadar
2. Andrzej Jaeschke
3. Bastiaan van der Boor
4. Leo Koop
5. Yunyi Zhu

email: 
1. kadar@math.tu-berlin.de
4. leokoop@gmail.com

Driver File: simulation.m 
%}

function [curve_rotated] = Rotate(phi,curve_local)
n = max(size(curve_local))/2;
x1_loc = curve_local(1:n,1);
y1_loc = curve_local(n+1:2*n,1);
x1_glo = cos(phi)*(x1_loc) - sin(phi)*y1_loc;
y1_glo = sin(phi)*(x1_loc) + cos(phi)*y1_loc;
curve_rotated = [x1_glo; y1_glo];
end
