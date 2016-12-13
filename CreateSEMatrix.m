function [matrix, splinePoints] = CreateSEMatrix(points, values, condition)
	pointsCount = length(points);
	segments = points(2 : end) - points(1 : end - 1);
	splinePoints = points(2 : end) - segments / 2;
	deltas = (values(2 : end) - values(1 : end - 1)) ./ segments(1 : end);
	matrix = [diag(segments(1 : end - 1)), zeros(pointsCount - 2, 2)] + [zeros(pointsCount - 2, 2), diag(segments(2 : end))] +...
	 3 * [zeros(pointsCount - 2, 1), diag(segments(1: end - 1)) + diag(segments(2 : end)), zeros(pointsCount - 2, 1)];
	matrix = [1, zeros(1, pointsCount - 1); matrix; zeros(1, pointsCount - 1), 1];
	rightSide = [condition(1); 8 * (deltas(2 : end)  - deltas(1 : end - 1)); condition(2)];
	matrix = [matrix, rightSide];
	
	matrix(2, :) -= matrix(1, :) * matrix(2, 1);
	matrix(end - 1, :) -= matrix(end, :) * matrix(end - 1, end - 1);
end;