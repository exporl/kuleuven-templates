clear all
close all
clc

%%
load ECGdata

x1=Control1;
x2=Control2;
x3=Control3;
x4=Control4;
x5=Control5;

t1=linspace(0,6*60*60,length(x1));
t2=linspace(0,6*60*60,length(x2));
t3=linspace(0,6*60*60,length(x3));
t4=linspace(0,6*60*60,length(x4));
t5=linspace(0,6*60*60,length(x5));

Poincare(x1)
xlabel('RR_n'),ylabel('RR_n+1'),title('Control1')

Poincare(x2)
xlabel('RR_n'),ylabel('RR_n+1'),title('Control2')

Poincare(x3)
xlabel('RR_n'),ylabel('RR_n+1'),title('Control3')

Poincare(x4)
xlabel('RR_n'),ylabel('RR_n+1'),title('Control4')

Poincare(x5)
xlabel('RR_n'),ylabel('RR_n+1'),title('Control5')

figure,
plot(t1,x1)
xlabel('Time [Sec]'),ylabel('Heart beat (A.u)')
title('Control1')
figure,
plot(t2,x2)
xlabel('Time [Sec]'),ylabel('Heart beat (A.u)')
title('Control2')
figure,
plot(t3,x3)
xlabel('Time [Sec]'),ylabel('Heart beat (A.u)')
title('Control3')
figure,
plot(t4,x4)
xlabel('Time [Sec]'),ylabel('Heart beat (A.u)')
title('Control4')
figure,
plot(t5,x5)
xlabel('Time [Sec]'),ylabel('Heart beat (A.u)')
title('Control5')



y1=West1;
y2=West2;
y3=West3;
y4=West4;
y5=West5;

t11=linspace(0,6*60*60,length(y1));
t21=linspace(0,6*60*60,length(y2));
t31=linspace(0,6*60*60,length(y3));
t41=linspace(0,6*60*60,length(y4));
t51=linspace(0,6*60*60,length(y5));

Poincare(y1)
xlabel('RR_n'),ylabel('RR_n+1'),title('West1')

Poincare(y2)
xlabel('RR_n'),ylabel('RR_n+1'),title('West2')

Poincare(y3)
xlabel('RR_n'),ylabel('RR_n+1'),title('West3')

Poincare(y4)
xlabel('RR_n'),ylabel('RR_n+1'),title('West4')

Poincare(y5)
xlabel('RR_n'),ylabel('RR_n+1'),title('West5')

figure,
plot(t11,y1)
xlabel('Time [Sec]'),ylabel('Heart beat (A.u)')
title('West1')
figure,
plot(t21,y2)
xlabel('Time [Sec]'),ylabel('Heart beat (A.u)')
title('West2')
figure,
plot(t31,y3)
xlabel('Time [Sec]'),ylabel('Heart beat (A.u)')
title('West3')
figure,
plot(t41,y4)
xlabel('Time [Sec]'),ylabel('Heart beat (A.u)')
title('West4')
figure,
plot(t51,y5)
xlabel('Time [Sec]'),ylabel('Heart beat (A.u)')
title('West5')


clear Control1,clear Control2,clear Control3,clear Control4,clear Control5
clear West1,clear West2,clear West3,clear West4,clear West5
clear t1,clear t2,clear t3,clear t4,clear t5
clear t11,clear t21,clear t31,clear t41,clear t51

% [FD1,SampEnResults1,LE1]=nonlin_measures(x1);
% [FD2,SampEnResults2,LE2]=nonlin_measures(x2);
% [FD3,SampEnResults3,LE3]=nonlin_measures(x3);
% [FD4,SampEnResults4,LE4]=nonlin_measures(x4);
% [FD5,SampEnResults5,LE5]=nonlin_measures(x5);
% 
% [FD1_1,SampEnResults1_1,LE1_1]=nonlin_measures(y1);
% [FD2_1,SampEnResults2_1,LE2_1]=nonlin_measures(y2);
% [FD3_1,SampEnResults3_1,LE3_1]=nonlin_measures(y3);
% [FD4_1,SampEnResults4_1,LE4_1]=nonlin_measures(y4);
% [FD5_1,SampEnResults5_1,LE5_1]=nonlin_measures(y5);

%%
% F_slope

T=6;                         % Duration in hours of the signal [Hours]
Fre_Thre1=10^(-4);           % First threshold frequency
Fre_Thre2=10^(-2);           % First threshold frequency


