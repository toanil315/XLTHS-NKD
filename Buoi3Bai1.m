%{
[x, Fs] = audioread('D:\Adacity Workspace\bai1\test16k.wav');
energy = 0;
for n = 1:length(x)
    energy = energy + (abs(x(n))^2);
end
Energy = energy 
Power = energy/length(x)
%}
histSTE = [25 8 15 5 6 10 10 3 1 20 7];
maximaHistSTE1 = 0;
maximaHistSTE2 = 0;
maximaIndex1 = 0;
maximaIndex2 = 0;   
for i = 2 : length(histSTE) - 1 % diem dau va diem cuoi khong the la cuc dai duoc
    prev = i - 1;
    next = i + 1;
    while(histSTE(i) == histSTE(next))
        next = next + 1;
    end
    if(histSTE(i) > histSTE(prev) && histSTE(i) > histSTE(next))
        if(maximaIndex1 == 0) 
            maximaHistSTE1 = histSTE(i);
            maximaIndex1 = i;
        else
            maximaHistSTE2 = histSTE(i);
            maximaIndex2 = i;
            break;
        end
    end
    i = next;
end
maximaHistSTE1
maximaHistSTE2

