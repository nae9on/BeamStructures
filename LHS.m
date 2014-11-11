
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

function [S, M, x, h] = LHS(p, L, E, I, A)
%Input: 
%L: length
%E: Young's modulus
%I: moment of inertia
%p: number of points is 2^p+1
%A: Contant.....

%% prepare fem stuff
%p    = 2;
nphi = 4;
N = 2*(2^p+1);

% create mesh & compute inverse transformation and determinant
x                = linspace(0,L,2^p+1);
[nelement,~,e2p] = generateelements(x);
h                = L/2^p;

%% build matrices
ii = zeros(nelement,nphi^2); % sparse i-index
jj = zeros(nelement,nphi^2); % sparse j-index
aa = zeros(nelement,nphi^2); % entry of Galerkin matrix
bb = zeros(nelement,nphi^2); % entry in mass-matrix (to build rhs)

%% build global from local
for k=1:nelement             % loop over elements
%     [edet,dFinv]  = generatetransformation(k,e2p,x); % compute map
%     
    % build local matrices (mass, stiffness, ...)
    sloc = localstiff_T(h);      % element stiffness matrix
    mloc = localmass_T(h);             % element mass matrix
    
    % compute i,j indices of the global matrix
    ii( k,: ) = [2*e2p(k,1)-1 2*e2p(k,1) 2*e2p(k,2)-1 2*e2p(k,2)...
                 2*e2p(k,1)-1 2*e2p(k,1) 2*e2p(k,2)-1 2*e2p(k,2)...
                 2*e2p(k,1)-1 2*e2p(k,1) 2*e2p(k,2)-1 2*e2p(k,2)...
                 2*e2p(k,1)-1 2*e2p(k,1) 2*e2p(k,2)-1 2*e2p(k,2)];
    % local-to-global
    jj( k,: ) = [2*e2p(k,1)-1 2*e2p(k,1)-1 2*e2p(k,1)-1 2*e2p(k,1)-1 ...
                 2*e2p(k,1)   2*e2p(k,1)   2*e2p(k,1)   2*e2p(k,1) ...
                 2*e2p(k,2)-1 2*e2p(k,2)-1 2*e2p(k,2)-1 2*e2p(k,2)-1 ...
                 2*e2p(k,2)   2*e2p(k,2)   2*e2p(k,2)   2*e2p(k,2)]; % local-to-global
    
    % compute a(i,j) values of the global matrix
    aa( k,: ) = sloc(:);
    bb( k,: ) = mloc(:);
end
% create sparse matrices
ST=E*I*sparse(ii(:),jj(:),aa(:));
MT=sparse(ii(:),jj(:),bb(:));

%% prepare fem stuff
nphi = 2;

%% build matrices
ii = zeros(nelement,nphi^2); % sparse i-index
jj = zeros(nelement,nphi^2); % sparse j-index
aa = zeros(nelement,nphi^2); % entry of Galerkin matrix
bb = zeros(nelement,nphi^2); % entry in mass-matrix (to build rhs)


%% build global from local
for k=1:nelement             % loop over elements
    sloc = localstiff_L(h);      % element stiffness matrix
    mloc = localmass_L(h);             % element mass matrix
    % compute i,j indices of the global matrix
    ii( k,: ) = [e2p(k,1) e2p(k,2) e2p(k,1) e2p(k,2)]; % local-to-global
    jj( k,: ) = [e2p(k,1) e2p(k,1) e2p(k,2) e2p(k,2)]; % local-to-global
    
    % compute a(i,j) values of the global matrix
    aa( k,: ) = sloc(:);
    bb( k,: ) = mloc(:);
end
% create sparse matrices
SL=E*A*sparse(ii(:),jj(:),aa(:)); 
ML=sparse(ii(:),jj(:),bb(:));

S= blkdiag(SL,ST);
M= blkdiag(ML,MT);

end

