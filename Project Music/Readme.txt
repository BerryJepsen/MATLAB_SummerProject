文件说明:
1.codes文件夹		 |    源代码文件夹(详情见后)
2.Readme.txt		 |    本文件
3.snowdreams-合成.wav	 |    通过matlab合成的snowdreams音乐
4.东方红-合成    		 |    通过matlab合成的东方红音乐
5.音乐合成实验报告.pdf	 |    实验报告

codes 文件夹
***********************************************************
1.beat_analyze.m   	 |   音乐节奏分析脚本
2.Bob Acri - Sleep Away.wav 	 |   一首钢琴曲, 可以用来进行节奏分析和音调分析测试
3.fmt.wav   		 |   给出的吉它曲(freq_analyze.m和beat_analyze.m运行的条件)
4.freq_analyze.m  		 |   频率(音调)分析脚本
5.freq_synthesis.m   	 |   自己编写的将realwave处理为接近wave2proc的脚本
6.Guitar.MAT  	 	 |   加载realwave和wave2proc(freq_synthesis.m运行的条件)
7.music.m  		 |   合成音乐脚本, 直接运行是东方红, 还有snowdreams被注释了
8.tone_generator 		 |    生成音频序列的函数(music.m运行的必要条件)