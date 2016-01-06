function [A,B]=FindSlope(X,Y)
Y=log(Y);
X=(X);
A=(Y(length(Y))-Y(length(Y)-1))/(X(length(X))-X(length(X)-1));
B=(Y(2)-Y(1))/(X(2)-X(1));
end