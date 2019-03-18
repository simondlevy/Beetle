classdef repeqvsa
    % REPEQVSA VSA implementation of replicator equations
    % for graph isomorphism and related problems.
    %
    % Based on
    %
    %     @Inproceedings{LevyGayler 2009,
    %       author =  {Simon D. Levy and Ross W. Gayler},
    %       title =   {``Lateral Inhibition'' in a Fully Distributed
    %                  Connectionist Architecture},
    %       booktitle = {Proceedings of the Ninth International Conference on
    %                    Cognitive Modeling (ICCM 2009)
    %       year = 	  {2009},
    %       address = {Manchester, UK}
    %      }
    %
    %
    
    properties
        
        % Vector size
        DIMS = 40000;
        
        % Permutation dictionary size
        PDSIZE = 200;
        
        % state vector
        x;
        
    end
    
    properties(Hidden)
        
        % weights matrix
        W;
        
        % Permutation dictionary
        pd;
        
        % Cleanup dictionary
        cd;
        
        
    end
    
    methods
        
        function obj = repeqvsa(A)
            % REPEQVSA(A) constructs a replicator-equation solver using consistency matrix A.
            
            fprintf('Initializing with %d dimensions and %d permutations ...', obj.DIMS, obj.PDSIZE)
            
            % Create a vector for each vertex/position pair
            v = randbp(16, obj.DIMS);
            
            % Build permutation dictionary from vertex/position pairs
            obj.pd = repeqvsa.permdict(v, obj.PDSIZE);
            
            % Build cleanup memory from from vertex/position pairs
            obj.cd = cleanmem(v);
            
            % State vector is normalized sum over vertex/position pairs
            obj.x = normalize(sum(v));
            
            % Weights (evidence) vector is sum over attested pairs in A
            
            obj.W = zeros(1, obj.DIMS);
            
            for i = 1:16
                for j = 1:i
                    if A(i,j)
                        obj.W = obj.W + v(i,:) .* v(j,:);
                    end
                end
            end
            
            fprintf('done\n')
            
        end
        
        function z = intersect(obj, xprev, y)
            % INTERSECT(XPREV, P) performs the "intersection" operation 
            % between previous state vector XPREV and payoff vector P.
            
            w  = obj.pd.w;
            p1 = obj.pd.p1;
            p2 = obj.pd.p2;
            
            z = zeros(size(xprev));
            
            for k = 1:size(w, 1)
                z = z + xprev(p1(k,:)) .* y(p2(k,:)) .* w(k,:);
            end
            
            z = z / size(w, 1);
            
            z = cleanup(z, obj.cd);
        end
        
        function v = probs(obj)
            % PROBS returns the probabilities associated with each
            % solution.
            
            N = size(obj.cd, 1);
            
            v = zeros(1,N);
            
            for k = 1:N
                v(k) = dot(obj.x, obj.cd(k,:)) / length(obj.x);
            end
            
            v  = normalize(v)';
            
        end
        
        function p = propagate(obj)
            % PROPAGATE performs evidence propagation.
            p = obj.W .* obj.x;
        end
        
        function x = squash(~, x)
            % SQUASH(X) returns the squashed (bounded) version of state vector X.
            x = x / max(abs(x));
        end
        
    end
    
    methods(Hidden, Static)
        
        function d = permdict(a, siz)
            
            dims = size(a, 2);
            
            w = zeros(siz, dims);
            
            p1 = zeros(siz, dims);
            p2 = zeros(siz, dims);
            
            for k = 1:siz
                p1(k,:) = randperm(dims);
                p2(k,:) = randperm(dims);
                for j = 1:size(a,1)
                    v = a(j,:);
                    w(k,:) = w(k,:) + v .* v(p1(k,:)) .* v(p2(k,:));
                end
            end
            
            d.w  = w;
            d.p1 = p1;
            d.p2 = p2;
            
        end
        
    end
    
end

