% Copyright (c) 2021 Michio Inoue
% The original is taken from here
% https://jp.mathworks.com/company/newsletters/articles/solving-sudoku-with-matlab.html
% Modified a few lines to C-code gen by MATLAB Coder

function X = Sudoku(X)
% SUDOKU  Solve Sudoku using recursive backtracking.
%   sudoku(X), expects a 9-by-9 array X.
% Fill in all “singletons”.
% C is a cell array of candidate vectors for each cell.
% s is the first cell, if any, with one candidate.
% e is the first cell, if any, with no candidates.
[Cout,s,e] = candidates(X);
while ~isempty(s) && isempty(e)
    X(s) = Cout;
    [Cout,s,e] = candidates(X);
end
% Return for impossible puzzles.
if ~isempty(e)
    return
end
% Recursive backtracking.
% if any(X(:) == 0)
%     Y = X;
%     z = find(X(:) == 0,1);    % The first unfilled cell.
%     for r = [C{z}]            % Iterate over candidates.
%         X = Y;
%         X(z) = r;              % Insert a tentative value.
%         X = Sudoku(X);         % Recursive call.
%         if all(X(:) > 0)       % Found a solution.
%             return
%         end
%     end
% end
% ------------------------------
    function [Cout,s,e] = candidates(X)
        C = cell(9,9);
        L = zeros(9,9);
        tri = @(k) 3*ceil(k/3-1) + (1:3);
        for j = 1:9
            for i = 1:9
                C{i,j} = 0;
                if X(i,j)==0
                    z = 1:9;
                    z(nonzeros(X(i,:))) = 0;
                    z(nonzeros(X(:,j))) = 0;
                    z(nonzeros(X(tri(i),tri(j)))) = 0;
                    C{i,j} = nonzeros(z)';
                    L(i,j) = length(nonzeros(z)');
                end
            end
        end
        %  L = cellfun(@length,C);   % Number of candidates.
        s = find(X==0 & L==1,1);
        e = find(X==0 & L==0,1);

        [row,col] = ind2sub([9,9],s);
        
        if ~isempty(s) && isempty(e)
            Cout = C{row,col};
        else
            Cout = 0;
        end
    end % candidates
end % sudoku