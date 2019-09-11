function [data_matrix] = heat_matrix(data)
%data is the input matrix of one frame
%processed data is the heat map of the frame
%   delete point that is not in our region of interest [0,4,-2,2]

%number of points in the frame
X=data(:,1);
Y=data(:,2);
intensity=data(:,3);

%delete points out of region of interest
p=find((0.0<=X)&(X<=4.0));
q=find((-2.0<=Y)&(Y<=2.0));
%x:0-4m y:-2-2m
c=intersect(p,q);
A=zeros(length(c),3);
%calculate row number of heat matrix
A(:,1)=ceil((Y(c)+2)/0.1);
%calculate col number of heat matrix
A(:,2)=ceil(X(c)/0.1);
%avoid overflow row=0 or col=0 should be set as 1
A(:,1:2)=A(:,1:2)+(A(:,1:2)==0);
%stor intensity of each grid
A(:,3)=intensity(c);

%merge intensity of the same grid
[C,ia,ic]=unique(A(:,1:2),'rows');
uA=A(ia,:);
for i=1:size(C,1)
    w=find(ic==i);
    if length(w)>1
        uA(i,3)=mean(A(w,3));
    end
end

%make a matrix for heat map
data_matrix=zeros(40,40);
for i=1:size(uA,1)
    data_matrix(uA(i,1),uA(i,2))=uA(i,3);
end

% %show heat map
% h=heatmap(data_matrix);
% h.GridVisible='off';
% h.CellLabelColor='none';
end

