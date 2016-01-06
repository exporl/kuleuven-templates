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
    
    [U1,Sing1,V1]=svd(M1,'econ');
    [U2,Sing2,V2]=svd(M2,'econ');
    
   
    
    x1_est_PCA=V1(:,1:2)';
    x2_est_PCA=V2(:,1:2)';
    
    A1_h_PCA=M1*pinv(x1_est_PCA);
    A2_h_PCA=M2*pinv(x2_est_PCA);
        
    [F1_PCA(i),~,~]=sir(A1,A1_h_PCA);
    [F2_PCA(i),~,~]=sir(A2,A2_h_PCA);
    
    [A1_h(i,:,:),~]=aci(M1);
    [A2_h(i,:,:),~]=aci(M2);
    
    A1_hat(:,:)=A1_h(i,:,:);
    A2_hat(:,:)=A2_h(i,:,:);
    
    x1_est=pinv(A1_hat)*M1;
    x2_est=pinv(A2_hat)*M2;
    
    [F1(i),~,~]=sir(A1,A1_hat);
    [F2(i),~,~]=sir(A2,A2_hat);

end

PlotSIR(SNR,F1)
a=sprintf('SIR for the first mixing matrix cond=%d',CondA1);
title(a)

PlotSIR(SNR,F2)
a=sprintf('SIR for the second mixing matrix cond=%d',CondA2);
title(a)

PlotSIR(SNR,F1_PCA)
a=sprintf('SIR via PCA for the first mixing matrix cond=%d',CondA1);
title(a)

PlotSIR(SNR,F2_PCA)
a=sprintf('SIR via PCA for the second mixing matrix cond=%d',CondA2);
title(a)
%% 3
close all
clear all
clc

load FECG.mat
[A,~]=aci(S);
S_est=pinv(A)*S;
PlotEEG(S_est,t)
xlabel('Time in sec'),ylabel('Channel data')
title('Channel data after ICA')
figure
PlotEEG(S,t)
xlabel('Time in sec'),ylabel('Channel data')
title('Channel data before ICA')
%% 4
close all
clear all
clc

load SynCP

T1=T(:,:,4);
a=rankest(T1);
[U, ~, V]=svd(T1);
U=U(:,1:3);
V=V(:,1:3);
[U1]=aci(T1);
[V1]=aci(T1');


T_Noisy=noisy(T,15);
[U,S,sv] = mlsvd(T_Noisy);
surf3(S)
voxel3(S)

figure
index=1;
for R=3:20;
    Uhat = cpd(T_Noisy,R);
    
    options.Initialization = @cpd_rnd;              % Select pseudorandom initialization.
    options.Algorithm = @cpd_nls;                   % Select NLS as the main algorithm multiple initialization avoid local minima.
    options.AlgorithmOptions.LineSearch = @cpd_nls; % Add exact line search.
    options.AlgorithmOptions.TolFun = 1e-20;        % Set algorithm stop criteria.
    options.AlgorithmOptions.TolX = 1e-20;
    

    [Uhat,output] = cpd(T,R,options);
    
    semilogy(0:output.Algorithm.iterations,sqrt(2*output.Algorithm.fval),'color',rand(1,3));
    xlabel('iteration');
    ylabel('frob(cpdres(T,U))');
    grid on;
    hold on
    title('Norm estimation over different interation repsectively to different rank trial')
    K=3:R;                                                          % Raw of different order of components
    legendCell=strcat('R=',strtrim(cellstr(num2str(K(:)))));        % Generation fo cells for the legend
    legend(legendCell)
    
    res = cpdres(T_Noisy,Uhat);
    relerr(index) = frob(cpdres(T_Noisy,Uhat))/frob(T_Noisy);
    index=index+1;
    %     relerr = cpderr(U,Uhat);
end
figure
plot(3:20,relerr)
xlabel('Rank trial'),ylabel('Relative error'),title('Relative erro of the estimations')

% RankOfNoisyTensor=rankest(T_Noisy);

%% 5
% Required software for this exercise:
% - EEGLAB: http://sccn.ucsd.edu/eeglab/downloadtoolbox.html
% - Wavelet Toolbox
clear all
close all
clc

% Load and inspect EEG measurements.
load demosignal3_963

FreqSampling=250; % Hz
T_sampling=1/FreqSampling;
t=0:max(size(demosignal3_963))-1;
t=T_sampling*t;
PlotEEG(demosignal3_963,t)
xlabel('Time in sec'), ylabel('Number of channels')

% Epileptic activity occurs around 52s.
% Normalise the measurements and wavelet transform them to a tensor.
[data_3D,m,s] = normalise_3D(demosignal3_963,51,53,make_scales(2,25));

for i=1:2
    rankC2=2;
    % Decompose the tensor in two rank one terms.
    U = cpd(data_3D,rankC2);
    A = U{1}; B = U{2}; C = U{3};
    
    % Look at the error of the fit in function of the number of rank one terms.
    % This can be done by manually testing each R or by using rankest(data_3D).
    
    % Topoplots.
    result = transform_back(A,s);
    
    % Frequency signatures.
    figure;
    plot(B);
    title('frequency signatures');
    
    % Temporal signatures.
    figure;
    plot(C);
    title('temporal signatures');
%     rankC2=rankest(data_3D);
end



