
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

function [Se, Me, x, h] = beamsLHS(p, E_bulk_modulus, I_mass_moment, Area, beam_config_matrix, out3, out4, out5, out6)

phi = beam_config_matrix(:,4);
no_of_beams = size(beam_config_matrix,1);

N=2^p+1;
Nsize = no_of_beams*3*N;

%adding 100 dummy constraints to start with
C = zeros(100,Nsize);
c_count = 0;

no_seperation_between_beams = out3;
no_rotation_between_beams   = out4;
no_seperation_from_wall = out5;
no_rotation_about_wall = out6;

%defining internal constraints
%no_seperation_between_beams = [1 2];
for i1 = 1:size(no_seperation_between_beams,1)
    m = no_seperation_between_beams(i1,1);
    n = no_seperation_between_beams(i1,2);
    
    if (no_seperation_between_beams(i1,3) == 1) && (no_seperation_between_beams(i1,4) == 0)
        
        c_count = c_count +1;
        
        start = (m-1)*3*N;
        C(c_count,start + N) = cos(phi(m));  %1
        C(c_count,start + 3*N-1) = -sin(phi(m)); %1
    
        start = (n-1)*3*N;
        C(c_count,start + 1) = -cos(phi(n)); %0
        C(c_count,start + N+1) = sin(phi(n)); %0
    
    
        c_count = c_count +1;
    
        start = (m-1)*3*N;
        C(c_count,start + N) = sin(phi(m)); %1
        C(c_count,start + 3*N-1) = cos(phi(m)); %1
    
        start = (n-1)*3*N;
        C(c_count,start + 1) = -sin(phi(n)); %0
        C(c_count,start + N+1) = -cos(phi(n)); %0
    end
    
    if (no_seperation_between_beams(i1,3) == 1) && (no_seperation_between_beams(i1,4) == 1)
        
        c_count = c_count +1;
        
        start = (m-1)*3*N;
        C(c_count,start + N) = cos(phi(m)); %1
        C(c_count,start + 3*N-1) = -sin(phi(m)); %1
    
        start = (n-1)*3*N;
        C(c_count,start + N) = -cos(phi(n)); %1
        C(c_count,start + 3*N-1) = sin(phi(n)); %1
    
    
        c_count = c_count +1;
    
        start = (m-1)*3*N;
        C(c_count,start + N) = sin(phi(m)); %1
        C(c_count,start + 3*N-1) = cos(phi(m)); %1
    
        start = (n-1)*3*N;
        C(c_count,start + N) = -sin(phi(n)); %1
        C(c_count,start + 3*N-1) = -cos(phi(n)); %1
    end
    
    if (no_seperation_between_beams(i1,3) == 0) && (no_seperation_between_beams(i1,4) == 0)
        
        c_count = c_count +1;
        
        start = (m-1)*3*N;
        C(c_count,start + 1) = cos(phi(m)); %0
        C(c_count,start + N+1) = -sin(phi(m)); %0
    
        start = (n-1)*3*N;
        C(c_count,start + 1) = -cos(phi(n)); %0
        C(c_count,start + N+1) = sin(phi(n)); %0
    
    
        c_count = c_count +1;
    
        start = (m-1)*3*N;
        C(c_count,start + 1) = sin(phi(m)); %0
        C(c_count,start + N+1) = cos(phi(m)); %0
    
        start = (n-1)*3*N;
        C(c_count,start + 1) = -sin(phi(n)); %0
        C(c_count,start + N+1) = -cos(phi(n)); %0
    end
    
    
end

%defining internal constraints
%no_rotation_between_beams = [1 2];
for i1 = 1:size(no_rotation_between_beams,1)
    
    m = no_rotation_between_beams(i1,1);
    n = no_rotation_between_beams(i1,2);
    start_m = (m-1)*3*N;
    start_n = (n-1)*3*N;
    
    if (no_seperation_between_beams(i1,3) == 1) && (no_seperation_between_beams(i1,4) == 0)
        c_count = c_count +1;
        C(c_count,start_m + 3*N) = 1;
        C(c_count,start_n + N+2) = -1;
    end
    
    if (no_seperation_between_beams(i1,3) == 1) && (no_seperation_between_beams(i1,4) == 1)
        c_count = c_count +1;
        C(c_count,start_m + 3*N) = 1;
        C(c_count,start_n + 3*N) = -1;
    end
    
    if (no_seperation_between_beams(i1,3) == 0) && (no_seperation_between_beams(i1,4) == 0)
        c_count = c_count +1;
        C(c_count,start_m + N+2) = 1;
        C(c_count,start_n + N+2) = -1;
    end
    

end

%defining boundary constraints
%no_seperation_from_wall = [0 1]; %[wall beam1]
for i1 = 1:size(no_seperation_from_wall,1)
    m = no_seperation_from_wall(i1,1);
    n = no_seperation_from_wall(i1,2);
    if(m==0) %wall on the left end of the beam
        start = (n-1)*3*N;
        c_count = c_count +1;
        C(c_count,start + 1) = 1;
        c_count = c_count +1;
        C(c_count,start + N+1) = 1;
    end
    
    if(n==0) %wall on the right end of the beam
        start = (m-1)*3*N;
        c_count = c_count +1;
        C(c_count,start + N) = 1;
        c_count = c_count +1;
        C(c_count,start + 3*N-1) = 1;
    end
end


%defining boundary constraints
%no_rotation_about_wall = [0 1]; %[wall beam1]
for i1 = 1:size(no_rotation_about_wall,1)
    m = no_rotation_about_wall(i1,1);
    n = no_rotation_about_wall(i1,2);
    if(m==0) %wall on the left end of the beam
        start = (n-1)*3*N;
        c_count = c_count +1;
        C(c_count,start + N+2) = 1;
    end
    
    if(n==0) %wall on the right end of the beam
        start = (m-1)*3*N;
        c_count = c_count +1;
        C(c_count,start + 3*N) = 1;        
    end
end

no_of_constraints = c_count;
C = C(1:no_of_constraints,:);

%Assembling the stiffness matrix and mass matrix
Se = zeros(Nsize,Nsize);
Me = zeros(Nsize,Nsize);
ZC = zeros(no_of_constraints,no_of_constraints);

for i=1:no_of_beams
    [S, M, x, h] = LHS(p, beam_config_matrix(i,3), E_bulk_modulus, I_mass_moment, Area);
    Se(((i-1)*3*N+1):(i*3*N),((i-1)*3*N+1):(i*3*N)) = S;
    Me(((i-1)*3*N+1):(i*3*N),((i-1)*3*N+1):(i*3*N)) = M;
end

%Adding the constraints to Me and Se
Me = blkdiag(Me, ZC);
Se=[Se C'; C ZC];

end

