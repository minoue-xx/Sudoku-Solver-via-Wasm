% Copyright (c) 2021 Michio Inoue
% A script to check the functions with the pre-recorded image

% Icam = imread('photoEx4.jpg'); % ver1
Icam = imread('photoEx5.jpg'); % ver2

% prepare image data
N = 750;
Icam = imresize(Icam,[N,N]);
img = permute(Icam,[3,2,1]);

% get solution
out = solveSudokuImage_codegen(img(:));

% postprocess the outout
out = reshape(out,[4,N,N]);
out = permute(out,[3,2,1]);
out = out(:,:,1:3); 

% show the result
montage({Icam,out})