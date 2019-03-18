classdef Permutation
    
    % PERMUTATION A class implementing forward and inverse vector
    % permutation.
    
    properties(Hidden)
        forward
        inverse
    end
    
    methods
        
        function obj = Permutation(n)
            % PERMUTATION(N) returns an N-dimensional Permutation object.
            obj.forward = randperm(n);
            [~,obj.inverse] = sort(obj.forward);
        end
        
        function y = fwd(obj, x)
            % FWD(X) returns the forward permutation of vector X.
            y = x(obj.forward);
        end
        
        function x = inv(obj, y)
            % INV(X) returns the inverse permutation of vector X.
            x = y(obj.inverse);
        end
        
    end
    
end

