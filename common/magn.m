function res = magn(v)
% MAGN(V) returns the magnitude of vector V, defined as the square root of
% the sum of its squared elements.

res = sqrt(sum(v.^2));