classdef SDMBP
    % SDMBP Sparse Distributed Memory using bipolar vectors.
    %
    % Based on
    %
    % @book{kanervasdm1988,
    % author    = {Pentti Kanerva}, 
    % title     = {Sparse Distributed Memory},
    % publisher = {MIT Press},
    % year      = {1988},
    % address   = {Cambridge, Massachusetts}
    % }
    %
    % Kanerva used vectors from {0,1}, but we use {-1,+1} to support
    % Multiply-Add-Permute flavor of Vector Symbolic Architecture.
    
    properties(Hidden)
        data
        addr
    end
    
    methods
        
        function obj = SDMBP(arg1, arg2, arg3)
            % SDMBP(ADDR, DATA) constructs a bipolar SDM with pre-built
            % addresses ADDR and data in DATA.  ADDR and DATA should have
            % the same number of rows.
            %
            % SDMBP(ADDR) constructs a bipolar autoassociative SDM using
            % pre-built addresses ADDR.
            %
            % SDMBP(H, M, N) constructs a bipolar SDM with H hard
            % addresses of dimension M and data of dimension N. Addresses
            % are initialized to random values from {-1,+1} and data to
            % zeros.
            %
            % SDMBP(H, M)  constructs a bipolar autoassociative SDM with H
            % hard addresses of dimension M.
            
            % Matrix input
            if numel(arg1) > 1
                obj.addr = arg1;
                if nargin < 2
                    obj.data = obj.addr; % Autoassociator
                else
                    obj.data = arg2;
                end
                
                % Dimension input
            else
                
                if nargin < 3
                    arg3 = arg2; % Autoassociator
                end
                
                obj.addr = randbp(arg1, arg2);
                obj.data = zeros(arg1, arg3);
            end
            
        end
        
        function obj = insert(obj, pattern, radius, newdata)
            % INSERT(PATTERN, RADIUS, NEWDATA) performs SDM insertion of
            % NEWDATA vector at addresses within RADIUS of PATTERN.
            %
            % INSERT(PATTERN, RADIUS) performs autoassociatve insertion.
            
            if nargin < 4
                newdata = pattern; % Autoassociator
            end
            
            for k = obj.neighbors(pattern, radius)
                obj.data(k,:) = obj.data(k,:) + newdata;
            end
            
        end
        
        function retr = retrieve(obj, cue, radius)
            % RETRIEVE(CUE, RADIUS) returns the pattern retrieved by
            % summing over neighors of CUE within RADIUS.
            
            retr = 2 * (sum(obj.data(neighbors(obj, cue, radius)', :), 1) > 0) - 1;
            
        end
        
        function res = strength(obj, pattern)
            % STRENGTH(PATTERN) returns the representation strength of a 
            % pattern vector in the SDM, defined as the sum of the dot 
            % products of the vector with the SDM addresses.
            res = 0;
            
            for j = 1:size(obj.addr, 1)
                res = res + dotprod(obj.data(j,:), pattern);
            end
            
            res = res / numel(obj.data);
        end
        
    end
    
    methods(Hidden)
        
        function a = neighbors(obj, pattern, radius)
            
            % Start with all zeros to avoid accumulation warning
            a = zeros(size(obj.addr, 1));
            n = 0;
            
            % Get the index of each address within RADIUS of V
            for k = 1:size(obj.addr, 1)
                if normdistbp(pattern, obj.addr(k,:)) < radius
                    n = n + 1;
                    a(n) = k;
                end
            end
            
            % Strip trailing zeros from indices and return them as a column vector
            a = a(1:n);
            
        end
        
    end
    
end

