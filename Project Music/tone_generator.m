function [outputarray] = tone_generator(notearray,timearray,fs)
%TONE_GENERATOR 生成可播放序列
%   notearray为唱名序列, timearray为对应的时长序列, fs为采样率
letter2freq = containers.Map(["C","#C","D","#D","E","F","#F","G","#G","A","#A","B","0"],...
    {[261.63],[277.18],[293.66],[311.13],[329.63],[349.23],[369.99],[392],[415.30],[440],[466.16],[493.88],[0]});
number2freq= containers.Map(["4-","#4-","5-","#5-","6-","#6-","7-","1","#1","2","#2","3","4","#4","5","#5","6","#6","7","0","1+","#1+","2+","#2+","3+","4+","#4+","5+","#5+","6+"],...
    {[174.61],[185.00],[196.00],[207.65],[220.00],[233.08],[246.94],[261.63],[277.18],[293.66],[311.13],[329.63],[349.23],[369.99],[392],[415.30],[440.00],[466.16],[493.88],[0],[523.25],[554.36],[587.33],[622.25],[659.26],[698.46],[739.99],[783.99],[830.61],[880.00]});

if (size(notearray))~=(size(timearray))
    disp("dim error");
    return;
end
time=timearray*fs;
tone_length=sum(time);
outputarray=zeros(1,tone_length);
pointer=1;
ascent=1;
descent=1;
decay=1;

for i =1:length(notearray)
    %时间序列和各个频率序列,谐波比例随频率线性变化
    t=1/fs:1/fs:timearray(i);
    if(number2freq(notearray(i))>246 && number2freq(notearray(i))<392 )
        fundamental=((-0.46252/145.06)*(number2freq(notearray(i))-246.94)+0.8929)*sin(2*pi*t*number2freq(notearray(i)));
        harmonic2=((0.23695/145.06)*(number2freq(notearray(i))-246.94)+0.3884)*sin(2*pi*t*number2freq(notearray(i))*2);
        harmonic3=((0.24955/145.06)*(number2freq(notearray(i))-246.94)+0.1599)*sin(2*pi*t*number2freq(notearray(i))*3);
        harmonic4=((0.35756/145.06)*(number2freq(notearray(i))-246.94)+0.1146)*sin(2*pi*t*number2freq(notearray(i))*4);
        harmonic5=((0.01833/145.06)*(number2freq(notearray(i))-246.94)+0.0075)*sin(2*pi*t*number2freq(notearray(i))*5);
        harmonic6=((-0.06218/145.06)*(number2freq(notearray(i))-246.94)+0.1083)*sin(2*pi*t*number2freq(notearray(i))*6);
        harmonic7=((0.12061/145.06)*(number2freq(notearray(i))-246.94)+0.0303)*sin(2*pi*t*number2freq(notearray(i))*7);
        harmonic8=((0.02834/145.06)*(number2freq(notearray(i))-246.94)+0.0256)*sin(2*pi*t*number2freq(notearray(i))*8);
    end
    
    if(number2freq(notearray(i))>=392)
        fundamental=0.43038*sin(2*pi*t*number2freq(notearray(i)));
        harmonic2=0.62535*sin(2*pi*t*number2freq(notearray(i))*2);
        harmonic3=0.40945*sin(2*pi*t*number2freq(notearray(i))*3);
        harmonic4=0.47216*sin(2*pi*t*number2freq(notearray(i))*4);
        harmonic5=0.02583*sin(2*pi*t*number2freq(notearray(i))*5);
        harmonic6=0.04612*sin(2*pi*t*number2freq(notearray(i))*6);
        harmonic7=0.15091*sin(2*pi*t*number2freq(notearray(i))*7);
        harmonic8=0.05394*sin(2*pi*t*number2freq(notearray(i))*8);
    end
    
    if (number2freq(notearray(i))<= 246)
        fundamental=0.8929*sin(2*pi*t*number2freq(notearray(i)));
        harmonic2=0.3884*sin(2*pi*t*number2freq(notearray(i))*2);
        harmonic3=0.1599*sin(2*pi*t*number2freq(notearray(i))*3);
        harmonic4=0.1146*sin(2*pi*t*number2freq(notearray(i))*4);
        harmonic5=0.0075*sin(2*pi*t*number2freq(notearray(i))*5);
        harmonic6=0.1083*sin(2*pi*t*number2freq(notearray(i))*6);
        harmonic7=0.0303*sin(2*pi*t*number2freq(notearray(i))*7);
        harmonic8=0.0256*sin(2*pi*t*number2freq(notearray(i))*8);
    end
   
    
    %过冲, 衰减比率 
    decay=floor(0.5*length(t));
    ascent=ceil(0.07*length(t));
    descent=ceil(0.12*length(t));
    
