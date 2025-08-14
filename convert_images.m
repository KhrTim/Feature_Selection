% Directory containing the PNG images
imgDir = 'coil-20-proc'; % <-- change to your folder path
fileList = dir(fullfile(imgDir, '*.png'));

numImages = length(fileList);
imgSize = [128, 128];
numPixels = prod(imgSize);

% Preallocate array (binary)
data = false(numImages, numPixels);

% Threshold value (0–255 for uint8)
threshold = 128; % adjust if needed

for i = 1:numImages
    % Read image
    imgPath = fullfile(imgDir, fileList(i).name);
    img = imread(imgPath);

    % Convert to grayscale if needed
    if size(img, 3) == 3
        img = rgb2gray(img);
    end

    % Ensure it's 128×128
    img = imresize(img, imgSize);

    % Binarize using threshold
    binaryImg = img > threshold;

    % Flatten to row vector
    data(i, :) = binaryImg(:)';
end

% Save to MAT file
save('binary_image_array.mat', 'data', '-v7.3');

disp('Binary image array saved to binary_image_array.mat');
