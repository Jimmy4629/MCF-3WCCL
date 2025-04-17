function [optmParameter, modelparameter] =  initialization
    optmParameter.alpha   = 4^(-4); 
    optmParameter.beta    = 4^(-3); 
    optmParameter.gamma   = 0.3;  
    optmParameter.maxIter           = 100;
    optmParameter.miniLossMargin = 0.001;

   %% Model Parameters
    modelparameter.crossvalidation    = 1; % {0,1}
    modelparameter.cv_num             = 5;
    modelparameter.L2Norm             = 1; 
    modelparameter.tuneparameter      = 0; %{0,1}
    
    modelparameter.searchbestparas    = 0; % {0,1}
    modelparameter.alpha_searchrange  = 4.^[-5:5]; 
    modelparameter.beta_searchrange   = 4.^[-5:5];
    modelparameter.gamma_searchrange  = 0:0.1:1;

end