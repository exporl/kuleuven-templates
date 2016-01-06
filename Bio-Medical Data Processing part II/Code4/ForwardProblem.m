
clear all
close all
clc
%%
% 1
load headmodel19                % Load the head model
%%
% 2 Show electrode position
showelpos(hm)                   % Plot the location of the electrodes
%%
% 3
showdipole([0 0 0 0 0 1],hm)    % Show the dipole at the center orientation towards z 
showdipole([.05 0 0 0 0 1],hm)  % Show the dipole at the middle of center towards the right ear orientation towards z 
%%
% 4 dipole at the center orinted along x axis
source.loc=[0 0 0];             % Input a source at the center
source.ori=[1 0 0];             % Input the orientation towards x axis
[V,L]=solve_forward(hm,source); % Comput the voltage at the electrodes from this dipole with the forward solution
showpotentials(V,hm)            % Show the potential distribution in the electrodes
title('Electrod potential from dipole at the center oriented along x axis')
showdipole([0 0 0 1 0 0],hm)    % The dipole location and its orientation has been plot
%%
% 5 study the composition of L
showpotentials(L(:,1),hm)
title('First column')
showpotentials(L(:,2),hm)
title('Second column')
showpotentials(L(:,3),hm)
title('Third column')
%%
% 6 two potential at the center, where one along the x axis the other along
% the z axis
source1.loc=[0 0 0];                % Input a source at the center
source1.ori=[0 0 1];                % Input the orientation towards z axis

source2.loc=[0 0 0];                % Input a source at the center
source2.ori=[1 0 0];                % Input the orientation towards x axis

[V1,L1]=solve_forward(hm,source1);  % Comput the voltage at the electrodes from this dipole with the forward solution
[V2,L2]=solve_forward(hm,source2);  % Comput the voltage at the electrodes from this dipole with the forward solution
VT=V1+V2;                           % Superimpose the voltages since the Maxwel equation is a linear relatoin
showpotentials(VT,hm)               % Show the potential distribution in the electrodes

%%
% 7 Simulate EEG
sourceEEG.loc=[0 -0.05 0.02];       % Input a source at the the indicated location
sourceEEG.ori=[0 0 1];              % Input the orientation towards z axis
f=200;                              % Sampling frequency
RotateFreq=20;                      % Rotation frequency in time domain
Duration=3;                         % Duration of the EEG signal
[RotateFreqRadReplecated,TimeArray]=GenerateTimeSeries(f,RotateFreq,Duration); % Compute the array of the rotation angles 

