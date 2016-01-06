function [SpectrumOfWatterSignal,SpectrumOfWatterFilterSignal,mrs_filt,mrs_water,SNR]=FilterSignal(MRS_single_signal,k,fsampl,t,ndp,frequency)
% Decompose
[freq,damp,ampl,phas]=hsvdU(MRS_single_signal,k,fsampl,t,ndp); % decomposition
% Listing the number of components
freq_ppm=freq*10^6/frequency+4.7;
idxfilt=find(freq_ppm<4.6); % select frequencies lower than 4.6ppm
%
freqfilt=freq(idxfilt);
dampfilt=damp(idxfilt);
amplfilt=ampl(idxfilt);
phasfilt=phas(idxfilt);
%%
mrs_filt=reconsd(t,freqfilt,dampfilt,amplfilt,phasfilt);
mrs_water=MRS_single_signal- mrs_filt;
SpectrumOfWatterFilterSignal=fftshift(fft(mrs_filt));
SpectrumOfWatterSignal=fftshift(fft(mrs_water));
SNR=10*log(sum(real(mrs_filt)).^2/sum(real(mrs_water)).^2);
end