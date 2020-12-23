function [dct2D]=Exe_2_2(dct1D)
dct2D=zeros(size(dct1D,1),size(dct1D,2));

for row=1:size(dct1D,1)
    dct2D(row,:)=DCT(dct1D(row,:));
end
for col=1:size(dct1D,2)
    dct2D(:,col)=DCT(dct2D(:,col)')';
end

end