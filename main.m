function [] = main(func, points, plotPoints, condition)
	if ~exist('func')
		func = @(t)(sin(t^2));
	end;
	if ~exist('points')
		points = sqrt(0 : 0.05 : 1) * 5;
	end;
	if ~exist('plotPoints')
		plotPoints = 0 : 0.001 : 5;
	end;
	if ~exist('condition')
		condition = 0;
	end;

	[interpolationSpline, splineFunc] = CreateSpline(points, func, condition);
	splineVal = @(t)(splineFunc(0, t));
	splineDerivative = @(t)(splineFunc(1, t));
	splineSecondDerivative = @(t)(splineFunc(2, t));

	figure('units','normalized','outerposition',[0 0 1 1], 'paperorientation', 'landscape');
	if strcmp(class(func), 'function_handle')
		plot(plotPoints, arrayfun(func, plotPoints), 'k--', plotPoints, arrayfun(splineVal, plotPoints), 'k', points, arrayfun(func, points), 'kx');
		legend('interpolated function', 'interpolation spline', 'pivot points', 'location', 'southoutside');
	else
		plot(plotPoints, arrayfun(splineVal, plotPoints), 'k', points, arrayfun(func, points), 'kx');
		legend('interpolation spline', 'pivot points', 'location', 'southoutside');
	end;
	title(sprintf('Maximal deviation: %e', max(abs(arrayfun(func, points) - arrayfun(splineVal, points)))));
	grid minor;
	print -dpdf ./result.pdf;
	figure('units','normalized','outerposition',[0 0 1 1], 'paperorientation', 'landscape');
	plot(plotPoints, arrayfun(splineDerivative, plotPoints), 'k--', plotPoints, arrayfun(splineSecondDerivative, plotPoints), 'k');
	legend('spline first derivative', 'spline second derivative', 'location', 'southoutside');
	grid minor;
	print -dpdf -append ./result.pdf;
end;