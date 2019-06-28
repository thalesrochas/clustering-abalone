%% Clustering Abalone dataset
% Francisco Mauro Falcão Matias Filho
% Francisco Thales Rocha Sousa
% Maria Raquel Lopes de Couto

clear
clc
close all

dataset = importdata('abalone.data');
abalone = dataset.data;
classes = dataset.textdata(2:end, 1);
className = ["M", "F", "I"];

%% Parâmetros
minClusters = 2; % Número mínimo de Clusters (Maior ou igual a 2)
maxClusters = 10; % Número máximo de Clusters
err = 0; % Erro máximo (Valor maior ou igual a zero)

%% K-means Ideal + Larguras de Silhueta do K-Means
% Implementação do k-means no arquivo k_means.m
result = k_means(abalone, minClusters, maxClusters, err, true, false, true);

fprintf("K-Means ideal:\n")
fprintf("Clusters: %2d\tVRC: %.3f\tIterações: %d\n", result.k, result.vrc, result.iterations);

%% C-means + Larguras de Silhueta do C-Means
% Calcula o C-Means pra cada quantidade de clusters plotando a silhueta
for C = minClusters:maxClusters
    [centers, U] = fcm(abalone, C, [NaN NaN NaN false]);
    maxU = max(U);
    indexes = zeros(length(abalone), 1);
    for c = 1:C
        index = find(U(c, :) == maxU);
        for i = index
            indexes(i) = c;
        end
    end
    
    % Plot das silhuetas para cada quantidade de clusters
    figure;
    silhouette(abalone, indexes);
    title("Largura de Silhueta C-Means - Clusters: " + C);
end

%% K-Means vs SVM
% Recuperando os dados do trabalho anterior de SVM
load("SvmConfusion.mat");

% Plot da matriz de confusão do SVM
figure;
plotconfusion(target, out);
set(gca, 'xticklabel', {'M' 'F' 'I' ''});
set(gca, 'yticklabel', {'M' 'F' 'I' ''});
title("Matriz de Confusão - SVM");

result_3 = k_means(abalone, 3, 3, err, false, false, false);
cluster = result_3.clusters;

centroideEstimado = result_3.centroids;
centroideReal = [
    mean(abalone(classes == className(1), :));
    mean(abalone(classes == className(2), :));
    mean(abalone(classes == className(3), :))];

for i = 1:3
    dist = sqrt(sum((centroideEstimado(i, :)' - centroideReal').^2));
    position(i) = find(dist == min(dist));
    classeEstimada(cluster == position(i), 1) = className(i);
end

target = zeros(3, length(classeEstimada));
out = target;   

for i = 1:length(classeEstimada)
    if classeEstimada(i) == className(1)
        out(:,i) = [1 0 0]';
    end
    if classeEstimada(i) == className(2)
        out(:,i) = [0 1 0]';
    end
    if classeEstimada(i) == className(3)
        out(:,i) = [0 0 1]';
    end

    if classes(i) == className(1)
        target(:,i) = [1 0 0]';
    end
    if classes(i) == className(2)
        target(:,i) = [0 1 0]';
    end
    if classes(i) == className(3)
        target(:,i) = [0 0 1]';
    end
end
figure;
plotconfusion(target, out);
title("Matriz de Confusão - K-Means");

set(gca,'xticklabel',{className(1) className(2) className(3) ''});
set(gca,'yticklabel',{className(1) className(2) className(3) ''});

%% Plots das classes reais e das preditas pelo agrupamento

figure;
hold on; grid on;
plot3(abalone(classes == className(1), 1), abalone(classes == className(1), 2), abalone(classes == className(1), 3), '.')
plot3(abalone(classes == className(2), 1), abalone(classes == className(2), 2), abalone(classes == className(2), 3), '.')
plot3(abalone(classes == className(3), 1), abalone(classes == className(3), 2), abalone(classes == className(3), 3), '.')
title("Real");

figure;
hold on; grid on;
plot3(abalone(classeEstimada == className(1), 1), abalone(classeEstimada == className(1), 2), abalone(classeEstimada == className(1), 3), '.')
plot3(abalone(classeEstimada == className(2), 1), abalone(classeEstimada == className(2), 2), abalone(classeEstimada == className(2), 3), '.')
plot3(abalone(classeEstimada == className(3), 1), abalone(classeEstimada == className(3), 2), abalone(classeEstimada == className(3), 3), '.')
title("Agrupamento");