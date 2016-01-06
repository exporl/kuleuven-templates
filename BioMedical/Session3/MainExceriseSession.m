clear all
close all
clc
%% 1
load Q1
rankC2=rankest(C2);
rankC4=rankest(C4);
CPD_C2=cpd(C2,rankC2);
CPD_C4=cpd(C2,rankC4);

%% 2


A1=[1 -2;-2 1];
A2=[1 -1.1;-1.1 1];
A1=1/sqrt(5)*A1;
A2=1/sqrt(5)*A2;

CondA1=cond(A1);
CondA2=cond(A2);

SNR=5:5:40;
for i=1:length(SNR)
    x(i,:,:)=rand(2,500);
    x1(:,:)=x(i,:,:);
    
    S1=A1*x1;
    S2=A2*x1;
    
    [Y1(i,:,:),N] = noisy(S1,SNR(i));
    [Y2(i,:,:),N] = noisy(S2,SNR(i));
    
    M1(:,:)=Y1(i,:,:);
    M2(:,:)=Y2(i,:,:);
    
    [A1_h(i,:,:),~]=aci(M1);
    [A2_h(i,:,:),~]=aci(M2);
    
    A1_hat(:,:)=A1_h(i,:,:);
    A2_hat(:,:)=A2_h(i,:,:);
    
    x1_est=pinv(A1_hat)*M1;
    x2_est=pinv(A2_hat)*M2;
    
    [F1(i),~,~]=sir(A1,A1_hat);
    [F2(i),~,~]=sir(A2,A2_hat);

end
figure 
plot(SNR,F1,'x')
hold on
plot(SNR,F1,'o')
hold on
plot(SNR,F1,'r')
xlabel('SNR trial'),ylabel('SIR')
a=sprintf('SIR for the first mixing matrix cond=%d',CondA1);
title(a)
figure 
plot(SNR,F2,'x')
hold on
plot(SNR,F2,'o')
hold on
plot(SNR,F2,'r')
xlabel('SNR trial'),ylabel('SIR')
a=sprintf('SIR for the second mixing matrix cond=%d',CondA2);
title(a)
%% 3
close all
clear all
clc

load FECG.mat
[A,~]=aci(S);
S_est=pinv(A)*S;
PlotEEG(S_est,t)
figure
PlotEEG(S,t)
%% 4
close all
clear all
clc

load SynCP





