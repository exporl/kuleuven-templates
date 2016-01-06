function PlotRRE(RRE)
figure
plot(RRE,'x')
hold on
plot(RRE,'o')
hold on
plot(RRE,'r')
xlabel('Solutions trials')
ylabel('Error value in uV')
end
