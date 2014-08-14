function sp = conv2_periodic(s,c)
% 2D convolution for periodic boundary conditions
% output of convolution is same size as leading input matrix
[NN,M] = size(s);
[n,m] = size(c); % both m and n should be odd
%  enlarge matrix s in preparation convolution with matrix c via periodic
%  edges
padn = round(n/2)-1;
padm = round(m/2)-1;
sp = [zeros(padn,M+(2*padm));...
    zeros(NN,padm) s zeros(NN,padm); zeros(padn,M+(2*padm))];
% fill in zero padding with the periodic alues
sp(1:padn,padm+1:padm + M) = s(NN+1-padn:NN,:);
sp(padn+1+NN:2*padn+NN,padm+1:padm+M) = s(1:padn,:);
sp(padn+1:padn+NN,1:padm) = s(:,M+1-padm:M);
sp(padm+1:padn+NN,padm+M+1:2*padm+M) = s(:,1:padm);
sp(1:padn,1:padm) = s(NN+1-padn:NN,M+1-padm:M);
sp(padn+NN+1:2*padn+NN,1:padm) = s(1:padn,M+1-padm:M);
sp(1:padn,padm+M+1:2*padm+M) = s(NN+1-padn:NN,1:padm);
sp(padn+NN+1:2*padn+NN,padm+M+1:2*padm+M) = s(1:padn,1:padm);
%  perform 2D convolution
sp = conv2(sp,c,'same');
%  reduce the matrix back to its original size
sp = sp(padn+1:padn+NN,padm+1:padm+M);

