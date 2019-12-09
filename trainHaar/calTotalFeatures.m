% ECEN - 649 Course Project
% Calculate total Harr Features for each type;

function [count] = calTotalFeatures(W, H, w, h)
X = W / w;
Y = H / h;
count = 0;
for i = 1 : X
    for j = 1 : Y
        for x = 1 : W - i * w + 1
            for y = 1 : H - j * h + 1
            count = count + 1;
            end
        end
    end
end

end