
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


function mloc= localmass_T(h)
    
    mloc = h * [13/35, 11/210*h, 9/70, -13/420*h;...
                11/210*h, 1/105*h*h, 13/420*h, -1/140*h*h;...
                9/70, 13/420*h, 13/35, -11/210*h;...
                -13/420*h, -1/140*h*h, -11/210*h, 1/105*h*h];
            
    

end

