imgSize = [128, 128];
data = load("prop_img_features.mat", "selectedFeatures");

initVal = 1;   % set your starting index
endVal  = numel(data.selectedFeatures); % or some other end index

for k = initVal:endVal
    index = data.selectedFeatures(k);   % get feature index
    [row, col] = ind2sub(imgSize, index);
    fprintf("%d %d\n", row, col);
end
