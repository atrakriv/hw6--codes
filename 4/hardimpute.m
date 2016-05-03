function [X_complete] = hardimpute(X_missing, Omega, r)
% Input:
% X missing -- a m-by-n input matrix, only values at Omega ** P_omega(X)
% Omega -- a m-by-n binary matrix, indicating location of the missing values
% r -- rank

eps = 1e-5;      % epsilon
max_iter = 1000; % maximum number of iteration

Omega_orth = -Omega + 1 ;

p = size(X_missing,1);
Z = zeros(p,p);

for i = 1 : max_iter
    P_Omega_orth_Z = Z.*Omega_orth;  % P'_omega(Z)
    [U,S,V] = svd(X_missing + P_Omega_orth_Z);
    U_r = U(:,1:r);    % truncated U
    S_r = S(1:r,1:r);  % truncated S
    V_r = V(:,1:r);    % truncated V
    Zn = U_r*S_r*V_r';
    if norm(Z-Zn)<eps
        break
    end
    Z = Zn;
end
X_complete = X_missing + P_Omega_orth_Z;

