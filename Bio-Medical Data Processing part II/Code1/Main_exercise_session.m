clear all
close all
clc
%% Part I: Decompose using HSVD & filter water @ 4.7ppm

load ExSession1_MRS_signal

% INPUT

% step: sampling time
% begin: begin time of the signal
% ndp: number of points
% frequency: spectrometer frequency

% compute the ppm, KHz and time axis
ppmaxis = ppmaxisfind(step,ndp,frequency);          % X axis in [ppm]
kHzaxis = ppm2kHz(ppmaxis, frequency);              % X axis in [KHz]
t=[0:step:(ndp-1)*step];                            % Time duration [Sec]

% plot the real part of the signal in time and frequency [ppm] domain
% time
figure,plot(t,real((MRS_single_signal)));
xlabel('time','FontSize',12),ylabel('Amplitude (a.u.)','FontSize',12), title('MRS signal with water in time domain');
% frequency [ppm]
figure,plot(ppmaxis,real(fftshift(fft(MRS_single_signal))))
set(gca, 'xdir', 'reverse'); xlabel('ppm','FontSize',12),ylabel('Amplitude (a.u.)','FontSize',12), xlim([0 8]), title('MRS Signal with water in ppm domain');

%% Decompose the signal using HSVD
% decompose the signal in k components.
fsampl=1/step;                                                  % Sampling frequency [Hz]
k=30;                                                           % Test several k=30 values model order
[freq,damp,ampl,phas]=hsvdU(MRS_single_signal,k,fsampl,t,ndp);  % Decomposition of the signal using hsvdU
% Listing the number of components
K=1:k;                                                          % Raw of different order of components
legendCell=strcat('N=',strtrim(cellstr(num2str(K(:)))));        % Generation fo cells for the legend
% Initialization of signal and spectrum
Signal=zeros(k,length(t));                                      % Signal in time domain for each component to be reconstructed
SpectrumSignalComponent=Signal;                                 % Spectrum for each component
% The following loop will decompose the signal for different order model
[Signal,SpectrumSignalComponent]=IndivudialComponent(t,ampl,freq,damp,phas,step);              % Individual component computation
for j=1:k
    [freq1,damp1,ampl1,phas1]=hsvdU(MRS_single_signal,j,fsampl,t,ndp);                    % Decompose the signal using hsvdU
    SignalReconstructed(j,:)=reconsd(t,freq1,damp1,ampl1,phas1);                          % Reconstruct the decomposed component signal in time domain for that corresponding model order according to the iteration
    ReconstructedSpectrumSignalComponent(j,:)=(fftshift(fft(SignalReconstructed(j,:))));  % Computation of the spectrum for a certain decomposition model
end
%%
% Ploting the sepctrum components
figure,plot(ppmaxis,real((ReconstructedSpectrumSignalComponent)));
set(gca, 'xdir', 'reverse');
legend(legendCell), xlim([0 5])
xlabel('ppm','FontSize',12),ylabel('Amplitude (a.u.)','FontSize',12), title('Reconstructed spectrum');
% Ploting the signal component
figure,plot(t,real((SignalReconstructed)));
title('Reconstructed signal component')
ylabel('Amplitude (a.u.)','FontSize',12),xlabel('Time in sec');
legend(legendCell);
%
[x,y]=size(SpectrumSignalComponent);

figure% Ploting individual components spectrum
for i=1:x
    component=sprintf('Spectrum for the componenet %d',i);
    subplot1 = subplot(5,6,i);
    plot(ppmaxis,real((SpectrumSignalComponent(i,:))));
    set(gca, 'xdir', 'reverse');
    xlim([0 8])
    xlabel('ppm','FontSize',12),ylabel('Amplitude (a.u.)','FontSize',12), title(component);
end

figure% Ploting individual components in time
for i=1:x
    component=sprintf('Time domain signal for the componenet %d',i);
    subplot1 = subplot(5,6,i);
    plot(t,real((Signal(i,:))));
    ylabel('Amplitude (a.u.)','FontSize',12),xlabel('Time in sec');
    title(component);
end
clear y
%% filter water around 4.7ppm
freq_ppm=freq*10^6/frequency+4.7; % go from frequency to ppm
for i=1:k
    [SpectrumOfWatterSignal(i,:),SpectrumOfWatterFilterSignal(i,:),mrs_filt(i,:),mrs_water(i,:),SNR(i)]=FilterSignal(MRS_single_signal,i,fsampl,t,ndp,frequency); % Filter the water signal from each of the components
end

%%

figure
for i=1:k
    component=sprintf('Filtered signal in time domain for the model order %d',i);
    subplot1 = subplot(5,6,i);
    plot(t,real((mrs_filt(i,:))));
    ylabel('Amplitude (a.u.)','FontSize',12),xlabel('Time in sec');
    title(component);
end

figure
for i=1:k
    component=sprintf('Sepctrum of filtered signal for moder order %d',i);
    subplot1 = subplot(5,6,i);
    plot(ppmaxis,(real(SpectrumOfWatterFilterSignal(i,:))));
    xlabel('ppm','FontSize',12),ylabel('Amplitude (a.u.)','FontSize',12),
    title(component);
    xlim([0 8]),set(gca, 'xdir', 'reverse');
end

figure,plot(ppmaxis,(real(SpectrumOfWatterFilterSignal(30,:))));
set(gca, 'xdir', 'reverse');
xlabel('ppm','FontSize',12),ylabel('Amplitude (a.u.)','FontSize',12), title('Sepctrum of filtered signal for moder order 30');
xlim([0 8])

