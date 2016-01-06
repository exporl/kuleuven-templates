function PlotEEG(sig,t)
% t = linspace(0,2,1024);
% sig = rand(32,1024);
[dim1,dim2]=size(sig);
% calculate shift
mi = min(sig,[],2);
ma = max(sig,[],2);
shift = cumsum([0; abs(ma(1:end-1))+abs(mi(2:end))]);
shift = repmat(shift,1,dim2);

%plot 'eeg' data
plot(t,sig+shift)

% edit axes
set(gca,'ytick',mean(sig+shift,2),'yticklabel',1:dim1)
grid on
% ylim([mi(1) max(max(shift+sig))])

end