for i=1:length(RotateFreqRadReplecated)
    Rotation=RotateDipole(sourceEEG.ori',RotateFreqRadReplecated(i),0,0);      % Rotation the dipole consistently to the rotation angles
    sourceEEG.ori=Rotation';                                                   % The new orientation updates the source orientation
    [EEG(i,:),LeadFieldMatrix]=solve_forward(hm,sourceEEG);                    % Compute the voltage done by this potential
end
%%
A=[sourceEEG.loc,sourceEEG.ori];                    
figure
showdipole(A,hm)
figure
% eegplot(EEG,f)
[dim1,dim2]=size(EEG);
t=linspace(0,3,dim1);
PlotEEG(EEG',t)

title('EEG signals at all the electrodes')
xlabel('Time od measurement in sec')
ylabel('Voltage at each electrode repsectively in uV')
%%
close all
%% 1
sourceEEG1.loc=[0.06 0 0.01];                 % Input a source at the the indicated location
sourceEEG1.ori=[1 0 0];                       % Input the orientation towards x axis
[V_EEG1,L_EEG1]=solve_forward(hm,sourceEEG1); % Compute the voltage done by this potential
result=solve_inverse_dipole_ana(V_EEG1,hm);   % Solve the inverse proble meaning the computation of the dipole parameters from the computed dipole
[RRE,V_in]=CalculateRRE(result,V_EEG1,hm);    % Calcuate the RRE error for each of the trials
%%  
PlotRRE(RRE)                                  % Plot the set of the RRE values
PlotPotemtialMap(V_in,hm)                     % Plot the potential at each electrode
%% 2
figure
PlotEEG(EEG',t)                                   % Plot the EEG signals
[x,y]=ginput(1);                                    % Get the data from the 
V_point=EEG(:,round(x*f));                          % Compute the potential from the point 
result_point=solve_inverse_dipole_ana(V_point,hm);  % Compute the dipole paramteres for this voltage read from the plots via the invers problem
%% 3
sourceEEG2.ori=[1 0 0];                             % Input the orientation towards x axis
sourceEEG2.loc=[0.06 0 0.01];                       % Input a source at the the indicated location

[VEEG2,LEEG2]=solve_forward(hm,sourceEEG2);         % Compute the voltage done by this potential
showpotentials(VEEG2,hm)                            % Show the computed voltages at each electrode
VEEG2Error=VEEG2;
VEEG2Error(13)=0;                                   % The P8 electrode is shut down to see the impact
showpotentials(VEEG2Error,hm)                       % Show the computed voltages at each electrode and the impact of the down electrode
VEEG2Error1=VEEG2;                                      
VEEG2Error1(3)=0;                                   % The third electrode is shut down to see the impact
showpotentials(VEEG2Error1,hm)                      % Show the computed voltages at each electrode and the impact of the down electrode


result_point_error=solve_inverse_dipole_ana(VEEG2Error,hm);          % The inverse proble is computed in the case when the p8 electrode is down
[RRE_error,V_in_error]=CalculateRRE(result_point_error,VEEG2,hm);    % The RRE error is computed for this estimation
result_point_error1=solve_inverse_dipole_ana(VEEG2Error1,hm);        % The inverse proble is computed in the case when the third electrode is down
[RRE_error1,V_in_error1]=CalculateRRE(result_point_error1,VEEG2,hm); % The RRE error is computed for this estimation
%%
PlotRRE(RRE_error)
title('Error estimation for the first model')
PlotPotemtialMap(V_in_error,hm)
PlotRRE(RRE_error1)
title('Error estimation for the second model')
PlotPotemtialMap(V_in_error1,hm)
PlotRRE(abs(RRE_error-RRE_error1))
title('Error difference between two model')
%%
hm.condskull=(1/80)*hm.condsoft;               % The conductivity of the skull is altered to see the impact
r= min(hm.radius);                             % The minimum radius is computed from the head modes
x=10;                                          % The total number of the random dipoles around the head is computed
[R,d]=GenerateDipole(x,r);                     % Ten random dipoles are generated
%%
for i=1:x
    for j=1:3
        sourceEEGS.loc(j)=R(i,j);                   % Location of the sources in inputed
        sourceEEGS.ori(j)=R(i,j+3);                 % Orientation of the sources in inputed
    end
    [VEEGS(i,:),~]=solve_forward(hm,sourceEEGS);    % Voltage at each electrode for this specific dipole is computed
    A=VEEGS(i,:)';                  
    B=solve_inverse_dipole_ana(A,hm);               % Dipole parameters for the computed volatage are computed 
    result_point_errorS(i,:)=B(:);
    [RRE_errorS,V_in_errorS]=CalculateRRE(B,A,hm);  % Dipole localization error is computed 
    PlotRRE(RRE_errorS)
    a=sprintf('Error estimation for from skull conductivity for the dipole %d',i);
    title(a);
    C(i,:)=RRE_errorS;
    D(i,:,:)=V_in_errorS;
end
mean(C)
%%
clear all
load headmodel19
r= min(hm.radius);
x=10;                                               % The total number of the random dipoles around the head is computed
[R,d]=GenerateDipole(x,r);                          % Ten random dipoles are generated
hm.elpos(1)=hm.elpos(1)+1;                          % The first electrode is displaced by 1 cm
for i=1:x
    for j=1:3
        sourceEEGS.loc(j)=R(i,j);                   % Location of the sources in inputed
        sourceEEGS.ori(j)=R(i,j+3);                 % Orientation of the sources in inputed
    end
    [VEEGS(i,:),~]=solve_forward(hm,sourceEEGS);    % Voltage at each electrode for this specific dipole is computed
    A=VEEGS(i,:)';
    B=solve_inverse_dipole_ana(A,hm);               % Dipole parameters for the computed volatage are computed
%     result_point_errorS(i,:)=B(:);
    [RRE_errorS,V_in_errorS]=CalculateRRE(B,A,hm);  % Dipole localization error is computed
    PlotRRE(RRE_errorS)
    a=sprintf('Error estimation for from skull conductivity for the dipole %d',i);
    title(a);
    C(i,:)=RRE_errorS;
    D(i,:,:)=V_in_errorS;
end



%%

