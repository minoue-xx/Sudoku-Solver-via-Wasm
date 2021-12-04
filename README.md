# Webcam Sudoku Solver 
Copyright (c) 2021 Michio Inoue

MATLAB's Sudoku solver is implemented as a form of WebAssembly, 
through "Generate JavaScript Using MATLAB Coder" version 2.0.2 by Geoff McVittie. 
The tool allows you to create JavaScript/WebAssembly libraries from MATLAB projects using MATLAB Coder.

You can find the tool here:
https://jp.mathworks.com/matlabcentral/fileexchange/69973-generate-javascript-using-matlab-coder

The sudoku on webcam image is recognized by classic image processing  techniques and each digit
is recognized by a simple CNN. The solution of the sudoku is overlayed on the original image
and displayed on the web page.

![](./docs/demo_webcam_lowres.gif)

# Implementation

- MATLAB R2021b
- Image Processing Toolbox
- Deep Learning Toolbox
- MATLAB Coder

## Training CNN
The details can be find here [model/trainCNN/trainCNNtoClassifyDigits.mlx](./model/trainCNN/trainCNNtoClassifyDigits.md)
