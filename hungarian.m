function [nrows_matrix] = hungarian(xyzi)
%xyzi is the cell which saves the position information of each frame,
%nrows_matrix gives the relationship of points in the last frame of xyzi with
%previous frames
%   hungarian algorithem

%threshold
c_corr=0.1;
%input number of frames
N=length(xyzi);

%calculate cost matrix
nrows_matrix=zeros(size(xyzi{N},1),N-1);

for i=1:(N-1)
    r=size(xyzi{N},1);%number of points in new frame
    c=size(xyzi{i},1);%number of points in old frame
    
    %calculate cost matrix
    C=zeros(r,c);
    for m=1:r
        for n=1:c
            A=(xyzi{N}(m,1:2)-xyzi{i}(n,1:2)).^2;
            C(m,n)=sqrt(sum(A));       
        end
    end
    
    %find the min number of each row and its index
    [min_c,index]=min(C.');
    p=find(min_c>c_corr);
    Q=zeros(size(index));
    Q(p)=-1;
    
    nrows_matrix(1:length(index),i)=Q.';
end
end

