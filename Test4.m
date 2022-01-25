% 
clear;
% result02FVA = [0.00, 0.83; 1.37, 2.09; 2.60 ,3.57; 4.00, 4.76; 5.33, 6.18; 6.68, 7.17];
% result01MDA = [0.00 ,0.45; 0.81, 1.53; 1.85, 2.69; 2.86, 3.78; 4.15, 4.84; 5.14 ,5.58];
% result03MAB = [0.00	,1.03; 1.42, 2.46; 2.80	,4.21 ;4.52, 6.81 ;7.14,	8.22; 8.50, 9.37];
% result06FTP = [0.00	,1.52; 1.92, 3.91; 4.35,	6.18; 6.60 ,8.67 ;9.14,	10.94; 11.33,12.75];
silenceMDV = [0.00, 0.88; 1.34, 2.35; 2.82, 3.76; 4.13, 5.04; 5.50, 6.41; 6.79, 7.42];
silenceMTT = [0.00, 0.93; 1.42, 2.59; 3.00, 4.71; 5.11, 6.26; 6.66, 8.04; 8.39, 9.27];
silenceFQT = [0.00, 0.46; 0.99, 1.56; 2.13, 2.51; 2.93, 3.79; 4.38, 4.77; 5.22, 5.79];
silenceFTN = [0.00, 0.59; 0.97, 1.76; 2.11, 3.44; 3.77, 4.70; 5.13, 5.96; 6.28, 6.78];

for k = 0: 0 
%     voiceDetected('G:\Document5\XLTH\Cuoi-Ki-Thuc-Hanh\Tin-Hieu-Huan-Luyen\01MDA.wav',result01MDA);
%     voiceDetected('G:\Document5\XLTH\Cuoi-Ki-Thuc-Hanh\Tin-Hieu-Huan-Luyen\02FVA.wav',result02FVA);
%     voiceDetected('G:\Document5\XLTH\Cuoi-Ki-Thuc-Hanh\Tin-Hieu-Huan-Luyen\03MAB.wav',result03MAB);
%     voiceDetected('G:\Document5\XLTH\Cuoi-Ki-Thuc-Hanh\Tin-Hieu-Huan-Luyen\06FTB.wav',result06FTP);
voiceDetected('D:\Adacity Workspace\tinhieukiemthu\30FTN.wav',silenceFTN);
voiceDetected('D:\Adacity Workspace\tinhieukiemthu\42FQT.wav',silenceFQT);
voiceDetected('D:\Adacity Workspace\tinhieukiemthu\44MTT.wav',silenceMTT);
voiceDetected('D:\Adacity Workspace\tinhieukiemthu\45MDV.wav',silenceMDV);
end
%Ham chinh dung de phan biet khoang lang va tieng noi
function voiceDetected(fileName , standardSignal)
[audioIn, Fs] = audioread(fileName);
% 1.---Cài đặt các giá trị cơ bản---
 audioIn = audioIn./abs(max(audioIn));
samples = length(audioIn);
frame_duration = 0.02;
frame_length = round(Fs * frame_duration); % so mau trong 1 frame
frameTotalWithoutFrameShift = floor(samples / frame_length); 
frame_total = 2*frameTotalWithoutFrameShift - 1;% tong so frame duoc chia ra
Weight = 100;
%----Thực hiện gọi hàm ----

% 2.---Tính STE của mỗi frame---
STE_PowFrame_Matrix = computeSTE(audioIn, frame_total, frame_length);

% 3.---Chuẩn hóa STE về với biên độ [0, 1]---
STE_PowFrame_Matrix = Standard_function(STE_PowFrame_Matrix);

% 4.---Làm mịn giá trị đặc trưng STE
baseSTE = Compute_BaseSTE(STE_PowFrame_Matrix,frame_length);

% 5.---Threshold---
threshHold =Compute_Threshold(STE_PowFrame_Matrix, Weight);

%6.---Phân tích tiếng nói và khoảng lặng

checkSpeechArray = AnalysisVoice_Function(frame_total , STE_PowFrame_Matrix , threshHold);
% xac dinh cac vi tri (bat dau, ket thuc) cua khoang lang
% Khai báo biến thời gian . Đưa trục Ox về đơn vị thời gian
time = length(audioIn) / Fs; % Đưa về đơn vị thời gian ( s )
t = (0:0.03:time);
time_STE = (1 : length(baseSTE))/ Fs; % Đưa về đơn vị thời gian ( s )
% 7. Dựng hình vẽ đồ thị

silenceIndexArray = findSilenceIndex(checkSpeechArray, frame_total);

% 8. Tìm F0 trên miền tần số
% [F0 ,yF0]= compute_F0(voiceArray , fileName);
 [y_F0,F0,Ptemp] = fastFTs(audioIn,Fs);
