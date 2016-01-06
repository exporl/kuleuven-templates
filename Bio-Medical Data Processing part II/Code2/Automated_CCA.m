function Automated_CCA(Y,R,W,~,k)

y=W'*Y;                                      % Reconstruct the signals from the CCA
[NumberOfChannels,LenghtOfTheSignal]=size(y);   % Extract the number of channels and the length of each signal
iterations=1;                                   % iteration index
for i=NumberOfChannels:-1:1
    if(R(length(R))<.75)
        R(length(R))=[];                        % Removal of the last correlation coefficient with the lowest value
        %%
        % Here is the secion of ploting the result
        figure
        plot(R),hold on,plot(R,'>')
        xlabel('Component'),ylabel('Correlation coefficent')
        b=sprintf('Component remain after %d iteration',iterations);
        title(b);
        %%
        Y(i,:)=[];                           % Removal of the last component corresponding to the lowest correlation coefficient
        W(i,:)=[];                              % Removal of the last linear coefficent corresponding to the lowest correlation coefficient
        y=W'*Y;                              % Reconstruction of the EEG signal without the last component which was removed
        %%
        % Here is the secion of ploting the result after removal of the
        % last componet
        figure
        eegplot_orig(y)
        a=sprintf('Automated CCA EEG%d after %d iteration',k,iterations);
        title(a)
    end
    iterations=iterations+1;
end
end