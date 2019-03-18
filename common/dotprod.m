function res = dotprod(x, y)
% DOTPROD(X,Y) returns the dot-product of vectors X and Y, defined as the
% sum over their element-wise products.

res = sum(x.*y);