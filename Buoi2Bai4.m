phase = input('nhap vao pha: ');
A = input('nhap vao bien do: ');
F0 = input('nhap vao F0: ');
start = 0; finish = 3; % thời gian bắt đầu và kết thúc.
Fs1 = 3*F0; Fs2 = 1.5*F0; %tần số lấy mẫu
T1 = 1/Fs1; T2 = 1/Fs2; % chu kì lấy mẫu
t1 = start: T1: finish; t2 = start: T2: finish;
x1 = A*cos(2*pi*F0*t1 + phase);
x2 = A*cos(2*pi*F0*t2 + phase);
%plot 2 result
subplot(2,1,1)
plot(t1(1:100), x1(1:100), '.-');

subplot(2,1,2)
plot(t2(1:100), x2(1:100), '.-');
%playback
sound(x1, Fs1);
pause(5);
sound(x2, Fs2);


