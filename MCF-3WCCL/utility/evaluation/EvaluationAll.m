
function ResultAll = EvaluationAll(Pre_Labels,Outputs,test_target)

    ResultAll=zeros(5,1); 

    HammingLoss=Hamming_loss(Pre_Labels,test_target);
    
    RankingLoss=Ranking_loss(Outputs,test_target);
    OneError=One_error(Outputs,test_target);
    Coverage=coverage(Outputs,test_target);
    Average_Precision=Average_precision(Outputs,test_target);
    
    ResultAll(1,1)=Average_Precision;
    ResultAll(2,1)=Coverage;
    ResultAll(3,1)=OneError;
    ResultAll(4,1)=RankingLoss;

    ResultAll(5,1)=HammingLoss;
end