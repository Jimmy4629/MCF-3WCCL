function [Pre_Labels,Outputs] = MCF3WCCL_Predict(model_MCF3WCCL, cv_test_data, Pre_Labels, num_iteration)
    
    for i =1:num_iteration
        Outputs = cv_test_data*model_MCF3WCCL;
        Outputs       = Outputs';
        
        Pre_Labels  = round(Outputs);
        Pre_Labels  = (Pre_Labels>= 0.5);
        Pre_Labels  = double(Pre_Labels);
    end
end