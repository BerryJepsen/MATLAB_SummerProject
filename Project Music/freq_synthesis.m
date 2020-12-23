Fs=8000;
L=length(realwave);
Y=fft(realwave);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;
subplot(3,1,1);
plot(f,P1);
title('Subplot 1: realwave')

 [mvalue,mindex]=sort(P1,'descend'); %得到频域的降序序列数值和角标
 fundamental=sort(mindex(1:5)); %假设基频是最大的5个频点中最小的
 fundamental=fundamental(1);
 harmonic2=2* (fundamental-1)+1;
 harmonic3=3*(fundamental-1)+1;
 harmonic4=4*(fundamental-1)+1;
 harmonic5=5* (fundamental-1)+1;
 harmonic6=6* (fundamental-1)+1;
 harmonic7=7* (fundamental-1)+1;
 harmonic8=8* (fundamental-1)+1;
 harmonic9=9* (fundamental-1)+1;
 harmonic10=10* (fundamental-1)+1;
%  synthesis=ifft(mvalue(1:10),L);
%  synthesis=abs(synthesis);
t=1:L;
synthesis=P1(fundamental)*sin(2*pi*fundamental*(Fs/L)*t/Fs);
synthesis=synthesis+P1(harmonic2)*sin(2*pi*harmonic2*(Fs/L)*t/Fs);
synthesis=synthesis+P1(harmonic3)*sin(2*pi*harmonic3*(Fs/L)*t/Fs);
synthesis=synthesis+P1(harmonic4)*sin(2*pi*harmonic4*(Fs/L)*t/Fs);
synthesis=synthesis+P1(harmonic5)*sin(2*pi*harmonic5*(Fs/L)*t/Fs);
synthesis=synthesis+P1(harmonic6)*sin(2*pi*harmonic6*(Fs/L)*t/Fs);
synthesis=synthesis+P1(harmonic7)*sin(2*pi*harmonic7*(Fs/L)*t/Fs);
synthesis=synthesis+P1(harmonic8)*sin(2*pi*harmonic8*(Fs/L)*t/Fs);
synthesis=synthesis+P1(harmonic9)*sin(2*pi*harmonic9*(Fs/L)*t/Fs);
synthesis=synthesis+P1(harmonic10)*sin(2*pi*harmonic10*(Fs/L)*t/Fs);
% plot(synthesis);
% hold;
% plot(realwave);
 %fundamental=fundamental*(Fs/L); %还原真实频率值
 %mindex=mindex*(Fs/L);

 

L=length(wave2proc);
Y=fft(wave2proc);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
 
f = Fs*(0:(L/2))/L;
subplot(3,1,2);
plot(f,P1);
title('Subplot 2: wave2proc')

L=length(synthesis);
Y=fft(wave2proc);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
 
f = Fs*(0:(L/2))/L;
subplot(3,1,3);
plot(f,P1,"g");
title('Subplot 3: synthesis')