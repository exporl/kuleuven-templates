function  [Yn]=LinearLeastSquareOfWindow(X,XR,n)

num=var(1:n);
DivisionResidue=length(XR);
[dim1,dim2]=size(X);
for i=1:dim1
    CovMatrix=cov(X(i,:),1:n);
    Beta(i)=CovMatrix(2,1)./CovMatrix(2,2);
    alpha(i)=mean(X(i,:))-Beta(i)*mean(1:n);
    LeastSquareValues(i,:)=alpha(i)*ones(1,n)+Beta(i)*(1:n);
end

if DivisionResidue~=0;
    CMR=cov(XR,1:DivisionResidue);
    if CMR~=0
        BetaR=CMR(2,1)./CMR(2,2);
        alphaR=mean(XR)-BetaR*mean(1:DivisionResidue);
        LeastSquareValuesResidue=alphaR*ones(1,DivisionResidue)+BetaR*(1:DivisionResidue);
    else
        LeastSquareValuesResidue=XR;
    end
    [di1,di2]=size(LeastSquareValues);
    FittedValues=reshape(LeastSquareValues',1,di1*di2);
    Yn=horzcat(FittedValues,LeastSquareValuesResidue);
else
    [di1,di2]=size(LeastSquareValues);
    FittedValues=reshape(LeastSquareValues',1,di1*di2);
    Yn=FittedValues;
end
end