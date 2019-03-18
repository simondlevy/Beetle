function sdmsequence(seed)
%SDMSEQUENCE Sparse Distributed Memory sequence-reconstruction demo. Based on the
%third figure in
%
%     @Article{Denning1989,
%       author =  {Peter J. Denning},
%       title =   {Sparse Distributed Memory},
%       journal = {American Scientist},
%       year = 	  {1989},
%       volume =  {77},
%       pages =   {333-337}
%     }

RADIUS = 0.325;
NOISE  = 0.3;
  
load roman

% Random seed for reproducibility
if nargin > 0
    rng(seed, 'twister')
end


% Use first five numerals as addresses
addr = zeros(5, 256);
addr(1,:) = r1;
addr(2,:) = r2;
addr(3,:) = r3;
addr(4,:) = r4;
addr(5,:) = r5;

% Map from one numeral to next
data = zeros(5, 256);
data(1,:) = r2;
data(2,:) = r3;
data(3,:) = r4;
data(4,:) = r5;
data(5,:) = r6;


% Create bipolar SDM with five hard addresses
sdm = SDMBP(addr, data);

% Create a noisy variant of numeral iii as cue
r3_noisy = distortbp(r3, NOISE);

% Display the cue
show_with_error(1, 4, 1, r3_noisy, r3)

% Use the noisy variant as a retrieval cue in the SDM
r4_retr = sdm.retrieve(r3_noisy, RADIUS);

% Display the first retrieved pattern
show_with_error(1, 4, 2, r4_retr, r4)

% Use the first retrieved pattern as another cue
r5_retr = sdm.retrieve(r4_retr, RADIUS);

% Display the second retrieved pattern
show_with_error(1, 4, 3, r5_retr, r5)

% Use the first retrieved pattern as another cue
r6_retr = sdm.retrieve(r5_retr, RADIUS);

% Display the second retrieved pattern
show_with_error(1, 4, 4, r6_retr, r6)

