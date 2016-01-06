function [X,XR]=WindowingFunction(x,n)

Nr=length(x);              % Length of the data 
DivisionResidue=rem(Nr,n); % Number of the windows needed
NrOfWindow=floor(Nr/n);    % The lenght of the window reserved for the residue

index=1;
for i=1:n:(NrOfWindow)*n;
    X(index,:)=x(i:n*index);                  % Creating the windows 
    index=index+1;
end
XR=x(length(x)-DivisionResidue+1:length(x))'; % Creating the residue window 

end