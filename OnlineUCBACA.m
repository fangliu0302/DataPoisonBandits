clear all
close all
clc
tic

K = 2;
mean = [0.2,0];
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
    avg = zeros(K,1);
    cnt = zeros(K,1);
    avgAtt = zeros(K,1);
    for t = 1:T
        if t<= K
            dec = t;
        else
            
            [val, in] = max(avgAtt+3*sigma*sqrt(log(t)./cnt));
            dec = in(1);
            
        end
        % play arm dec and receive reward
        reward = mean(dec) + randn * sigma;
        % update average reward and generate attack
        avg(dec) = (avg(dec)*cnt(dec)+reward)/(cnt(dec)+1);
        cnt(dec) = cnt(dec) + 1;
        if t<= K
            att = 0;
        else
            att = - mask(dec) * max(0,avg(dec)-avg(K)+beta(cnt(dec))+beta(cnt(K)));
        end
        % update average + attack
        avgAtt(dec) = (avgAtt(dec)*(cnt(dec)-1) + reward + att)/cnt(dec);
        
        % For plot
        Target(t) = Target(t) + ind(dec);
        Cost(t) = Cost(t) + abs(att);
    end
end
save(['OnlineUCBACA_sigma=',num2str(sigma),'_Delta=',num2str(mean(1)),'.mat'])
toc