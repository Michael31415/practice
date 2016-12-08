function interpolationSpline = FormSpline(points, values, solution)
=======
	pointsCount = length(points);
	segments = points(2 : end) - points(1 : end - 1);
	deltas = (values(2 : end) - values(1 : end - 1)) ./ segments(1 : end);

	interpolationSpline = [solution, deltas - segments .* solution, values(1 : end - 1)];
>>>>>>> Done
end;