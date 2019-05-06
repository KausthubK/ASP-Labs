%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @author: Kausthub Krishnamurthy
% URN:     6562233
% EEEM007 Advanced Signal Processing - Lab Experiments
% Filename: asp_exp3.m
% Date started: 03-May-2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Clear everything and setup

clear all
close all
clc

a = 1;
b = 3; 
c = 3; 
d = 3; 
f = 1;

%% effect of the size of test set on the reliability of the empirical error count estimator

sampleSizes = [3 5 10 20 50 100 200 500]
dimensionSizes = [5, 10, 15]

E_train = [];
E_test = [];

for k = 1:length(dimensionSizes) 
    dims = dimensionSizes(k)
    mu1 = randi(5,dims,1)
    if dims == 5
        mu2 = mu1 + 2*rand(dims,1)
    elseif dims == 10
        mu2 = mu1 + 1.6*rand(dims,1)
    else dims == 15
        mu2 = mu1 + 1.35*rand(dims,1)
    end
    cova = eye(dims)
    X1_design = mvnrnd(mu1,cova,100);
    X2_design = mvnrnd(mu2,cova,100);
    for i = 1:length(sampleSizes)
        e_train = [];
        e_test = [];
        for iters = 1:10
            Nd = sampleSizes(i);
            X1_test = mvnrnd(mu1,cova,Nd);
            X2_test = mvnrnd(mu2,cova,Nd);
            X = [X1_design; X2_design];
            train_labels = [zeros(100,1); ones(100,1)];
            test_labels = [zeros(Nd,1); ones(Nd,1)];
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
    plot(sampleSizes(1:7), E_test(1:7))
    hold on
    plot(sampleSizes(1:7), E_train(1:7))
    hold on
    E_true = [E_test(8), E_test(8), E_test(8), E_test(8), E_test(8), E_test(8), E_test(8)]
    plot(sampleSizes(1:7), E_true)
    legend('Test Set Error', 'Training Set Error', 'True Error')
    title(sprintf("ASP - Experiment 2 -" + " d=" + dims))
    xlabel('Nd')
    ylabel('Average Error')
%     saveas(fig,"./Exp2-results/ErrorComparison_" + dims + ".png")
%     w = waitforbuttonpress
end