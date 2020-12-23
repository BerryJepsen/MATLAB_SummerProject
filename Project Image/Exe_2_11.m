%加载资源
load hall.mat 
load jpegcodes.mat
load JpegCoeff.mat 

raw_img=hall_gray;
%DC解码
DC_d_r = DC_decode(DC_series,DCTAB);
%还原差分
DC_r=zeros(size(DC_d_r));
DC_r(1)=DC_d_r(1);
for i=2:length(DC_r)
    DC_r(i) = DC_r(i-1)-DC_d_r(i);
end

% AC解码
AC_r = AC_decode(AC_series,ACTAB);

%还原图像
C_rr=[DC_r;AC_r];
H=ceil(h/8);
W=ceil(w/8);
pic=zeros(H*8,W*8);
C_r=mat2cell(pic,ones(H,1)*8,ones(W,1)*8);
%反zigzag扫描
count=1;
for i=1:H
    for j=1:W
        C_r(i,j)=mat2cell(iZigzag(C_rr(:,count)),8,8);
        count=count+1;
    end
end
pic=cell2mat(C_r);
%反量化
fun= @(block_struct) block_struct.data.*QTAB;
pic=blockproc(pic,[8,8],fun);
%反dct
fun = @(block_struct) idct2(block_struct.data);
pic=blockproc(pic,[8,8],fun);
%反预处理
pic=pic+128;
pic=ceil(pic);
%裁剪还原
pic(pic<0) = 0;
pic(pic>255)=255;
pic = pic(1:h,1:w);
pic=uint8(pic);

%显示比较
subplot(2,1,1);
imshow(raw_img);
title("原图");
subplot(2,1,2);
imshow(pic);
title("压缩后");

% 评价解码结果
MSE = mean((raw_img-pic).^2,'all');
PSNR = 10*log10(255*255/MSE);
disp(['PSNR为',num2str(PSNR)]);


%DC解码函数, 输出差分DC码
function dc = DC_decode(dc_series,DCTAB)
dc = [];
Start=1;
End=1;
while End<=length(dc_series) 
    test = zeros(1,9);
    Len = End-Start+1;
    test(1:Len)=dc_series(Start:End); 
    match_rindex = find(all(DCTAB(:,2:end)==test,2));
    %匹配情况
    if ~isempty(match_rindex) && DCTAB(match_rindex,1)==Len  
        category = match_rindex(1)-1;   
        %DC=0
        if category==0
            dc = [dc,0];
         %DC!=0
        else
            %判断正负
            tmp=dc_series(End+1:End+category);
            if tmp(1)==0 
               tmp(:)=~tmp(:);
               dc_value =-bin2dec(num2str(tmp));
            else
               dc_value = bin2dec(num2str(tmp)); 
            end
            dc = [dc,dc_value];            
        end
        Start = End+category+1;
        End = Start;
    else
        End=End+1;
    end
end
end

%AC解码函数
function ac = AC_decode(ac_series,ACTAB)
EOB=[1,0,1,0];
ZRL=[1,1,1,1,1,1,1,1,0,0,1];
ac=[]; 
ac_cur=zeros(1,63); 
ac_pointer=1; 
Start=1; 
End=1;
while End<=length(ac_series)   
    Len = End-Start+1; 
    test = zeros(1,16);
    test(1:Len)=ac_series(Start:End); 
    match_rindex = find(all(ACTAB(:,4:end)==test,2));
    %EOB
    if all(test(1:4)==EOB,'all') && Len == 4 
        ac = [ac;ac_cur];  
        ac_cur=zeros(1,63);  
        ac_pointer=1;
        End = End+1;  
        Start = End;
    %ZRL
    elseif all(test(1:11)==ZRL,'all') && Len == 11
        ac_pointer=ac_pointer+16;   
        End = End+1; 
        Start = End;
    elseif ~isempty(match_rindex) && ACTAB(match_rindex,3)==Len    
        row = match_rindex(1);
        run = ACTAB(row,1); 
        category = ACTAB(row,2); 
        ac_pointer = ac_pointer+run;
        tmp=ac_series(End+1:End+category);
        %判断正负
        if tmp(1)==0 
             tmp(:)=~tmp(:);
             ac_value =-bin2dec(num2str(tmp));
        else
             ac_value = bin2dec(num2str(tmp)); 
        end
        ac_cur(ac_pointer) = ac_value;
        ac_pointer = ac_pointer+1;        
        End = End+category+1;
        Start = End;
    else
        End=End+1;
    end
end
ac=ac';
end

