% Copyright (c) 2021 Michio Inoue
% This is a script to test the Sudoku Solver for the input from a webcam.
% In order to use webcam please install the following support package.
% MATLAB Support Package for USB Webcams
% https://jp.mathworks.com/matlabcentral/fileexchange/45182-matlab-support-package-for-usb-webcams
%
% Initialize webcam
cam = webcam;
preview(cam);
pause % press any key when webcam is ready to take a snap shot

% take a snapshot
Icam = snapshot(cam);
clear('cam');

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

