function solution = SolveSE(matrix)
	[rows, cols] = size(matrix);
	core = matrix(:, 1 : rows);
	mask = diag(ones(1, rows)) + diag(ones(1, rows - 1), 1) + diag(ones(1, rows - 1), -1);
	if max(abs(core - core .* mask)) < 1e-10
		% for used formulae see Popov's book
		rightSide = matrix(:, rows + 1 : end);
		gammas = deltas = zeros(rows + 1, cols - rows);
		for i = rows : -1 : 2
			gammas(i, :) = -matrix(i, i - 1) ./ (matrix(i, i) + gammas(i + 1, :) * matrix(i, i + 1));
			deltas(i, :) = (rightSide(i, :) - matrix(i, i + 1) .* deltas(i + 1, :)) ./ (matrix(i, i) + gammas(i + 1, :) * matrix(i, i + 1));
		end;
		solution = zeros(rows, cols - rows);
		solution(1, :) = (rightSide(1, :) - matrix(1, 2) * deltas(2, :)) ./ (matrix(1, 1) + gammas(2, :) * matrix(1, 2));
		for i = 2 : rows
			solution(i, :) = gammas(i, :) .* solution(i - 1, :) + deltas(i, :); 
		end;
	else
		error('Matrix is not tridiagonal');
	end;
end;