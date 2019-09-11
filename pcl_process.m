clear all
clc
%load bag file
filepath=fullfile('E:','wumiao','experiment','moving2.bag');
bag=rosbag(filepath);

%extract the topic message
bSel=select(bag,'Topic','/mmWaveDataHdl/RScan');
msgStructs=readMessages(bSel);

%extract x,y,z,intensity
N=size(msgStructs,1);
%number of frames
xyzi=cell(N,1);
for i=1:N
    xyzi{i}=readXYZ(msgStructs{i});
    xyzi{i}(:,3)=readField(msgStructs{i},'intensity');
    xyzi{i}(:,4)=i;
end


%% hungarian algorithem
% match points of kth frame with previous points of 9 frames (window length
% 10)

% decide which point is noise
scatter_make_gif(xyzi,'moving_raw_data.avi')

processed_xyzi=xyzi(10:end);
for i=1:(N-9)
    if (i+9)<=N
        match_matrix=hungarian(xyzi(i:(i+9)));
        no_match=sum(match_matrix,2);
        p=find(no_match<=-6);
        processed_xyzi{i}(p,:)=[];
    else
        print('overflow!\n');
    end
end

scatter_make_gif(processed_xyzi,'moving_filtered_hungarian.avi')
%% intuitive method
%plot 2D points in a x-y-t figure and use color represent intensity,
%according to feature number decide noise point

%process raw data to get heat map matrix
all_matrix=cell(N,1);
for i=1:N
    all_matrix{i}=heat_matrix(xyzi{i});
end

%show heat map and save as gif
heatmap_make_gif(all_matrix,'moving_raw_heatmap.avi');

%process each frame
processed_all_matrix=cell(N-10,1);
for i=1:(N-10)
    A=all_matrix{i};
    for m=1:9
        A=A+all_matrix{m+i};
    end
    A=1/10*A;
    target_matrix=all_matrix{i+10};
    location=target_matrix>=A;
    processed_all_matrix{i}=target_matrix.*location;
end

heatmap_make_gif(processed_all_matrix,'moving_filtered_heatmap.avi');
