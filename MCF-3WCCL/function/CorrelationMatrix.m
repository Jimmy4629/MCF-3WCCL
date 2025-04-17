function [rex,rin] = CorrelationMatrix(train_data,train_target)

data = horzcat(train_data,train_target);
Fn = size(train_data,2);
Ln = size(train_target,2);

A1=data;
[n00,m0]=size(A1);
AL=cell(Ln,1);
ALc=cell(Ln,1);
ALN=cell(Ln,1);
Ldata=cell(Ln,1);

WAll3Wlabelconcept=cell(Ln,1);
numConcept=cell(Ln,1);
for i=1:Ln
    ce=find(A1(:,Fn+i)==1); 
    ALN{i}=ce;
    AL{i}=A1(ce,:);  
    [n(i),~]=size(AL{i}); 
    ALc{i}=1-AL{i}(:,1:Fn);
    ALc{i}(:,Fn+1:m0)=AL{i}(:,Fn+1:m0);
    Ldata{i}=AL{i}(:,Fn+1:m0);

    WAll3Wlabelconcept{i}=WeightAll3Wconcept(Ldata{i});
    [numConcept{i},~]=size(WAll3Wlabelconcept{i});
end

Bz=cell(Ln,1); Bf=cell(Ln,1);
wBz=cell(Ln,1);wBf=cell(Ln,1); 
WBz=cell(Ln,1);WBf=cell(Ln,1); 
WB=cell(Ln,1);
for i=1:Ln
    for j=1:numConcept{i}
        if length(WAll3Wlabelconcept{i}{j,1})>1
            Bz{i}(j,:)=min(AL{i}(WAll3Wlabelconcept{i}{j,1},1:Fn)); 
            Bf{i}(j,:)=min(ALc{i}(WAll3Wlabelconcept{i}{j,1},1:Fn)); 
        else
            Bz{i}(j,:)=AL{i}(WAll3Wlabelconcept{i}{j,1},1:Fn); 
            Bf{i}(j,:)=ALc{i}(WAll3Wlabelconcept{i}{j,1},1:Fn); 
        end
        wBz{i}(j,:)=WAll3Wlabelconcept{i}{j,4}*Bz{i}(j,:); 
        wBf{i}(j,:)=WAll3Wlabelconcept{i}{j,4}*Bf{i}(j,:); 
    end
    if numConcept{i}==1
        WBz{i}=Bz{i};
        WBf{i}=Bf{i};
        WB{i}=[WBz{i},WBf{i}];
    else
        WBz{i}=sum(wBz{i});
        WBf{i}=sum(wBf{i});
        WB{i}=[WBz{i},WBf{i}];
    end
    if numConcept{i}==0
        WB{i}= zeros(1, 2*Fn); 
        WB{i}(1)=10^(-5);
        ALN{i}=n00+1;
    end
end

rex=zeros(Ln);
rin=zeros(Ln);
for i=1:Ln
    for j=1:Ln
        rex(i,j)=length(intersect(ALN{i},ALN{j}))/length(union(ALN{i},ALN{j}));
        rin(i,j)= dot(WB{i}, WB{j}) / (norm(WB{i}) * norm(WB{j}));
    end
end


























