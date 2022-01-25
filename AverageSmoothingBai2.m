% y = 1/3*{x[n] + x[n-1] + x[n-2]}

% sinh tin hieu bi lan voi nhieu cong (additive noise)
clear all;
clf;                            % clear figures
L = 51;                         % do dai tin hieu
n = 0:L-1;                      % bien thoi gian roi rac
d = 0.5*randn(1,L);             % sinh tin hieu Gausian noise d[n] (0.5 la bien do nhieu)
s = 2*n.*(0.9.^n);              % sinh tin hieu goc s[n] = 2n(0.9)^n
x = s + d;                      % tin hieu co nhieu x[n]=s[n]+d[n]

% cach 1: cai dat he thong bang cach dich thoi gian va tinh
% TBC cua 3 tin hieu
x1 = [x];                           % x1[n] = x[n]
x2 = [0, x(1:L-1)];                 % x2[n] = x[n - 1]
x3 = [0, 0, x(1:L-2)];              % x3[n] = x[n - 2]

y1 = 1/3*(x1+x2+x3);     % lenh cai dat he thong

% ve do thi y1[n]
figure(1)
plot(n,y1(1:L),'r-',n,s(1:L),'b-');
xlabel('Chi so thoi gian n');
ylabel('Bien do');
legend('y1[n]','s[n]');

% cach 2: cai dat he thong bang cach dung ham tinh tong chap conv()
num = [1/3, 1/3, 1/3];
den = [1];
h = impz(num, den);  
y2 = conv(x, h);       
% ve do thi y2[n] vs. s[n]
figure(2)
plot(n,y2(1:L),'r-',n,s(1:L),'b-');
xlabel('Chi so thoi gian n');
ylabel('Bien do');
legend('y2[n]','s[n]');

% cach 3: dung vong lap (hieu n la mot chi so mau nao do)
% PUT YOUR CODE HERE
y3 = [];
for i = 1:L
    t1 = x(i); t2 = 0; t3 = 0;
    if(i > 1)
        t2 = x(i - 1);
    end
    if(i > 3)
        t3 = x(i - 2);
    end
    y3(i) = 1/3*(t1 + t2 + t3);
end
figure(3)
plot(n,y3(1:L),'r-',n,s(1:L),'b-');
xlabel('Chi so thoi gian n');
ylabel('Bien do');
legend('y3[n]','s[n]');

% cach 4: dung filter (hieu n la mot chi so mau nao do)
% PUT YOUR CODE HERE
y4 = filter(num, den, x);
figure(4)
plot(n,y4(1:L),'r-',n,s(1:L),'b-');
xlabel('Chi so thoi gian n');
ylabel('Bien do');
legend('y4[n]','s[n]');



