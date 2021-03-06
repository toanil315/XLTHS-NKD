% BACKUP
clear;
silenceFTN = [0.00, 0.59; 0.97, 1.76; 2.11, 3.44; 3.77, 4.70; 5.13, 5.96; 6.28, 6.78];
main('D:\Adacity Workspace\tinhieukiemthu\30FTN.wav', silenceFTN);
clear;
silenceFQT = [0.00, 0.46; 0.99, 1.56; 2.13, 2.51; 2.93, 3.79; 4.38, 4.77; 5.22, 5.79];
main('D:\Adacity Workspace\tinhieukiemthu\42FQT.wav', silenceFQT);
clear;
silenceMTT = [0.00, 0.93; 1.42, 2.59; 3.00, 4.71; 5.11, 6.26; 6.66, 8.04; 8.39, 9.27];
main('D:\Adacity Workspace\tinhieukiemthu\44MTT.wav', silenceMTT);
clear;
silenceMDV = [0.00, 0.88; 1.34, 2.35; 2.82, 3.76; 4.13, 5.04; 5.50, 6.41; 6.79, 7.42];
main('D:\Adacity Workspace\tinhieukiemthu\45MDV.wav', silenceMDV);
clear;

%Cac ham chinh dung de phan biet khoang lang va tieng noi + tim tan so co
%ban tren mien tan so
%==================================================================================================
function main(filePath, silenceStandard) 
    [baseSTE, threshHold, silenceIndexArray, frameLength] = speechDiscrimiation(filePath, silenceStandard);
    [fftF0, yFftF0] = findF0(silenceIndexArray, filePath);
    FMean = mean(yFftF0);
    FStd = std(yFftF0);
    [x, Fs] = audioread(filePath);
    draw(x, Fs, filePath, baseSTE, threshHold, silenceIndexArray, frameLength, silenceStandard, fftF0, FMean, FStd, yFftF0);
end

function [baseSTE, threshHold, silenceIndexArray, frameLength] = speechDiscrimiation(filePath, silenceStandard)
    
    [x, Fs] = audioread(filePath);

    % Setup cac gia tri co ban
    samples = length(x);
    frameDuration = 0.02;
    frameLength = round(Fs * frameDuration); % so mau trong 1 frame
    frameTotalWithNoShift = floor(samples / frameLength); % tong so frame duoc chia ra
    frameTotal = 2*frameTotalWithNoShift - 1;
    Weight = 8;

    % tinh STE cua moi frame
    STEMatrix = calcSTE(x, frameTotal, frameLength);

    %% chuan hoa STE ve voi bien do [0, 1]
    minEnergy = min(STEMatrix);
    maxEnergy = max(STEMatrix);
    for i = 1 : length(STEMatrix)
        STEMatrix(i) = (STEMatrix(i) - minEnergy) / (maxEnergy - minEnergy); 
    end
    
    baseSTE = 0;
    for i = 1: length(STEMatrix)
        startIndex = round(frameLength * (i - 1) / 2) + 1;
        endIndex =  startIndex + frameLength - 1 ;
        baseSTE(startIndex : endIndex) = STEMatrix(i);
    end

    %% tim Threshold
    % Cach 1: dung thuat toan
    % B1 lap bieu do tan suat
    [histSTE, x_STE] = hist(STEMatrix, round(length(STEMatrix) / 0.42));
    % B2: tim cuc dai thu nhat va thu 2 cua histSTE: 
    [maximaIndex1, maximaIndex2] = findIndexMaxima(histSTE);
    maximaHistSTE1 = x_STE(maximaIndex1);
    maximaHistSTE2 = x_STE(maximaIndex2);
    % B3: ap dung cong thuc T = (W * M1 + M2) / (W + 1)
    threshHold = ((Weight * maximaHistSTE1) + maximaHistSTE2) / (Weight + 1);
    % Cach 2: Thong ke theo du lieu chuan
    %threshHold = 0.00325;
    % thong ke theo du lieu chuan ta se dat duoc cac nguong cua tung file wav nhu sau
    %studio_M1: 0.004                  0.004 + 0.0045 + 0.0025 + 0.002
    %studio_F1: 0.0045 -> threshold = --------------------------------- = 0.00325
    %phone_M1: 0.0025                                 4
    %phone_F1: 0.002
  
    %xac dinh nhung frame nao co muc nang luong thoa man dieu kien > threshold
    checkSpeechArray = zeros(1, frameTotal);
    for i = 1 : frameTotal
        if(STEMatrix(i) > threshHold) 
            checkSpeechArray(i) = 1;
        else
            checkSpeechArray(i) = 0;
        end
    end
    % xac dinh cac vi tri (bat dau, ket thuc) cua khoang lang
    silenceIndexArray = findSilenceIndex(checkSpeechArray, frameTotal);
  
    % tien hanh ve 
    %draw(x, Fs, filePath, baseSTE, threshHold, silenceIndexArray, frameLength, silenceStandard);
end

