pkg load symbolic;
syms t real positive;

A0 = -8;
A1 = -1;
H = 2;
T0 = 0;
## PHI = (t+H)^2;
## PHI = sym(1);
## PHI = H + t;
PHI = e^t;
MAX = max(subs(PHI, T0), subs(PHI, T0 - H));
## PHI = 1 + t;
STEPS = 5;
SHOW_ABS = false;

fprintf(" --- Estimate ---\n");
eps = 1e-6;

beta = -A0 - lambertw (abs(A1) * H * e^(-A0 * H)) / H - eps

D = (A0 + beta)^2 - A1^2 * e^(2 * beta * H)
## z_eps = 0.01;
## z = -2 * (A0 + beta) - z_eps;
first_root = - (A0 + beta) + sqrt(D)
second_root = - (A0 + beta) - sqrt(D)
z = second_root + eps
## z = eps

first = 2 * (A0 + beta) + z;
second = first * z * e^(-2 * beta * H) + A1^2;

fprintf("Testing LMI\n");
fprintf("First: %d\n", first);
fprintf("Second: %d\n", second);

if first >= 0
  fprintf("First should be less than zero!\n");
  return
elseif second >= 0
  fprintf("Second should be less than zero!\n");
  return
end

## A1 = A0;

fprintf(" --- Exact solution ---\n");

hf = ezplot(PHI, [T0-H T0]);
set(hf, 'Color', 'black');
if SHOW_ABS
  hf = ezplot(abs(PHI), [T0-H T0]);
  set(hf, 'Color', 'blue');
end
hold on;
prev = PHI;
for i = 1:STEPS
  left = T0 + (i - 1) * H
  right = left + H
  fprintf("t in [%d, %d]:\n", left, right);

  cint = int(A1 * subs(prev, t - H) * e^(-A0 * t));

  val = e^(-A0 * sym(left));
  C = subs(prev, left) * val - subs(cint, left);
  x = simplify(expand((cint + C) * e^(A0 * t)))
  hf = ezplot(x, [left right]);
  set(hf, 'Color', 'black');
  if SHOW_ABS
    hf = ezplot(abs(x), [left right]);
    set(hf, 'Color', 'blue');
  end
  prev = x;
end

gamma = sqrt(1 + H * z);

estimate = gamma * MAX * e^(-beta * t)
hf = ezplot(estimate, [T0 T0+STEPS*H]);
set(hf, 'Color', 'red');

if ~SHOW_ABS
  estimate = -gamma * MAX * e^(-beta * t)
  hf = ezplot(estimate, [T0 T0+STEPS*H]);
  set(hf, 'Color', 'red');
end

title("Сравнение с методом шагов")
axis("tic", "square");
grid on;