% __________HPS___________%
%  f_y = pitch_detec(audioIn, 5000, 3000, 32768);
time = [1 : length(audioIn)] / Fs;
F0_mean = mean(F0);
F0_std = mean(F0) ;
figure('name',fileName);

subplot(4,1,1);     % Vẽ hai đồ thị chung một figure
% plot(time,audioIn);hold on;
plot(time_STE,baseSTE , 'r','LineWidth',1.5);
title('Short-Time-Energy (STE)');  % Gán nhãn tiêu đề đồ thị
legend('STE','location','northeast'); % Chú thích các thành phần trên đồ thị
xlabel('Thời gian (s)'); % Gán nhãn đơn vị trục thời gian
ylabel('Biên độ');% Gán nhãn đơn vị trục biên độ
 
subplot(4,1,2);     % Vẽ hai đồ thị chung một figure
p1=plot(audioIn);
title('Phân đoạn speech và silence (STE)'); % Gán nhãn tiêu đề đồ thị
hold on;
%Vẽ biên chuẩn file lab
for j = 1: length(standardSignal)
    p2=xline(standardSignal(j, 1) * Fs, 'r','LineWidth',2);
    xline(standardSignal(j, 2) * Fs, 'r','LineWidth',2);
end
% Vẽ biên theo thuật toán
for j = 1: size(silenceIndexArray)
    start =  silenceIndexArray(j, 1);
    endIndex = silenceIndexArray(j, 2);
    p3=xline(((start - 1) / 2) * frame_length, 'g','LineWidth',2);
    xline((endIndex * frame_length) - (frame_length * (endIndex - 1) / 2), 'g','LineWidth',2);
end
hold off;
legend([p1,p2,p3],{'Voice Signal' ,'By Teacher', 'By Student'});  % Chú thích các thành phần trên đồ thị
xlabel('Thời gian (s)'); % Gán nhãn đơn vị trục thời gian
ylabel('Biên độ'); % Gán nhãn đơn vị trục thời gian
subplot(4,1,3);
%yF0(k) =0;medfilt1
 stem( y_F0,'.','LineStyle', 'none', 'MarkerFace', 'b');
% plot(t,y_F0,'.');
title(['Fundemental frequency F0 (Hz), F0mean = ',num2str(mean(F0)),' F0std = ',num2str(mean(diff( F0)))]); 
% subplot(4,1,4);
% plot(Ptemp);
% stem(y_F0,'.','LineStyle', 'none', 'MarkerFace', 'b');
% plot(y_F0);
end

%---------------------------------------------------------------------------------------------------------------------------------------------------------------%
%                                                                                           Hàm xử lý phân tích tín hiệu                                                                              %                                      
%---------------------------------------------------------------------------------------------------------------------------------------------------------------%
% 1. Hàm xác định khoảng lặng
function silenceIndexArray = findSilenceIndex(checkSpeechArray, frameTotal)
silenceIndexArray = [];
indexSilence = 1;
stepForSkip = 0;
for i = 1 : frameTotal
    if(stepForSkip > 0)
        stepForSkip = stepForSkip - 1;
        continue;
    end
    % Kiem tra xem khoang lang >= 300ms hay khong
    if(checkSpeechArray(i) == 0)
        count = i;
        while(count < frameTotal && checkSpeechArray(count + 1) == 0)
            count = count + 1;
        end
        if(count - i >= 14)
            silenceIndexArray(indexSilence, 1) = i;
            silenceIndexArray(indexSilence, 2) = count;
            indexSilence = indexSilence + 1;
            stepForSkip = count - i;
        end
    end
end
end
% 2. Hàm tính STE  mỗi frame
function STE_PowFrame_Matrix = computeSTE(x, frameTotal, frameLength)
STE_PowFrame_Matrix = zeros(1, frameTotal); % tinh nang luong cua moi frame
for i = 1 : frameTotal
    startIndex = (frameLength * (i - 1) / 2) + 1;
    endIndex =  startIndex + frameLength - 1 ;
    frameI = x(startIndex : endIndex);
    % tien hanh tinh STE:
    STE_PowFrame_Matrix(i) = sum(frameI.^2);
