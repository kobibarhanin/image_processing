function [] = createMagicMovie (movieFileName, numFrames, img, transformType, pointsSet_grab, pointsSet_0, pointsSet_1)

%CREATEMAGICMOVIE Summary of this function goes here
%   Detailed explanation goes here


video=VideoWriter(movieFileName);     
open(video);

imshow(img);
hold on

[X_t,Y_t] = linspaceVec(pointsSet_0, pointsSet_grab, numFrames/2);

for i=1:numFrames/2
    % calculate the polygon at time t
    pointsSet_t = [X_t(:,i) Y_t(:,i)]';
    
    % plot the polygon at time t
    p = plot(pointsSet_t(1,:),pointsSet_t(2,:), "-", 'LineWidth',3, 'Color', 'red');
    
    % record frame at time t
    frameT = getframe(gcf);
    writeVideo(video,frameT);
    
    % remove ploted polygon
    delete(p);
end

[X_t,Y_t] = linspaceVec(pointsSet_grab, pointsSet_1, numFrames/2);

for i=1:numFrames/2

    pointsSet_t = round([X_t(:,i) Y_t(:,i)]');
        

    img_t = mapQuad(img, pointsSet_grab, pointsSet_t, transformType);
    imshow(img_t);

    % to close off the polygon
    pointsSet_t_show=[pointsSet_t pointsSet_t(:,1)];
    
    p = plot(pointsSet_t_show(1,:),pointsSet_t_show(2,:), "-", 'LineWidth',3, 'Color', 'red');

    frameT = getframe(gcf);
    writeVideo(video,frameT);

    delete(p);
end

close(video);

