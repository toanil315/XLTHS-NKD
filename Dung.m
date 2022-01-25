t01=[0.45 0.81 1.53 1.85 2.69 2.86 3.78 4.15 4.84 5.14];
t02=[0.83 1.37 2.09 2.6 3.57 4 4.76 5.33 6.18 6.68];
t03=[1.03 1.42 2.46 2.8 4.21 4.52 6.81 7.14 8.22 8.5];
t06=[1.52 1.92 3.91 4.35 6.18 6.6 8.67 9.14 10.94 11.33];
t44=[0.93 1.42 2.59 3 4.71 5.11 6.26 6.66 8.04 8.39]
t30 =[0.59 0.97 1.76 2.11 3.44 3.77 4.7 5.13 5.96 6.28];
[sig,fs] = audioread('D:\Adacity Workspace\tinhieukiemthu\44MTT.wav'); %Fetch the signal
N = 32768; %N-point fft
frame_len = ceil(0.03*fs); %Length of frame (30ms)
half = round(frame_len/2); %For overlapping frame
h = hamming(frame_len); %Hamming window function
time_sig = length(sig)/fs; 
total_frame = round(time_sig*98);
time_frame_first =0;
time_frame_last = 0.03;

for i = 1 : total_frame-1
     % kk
   check_ok =checkSpeech(t02,time_frame_first,time_frame_last);
   aa(i)=0;
   %jj 
   if (check_ok==1)
    time_output(i)=(time_frame_first+time_frame_last)/2;
    sample_first = time_frame_first*fs+1;
    sample_last = time_frame_last*fs;
    sample_frame = sig(sample_first:sample_last);
    frame = h.*sample_frame; %Value of each element in window
    P2 = abs(fft(frame,N));
    P1 = P2(1:length(P2)/2+1); %The single-sided spectrum P1
    data2 = downsample(P1,2);
    data3 = downsample(P1,3);
    data4 = downsample(P1,4);
    data5 = downsample(P1,5);
    data6 = downsample(P1,6);
    data7 = downsample(P1,7);
        data8 = downsample(P1,8);

  
    for j = 1:length(data7)
     hps(j) = P1(j)*data2(j)*data3(j)*data4(j)*data5(j)*data6(j)*data7(j);
    end
    [m,n]=findpeaks(hps, 'SORTSTR', 'descend');
    F0_test =( (n(2) / 32768) * fs );
    a=n(1);
    b=n(2);
    if (a*2<(b+10))
     b=n(3);   
    end
    if (b*2<(a+3))
     F0 =  ( (b / 32768) * fs );
     aa(i)=1;
    else
     F0 =  ( (a / 32768) * fs );
    end
     if (F0>70 && F0<400)
     output(i) = F0;
     else
     output(i)=0;
     end
   end
   time_frame_first = time_frame_last-0.02;
   time_frame_last = time_frame_first+0.03;
end

plot(output,'.');

 function [conclude] = checkSpeech(arr_speech,frame_time_first,frame_time_last)
    conclude=0;
    for i = 1:length(arr_speech)
       if (mod(i,2)==1 && (frame_time_first>=arr_speech(i) && frame_time_last<=arr_speech(i+1)))
           conclude = 1;
           break;
       end
    end

end
 
