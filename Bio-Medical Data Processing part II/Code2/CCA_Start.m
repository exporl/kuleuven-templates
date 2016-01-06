function [Y2,W2,R2]=CCA_Start(EEG2,k)
%%
[Y2,W2,R2] = ccaqr(EEG2);           % Aplication of the CCA
y2=W2'*Y2;                        % Recovery of the CCA signal based on regression weights
%%  
figure
eegplot_orig(y2)
b=sprintf('Sources after CCA of EEG%d',k);
title(b)
%%
figure
eegplot_orig(Y2)
b=sprintf('Sources after autocorrelation CCA of EEG%d',k);
title(b)
%%
figure
plot(R2),hold on,plot(R2,'>')
xlabel('Component'),ylabel('Correlation coefficent')
a=sprintf('Correlation coefficient for each component of EEG%d',k);
title(a)
end