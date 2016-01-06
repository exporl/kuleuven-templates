function [y,w,r] = ccaqr(X)
% CCABSS -  Blind Source Separation by Canonical Correlation Analysis
%
% INPUT
% X = input data
%
% OUTPUT
% y = source signals
% w = de-mixing matrix
% r = source signals authocoration value
%
%
% Y = CCABSS(X) is the BSS of X=A*S where S is a set of unknown source signals
% and A is an unknown mixing matrix. The components in S are supposed to
% be independent. Y is an estimate of S appart from permutation and scaling.
% For mixed 1-D signals, X is 2-D. The first index refer to the different
% components and the second index refers to the signal parameter (e.g. time)
% For mixed images, X is 3-D where the first index refers to the different 
% mixed images and the second and third indeces are the spatial coordinates.
%
% [Y W] = CCABSS(X) also gives the 'de-mixing' matrix W, such that Y = W'*X.
%
%
%
%
% © 2000 Magnus Borga

A = X(:,1:end-1);
B=X(:,2:end);

 
[w, y, r] = cc(A,B); % CCA
%y = wa'*X;

% ------------
% --- CCA ----
% ------------

function [w, y, r] = cc(X,Y)

% --- Calculate covariance matrices ---

[Q_x,R_x]=qr(X',0);
[Q_yt1,R_yt1]=qr(Y',0);
[U_fin1, S_fin1, V_fin1] = svd(Q_x'*Q_yt1,'econ');
if size(S_fin1,1)==1%size(S_fin1,2)
    r=S_fin1;
    
else
    r=diag(S_fin1);
    
end
y=(Q_x*U_fin1)';
w=pinv(R_x)*U_fin1;