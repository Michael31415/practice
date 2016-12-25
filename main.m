function [] = main(func, points, plotPoints, condition)
	if ~exist('func')
		func = @(t)(sin(2 * t) * sign(sin(t)));
	end;
	if ~exist('points')
		points = 0 : 0.1 : 10;
	end;
	if ~exist('plotPoints')
		plotPoints = 0 : 0.01 : 10;
	end;
	if ~exist('condition')
		condition = [0, 0];
	end;

	[interpolationSpline, splineFunc] = CreateSpline(points, func, condition);
	splineVal = @(t)(splineFunc(0, t));
	splineDerivative = @(t)(splineFunc(1, t));
	splineSecondDerivative = @(t)(splineFunc(2, t));

	figure('units','normalized','outerposition',[0 0 1 1], 'paperorientation', 'landscape');
	if strcmp(class(func), 'function_handle')
		plot(plotPoints, arrayfun(func, plotPoints), 'k--', plotPoints, arrayfun(splineVal, plotPoints), 'k', points, arrayfun(func, points), 'kx');
		legend('interpolated function', 'interpolation spline', 'pivot points', 'location', 'southoutside');
		title(sprintf('Maximal deviation: %e', max(abs(arrayfun(func, plotPoints) - arrayfun(splineVal, plotPoints)))));
	else
		plot(plotPoints, arrayfun(splineVal, plotPoints), 'k', points, func, 'kx');
		legend('interpolation spline', 'pivot points', 'location', 'southoutside');
	end;
	grid minor;
	print -dpdf ./result.pdf;
	figure('units','normalized','outerposition',[0 0 1 1], 'paperorientation', 'landscape');
	plot(plotPoints, arrayfun(splineDerivative, plotPoints), 'k--', plotPoints, arrayfun(splineSecondDerivative, plotPoints), 'k');
	legend('spline first derivative', 'spline second derivative', 'location', 'southoutside');
	grid minor;
	print -dpdf -append ./result.pdf;
end;