clear; clc; close all;

p = 128;         % image size, say 128*128
ratio = 0.5;     % observed/total
n = p*p*ratio;   % number of observation
r = 10;          % rank - trunctaed-r matrix
eps = 1e-5;      % epsilon
max_iter = 1000; % maximum number of iteration

omega = zeros(p, p);
omega(randperm(numel(omega), n)) = 1;
omega_orth = -omega + 1 ;

[img,map] = imread('lnds2.gif');
% convert the image to rgb format
rgb=ind2rgb(img,map);

% convert image to double format
X_r=double(rgb(:,:,1)); % red channel
X_g=double(rgb(:,:,2)); % green channel
X_b=double(rgb(:,:,3)); % blue channel
figure(2*length(r_arr)+1)
plot(r_arr,error_r,'b-o','LineWidth',2, r_arr,error,'r-o','LineWidth',2)
% hold on
% plot(r_arr,error,'r-o','LineWidth',2)
xlabel('r')
ylabel('total reconstruction error')
title('total reconstruction error vs number of selected feature')
legend('red-channel error','mean 3-channel error')
lll

Z = zeros(p,p);
P_omega_X = X_r.*omega;          % P_omega(X)
for i = 1 : max_iter
    P_omega_orth_Z = Z.*omega_orth;  % P'_omega(Z)
    [U,S,V] = svd(P_omega_X + P_omega_orth_Z);
    U_r = U(:,1:r);    % truncated U
    S_r = S(1:r,1:r);  % truncated S
    V_r = V(:,1:r);    % truncated V
    Zn = U_r*S_r*V_r';
    if norm(Z-Zn)<eps
        break
    end
    Z = Zn;
end


figure(1)
imshow(X_r)
figure(2)
imshow(X_r.*omega)
figure(3)
imshow(P_omega_X + P_omega_orth_Z)


% normalize each image
% max_X_r=max(max(X_r));
% max_X_g=max(max(X_g));
% max_X_b=max(max(X_b));

% reconstruct the rgb images
% X_hat(:,:,1) = X_r.*omega*max_X_r;
% X_hat(:,:,2) = X_g.*omega*max_X_g;
% X_hat(:,:,3) = X_b.*omega*max_X_b;

% reconstruct the rgb images
X_hat(:,:,1) = X_r.*omega;
X_hat(:,:,2) = X_g.*omega;
X_hat(:,:,3) = X_b.*omega;
%imshow(X_hat)

