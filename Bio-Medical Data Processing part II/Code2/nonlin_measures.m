function [FD,SampEnResults,LE]=nonlin_measures(RR)
% Input:    RR      RR intervals
% Output:   FD      Fractal Dimension using boxcounting method
%           LE      Lyapunov Exponent

fs = 2;
time = cumsum(RR/1000);
[time_resamp,RR_resamp] = resamp(time,RR,fs);

%% Fractal Dimension
FD = boxcount([time_resamp',RR_resamp'],7,0);

%% Sample Entropy
SampEnResults = sampenc(RR,2,0.2*std(RR));
% Derive Sample Entropy from SampEnResults
%% Lyapunov Exponent
LE = LyapunovExponent(time_resamp',RR_resamp');
if isempty(LE)
    LE = Inf;
end

%% Correlation Dimension
% Note: Check the matlab compiler of your computer. You will need one to be
% able to execute this section
%mex interpoint.c
% [m,dcm,eps0,cim,bins]=judd(RR,2:30,1);
%Derive Correlation Dimension (m=8) from the outputs given above
