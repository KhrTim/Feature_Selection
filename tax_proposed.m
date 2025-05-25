clear;

fs_res = [128,	1,	123; 1,	2,	3];

load("./data/scadi.mat");

count_tb = zeros(14, 2);

count_tb(1, 1) = sum(fea(:, fs_res(1, 1)) == 0);
count_tb(2, 1) = sum(fea(:, fs_res(1, 1)) == 1);

count_tb(1, 2) = sum(fea(:, fs_res(2, 1)) == 0);
count_tb(2, 2) = sum(fea(:, fs_res(2, 1)) == 1);

count_tb(3, 1) = sum(fea(:, fs_res(1, 1)) == 0 & fea(:, fs_res(1, 2)) == 0);
count_tb(4, 1) = sum(fea(:, fs_res(1, 1)) == 0 & fea(:, fs_res(1, 2)) == 1);
count_tb(5, 1) = sum(fea(:, fs_res(1, 1)) == 1 & fea(:, fs_res(1, 2)) == 0);
count_tb(6, 1) = sum(fea(:, fs_res(1, 1)) == 1 & fea(:, fs_res(1, 2)) == 1);

count_tb(3, 2) = sum(fea(:, fs_res(2, 1)) == 0 & fea(:, fs_res(2, 2)) == 0);
count_tb(4, 2) = sum(fea(:, fs_res(2, 1)) == 0 & fea(:, fs_res(2, 2)) == 1);
count_tb(5, 2) = sum(fea(:, fs_res(2, 1)) == 1 & fea(:, fs_res(2, 2)) == 0);
count_tb(6, 2) = sum(fea(:, fs_res(2, 1)) == 1 & fea(:, fs_res(2, 2)) == 1);

count_tb(7, 1) = sum(fea(:, fs_res(1, 1)) == 0 & fea(:, fs_res(1, 2)) == 0 & fea(:, fs_res(1, 3)) == 0);
count_tb(8, 1) = sum(fea(:, fs_res(1, 1)) == 0 & fea(:, fs_res(1, 2)) == 0 & fea(:, fs_res(1, 3)) == 1);
count_tb(9, 1) = sum(fea(:, fs_res(1, 1)) == 0 & fea(:, fs_res(1, 2)) == 1 & fea(:, fs_res(1, 3)) == 0);
count_tb(10, 1) = sum(fea(:, fs_res(1, 1)) == 0 & fea(:, fs_res(1, 2)) == 1 & fea(:, fs_res(1, 3)) == 1);
count_tb(11, 1) = sum(fea(:, fs_res(1, 1)) == 1 & fea(:, fs_res(1, 2)) == 0 & fea(:, fs_res(1, 3)) == 0);
count_tb(12, 1) = sum(fea(:, fs_res(1, 1)) == 1 & fea(:, fs_res(1, 2)) == 0 & fea(:, fs_res(1, 3)) == 1);
count_tb(13, 1) = sum(fea(:, fs_res(1, 1)) == 1 & fea(:, fs_res(1, 2)) == 1 & fea(:, fs_res(1, 3)) == 0);
count_tb(14, 1) = sum(fea(:, fs_res(1, 1)) == 1 & fea(:, fs_res(1, 2)) == 1 & fea(:, fs_res(1, 3)) == 1);

count_tb(7, 2) = sum(fea(:, fs_res(2, 1)) == 0 & fea(:, fs_res(2, 2)) == 0 & fea(:, fs_res(2, 3)) == 0);
count_tb(8, 2) = sum(fea(:, fs_res(2, 1)) == 0 & fea(:, fs_res(2, 2)) == 0 & fea(:, fs_res(2, 3)) == 1);
count_tb(9, 2) = sum(fea(:, fs_res(2, 1)) == 0 & fea(:, fs_res(2, 2)) == 1 & fea(:, fs_res(2, 3)) == 0);
count_tb(10, 2) = sum(fea(:, fs_res(2, 1)) == 0 & fea(:, fs_res(2, 2)) == 1 & fea(:, fs_res(2, 3)) == 1);
count_tb(11, 2) = sum(fea(:, fs_res(2, 1)) == 1 & fea(:, fs_res(2, 2)) == 0 & fea(:, fs_res(2, 3)) == 0);
count_tb(12, 2) = sum(fea(:, fs_res(2, 1)) == 1 & fea(:, fs_res(2, 2)) == 0 & fea(:, fs_res(2, 3)) == 1);
count_tb(13, 2) = sum(fea(:, fs_res(2, 1)) == 1 & fea(:, fs_res(2, 2)) == 1 & fea(:, fs_res(2, 3)) == 0);
count_tb(14, 2) = sum(fea(:, fs_res(2, 1)) == 1 & fea(:, fs_res(2, 2)) == 1 & fea(:, fs_res(2, 3)) == 1);




