%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @author: Kausthub Krishnamurthy
% URN:     6562233
% EEEM007 Advanced Signal Processing - Lab Experiments
% Filename: asp_exp4.m
% Date started: 7-May-2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Clear everything and setup
clear all
close all
clc

%% create multiple distribution pairs monotonically increasing.
dims = 5;
numSequences = 10;
classSizes = 100;

mu1 = [];
mu2 = [];
cova = [];
dm2 = [];

for i = 1:numSequences
    mu1{i} = randi(5,dims,1);
    mu2{i} = randi(5,dims,1);
    cova{i} = randi(5,dims,1) .* eye(5);
    dm2(1,i) = (mu1{i}-mu2{i})'*inv(cova{i})*(mu1{i}-mu2{i});
    dm2(2,i) = i;
end
ordered_dm2 = sortrows(dm2', 1)';

for i = 1:numSequences
    X1 = mvnrnd(mu1{ordered_dm2(2,i)},cova{ordered_dm2(2,i)},classSizes);
    X2 = mvnrnd(mu2{ordered_dm2(2,i)},cova{ordered_dm2(2,i)},classSizes);
    Xt{i} = [X1; X2];
    ordered_m1{i} = mu1{ordered_dm2(2,i)};
    ordered_m2{i} = mu2{ordered_dm2(2,i)};
    ordered_cova{i} = cova{ordered_dm2(2,i)};
end
labels = [zeros(classSizes,1); ones(classSizes,1)];

for i = 1:numSequences
    mdl = fitcnb(Xt{i}, labels);
    prediction = predict(mdl, Xt{i});
    e(i) = sum(xor(prediction, labels))/length(prediction);
end

fig = figure;
plot(ordered_dm2(1,:), e)
xlabel('Mahalanobis Distance')
ylabel('Error')
title(sprintf("ASP - Experiment 4 -" + " d=" + dims))
saveas(fig,"./Exp4-results/MahalError_" + dims + ".png")
