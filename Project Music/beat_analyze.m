[y, Fs]=audioread("fmt.wav");
L=length(y);
step=Fs/20;%步长0.05s
tmp=ceil(L/(step));%0.05s的整数倍长度
tmp=tmp* (step);
L=length(y);
ax=1:L;

subplot(2,2,1);
plot(y);
title("原音频序列");

Y=fft(y);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

subplot(2,2,2);
plot(P1);
title("原音频频谱");

[yupper,ylower] = envelope(y,200,'rms');
yupper=smoothdata(yupper,'gaussian',20);
fc =5;
[b,a] = butter(4,fc/(Fs/2),'low');
yupper = filter(b,a,yupper);
yupper=smoothdata(yupper,'gaussian',100);

[pks,locs] = findpeaks(yupper,'MinPeakDistance',ceil(Fs/3));

subplot(2,2,3);
plot(ax,yupper,ax(locs),pks,'or');
title("滤波后音频序列");
axis tight

subplot(2,2,4);
interval=locs(2:end)-locs(1:end-1);
interval=interval/Fs;
ax=1:length(interval);
plot(ax,interval);
hold;

% TF = isoutlier(interval);
% ind = find(TF);
% Aoutlier = interval(ind);
interval = filloutliers(interval,'previous');%离群值检测替代
interval=smoothdata(interval,'movmedian',3);
plot(ax,interval);
title("音符间隔");
ylabel('Time/S')

beat=mean(interval,'omitnan');
beat=floor(60/beat);
disp(beat);


%  Y=fft(yupper);
%  P2 = abs(Y/L);
%  P1 = P2(1:L/2+1);
%  P1(2:end-1) = 2*P1(2:end-1);
%  
% subplot(2,2,4);
% plot(P1);
% title("滤波后音频频谱");
 
 
 