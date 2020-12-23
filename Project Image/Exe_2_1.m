%绘制原图
subplot(3,1,1);
imshow(hall_gray);
title("原图");

%直接让灰度减去128
hall_gray_1=hall_gray-128;
subplot(3,1,2);
imshow(hall_gray_1);
title("直接操作");

%变换域处理
hall_gray_dct=dct2(hall_gray);
pre_dct=zeros(size(hall_gray));
pre_dct(:,:)=128;
pre_dct=dct2(pre_dct);
hall_gray_dct=hall_gray_dct-pre_dct;
hall_gray_2=idct2(hall_gray_dct)/255;
subplot(3,1,3);
imshow(hall_gray_2);
title("变换域操作");