figure,plot(ppmaxis,(real(SpectrumOfWatterSignal)));
set(gca, 'xdir', 'reverse');
legend(legendCell);
xlabel('ppm','FontSize',12),ylabel('Amplitude (a.u.)','FontSize',12), title('Sepctrum of Water signal');
xlim([0 5])

figure,plot(t,real((mrs_water)));
title('Water signal in time domain')
legend(legendCell);
ylabel('Amplitude (a.u.)','FontSize',12),xlabel('Time in sec');

figure,plot(1:k,SNR,'r')
hold on
plot(1:k,SNR,'x')
xlabel('Nr of components'),ylabel('SNR in dB'),title('Estimation of the signal to noise')
%% Part 2: Quantify (original & noisy) water filtered signal using HSVD, HTLS, HTLSPK
mrs_filt=mrs_filt(k,:);
noise_std=std(mrs_filt(end-299:end));                   % get standard deviation of the last 300 points of the water filtered signal
rng(25);                                                % set the seed for the random noise generator
mrs_noisy=mrs_filt+normrnd(0,noise_std,[1 ndp]);        % add noise to the water filtered signal: m=0, StDev=std
%%
figure
plot(ppmaxis,(real(fftshift(fft(mrs_filt)))));
hold on
plot(ppmaxis,(real(fftshift(fft(mrs_noisy)))),'r');
set(gca, 'xdir', 'reverse');
legend('Pure signal','Pure signal');
xlabel('ppm','FontSize',12),ylabel('Amplitude (a.u.)','FontSize',12), title('Sepctrum of Water signal');
xlim([0 5])

figure
plot(t,(real((mrs_filt))));
hold on
plot(t,(real((mrs_noisy))),'r');
% set(gca, 'xdir', 'reverse');
legend('Pure signal','Pure signal');
xlabel('ppm','FontSize',12),ylabel('Amplitude (a.u.)','FontSize',12), title('Sepctrum of Water signal');
xlim([0 20])
%%
htlspk_freq_ppm=3.972554929018351;                                                      % Frequency ppm prior knowledge
htlspk_freq_Khz=ppm2kHz(htlspk_freq_ppm,frequency);                                     % Frequency kHz prior knowledge
htlspk_damp=0.072981231085375410;                                                       % Damping prior knowledge
M=ndp/2;

% Quantify BOTH signals using different subspace approaches: HSVD, HTLS, HTLSPK
[freq1,damp1,ampl1,phas1]=hsvdU(mrs_filt,k,fsampl,t,ndp);                                      % Decompose the water filtered signal via hsvdU
[freq1_1,damp1_1,ampl1_1,phas1_1]=hsvdU(mrs_noisy,k,fsampl,t,ndp);                             % Decompose the noisy water filtered signal via hsvdU
[freq2,damp2,ampl2,phas2]=htlsU(mrs_filt,k,fsampl,t,ndp);                                      % Decompose the water filtered signal via htlsU
[freq2_1,damp2_1,ampl2_1,phas2_1]=htlsU(mrs_noisy,k,fsampl,t,ndp);                             % Decompose the noisy water filtered signal via htlsU
[freq3,damp3,ampl3,phas3]=htlspkfd(mrs_filt,k,fsampl,t,M,htlspk_freq_Khz,htlspk_damp);         % Decompose the water filtered signal via htlspkfd using the prior knowledge
[freq3_1,damp3_1,ampl3_1,phas3_1]=htlspkfd(mrs_noisy,k,fsampl,t,M,htlspk_freq_Khz,htlspk_damp);% Decompose the noisy signal via htlspkfd using the prior knowledge


[vrecn1]=reconsd(t,freq1,damp1,ampl1,phas1);                                            % Reconstruct the water filtered signal via the estimated parameters from hsvdU
[vrecn1_1]=reconsd(t,freq1_1,damp1_1,ampl1_1,phas1_1);                                  % Reconstruct the noisy water filtered signal via the estimated parameters from hsvdU
[vrecn2]=reconsd(t,freq2,damp2,ampl2,phas2);                                            % Reconstruct the water filtered signal via the estimated parameters from htlsU
[vrecn2_1]=reconsd(t,freq2_1,damp2_1,ampl2_1,phas2_1);                                  % Reconstruct the noisy water filtered signal via the estimated parameters from htlsU
[vrecn3]=reconsd(t,freq3,damp3,ampl3,phas3);                                            % Reconstruct the water filtered signal via the estimated parameters from htlspkfd
[vrecn3_1]=reconsd(t,freq3_1,damp3_1,ampl3_1,phas3_1);                                  % Reconstruct the noisy water filtered signal via the estimated parameters from htlsU

[Signal1,SpectrumSignalComponent1]=IndivudialComponent(t,freq1,damp1,ampl1,phas1,step);        % Individual component computation for hsvd of the water filtered signal
[Signal2,SpectrumSignalComponent2]=IndivudialComponent(t,freq1_1,damp1_1,ampl1_1,phas1_1,step);% Individual component computation for hsvd of the noisy water filtered signal
[Signal3,SpectrumSignalComponent3]=IndivudialComponent(t,freq2,damp2,ampl2,phas2,step);        % Individual component computation for htlsU of the water filtered signal
[Signal4,SpectrumSignalComponent4]=IndivudialComponent(t,freq2_1,damp2_1,ampl2_1,phas2_1,step);% Individual component computation for htlsU of the noisy water filtered signal
[Signal5,SpectrumSignalComponent5]=IndivudialComponent(t,freq3,damp3,ampl3,phas3,step);        % Individual component computation for htlspkfd of the water filtered signal
[Signal6,SpectrumSignalComponent6]=IndivudialComponent(t,freq3_1,damp3_1,ampl3_1,phas3_1,step);% Individual component computation for htlspkfd of the noisy water filtered signal

