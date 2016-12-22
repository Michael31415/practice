function [interpolationSpline, splineFunction] = CreateSpline(points, func)
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

	[matrix, splinePoints] = CreateSEMatrix(points, values);
	[solution, it] = SolveSE(matrix, 1);
	interpolationSpline = FormSpline(points, values, solution);
	splineFunction = @(derivative, t)(EvaluateSpline(points, splinePoints, interpolationSpline, derivative, t));
end;

function result = EvaluateSpline(points, splinePoints, interpolationSpline, derivative, t)
	[row, relativeValue] = SelectRow(points, splinePoints, interpolationSpline, t);
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

function [row, relativeValue] = SelectRow(points, splinePoints, interpolationSpline, t)
	index = max([1; find((t - splinePoints) >= 0)]);
	row = interpolationSpline(index, :);
	relativeValue = t - points(index);
end;