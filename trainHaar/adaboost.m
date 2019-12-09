% ECEN - 649 Course Project
% adaboost.m - boosts classifiers and keep updating weights for images
% alpha values, and for individual images by updating image weights
function [newWeights,alpha, minError,minHaarX, minHaarY, minPixelX, minPixelY, falsepos, falseneg] = adaboost(classifier, images, imgWeights, minError, minHaarX, minHaarY, minPixelX, minPixelY)
imgsSize = 499+2000; % total number of images in given dataset
faceSize = 499; % total number of face images
captures = zeros(imgsSize,1);
error = 0;
falsepos = 0;
falseneg = 0;
for i = 1:imgsSize
    img = images{i};
    % obtains classifier metadata from fields in the row vector 
    haar = classifier(1);
    pixelX = classifier(2);
    pixelY = classifier(3);
    haarX = classifier(4);
    haarY = classifier(5);
    % calculates intensity difference between black-white region of the
    % Haar feature and checks against the precalculated range
    haarVal = calcHaarVal(img,haar,pixelX,pixelY,haarX,haarY);
    if haarVal >= classifier(9) && haarVal <= classifier(10) % if falls between correct value
        if i <= faceSize % if its a face
            captures(i) = 1; % correct capture
        else
            captures(i) = 0; % error
            falsepos = falsepos + 1;
            error = error + imgWeights(i); % increase weighted error count
        end
    else % if falls outside the expected range
        if i <= faceSize % if is a face
            captures(i) = 0;
            falseneg = falseneg + 1;
            error = error + imgWeights(i); % error
        else 
            captures(i) = 1;
        end
    end
end

alpha = 0.5*log((1-error)/error); % updates classifier weight (alpha)
% display(error);
if (error <= minError)
    minError = error;
    minHaarX = haarX;
    minHaarY = haarY;
    minPixelX = pixelX;
    minPixelY = pixelY;
end
% modifies images' weights by whether it is a successful capture or not
% correct captures result in lower weights; false captures result in higher
% weight to put more emphasis on them
for i = 1:imgsSize
    if captures(i) == 0
        imgWeights(i) = imgWeights(i).*exp(alpha);
    else
        imgWeights(i) = imgWeights(i).*exp(-alpha);
    end
end
imgWeights = imgWeights./sum(imgWeights); % normalize image weights
newWeights = imgWeights; % pass as function output
end


    