function [fftF0, yFftF0] = findF0(silenceIndexArray, filePath)
    [x, Fs] = audioread(filePath);
    N = 1024; %so diem fft 
    frameLength = round(0.02 * Fs); %do dai 1 frame 20ms
    frameTotalWithNoShift = floor(length(x) / frameLength); % tong so frame duoc chia ra neu khong tinh overlap
    frameTotal = 2 * frameTotalWithNoShift - 1;%vi frame shift = 10ms = 1/2 do dai 1 frame nen cu 2 frame thi chen them 1 frame moi
%     h = zeros(frameLength , 1); %khoi tao cua so hamming
%     for i=1:frameLength
%         h(i) = 0.54 - 0.46*cos(2*pi*(i-1)/(frameLength));
%     end
    h = hamming(frameLength);%khoi tao cua so hamming
 
    %B1: Xac dinh cac khoang voice dua tren cau 1.
    voiceIndexArray = [];
    voiceIndex = 1;
    for i = 1: size(silenceIndexArray) - 1
        voiceIndexArray(voiceIndex, 1) = silenceIndexArray(i, 2) + 1;
        voiceIndexArray(voiceIndex, 2) = silenceIndexArray(i + 1, 1) - 1;
        voiceIndex = voiceIndex + 1;
    end

    %B2: tien hanh xac dinh f0 cua moi frame
    indexF0 = 1;
    indexGraph = 1;
    defaultPoint = 3;
    sumOfF0 = 0;
    indexSum = 0;
    for k = 1 : frameTotal %Vong lap cac frame
        begin = round(frameLength * (k - 1) / 2) + 1;
        endIndex =  begin + frameLength - 1;
        check = isMember(k, voiceIndexArray);
        if check == 1 % kiem tra frame thu k hien tai co phai nam trong doan tieng noi hay khong
            range = begin : endIndex; %chi so cua cac mau trong 1 frame
            frame = h.*x(range);%gia tri cua moi phan tu trong cua so hamming su dung fft
            P2 = abs(fft(frame, N)); %P2 co 1 nua la ao, 1 nua la thuc
            P1 = P2(1 : round(length(P2) / 2)); %Ta chi xet rieng 1 nua ben trai
            freq = linspace(0, Fs/2, length(P1));
            %Tim dinh cao nhat
            %[yValueHighest, yPeak1] = findpeaks(P1,freq,'NPeaks',1,'SortStr','descend','MinPeakHeight', 2.8);
            [yValueHighest, yPeak1] = findpeaks(P1,freq,'NPeaks',1,'SortStr','descend');
            %Tim cac dinh trong frame
            [zValue, zLocations] = findpeaks(P1, freq);
            F0 = configF0(zLocations, defaultPoint, yPeak1);
            if indexSum == 0 
                sumOfF0 = sumOfF0 + F0;
                indexSum = indexSum + 1;
            end
            % kiem tra xem F0 dau tien co cao hon F0Mean nhieu khong, neu
            % cao hon thi t tinh lai F0 bang cach tang so hai
           if indexSum > 0 && (F0 - (sumOfF0 / indexSum)) > 10
                temp = defaultPoint + 1;
                while (F0 - (sumOfF0 / indexSum)) > 10 && temp <= 10
                    F0 = configF0(zLocations, temp, yPeak1);
                    temp = temp + 1;
                end
                sumOfF0 = sumOfF0 + F0;
                indexSum = indexSum + 1;
           end
            if (F0 < 400 && F0 > 70)
                fftF0(indexF0) = F0;
                yFftF0(indexGraph) = F0;
                indexGraph = indexGraph + 1;
                indexF0 = indexF0 + 1;
            end
        else
            fftF0(indexF0) = 0;
            indexF0 = indexF0 + 1;
        end
    end
end

