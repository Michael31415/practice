function interpolationSpline = FormSpline(points, values, solution)
	pointsCount = length(points);
	segments = points(2 : end) - points(1 : end - 1);
	deltas = (values(2 : end) - values(1 : end - 1)) ./ segments(1 : end);
	solution = [solution(end); solution];

	interpolationSpline = [solution / 2, zeros(pointsCount, 1), values];
	interpolationSpline(:, 2) = [deltas(1) - 0.125 * segments(1) * (3 * solution(1) + solution(2));...
	 deltas(1 : end) + 0.125 * segments(1 : end) .* (solution(1 : end - 1) + 3 * solution(2 : end))];
end;