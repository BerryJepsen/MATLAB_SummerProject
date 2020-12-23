%补充为8*8的整数倍, 灰度减去128
[h,w]=size(hall_gray);
H=ceil(h/8);
W=ceil(w/8);
proc=zeros(H*8,W*8);
proc(1:h,1:w)=hall_gray;
if (H>h)
    proc(h:H,:)=hall_gray(h);
end
if(W>w)
    proc(:,w:W)=hall_gray(w);
end
proc=proc-128;

%分为8*8的块进行dct
fun = @(block_struct) dct2(block_struct.data);
proc_dct=blockproc(proc,[8,8],fun);

%量化
fun= @(block_struct) round(block_struct.data./QTAB);
proc_q=blockproc(proc_dct,[8,8],fun);

%zigzag扫描
% fun= @(block_struct) Zigzag(block_struct.data);
% proc_z=blockproc(proc_q,[8,8],fun);
%proc_z=reshape(proc_z,[64,numel(proc_z)/64]);

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


