[x, Fs] = audioread('D:\Adacity Workspace\bai1\test16k.wav');
t=(0:length(x)-1)/Fs;
plot(t,x, '-');
len = length(x);
len
lenInSecond = len/Fs;
lenInSecond
sound(x, Fs); % nghe rõ, phát lại giống với file ban đầu
pause(5);
sound(x, Fs/2); % âm phát ra rất chậm, nghe không rõ
pause(5);
sound(x, Fs*2); % nhanh, không nghe rõ

