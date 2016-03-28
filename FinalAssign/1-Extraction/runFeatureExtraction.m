function runFeatureExtraction()

    clusters = {400, 800, 1200, 1600};
    samplings = {'point'};
    for s=1:length(samplings)
        samplings{s}
        for k=1:length(clusters)
        
            pipeLine(50, 'train', samplings{s}, clusters{k});
        end
    end



end % runFeatureExtraction