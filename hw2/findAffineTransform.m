function [T] = findAffineTransform(pointsSet1, pointsSet2)
%FINDAFFINETRANSFORM Summary of this function goes here
%   Detailed explanation goes here

% generate X matrix
X_source = pointsSet1(:);
X = [];
for i = 1:2:length(X_source)
    t = [X_source(i), X_source(i+1), 0, 0, 1, 0];
    k = [0, 0, X_source(i), X_source(i+1), 0, 1];
    X = [X t k];
end
X = reshape(X, 6, i+1)';

% generate X' matrix - the regular point_set:
X_t = pointsSet2(:);

% calculate T values: 
A = pinv(X) * X_t;

% constract A:
%  -----------
% a b e
% c d f
% 0 0 1
%  -----------

T = [A(1) A(2) A(5); 
     A(3) A(4) A(6); 
     0    0    1];

end