%     %基频包络
%     fundamental(1:ascent)=fundamental(1:ascent).*exp(3*(t(1:ascent)/t(ascent)-0.9));
%     fundamental(ascent+1:descent)=fundamental(ascent+1:descent).*exp(0.72-0.72.*t(ascent+1:descent)/t(descent));
%     fundamental(decay:end)=fundamental(decay:end).*exp(-4*(t(decay:end)/t(decay)).^2+8.*t(decay:end)/t(decay)-4);
%     
%     %二次谐波包络
%     harmonic2(1:ascent)=harmonic2(1:ascent).*exp(3*(t(1:ascent)/t(ascent)-0.9));
%     harmonic2(ascent+1:descent)=harmonic2(ascent+1:descent).*exp(0.72-0.72.*t(ascent+1:descent)/t(descent));
%     harmonic2(decay:end)=harmonic2(decay:end).*exp(-4*(t(decay:end)/t(decay)).^2+8.*t(decay:end)/t(decay)-4);
%     
%     %三次谐波包络
%     harmonic3(1:ascent)=harmonic3(1:ascent).*exp(3*(t(1:ascent)/t(ascent)-0.9));
%     harmonic3(ascent+1:descent)=harmonic3(ascent+1:descent).*exp(0.72-0.72.*t(ascent+1:descent)/t(descent));
%     harmonic3(decay:end)=harmonic3(decay:end).*exp(-4*(t(decay:end)/t(decay)).^2+8.*t(decay:end)/t(decay)-4);
%     
%     %四次谐波包络
%     harmonic4(1:ascent)=harmonic4(1:ascent).*exp(3*(t(1:ascent)/t(ascent)-0.9));
%     harmonic4(ascent+1:descent)=harmonic4(ascent+1:descent).*exp(0.72-0.72.*t(ascent+1:descent)/t(descent));
%     harmonic4(decay:end)=harmonic4(decay:end).*exp(-4*(t(decay:end)/t(decay)).^2+8.*t(decay:end)/t(decay)-4);
%     
%     %五次谐波包络
%     harmonic5(1:ascent)=harmonic5(1:ascent).*exp(3*(t(1:ascent)/t(ascent)-0.9));
%     harmonic5(ascent+1:descent)=harmonic5(ascent+1:descent).*exp(0.72-0.72.*t(ascent+1:descent)/t(descent));
%     harmonic5(decay:end)=harmonic5(decay:end).*exp(-4*(t(decay:end)/t(decay)).^2+8.*t(decay:end)/t(decay)-4);
%     
%     %六次谐波包络
%     harmonic6(1:ascent)=harmonic6(1:ascent).*exp(3*(t(1:ascent)/t(ascent)-0.9));
%     harmonic6(ascent+1:descent)=harmonic6(ascent+1:descent).*exp(0.72-0.72.*t(ascent+1:descent)/t(descent));
%     harmonic6(decay:end)=harmonic6(decay:end).*exp(-4*(t(decay:end)/t(decay)).^2+8.*t(decay:end)/t(decay)-4);
%     
%     %七次谐波包络
%     harmonic7(1:ascent)=harmonic7(1:ascent).*exp(3*(t(1:ascent)/t(ascent)-0.9));
%     harmonic7(ascent+1:descent)=harmonic7(ascent+1:descent).*exp(0.72-0.72.*t(ascent+1:descent)/t(descent));
%     harmonic7(decay:end)=harmonic7(decay:end).*exp(-4*(t(decay:end)/t(decay)).^2+8.*t(decay:end)/t(decay)-4);
%     
%     %八次谐波包络
%     harmonic8(1:ascent)=harmonic8(1:ascent).*exp(3*(t(1:ascent)/t(ascent)-0.9));
%     harmonic8(ascent+1:descent)=harmonic8(ascent+1:descent).*exp(0.72-0.72.*t(ascent+1:descent)/t(descent));
%     harmonic8(decay:end)=harmonic8(decay:end).*exp(-4*(t(decay:end)/t(decay)).^2+8.*t(decay:end)/t(decay)-4);
    
    %加和信号
    outputarray(pointer:pointer+length(t)-1)=fundamental;
    outputarray(pointer:pointer+length(t)-1)=outputarray(pointer:pointer+length(t)-1)+harmonic2;
    outputarray(pointer:pointer+length(t)-1)=outputarray(pointer:pointer+length(t)-1)+harmonic3;
    outputarray(pointer:pointer+length(t)-1)=outputarray(pointer:pointer+length(t)-1)+harmonic4;
    outputarray(pointer:pointer+length(t)-1)=outputarray(pointer:pointer+length(t)-1)+harmonic5;
    outputarray(pointer:pointer+length(t)-1)=outputarray(pointer:pointer+length(t)-1)+harmonic6;
    outputarray(pointer:pointer+length(t)-1)=outputarray(pointer:pointer+length(t)-1)+harmonic7;
    outputarray(pointer:pointer+length(t)-1)=outputarray(pointer:pointer+length(t)-1)+harmonic8;    
    
    %统一添加包络
    outputarray(pointer+1:pointer+ascent)=outputarray(pointer+1:pointer+ascent).*exp(3*(t(1:ascent)/t(ascent)-0.9));
    outputarray(pointer+ascent+1:pointer+descent)=outputarray(pointer+ascent+1:pointer+descent).*exp(0.72-0.72.*t(ascent+1:descent)/t(descent));
    outputarray(pointer+decay-1:pointer+length(t)-1)=outputarray(pointer+decay-1:pointer+length(t)-1).*exp(-4*(t(decay:end)/t(decay)).^2+8.*t(decay:end)/t(decay)-4);
    
    %移动指针
    pointer=pointer+length(t);
end

end

