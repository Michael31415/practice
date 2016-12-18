function interpolationSpline = FormSpline(points, values, solution)
	pointsCount = length(points);
	segments = points(2 : end) - points(1 : end - 1);
	deltas = (values(2 : end) - values(1 : end - 1)) ./ segments(1 : end);

	interpolationSpline = [zeros(pointsCount, 1), solution, values];
	interpolationSpline(:, 1) = [(2 * deltas(1) - 0.5 * (3 * solution(1) + solution(2))) / segments(1);...
	(0.5 * (solution(1 : end - 1) + 3 * solution(2 : end)) - 2 * deltas) ./ segments];
end;