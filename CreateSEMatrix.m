<<<<<<< 57584966ca2be321d08b458403e5f791a1d7e140
function matrix = CreateSEMatrix(points, values, leftCondition)
	pointsCount = length(points);
	segments = points(2 : end) - points(1 : end - 1);
	deltas = (values(2 : end) - values(1 : end - 1)) ./ segments(1 : end);
	matrix = diag(segments) + diag(segments(2: end), 1);
	matrix = matrix(1 : end - 1, :);
	matrix = [1, zeros(1, pointsCount - 2); matrix];
	rightSide = [leftCondition; deltas(2 : end)  - deltas(1 : end - 1)];
	matrix = [matrix, rightSide];
	for i = 1 : pointsCount - 2
		matrix(i, :) += matrix(i + 1, :) * matrix(i + 1, i) / matrix(i + 1, i + 1);
	end;
>>>>>>> Done
end;