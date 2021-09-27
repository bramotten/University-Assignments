function dilh = dilation(h, SEsize)
SE = -floor(SEsize/2):floor(SEsize/2);
[rows, cols] = size(h);
dilh = zeros(rows, cols);
for y = 1:rows
    for x = 1:cols
        highestval = 0;
        for ySE = SE
            for xSE = SE
                if ySE+y > 0 && ySE+y < rows && xSE+x > 0 && xSE+x < cols
                    if h(ySE+y, xSE+x) > highestval
                        highestval = h(ySE+y, xSE+x);
                    end
                end
            end
        end
        dilh(y, x) = highestval;
    end
end
