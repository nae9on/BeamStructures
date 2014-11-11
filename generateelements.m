
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

function [ nelement, npoint, e2p ] = generateelements( x )
npoint = length(x);
nelement = npoint - 1;

e2p = zeros(nelement, 2);
e2p(:, 1) = 1 : (npoint-1);
e2p(:, 2) = 2:npoint;

end

