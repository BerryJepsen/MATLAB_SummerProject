[y, Fs]=audioread("fmt.wav");
L=length(y);
step=Fs/20;%步长0.05s
tmp=ceil(L/(step));%0.05s的整数倍长度
tmp=tmp* (step);
y=[y; zeros(tmp-L,1)];%paddle
%y=resample(y,tmp,L);%重采样
 L=length(y);
fc =500;
[b,a] = butter(10,fc/(Fs/2),'low');
y = filter(b,a,y);
y=y*3;

fc=200;
[b,a] = butter(10,fc/(Fs/2),'high');
y = filter(b,a,y);
y=y*5;
y=smoothdata(y,'gaussian',15);

stepnum=(L/step);%步数
pointer=1;

freq_series=zeros(stepnum,1);

for i=1:stepnum-1
    Y=fft(y(pointer:pointer+step));
    P2 = abs(Y/step);
    P1 = P2(1:step/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    [mvalue,mindex]=sort(P1,'descend'); %得到频域的降序序列数值和角标
    fundamental=sort(mindex(1:1)); %假设基频是5个幅度最大的频率中最小的
    fundamental=fundamental(1);
    fundamental=fundamental*(Fs/step); %还原真实频率值
    freq_series(i)=fundamental;
    pointer=pointer+step;
end
subplot(2,1,1);
plot(freq_series);
title("未处理的频率序列");

pointer=1;
while(pointer<stepnum)
    if length(freq_series)-pointer<5
        freq_series(pointer:end)=mode(freq_series(pointer:end));
        break;
    end
    freq_series(pointer:pointer+5)=mode(freq_series(pointer:pointer+5));
    pointer=pointer+5;
end

subplot(2,1,2);
plot(freq_series);
title("平滑后的频率序列");

pointer=1;
synthesis=zeros(L,1);
for i=1:stepnum-1
    t=1/Fs:1/Fs:step/Fs;
    synthesis(pointer:pointer+step-1)=sin(2*pi*freq_series(i)*t);
    pointer=pointer+step;
end

% [b,a] = butter(6,0.5);
% plot(freq_series);
% hold;
% plot(filter(b,a,freq_series));

% Y=fft(y);
% P2 = abs(Y/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% 
% f = Fs*(0:(L/2))/L;
% plot(f,P1);
% 
%  [mvalue,mindex]=sort(P1,'descend'); %得到频域的降序序列数值和角标
%  fundamental=sort(mindex(1:5)); %假设基频是最大的5个频点中最小的
%  fundamental=fundamental(1);
%  fundamental=fundamental*(Fs/L); %还原真实频率值
 
 