function [interpolationSpline, splineFunction] = CreateSpline(points, func, condition)
	if strcmp(class(func), 'function_handle')
		values = arrayfun(func, points);
	elseif length(func) == length(points)
		values = func;
	else
		error('Unknown format of input argument func.');
	end;
	if isrow(points)
		points = points';
	end;
	if isrow(values)
		values = values';
	end;
	matrix = CreateSEMatrix(points, values, condition);
	solution = SolveSE(matrix);
	interpolationSpline = FormSpline(points, values, solution);
	splineFunction = @(derivative, t)(EvaluateSpline(points, interpolationSpline, derivative, t));
end;

function result = EvaluateSpline(points, interpolationSpline, derivative, t)
	[row, relativeValue] = SelectRow(points, interpolationSpline, t);
	if row == 0
		result = 0;
		return;
	end;
	coefficients = EvaluateCoefficients(length(row), derivative);
	powers = relativeValue .^ (length(row) - derivative - 1 : -1 : 0);
	result = sum(row(1 : length(powers)) .* powers .* coefficients(1 : length(powers)));
end;

function coefficients = EvaluateCoefficients(rowLength, derivative)
	if derivative == 0
		coefficients = ones(1, rowLength);
		return;
	end;
	coefficients = prod((ones(derivative, 1) * (rowLength - 1 : -1 : 0)) - ((0 : derivative - 1)' * ones(1, rowLength)), 1);
end;

function [row, relativeValue] = SelectRow(points, interpolationSpline, t)
	if t < points(1)
		row = 1;
		relativeValue = 0;
		return;
	end;
	if t >= points(end)
		row = interpolationSpline(end, :);
		relativeValue = t - points(end - 1);
		return;
	end;

	points = t - points;
	interpolationSpline = interpolationSpline(points >= 0, :);
	row = interpolationSpline(end, :);
	points = points(points >= 0);
	relativeValue = points(end);
end;