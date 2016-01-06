%**************************************************************************
%                              CADZOW.M
%**************************************************************************
% Purpose: Signal enhancement by means of the Cadzow iterations performed
%          on an L by M Hankel matrix
%**************************************************************************
% CALL:    hvec=cadzow(vcadzow, fKest, M);
%**************************************************************************
% INPUT:   vcadzow -- signal data vector for CADZOW
%          fKest   -- number of estimated damped exponentials (model order)
%          M       -- number of columns of hankel matrix
% OUTPUT:  hvec    -- enhanced signal data vector
%**************************************************************************
function yOutc=minimum_variance(vcadzow, fKest, ndp) 
M=ndp/2;
N=length(vcadzow);
L=N+1-M;
colhmat=vcadzow(1:L);
rowhmat=vcadzow(L:N);
hmat=hankel(colhmat(:),rowhmat(:));
[u,s,v]=svd(hmat,0);

%-----------------------------truncation-----------------------------------
u1=u(:,1:fKest);
s1=s(1:fKest,1:fKest);
v1=v(:,1:fKest);
%----------Smallest signular values
[x,y]=size(s);
% sigmaV=sum(sum(s(fKest+1:x,fKest+1:y)));
sigmaV=s(x,y);
for i=1:fKest
   s1(i,i)=s1(i,i)-sigmaV.^2/s1(i,i);
end
%-----------------forms intermediate matrix of rank fKest------------------
mat=u1*s1*v1';
%--------------------restores the Hankel structure-------------------------
hvec=avgHankel(mat);

% need to extract data from matrix Tr
yOut = conj([hvec(:,1); hvec(size(hvec,1),2:size(hvec,2)).']);
yOutc=real(yOut)-j*imag(yOut);

