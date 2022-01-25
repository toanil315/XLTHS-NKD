clear;
genderArray = strings(10, 3);
filePaths = [
    'D:\Adacity Workspace\tinhieukiemthu\04MHB.wav',
    'D:\Adacity Workspace\tinhieukiemthu\05MVB.wav',
    'D:\Adacity Workspace\tinhieukiemthu\07FTC.wav',
    'D:\Adacity Workspace\tinhieukiemthu\08MLD.wav',
    'D:\Adacity Workspace\tinhieukiemthu\09MPD.wav',
    'D:\Adacity Workspace\tinhieukiemthu\10MSD.wav',
    'D:\Adacity Workspace\tinhieukiemthu\12FTD.wav',
    'D:\Adacity Workspace\tinhieukiemthu\14FHH.wav',
    'D:\Adacity Workspace\tinhieukiemthu\16FTH.wav',
    'D:\Adacity Workspace\tinhieukiemthu\24FTL.wav',
];
for i = 1 : size(filePaths)
    filePath = filePaths(i, 1:45);
    [fileName, FMean, gender] = mainFunc(filePath);
    genderArray(i, 1) = fileName;
    genderArray(i, 2) = FMean;
    genderArray(i, 3) = gender;
end
genderArray;
name = {'File Name', 'F0 Mean', 'Gender'};
f = uifigure;
f.Name = 'Gender Detection'; 
uitable(f,'data', genderArray, 'columnname', name);
lbl = uilabel(f);
lbl.Text = '<b style="font-size: 18px;">Gender Detection Result(10/10)</b>';
lbl.Position = [150 350 400 60];
lbl.Interpreter = 'html';

