function [ c,ceq, gradc, gradceq ] = TScon(x, avg,cnt,sigma,delta )
K = length(avg);
T = sum(cnt);
A = zeros(K,T);
offset = 0;
for i = 1:K
    A(i,offset+1:offset+cnt(i)) = ones(1,cnt(i))/cnt(i);
    offset = offset + cnt(i);
end
avgAtt = avg + A*x;
c = 0;
for i = 1:(K-1)
    c = c+ normcdf((avgAtt(i) - avgAtt(K))/sigma/sigma/sigma/sqrt(1/cnt(i)+1/cnt(K)));
end
c = c-delta;
ceq = [];
if nargout > 2
    gradc = zeros(T,1);
    Const = zeros(K,1);
    for i = 1:(K-1)
        Const(i) = 1/sigma/sigma/sigma/sqrt(1/cnt(i)+1/cnt(K));
    end
    preGrad = zeros(K,1);
    for i = 1:(K-1)
        preGrad(i) = Const(i)/sqrt(2*pi)*exp(-(Const(i)*(avgAtt(i)-avgAtt(K)))^2/2);
        preGrad(K) = preGrad(K) - preGrad(i);
    end
    offset = 0;
    for i = 1:K
        gradc(offset+1:offset+cnt(i)) = ones(cnt(i),1)*preGrad(i)/cnt(i);
        offset = offset + cnt(i);
    end
    gradceq = [];

end

