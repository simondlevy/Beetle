function matrix = solveravens(matrix)
% SOLVERAVENS Sovles Ravens Matrices using VSA (MAP flavor)
%
% SOLVERAVENS(MATRIX) takes a 3x3 cell array MATRIX with missing cell at
% <3,3> and returns a solution with <3,3> filled in.  Currenly supports
% shapes C(ircle), T(riangle), and D(iamond), one two three of each per
% cell.
% 
% Example:
%
%  >> matrix = {'T',   'D',   'C'; ...
%              'TT',  'DD',  'CC'; ...
%              'TTT', 'DDD', ''};
% 
%  >> solveravens(matrix)
%
%  ans = 
%  
%      'T'      'D'      'C'  
%      'TT'     'DD'     'CC' 
%      'TTT'    'DDD'    'CCC'
%
%  Based on
%
%     @Article{RasmussenEliasmith2011,
%       author =  {Daniel Rasmussen and Chris Eliasmith},
%       title =   {A Neural Model of Rule Generation in Inductive Reasoning},
%       journal = {Topics in Cognitive Science},
%       year = 	  {2011},
%       volume =  {3},
%       number =  {1},
%       pages =   {140-153}
%     }

% Dimesnionality of VSA representations (arbitrary)
NDIMS = 10000;

% Permutation object
P = Permutation(NDIMS);

% VSA encodings of roles
nrole = randbp(1, NDIMS);
srole = randbp(1, NDIMS);

% VSA encodings of fillers
shapes = struct('C', randbp(1,NDIMS), 'D', randbp(1,NDIMS), 'T', randbp(1,NDIMS));
counts = randbp(3,NDIMS);

% Row transformation
rowtrans =  ...
    rowpair(matrix, P, nrole, srole, shapes, counts, 1, 1) + ...
    rowpair(matrix, P, nrole, srole, shapes, counts, 1, 2) + ...
    rowpair(matrix, P, nrole, srole, shapes, counts, 2, 1) + ...
    rowpair(matrix, P, nrole, srole, shapes, counts, 2, 2) + ...
    rowpair(matrix, P, nrole, srole, shapes, counts, 3, 1);

% Column transformation
coltrans =  ...
    colpair(matrix, P, nrole, srole, shapes, counts, 1, 1) + ...
    colpair(matrix, P, nrole, srole, shapes, counts, 1, 2) + ...
    colpair(matrix, P, nrole, srole, shapes, counts, 1, 3) + ...
    colpair(matrix, P, nrole, srole, shapes, counts, 2, 1) + ...
    colpair(matrix, P, nrole, srole, shapes, counts, 2, 2);

% Solution
solution = P.inv(encodem(matrix, nrole, srole, shapes, counts, 3, 2).*rowtrans + ...
                 encodem(matrix, nrole, srole, shapes, counts, 2, 3).*coltrans);
           

% Compare with all possible shape/count combos
maxcos = 0;
smax = '';
nmax = 0;
for s = 'CDT'
    for n = 1:3
        cosval = cosine(solution, encode(nrole, srole, shapes, counts, s, n));
        if cosval > maxcos
            maxcos = cosval;
            smax = s;
            nmax = n;
        end
    end
end

% Fill missing cell with shape/count
matrix{3,3} = repmat(smax, 1, nmax);

function res = rowpair(matrix, P, nrole, srole, shapes, counts, row, col)
res = makepair(matrix, P, nrole, srole, shapes, counts, row, col, row, col+1);

function res = colpair(matrix, P, nrole, srole, shapes, counts, row, col)
res = makepair(matrix, P, nrole, srole, shapes, counts, row, col, row+1, col);

function res = makepair(matrix, P, nrole, srole, shapes, counts, row, col, nextrow, nextcol)
res = encodem(matrix, nrole, srole, shapes, counts, row, col) .* ...
    P.fwd(encodem(matrix, nrole, srole, shapes, counts, nextrow, nextcol));

function res = encodem(matrix, nrole, srole, shapes, counts, row, col)
celli = matrix{row,col};
shape = celli(1);
count = length(celli);
res = encode(nrole, srole, shapes, counts, shape, count);

function res = encode(nrole, srole, shapes, counts, shape, count)
res = nrole .* counts(count,:) + srole .* shapes.(shape);