%%
freq=[freq1;freq2;freq3;freq1_1;freq2_1;freq3_1]';
damp=[damp1;damp2;damp3;damp1_1;damp2_1;damp3_1]';
ampl=[ampl1;ampl2;ampl3;ampl1_1;ampl2_1;ampl3_1]';
phas=[phas1;phas2;phas3;phas1_1;phas2_1;phas3_1]';
%%
freq=sort(freq,1,'descend');
damp=sort(damp,1,'descend');
ampl=sort(ampl,1,'descend');
phas=sort(phas,1,'descend');
%%

figure,plot(K,freq),hold on,plot(K,freq,'x'),hold on,plot(K,freq,'o'),xlabel('Nr of iteration'),ylabel('Hz'),title('Estimation of frequency');
legend('hsvD pure signal','htls pure signal','htlspk pure signal','hsvD noisy signal','htls noisy signal','htlspk noisy signal')

figure,plot(K,damp),hold on,plot(K,damp,'x'),hold on,plot(K,damp,'o'),xlabel('Nr of iteration'),ylabel('unit'),title('Estimation of damping');
legend('hsvD pure signal','htls pure signal','htlspk pure signal','hsvD noisy signal','htls noisy signal','htlspk noisy signal')

figure,plot(K,ampl),hold on,plot(K,ampl,'x'),hold on,plot(K,ampl,'o'),xlabel('Nr of iteration'),ylabel('unit'),title('Estimation of amplitude');
legend('hsvD pure signal','htls pure signal','htlspk pure signal','hsvD noisy signal','htls noisy signal','htlspk noisy signal')

figure,plot(K,phas),hold on,plot(K,phas,'x'),hold on,plot(K,phas,'o'),xlabel('Nr of iteration'),ylabel('rad'),title('Estimation of phase');
legend('hsvD pure signal','htls pure signal','htlspk pure signal','hsvD noisy signal','htls noisy signal','htlspk noisy signal')
%%

figure
for i=1:x
    component=sprintf('Spectrum for the componenet %d',i);
    subplot1 = subplot(5,6,i);
    plot(ppmaxis,real((SpectrumSignalComponent1(i,:))));
    set(gca, 'xdir', 'reverse');
    xlim([0 8])
    xlabel('ppm','FontSize',12),ylabel('Amplitude (a.u.)','FontSize',12), title(component);
end

figure
for i=1:x
    component=sprintf('Spectrum for the componenet %d',i);
    subplot1 = subplot(5,6,i);
    plot(ppmaxis,real((SpectrumSignalComponent2(i,:))));
    set(gca, 'xdir', 'reverse');
    xlim([0 8])
    xlabel('ppm','FontSize',12),ylabel('Amplitude (a.u.)','FontSize',12), title(component);
end

figure
for i=1:x
    component=sprintf('Spectrum for the componenet %d',i);
    subplot1 = subplot(5,6,i);
    plot(ppmaxis,real((SpectrumSignalComponent3(i,:))));
    set(gca, 'xdir', 'reverse');
    xlim([0 8])
    xlabel('ppm','FontSize',12),ylabel('Amplitude (a.u.)','FontSize',12), title(component);
end

figure
for i=1:x
    component=sprintf('Spectrum for the componenet %d',i);
    subplot1 = subplot(5,6,i);
    plot(ppmaxis,real((SpectrumSignalComponent4(i,:))));
    set(gca, 'xdir', 'reverse');
    xlim([0 8])
    xlabel('ppm','FontSize',12),ylabel('Amplitude (a.u.)','FontSize',12), title(component);
end

figure
for i=1:x
    component=sprintf('Spectrum for the componenet %d',i);
    subplot1 = subplot(5,6,i);
    plot(ppmaxis,real((SpectrumSignalComponent5(i,:))));
    set(gca, 'xdir', 'reverse');
    xlim([0 8])
    xlabel('ppm','FontSize',12),ylabel('Amplitude (a.u.)','FontSize',12), title(component);
end

figure
for i=1:x
    component=sprintf('Spectrum for the componenet %d',i);
    subplot1 = subplot(5,6,i);
    plot(ppmaxis,real((SpectrumSignalComponent6(i,:))));
    set(gca, 'xdir', 'reverse');
    xlim([0 8])
    xlabel('ppm','FontSize',12),ylabel('Amplitude (a.u.)','FontSize',12), title(component);
end

%%

figure, plot(ppmaxis,real(fftshift(fft(mrs_filt))),'b')
hold on,plot(ppmaxis,real(fftshift(fft(vrecn1))),'<')
hold on,plot(ppmaxis,real(fftshift(fft(vrecn2))),'>')
hold on,plot(ppmaxis,real(fftshift(fft(vrecn3))),'*')


SNRa=snr(mrs_filt,MRS_single_signal-mrs_filt);
SNRb=snr(vrecn1,mrs_filt-vrecn1);
SNRc=snr(vrecn2,mrs_filt-vrecn2);
SNRd=snr(vrecn3,mrs_filt-vrecn3);


