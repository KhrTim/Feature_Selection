% function [ U ] = Optimize_S(X, Phi, lambda1, Ai,alpha) % update U
% lambda = 1/lambda1;
% num = size(X,2);
% m = size(Ai,3);
% PhiX = Phi'*X;
% islocal = 1; % only update the similarities of neighbors if islocal=1
% dist = L2_distance_1(PhiX,PhiX); % num * num
% U = zeros(num);
% for i=1:num
%     idx = zeros();
%     for v = 1:m
%         temp = Ai(:,:,v);
%         s0 = temp(i,:);
%         idx = [idx,find(s0>0)];
%     end;
%     idxs = unique(idx(2:end));
%     if islocal == 1
%         idxs0 = idxs;
%     else
%         idxs0 = 1:num;
%     end;
%     for v = 1:m
%         temp = Ai(:,:,v);
%         s1 = temp(i,:);
%         si = s1(idxs0);
%         di = dist(i,idxs0);
%         mw = m*alpha(v);
%         lmw = lambda/mw;
%         q(v,:) = si-0.5*lmw*di;
%     end;
%     U(i,idxs0) = SloutionToP19(q,m);
%     clear q;
% end;
% end
function [ U ] = Optimize_S(X, Phi, lambda1, Ai,alpha) % update U
lambda = 1/lambda1;
num = size(X,2); % This assumes X is features x samples, so num is the number of samples.
m = size(Ai,3);

fprintf('--- Debugging Optimize_S ---\n');
fprintf('Input X size: [%d %d]\n', size(X));
fprintf('Input Phi size: [%d %d]\n', size(Phi));
fprintf('Phi transpose size: [%d %d]\n', size(Phi'));

% The problematic line (Line 5)
try
    PhiX = Phi'*X;
    fprintf('PhiX size: [%d %d]\n', size(PhiX));
catch ME
    fprintf('Error at PhiX = Phi''*X:\n');
    fprintf('Error message: %s\n', ME.message);
    % Re-throw the error to stop execution
    rethrow(ME);
end

dist = L2_distance_1(PhiX,PhiX); % This should result in a num x num matrix.

U = zeros(num);
for i=1:num
    % FIX 1: Initialize idx as an empty array
    idx = [];
    for v = 1:m
        temp = Ai(:,:,v);
        s0 = temp(i,:); % Assumes Ai is (num x num x m), so temp(i,:) is (1 x num)
        idx = [idx, find(s0 > 0)]; % Concatenate found indices
    end;
    % idxs should now contain unique indices of neighbors for sample i
    idxs = unique(idx); % No need for (2:end) if idx was initialized as []

    if islocal == 1
        idxs0 = idxs;
    else
        idxs0 = 1:num;
    end;

    % Pre-allocate q for efficiency if possible, or ensure it's cleared correctly.
    % If idxs0 can be empty, this loop will cause issues if q is not handled.
    % Check if idxs0 is empty and handle if necessary.
    if isempty(idxs0)
        % No neighbors found, what should U(i,idxs0) be?
        % For now, skip or assign zeros.
        continue; % Skip to next iteration if no neighbors
    end

    q = zeros(m, length(idxs0)); % Pre-allocate q

    for v = 1:m
        temp = Ai(:,:,v);
        s1 = temp(i,:);
        si = s1(idxs0);
        di = dist(i,idxs0);
        mw = m*alpha(v);
        lmw = lambda/mw;
        q(v,:) = si-0.5*lmw*di;
    end;
    U(i,idxs0) = SloutionToP19(q,m);
    % No need to clear q explicitly if it's re-assigned in the next iteration.
    % clear q; % This line is fine, but not strictly necessary for this context.
end;
end