%==================================================================================================
%Cac ham chinh dung de phan biet khoang lang va tieng noi + tim tan so co
%ban tren mien tan so
%==================================================================================================
function [fileName, FMean, gender] = mainFunc(filePath) 
    [baseSTE, threshHold, silenceIndexArray, frameLength] = speechDiscrimiation(filePath);
    [fftF0, yFftF0, PVoice, freqVoice, PSilent, freqSilent] = findF0(silenceIndexArray, filePath);
    yFftF0 = medfilt1(yFftF0, 5);
    FMean = mean(yFftF0);
    FStd = std(yFftF0);
    [x, Fs] = audioread(filePath);
    gender = 'Undefined';
    if 70 <= FMean && FMean <= 150
            gender = 'Male';
    else 
        if 150 < FMean && FMean <= 400
            gender = 'Female';
        end
    end
    fileNames = strsplit(filePath,'\');
    fileName = fileNames(4);
    FMean = num2str(FMean);
end

%Ham chinh dung de phan biet khoang lang va nguyen am
function [baseSTE, threshHold, silenceIndexArray, frameLength] = speechDiscrimiation(filePath)
    
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
function [fftF0, yFftF0, P1, freq, P0, freqP0] = findF0(silenceIndexArray, filePath)
    warning('off');
    [x, Fs] = audioread(filePath);
    N= 32768; %so diem fft 
    frameLength = round(0.02 * Fs); %do dai 1 frame 20ms
    frameTotalWithNoShift = floor(length(x) / frameLength); % tong so frame duoc chia ra neu khong tinh overlap
    frameTotal = 2 * frameTotalWithNoShift - 1;%vi frame shift = 10ms = 1/2 do dai 1 frame nen cu 2 frame thi chen them 1 frame moi
    h = zeros(1, frameLength);
    for i=1:frameLength
        h(i) = 0.54 - 0.46*cos(2*pi*(i-1)/(frameLength));
    end
 
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
    yFftF0 = [];
    isTake = 1;
    for k = 1 : frameTotal %Vong lap cac frame
        begin = round(frameLength * (k - 1) / 2) + 1;
        endIndex =  begin + frameLength - 1;
        check = isMember(k, voiceIndexArray);
        if check == 1 % kiem tra frame thu k hien tai co phai nam trong doan tieng noi hay khong
            range = begin : endIndex; %chi so cua cac mau trong 1 frame
            frame = x(range);
            for indexFrame = 1:frameLength
                frame(indexFrame) = h(indexFrame) * frame(indexFrame);
            end
            P2 = abs(fft(frame, N)); %P2 co 1 nua la ao, 1 nua la thuc
            P1 = P2(1 : round(length(P2) / 2)); %Ta chi xet rieng 1 nua ben trai
            freq = linspace(0, Fs/2, length(P1));
            
            %Tim dinh 
            [yValue, yLocations] =  findpeaks(P1, freq, 'NPeaks', 3, 'MinPeakHeight', 5, 'MinPeakDistance', 80);
            minHeight = 4.5;
            while length(yLocations) <= 2 && minHeight >= 1
                [yValue, yLocations] =  findpeaks(P1, freq, 'NPeaks', 3, 'MinPeakHeight', minHeight, 'MinPeakDistance', 80);
                minHeight = minHeight - 0.5;
            end
            if length(yLocations) == 3
             z1 = (yLocations(2) - yLocations(1));
             z2 = (yLocations(3) - yLocations(2));
             if (70 < z1 && z1 < 400)  && (70 < z2 && z2 < 400)  %Kiem tra tan so co nam trong khoang 70Hz-400Hz hay khong 
                if z1 > 1.2 * z2 
                     fftF0(indexF0) = z2; %Neu z1 gap 1.2 lan z2 thi chi lay z2 de tranh sai so qua cao
                     yFftF0 = [yFftF0 z2];
                else
                     if z2 > 1.2 * z1
                         fftF0(indexF0) = z1; %Neu z2 gap 1.2 lan z1 thi chi lay z1
                         yFftF0 = [yFftF0 z1];
                     else
                         fftF0(indexF0) = (z1 + z2) / 2;
                         yFftF0  = [yFftF0 (z1 + z2) / 2];
                     end
                end
             end
            end
            indexF0 = indexF0 + 1; 
        else % Xu ly khung khong tuan hoan
            if isTake == 1 % lay ra khung chua khoang lang (khong tuan hoan)
                range = begin : endIndex; %chi so cua cac mau trong 1 frame
                frameP0 = x(range);
                for indexFrame = 1:frameLength
                    frameP0(indexFrame) = h(indexFrame) * frameP0(indexFrame);
                end
                P20 = abs(fft(frameP0, N)); %P2 co 1 nua la ao, 1 nua la thuc
                P0 = P20(1 : round(length(P20) / 2)); %Ta chi xet rieng 1 nua ben trai
                freqP0 = linspace(0, Fs/2, length(P0));
                isTake = 0;
            end
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
    function draw(x, Fs, filePath, baseSTE, threshHold, silenceIndexArray, frameLength, fftF0, FMean, FStd, yFftF0, PVoice, freqVoice, PSilent, freqSilent)
        f = figure();
        f.Name = filePath;
        subplot(4,2,[1 2]);
        plot(x);
        title(['Signal Speech Of ', gender]);
        xlabel('Thời gian (s)'); % Gán nhãn đơn vị trục thời gian
        ylabel('Biên độ');% Gán nhãn đơn vị trục biên độ
        hold on;
        % ve STE
        plot(baseSTE, 'r');
        % ve duong threshHold
        yline(threshHold, 'g');
        hold off;
        legend('Tin hieu mau', 'STE', 'Threshold');
        % Ket qua
        subplot(4,2,3)
        plot(freqVoice(1:length(freqVoice)/10), PVoice(1:length(PVoice)/10));
        findpeaks(PVoice(1:length(PVoice)/10), freqVoice(1:length(freqVoice)/10), 'NPeaks', 3, 'MinPeakDistance', 80, 'MinPeakHeight', 1);
        title('Spectrum of frame Voice');
        subplot(4,2,4)
        plot(freqSilent(1:length(freqSilent)/10), PSilent(1:length(PSilent)/10));
        title('Spectrum of frame Unvoice');
        
        fftF0 = medfilt1(fftF0, 3);
        subplot(4,2,[5 6]);
        stem (fftF0, 'LineStyle', 'none', 'MarkerFaceColor', 'b', 'MarkerSize', 2);
        title(['Fundemental frequency F0 (Hz), F0mean = ',num2str(FMean),' F0std = ',num2str(FStd)]);
        xlabel('Frame'); % Gán nhãn đơn vị trục thời gian
        ylabel('F0');% Gán nhãn đơn vị trục biên độ
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
            for i = floor(Fs/400) : floor(Fs/70) % 70Hz -> 400Hz 
                if (y(i) > y(i -1) && y(i) > y(i+1) && y(i) >= maxPeak)   
                    maxPeak = y(i);                
                    index = i;
                end
            end
            if(maxPeak > 0.45) %threshold
                F0 = Fs/index;
            else
                F0 = 0;
            end
            
    end
    
    
    