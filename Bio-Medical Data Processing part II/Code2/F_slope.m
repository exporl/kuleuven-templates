function [Fitt,Alpha,Beta,Pxx,FrequencySpectrum,LogFreq,LogSpectrum]=F_slope(x,T,Fre_Thre1,Fre_Thre2)
%%
Tsampling=T*60*60;      % Samping period [sec]
Fsampling=1/Tsampling;  % Sampling frequency [Hz]
dF=Fsampling;           % Step in sampling frequeny [hz]

%%
Pxx = pwelch(x);                            % Power spectrum density (PSD) estimation
NrOfSamples=length(Pxx );                   % Number of samples
FrequencySpectrum=dF*(1:(NrOfSamples));     % Spectrum of PSD

%%
pos1=RetriveIndex(FrequencySpectrum,Fre_Thre1);  % Retrieve the position of the first threshold frequency
pos2=RetriveIndex(FrequencySpectrum,Fre_Thre2);  % Retrieve the position of the second threshold frequency

%%
FrequencySpectrum=FrequencySpectrum(pos1:pos2);             % Retrieve the frequencies fraction of our interest 
Pxx=Pxx(pos1:pos2);                                         % Retrieve the PSD fraction of our interest 
LogFreq=log10(FrequencySpectrum);                           % Log scale of the frequency ranges
LogSpectrum=log10(Pxx);                                     % Log scale of the PSD ranges
CovMatrix=cov(double(LogSpectrum),double(LogFreq));         % Computation of the coovariance matrix
Beta=CovMatrix(2,1)./CovMatrix(2,2);                        % Computation of Beta coefficient for the linear regression SLOPE
Alpha=mean(LogSpectrum)-Beta*mean(LogFreq);                 % Computation of Alpha coefficient for the linear regression Intersection
Fitt=Alpha+Beta*LogFreq;                                    % Fitted data values

end

%%
function  [pos1]=RetriveIndex(FrequencySpectrum,Fre_Thre1)
%%
for i=1:length(FrequencySpectrum)
    if(FrequencySpectrum(i)>Fre_Thre1)
        pos1=i;
        break;
    end
end
%%
end