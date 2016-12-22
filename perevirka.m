function [] = perevirka(func, X, T)
	if ~exist('func')
		func = @(t)(t * (1 - t));
	end;
	if ~exist('X')
		X = 0:0.1:1;
	end;
	if ~exist('T')
		T = 0 : 0.001 : 1;
	end;

	u = arrayfun(func, X);
	res = spl_23(X, u, T);

	plot(T, arrayfun(func, T), 'm', T, res, 'r', X, u, 'kx');
	legend('interpolyovana funciya', 'spline', 'X');
	title(sprintf('Rasnica norm %e', max(abs(arrayfun(func, T) - res))));
	print -dpdf ./result.pdf;
end;