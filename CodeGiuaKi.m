clear; close all;
link = "D:\Dropbox\Season3 - DUT\Ditigal Signal Processing\BaiTapNhom\TinHieuKiemThu\";
i = 1;
unit_time = 0.03; % time in frame: 30ms
f0_min = 70; %hz
f0_max = 450;
while (i <= 4)
    if i == 1
        link_wav = strcat(link,"phone_M2.wav");
        link_lab = strcat(link,"phone_M2.lab");
        figure("Name", "phone_M2");
    elseif i == 2
        link_wav = strcat(link,"phone_F2.wav");
        link_lab = strcat(link,"phone_F2.lab");
        figure("Name", "phone_F2");
    elseif i == 3
        link_wav = strcat(link,"studio_M2.wav");
        link_lab = strcat(link,"studio_M2.lab");
        figure("Name", "studio_M2");
    else
        link_wav = strcat(link,"studio_F2.wav");
        link_lab = strcat(link,"studio_F2.lab");
        figure("Name", "studio_F2");
    end
    % doc file .lab
    fr = fileread(link_lab);
    fid = fopen(link_lab);
    num_line = 0;
    while true
        if ~ischar(fgetl(fid))
            break; 
        end
        num_line = num_line + 1;
    end
    matches = regexp(fr, '[^\n]*', 'match');
    % tac line lay du lieu f0_mean & f0_std tu .lab
    line_f0_mean = split(string(matches{num_line-1}));
    line_f0_std = split(string(matches{num_line}));
    [x, fs] = audioread(link_wav);
    plot(x);
    % ---------------
    
    frame_length = unit_time * fs; % chi so mau trong 1 khung
    frame_number = round(length(x) / frame_length); % so khung cua tin hieu
    
    frame_arr = zeros(1, frame_number);
    f0_arr = zeros(1, frame_number); % mang chua F0 cua moi khung
    t0_arr = zeros(1, frame_number);
    f0 = 0; % tan so co ban
    t0 = 0;  % thoi gian tai f0
    % ---------------
    % ve do thi voice va unvoice bang phuong phap thu cong
    if (i == 1) % phone_M2
        frame_index = x(9120:9120+frame_length);
        subplot(4,1,1);
        plot(ACF(frame_index, length(frame_index)));
        title("Voice");
        frame_index = x(16800:16800+frame_length);
        subplot(4,1,2);
        plot(ACF(frame_index, length(frame_index)));
        title("Unvoice");
    elseif (i == 2) % phone_F2
        frame_index = x(32100:32100+frame_length);
        subplot(4,1,1);
        plot(ACF(frame_index, length(frame_index)));
        title("Voice");
        frame_index = x(30240:30240+frame_length);
        subplot(4,1,2);
        plot(ACF(frame_index, length(frame_index)));
        title("Unvoice");
    elseif (i == 3) % studio_M2
        frame_index = x(21168:21168+frame_length);
        subplot(4,1,1);
        plot(ACF(frame_index, length(frame_index)));
        title("Voice");
        frame_index = x(19845:19845+frame_length);
        subplot(4,1,2);
        plot(ACF(frame_index, length(frame_index)));
        title("Unvoice");
    elseif (i == 4) % studio_f2
        frame_index = x(39690:39690+frame_length);
        subplot(4,1,1);
        plot(ACF(frame_index, length(frame_index)));
        title("Voice");
        frame_index = x(59535:59535+frame_length);
        subplot(4,1,2);
        plot(ACF(frame_index, length(frame_index)));
        title("Unvoice");
    end
    % ve do thi input signal
    subplot(4,1,3);
    plot(linspace(0, length(x) / fs, length(x)), x);
    xlabel("Time(seconds)"); ylabel("Normalized Amplitude");
    title(strcat(strcat("Input: F0mean = ", string(line_f0_mean(2))), strcat(", F0std = ", string(line_f0_std(2)))));
    % ---------------
    subplot(4,1,4);
    for index = 1 : frame_number
        
        start_frame = (index - 1) * frame_length + 1;
        if (index == frame_number)
            end_frame = length(x) - (index - 1) * frame_length;
        else
            end_frame = index * frame_length;
        end
        frame_index = x(start_frame : end_frame);
        
        % ham tu tuong quan
        index_length = length(frame_index); % do dai khung tin hieu thu index
        acf = ACF(frame_index, index_length);
        max_peak = 0; % maximum autocorrelation peak
        pos = 0; % vi tri cua max_peak trong khung
        % find maxium autocorrelation peak (cuc dai cuc bo)
        for peak_index = 2 : (index_length - 1) % ignore first and last peak of frame
            if (acf(peak_index) > acf(peak_index - 1) && acf(peak_index) > acf(peak_index + 1) && acf(peak_index) > max_peak)
                max_peak = acf(peak_index);
                pos = peak_index;
            end
        end
        % nguong tin hieu
        threshold = 0.55;
        % so sanh bien do cuc dai voi nguong tin hieu => ra quyet dinh
        % voice, unvoice
        f0 = fs/pos;
        t0 = (start_frame + pos) / fs;
        if (max_peak >= threshold && f0 > f0_min && f0 < f0_max)
            f0_arr(index) = f0;
            t0_arr(index) = t0;
        else
            f0_arr(index) = 0;
            t0_arr(index) = t0;
        end
    end
    % ---------------
    new_f0_arr = f0_arr(f0_arr ~= 0); % loai bo cac gia tri f0 = 0 trong f0_arr[]
    % find f0 mean
    f0_mean = mean(new_f0_arr);
    % find f0 std
    f0_std = std(new_f0_arr);
    
    % loc pitch ao va ve output
    for iindex = 1 : length(f0_arr)
        if (f0_arr(iindex) >= 2*f0_mean)
            f0_arr(iindex) = 0;
        end
        if f0_arr(iindex) > 0
            plot(t0_arr(iindex), f0_arr(iindex), 'Color', 'b', 'LineStyle', 'none', 'Marker', '*');
            hold on;
        else
            plot(t0_arr(iindex), f0_arr(iindex));
            hold on;
        end
    end
    xlabel("Time(seconds)"); ylabel("F0(Hz)");
    % Do lech
    delta_f0_mean = abs(double(line_f0_mean(2)) - f0_mean); % do lech f0_mean
    delta_f0_std = abs(double(line_f0_std(2)) - f0_std); % do lech f0_mean
    title(strcat(strcat("Output: F0mean = ", string(f0_mean), "(", string(delta_f0_mean), ")"), strcat(", F0std = ", string(f0_std), "(", string(delta_f0_std), ")")));
    i = i + 1;
end


 