[Fitt1,Alpha1,Beta1,Pxx1,FrequencySpectrum1,LogFreq1,LogSpectrum1]=F_slope(x1,T,Fre_Thre1,Fre_Thre2);
[Fitt2,Alpha2,Beta2,Pxx2,FrequencySpectrum2,LogFreq2,LogSpectrum2]=F_slope(x2,T,Fre_Thre1,Fre_Thre2);
[Fitt3,Alpha3,Beta3,Pxx3,FrequencySpectrum3,LogFreq3,LogSpectrum3]=F_slope(x3,T,Fre_Thre1,Fre_Thre2);
[Fitt4,Alpha4,Beta4,Pxx4,FrequencySpectrum4,LogFreq4,LogSpectrum4]=F_slope(x4,T,Fre_Thre1,Fre_Thre2);
[Fitt5,Alpha5,Beta5,Pxx5,FrequencySpectrum5,LogFreq5,LogSpectrum5]=F_slope(x5,T,Fre_Thre1,Fre_Thre2);


[Fitt11,Alpha11,Beta11,Pxx11,FrequencySpectrum11,LogFreq11,LogSpectrum11]=F_slope(y1,T,Fre_Thre1,Fre_Thre2);
[Fitt22,Alpha22,Beta22,Pxx22,FrequencySpectrum22,LogFreq22,LogSpectrum22]=F_slope(y2,T,Fre_Thre1,Fre_Thre2);
[Fitt33,Alpha33,Beta33,Pxx33,FrequencySpectrum33,LogFreq33,LogSpectrum33]=F_slope(y3,T,Fre_Thre1,Fre_Thre2);
[Fitt44,Alpha44,Beta44,Pxx44,FrequencySpectrum44,LogFreq44,LogSpectrum44]=F_slope(y4,T,Fre_Thre1,Fre_Thre2);
[Fitt55,Alpha55,Beta55,Pxx55,FrequencySpectrum55,LogFreq55,LogSpectrum55]=F_slope(y5,T,Fre_Thre1,Fre_Thre2);

%%
figure
plot(LogFreq1,LogSpectrum1)
hold on
plot(LogFreq1,Fitt1,'r')
title('Power Spectrumd Density and the F fitted slot Control1')
xlabel('Frequency in Hz'),ylabel('Spectrum value')
legend('PSD real value','F slope')

figure
plot(LogFreq2,LogSpectrum2)
hold on
plot(LogFreq2,Fitt2,'r')
title('Power Spectrumd Density and the F fitted slot Control2')
xlabel('Frequency in Hz'),ylabel('Spectrum value')
legend('PSD real value','F slope')

figure
plot(LogFreq3,LogSpectrum3)
hold on
plot(LogFreq3,Fitt3,'r')
title('Power Spectrumd Density and the F fitted slot Control3')
xlabel('Frequency in Hz'),ylabel('Spectrum value')
legend('PSD real value','F slope')

figure
plot(LogFreq4,LogSpectrum4)
hold on
plot(LogFreq4,Fitt4,'r')
title('Power Spectrumd Density and the F fitted slot Control4')
xlabel('Frequency in Hz'),ylabel('Spectrum value')
legend('PSD real value','F slope')

figure
plot(LogFreq5,LogSpectrum5)
hold on
plot(LogFreq5,Fitt5,'r')
title('Power Spectrumd Density and the F fitted slot Control5')
xlabel('Frequency in Hz'),ylabel('Spectrum value')
legend('PSD real value','F slope')
%%
figure
plot(LogFreq11,LogSpectrum11)
hold on
plot(LogFreq11,Fitt11,'r')
title('Power Spectrumd Density and the F fitted slot West1')
xlabel('Frequency in Hz'),ylabel('Spectrum value')
legend('PSD real value','F slope')

figure
plot(LogFreq22,LogSpectrum22)
hold on
plot(LogFreq22,Fitt22,'r')
title('Power Spectrumd Density and the F fitted slot West2')
xlabel('Frequency in Hz'),ylabel('Spectrum value')
legend('PSD real value','F slope')

figure
plot(LogFreq33,LogSpectrum33)
hold on
plot(LogFreq33,Fitt33,'r')
title('Power Spectrumd Density and the F fitted slot West3')
xlabel('Frequency in Hz'),ylabel('Spectrum value')
legend('PSD real value','F slope')

figure
plot(LogFreq44,LogSpectrum44)
hold on
plot(LogFreq44,Fitt44,'r')
title('Power Spectrumd Density and the F fitted slot West4')
xlabel('Frequency in Hz'),ylabel('Spectrum value')
legend('PSD real value','F slope')

