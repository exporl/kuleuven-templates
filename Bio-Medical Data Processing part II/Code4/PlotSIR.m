function PlotSIR(SNR,F1)
figure 
plot(SNR,F1,'x')
hold on
plot(SNR,F1,'o')
hold on
plot(SNR,F1,'r')
xlabel('SNR trial'),ylabel('SIR')
end