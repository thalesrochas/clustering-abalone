%% C-Means Implementation
% Francisco Mauro Falcão Matias Filho
% Francisco Thales Rocha Sousa
% Maria Raquel Lopes de Couto

dataset = importdata('abalone.data');
abalone = dataset.data;

[centers, U] = fcm(abalone, 2);

maxU = max(U);
index1 = find(U(1,:) == maxU);
index2 = find(U(2,:) == maxU);

hold on;
plot(abalone(index1,1),abalone(index1,2),'ob')
plot(abalone(index2,1),abalone(index2,2),'or')
plot(centers(1,1),centers(1,2),'xb','MarkerSize',15,'LineWidth',3)
plot(centers(2,1),centers(2,2),'xr','MarkerSize',15,'LineWidth',3)
