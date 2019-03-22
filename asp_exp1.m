%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @author: Kausthub Krishnamurthy
% URN:     6562233
% EEEM007 Advanced Signal Processing - Lab Experiments
% Filename: asp_exp1.m
% Date started: 11-Mar-2019
% Date updated: 11-Mar-2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 0. Clear everything
clear all
close all
clc

a = 1;
b = 3; 
c = 3; 
d = 3; 
f = 1;

mu1 = [a;b]
mu2 = [a+d; b+d]
cova = [c f;f c] % cova is the covariance matrix. didn't use cov since it's a built in function


%% 1. Effect of training sample size on classifier performance
X1_test = mvnrnd(mu1,cova,100);
X2_test = mvnrnd(mu2,cova,100);
plot2Classes(X1_test, X2_test, 1, "test")

test_labels = [zeros(100,1); ones(100,1)];
sampleSizes = [3 5 10 50 100]

E_train = [];
E_test = [];

for i = 1:length(sampleSizes)
    e_train = [];
    e_test = [];
    for iters = 1:10
        Nd = sampleSizes(i);
        X1_design = mvnrnd(mu1,cova,Nd);
        X2_design = mvnrnd(mu2,cova,Nd);
        X = [X1_design; X2_design];
        plot2Classes(X1_design, X2_design, 1, "train")
        train_labels = [zeros(Nd,1); ones(Nd,1)];
        mdl = fitcnb(X, train_labels);
        train_prediction = predict(mdl, X);
        test_prediction = predict(mdl, [X1_test; X2_test]);
        
        e_train(iters) = sum(xor(train_prediction, train_labels))/length(train_prediction);
        e_test(iters) = sum(xor(test_prediction, test_labels))/length(test_prediction);
    end
    E_train(i) = sum(e_train)/iters;
    E_test(i) = sum(e_test)/iters;
end

fig = figure
plot(sampleSizes, E_test)
hold on
plot(sampleSizes, E_train)
legend('Test Set Error', 'Training Set Error')
title(sprintf("ASP - Experiment 1"))
xlabel('Nd')
ylabel('Average Error')
saveas(fig,'./Exp1-results/ErrorComparison.png')