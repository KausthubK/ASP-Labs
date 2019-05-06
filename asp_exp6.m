%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @author: Kausthub Krishnamurthy
% URN:     6562233
% EEEM007 Advanced Signal Processing - Lab Experiments
% Filename: asp_exp6.m
% Date started: 6-May-2019
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

mu1 = [a;b]
mu2 = [a+d; b+d]
cova = [c f;f c] % cova is the covariance matrix. didn't use cov since it's a built in function


%% Comparing kNN with a gaussian classiefier
X1_test = mvnrnd(mu1,cova,100);
X2_test = mvnrnd(mu2,cova,100);

test_labels = [zeros(100,1); ones(100,1)];
sampleSizes = [3 5 10 50 100];
% sampleSizes = [3, 5:5:100];

kND_best = [];
E_train_best = [];
E_test_best = [];
for i = 1:length(sampleSizes)
    Nd = sampleSizes(i);
    E_train_mean = [];
    E_test_mean = [];
    if Nd*2 < 51
        kVals = 3:2:(2*Nd);
    else
        kVals = 3:2:51;
    end
    for kIter = 1:length(kVals)
        k = kVals(kIter);
        e_train = [];
        e_test = [];
        for iters = 1:10
            X1_design = mvnrnd(mu1,cova,Nd);
            X2_design = mvnrnd(mu2,cova,Nd);
            X = [X1_design; X2_design];
            train_labels = [zeros(Nd,1); ones(Nd,1)];
            mdl = fitcknn(X, train_labels);
            mdl.NumNeighbors = k;
            train_prediction = predict(mdl, X);
            test_prediction = predict(mdl, [X1_test; X2_test]);

            e_train(iters) = sum(xor(train_prediction, train_labels))/length(train_prediction);
            e_test(iters) = sum(xor(test_prediction, test_labels))/length(test_prediction);
        end
        E_train_mean(kIter) = sum(e_train)/iters;
        E_test_mean(kIter) = sum(e_test)/iters;
    end
    [val, idx] = max(E_test_mean);
    kND_best(i) = kVals(idx);
    E_train_best(i) = E_train_mean(idx);
    E_test_best(i) = val;
end

fig = figure;
plot(sampleSizes, E_test_best)
hold on
plot(sampleSizes, E_train_best)
legend('Test Set Error', 'Training Set Error')
title(sprintf("ASP - Experiment 6"))
xlabel('Nd')
ylabel('Average Error')
saveas(fig,'./Exp6-results/ErrorComparison.png')

fig = figure;
plot(sampleSizes, kND_best)
title(sprintf("ASP - Experiment 6"))
xlabel('Nd')
ylabel('k')
saveas(fig,'./Exp6-results/BestkVals.png')