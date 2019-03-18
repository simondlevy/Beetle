function res = cosine(x, y)
% COSINE(X,Y) returns the vector cosine between vectors X and Y, defined as
% their dot-product divided by the product of their magnitudes.

res = dotprod(x,y) / (magn(x) * magn(y));