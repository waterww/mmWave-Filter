function [] = heatmap_make_gif(data,filename)
%data is the input cell of heatmap matrix, filename is the name for output file
%   show heat map and save as gif

vidObj=VideoWriter(filename);
open(vidObj);
aviobj.Quality = 100;
aviobj.Fps = 25;
aviobj.compression='None';

for i=1:length(data)
    matrix=data{i};
    h=heatmap(matrix);
    h.GridVisible='off';
    h.CellLabelColor='none';
    h.ColorbarVisible='off';
    h.OuterPosition=[0.1 0 0.8 1];
    h.XLabel='X(0бл4m)';
    h.YLabel='Y(-2бл2m)';
    pause(0.05);
    
%     F=getframe(gcf);
%     I=frame2im(F);
%     [I,map]=rgb2ind(I,256);
%     if i==1
%         imwrite(I,map,filename,'gif','Loopcount',inf,'DelayTime',0.02);
%     else
%         imwrite(I,map,filename,'gif','WriteMode','append','DelayTime',0.02);
%     end

    %make video
    frame=getframe(gcf);
    adata=frame2im(frame);
    writeVideo(vidObj,adata);
    
end
close all
end

