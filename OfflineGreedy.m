clear all
close all
clc
tic

K = 5;
mean = [1,1,1,1,0];
mask = [1,1,1,1,0];
ind  = [0,0,0,0,1];
minMean = 0;%0.2;

T = 1000;
outloop = 1000;
%delta = 0.05;
sigma = 0.1;
xi = 0.001;

%for plot
success = 0;
ratioHub = zeros(outloop,1);
for out = 1:outloop
    display(out)
    % initialize the mean of all the non-target arms
    for a = 1:(K-1)
        mean(a) = rand;
    end
    % arm a<K is the non-target arm while arm K is the target arm
    avg = zeros(K,1);
    cnt = zeros(K,1);
    ynorm = 0;
    for t = 1:T
        if t<= K
            dec = t;
        else
            epsilon = 1/t;
            tmp = rand;
            if tmp<epsilon
                dec = randi(K);
            else
                [val, in] = max(avg);
                dec = in(1);
            end
        end
        % play arm dec and receive reward
        reward = mean(dec) + randn * sigma;
        % update average reward and generate attack
        avg(dec) = (avg(dec)*cnt(dec)+reward)/(cnt(dec)+1);
        cnt(dec) = cnt(dec) + 1;
        
        % for plot
        ynorm = ynorm + reward*reward;
    end
    
    % offline attack is a quadratic programming with linear constraints
    H = eye(T);
    A = zeros(K-1,T);
    offset = 0;
    for i = 1:(K-1)
        A(i,offset+1:offset+cnt(i)) = ones(1,cnt(i))/cnt(i);
        A(i,T-cnt(K)+1:T) = -ones(1,cnt(K))/cnt(K);
        offset = offset + cnt(i);
    end
    b = ones(K-1,1)*avg(K);
    for i = 1:(K-1)
        b(i) = b(i) - avg(i) - xi;
    end
    x = quadprog(H,[],A,b);
    
    % for plot
    ratio = sqrt(x'*x/ynorm);
    ratioHub(out) = ratio;
    % we can check Ax <= b or directly the average after attack.
    C = zeros(K,T);
    offset = 0;
    for i = 1:K
        C(i,offset+1:offset+cnt(i)) = ones(1,cnt(i))/cnt(i);
        offset = offset + cnt(i);
    end
    [val,in] = max(avg + C * x);
    dec = in(1);
    success = success + ind(dec);
end
save(['OfflineGreedy_sigma=',num2str(sigma),'.mat'])
toc