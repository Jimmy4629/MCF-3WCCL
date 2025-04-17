warning off %#ok<WNOFF>
addpath(genpath('.'));
clc
clear all
load 'data/medical.mat';
BestParameters_filename = sprintf('medical_BestResult_%s.txt', datestr(now, 'yyyymmdd_HHMMSS'));

[optmParameter, modelparameter] =  initialization;
model_MCF3WCCL.optmParameter = optmParameter;
model_MCF3WCCL.modelparameter = modelparameter;

if exist('train_data','var')==1
    data    = [train_data;test_data];
    target  = [train_target,test_target];
end

% target = targets';

zeroColumns = all(target == 0, 1);
target(:, zeroColumns) = [];
target(target == -1) = 0;

data      = double (data);
num_data  = size(data,1);
temp_data = data + eps;

if modelparameter.L2Norm == 1 
    temp_data = temp_data./repmat(sqrt(sum(temp_data.^2,2)),1,size(temp_data,2));
    if sum(sum(isnan(temp_data)))>0
        temp_data = data+eps;
        temp_data = temp_data./repmat(sqrt(sum(temp_data.^2,2)),1,size(temp_data,2));
    end
end

if modelparameter.tuneparameter==1 
    randorder = 1:num_data; 
else
    randorder = randperm(num_data);
end

cvResult  = zeros(5,modelparameter.cv_num);

if modelparameter.searchbestparas == 1 
        fprintf('\n-  parameterization for MCF-3WCCL by cross validation on the training data');
        [ BestParameter, BestResult] = MCF3WCCL_adaptive_validate(temp_data, target',optmParameter,modelparameter,BestParameters_filename);
else 
    for j = 1:modelparameter.cv_num
        fprintf('- Cross Validation - %d/%d  ', j, modelparameter.cv_num);
        [cv_train_data,cv_train_target,cv_test_data,cv_test_target ] = generateCVSet( temp_data,target',randorder,j,modelparameter.cv_num );

        W  = MCF3WCCL( cv_train_data, cv_train_target,optmParameter); 
        [~, cv_predict_target] = MCF3WCCL_TrainAndPredict(cv_train_data, cv_train_target,cv_test_data,optmParameter);
            
        [Pre_Labels,Outputs] = MCF3WCCL_Predict(W, cv_test_data, cv_predict_target, 3);
        cvResult(:,j) = EvaluationAll(Pre_Labels,Outputs,cv_test_target')
    end

    Avg_Result      = zeros(5,2);
    Avg_Result(:,1) = mean(cvResult,2);
    Avg_Result(:,2) = std(cvResult,1,2);
    PrintResults(Avg_Result);

end