end
end
% 3. Hàm tính ngưỡng (Threshold) sử dụng thuật toán Histogram
function [threshHold] = Compute_Threshold(STE_PowFrame_Matrix, Weight)
[histSTE, x_STE] = hist(STE_PowFrame_Matrix, round(length(STE_PowFrame_Matrix)/0.5)); % Tần suất xuất hiện ( hist STE ) giá trị STE mỗi frame
% tại các vị trí x_STE.
% vecto histSTE : lưu tần suất xuất hiện ( số lần xuất hiện ) giá trị STE.
% của mỗi frame ( STE_PowFrame_Matrix) tại vị trí x_STE ( vecto ).
maximaHistSTE1 = 0;
maximaHistSTE2 = 0;
maximaIndex1 = 0; % Vị trí cực đại cục bộ thứ 1
maximaIndex2 = 0; % Vị trí cực đại cục bộ thứ 2
%Tìm cực đại cục bộ thứ nhất và thứ hai nằm cùng 1 frame
for i = 2 : length(histSTE) - 1  % Duyệt kết quả đồ thị tần suất ( histSTE)
    previous = i - 1;
    next = i + 1;
    while(histSTE(i) == histSTE(next)) % Xét vị trí histSTE thứ i và histSTE liền kề
        next = next + 1;
    end
    if(histSTE(i) > histSTE(previous) && histSTE(i) > histSTE(next)) % Kiểm tra giá trị tại histSTE thứ i so với giá trị tại histSTE trước và sau
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
maximaHistSTE1 = x_STE(maximaIndex1); % Kết quả giá trị cực đại cục bộ thứ nhất
maximaHistSTE2 = x_STE(maximaIndex2); % Kết quả giá trị cực đại cục bộ thứ hai
% B2: Áp dụng công thức : T = (W * M1 + M2) / (W + 1)
threshHold = (Weight * maximaHistSTE1 + maximaHistSTE2) / (Weight + 1);
end
% 4. Hàm tính baseSTE 
function [baseSTE] = Compute_BaseSTE(STE_PowFrame_Matrix,frame_length)
    for i = 1: length(STE_PowFrame_Matrix)
        startIndex = (frame_length * (i - 1) / 2) + 1;
        endIndex =  startIndex + frame_length - 1 ;
        baseSTE(startIndex : endIndex) = STE_PowFrame_Matrix(i);
    end
end
% 5. Hàm xác định biên 
function [Point] = Point(Speech, frame_number, frame_duration)  % Mảng các điểm tiếng nói và khoảng lặng
    Point = [];
    j = 1;
    for i = 2:frame_number                                % Duyệt tất cả các khung
        if(Speech(i) == 1 && Speech(i-1)==0)
            Point(2*j - 1)= (i-1)*frame_duration;         % Lưu vị trí biên đầu của tiếng nói
            j = j + 1;
        end
    end
    j = 1;
    for i = 2:frame_number
        if (Speech(i) == 0 && Speech(i-1) == 1)
            Point(2*j) = (i-1)*frame_duration;             % Lưu vị trí biên cuối của tiếng nói
            j = j + 1;
        end
    end
end
% 6. Hàm chuẩn hóa STE về biên [0:1]
function [STE_PowFrame_Matrix] = Standard_function(STE_PowFrame_Matrix)
    minEnergy = min(STE_PowFrame_Matrix); % Giá trị Energy min
    maxEnergy = max(STE_PowFrame_Matrix);% Giá trị Energy max
    for i = 1 : length(STE_PowFrame_Matrix) % Duyệt từng phần tử mảng STE_PowFrame_Matrix
        STE_PowFrame_Matrix(i) = (STE_PowFrame_Matrix(i) - minEnergy) / (maxEnergy - minEnergy);
    end
end
% 7. Hàm đưa ra quyết định tiếng nói hay khoảng lặng
function [checkSpeechArray] =  AnalysisVoice_Function(frame_total , STE_PowFrame_Matrix , threshHold)
    checkSpeechArray = zeros(1, frame_total); % Mảng kiểm tra tiếng nói và khoảng lặng
    for i = 1 : frame_total % Duyệt từng frame
        if(STE_PowFrame_Matrix(i) >threshHold )  % So sánh với giá trị ngưỡng
            checkSpeechArray(i) = 1; % Giá trị STE lớn hơn giá trị ngưỡng => Lưu bằng 1
        else
            checkSpeechArray(i) = 0; % % Giá trị STE lớn hơn giá trị ngưỡng => Lưu bằng 0
        end
    end
end
% 8. Hàm tính tần số F0 trên miền tần số ( FFT )

%------------------------%
function [y_F0,F0,Ptemp] = fastFTs(x,fs)
    N= 32768;                                     %So diem FFT
    frame_length = round(0.03*fs); %Do dai khung bang 30ms
    half = round(frame_length/2);  %Nua do dai khung de xep chong khung tiep theo    
    
    %Khoi tao ham cua so hamming
    h = zeros(frame_length , 1);
    for i=1:frame_length
        h(i) = 0.54 - 0.46*cos(2*pi*(i-1)/(frame_length));
    end
    
    %Khai bao so luong khung tin hieu 
