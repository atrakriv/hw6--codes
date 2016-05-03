clc; clear; close all;
load('ad_data')
par = [1e-5 0.01, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1];
par = [0.1];
for i = 1:length(par)
    [w, c] = logistic_l1_train(X_train, y_train, par(i));
    out_test = w'*X_test'+c;  
    % [X,Y,T,AUC] = perfcurve(labels,scores,posclass) 
    % --> scores is wX+c , it is not labeles
    [X,Y,T,AUC] = perfcurve(y_test, out_test, 1);
    AUC_vec(i) = AUC;
    nsf = sum([w;c]~=0);  % number of selected features
    nsf_vec(i) = nsf;
    S = sprintf('par = %f , AUC = %f, number of selected feature = %d',par(i),AUC,nsf);
    disp(S)
end
%%
figure(1)
plot(par, AUC_vec,'-o', 'MarkerFaceColor','b')
xlabel('l1-regularization parameter')
ylabel('AUC')
figure(2)
plot(par, nsf_vec,'-o', 'MarkerFaceColor','b')
xlabel('l1-regularization parameter')
ylabel('number of selected features')