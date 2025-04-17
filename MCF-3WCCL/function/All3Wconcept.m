function [uniqueALL3Wconcept] = All3Wconcept(data)
X=X3Wconcept(data);
B1=B1_3Wconcept(data);
B2=B2_3Wconcept(data);

ALL3Wconcept=[X;B1;B2];

empty_rows = find(cellfun(@(x) isempty(x), ALL3Wconcept(:, 1)));

ALL3Wconcept(empty_rows, :) = [];

[~, uniqueIndices, ~] = unique(cellfun(@mat2str, ALL3Wconcept(:,1), 'UniformOutput', false));
uniqueALL3Wconcept = ALL3Wconcept(uniqueIndices, :);

