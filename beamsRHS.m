
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

function [RHS] = beamsRHS(p, Me, beam_config_matrix, beam_load_matrix, t)
N = 2^p+1;
no_of_beams = size(beam_config_matrix,1);
Nsize = no_of_beams*3*N;
no_of_constraints = max(size(Me))-Nsize;

%get the load as input
q = zeros(Nsize,1);
for ctr=1:no_of_beams
    x = linspace(0,beam_config_matrix(ctr,3),N);
    start = (ctr-1)*3*N;
    for j=1:N
        q(j + start) = beam_load_matrix{ctr,1}(x(j),t); %xload
        q(2*j-1+N + start) = beam_load_matrix{ctr,2}(x(j),t); %yload
        q(2*j+N + start) = beam_load_matrix{ctr,3}(x(j),t); %moment
    end
end
M = Me(1:Nsize,1:Nsize);
RHS = [M*q; zeros(no_of_constraints,1)];
end
