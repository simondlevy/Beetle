function a = randbp(varargin)
% RANDBP Pseudo-random bipolar numbers
%    R = RANDBP(<args>) works like the built-in RAND(<args>) function, 
%    but returns values from the set {-1,+1}.

a = 2 * (rand(varargin{:}) > 0.5) - 1;
