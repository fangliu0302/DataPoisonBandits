clear all
close all
clc
tic

K = 2;
mean = [1,0];
mask = [1,0];
ind = [0,1];

T = 1e5;
outloop = 100;
delta = 0.05;
sigma = 0.1;
beta = @(n) sqrt(2*sigma*sigma/n*log(pi*pi*K*n*n/3/delta));

Target = zeros(T,1);
Cost = zeros(T,1);
for out = 1:outloop
    display(out)
    % arm 1 is the optimal arm while arm 2 is the target arm
    %avg = zeros(K,1);
    cnt = zeros(K,1);
    avgAtt = zeros(K,1);
    for t = 1:T
        if t<=K
            dec = t;
        else
            epsilon = 1/t;
            tmp = rand;
            if tmp<epsilon
                dec = randi(K);
            else
                [val, in] = max(avgAtt);
                dec = in(1);
            end
        end
        % play arm dec and receive reward
        reward = mean(dec) + randn * sigma;
        % generate attack
        if t<=K
            att = 0;
        else
            att = - mask(dec) * max(0,avgAtt(dec)*cnt(dec)+reward - (avgAtt(K)-2*beta(cnt(K)))*(cnt(dec)+1));
        end
        % update average + attack
        avgAtt(dec) = (avgAtt(dec)*cnt(dec) + reward + att)/(cnt(dec)+1);
        cnt(dec) = cnt(dec)+1;
        
        % For plot
        Target(t) = Target(t) + ind(dec);
        Cost(t) = Cost(t) + abs(att);
    end
end
save(['OnlineGreedyNIPS_sigma=',num2str(sigma),'_Delta=',num2str(mean(1)),'.mat'])
toc