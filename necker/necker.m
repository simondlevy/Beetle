function necker(solver, seed)
%
% NECKER Demonstration of Necker cube solution by replicator equations
%
%   NECKER runs runs the Necker cube demo using the VSA solution model.
%
%   NECKER(SOLVER) runs the Necker cube demo using the specified solution model (@repeqlocal or @repeqvsa).
%
%   NECKER(SOLVER, SEED) supports random-number-generator seed for reproducibility.


% Noise floor
ZERO = 0.05;

% Number of iterations
NITER = 10;

% Default to VSA solution model
if nargin < 1
    solver = @repeqvsa;
end

% Seed random-number generator if indicated
if nargin > 1
    rng(seed)    
end

% Consistency matrix. 
A = [...
    % PF QF RF SF PB QB RB SB TF UF VF WF TB UB VB WB
      1  1  1  1  0  0  0  0  0  0  0  0  1  1  1  1; ... % PF  
      1  1  1  1  0  0  0  0  0  0  0  0  1  1  1  1; ... % QF  
      1  1  1  1  0  0  0  0  0  0  0  0  1  1  1  1; ... % RF
      1  1  1  1  0  0  0  0  0  0  0  0  1  1  1  1; ... % SF
      0  0  0  0  1  1  1  1  1  1  1  1  0  0  0  0; ... % PB
      0  0  0  0  1  1  1  1  1  1  1  1  0  0  0  0; ... % QB
      0  0  0  0  1  1  1  1  1  1  1  1  0  0  0  0; ... % RB
      0  0  0  0  1  1  1  1  1  1  1  1  0  0  0  0; ... % SB
      0  0  0  0  1  1  1  1  1  1  1  1  0  0  0  0; ... % TF
      0  0  0  0  1  1  1  1  1  1  1  1  0  0  0  0; ... % UF
      0  0  0  0  1  1  1  1  1  1  1  1  0  0  0  0; ... % VF
      0  0  0  0  1  1  1  1  1  1  1  1  0  0  0  0; ... % WF
      1  1  1  1  0  0  0  0  0  0  0  0  1  1  1  1; ... % TB
      1  1  1  1  0  0  0  0  0  0  0  0  1  1  1  1; ... % UB
      1  1  1  1  0  0  0  0  0  0  0  0  1  1  1  1; ... % VB
      1  1  1  1  0  0  0  0  0  0  0  0  1  1  1  1];    % WB    
  
% Avoid self-reinforcement
A = A & ~eye(size(A));
  
% State history
h = [];

% Initialize solver
solv = solver(A);

% Previous state, for convergence check
xprev = solv.x;

% Print out header
fprintf('ITERATION\tCONVERGENCE\n')

% Run for specified number of iterations
for i = 1:NITER
    
    % maintain state history
    h(:,end+1) = solv.probs();
    
    % propagate evidence to get payoff
    p = solv.propagate();
    
    % multiply previous state by payoff to get new state (Eq. 3.2)
    solv.x = solv.intersect(xprev, p);
    
    % keep state vector in reasonable bounds
    solv.x = solv.squash(solv.x);
    
    % get distance between successive state vectors
    d = sqrt(sum((solv.x-xprev).^2));
    
    % report convergence 
    fprintf('%3d\t\t%f\n', i, d)
        
    % update
    xprev = solv.x;
    
end

% Find nonzero solutions
win = find(solv.probs() > ZERO);

hold on

% Plot histories of winners in color
plot(h(win,:)')

% Plot losers in black
plot(h(setdiff(1:16, win),:)', 'k')

% Label axes
xlabel('t')
ylabel('x_t')

% Legend shows winners
key = {};
labels = {'PF', 'QF', 'RF', 'SF', 'PB', 'QB', 'RB', 'SB', 'TF', 'UF', 'VF', 'WF', 'TB', 'UB', 'VB', 'WB'};
for i = 1:length(win)
    key{i} = labels{win(i)};
end

legend(key);














