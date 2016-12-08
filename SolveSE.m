function solution = SolveSE(matrix)
	[rows, cols] = size(matrix);
	core = matrix(:, 1 : rows);
	if core == conj(core')
		% for used formulae see Popov's book
		D = zeros(rows, 1);
		S = zeros(rows);
		for i = 1 : rows
			D(i) = sign(core(i, i) - sum(D(1 : i - 1) .* (S(1 : i - 1, i) .* conj(S(1 : i - 1, i)))));
			S(i, i) = sqrt(abs( core(i, i) - sum(D(1 : i - 1) .* (S(1 : i - 1, i) .* conj(S(1 : i - 1, i)))) ));
			for j = i + 1 : rows
				S(i, j) = (core(i, j) - sum(D(1 : i - 1) .* S(1 : i - 1, i) .* S(1 : i - 1, j))) / (conj(S(i, i)) * D(i));
			end;
		end;
		rightSide = matrix(:, rows + 1 : end);
		v = zeros(rows, cols - rows);
		for i = 1 : rows
			v(i, :) = ( rightSide(i, :) - sum(((conj(S(1 : i - 1, i)) .* D(1 : i - 1)) * ones(cols - rows, 1)) .* v(1 : i - 1, :)) ) / (S(i, i) * D(i));
		end;
		solution = zeros(rows, cols - rows);
		for i = rows : -1 : 1
			solution(i, :) = (v(i, :) - sum( (S(i, i + 1 : end) * ones(cols - rows, 1)) .*  solution(i + 1 : end, :)')) / S(i, i);
		end;
	else
		error('Matrix is not hermitian');
	end;
end;