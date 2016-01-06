function [RRE,V_in]=CalculateRRE(Results,V_EEG,hm)
[dim1,dim2]=size(Results);               % Extract the dimensions of the results, number of dipoles dim1 and data length dim2
for i=1:dim1
    for j=1:3
        source.loc(j)=Results(i,j);      % Input the location of the source from the first 3 data values
        source.ori(j)=Results(i,j+3);    % Input the orientation of the source from the last 3 data values
    end
    [V, ~]=solve_forward(hm,source);     % Calculate the forward problem meaning the computation of the voltage
    V_in(i,:)=V;                         % Store this values
    RRE(i)=sum((V-V_EEG).^2)./sum(V.^2); % Compute the RRE value for respective computation
end
end