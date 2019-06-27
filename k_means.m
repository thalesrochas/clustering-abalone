%% K-Means Implementation
% Francisco Mauro Falcão Matias Filho
% Francisco Thales Rocha Sousa
% Maria Raquel Lopes de Couto

function result = k_means(dataset, minClusters, maxClusters, error, verbosis, plotFigures, plotSilhouette)
    if minClusters < 2
        minClusters = 2;
    end
    %% Parâmetros
    nAmostras = size(dataset, 1);
    result.vrc = 0;
    %% Diversas iterações para verificar qual a melhor quantidade de clusteres com base no VRC
    for K = minClusters:maxClusters
        %% Escolhe K amostras aleatoriamente para serem os K centroides iniciais
        rng(0);
        centroides = randperm(nAmostras);
        centroides = dataset(centroides(1:K), :);

        %% Itera várias vezes até o erro ser menor que o definido.
        err = inf; iter = 0;

        while (err > error)
            iter = iter + 1;

            %% Cálculo de distâncias
            % Calcula a distância de cada amostra até os K centroides e atribui em
            % indices qual o centroide mais próximo da amostra i.
            indices = zeros(nAmostras, 1);
            for i = 1:nAmostras
                closer = inf; % Distância inicial
                for j = 1:K
                    dist = sum((dataset(i, :) - centroides(j, :)).^2);
                    % Se dist for menor que closer, essa é uma amostra mais próxima.
                    if (dist < closer)
                      closer = dist;
                      k = j;
                    end
                end
                indices(i) = k;
            end

            %% Plots
            if plotFigures
                figure;
                plot3(centroides(:, 1), centroides(:, 2), centroides(:, 3), 'o');
                hold on; grid on;
                for i = 1:K
                    plot3(dataset(indices == i, 1), dataset(indices == i, 2), ...
                        dataset(indices == i, 3), '.');
                end
                title("Agrupamento - Clusters: " + K + " Iteração " + iter);
            end
            %% Recálculo dos centroides e do erro
            prev_centroides = centroides;
            for i = 1:K
                centroides(i, :) = mean(dataset(indices == i, :));
            end
            % Armazena a maior distância entre os clusters das duas últimas
            % iterações.
            err = max(sum((prev_centroides' - centroides').^2));
        end

        %% Cálculo do VRC
        % Número de amostras em cada cluster
        n = zeros(1, K);
        for k = 1:K
            n(1, k) = sum(indices == k);
        end

        % Distância Quadrática entre os centróides e o centro do dataset.
        d2 = zeros(1, K);
        for k = 1:K
            d2(1, k) = sum((mean(dataset) - centroides(k, :)).^2);
        end

        % Somatório de todas as distâncias das amostras até o centróide de seu
        % cluster.
        x = zeros(1, K);
        for k = 1:K
            x(1, k) = sum(sum((dataset(indices == k, :) - centroides(k, :)).^2));
        end

        vrc = (sum(n.*d2)/(K-1))/(sum(x)/(nAmostras-K));
        if verbosis
            fprintf("Clusters: %2d\tVRC: %.3f\tIterações: %d\n", K, vrc, iter);
        end
        if plotSilhouette
            figure;
            silhouette(dataset, indices);
            title("Largura de Silhueta - Clusters: " + K);
        end
        if vrc > result.vrc
            result.k = K;
            result.vrc = vrc;
            result.iterations = iter;
            result.clusters = indices;
            result.centroids = centroides;
        end
    end
end