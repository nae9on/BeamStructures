
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

% This is the driver file of the Dynamic Structure Simulation Project
% and is to be run to simulate the structure
% The structure and the problem have to be well defined in the
% configuration_xxx.m file

% We have the following working examples
% 1. configuration_tacoma
% 2. configuration_fernsehturm
% 3. configuration_tower

% One can create his own structure/problem easily by following the
% conventions given in the configuration_xxx.m file

% Enjoy your structures!!

%clearing workspace
clc
clear all
close all

%Assuming every beam has the same physical properties.
%And every beam has the same discretization.
p = 5;
N=2^p+1;
E_bulk_modulus = 1;
I_mass_moment = 1;
Area = 1;

%get the configuration matrices from configuration.m
%[out1,out2,out3,out4,out5,out6,out7,out8,out9] = configuration_tacoma(0);
[out1,out2,out3,out4,out5,out6,out7,out8,out9] = configuration_fernsehturm(0);
%[out1,out2,out3,out4,out5,out6,out7,out8,out9] = configuration_tower(0);
                
beam_config_matrix = out1;
beam_load_matrix = out2;
no_seperation_between_beams = out3;
no_rotation_between_beams = out4;
no_seperation_from_wall = out5;
no_rotation_about_wall = out6;
plot_window_center = out7;
margin = out8;
tsteps = out9;

phi = beam_config_matrix(:,4);
no_of_beams = size(beam_config_matrix,1);

[Se, Me, x, h] = beamsLHS(p, E_bulk_modulus, I_mass_moment, Area, beam_config_matrix, out3, out4, out5, out6);

%first solving the static problem for defining the initial configuration
sol = Se\beamsRHS(p, Me, beam_config_matrix, beam_load_matrix, 0);

%defining variables for simulation
dt = 0.1;
beta = 1/4;
gamma = 1/2;
size_ext = max(size(sol));

%defining the initial configuration
u_0 = sol;                   % position
uD_0 = zeros(size_ext,1);    % velocity
uDD_0 = zeros(size_ext,1);   % acceleration
u_Temp = zeros(size_ext, 1);
uD_Temp = zeros(size_ext, 1);

%creating the LHS
A = Me + beta*dt*dt*Se;

%LU factorization to speed up the simulation
[L_factor_A,U_factor_A] = lu(A);

%initialize
u = u_0;
uD = uD_0;
uDD = uDD_0;

% plotting and video capture
writerObj = VideoWriter('beam.avi');
open(writerObj);

cmap = hsv(no_of_beams);
figure();
for i = 1: tsteps
    sol = u;
    clf
    hold on
    for ctr = 1:no_of_beams
        start = (ctr-1)*3*N;
        sol_beam = sol(start+1:start+3*N);
        x_change = sol_beam(1:1:N);
        y_change = sol_beam(N+1:2:3*N-1);
        y_slope_change = sol_beam(N+2:2:3*N);
        x_original = linspace(0,beam_config_matrix(ctr,3),N)';
        y_original = zeros(N,1);
        curve_local = [x_original;y_original] + [x_change; y_change];
        curve_rotated = Rotate(phi(ctr),curve_local);
        curve_global = curve_rotated + [beam_config_matrix(ctr,1)*ones(N,1); beam_config_matrix(ctr,2)*ones(N,1)];
        x_glo = curve_global(1:N);
        y_glo = curve_global(1+N:2*N);
        plot(x_glo,y_glo,'Color',cmap(ctr,:));
    end
    
    axis([plot_window_center(1,1)-margin plot_window_center(1,1)+margin plot_window_center(1,2)-margin plot_window_center(1,2)+margin]);
    xlabel('length');
    ylabel('deflection');
    title('simulation')
    frame = getframe;
    writeVideo(writerObj,frame);
    
    %hold the plot for visibility
    %pause(0.02);
    
    %now updating using Newmark Algorithm
    t = i*dt;
    u_Temp = u + uD*dt + (1/2 - beta)*uDD*dt*dt;
    uD_Temp = uD + (1 - gamma)*uDD*dt;
    
    b = beamsRHS(p, Me, beam_config_matrix, beam_load_matrix, t) - Se*u_Temp;
    %sol_t = A\b;
    sol_t = U_factor_A\(L_factor_A\b);
    
    uDD = sol_t;
    u = u_Temp + beta*uDD*dt*dt;
    uD = uD_Temp + gamma*uDD*dt;
    
end

close(writerObj);


