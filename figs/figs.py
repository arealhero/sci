#!/usr/bin/env python3

import numpy as np
import matplotlib.pyplot as plt

N = 3000
MIN = -10
MAX = 10

x = np.linspace(MIN, MAX, N)
y = np.linspace(MIN, MAX, N)

h = 1

fig, ax = plt.subplots()
ax.plot(x, -x, color='black')
ax.plot(x, x, linestyle='--', color='black', label=r'$a_0^2 = a_1^2$')

for k in range(4):
    tol = 0.001
    val = np.pi / h
    t = np.linspace(val * k + tol, val * (k+1) - tol, N)
    xs = t * np.cos(h * t) / np.sin(h * t)
    ys = - t / np.sin(h * t)

    ax.plot(xs, ys, color='black')

ax.set_aspect('equal')
ax.axhline(0, color='black', linewidth=.5)
ax.axvline(0, color='black', linewidth=.5)
ax.set_xlabel(r'$a_0$')
ax.set_ylabel(r'$a_1$')
ax.legend()

plt.show()
