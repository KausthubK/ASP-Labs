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

a = 1;
b = 3; 
c = 3; 
d = 3; 
f = 1;

mu1 = [a;b]
mu2 = [a+d; b+d]
cova = [c f;f c] % cova is the covariance matrix. didn't use cov since it's a built in function

%% Comparing kNN with a gaussian classifier