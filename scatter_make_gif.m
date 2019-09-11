function []= scatter_make_gif(data,filename)
%data is the cell with position and intensity information of each frame
%output is gif to show how the points move
%   use point cloud data to plot and make gif
N=length(data);

vidObj=VideoWriter(filename);
open(vidObj);
aviobj.Quality = 100;
aviobj.Fps = 25;
aviobj.compression='None';

for i=1:N
    %plot figure
    figure(1)
    x=data{i}(:,1);
    y=data{i}(:,2);
    intensity=data{i}(:,3);
    sz=25;
    c=1+intensity/40*9;
    scatter(x,y,sz,c,'filled')
    grid on
    
    axis([0,8,-6,6])
    xlabel('X(m)');
    ylabel('Y(m)');
    pause(0.05)
    
    %make gif
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

