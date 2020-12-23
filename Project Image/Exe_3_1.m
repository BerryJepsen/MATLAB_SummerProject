load hall.mat 
msg='don''t go gentle into that good night';
%生成二进制信息序列
msg_bin=msg2bin(msg);

%加载图片
pic=hall_gray;

%重复信息序列
rep= ceil(numel(pic)/(length(msg)*8));
msg_rep = repmat(msg_bin,1,rep);
msg_rep = msg_rep(1:numel(pic));
%修改图片bit
pic = bitset(pic,1,reshape(msg_rep,size(pic)));
imshow(pic);
title("空域隐藏信息");

%JPEG编码解码
Exe_2_9;
Exe_2_11;

%读取加密信息
msg_bit = bitget(pic,1);
msg_bit = msg_bit(:);
msg_res = bin2msg(num2str(msg_bit));
disp(['空域隐藏信息: ',msg_res]);


function msg_bin=msg2bin(msg)
msg_dec=uint8(msg);
msg_bin=dec2bin(msg_dec,8);
msg_bin=reshape(msg_bin',1,[]);
msg_bin=str2num(msg_bin(:))';
msg_bin=uint8(msg_bin);
end

function msg_char=bin2msg(bin)
len=floor(length(bin)/8);
bin = bin(1:len*8);
bin = reshape(bin,8,len)';
msg_dec=bin2dec(num2str(bin));
msg_char=char(msg_dec)';
end