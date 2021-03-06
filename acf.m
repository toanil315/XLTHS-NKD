clear;
silenceFTN = [0.00, 0.59; 0.97, 1.76; 2.11, 3.44; 3.77, 4.70; 5.13, 5.96; 6.28, 6.78];
mainFunc('D:\Adacity Workspace\tinhieukiemthu\04MHB.wav', silenceFTN);
clear;
silenceFQT = [0.00, 0.46; 0.99, 1.56; 2.13, 2.51; 2.93, 3.79; 4.38, 4.77; 5.22, 5.79];
mainFunc('D:\Adacity Workspace\tinhieukiemthu\05MVB.wav', silenceFQT);
clear;
silenceMTT = [0.00, 0.93; 1.42, 2.59; 3.00, 4.71; 5.11, 6.26; 6.66, 8.04; 8.39, 9.27];
mainFunc('D:\Adacity Workspace\tinhieukiemthu\07FTC.wav', silenceMTT);
clear;
silenceMDV = [0.00, 0.88; 1.34, 2.35; 2.82, 3.76; 4.13, 5.04; 5.50, 6.41; 6.79, 7.42];
mainFunc('D:\Adacity Workspace\tinhieukiemthu\08MLD.wav', silenceMDV);
clear;
silenceMDV = [0.00, 0.88; 1.34, 2.35; 2.82, 3.76; 4.13, 5.04; 5.50, 6.41; 6.79, 7.42];
mainFunc('D:\Adacity Workspace\tinhieukiemthu\09MPD.wav', silenceMDV);
clear;

%Cac ham chinh dung de phan biet khoang lang va tieng noi + tim tan so co
%ban tren mien tan so
%==================================================================================================
function mainFunc(filePath, silenceStandard) 
    [baseSTE, threshHold, silenceIndexArray, frameLength] = speechDiscrimiation(filePath, silenceStandard);
    [yF0] = findF0(silenceIndexArray, filePath);
    yF0 = medfilt1(yF0, 5);
    FMean = mean(yF0);
    FStd = std(yF0);
    [x, Fs] = audioread(filePath);
    filePath
    FMean
    %draw(x, Fs, filePath, baseSTE, threshHold, silenceIndexArray, frameLength, silenceStandard, fftF0, FMean, FStd, yFftF0, PVoice, freqVoice, PSilent, freqSilent);
end

%Ham chinh dung de phan biet khoang lang va nguyen am
function [baseSTE, threshHold, silenceIndexArray, frameLength] = speechDiscrimiation(filePath, silenceStandard)
    
    [x, Fs] = audioread(filePath);

    % Setup cac gia tri co ban
    samples = length(x);
    frameDuration = 0.02;
    frameLength = round(Fs * frameDuration); % so mau trong 1 frame
    frameTotalWithNoShift = floor(samples / frameLength); % tong so frame duoc chia ra
    frameTotal = 2*frameTotalWithNoShift - 1;
    Weight = 6;

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

