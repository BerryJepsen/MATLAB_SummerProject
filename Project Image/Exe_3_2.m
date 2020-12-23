load JpegCoeff.mat   % 码表
load hall.mat        % 原图
load snow.mat        % 原图
msg='don''t go gentle into that good night';    %隐藏信息
dct_hide= 3;    %隐藏方式

%生成二进制信息序列
msg_bin=msg2bin(msg);


%补充为8*8的整数倍, 灰度减去128
pic=hall_gray;
[h,w]=size(pic);
save('jpegcodes.mat','h','w');
H=ceil(h/8);
W=ceil(w/8);
proc=zeros(H*8,W*8);
proc(1:h,1:w)=pic;
if (H>h)
    proc(h:H,:)=pic(h);
end
if(W>w)
    proc(:,w:W)=pic(w);
end
proc=proc-128;

%分为8*8的块进行dct
fun = @(block_struct) dct2(block_struct.data);
proc_dct=blockproc(proc,[8,8],fun);

%量化
fun= @(block_struct) round(block_struct.data./QTAB);
proc_q=blockproc(proc_dct,[8,8],fun);

%zigzag扫描
h=ones(H,1)*8;
w=ones(W,1)*8;
C=mat2cell(proc_q,h,w);
proc_z=zeros(64,H*W);
count=1;
for i=1:H
    for j=1:W
        proc_z(:,count)=Zigzag(cell2mat(C(i,j)));
        count=count+1;
    end
end

%变换域隐藏信息
switch dct_hide
    %隐藏方法1
    case 1
        rep= ceil(numel(proc)/(length(msg)*8));
        msg_rep = repmat(msg_bin,1,rep);
        msg_rep = msg_rep(1:numel(proc));
        proc_z = bitset(proc_z,1,reshape(msg_rep,size(proc_z)),'int64');
    %隐藏方法2
    case 2
        hide_th = 39;
        QTAB_zigzag = Zigzag(QTAB);
        hide_indice = find(QTAB_zigzag<=hide_th);
        target_proc = proc_z(hide_indice,:);
        rep= ceil(numel(target_proc)/(length(msg)*8));
        msg_rep = repmat(msg_bin,1,rep);
        msg_rep = msg_rep(1:numel(target_proc));
        target_proc = bitset(target_proc,1,reshape(msg_rep,size(target_proc)),'int64');
        proc_z(hide_indice,:) = target_proc; 
    %隐藏方法3
    case 3
        msg_bin=2*msg_bin-1;
        rep = ceil(size(proc_z,2)/(length(msg)*8));
        msg_rep = repmat(msg_bin,1,rep);
        msg_rep = msg_rep(1:size(proc_z,2));
        for i=1:size(proc_z,2) 
           nonzero_idx = find(proc_z(:,i));
           if nonzero_idx(end) == 64
               target = nonzero_idx(end);
           else
               target = nonzero_idx(end)+1;
           end
           proc_z(target,i)=msg_rep(i);
        end
end


%DC编码
DC=proc_z(1,:);
DC_d=zeros(1,H*W);
DC_d(1)=DC(1);
DC_d(2:end)=DC(1:end-1)-DC(2:end);
DC_series=[];
for i=1:H*W
    %0类
    if DC_d(i)==0
        DC_series=[DC_series, [0,0]];
        continue;
    end
    category=floor(log2(abs(DC_d(i))))+1;
    %错误
    if category>=12
        error("error coding");
    end
    
    Len = DCTAB(category+1,1);
    DC_series=[DC_series, DCTAB(category+1,2:1+Len)];
    magnitude=dec2bin(abs(DC_d(i)));
    magnitude=str2num(magnitude(:))';
     if DC_d(i)<0
          magnitude(:)=~magnitude(:);
     end
     DC_series=[DC_series,magnitude];
     continue;
end

%AC编码
AC=proc_z(2:end,:);
AC_series=[];
EOB=[1,0,1,0];
ZRL=[1,1,1,1,1,1,1,1,0,0,1];
for i=1:H*W
    ac_block=AC(:,i);
    non_zero=find(ac_block)';
    %全空
    if isempty(non_zero)
        AC_series=[AC_series,EOB];
        continue;
    end
    
    %有非零元素
    run=(non_zero-[0,non_zero(1:end-1)])-1;
    amplitude=ac_block(non_zero)';
    Size=floor(log2(abs(amplitude)))+1;
    %编码
    for j=1:length(non_zero)
        %run>15
        while(run(j)>15)
            run(j)=run(j)-16;
            AC_series=[AC_series,ZRL];
        end
        huffman=ACTAB(run(j)*10+Size(j),4:3+ACTAB(run(j)*10+Size(j),3));
        binary=dec2bin(abs(amplitude(j)));
        binary=str2num(binary(:))';
        if amplitude(j)<0
            binary(:)=~binary(:);
        end
        AC_series=[AC_series,huffman,binary];
    end
    AC_series=[AC_series,EOB];
end
save('jpegcodes.mat','DC_series','AC_series','dct_hide','-append');
Exe_3_2_1;

function msg_bin=msg2bin(msg)
msg_dec=uint8(msg);
msg_bin=dec2bin(msg_dec,8);
msg_bin=reshape(msg_bin',1,[]);
msg_bin=str2num(msg_bin(:))';
end

function msg_char=bin2msg(bin)
len=floor(length(bin)/8);
bin = bin(1:len*8);
bin = reshape(bin,8,len)';
msg_dec=bin2dec(num2str(bin));
msg_char=char(msg_dec)';
end




