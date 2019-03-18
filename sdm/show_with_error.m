function show_with_error(m, n, p, actual, target)
% helper function for SMDSEQUENCE, SDMSIGNOISE

subplot(m,n,p)

a = reshape(actual, 16, 16);

a = flipud(a);

m = size(a, 1);
n = size(a, 2);

b = zeros(m+1, n+1);

b(1:m,1:n) = a;

if any(actual ~= 0)
    pcolor(1-b)
end

axis square
colormap bone
shading flat
axis off
title(sprintf('%d%%', round(normdistbp(actual, target)*100)))

