function y = cleanup(x, c)
% Y = CLEANUP(X, C) where C is a VSA cleanup memory returns a cleaned-up
% version of noisy vector X.

if size(c, 1) ~= size(c, 2)
    
    % XXX localist cheat
    y = zeros(size(x));
    for k = 1:size(c, 1)
        ck = c(k,:);
        s = dot(x, ck) / length(x);
        y = y + s * ck;
    end
else
    
    % auto-associative cleanup
    y = (x * c) / length(x);
    
end

