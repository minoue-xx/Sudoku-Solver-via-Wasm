# Webcam Sudoku Solver 
Copyright (c) 2021 Michio Inoue

   -  [Sudoku Solver, Live WebCam (PC only)](https://minoue-xx.github.io/Sudoku-Solver-via-Wasm/index.html) 
   -  [Sudoku Solver, Static Image (for mobile)](https://minoue-xx.github.io/Sudoku-Solver-via-Wasm/index_mobile.html) 

The sudoku on webcam image is recognized by classic image processing  techniques and each digit
is recognized by a simple CNN. The solution of the sudoku is overlayed on the original image
and displayed on the web page.

日本語の解説はこちら
- 全体像: [docs/JP_SudokuSolverOverview.md](docs/JP_SudokuSolverOverview.md)
- モデル学習: [docs/JP_trainCNNtoClassifyDigits.md](docs/JP_trainCNNtoClassifyDigits.md)

![](./docs/demo_webcam_lowres.gif)

# Products used in development

- MATLAB R2021b
- Image Processing Toolbox
- Deep Learning Toolbox
- MATLAB Coder

MATLAB's Sudoku solver is implemented as a form of WebAssembly, 
through "Generate JavaScript Using MATLAB Coder" version 2.0.2 by Geoff McVittie. 
The tool allows you to create JavaScript/WebAssembly libraries from MATLAB projects using MATLAB Coder.

You can find the tool here:
https://jp.mathworks.com/matlabcentral/fileexchange/69973-generate-javascript-using-matlab-coder


## Training CNN
The details can be find here [model/trainCNN/trainCNNtoClassifyDigits.mlx](./model/trainCNN/trainCNNtoClassifyDigits.md)
