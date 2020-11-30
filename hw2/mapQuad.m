function [newIm] = mapQuad(im, pointsSet1, pointsSet2, transformType)
%MAPQUAD Summary of this function goes here
%   Detailed explanation goes here

if (transformType == 1)
    A = findAffineTransform(pointsSet2, pointsSet1);
else
    A = findProjectiveTransform(pointsSet2, pointsSet1);
end


M = getCordinatesVector(256);


% add ones row [V ones(256,1)]
% this will be your X
X_s = [reshape(M,2,256*256); ones(256*256,1)'];

% calc X' by multyplying with A
% floor/round cordinates (NN)
X_t = abs(round(A*X_s));
X_t(3,:) = [];
X_s(3,:) = [];

polygon = inpolygon(M(1,:),M(2,:),pointsSet2(1,:),pointsSet2(2,:));
polygon = reshape(polygon,256,256);

% get actual pixel values mapping
% newIm = ones(256,256)*250;
newIm = im;
for i = 1:length(X_t)
    
    t = X_s(:,i);
    k = X_t(:,i)';
    
%      FIX THIS SHIT!
    if k(1) > 256 || k(1) == 0 || k(2) == 0 || k(2) > 256
        continue
    end
    
    if polygon(t(1),t(2))
        newIm(t(1),t(2)) = im(k(1),k(2));
%         newIm(k(1),k(2)) = 0; 
%         newIm(t(1),t(2)) = 0;
    end
    
end


end

