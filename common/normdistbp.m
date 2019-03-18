function d = normdistbp(x, y)
%NORMDISTBP(X, Y) return the Hamming distance between two bipolar
%vectors, normalized to the interval [0,1].

d = sum(abs(x-y)) / length(y) / 2;
