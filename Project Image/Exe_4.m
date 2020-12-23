Dirpath='Faces/';
num_train = 33;
L = 5;
test_img=imread([Dirpath,'test2.bmp']);
Window=[40,60,80,100,120];
Step=[10,15,20,25,30];


%训练得到v矢量
v = zeros(2^(3*L),1);
for i=1:num_train
    sample=imread([Dirpath,num2str(i),'.bmp']);
    v = v+eigenvector(sample,L);
end
v = v/num_train;

%经验阈值
switch L
    case 3
        threshold=0.25;
    case 4
        threshold=0.40;
    case 5
        threshold=0.50;
    otherwise
        error("L not defined");
end

%人脸检测扫描
[h,w,~]=size(test_img);
candidate = [];

%图片调整
% 旋转
% test_img = imrotate(test_img,-90); 
% [h,w,~]=size(test_img);
% 缩放
test_img = imresize(test_img,[h,w*3]); 
[h,w,~]=size(test_img);
% 调色
% test_img = imadjust(test_img,[0 0 0; 1 1 0.1],[]);

for i = 1:numel(Window)
    window = Window(i);
    step = Step(i);
    for row=1:step:h-window+1
        for column=1:step:w-window+1
            u = eigenvector(test_img(row:row+window-1,column:column+window-1,:),L);
            dis = 1-sum(sqrt(u.*v),'all');
            if dis < threshold
                x = column;
                y = row;
                candidate = [candidate;[x,y,window]];
            end
        end
    end
end

%合并重复选框
while (true)
    candidate_merged = [];
    for i=1:size(candidate,1)
        test = candidate(i,:);
        if isempty(candidate_merged)
            candidate_merged=[candidate_merged;test];
        else
            addon=true;
            for j=1:size(candidate_merged,1)
                cmp=candidate_merged(j,:);
                area = min(cmp(3).^2, test(3).^2); 
                %判断是否重叠
                if (cmp(1)+cmp(3)> test(1) && test(1)+test(3)>cmp(1) && cmp(2)+cmp(3)> test(2) && test(2)+test(3)>cmp(2))
                    %计算重叠面积
                    overlap=(min(cmp(1)+cmp(3),test(1)+test(3))-max(cmp(1),test(1)))*(min(cmp(2)+cmp(3),test(2)+test(3))-max(cmp(2),test(2)));
                    %重叠比例超过1/3, 删除较小的那个
                    if(overlap*3>area)
                        addon=false;
                        if cmp(3)<test(3)
                            candidate_merged(j,:)=test;
                        end
                    end
                end
            end
            if addon
                candidate_merged=[candidate_merged;test];
            end
        end
    end
    if all(size(candidate_merged)==size(candidate))
        break;
    end
    candidate = candidate_merged;
end

%显示识别结果
imshow(test_img);
for n=1:size(candidate_merged,1)
    rectangle('Position',[candidate_merged(n,:),candidate_merged(n,3)],'EdgeColor','r');
end

%特征向量计算函数
function u = eigenvector(src_pic,L)
u = zeros(2^(L*3),1);
shifted_pic = int32(bitshift(src_pic,L-8));
shifted_color = reshape(bitshift(shifted_pic(:,:,1),L*2)+bitshift(shifted_pic(:,:,2),L)+shifted_pic(:,:,3),[],1);
for i=1:numel(shifted_color)
    %矢量的每一个位置即为一种颜色
    u(shifted_color(i)+1) = u(shifted_color(i)+1)+1;
end
u = u/numel(shifted_color);
end

