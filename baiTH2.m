clear;
numOfCoef = 26;
filePaths = [
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\01MDA\a.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\01MDA\e.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\01MDA\i.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\01MDA\o.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\01MDA\u.wav',
    
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\02FVA\a.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\02FVA\e.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\02FVA\i.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\02FVA\o.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\02FVA\u.wav',
    
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\03MAB\a.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\03MAB\e.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\03MAB\i.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\03MAB\o.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\03MAB\u.wav',
    
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\04MHB\a.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\04MHB\e.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\04MHB\i.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\04MHB\o.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\04MHB\u.wav',
    
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\05MVB\a.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\05MVB\e.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\05MVB\i.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\05MVB\o.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\05MVB\u.wav',
    
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\06FTB\a.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\06FTB\e.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\06FTB\i.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\06FTB\o.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\06FTB\u.wav',
    
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\07FTC\a.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\07FTC\e.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\07FTC\i.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\07FTC\o.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\07FTC\u.wav',
    
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\08MLD\a.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\08MLD\e.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\08MLD\i.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\08MLD\o.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\08MLD\u.wav',
    
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\09MPD\a.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\09MPD\e.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\09MPD\i.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\09MPD\o.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\09MPD\u.wav',
    
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\10MSD\a.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\10MSD\e.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\10MSD\i.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\10MSD\o.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\10MSD\u.wav',
    
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\11MVD\a.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\11MVD\e.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\11MVD\i.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\11MVD\o.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\11MVD\u.wav',
    
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\12FTD\a.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\12FTD\e.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\12FTD\i.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\12FTD\o.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\12FTD\u.wav',
    
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\14FHH\a.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\14FHH\e.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\14FHH\i.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\14FHH\o.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\14FHH\u.wav',
    
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\15MMH\a.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\15MMH\e.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\15MMH\i.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\15MMH\o.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\15MMH\u.wav',
    
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\16FTH\a.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\16FTH\e.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\16FTH\i.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\16FTH\o.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\16FTH\u.wav',
    
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\17MTH\a.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\17MTH\e.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\17MTH\i.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\17MTH\o.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\17MTH\u.wav',
    
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\18MNK\a.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\18MNK\e.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\18MNK\i.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\18MNK\o.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\18MNK\u.wav',
    
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\19MXK\a.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\19MXK\e.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\19MXK\i.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\19MXK\o.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\19MXK\u.wav',
    
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\20MVK\a.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\20MVK\e.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\20MVK\i.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\20MVK\o.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\20MVK\u.wav',
    
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\21MTL\a.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\21MTL\e.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\21MTL\i.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\21MTL\o.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\21MTL\u.wav',
    
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\22MHL\a.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\22MHL\e.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\22MHL\i.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\22MHL\o.wav',
    'D:\Adacity Workspace\NguyenAmHuanLuyen-16k\22MHL\u.wav',
];

melCep = zeros(1, numOfCoef);
vectorMelCepAverage = zeros(5, numOfCoef);

num = 1;
for i = 1 : size(filePaths)
    if(num > 5)
        num = num - 5;
    end
    filePath = filePaths(i, 1:54);
    vectorAverage = calcMelCepStandard(filePath, num, numOfCoef);
    for j = 1 : numOfCoef
        vectorMelCepAverage(num, j) = vectorMelCepAverage(num, j) + (vectorAverage(j)/21);
    end
    num = num + 1;
end

fileNames = ['a', 'e', 'i', 'o', 'u'];

f = figure;
for k = 1 : 5
    subplot(5,1,k);
    plot(vectorMelCepAverage(k, 1 : numOfCoef));
    title(fileNames(k));
end

