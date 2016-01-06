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

function [yOutc]=Multi_Channel_Cadzow(MultipleLine, fKest, ndp)
[x,y]=size(MultipleLine);
M=ndp/2;
N=length(MultipleLine(1,:));
L=N+1-M;
colhmat=MultipleLine(1,1:L);
rowhmat=MultipleLine(1,L:N);
C=hankel(colhmat(:),rowhmat(:));

for i=2:x
    %     M=ndp/2;
    %     N=length(MultipleLine(i,:));
    %     L=N+1-M;
    colhmat=MultipleLine(i,1:L);
    rowhmat=MultipleLine(i,L:N);
    hmat(:,:)=hankel(colhmat(:),rowhmat(:));
    C = horzcat(C,hmat);
end
[u,s,v]=svd(C,0);

%-----------------------------truncation-----------------------------------
u1=u(:,1:fKest);
s1=s(1:fKest,1:fKest);
v1=v(:,1:fKest);

%-----------------forms intermediate matrix of rank fKest------------------
mat=u1*s1*v1';
%--------------------restores the Hankel structure-------------------------
hvec1=avgHankel(mat);

% need to extract data from matrix Tr
for k=1:x
    for l=1:1024
        hvec(:,l)=hvec1(:,l+(k-1)*1024);
    end
    yOut(k,:) = conj([hvec(:,1); hvec(size(hvec,1),2:size(hvec,2)).']);
    yOutc(k,:)=real(yOut(k,:))-j*imag(yOut(k,:));
end
end
