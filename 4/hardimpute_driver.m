clear; clc; close all;

p = 128;         % image size, say 128*128
ratio = 0.5;     % observed/total 
n = p*p*ratio;   % number of observation
% r : rank - trunctaed-r matrix       
r_arr = [1, 5, 10, 15, 20, 25, 30];
% r_arr = [5, 10];

Omega = zeros(p, p);
Omega(randperm(numel(Omega), n)) = 1;

[img,map] = imread('lnds2.gif');
% convert the image to rgb format
rgb=ind2rgb(img,map);

% convert image to double format
X_r=double(rgb(:,:,1)); % red channel
X_g=double(rgb(:,:,2)); % green channel
X_b=double(rgb(:,:,3)); % blue channel


% missing image
X_missing(:,:,1) = X_r.*Omega;
X_missing(:,:,2) = X_g.*Omega;
X_missing(:,:,3) = X_b.*Omega;

% true image
X(:,:,1) = X_r;
X(:,:,2) = X_g;
X(:,:,3) = X_b;


for i = 1 : length(r_arr)
    r = r_arr(i);
    
    X_complete_r = hardimpute(X_r.*Omega, Omega, r);
    X_complete_g = hardimpute(X_g.*Omega, Omega, r);
    X_complete_b = hardimpute(X_b.*Omega, Omega, r);
    
    % reconstructed image
    X_hat(:,:,1) = X_complete_r;
    X_hat(:,:,2) = X_complete_g;
    X_hat(:,:,3) = X_complete_b;
    
    error_r(i) = norm(X_complete_r-X_r,'fro');
    error(i) = (norm(X_complete_r-X_r,'fro')+norm(X_complete_g-X_g,'fro')...
                                           +norm(X_complete_b-X_b,'fro'))/3;
    
    figure(i)
    subplot(1,3,1);
    imshow(X_r)
    title(['r = ' num2str(r)])
    subplot(1,3,2);
    imshow(X_r.*Omega)
    subplot(1,3,3);
    imshow(X_complete_r)
    
    figure(i+length(r_arr))
    subplot(1,3,1);
    imshow('lnds2.gif')
    title(['r = ' num2str(r)])
    subplot(1,3,2);
    imshow(X_missing)
    subplot(1,3,3);
    imshow(X_hat)
end

figure(2*length(r_arr)+1)
plot(r_arr,error_r,'b-o', r_arr,error,'r-o','LineWidth',2)
xlabel('r')
ylabel('total reconstruction error')
title('total reconstruction error vs number of selected feature')
legend('red-channel error','mean 3-channel error')