detectVowelPaths = [
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\23MTL\a.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\23MTL\e.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\23MTL\i.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\23MTL\o.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\23MTL\u.wav',
    
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\24FTL\a.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\24FTL\e.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\24FTL\i.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\24FTL\o.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\24FTL\u.wav',
    
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\25MLM\a.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\25MLM\e.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\25MLM\i.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\25MLM\o.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\25MLM\u.wav',
    
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\27MCM\a.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\27MCM\e.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\27MCM\i.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\27MCM\o.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\27MCM\u.wav',
    
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\28MVN\a.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\28MVN\e.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\28MVN\i.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\28MVN\o.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\28MVN\u.wav',
    
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\29MHN\a.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\29MHN\e.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\29MHN\i.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\29MHN\o.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\29MHN\u.wav',
    
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\23MTL\a.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\23MTL\e.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\23MTL\i.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\23MTL\o.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\23MTL\u.wav',
    
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\30FTN\a.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\30FTN\e.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\30FTN\i.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\30FTN\o.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\30FTN\u.wav',
    
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\32MTP\a.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\32MTP\e.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\32MTP\i.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\32MTP\o.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\32MTP\u.wav',
    
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\34MQP\a.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\34MQP\e.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\34MQP\i.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\34MQP\o.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\34MQP\u.wav',
    
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\35MMQ\a.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\35MMQ\e.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\35MMQ\i.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\35MMQ\o.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\35MMQ\u.wav',
    
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\36MAQ\a.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\36MAQ\e.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\36MAQ\i.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\36MAQ\o.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\36MAQ\u.wav',
    
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\37MDS\a.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\37MDS\e.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\37MDS\i.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\37MDS\o.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\37MDS\u.wav',
    
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\38MDS\a.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\38MDS\e.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\38MDS\i.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\38MDS\o.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\38MDS\u.wav',
    
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\39MTS\a.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\39MTS\e.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\39MTS\i.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\39MTS\o.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\39MTS\u.wav',
    
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\40MHS\a.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\40MHS\e.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\40MHS\i.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\40MHS\o.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\40MHS\u.wav',
    
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\41MVS\a.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\41MVS\e.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\41MVS\i.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\41MVS\o.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\41MVS\u.wav',
    
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\42FQT\a.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\42FQT\e.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\42FQT\i.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\42FQT\o.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\42FQT\u.wav',
    
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\43MNT\a.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\43MNT\e.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\43MNT\i.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\43MNT\o.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\43MNT\u.wav',
    
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\44MTT\a.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\44MTT\e.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\44MTT\i.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\44MTT\o.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\44MTT\u.wav',
    
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\45MDV\a.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\45MDV\e.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\45MDV\i.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\45MDV\o.wav',
    'D:\Adacity Workspace\NguyenAmKiemThu-16k\45MDV\u.wav',
];
%Tien hanh nhan dang nguyen am
numOfCorrect = 0;
confusionMatrix = zeros(5, 5);
for i = 1 : size(detectVowelPaths)
    if(num > 5)
        num = num - 5;
    end
    filePath = detectVowelPaths(i, 1:52);
    vectorAverage = calcMelCepStandard(filePath, num, numOfCoef);
    indexVowel = detectVowel(vectorAverage, vectorMelCepAverage, numOfCoef);
    result = ' Sai';
    if indexVowel == num
        numOfCorrect = numOfCorrect + 1;
        result = ' Dung';
    end
    confusionMatrix(num, indexVowel) = confusionMatrix(num, indexVowel) + 1;
    str = [filePath, ' Result of detect vowel: ', fileNames(indexVowel), result];
    disp(str);
    num = num + 1;
end
numOfCorrect
confusionMatrix

%Cac ham chinh dung de phan biet khoang lang va tieng noi + tim tan so co
%ban tren mien tan so
%==================================================================================================
function vectorAverage = calcMelCepStandard(filePath, indexOfMelCep, numOfCoef) 
    [baseSTE, threshHold, silenceIndexArray, frameLength, frameTotal] = speechDiscrimiation(filePath);
     [x, Fs] = audioread(filePath);
    %Tim ra doan cac frame on dinh
    [startIndex, endIndex] = findStable(silenceIndexArray, frameLength, frameTotal);
    %tinh mel-cepstrum
    c = v_melcepst(x(startIndex : endIndex), Fs, 'M', numOfCoef, floor(3*log(Fs)), 0.03*Fs, 0.015*Fs);
    sizeOfCepstrum = size(c);
    numberFrameInCep = sizeOfCepstrum(1);
    vectorAverage = zeros(1, length(c));
    %tinh trung binh cac vector dac trung cua 1 nguyen am cua 1 nguoi noi
    for i = 1 : numberFrameInCep
        for j = 1 : length(c)
            vectorAverage(j) = vectorAverage(j) + c(i, j);
        end
    end
    vectorAverage = vectorAverage./numberFrameInCep;
    %draw(x, Fs, filePath, baseSTE, threshHold, silenceIndexArray, frameLength, vectorAverage, startIndex, endIndex);
end

function indexVowel = detectVowel(melCep, melCepAverage, numOfCoef)
    distanceEuclid = [];
    for i = 1:5
        distanceEuclid = [distanceEuclid calcDistance(melCep, melCepAverage(i, 1: numOfCoef))];
    end
    minDistance = min(distanceEuclid);
    for k = 1:5
        if minDistance == distanceEuclid(k)
            indexVowel = k;
        end
    end
end

