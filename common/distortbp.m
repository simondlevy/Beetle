function y = distortbp(x, noise)
% DISTORTBP(X, NOISE) returns a version of bipolar vector X distorted by randomly
% negating NOISE fraction of its values.

y = x;
n = numel(x);
k = randperm(n);
k = k(1:round(noise*n));
y(k) = -y(k);
