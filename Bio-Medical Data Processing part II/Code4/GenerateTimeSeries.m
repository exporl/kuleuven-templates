function [RotateFreqRadReplecated,TimeArray]=GenerateTimeSeries(f,RotateFreq,Duration)
% f=200;
T=1/f;                                % Comput the period of sampling from the sampling frequency
TimeArray=0:T:Duration;               % Time array of the sampling       
TimeArray(length(TimeArray))=[];      % Removing the last sample in time since we start from 0 sec
DataPoints=length(TimeArray);         % Compute the size of the data points in time domain
%%
T_Retota=1/RotateFreq;                % Compute the rotation period in sec
RotateAngle=0:T_Retota:Duration;      % Compute the array of the rotation in sec
RotateAngle(length(RotateAngle))=[];  % Removing the last sample in time since we start from 0 sec
RotatePoints=length(RotateAngle);     % Compute the size of the data points of rotation
RotateFreqRad=RotateAngle*pi;         % Compute the array of rotation angle in rad
%%
A=length(RotateFreqRad);              % Length of the rotate angle array
B=length(TimeArray);                  % Length of the time array
A1=rem(B,A);                          % Division residue between this data
B1=round(B/A);                        % The scale of data size between this two data
%%
% In this loop the data size of the rotate angle has been replicated
% consistently to the data size of the time. Hereby it is ensured that for
% the certain time sample a consistent rotation angle sample is ensured.
% Since the dsampling freq is at a certain scale compare to the rotation
% freq of the dipole. The number of sample repetition is expected to be at
% the same scale
index=1;                                
for i=1:length(RotateFreqRad)
    for j=1:B1
        RotateFreqRadReplecated(index)=RotateFreqRad(i);
        index=index+1;
    end  
end
for i=1:A1;
    RotateFreqRadReplecated(length(RotateFreqRadReplecated))=[];
end
%%

end