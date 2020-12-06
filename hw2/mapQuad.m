function [newIm] = mapQuad(im, pointsSet1, pointsSet2, transformType)

% determine transformation type:
if (transformType == 1)
    A = findAffineTransform(pointsSet1, pointsSet2);
else
    A = findProjectiveTransform(pointsSet1, pointsSet2);
end

% get generic cordinates vector:
M = getCordinatesVector(256);

% TODO - add meshgrid to minimize calcs here
min_x_bound = min(pointsSet2(1,:));
min_y_bound = min(pointsSet2(2,:));
max_x_bound = max(pointsSet2(1,:));
max_y_bound = max(pointsSet2(2,:));
[x_bound, y_bound] = meshgrid(min_x_bound:max_x_bound, min_y_bound:max_y_bound);
polygon_dst = inpolygon(x_bound, y_bound,pointsSet2(1,:),pointsSet2(2,:));
[x, y] = find(polygon_dst);
x=x+min_y_bound;
y=y+min_x_bound;

X_dest=[y'; x'; ones(length(x),1)'];

newIm = im;

X_t = A\X_dest;

% bilinear interpolation on X_t here
X_t = X_t ./ X_t(3,:);
X_t(3,:) = [];


for i = 1:length(X_dest)
    
    x_d = X_dest(:,i);
    t = X_t(:,i);

    % in case of out of bounds pixels
    if t(1) > 256 || t(1) < 1 || t(2) < 1 || t(2) > 256 
        newIm(x_d(1),x_d(2)) = 0;
        continue
    end
    
    % pixel assignment:
    newIm(x_d(2),x_d(1)) = bilinearInterpolation(im,t(2),t(1));

end

end


