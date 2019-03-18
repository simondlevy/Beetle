classdef repeqlocal
    
    % REPEQLOCAL Localist (original) implementation of replicator equations
    % for graph isomorphism and related problems.
    %
    %   Based on
    %
    %     @Article{Pelillo1999,
    %       author =  {Marcello Pelillo},
    %       title =   {Replicator Equations, Maximal Cliques, and Graph
    %                  Isomorphism},
    %       journal = {Neural Computation},
    %       year = 	  {1999},
    %       volume =  {11},
    %       pages =   {1933-1955}
    %     }
    
    properties
        
        % Perturbation coefficient
        PERTURB = 1e-2;
        % State vector
        x
        
    end
    
    properties(Hidden)
        
        
        % Weights matrix
        W
    end
    
    methods
        
        function obj = repeqlocal(A)
            % REPEQLOCAL(A) constructs a replicator-equation solver using consistency matrix A.
            
            % Weight matrix is same as consistency matrix, for repeqlocal version
            obj.W = A;
            
            % Characteristic (solution) vector starts at barycenter of simplex.
            % 16 possibilities:
            %   PF, QF, RF, SF, PB, QB, RB, SB, TF, UF, VW, WF, TB, UB, VB, WB
            obj.x = normalize(ones(16,1));
            
            % We perturb at the beginning, unlike Pelillo, who converges, perturbs,
            % and re-converges.
            obj.x = normalize(obj.x + obj.PERTURB * randn(size(obj.x)));
            
        end
        
        function z = intersect(~, xprev, p)
            % INTERSECT(XPREV, P) performs the "intersection" (elementwise
            % multiply) operation between previous state vector XPREV and payoff
            % vector P.
            z = xprev .* p;
        end
        
        function x = probs(obj)
            % PROBS returns the probabilities associated with each
            % solution.
            x = obj.x;
        end
        
        function p = propagate(obj)
            % PROPAGATE performs evidence propagation.
            p = obj.W * obj.x;
        end
        
        function x = squash(~, x)
            % SQUASH(X) returns the squashed (bounded) version of state vector X.
            x = normalize(x);
        end
        
    end
    
end

