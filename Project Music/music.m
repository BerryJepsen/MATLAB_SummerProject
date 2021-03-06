%clear all, close all, clc;
fs=8000;
tone=struct("pitch",{"C","#C","D","#D","E","F","#F","G","#G","A","#A","B"},"freq",{[261.63],[277.18],[293.66],[311.13],[329.63],[349.23],[369.99],[392],[415.30],[440],[466.16],[493.88]});
letter2freq = containers.Map(["C","#C","D","#D","E","F","#F","G","#G","A","#A","B","0"],...
    {[261.63],[277.18],[293.66],[311.13],[329.63],[349.23],[369.99],[392],[415.30],[440],[466.16],[493.88],[0]});
number2freq= containers.Map(["4-","#4-","5-","#5-","6-","#6-","7-","1","#1","2","#2","3","4","#4","5","#5","6","#6","7","0","1+","#1+","2+","#2+","3+","4+","#4+","5+","#5+","6+"],...
    {[174.61],[185.00],[196.00],[207.65],[220.00],[233.08],[246.94],[261.63],[277.18],[293.66],[311.13],[329.63],[349.23],[369.99],[392],[415.30],[440.00],[466.16],[493.88],[0],[523.25],[554.36],[587.33],[622.25],[659.26],[698.46],[739.99],[783.99],[830.61],[880.00]});

% Snowdreams

% notearray1=...
%     ["5","1+","2+","3+","4+","5+","3+", "2+","1+","6", "3+", "2+","0", "3+","4+","5+","3+", "2+","1+" ,"6+","6+","5+",  "0" ,];
% timearray1=...
%     [0.5, 0.5,   0.5 ,  0.5,  0.5,   0.5,   0.5,    1,      1,     1,    1,     1.75, 0.25 ,0.5,  0.5,   0.5,   0.5,    1,      1,     1,    1,     1.75, 0.25];
% 
%  notearray2=...
%      ["0","0", "0", "1", "5", "3+" ,"5", "6-", "3+", "3+", "4-", "1", "6", "1", "5-", "2", "5", "2", "1", "5", "3+" ,"5", "6-", "3", "1+" ,"3",  "4-", "1", "6", "1", "5-", "2", "7", "5+"];
% timearray2=...
%     [0.5, 0.5,  0.5 ,0.5, 0.5,  0.5,   0.5,  0.5,    1,     0.5 ,  0.5,  0.5,  0.5 ,0.5, 0.5,  0.5,  0.5 ,0.5, 0.5, 0.5,  0.5 ,  0.5,  0.5,  0.5,  0.5 ,  0.5,  0.5,  0.5,  0.5 ,0.5,  0.5,  0.5,  0.5 , 0.5];
% 
% 
% left=tone_generator(notearray1,timearray1,fs);
% right=tone_generator(notearray2,timearray2/2,fs*2);

% test=left+right;

%东方红

notearray=...
    ["5", "5", "6", "2" , "1" , "1" ,"6-", "2", "5", "5",  "6",  "1+","6", "5",  "1", "1",  "6-",  "2", "5" ,"2", "1", "7-", "6-","5-","5","2","3","2","1","1","6-"...
     "2", "3", "2", "1" , "2" , "1", "7-" ,"6-", "5-","0","5", "2","1", "7-", "6-","5-","5","2","3", "2","1", "1", "6-","2", "3","2", "1","2","1","7-","6-","5-"];
timearray=...
    [1  , 0.5,  0.5 ,  2 ,   1 ,   0.5 , 0.5 ,   2,    1,   1,    0.5,   0.5,  0.5 , 0.5,   1,   0.5,   0.5,    2,    1,    1,    1,   0.5,   0.5,  1,    1,   1,  0.5,0.5,  1,  0.5, 0.5...
     0.5 , 0.5, 0.5  0.5 , 0.5 , 0.5 , 0.5 , 0.5,    3,    1,    1,   1 ,   1,   0.5,   0.5,  1,    1,   1,  0.5,  0.5,  1 , 0.5, 0.5, 0.5, 0.5,0.5, 0.5,0.5,0.5, 0.5, 0.5,   3];
test=tone_generator(notearray,timearray,fs);

sound(test,fs);

