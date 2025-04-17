function [uniqueB2] = B2_3Wconcept(data)

numCols = size(data, 2);
B2 = cell(numCols, 3);

for i = 1:numCols
    oneIndiceCols = find(data(:, i) == 0);
    tupleX2 = [];
    tupleX2 = [tupleX2,oneIndiceCols];
    tupleA2 = [];
    tupleAc2 = [];

    for j = 1:numCols
        otherOneIndiceCols = find(data(:, j) == 0);
        otherOneIndiceCols0 = find(data(:, j) == 1);
        if all(ismember(oneIndiceCols, otherOneIndiceCols))
            tupleAc2 = [tupleAc2, j];
        end
        if all(ismember(oneIndiceCols, otherOneIndiceCols0))
            tupleA2 = [tupleA2, j];
        end
    end

    B2{i,1} = tupleX2';
    B2{i,2} = tupleA2;
    B2{i,3} = tupleAc2;
end

[~, uniqueIndices, ~] = unique(cellfun(@mat2str, B2(:,1), 'UniformOutput', false));
uniqueB2 = B2(uniqueIndices, :);