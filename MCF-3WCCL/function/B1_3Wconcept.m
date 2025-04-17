function [uniqueB1] = B1_3Wconcept(data)

numCols = size(data, 2);
B1 = cell(numCols, 3);

for i = 1:numCols
    oneIndiceCols = find(data(:, i) == 1);
    tupleX1 = [];
    tupleX1 = [tupleX1,oneIndiceCols];
    tupleA1 = [];
    tupleAc1 = [];

    for j = 1:numCols
        otherOneIndiceCols = find(data(:, j) == 1);
        otherOneIndiceCols0 = find(data(:, j) == 0);
        if all(ismember(oneIndiceCols, otherOneIndiceCols))
            tupleA1 = [tupleA1, j];
        end
        if all(ismember(oneIndiceCols, otherOneIndiceCols0))
            tupleAc1 = [tupleAc1, j];
        end
    end
    B1{i,1} = tupleX1';
    B1{i,2} = tupleA1;
    B1{i,3} = tupleAc1;
end

[~, uniqueIndices, ~] = unique(cellfun(@mat2str, B1(:,1), 'UniformOutput', false));
uniqueB1 = B1(uniqueIndices, :);
