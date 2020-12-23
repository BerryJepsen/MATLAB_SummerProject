%绘制原图
subplot(2,2,1);
imshow(hall_gray);
title("原图");

%转置
hall_gray_dct=dct2(hall_gray)';
hall_gray_1=idct2(hall_gray_dct)/255;
subplot(2,2,2);
imshow(hall_gray_1);
title("转置");

%旋转90度
hall_gray_dct=dct2(hall_gray);
hall_gray_dct=rot90(hall_gray_dct);
hall_gray_2=idct2(hall_gray_dct)/255;
subplot(2,2,3);
imshow(hall_gray_2);
title("旋转90度");

%旋转180度
hall_gray_dct=dct2(hall_gray);
hall_gray_dct=rot90(hall_gray_dct);
hall_gray_dct=rot90(hall_gray_dct);
hall_gray_3=idct2(hall_gray_dct)/255;
subplot(2,2,4);
imshow(hall_gray_3);
title("旋转180度");