%Ham chinh dung de tim F0
function [yF0] = findF0(silenceIndexArray, filePath)
    warning('off');
    [x, Fs] = audioread(filePath);
    frameLength = round(0.02 * Fs); %do dai 1 frame 20ms
    frameTotalWithNoShift = floor(length(x) / frameLength); % tong so frame duoc chia ra neu khong tinh overlap
    frameTotal = 2 * frameTotalWithNoShift - 1;%vi frame shift = 10ms = 1/2 do dai 1 frame nen cu 2 frame thi chen them 1 frame moi
 
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
    yF0 = [];
    for k = 1 : frameTotal %Vong lap cac frame
        begin = round(frameLength * (k - 1) / 2) + 1;
        endIndex =  begin + frameLength - 1;
        check = isMember(k, voiceIndexArray);
        if check == 1 % kiem tra frame thu k hien tai co phai nam trong doan tieng noi hay khong
            range = begin : endIndex; %chi so cua cac mau trong 1 frame
            frame = x(range);
            F0 = calcF0ACF(frame, frameLength, Fs);
            if F0 ~= 0
                yF0 = [yF0 F0];
            end
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
    function draw(x, Fs, filePath, baseSTE, threshHold, silenceIndexArray, frameLength, silenceStandard, fftF0, FMean, FStd, yFftF0, PVoice, freqVoice, PSilent, freqSilent)
        f = figure();
        f.Name = filePath;
        subplot(4,2,[1 2]);
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
%         subplot(4,2,[3 4]);
%         plot(x, 'DisplayName', 'Tin hieu mau');
%         title('Speech / Silence discrimination');
%         xlabel('Th???i gian (s)'); % G??n nh??n ????n v??? tr???c th???i gian
%         ylabel('Bi??n ?????');% G??n nh??n ????n v??? tr???c bi??n ?????
%         hold on;
%         %ve bien chuan theo file thay cho
%         for j = 1: length(silenceStandard)
%             xline(silenceStandard(j, 1) * Fs, 'r','LineWidth',1);
%             xline(silenceStandard(j, 2) * Fs, 'r','LineWidth',1);
%         end
%         % ve bien theo thuat toan
%         for j = 1: size(silenceIndexArray)
%             start =  silenceIndexArray(j, 1);
%             endIndex = silenceIndexArray(j, 2);
%             xline(((start - 1) / 2) * frameLength, 'g','LineWidth',1);
%             xline((endIndex * frameLength) - (frameLength * (endIndex - 1) / 2), 'g','LineWidth',1);
%         end
%         % Add chu thich cho figure
%         h = zeros(3, 1);
%         h(1) = plot(NaN,NaN, 'b');
%         h(2) = plot(NaN,NaN, 'r');
%         h(3) = plot(NaN,NaN, 'g');
%         legend(h, 'Tin hieu mau','Khoang lang chuan','Khoang lang thuat toan');
%         hold off 
        subplot(4,2,3)
        plot(freqVoice(1:length(freqVoice)/10), PVoice(1:length(PVoice)/10));
        findpeaks(PVoice(1:length(PVoice)/10), freqVoice(1:length(freqVoice)/10), 'NPeaks', 3, 'MinPeakDistance', 80, 'MinPeakHeight', 1);
        title('Spectrum of frame Voice');
        subplot(4,2,4)
        plot(freqSilent(1:length(freqSilent)/10), PSilent(1:length(PSilent)/10));
        title('Spectrum of frame Unvoice');
        subplot(4,2,[5 6]);
        stem (fftF0, 'LineStyle', 'none', 'MarkerFaceColor', 'b', 'MarkerSize', 2);
        title(['Fundemental frequency F0 (Hz), F0mean = ',num2str(FMean),' F0std = ',num2str(FStd)]);
        xlabel('Frame'); % G??n nh??n ????n v??? tr???c th???i gian
        ylabel('F0');% G??n nh??n ????n v??? tr???c bi??n ?????
    end

    %Ham dung de kiem tra 1 so k co nam trong mang hay khong
    function check = isMember(k, array)
        check = 0;
        for i = 1: size(array)
            if  array(i, 1) <= k  && k <= array(i, 2)
                check = 1;
                break;
            end
        end
    end
    
    %Ham dung de tinh F0 theo phuong phap tu tuong quan
    function F0 = calcF0ACF(frame, frameLength, Fs)
        y = zeros(1, frameLength);
            
            %Autocorrelation
            for lag = 0 : frameLength
                for j = 1 : frameLength - lag
                    y(lag+1) = y(lag+1) + frame(j) * frame(j + lag);
                end
            end
            
            %Normalize
            for i = 2 : length(y)
                y(i) = y(i) / y(1);
            end
            y(1) = 1;
            
            %Find maxima
            maxPeak = 0;% globally maximal
            index = 0;
            for i = floor(Fs/400) : floor(Fs/70) % 70Hz -> 450Hz 
                if (y(i) > y(i -1) && y(i) > y(i+1) && y(i) >= maxPeak)   
                    maxPeak = y(i);                
                    index = i;
                end
            end
            if(maxPeak > 0.4)
                F0 = Fs/index;
            else
                F0 = 0;
            end
            
    end
    
    
    