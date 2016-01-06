function [F,Yn,x]=DFA(x,threshold1,threshold2)
x=IntegrateRR(x); % Step1 Random walk accross the data
index=1;
for n=threshold1:threshold2
    [X,XR]=WindowingFunction(x,n);              % Step2 Boxing the data consistently to the defined width
    [Yn]=LinearLeastSquareOfWindow(X,XR,n);     % Step2 Fitting a linear regression line inside the data
    F(index)=sqrt(1/length(x))*sum((x'-Yn).^2); % Step3 Detrend the integrated time series in each window
    index=index+1;
end
end