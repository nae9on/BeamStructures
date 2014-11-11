
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

function [out1,out2,out3,out4,out5,out6,out7,out8,out9] = configuration_tower(flag)
% This file defines the configuration of a problem which is needed by
% simulation.m

% The simulation.m and the rest of the code is generic enough to be able 
% to simulate any dynamic structure provided the problem is defined 
% correctly(in the configuration file)as per the conventions.


% defining configuration of every beam in the beam_config_matrix

%{
% for example [[4 5] 12 pi/6] defines a beam of length 12 whose left
% end has coordinates [4 5] and  makes an angle of pi/6 with the x-axis.

% Note that the index of the beam is the same as it appears in the 
% beam_config_matrix
% for example

beam_config_matrix = [[-1 0] sqrt(2) pi/4; 
                      [1 0] sqrt(2) 3*pi/4;   
                      [0 1] 1 pi/2;
                      [-1 0] sqrt(5) atan(2);
                      [1 0] sqrt(5) pi-atan(2)];
would mean 
beam 1 = [-1 0] sqrt(2) pi/4
beam 2 = [1 0] sqrt(2) 3*pi/4
beam 3 = [0 1] 1 pi/2

The index is very important to define the constraints/boundary conditions
%}

% beam_config_matrix = [left_node_coordinates length angle_with_x];
beam_config_matrix = [[-1 0] sqrt(2) pi/4; 
                      [1 0] sqrt(2) 3*pi/4;   
                      [0 1] 1 pi/2;
                      [-1 0] sqrt(5) atan(2);
                      [1 0] sqrt(5) pi-atan(2)];
                  
                  
% defining external load for every beam in the beam_load_matrix
% beam_load_matrix = [load_parallel_to_the_beam load_normal_to_the_beam moment moment];
beam_load_matrix = {@(x,t)0 @(x,t)0 @(x,t)0;
                    @(x,t)0 @(x,t)0 @(x,t)0;
                    @(x,t)0 @(x,t)-1*not(t) @(x,t)0;
                    @(x,t)0 @(x,t)0 @(x,t)0;
                    @(x,t)0 @(x,t)0 @(x,t)0};

%defining boundary conditions
%{
no_seperation_between_beams = [beam_i beam_j end(L/R)_of_beam_i end(L/R)_of_beam_j];

example 
no_seperation_between_beams = [1 3 1 0];
would mean right end of beam_1 is connected to left end of beam_3

no_seperation_between_beams = [3 5 1 1];
would mean right end of beam_3 is connected to right end of beam_5

no_seperation_from_wall = [0 5]
would mean that left end of beam_5 is connected to the wall

no_seperation_from_wall = [7 0]
would mean that right end of beam_7 is connected to the wall

Note that the order of constraints/boundary conditions do not matter
and is irrespective of the order of the beams defined in the beam/load 
config matrix

Critical Note: It is important to prevent redundant boundary conditions
while defining the constraints/boundary conditions otherwise the matrix 
would be singular. 
The easiest way is to sketch the structure on paper, give directions to 
each beam and then defining the constraints (avoiding graph loops)

%}

% no_seperation_between_beams = [beam_i beam_j end(L/R)_of_beam_i end(L/R)_of_beam_j];
no_seperation_between_beams = [1 3 1 0; 2 3 1 0; 3 4 1 1; 3 5 1 1; 1 4 0 0; 2 5 0 0];

% no_rotation_between_beams = [beam_i beam_j end(L/R)_of_beam_i end(L/R)_of_beam_j];
no_rotation_between_beams   = [1 3 1 0; 2 3 1 0; 3 4 1 1; 3 5 1 1; 1 4 0 0; 2 5 0 0];

% no_seperation_from_wall = [wall_is_0_always_and_left_end_of_beam_is_connected beam_index] 
% or 
% no_seperation_from_wall = [beam_index wall_is_0_always_and_right_end_of_beam_is_connected];
no_seperation_from_wall = [0 1; 0 2]; 

% no_rotation_about_wall = [wall_is_0_always_and_left_end_of_beam_is_pinned beam_index] 
% or 
% no_rotation_about_wall = [beam_index wall_is_0_always_and_right_end_of_beam_is_pinned];
no_rotation_about_wall = [0 1]; 

% plot parameteres
plot_window_center = [0 1];
% the farthest distance of any point in the structure from the center of
% the structure
margin = 2;

% simulation parametres
tsteps = 100;

% To test the configuration you can just run the configuration explicitly
% providing the flag = 1
if flag
    %plotting the initial structure to check
    figure();
    p = 5;
    N=2^p+1;
    phi = beam_config_matrix(:,4);
    no_of_beams = size(beam_config_matrix,1);
    cmap = hsv(no_of_beams);
    for ist=1:no_of_beams
        hold on
        curve_local = [linspace(0,beam_config_matrix(ist,3),N)';zeros(N,1)];
        curve_rotated = Rotate(phi(ist),curve_local);
        curve_global = curve_rotated + [beam_config_matrix(ist,1)*ones(N,1); beam_config_matrix(ist,2)*ones(N,1)];
        x_glo = curve_global(1:N);
        y_glo = curve_global(1+N:2*N);
        plot(x_glo,y_glo,'Color',cmap(ist,:));
    end
    axis([plot_window_center(1,1)-margin plot_window_center(1,1)+margin plot_window_center(1,2)-margin plot_window_center(1,2)+margin]);
end

out1 = beam_config_matrix;
out2 = beam_load_matrix;
out3 = no_seperation_between_beams;
out4 = no_rotation_between_beams;
out5 = no_seperation_from_wall;
out6 = no_rotation_about_wall;
out7 = plot_window_center;
out8 = margin;
out9 = tsteps;
end