%=====================================SUB-FUNCTION===============================================
%============================================================================================
    
    % Ham dung de tinh STE cho moi frame
    function STEMatrix = calcSTE(x, frameTotal, frameLength)
        STEMatrix = zeros(1, frameTotal); % tinh nang luong cua moi frame
        for i = 1 : frameTotal
            startIndex = round(frameLength * (i - 1) / 2) + 1;
            endIndex =  startIndex + frameLength - 1 ;
            frameI = x(startIndex : endIndex);
            % tien hanh tinh STE:
            STEMatrix(i) = sum(frameI.^2);
        end
    end
        
    % Ham dung de xac dinh khoang lang ( Constraint: >= 300ms)
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

    % Ham dung de tim vi tri cua cuc dai thu 1 va thu 2
    function [maximaIndex1, maximaIndex2] = findIndexMaxima(histSTE)
        maximaIndex1 = 0;
        maximaIndex2 = 0;   
        for i = 2 : length(histSTE) - 1 % diem dau va diem cuoi khong the la cuc dai duoc
            prev = i - 1;
            next = i + 1;
            while(histSTE(i) == histSTE(next))
                next = next + 1;
            end
            % kiem tra co phai cuc dai hay khong
            if(histSTE(i) > histSTE(prev) && histSTE(i) > histSTE(next))
                if(maximaIndex1 == 0) 
                    maximaIndex1 = i;
                else
                    maximaIndex2 = i;
                    break;
                end
            end
            i = next;
        end
    end
    
    % Ham dung de ve cac figure
    function draw(x, Fs, filePath, baseSTE, threshHold, silenceIndexArray, frameLength, silenceStandard, fftF0, FMean, FStd, yFftF0)
        f = figure();
        f.Name = filePath;
        subplot(5,1,1);
        plot(x);
        title('Signal - STE - Threshold');
        xlabel('Th???i gian (s)'); % G??n nh??n ????n v??? tr???c th???i gian
        ylabel('Bi??n ?????');% G??n nh??n ????n v??? tr???c bi??n ?????
        hold on;
        % ve STE
        plot(baseSTE, 'r');
        % ve duong threshHold
        yline(threshHold, 'g');
        hold off;
        legend('Tin hieu mau', 'STE', 'Threshold');
        % Ket qua
        subplot(5,1,2);
        plot(x, 'DisplayName', 'Tin hieu mau');
        title('Speech / Silence discrimination');
        xlabel('Th???i gian (s)'); % G??n nh??n ????n v??? tr???c th???i gian
        ylabel('Bi??n ?????');% G??n nh??n ????n v??? tr???c bi??n ?????
        hold on;
        %ve bien chuan theo file thay cho
        for j = 1: length(silenceStandard)
            xline(silenceStandard(j, 1) * Fs, 'r','LineWidth',1);
            xline(silenceStandard(j, 2) * Fs, 'r','LineWidth',1);
        end
        % ve bien theo thuat toan
        
        for j = 1: size(silenceIndexArray)
            start =  silenceIndexArray(j, 1);
            endIndex = silenceIndexArray(j, 2);
            xline(((start - 1) / 2) * frameLength, 'g','LineWidth',1);
            xline((endIndex * frameLength) - (frameLength * (endIndex - 1) / 2), 'g','LineWidth',1);
        end
        % Add chu thich cho figure
        h = zeros(3, 1);
        h(1) = plot(NaN,NaN, 'b');
        h(2) = plot(NaN,NaN, 'r');
        h(3) = plot(NaN,NaN, 'g');
        legend(h, 'Tin hieu mau','Khoang lang chuan','Khoang lang thuat toan');
        hold off 
        subplot(5,1,3);
        plot(x, 'DisplayName', 'Tin hieu mau');
        subplot(5,1,4);
        plot(x, 'DisplayName', 'Tin hieu mau');
        subplot(5,1,5);
        stem (fftF0, 'LineStyle', 'none', 'MarkerFaceColor', 'b', 'MarkerSize', 2);
        title(['Fundemental frequency F0 (Hz), F0mean = ',num2str(FMean),' F0std = ',num2str(FStd)]);
        xlabel('Th???i gian (s)'); % G??n nh??n ????n v??? tr???c th???i gian
        ylabel('Bi??n ?????');% G??n nh??n ????n v??? tr???c bi??n ?????
    end

    %Ham dung de kiem tra 1 so k co nam trong mang hay khong
    function check = isMember(k, array)
        check = 0;
        for i = 1: size(array)
            if k >= array(i, 1) && k <= array(i, 2)
                check = 1;
                break;
            end
        end
    end
    
    %Ham downsample dung de thuc hien hps
    function hps = downsample(fft, number)
        skipStep = 0;
        indexHps = 1;
        for i = 1: length(fft)
            if(skipStep > 0)
                skipStep = skipStep - 1;
                continue;
            else
                hps(indexHps) = fft(i);
                indexHps = indexHps + 1;
                skipStep = number - 1;
            end
        end
    end
    
    %Ham dieu chinh F0
    function F0 = configF0(zLocations, num, yPeakMax)
        f0Array = zeros(1, num - 1);
        indexMax = 0;
        for i = 1: length(zLocations)
            %Tim dinh lien ke cua dinh cao nhat
            if zLocations(i) == yPeakMax
                indexMax = i;
                break;
            end
        end
        %tinh khoang cach giua cac hai voi nhau; khoang cach giua 2 hai
        %lien tiep = f0
        for k = 1 : num - 1
            if k == 1 && indexMax > 1
                f0Array(k) = yPeakMax - zLocations(indexMax - 1);
            end
            if k == 2 
                f0Array(k) = zLocations(indexMax + 1) - yPeakMax;
            end
            if k > 2 
                f0Array(k) = zLocations(indexMax + k - 1) - zLocations(indexMax + k - 2);
            end
        end
        check = 1;
        %Kiem tra dieu kien
        for i = 1: num - 1
            if f0Array(k) < 70 || f0Array(k) > 400
                check = 0;
                break;
            end
        end
        %F0 = sum(f0Array) / length(f0Array); %F0 c???a frame = tbc cua 2 khoang cachs
        if check == 1
            F0 = sum(f0Array) / length(f0Array); %F0 c???a frame = tbc cua 2 khoang cachs
            
        else
            F0 = 0;
        end
    end
    
    
    