function [y]=IntegrateRR(x)
%%
for i=1:length(x)
    y(i)=sum(x(1:i)-mean(x));
end
%%
y=y';
end