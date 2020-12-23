function [X]=DCT2(x)

[H,L]=size(x);

%ÓÒ³Ë¾ØÕó
k=0:(L-1);
n=0:(L-1);
C=sqrt(2/L)*cos(pi/L*(n'+1/2)*k)';
C(1,:)=C(1,:)/sqrt(2);

%×ó³Ë¾ØÕó
k=0:(H-1);
n=0:(H-1);
CT=sqrt(2/H)*cos(pi/H*(n'+1/2)*k)';
CT(1,:)=CT(1,:)/sqrt(2);

X=CT*double(x)*C';

end