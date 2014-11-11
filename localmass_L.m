
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

function mloc = localmass_L(h)


mloc = zeros(2,2);
mloc(1,1) = h/3;
mloc(1,2) = h/6;
mloc(2,1) = h/6;
mloc(2,2) = h/3;

end


