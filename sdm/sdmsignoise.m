function sdmsignoise(seed)
%SDMSIGNOISE Sparse Distributed Memory signal-from-noise demo. Based on the
%second figure in
%
%     @Article{Denning1989,
%       author =  {Peter J. Denning},
%       title =   {Sparse Distributed Memory},
%       journal = {American Scientist},
%       year = 	  {1989},
%       volume =  {77},
%       pages =   {333-337}
%     }


RADIUS = 0.325; % Tweaked to illustrate progressive signal-from-noise
NOISE  = 0.2;

% Load the ring image
load ring

% Random seed for reproducibility
if nargin > 0
    rng(seed, 'twister')
end

% Create nine noisy variants of the ring pattern as SDM addresses
rnoisy = randbp(9, 256);
for p = 1:9
    
    % Add noise by randomly flipping a fraction of the original ring bits
    rnoisy(p,:) = distortbp(ring, NOISE);
    
    % Display the noisy pattern in sub-plot
    show_with_error(4, 3, p, rnoisy(p,:), ring)
    
end

% Create bipolar SDM from noisy variants
sdm = SDMBP(rnoisy);

% Create another noisy variant as a cue
cue = distortbp(ring, NOISE);

% Display the cue
show_with_error(4, 3, 10, cue, ring)

% Use the noisy variant as a retrieval cue in the SDM
retr = sdm.retrieve(cue, RADIUS);

% Display the first retrieved pattern
show_with_error(4, 3, 11, retr, ring)

% Use the first retrieved pattern as another cue
retr = sdm.retrieve(retr, RADIUS);

% Display the second retrieved pattern
show_with_error(4, 3, 12, retr, ring)
