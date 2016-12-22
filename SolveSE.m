function [solution, iterationsElapsed] = SolveSE(matrix, param, precision = 1e-5, maxIterations = 1000)
	[rows, cols] = size(matrix);
	matrix = matrix / (norm(matrix, 1));
	core = diag(ones(rows, 1)) - matrix(:, 1 : rows);
	rightSide = Solve(diag(ones(rows, 1)) - tril(core, -1), matrix(:, rows + 1 : end));
	step = @(t)(Solve(diag(ones(rows, 1)) - tril(core, -1), triu(core) * t) + rightSide);
	approximation = zeros(rows, cols - rows);
	for iterationsElapsed = 1 : maxIterations
		change = step(approximation);
		solution = approximation + param * (change - approximation);
		if param * norm(change - approximation, 1) < precision
			return
		end;
		approximation = solution;
	end;
end;

function solution = Solve(matrix, rightSide, method)
	[rows, cols] = size(rightSide);
	solution = zeros(rows, cols);
	for i = 1 : rows
		solution(i, :) = rightSide(i, :) ./ matrix(i, i);
		rightSide(i : end, :) -= matrix(i : end, i) * solution(i, :);
	end;
end;