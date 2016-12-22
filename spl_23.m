function res = spl_23(X, u, T)
	if isrow(X)
		X = X';
	end;
	if isrow(u)
		u = u';
	end;

	n = length(X) + 1;
	u = [u; u(2)];
	h = X(2 : end) - X(1 : end - 1);
	X1 = X(2 : end) - h / 2;
	h = [h; h(1)];
	d = (u(2 : end) - u(1 : end - 1)) ./ h(1 : end);
	m = [diag(h(1 : end - 1)), zeros(n - 2, 2)] + [zeros(n - 2, 2), diag(h(2 : end))] + 3 * [zeros(n - 2, 1), diag(h(1: end - 1)) + diag(h(2 : end)), zeros(n - 2, 1)];
	m(:, [2, end - 1]) += m(:, [end, 1]);
	m = m(:, 2 : end - 1);
	b = [8 * (d(2 : end) - d(1 : end - 1))];
	m = [m, b];

	[r, c] = size(m);
	m = m / (norm(m, 1));
	core = diag(ones(r, 1)) - m(:, 1 : r);
	b = solve(diag(ones(r, 1)) - tril(core, -1), m(:, r + 1 : end));
	next = @(t)(solve(diag(ones(r, 1)) - tril(core, -1), triu(core) * t) + b);
	app = zeros(r, c - r);
	for i = 1 : 1000
		t = next(app);
		s = app + 1 * (t - app);
		if norm(t - app, 1) < 1e-5
			break
		end;
		app = s;
	end;

	n = n - 1;
	u = u(1 : end - 1);
	h = X(2 : end) - X(1 : end - 1);
	d = (u(2 : end) - u(1 : end - 1)) ./ h(1 : end);
	s = [s(end); s];

	spl = [s / 2, zeros(n, 1), u];
	spl(:, 2) = [d(1) - 0.125 * h(1) * (3 * s(1) + s(2));...
	 d(1 : end) + 0.125 * h(1 : end) .* (s(1 : end - 1) + 3 * s(2 : end))];
	splineFunction = @(t)(eval(X, X1, spl, t));
	res = arrayfun(splineFunction, T);
end;

function s = solve(m, b)
	[r, c] = size(b);
	s = zeros(r, c);
	for i = 1 : r
		s(i, :) = b(i, :) ./ m(i, i);
		b(i : end, :) -= m(i : end, i) * s(i, :);
	end;
end;

function y = eval(X, X1, spl, t)
	i = max([0; find((t - X1) >= 0)]) + 1;
	r = spl(i, :);
	t1 = t - X(i);
	p = t1 .^ (length(r) - 1 : -1 : 0);
	y = sum(r(1 : length(p)) .* p );
end;