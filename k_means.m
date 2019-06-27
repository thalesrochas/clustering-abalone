%% K-Means Implementation
% Francisco Mauro Falc�o Matias Filho
% Francisco Thales Rocha Sousa
% Maria Raquel Lopes de Couto

function result = k_means(dataset, minClusters, maxClusters, error, verbosis, plotFigures, plotSilhouette)
    if minClusters < 2
        minClusters = 2;
    end
    %% Par�metros
    nAmostras = size(dataset, 1);
    result.vrc = 0;
    %% Diversas itera��es para verificar qual a melhor quantidade de clusteres com base no VRC
    for K = minClusters:maxClusters
        %% Escolhe K amostras aleatoriamente para serem os K centroides iniciais
        rng(0);
        centroides = randperm(nAmostras);
        centroides = dataset(centroides(1:K), :);

        %% Itera v�rias vezes at� o erro ser menor que o definido.
        err = inf; iter = 0;

        while (err > error)
            iter = iter + 1;

            %% C�lculo de dist�ncias
            % Calcula a dist�ncia de cada amostra at� os K centroides e atribui em
            % indices qual o centroide mais pr�ximo da amostra i.
            indices = zeros(nAmostras, 1);
            for i = 1:nAmostras
                closer = inf; % Dist�ncia inicial
                for j = 1:K
                    dist = sum((dataset(i, :) - centroides(j, :)).^2);
                    % Se dist for menor que closer, essa � uma amostra mais pr�xima.
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
                title("Agrupamento - Clusters: " + K + " Itera��o " + iter);
            end
            %% Rec�lculo dos centroides e do erro
            prev_centroides = centroides;
            for i = 1:K
                centroides(i, :) = mean(dataset(indices == i, :));
            end
            % Armazena a maior dist�ncia entre os clusters das duas �ltimas
            % itera��es.
            err = max(sum((prev_centroides' - centroides').^2));
        end

        %% C�lculo do VRC
        % N�mero de amostras em cada cluster
        n = zeros(1, K);
        for k = 1:K
            n(1, k) = sum(indices == k);
        end

        % Dist�ncia Quadr�tica entre os centr�ides e o centro do dataset.
        d2 = zeros(1, K);
        for k = 1:K
            d2(1, k) = sum((mean(dataset) - centroides(k, :)).^2);
        end

        % Somat�rio de todas as dist�ncias das amostras at� o centr�ide de seu
        % cluster.
        x = zeros(1, K);
        for k = 1:K
            x(1, k) = sum(sum((dataset(indices == k, :) - centroides(k, :)).^2));
        end

        vrc = (sum(n.*d2)/(K-1))/(sum(x)/(nAmostras-K));
        if verbosis
            fprintf("Clusters: %2d\tVRC: %.3f\tItera��es: %d\n", K, vrc, iter);
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