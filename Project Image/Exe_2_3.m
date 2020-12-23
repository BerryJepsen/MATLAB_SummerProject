%绘制原图
subplot(3,1,1);
imshow(hall_gray);
title("原图");

%右侧置零
hall_gray_dct=dct2(hall_gray);
hall_gray_dct(:,end-3:end)=0;
hall_gray_1=idct2(hall_gray_dct)/255;
subplot(3,1,2);
imshow(hall_gray_1);
title("右侧置零");

%左侧置零
hall_gray_dct=dct2(hall_gray);
hall_gray_dct(:,1:4)=0;
hall_gray_2=idct2(hall_gray_dct)/255;
subplot(3,1,3);
imshow(hall_gray_2);
title("左侧置零");