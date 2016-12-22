function [matrix, splinePoints] = CreateSEMatrix(points, values)
	pointsCount = length(points) + 1;
	values = [values; values(2)];
	segments = points(2 : end) - points(1 : end - 1);
	splinePoints = points(2 : end) - segments / 2;
	segments = [segments; segments(1)];
	deltas = (values(2 : end) - values(1 : end - 1)) ./ segments(1 : end);
	matrix = [diag(segments(1 : end - 1)), zeros(pointsCount - 2, 2)] + [zeros(pointsCount - 2, 2), diag(segments(2 : end))] +...
	 3 * [zeros(pointsCount - 2, 1), diag(segments(1: end - 1)) + diag(segments(2 : end)), zeros(pointsCount - 2, 1)];
	matrix(:, [2, end - 1]) += matrix(:, [end, 1]);
	matrix = matrix(:, 2 : end - 1);
	rightSide = [8 * (deltas(2 : end) - deltas(1 : end - 1))];
	matrix = [matrix, rightSide];
end;