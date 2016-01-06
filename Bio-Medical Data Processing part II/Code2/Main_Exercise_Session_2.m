
clear all
close all
clc

%% Part I: Decompose using HSVD & filter water @ 4.7ppm
load EEG_muscleArtifact
%%
figure
eegplot_orig(EEG1)
title('EEG1')
figure
eegplot_orig(EEG2)
title('EEG2')
%%
[Y1,W1,R1]=CCA_Start(EEG1,1);
[Y2,W2,R2]=CCA_Start(EEG2,2);
%%
% Manual_CCA(Y1,R1,W1,EEG1,1)
% Manual_CCA(Y2,R2,W2,EEG2,2)
%%
Automated_CCA(Y1,R1,W1,EEG1,1)
Automated_CCA(Y2,R2,W2,EEG2,2)
%%



