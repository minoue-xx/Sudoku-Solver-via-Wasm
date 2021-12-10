% Copyright (c) 2021 Michio Inoue
% A function generates an image with a solution overlayed to the original
% input image
function I = solution2image_codegen(M,Msol) %#codegen
% M: Sudoku puzzle (9x9)
% M_sol: Solution of the puzzle (9x9)
% I: Image of solution (digits are placed where the puzzle does not have
% digits)

% A image of each digits are pre-saved to mat file.
digits = coder.load('digitsSet.mat','digits');
I = true(180);

for k = 1:9
    for j = 1:9
        if ~M(k,j)
            if Msol(k,j) == 0
                tmp = digits.digits(:,:,10);
            else
                tmp = digits.digits(:,:,Msol(k,j));
            end
            I(20*(k-1)+1:20*k,20*(j-1)+1:20*j) = tmp;
        end
    end
end
