% -*- mode: octave -*-

pkg load symbolic;
syms t real positive;

global a1;
global h;
global W1;
global W2;
global W;

a1 = -sym(1);
h = sym(1);

W0 = sym(1);
W1 = sym(1);
W2 = sym(1);
W = W0 + W1 + W2 * h;

l = log(1 + W2 * h / W1);
A = 2 * W * a1;
B1 = W * (3 * a1 * h - 1);
B2 = (((a1 * h * W2 - 2 * a1 * W1 - W2) + 2 * a1 * W2 * h) / (4 * W2 - (a1 - a1^2 * h) * W * l)) * ((a1 - a1^2 * h) * W^2 / W2);
B = B1 + B2;
C = 4 * W2;
D = 4 * W1 + 4 * W2 * h;

f0 = 1;
extr = - (A * t + B) / (C * t + D) * f0;

syms tau real;
u = sign(tau) * (- W / 2 * tau + (a1 * h - 1) / (4 * a1) * W);

syms t1 real positive;
global origvu;
origvu = @(f) subs(u, 0) * (subs(f, 0))^2 + ...
         + 2 * a1 * subs(f, 0) * int(subs(u, -h - t) * f, [-h 0]) + ...
         + int(a1^2 * f * int(subs(u, t - t1) * subs(f, t1), t1, [-h 0]), [-h 0]) + ...
         + int((W1 + (h + t) * W2) * f^2, [-h 0]);

global origv;
origv = @(f) (a1 * h - 1) / (4 * a1) * (subs(f, 0))^2 + ...
        + 2 * subs(f, 0) * int( (W / 2 * (h + t) + (a1 * h - 1) / (4 * a1) * W) * a1 * f, [-h 0] ) + ...
        + int(a1 * f * int((W / 2 * (t1 - t) + (a1 * h - 1) / (4 * a1) * W) * a1 * subs(f, t1), t1, [-h 0]), [-h 0]) + ...
        + int((W1 + (h + t) * W2) * f^2, [-h 0]);

v = @(f) (a1 * h - 1) / (4 * a1) * (subs(f, 0))^2 + ...
    + (3 * a1 * h - 1) / 2 * W * subs(f, 0) * int(f, [-h 0]) + ...
    + a1 * W * subs(f, 0) * int(t * f, [-h 0]) + ...
    + (a1^2 * h - a1) / 4 * W * (int(f, [-h 0]))^2 + ...
    + (W1 + h * W2) * int(f^2, [-h 0]) + ...
    + W2 * int(t * f^2, [-h 0]);

global alpha1;
alpha1 = D / B * (B * C - A * D) / C * (B1 * C - A * D) / C^2 * log(D / (D - C * h)) + ...
         + ((B * C + B1 * C - A * D) / C - A * h / 2) * (A * D) / (B * C) * h + (B1 - A * h) / (2 * A);
fprintf("alpha1: %d\n", double(alpha1));
## alpha1 = simplify(alpha1);

function run_test(f)
  global alpha1;
  global origvu;
  global origv;
  fprintf("--- TEST ---\n");
  f
  double(origvu(f))
  double(origv(f))
  r1 = v(f);
  r2 = alpha1 * (subs(f, 0))^2;

  fprintf("numbers: %d <= %d\n", double(r2), double(r1));
  if double(r2) <= double(r1)
    fprintf("True\n");
  else
    fprintf("False\n");
  end
end

run_test(t);
run_test(4 * t^2 / h^2 + 4 * t / h + 1);
run_test(-t);
run_test(-1/(t+2));
run_test(sym(1));
run_test(extr);