a=sprintf('pre-estimate signal, SNR=%d',SNRa);
b=sprintf('hsvD, SNR=%d',SNRb);
c=sprintf('htls, SNR=%d',SNRc);
d=sprintf('htlspk, SNR=%d',SNRd);

legend(a,b,c,d)
set(gca, 'xdir', 'reverse');xlabel('ppm'),title('Pure signal'),ylabel('amplitude (a.u)')
xlim([0 5])

figure,plot(ppmaxis,real(fftshift(fft(mrs_noisy))),'b')
hold on,plot(ppmaxis,real(fftshift(fft(vrecn1_1))),'<')
hold on,plot(ppmaxis,real(fftshift(fft(vrecn2_1))),'>')
hold on,plot(ppmaxis,real(fftshift(fft(vrecn3_1))),'*')

SNRa=snr(mrs_noisy,MRS_single_signal-mrs_noisy);
SNRb=snr(vrecn1_1,mrs_noisy-vrecn1_1);
SNRc=snr(vrecn2_1,mrs_noisy-vrecn2_1);
SNRd=snr(vrecn3_1,mrs_noisy-vrecn3_1);

a1=sprintf('pre-estimate signal, SNR=%d',SNRa);
b1=sprintf('hsvD, SNR=%d',SNRb);
c1=sprintf('htls, SNR=%d',SNRc);
d1=sprintf('htlspk, SNR=%d',SNRd);

legend(a1,b1,c1,d1)
set(gca, 'xdir', 'reverse');xlabel('ppm'),title('noisy signal'),ylabel('amplitude (a.u)')
xlim([0 5])

figure
hold on,plot(ppmaxis,real(fftshift(fft(mrs_filt-vrecn1))),'<')
hold on,plot(ppmaxis,real(fftshift(fft(mrs_filt-vrecn2))),'>')
hold on,plot(ppmaxis,real(fftshift(fft(mrs_filt-vrecn3))),'*')

mu1=mean(mrs_filt-vrecn1);
mu2=mean(mrs_filt-vrecn2);
mu3=mean(mrs_filt-vrecn3);

var1=var(mrs_filt-vrecn1);
var2=var(mrs_filt-vrecn2);
var3=var(mrs_filt-vrecn3);

a2=sprintf('hsvD mu=%d,var=%d',mu1,var1);
b2=sprintf('htls mu=%d,var=%d',mu2,var2);
c2=sprintf('htlspk mu=%d,var=%d',mu3,var3);

legend(a2,b2,c2)

set(gca, 'xdir', 'reverse');xlabel('ppm'),title('Pure signal'),ylabel('amplitude (a.u)')
xlim([0 5])

figure
hold on,plot(ppmaxis,real(fftshift(fft(mrs_noisy-vrecn1_1))),'<')
hold on,plot(ppmaxis,real(fftshift(fft(mrs_noisy-vrecn2_1))),'>')
hold on,plot(ppmaxis,real(fftshift(fft(mrs_noisy-vrecn3_1))),'*')

mu1=mean(mrs_noisy-vrecn1_1);
mu2=mean(mrs_noisy-vrecn2_1);
mu3=mean(mrs_noisy-vrecn3_1);


var1=var(mrs_noisy-vrecn1_1);
var2=var(mrs_noisy-vrecn2_1);
var3=var(mrs_noisy-vrecn3_1);


a2=sprintf('hsvD mu=%d,var=%d',mu1,var1);
b2=sprintf('htls mu=%d,var=%d',mu2,var2);
c2=sprintf('htlspk mu=%d,var=%d',mu3,var3);

legend(a2,b2,c2)
set(gca, 'xdir', 'reverse');xlabel('ppm'),title('noisy signal'),ylabel('amplitude (a.u)')
xlim([0 5])




%% Part 3: Noise removal & Quantification using Cadzow-HTLS, Mv-HTLS, Multichannel Cadzow-HTLS

