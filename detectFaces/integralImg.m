% ECEN - 649 Course Project
% integralImg.m - computes integral images for face detection using Viola-Jones algorithm 
function outimg = integralImg (inimg)
    % cumulative sum for each pixel of all rows and columns to the left and
    % above the corresponding pixel
    outimg = cumsum(cumsum(double(inimg),2));
end
