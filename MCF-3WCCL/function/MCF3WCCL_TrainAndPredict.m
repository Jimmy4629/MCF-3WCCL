function [Outputs, predict_target] = MCF3WCCL_TrainAndPredict(cv_train_data, cv_train_target,cv_test_data,optmParameter)
% cv_train_data   : n by d data matrix
% cv_train_target : n by l label matrix

    model_MCF3WCCL  = MCF3WCCL( cv_train_data, cv_train_target,optmParameter);  
    Outputs     = cv_test_data*model_MCF3WCCL;
    Outputs     = Outputs';
    
    predict_target  = (Outputs>= 0.5);
    predict_target  = double(predict_target);
end