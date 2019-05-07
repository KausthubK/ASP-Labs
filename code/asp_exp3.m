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

sampleSizes = [3 5 10 20 50 100 200 500];

dims = 5;
mu1 = randi(5,dims,1);
mu2 = mu1 + 2*rand(dims,1);
cova = eye(dims);

X1_design = mvnrnd(mu1,cova,100);
X2_design = mvnrnd(mu2,cova,100);
Xd = [X1_design; X2_design];
train_labels = [zeros(100,1); ones(100,1)];

for i = 1:10
    X1_test = mvnrnd(mu1,cova,500);
    X2_test = mvnrnd(mu2,cova,500);
    Xt{i} = [X1_test; X2_test];
end
test_labels = [zeros(500,1); ones(500,1)];

testSizes = [5, 10, 20, 50:50:500];
E_train_mean = [];
E_test_mean = [];
E_train_std = [];
E_test_std = [];

for i = 1:length(sampleSizes)
    e_train = [];
    e_test = [];
    for iters = 1:10
        mdl = fitcnb(Xd, train_labels);
        train_prediction = predict(mdl, Xd);
        test_prediction = predict(mdl, Xt{i});
        e_train(iters) = sum(xor(train_prediction, train_labels))/length(train_prediction);
        e_test(iters) = sum(xor(test_prediction, test_labels))/length(test_prediction);
    end
    E_train_mean(i) = sum(e_train)/iters;
    E_test_mean(i) = sum(e_test)/iters;
%     E_train_std(i) = (1/9)*sum((e_train.*E_train_mean(i)).^2);
%     E_test_std(i) = (1/9)*sum((e_test.*E_test_mean(i)).^2);
    E_train_std(i) = std(e_train);
    E_test_std(i) = std(e_test);
end

fig = figure;
plot(sampleSizes, E_test_mean)
hold on
plot(sampleSizes, E_train_mean)
hold on
E_true = [E_test_mean(end), E_test_mean(end), E_test_mean(end), E_test_mean(end), E_test_mean(end), E_test_mean(end), E_test_mean(end), E_test_mean(end)];
plot(sampleSizes, E_true)
legend('Test Set Error', 'Training Set Error', 'True Error')
title(sprintf("ASP - Experiment 3 -" + " d=" + dims))
xlabel('Nd')
ylabel('Average Error')
% saveas(fig,"./Exp3-results/ErrorComparison_" + dims + ".png")

fig = figure;
plot(sampleSizes, E_test_std)
hold on
plot(sampleSizes, E_train_std)
legend('Test Set Error', 'Training Set Error')
title(sprintf("ASP - Experiment 3 -" + " d=" + dims))
xlabel('Nd')
ylabel('Error % Standard Deviation')
% saveas(fig,"./Exp3-results/ErrorStandardDeviation_" + dims + ".png")