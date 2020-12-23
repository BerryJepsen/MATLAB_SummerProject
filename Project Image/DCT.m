function [X]=DCT(x)

N=length(x);
k=0:(N-1);
n=0:(N-1);
C=cos(pi/N*(n'+1/2)*k);
X=sqrt(2/N)*double(x)*C;
X(1)=X(1)/sqrt(2);

end