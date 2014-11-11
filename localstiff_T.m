
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


function sloc_T = localstiff_T(h)
c = 1/h^3;

sloc_T = c * [12, 6*h, -12, 6*h;...
             6*h, 4*h*h, -6*h, 2*h*h;...
           -12, -6*h, 12, -6*h;...
             6*h, 2*h*h, -6*h, 4*h*h];
end

