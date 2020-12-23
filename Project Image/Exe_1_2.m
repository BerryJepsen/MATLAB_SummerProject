%绘制原图
subplot(3,1,1);
imshow(hall_color);
title("原图");

%得到测试图像的长宽中较小值的一半作为半径(向下取整)
radius=size(hall_color);
radius=ceil(min(radius(1:2))*0.5);

%得到圆心坐标(向下取整)
center=size(hall_color);
center=ceil(center(1:2)*0.5);

%将范围内的矩阵值设置为红色
hall_color_circle=hall_color;
height=size(hall_color);
width=height(2);
height=height(1);
for x=1:width
    for y=1:height
        if ((x-center(2))*(x-center(2))+(y-center(1))*(y-center(1))<=radius*radius)
            hall_color_circle(y,x,:)=[255, 0 ,0];
        end
    end
end

%绘制处理过的图片
subplot(3,1,2);
imshow(hall_color_circle);
title("红色圆圈");

%国际象棋处理,格子宽度20pixel
hall_color_grid=hall_color;
for x=1:width
    for y=1:height
        if (xor(mod(ceil(x/20),2), mod(ceil(y/20),2)))
            hall_color_grid(y,x,:)=[0, 0 ,0];
        end
    end
end

%绘制处理过的图片
subplot(3,1,3);
imshow(hall_color_grid);
title("国际象棋");