figure
plot(LogFreq55,LogSpectrum55)
hold on
plot(LogFreq55,Fitt55,'r')
title('Power Spectrumd Density and the F fitted slot West5')
xlabel('Frequency in Hz'),ylabel('Spectrum value')
legend('PSD real value','F slope')



%%
% DFA

threshold1=2;
threshold2=160;
[F1,Yn1,RW1]=DFA(x1,threshold1,threshold2);
[F2,Yn2,RW2]=DFA(x2,threshold1,threshold2);
[F3,Yn3,RW3]=DFA(x3,threshold1,threshold2);
[F4,Yn4,RW4]=DFA(x4,threshold1,threshold2);
[F5,Yn5,RW5]=DFA(x5,threshold1,threshold2);


[F11,Yn11,RW11]=DFA(y1,threshold1,threshold2);
[F22,Yn22,RW22]=DFA(y2,threshold1,threshold2);
[F33,Yn33,RW33]=DFA(y3,threshold1,threshold2);
[F44,Yn44,RW44]=DFA(y4,threshold1,threshold2);
[F55,Yn55,RW55]=DFA(y5,threshold1,threshold2);

%%
X=threshold1:threshold2;
[A1,B1]=FindSlope(X,F1);
[A2,B2]=FindSlope(X,F2);
[A3,B3]=FindSlope(X,F3);
[A4,B4]=FindSlope(X,F4);
[A5,B5]=FindSlope(X,F5);


[A11,B11]=FindSlope(X,F11);
[A22,B22]=FindSlope(X,F22);
[A33,B33]=FindSlope(X,F33);
[A44,B44]=FindSlope(X,F44);
[A55,B55]=FindSlope(X,F55);

A=[A1,A2,A3,A4,A5;A11,A22,A33,A44,A55];
B=[B1,B2,B3,B4,B5;B11,B22,B33,B44,B55];
%%
F=[F1;F2;F3;F4;F5];
F_1=[F11;F22;F33;F44;F55];

%%
%step4
figure
plot(log(threshold1:threshold2),log(F))
xlabel('Window size'),ylabel('RMS Fluctuation')
legend('Control1','Control2','Control3','Control4','Control5')
%%
%step4
figure
plot(log(threshold1:threshold2),log(F_1))
xlabel('Window size'),ylabel('RMS Fluctuation')
legend('West1','West2','West3','West4','West5')
%%
figure
plot(RW1)
hold on
plot(Yn1,'r')
xlabel('Distance walk'),ylabel('Cumulative value'),title('Control1')
legend('Random walk over the HR','DFA window width 160')
figure
plot(RW2)
hold on
plot(Yn2,'r')
xlabel('Distance walk'),ylabel('Cumulative value'),title('Control2')
legend('Random walk over the HR','DFA window width 160')
figure
plot(RW3)
hold on
plot(Yn3,'r')
xlabel('Distance walk'),ylabel('Cumulative value'),title('Control3')
legend('Random walk over the HR','DFA window width 160')
figure
plot(RW4)
hold on
plot(Yn4,'r')
xlabel('Distance walk'),ylabel('Cumulative value'),title('Control4')
legend('Random walk over the HR','DFA window width 160')
figure
plot(RW5)
hold on
plot(Yn5,'r')
xlabel('Distance walk'),ylabel('Cumulative value'),title('Control5'), xlim([12 12+3*160]),
legend('Random walk over the HR','DFA window width 160')
%%
%%
figure
plot(RW11)
hold on
plot(Yn11,'r')
xlabel('Distance walk'),ylabel('Cumulative value'),title('West1')
legend('Random walk over the HR','DFA window width 160')
figure
plot(RW23)
hold on
plot(Yn22,'r')
xlabel('Distance walk'),ylabel('Cumulative value'),title('West2')
legend('Random walk over the HR','DFA window width 160')
figure
plot(RW33)
hold on
plot(Yn33,'r')
xlabel('Distance walk'),ylabel('Cumulative value'),title('West3')
legend('Random walk over the HR','DFA window width 160')
figure
plot(RW44)
hold on
plot(Yn44,'r')
xlabel('Distance walk'),ylabel('Cumulative value'),title('West4')
legend('Random walk over the HR','DFA window width 160')
figure
plot(RW55)
hold on
plot(Yn55,'r')
xlabel('Distance walk'),ylabel('Cumulative value'),title('West5')
legend('Random walk over the HR','DFA window width 160')
%%

