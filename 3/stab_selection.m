clc; clear; close all;
load('feature_name')
load('ad_data')
par = [1e-5 0.01, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1];
nbs = 1000;    %% number of bootstrap
nsf = 20;    %% number of selected feature
X_train_y_train = [X_train y_train];
n = size(X_train,1);   %% number of training sample
is = size(X_train,2);   %% input sapce size

prob_score = zeros(is,length(par));  %% probability score
for i = 1:length(par)
    for j = 1:nbs
        %%% subsampling
        X_train_y_train_sub = datasample(X_train_y_train,n,1); 
        X_train = X_train_y_train_sub(:,1:is);
        y_train = X_train_y_train_sub(:,is+1);
        [w, c] = logistic_l1_train(X_train, y_train, par(i));
        prob_score(:,i) = prob_score(:,i) + 1*(w~=0);
    end
end
final_prob_score = max(prob_score,[],2)/nbs;

[Sorted Idx] = sort(final_prob_score, 'descend');
largestNelements = Sorted(1:nsf);
largestNidx = Idx(1:nsf);

Result = [FeatureNames_PET(largestNidx), num2cell(largestNelements)];