%Ham chinh dung de phan biet khoang lang va nguyen am
function [baseSTE, threshHold, silenceIndexArray, frameLength, frameTotal] = speechDiscrimiation(filePath)
    
    [x, Fs] = audioread(filePath);

    % Setup cac gia tri co ban
    samples = length(x);
    frameDuration = 0.02;
    frameLength = round(Fs * frameDuration); % so mau trong 1 frame
    frameTotalWithNoShift = floor(samples / frameLength); % tong so frame duoc chia ra
    frameTotal = 2*frameTotalWithNoShift - 1;
    Weight = 1;

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
    function draw(x, Fs, filePath, baseSTE, threshHold, silenceIndexArray, frameLength, vectorAverage, startStable, endStable)
        f = figure();
        f.Name = filePath;
        % Ket qua
        subplot(2,2,[1 2]);
        plot(x, 'DisplayName', 'Tin hieu mau');
        title('Speech / Silence discrimination');
        xlabel('Thời gian (s)'); % Gán nhãn đơn vị trục thời gian
        ylabel('Biên độ');% Gán nhãn đơn vị trục biên độ
        hold on;
        % ve bien theo thuat toan
        for j = 1: size(silenceIndexArray)
            start =  silenceIndexArray(j, 1);
            endIndex = silenceIndexArray(j, 2);
            xline(((start - 1) / 2) * frameLength, 'g','LineWidth',1);
            xline((endIndex * frameLength) - (frameLength * (endIndex - 1) / 2), 'g','LineWidth',1);
        end
        xline(startStable, 'r','LineWidth',1);
        xline(endStable, 'r','LineWidth',1);
        % Add chu thich cho figure
        h = zeros(3, 1);
        h(1) = plot(NaN,NaN, 'b');
        h(2) = plot(NaN,NaN, 'r');
        h(3) = plot(NaN,NaN, 'g');
        legend(h, 'Tin hieu mau','Doan tin hieu on dinh','Khoang lang thuat toan');
        hold off 
        subplot(2,2,[3 4]);
        plot(vectorAverage);
        hold on 
        title(filePath);
        hold off 
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
    
    %Ham dung de tim ra doan cac frame on dinh
    function [startIndexStable, endIndexStable] = findStable(silenceIndexArray, frameLength, frameTotal)
        voiceIndexArray = [];
        voiceIndex = 1;
        %Tim ra doan tieng noi 
        sizeSilence = size(silenceIndexArray);
        if sizeSilence(1) == 0 % co 0 doan khoang lang
            voiceIndexArray = [1 frameTotal];
        end
        if sizeSilence(1) == 1 % co 1 doan khoang lang
            if(silenceIndexArray(1) > 1) %khoang lang nam o phan cuoi tin hieu
                voiceIndexArray = [1 (silenceIndexArray(1) - 1)];
            else
                voiceIndexArray = [(silenceIndexArray(2) + 1) frameTotal];
            end
        end
        if sizeSilence(1) == 2 % co 2 doan khoang lang
            for i = 1: size(silenceIndexArray) - 1
                voiceIndexArray(voiceIndex, 1) = silenceIndexArray(i, 2) + 1;
                voiceIndexArray(voiceIndex, 2) = silenceIndexArray(i + 1, 1) - 1;
                voiceIndex = voiceIndex + 1;
            end
        end
        
        if sizeSilence(1) > 2 % co >2 doan khoang lang
            for i = 1: size(silenceIndexArray) - 1
                voiceIndexArray(voiceIndex, 1) = silenceIndexArray(i, 2) + 1;
                voiceIndexArray(voiceIndex, 2) = silenceIndexArray(i + 1, 1) - 1;
                voiceIndex = voiceIndex + 1;
            end
            %Tim ra doan tieng noi co do dai lon nhat
            max = 0;
            indexMax = 1;
            for j = 1 : size(voiceIndexArray)
                distance = voiceIndexArray(j, 2) - voiceIndexArray(j, 1);
                if(distance > max)
                    max = distance;
                    indexMax = j;
                end
            end
            temp = [voiceIndexArray(indexMax, 1) voiceIndexArray(indexMax, 2)];
            voiceIndexArray = temp;
        end             
        startIndex = ((voiceIndexArray(1) - 1) / 2) * frameLength;
        endIndex = (voiceIndexArray(2) * frameLength) - (frameLength * (voiceIndexArray(2) - 1) / 2);
        lengthVoice = endIndex - startIndex + 1;
        startIndexStable = startIndex + round(lengthVoice * 1 / 3);
        endIndexStable = startIndex + round(lengthVoice * 2 / 3);
    end
    
    %Ham tinh khoang cach Euclid
    function distance = calcDistance(a, b)
        sum = 0;
        for i = 1: length(a)
            sum = sum + (b(i) - a(i))^2;
        end
        distance = sqrt(sum);
    end
    
    