% yOutc=cadzow(mrs_filt, k, ndp);             % remove noise from the water filtered signal using cadzow
% yOutc1=minimum_variance(mrs_filt, k, ndp);  % remove noise from the water filtered signal using minimum variance
% 
% [freq_P_htls,damp_P_htls,ampl_P_htls,phas_P_htls]=htlsU(mrs_filt,k,fsampl,t,ndp);   % quantify parameters of interest of orginal signal using HTLS
% [freq_C_htls,damp_C_htls,ampl_C_htls,phas_C_htls]=htlsU(yOutc,k,fsampl,t,ndp);      % quantify parameters of interest of the cadzow filtered signal using HTLS
% [freq_MV_htls,damp_MV_htls,ampl_MV_htls,phas_MV_htls]=htlsU(yOutc1,k,fsampl,t,ndp); % quantify parameters of interest of the minimum variance filtered signal using HTLS
% 
% [vrecn4]=reconsd(t,freq_P_htls,damp_P_htls,ampl_P_htls,phas_P_htls);                % reconstruction of the orginal signal
% [vrecn5]=reconsd(t,freq_C_htls,damp_C_htls,ampl_C_htls,phas_C_htls);                % reconstruction of the cadzow filtered signal
% [vrecn6]=reconsd(t,freq_MV_htls,damp_MV_htls,ampl_MV_htls,phas_MV_htls);            % reconstruction of the minimum variance filtered signal
% 
% PreEnhanceSpectrum=real(fftshift(fft(mrs_filt)));                                   % computation of the spectrum for the orginal signal
% CadzowEnhanceSpectrum=real(fftshift(fft(yOutc)));                                   % computation of the spectrum for the cadzow filtered signal
% MinVarianceEnhanceSpectrum=real(fftshift(fft(yOutc1)));                             % computation of the spectrum the minimum variance filtered signal
% 
% SNR1=snr(mrs_filt,MRS_single_signal-mrs_filt);                                      % computation of the spectrum for the orginal signal
% SNR2=snr(yOutc,mrs_filt'-yOutc);                                                    % computation of the spectrum for the cadzow filtered signal
% SNR3=snr(yOutc1,mrs_filt'-yOutc1);                                                  % computation of the spectrum for the minimum variance filtered signal

%%
% plot the signals on top of each other filtered spectrum
% figure,plot(ppmaxis,PreEnhanceSpectrum,'b')
% hold on,plot(ppmaxis,CadzowEnhanceSpectrum,'<')
% hold on,plot(ppmaxis,MinVarianceEnhanceSpectrum,'*')
% set(gca, 'xdir', 'reverse'); xlabel('ppm','FontSize',12),ylabel('Amplitude (a.u.)','FontSize',12), xlim([0 5]),title('MV')
% legend('Pure signal','Cadzow','Minimuma Variance'),title('Enhanced signal')
% 
% 
% figure,plot(ppmaxis,real(fftshift(fft(vrecn4))),'b')
% hold on,plot(ppmaxis,real(fftshift(fft(vrecn5))),'<')
% hold on,plot(ppmaxis,real(fftshift(fft(vrecn6))),'*')
% set(gca, 'xdir', 'reverse'); xlabel('ppm','FontSize',12),ylabel('Amplitude (a.u.)','FontSize',12), xlim([0 5]),title('MV')
% legend('Pure signal','Cadzow','Minimuma Variance'),title('Reconstructed signal')

%% Work on a local neighbourhood of 3x3 pixels around the position 623 (the original signal) from the grid MRS_grid_signal
% This code is used only to visualize the voxels numbering
axis1=1:32;
axis2=1:32;
[x,y]=meshgrid(axis1,axis2);
figure
plot(x,y,'.')
hold on
plot(x,y,'.')
for i=1:32
    ac = (i-1)*32*ones(32,1)+[1:32]'; b = num2str(ac); c = cellstr(b);
    text(axis1, i*ones(size(axis1)), c);
end
%%

PositionOfMainVoxel=623;                                              % Postion of the voxel of interest
NrOfVoxels=32;                                                        % Number of voxels
DimensionConsideration=3;                                             % Dimension consideratation of the neigbhours it has to odd number
maner=1;                                                              % Describes the manner of neighbourhooding 1+> full, 1=> horizontally and vertically, 2=> diagonally and anti-diagonally
[Neigbours,pos]=ExtractionNeigbours(PositionOfMainVoxel,DimensionConsideration,MRS_grid_signal,maner);

%%
% Remove the water component from each voxel in the neighbourhood using
% the same model order and the same frequency window as in Exercise 1.1.
[x,y]=size(Neigbours);
for i=1:x
    [SpectrumOfNeigbours(i,:),SpectrumOfWatterFilterNeigbours(i,:),mrs_filtMulti(i,:),mrs_water(i,:),~]=FilterSignal(Neigbours(i,:),k,fsampl,t,ndp,frequency);
end
OriginalSignal=mrs_filtMulti(pos,:);
%%
figure,plot(ppmaxis,real(SpectrumOfWatterFilterNeigbours))
set(gca, 'xdir', 'reverse'); xlabel('ppm','FontSize',12),ylabel('Amplitude (a.u.)','FontSize',12), xlim([0 5])
title('Filtered multi-channel data'),legend(legendCell)

figure,plot(ppmaxis,real(SpectrumOfNeigbours))
set(gca, 'xdir', 'reverse'); xlabel('ppm','FontSize',12),ylabel('Amplitude (a.u.)','FontSize',12)
title('Multi-channel data'),legend(legendCell)

%%

MultiChannelDataEnhanced=Multi_Channel_Cadzow(mrs_filtMulti, k, ndp,pos);                  %  Multichannel Cadzow application over the channel data
CadzowOutput=cadzow(OriginalSignal, k, ndp);                                               %  Cadzow application over the channel data
Minimum_varianceOutput=minimum_variance(OriginalSignal, k, ndp);                           %  Minimum variance application over the channel data
%%
[freq_P_htls,damp_P_htls,ampl_P_htls,phas_P_htls]=htlsU(mrs_filtMulti(pos,:),k,fsampl,t,ndp);      % quantify parameters of interest of orginal signal using HTLS
[freq_C_htls,damp_C_htls,ampl_C_htls,phas_C_htls]=htlsU(CadzowOutput,k,fsampl,t,ndp);              % quantify parameters of interest of the cadzow filtered signal using HTLS
[freq_MV_htls,damp_MV_htls,ampl_MV_htls,phas_MV_htls]=htlsU(Minimum_varianceOutput,k,fsampl,t,ndp);% quantify parameters of interest of the minimum variance filtered signal using HTLS
[freqMCC,dampMCC,amplMCC,phasMCC]=htlsU(MultiChannelDataEnhanced,k,fsampl,t,ndp);                  % quantify parameters of interest of the cadzow filtered signal using HTLS

%%

[vrecn4]=reconsd(t,freq_P_htls,damp_P_htls,ampl_P_htls,phas_P_htls);                % reconstruction of the orginal signal
[vrecn5]=reconsd(t,freq_C_htls,damp_C_htls,ampl_C_htls,phas_C_htls);                % reconstruction of the cadzow filtered signal
[vrecn6]=reconsd(t,freq_MV_htls,damp_MV_htls,ampl_MV_htls,phas_MV_htls);            % reconstruction of the minimum variance filtered signal
[Reconstucted]=reconsd(t,freqMCC,dampMCC,amplMCC,phasMCC);                          % reconstruction of the cadzow filtered signal
%%
PreEnhanceSpectrum=real(fftshift(fft(OriginalSignal)));                             % computation of the spectrum for the orginal signal
CadzowEnhanceSpectrum=real(fftshift(fft(CadzowOutput)));                                   % computation of the spectrum for the cadzow filtered signal
MinVarianceEnhanceSpectrum=real(fftshift(fft(Minimum_varianceOutput)));                             % computation of the spectrum the minimum variance filtered signal
MultiChannelDataEnhancedSpectrum=real(fftshift(fft(MultiChannelDataEnhanced)));     % computation of the spectrum for the cadzow filtered signal

SNR1=snr(OriginalSignal,MRS_single_signal-OriginalSignal);                          % computation of the spectrum for the orginal signal
SNR2=snr(CadzowOutput,OriginalSignal'-CadzowOutput);                                              % computation of the spectrum for the cadzow filtered signal
SNR3=snr(Minimum_varianceOutput,OriginalSignal'-Minimum_varianceOutput);                                            % computation of the spectrum for the minimum variance filtered signal
SNR4=snr(MultiChannelDataEnhanced,OriginalSignal-MultiChannelDataEnhanced);         % computation of the spectrum for the multichannel cadzow filtered signal
%%

figure,plot(ppmaxis,real(fftshift(fft(MultiChannelDataEnhanced))))
hold on,plot(ppmaxis,real(fftshift(fft(CadzowOutput))),'<')
hold on,plot(ppmaxis,real(fftshift(fft(Minimum_varianceOutput))),'.')
hold on,plot(ppmaxis,real(fftshift(fft(OriginalSignal))),'>')
set(gca, 'xdir', 'reverse'); xlabel('ppm','FontSize',12),ylabel('Amplitude (a.u.)','FontSize',12)
title('Enhance signals'),legend(legendCell), xlim([0 5])
legend('Multichannel Cadzow','Cadzow','Minimum Variance','Original')

figure,plot(ppmaxis,real(fftshift(fft(Reconstucted))))
hold on,plot(ppmaxis,real(fftshift(fft(vrecn5))),'<')
hold on,plot(ppmaxis,real(fftshift(fft(vrecn6))),'.')
hold on,plot(ppmaxis,real(fftshift(fft(vrecn4))),'>')
set(gca, 'xdir', 'reverse'); xlabel('ppm','FontSize',12),ylabel('Amplitude (a.u.)','FontSize',12)
title('Reconstruction of the enhanced signal'),legend(legendCell), xlim([0 5])
legend('Multichannel Cadzow','Cadzow','Minimum Variance','Original')

%%
clear ampl1,clear ampl2,clear ampl3
clear ampl1_1,clear ampl2_1,clear ampl3_1
clear damp1,clear damp2,clear damp3
clear damp1_1,clear damp2_1,clear damp3_1
clear freq1,clear freq2,clear freq3
clear freq1_1,clear freq2_1,clear freq3_1
clear SpectrumOfNeigbours,clear SpectrumOfWatterFilterNeigbours, clear SpectrumOfWatterFilterSignal
clear SpectrumSignalComponent,clear SpectrumSignalComponent1,clear SpectrumSignalComponent2,clear SpectrumSignalComponent3
clear SpectrumSignalComponent4,clear SpectrumSignalComponent5,clear SpectrumSignalComponent6
clear Signal,clear Signal1,clear Signal2,clear Signal3,clear Signal4,clear Signal5,clear Signal6
clear SignalReconstructed, clear SpectrumOfWatterSignal, clear mrs_water
clear vrecn1,clear vrecn2,clear vrecn3,clear vrecn4,clear vrecn5,clear vrecn6
clear vrecn1_1,clear vrecn2_1,clear vrecn3_1
clear yOutc,clear yOutc1
close all
%% Optimize the computation of the Multi-Channel Cadzow enhancement.
index1=1;
for DimensionConsideration=3:2:5
    maner=1;
    [Neigbours,pos]=ExtractionNeigbours(PositionOfMainVoxel,DimensionConsideration,MRS_grid_signal,maner);
    [x,y]=size(Neigbours);
    for i=1:x
        [~,~,mrs_filt(i,:),~,~]=FilterSignal(Neigbours(i,:),k,fsampl,t,ndp,frequency); % Remove the water component from each voxel in the neighbourhood using the same model order and the same frequency window as in Exercise 1.1.
    end
    OriginalSignal=mrs_filt(pos,:);
    MultiChannelDataEnhanced=Multi_Channel_Cadzow(mrs_filt, k, ndp,pos);                %  Multichannel Cadzow application over the channel data
    SNR4(index1)=snr(MultiChannelDataEnhanced,OriginalSignal-MultiChannelDataEnhanced);  % Computation of the spectrum for the multichannel cadzow filtered signal
    index1=index1+1;
end
%%
maner=1;
[Neigbours,pos]=ExtractionNeigbours(PositionOfMainVoxel,9,MRS_grid_signal,maner);
[x,y]=size(Neigbours);
for i=1:x
    [~,~,mrs_filt(i,:),~,~]=FilterSignal(Neigbours(i,:),k,fsampl,t,ndp,frequency); % Remove the water component from each voxel in the neighbourhood using the same model order and the same frequency window as in Exercise 1.1.
end
figure
for i=1:x
    if i==pos
        component=sprintf('ppm, Voxel of interests',i);
    else
        component=sprintf('ppm,voxel position %d',i);
    end
    subplot1 = subplot(9,9,i);
    plot(ppmaxis,real(SpectrumOfWatterFilterSignal));
    set(gca, 'xdir', 'reverse');
    xlim([0 8])
    xlabel(component,'FontSize',7),ylabel('Amplitude (a.u.)','FontSize',7)
end
%%
index2_1=1;
for k=30:20
    index2=1;
    for DimensionConsideration=3:2:9
        maner=2;
        [Neigbours,pos]=ExtractionNeigbours(PositionOfMainVoxel,DimensionConsideration,MRS_grid_signal,maner);
        [x,y]=size(Neigbours);
        for i=1:x
            [~,~,mrs_filt(i,:),~,~]=FilterSignal(Neigbours(i,:),k,fsampl,t,ndp,frequency); % Remove the water component from each voxel in the neighbourhood using the same model order and the same frequency window as in Exercise 1.1.
        end
        OriginalSignal=mrs_filt(pos,:);
        MultiChannelDataEnhancedx=Multi_Channel_Cadzow(mrs_filt, k, ndp,pos);                %  Multichannel Cadzow application over the channel data
        SNR5(index2,index2_1)=snr(MultiChannelDataEnhancedx,OriginalSignal-MultiChannelDataEnhancedx);  % Computation of the spectrum for the multichannel cadzow filtered signal
        index2=index2+1;
    end
    index2_1=index2_1+1;
end
%%
index3_1=1;
for k=20:30
    index3=1;
    for DimensionConsideration=3:2:9
        maner=3;
        [Neigbours,pos]=ExtractionNeigbours(PositionOfMainVoxel,DimensionConsideration,MRS_grid_signal,maner);
        [x,y]=size(Neigbours);
        for i=1:x
            [~,SpectrumOfWatterFilterSignal,mrs_filt(i,:),~,~]=FilterSignal(Neigbours(i,:),k,fsampl,t,ndp,frequency); % Remove the water component from each voxel in the neighbourhood using the same model order and the same frequency window as in Exercise 1.1.
        end
        OriginalSignal=mrs_filt(pos,:);
        MultiChannelDataEnhancedX=Multi_Channel_Cadzow(mrs_filt, k, ndp,pos);                %  Multichannel Cadzow application over the channel data
        SNR6(index3,index3_1)=snr(MultiChannelDataEnhancedX,OriginalSignal-MultiChannelDataEnhancedX);  % Computation of the spectrum for the multichannel cadzow filtered signal
        index3=index3+1;
    end
    index3_1=index3_1+1;
end

%%
% HINT: Take into consideration different neighbourhoods (“+”,”X”, etc.) that can
% vary in size and also different model orders.
% TO BE COMPLETED

% Quantify parameters of peaks of interest using HTLS for the main voxel.
% TO BE COMPLETED
%%
index2_1=1;
for k=22:22
    index2=1;
    for DimensionConsideration=3:2:3
        maner=2;
        [Neigbours,pos]=ExtractionNeigbours(PositionOfMainVoxel,DimensionConsideration,MRS_grid_signal,maner);
        [x,y]=size(Neigbours);
        for i=1:x
            [~,~,mrs_filt(i,:),~,~]=FilterSignal(Neigbours(i,:),k,fsampl,t,ndp,frequency); % Remove the water component from each voxel in the neighbourhood using the same model order and the same frequency window as in Exercise 1.1.
        end
        OriginalSignal=mrs_filt(pos,:);
        MultiChannelDataEnhancedx=Multi_Channel_Cadzow(mrs_filt, k, ndp,pos);                %  Multichannel Cadzow application over the channel data
        SNR5(index2,index2_1)=snr(MultiChannelDataEnhancedx,OriginalSignal-MultiChannelDataEnhancedx);  % Computation of the spectrum for the multichannel cadzow filtered signal
        index2=index2+1;
    end
    index2_1=index2_1+1;
end
OriginalSignal=mrs_filt(pos,:);
MultiChannelDataEnhancedX=MultiChannelDataEnhancedx;

k=22;  % From the enhanced method this one yield the best SNR We have to runa gain the previus algorithm to compare the extracted paramteter for each estimation

CadzowOutput=cadzow(OriginalSignal, k, ndp);                                               %  Cadzow application over the channel data
Minimum_varianceOutput=minimum_variance(OriginalSignal, k, ndp);                           %  Minimum variance application over the channel data
MultiChannelDataEnhanced=Multi_Channel_Cadzow(mrs_filtMulti, k, ndp,pos);                  %  Multichannel Cadzow application over the channel data

%%
[freq_P_htls,damp_P_htls,ampl_P_htls,phas_P_htls]=htlsU(mrs_filt(pos,:),k,fsampl,t,ndp);                    % quantify parameters of interest of orginal signal using HTLS
[freq_C_htls,damp_C_htls,ampl_C_htls,phas_C_htls]=htlsU(CadzowOutput,k,fsampl,t,ndp);                       % quantify parameters of interest of the cadzow filtered signal using HTLS
[freq_MV_htls,damp_MV_htls,ampl_MV_htls,phas_MV_htls]=htlsU(Minimum_varianceOutput,k,fsampl,t,ndp);         % quantify parameters of interest of the minimum variance filtered signal using HTLS
[freqMCC,dampMCC,amplMCC,phasMCC]=htlsU(MultiChannelDataEnhanced,k,fsampl,t,ndp);                           % quantify parameters of interest of the cadzow filtered signal using HTLS
[freqMCCX,dampMCCX,amplMCCX,phasMCCX]=htlsU(MultiChannelDataEnhancedX,k,fsampl,t,ndp);                      % quantify parameters of interest of the cadzow filtered signal using HTLS

[vrecn4]=reconsd(t,freq_P_htls,damp_P_htls,ampl_P_htls,phas_P_htls);                % reconstruction of the orginal signal
[vrecn5]=reconsd(t,freq_C_htls,damp_C_htls,ampl_C_htls,phas_C_htls);                % reconstruction of the cadzow filtered signal
[vrecn6]=reconsd(t,freq_MV_htls,damp_MV_htls,ampl_MV_htls,phas_MV_htls);            % reconstruction of the minimum variance filtered signal
[Reconstucted]=reconsd(t,freqMCC,dampMCC,amplMCC,phasMCC);                          % reconstruction of the cadzow filtered signal
[ReconstuctedX]=reconsd(t,freqMCCX,dampMCCX,amplMCCX,phasMCCX);                     % reconstruction of the cadzow filtered signal
MinVarianceEnhanceSpectrumMCCX=real(fftshift(fft(MultiChannelDataEnhancedX)));      % computation of the spectrum the minimum variance filtered signal

%%
figure,plot(ppmaxis,real(fftshift(fft(MultiChannelDataEnhancedX))),'h')
hold on,plot(ppmaxis,real(fftshift(fft(MultiChannelDataEnhanced))),'<')
hold on,plot(ppmaxis,real(fftshift(fft(Minimum_varianceOutput))),'>')
hold on,plot(ppmaxis,real(fftshift(fft(CadzowOutput))),'.')
hold on,plot(ppmaxis,real(fftshift(fft(OriginalSignal))),'r')
set(gca, 'xdir', 'reverse'); xlabel('ppm','FontSize',12),ylabel('Amplitude (a.u.)','FontSize',12)
title('Enhance signals'),legend(legendCell), xlim([0 5])
legend('Multichannel Cadzow Enhanced','Multichannel Cadzow','Minimum Variance','Cadzow','Original')

%%

figure,plot(ppmaxis,real(fftshift(fft(ReconstuctedX))),'h')
hold on,plot(ppmaxis,real(fftshift(fft(vrecn5))),'<')
hold on,plot(ppmaxis,real(fftshift(fft(vrecn6))),'>')
hold on,plot(ppmaxis,real(fftshift(fft(vrecn4))),'.')
hold on,plot(ppmaxis,real(fftshift(fft(OriginalSignal))),'r')
set(gca, 'xdir', 'reverse'); xlabel('ppm','FontSize',12),ylabel('Amplitude (a.u.)','FontSize',12)
title('Reconstruction of the enhanced signal'),legend(legendCell), xlim([0 5])
legend('Multichannel Cadzow Enhanced','Multichannel Cadzow','Cadzow','Minimum Variance','Original')

%%
freq1=[freq_P_htls;freq_C_htls;freq_MV_htls;freqMCC;freqMCCX]';
damp1=[damp_P_htls;damp_C_htls;damp_MV_htls;dampMCC;dampMCCX]';
ampl1=[ampl_P_htls;ampl_C_htls;ampl_MV_htls;amplMCC;amplMCCX]';
phas1=[phas_P_htls;phas_C_htls;phas_MV_htls;phasMCC;phasMCCX]';
%%
freq1=sort(freq1,1,'descend');
damp1=sort(damp1,1,'descend');
ampl1=sort(ampl1,1,'descend');
phas1=sort(phas1,1,'descend');
%%

figure,plot(K,freq1),hold on,plot(K,freq1,'x'),hold on,plot(K,freq1,'o'),xlabel('Nr of iteration'),ylabel('Hz'),title('Estimation of frequency');
legend('pure signal','Cadzow','MV','MCC','MCCX')

figure,plot(K,damp1),hold on,plot(K,damp1,'x'),hold on,plot(K,damp1,'o'),xlabel('Nr of iteration'),ylabel('unit'),title('Estimation of damping');
legend('pure signal','Cadzow','MV','MCC','MCCX')

figure,plot(K,ampl1),hold on,plot(K,ampl1,'x'),hold on,plot(K,ampl1,'o'),xlabel('Nr of iteration'),ylabel('unit'),title('Estimation of amplitude');
legend('pure signal','Cadzow','MV','MCC','MCCX')

figure,plot(K,phas1),hold on,plot(K,phas1,'x'),hold on,plot(K,phas1,'o'),xlabel('Nr of iteration'),ylabel('rad'),title('Estimation of phase');
legend('pure signal','Cadzow','MV','MCC','MCCX')

%% PART 4: ATTENTION !! THIS PART IS OPTIONAL !! ATTENTION !! THIS PART IS OPTIONAL !!

%% If you solve this part, you can get maximum 2 extra points (minimum 0)

%% If your thesis's subject (PhD or Master) is related to signal decomposition, quantification, noise removal,
%% and you think this part might be helpful for your data set
%% you are strongly encouraged to talk to Prof. Sabine Van Huffel about solving this optional exercise