%     num_odf_windows = roun(length(x)/half -1);
    num_of_windows = floor((length(x)-1)*2/frame_length)+1;
    %Khoi tao ma tran chua tan so co ban cua tung khung
    y_F0 = zeros(1, num_of_windows);
    F0 = [];
    i = 1; %Gan chi so phan tu dau tien cua mang y_F0
    
    %Chay vong lap qua tung khung tin hieu
    for k = 1 : num_of_windows 
        range = (k-1)*half + 1 : (frame_length + (k-1)*half);  %Khoang vi tri tin hieu x trong khung thu k
        %frame = h.*x(range);                                                        %Gia tri cua tung phan tu trong cua so
        frame = zeros(1, frame_length);
        for ii = 1:frame_length
            if range(ii) <= length(x)
                frame(ii) =  h(ii)*x(range(ii));
            end
        end
        Ptemp = abs(fft(frame,N));                  %Tin hieu Ptemp
        P = Ptemp(1:length(Ptemp)/2+1);     %Lay mot nua ben trai tin hieu Ptemp
        freq = linspace(0,fs/2,length(P));        %Truc tan so cua khung tin hieu P
      
         [a,y_peak] =findpeaks(P,freq,'NPeaks', 3,'MinPeakDistance', 118,'MinPeakHeight', 9);
%           [a,y_peak] =findpeaks(P(1:length(P)/ 10), freq(1:length(freq) / 10), 'NPeaks', 3,'SortStr', 'descend', 'MinPeakDistance', 100, 'MinPeakHeight', 3);
        %Tim tat ca cac cuc dai cua pho P
        %Neu tim duoc tu 3 dinh tro len thi lay trung binh cong hieu giua 2
        %dinh ke nhau do la tan so co ban F0
        if length(y_peak)  ==3
             z1 = abs(y_peak(1) - y_peak(2));     %Tim hieu giua 2 cuc dai
             z2 = abs(y_peak(2) - y_peak(3));
             if z1<400 && z1>70 && z2 < 400 && z2 > 70  %Kiem tra tan so co nam trong khoang 75Hz-350Hz hay khong 
                if z1 > 1.5*z2 
                     y_F0(i) = z2;              %Neu z1 chenh lech hon 1.5 lan z2 thi chi lay z2
                     F0 = [F0 z2];
                 else
                     if z2 > 1.5*z1
                         y_F0(i) = z1;
                         %Neu z2 chenh lech hon 1.5 lan z1 thi chi lay z1
                          F0 = [F0 z1];
                     else
                         y_F0(i) = (z1+z2)/2;% Lay trung binh 2 tan so z1 va z2 suy ra F0
                         F0  = [F0 (z1+z2)/2];
                     end
                 end
             end
        %Neu tim duoc 2 dinh thi lay hieu cua 2 dinh do la tan so co ban F0     
        else
            if length(y_peak) == 2
                z = abs(y_peak(1) - y_peak(2));     %Tim hieu giua 2 cuc dai
                if z<400 && z>70                           %Kiem tra tan so co nam trong khoang 75Hz-350Hz hay khong 
                    y_F0(i) = z;                                    %Neu co thi dua gia tri F0 do vao y_F0
                    F0 = [F0 z];
                end
            end
        end
        i=i+1;  %Tang chi so cua mang y_F0 len 1 don vi
    end
   
    %Tim tat ca cac cuc dai trong pho bien do cua 1 khung
    function peaksArray = findAllPeaks(x, t)
        peaksArray = [];  %Khoi tao mang chua cac cuc dai cua do thi
        peakIndex = -1;  %Gan vi tri ban dau cua dinh hien tai
        peakValue = -1;  %Gan gia tri ban dau cua dinh hien tai   
        index = 1;             %Khoi tao chi so dau tien cua mang peaksArrray
        baseline = 1.2;     %Nguong cuc dai toi thieu (Loc nhung cuc dai ao)

        %Chay vong lap qua tung tin hieu trong khung
        for j=1:length(x)     
           %Neu dinh hien tai chua duoc danh dau hoac tin hieu dang xet lon hon dinh hien tai thi gan lai dinh hien tai cho diem do
            if x(j) > baseline      
                if peakValue == -1 || x(j) > peakValue          
                    %Cap nhat dinh hien tai
                    peakIndex = t(j);
                    peakValue = x(j);
                end
            %Neu tin hieu tiep theo duoi nguong va dinh hien tai da duoc danh dau thi them dinh do vao mang peaksArray    
            else
                if x(j) < baseline && peakIndex ~= -1 
                    %Dua dinh da duoc danh dau vao mang
                    peaksArray(index) = peakIndex;
                    %Khoi tao lai vi tri va gia tri dinh hien tai
                    peakIndex = -1;
                    peakValue = -1;
                    index = index + 1;  %Tang chi so cua mang peaksArray len 1 don vi
                end
            end
        end
    end  
end
%--------------------------------------------------


