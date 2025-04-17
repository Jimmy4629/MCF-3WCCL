function [uniqueA] = X3Wconcept(data)

numRows = size(data, 1);
A = cell(numRows, 3);

for i = 1:numRows
    oneIndices = find(data(i, :) == 1);
    oneIndices0 = find(data(i, :) == 0);

    tupleX = [];
    tupleA = [];
    tupleAc = [];
    tupleA = [tupleA,oneIndices];
    tupleAc = [tupleAc,oneIndices0];
    
    for j = 1:numRows
        otherOneIndices = find(data(j, :) == 1);
        otherOneIndices0 = find(data(j, :) == 0);
        
        if all(ismember(oneIndices, otherOneIndices))&&all(ismember(oneIndices0, otherOneIndices0))
            tupleX = [tupleX, j];
        end
    end
    
    A{i,1} = tupleX;
    A{i,2} = tupleA;
    A{i,3} = tupleAc;
end

[~, uniqueIndices, ~] = unique(cellfun(@mat2str, A(:,1), 'UniformOutput', false));
uniqueA = A(uniqueIndices, :);



