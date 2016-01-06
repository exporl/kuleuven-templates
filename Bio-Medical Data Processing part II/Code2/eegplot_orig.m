function eegplot_orig(S,meas,sens,linestyle,halfpage)
%EEGPLOT    plots a multi-channel data set
%   eegplot(S,meas,sens,linestyle,halfpage)
%   S is a matrix with m rows (channels) and n coloms (timesamples)
%   meas is the montage used (optional)
%   sens is the y-axes scale (optional)
%   linestyle (optional)
%   halfpage is 1 if you plot the second half of a page and the first half
%   of the next page, 0 if you just plot a whole page (default) (optional)
if nargin<3, mode = 'raw'; elseif isempty(meas), mode = 'raw'; else mode = 'montage'; end

if nargin<4, linestyle='k'; end
if nargin<5, halfpage=0; end
fs = 250; % sample rate

[r c] = size(S);


% if strcmp(mode,'montage')
% 
%   S = S(meas.mont(:,1),:);%-S(meas.mont(:,2),:);
% 
%   chanlabels=[];
%   nofchan = size(meas.mont,1);
%   for i=1:nofchan
%     chanlabels{i} = [char(meas.el.lbl(meas.mont(i,1),:))];% '-' char(meas.el.lbl(meas.mont(i,2),:))];
%   end
  
%elseif strcmp(mode,'raw')

  chanlabels=[];
  nofchan = r;
  for i=1:nofchan
    chanlabels{i} = num2str(i);
  end

%end
%figure
chanlabels = chanlabels';
S=flipud(S);

[r c]=size(S);
if nargin<3 || isempty(sens)
  m = max(max(abs(S)));
else 
  sens=sens-19.9;  
  m = sens*2048/2000;
end
plot([0,c/fs],[1 1],'w:')%zet stippelijn per kanaal
% hold on
set(gca,'nextplot','add');
for i=1:r
  S(i,:)=S(i,:)/m + i;
  plot([0,c/fs],[i i],'w:');%zet stippelijn per kanaal
end

% plot((1:c)/fs,S',linestyle,'linewidth',[1],'color','k');
% set(gca,'xlim',[0 c/fs],'xcolor',[0.5,0.5,0.5]);
% a=c/fs/10;
% set(gca,'xtick',[0:a:10*a],'XTickLabel','')
% set(gca,'ylim',[0 r+1],'YTickLabel','');

plot((1:c),S',linestyle,'linewidth',[1],'color',linestyle);
set(gca,'xlim',[0 c],'xcolor',[0.5,0.5,0.5]);
a=c/10;
ticks=[0:a:10*a];
for i=1:numel([0:a:10*a])
    labels{i}=num2str(ticks(i)/250);
end
set(gca,'xtick',[0:a:10*a],'XTickLabel',labels);
set(gca,'ylim',[0 r+1],'YTickLabel','');


%set(gca,'ytick',1:nofchan);
%set(gca,'yticklabel',flipud(chanlabels),'ycolor',[0.5,0.5,0.5],'fontsize',10);
%xlabel('Time (sec)')
set(gca,'XGrid','on','GridLineStyle','-')
if nargin<5
  sensstring=num2str(round(m*2000/2048));
else
  sensstring=num2str(sens);
end

%text(0,r+0.5,[sensstring ' uV'])

if halfpage
    hold on
    line('XData',[5*250 5*250],'YData',[0 100],'Color','blue')
end
hold off
