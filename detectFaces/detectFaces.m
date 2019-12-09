% ECEN - 649 Course Project
% detectFaces.m - detects face using trained classifiers 
function [faces,faceBound] = detectFaces(img)
% preprocessing by Gaussian filtering
img2 = img; % keep a copy of the original color 3D image
img = imread(img);
img = rgb2gray(img);
img = conv2(img,fspecial('gaussian',3,3),'same');

% get image parameters
[m,n] = size(img);

% other variables
scanItr = 10; % can be modified depending on how big face is relative to image
faces = []; % empty by default

% compute integral image
intImg = integralImg(img);

% load finalClassifiers
% load '../trainHaar/trainedClassifiers.mat' % 286 classifiers
load '../trainHaar/finalClassifiers.mat'

%%%%% Cascaded Detector Structure: 7 levels, 200 classifiers %%%%%
class1 = selectedClassifiers(1:2,:);
class2 = selectedClassifiers(3:12,:);
class3 = selectedClassifiers(13:20,:);
class4 = selectedClassifiers(21:40,:);
class5 = selectedClassifiers(41:70,:);
class6 = selectedClassifiers(71:150,:);
class7 = selectedClassifiers(151:200,:);

% iterate through each window size/pyramid level
for itr = 1:scanItr
    printout = strcat('Iteration #',int2str(itr),'\n');
    fprintf(printout);
    for i = 1:2:m-19
        if i + 19 > m 
            break; % boundary case check
        end
        for j = 1:2:n-19
            if j + 19 > n
                break; % boundary case check
            end
            window = intImg(i:i+18,j:j+18); % 19x19 window as per training
            check1 = cascade(class1,window,1);
            if check1 == 1
                check2 = cascade(class2,window,.5);
                if check2 == 1
                    check3 = cascade(class3,window,.5);
                    if check3 == 1
                        check4 = cascade(class4,window,.4);
                        if check4 == 1
                            check5 = cascade(class5,window,.4);
                            if check5 == 1
                                check6 = cascade(class6,window,.4); 
                                if check6 == 1
                                    fprintf('Passed level 6 cascade.\n');
                                    check7 = cascade(class7,window,.4);
                                    if check7 == 1
                                        % save rectangular corner coordinates
                                        bounds = [j,i,j+18,i+18,itr];
                                        fprintf('Face detected!\n');
                                        faces = [faces;bounds];
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    % create next image pyramid level
    tempImg = imresize(img,.8);
    img = tempImg;
    [m,n] = size(img);
    intImg = integralImg(img);
end

if size(faces,1) == 0 % no faces detected
   error('No face detected! Try again with a larger value of scanItr.'); 
end

%%%%% Get Best Bounding Box %%%%%
% upscale rectangular bound coordinates back to base level of pyramid
faceBound = zeros(size(faces,1),4);
maxItr = max(faces(:,5)); % higher iterations have larger bounding boxes
for i = 1:size(faces,1)
    if faces(i,5) ~= maxItr
        continue; % only interested in large bounding boxes
    end
    faceBound(i,:) = floor(faces(i,1:4)*1.25^(faces(i,5)-1));
end

% filter out overlapping rectangular bounding boxes
startRow = 1;
for i = 1:size(faceBound,1)
   if faceBound(i,1) == 0
       startRow = startRow+1; % start with next row
   end
end
faceBound = faceBound(startRow:end,:); % trim faceBound to get rid of 0-filled rows

% get the union of the areas of overlapping boxes
faceBound = [min(faceBound(:,1)),min(faceBound(:,2)),max(faceBound(:,3)),max(faceBound(:,4))];

% Show the detected face(s) with original image
figure,imshow(img2), hold on;
if(~isempty(faceBound))
    for n=1:size(faceBound,1)
        toleranceX = floor(0.1*(faceBound(n,3)-faceBound(n,1)));
        toleranceY = floor(0.1*(faceBound(n,4)-faceBound(n,2)));
        % original bounds
        x1=faceBound(n,1); y1=faceBound(n,2);
        x2=faceBound(n,3); y2=faceBound(n,4);
        % adjusted bounds to get wider face capture
        x1t=faceBound(n,1)-toleranceX; y1t=faceBound(n,2)-toleranceY;
        x2t=faceBound(n,3)+toleranceX; y2t=faceBound(n,4)+toleranceY;
        imSize = size(imread(img2));
        % if adjusted bounds will lead to out-of-bounds plotting, use original bounds
        if x1t < 1 || y1t < 1 || x2t > imSize(2) || y2t > imSize(1)
            fprintf('Out of bounds adjustments. Plotting original values...\n');
            plot([x1 x1 x2 x2 x1],[y1 y2 y2 y1 y1],'LineWidth',2);
        else
            plot([x1t x1t x2t x2t x1t],[y1t y2t y2t y1t y1t],'LineWidth',2);
        end
    end
end

title('Detected face in image');
hold off;

end
