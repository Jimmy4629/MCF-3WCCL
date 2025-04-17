function [BestParameter, BestResult] = MCF3WCCL_adaptive_validate(train_data, train_target, oldoptmParameter, modelparameter, BestParameters_filename)

    num_train = size(train_data, 1);
    randorder = randperm(num_train);
    optmParameter = oldoptmParameter;

    alpha_searchrange = modelparameter.alpha_searchrange;
    beta_searchrange = modelparameter.beta_searchrange;
    gamma_searchrange = modelparameter.gamma_searchrange;

    num_cv = 5;
    BestResult = zeros(6, 1);
    index = 1;
    total = length(alpha_searchrange) * length(beta_searchrange) * length(gamma_searchrange);

    fid_best = fopen(BestParameters_filename, 'wt'); 
    
    All_results = cell(total,15);
    z = 1;
    
    for i = 1:length(alpha_searchrange) % alpha
        for j = 1:length(beta_searchrange) % beta
            for k = 1:length(gamma_searchrange) % gamma
                fprintf('\n-   %d-th/%d: searching parameter for MCF-3WCCL, alpha = %f, beta = %f, gamma = %f\n',...
                    index, total, alpha_searchrange(i), beta_searchrange(j), gamma_searchrange(k));

                optmParameter.alpha = alpha_searchrange(i); 
                optmParameter.beta = beta_searchrange(j);  
                optmParameter.gamma = gamma_searchrange(k); 

                optmParameter.maxIter = 100;
                optmParameter.miniLossMargin = 0.1;
                Avg_Result = zeros(5, 2);
                cv_Result = zeros(5, num_cv);

                for cv = 1:num_cv
                    [cv_train_data, cv_train_target, cv_test_data, cv_test_target] = generateCVSet(train_data, train_target, randorder, cv, 5);
                    model_MCF3WCCL = MCF3WCCL(cv_train_data, cv_train_target, optmParameter); 
                    [~, cv_predict_target] = MCF3WCCL_TrainAndPredict(cv_train_data, cv_train_target, cv_test_data, optmParameter);
                    [Pre_Labels, Outputs] = MCF3WCCL_Predict(model_MCF3WCCL, cv_test_data, cv_predict_target, 3);

                    cv_Result(:,cv) = EvaluationAll(Pre_Labels, Outputs, cv_test_target');
                end

                Avg_Result(:,1) = mean(cv_Result,2);
                Avg_Result(:,2) = std(cv_Result,1,2);

                r = IsBetterThanBefore(BestResult, Avg_Result(:,1));

                All_results{z,1} = alpha_searchrange(i);
                All_results{z,2} = beta_searchrange(j);
                All_results{z,3} = gamma_searchrange(k);

                All_results{z,4}= Avg_Result(1,1);%AP
                All_results{z,5}= Avg_Result(1,2);%AP_std
                All_results{z,6}= Avg_Result(2,1);%CV
                All_results{z,7}= Avg_Result(2,2);%CV_std
                All_results{z,8}= Avg_Result(3,1);%OE
                All_results{z,9}= Avg_Result(3,2);%OE_std
                All_results{z,10}= Avg_Result(4,1);%RL
                All_results{z,11}= Avg_Result(4,2);%RL_std
                All_results{z,12}= Avg_Result(5,1);%HL
                All_results{z,13}= Avg_Result(5,2);%HL_std

                z = z+1;

                if r == 1
                    BestResult = Avg_Result;
                    BestParameter = optmParameter;

                    fprintf(fid_best, '\n-   %d-th/%d: search parameter for MCF-3WCCL, alpha = %f, beta = %f, gamma = %f\n',...
                        index, total, alpha_searchrange(i), beta_searchrange(j), gamma_searchrange(k));
                    for aa = 1:5
                        fprintf(fid_best, '%.4f\n', BestResult(aa, 1));
                    end
                    fprintf(fid_best, '--------------------\n');
                    for aa = 1:5
                        fprintf(fid_best, '%.4f\n', BestResult(aa, 2));
                    end
                end

                index = index + 1;

            end % for k
        end % for j
    end
end

% Auxiliary function to compare results
function r = IsBetterThanBefore(Result, CurrentResult)
    a = CurrentResult(1, 1);
    b = Result(1, 1) ;
    
    AP=Result(1, 1)    
    CV= Result(2, 1)
    OE= Result(3, 1)
    RL= Result(4, 1)
    HL= Result(5, 1)
    
    a2 = CurrentResult(5, 1);
    b2 = Result(5, 1);

    if a > b 
        r = 1;
    elseif a == b && a2 < b2
        r = 1;
    else
        r = 0;
    end
end

