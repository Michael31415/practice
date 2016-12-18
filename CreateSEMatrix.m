function [matrix, splinePoints] = CreateSEMatrix(points, values, condition)
	pointsCount = length(points);
	segments = points(2 : end) - points(1 : end - 1);
	splinePoints = points(2 : end) - segments / 2;
	deltas = (values(2 : end) - values(1 : end - 1)) ./ segments(1 : end);
	matrix = [diag(segments(2 : end)), zeros(pointsCount - 2, 2)] + [zeros(pointsCount - 2, 2), diag(segments(1 : end - 1))] +...
	 3 * [zeros(pointsCount - 2, 1), diag(segments(1: end - 1)) + diag(segments(2 : end)), zeros(pointsCount - 2, 1)];
	matrix = [3, 1, zeros(1, pointsCount - 2); matrix; zeros(1, pointsCount - 2), 1, 3];
	rightSide = [4 * deltas(1) - segments(1) * condition(1);...
	 4 * (deltas(2 : end) .* segments(1 : end - 1)  + deltas(1 : end - 1) .* segments(2 : end));...
	 4 * deltas(end) + segments(end) * condition(2)];
	matrix = [matrix, rightSide];
end;