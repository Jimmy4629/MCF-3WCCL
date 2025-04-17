function [WALL3Wconcept] = WeightAll3Wconcept(data)

ALL3Wconcept=All3Wconcept(data);
[numRows,~]=size(ALL3Wconcept);
[nRows,nCols]=size(data);
numConcept=numRows;
H1=cell(numConcept,1);
H2=cell(numConcept,1);
H3=cell(numConcept,1);
H=cell(numConcept,1);
sumH = 0;

for i=1:numConcept
    X=numel(ALL3Wconcept{i,1});
    LP=numel(ALL3Wconcept{i,2});
    LN=numel(ALL3Wconcept{i,3});

    H1{i}=-log(X/nRows)/log(nRows);
    H2{i}=-log((nCols-LP+1)/nCols)/log(nCols);
    H3{i}=-log((nCols-LN)/nCols)/log(nCols); 
    H{i}= (H1{i}+ H2{i}+ H3{i})/3;
    sumH=sumH+H{i};
end

W=cell(numConcept,1);

for i=1:numConcept
    W{i}=(1-H{i})/(numConcept-sumH);
end

WALL3Wconcept=[ALL3Wconcept,W];
end
