%% Clustering Abalone dataset
% Francisco Mauro Falcão Matias Filho
% Francisco Thales Rocha Sousa
% Maria Raquel Lopes de Couto

clear
clc
close all

dataset = importdata('abalone.data');
abalone = dataset.data;

%% Tests
% [a, b, c] = pca(abalone);
% abalone = b;

% load fisheriris;
% abalone = meas;

%% Parâmetros
minClusters = 2; % Número mínimo de Clusters (Maior ou igual a 2)
maxClusters = 5; % Número máximo de Clusters
err = 0; % Erro máximo (Valor maior ou igual a zero)

result = k_means(abalone, minClusters, maxClusters, err, true, false, true);

fprintf("Melhor Resultado:\n")
fprintf("Clusters: %2d\tVRC: %.3f\tIterações: %d\n", result.k, result.vrc, result.iterations);

c = result.clusters;
cen = result.centroids;

plot3(abalone(c == 1, 1), abalone(c == 1, 2), abalone(c == 1, 3), '.');
hold on; grid on;
plot3(abalone(c == 2, 1), abalone(c == 2, 2), abalone(c == 2, 3), '.');
plot3(abalone(c == 3, 1), abalone(c == 3, 2), abalone(c == 3, 3), '.');
plot3(cen(:, 1), cen(:, 2), cen(:, 3), '*');

% figure;
% silhouette(abalone, c);