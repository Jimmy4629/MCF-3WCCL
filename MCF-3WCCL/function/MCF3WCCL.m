function [W_opt] = MCF3WCCL(X, Y, optmParameter)
%   X:  (n_samples ¡Á n_features)
%   Y:  (n_samples ¡Á n_labels)
alpha = optmParameter.alpha;
beta = optmParameter.beta;
gamma = optmParameter.gamma;
maxIter = optmParameter.maxIter;
miniLossMargin   = optmParameter.miniLossMargin;

[rex,rin] = CorrelationMatrix(X,Y);
R = gamma*rex + (1-gamma)*rin;

[n, d] = size(X);

W = (X'*X + eye(d)) \ (X'*Y); 
W_prev = W;

XTX = X'*X;
Lip = norm(XTX, 2) + 4*alpha*(norm(W'*W, 2) + norm(R, 2));
step = 1/Lip;

t = 1; t_prev = 1;
prev_loss = inf;

for iter = 1:maxIter
    t_new = (1 + sqrt(1 + 4*t^2))/2;
    eta = (t_prev - 1)/t_new;
    V = W + eta*(W - W_prev);
    
    grad_data = XTX*V - X'*Y;
    grad_struct = 2*alpha*V*(V'*V - R);
    grad = grad_data + grad_struct;
    
    W_new = V - step*grad;
    W_new = softthres(W_new, step*beta); 
    
    term1 = 0.5*norm(X*W_new - Y, 'fro')^2;
    term2 = 0.5*alpha*norm(W_new'*W_new - R, 'fro')^2;
    term3 = beta*sum(abs(W_new(:)));
    total_loss = term1 + term2 + term3;
    
    if abs(prev_loss - total_loss)/prev_loss < miniLossMargin
        break;
    end
    
    W_prev = W;
    W = W_new;
    t_prev = t;
    t = t_new;
    prev_loss = total_loss;
end

W_opt = W;
end

function W = softthres(W, lambda)
    W = sign(W).*max(abs(W) - lambda, 0);
end

