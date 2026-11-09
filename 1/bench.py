import csv
import random
import statistics
import time

from student import matmul

n = 256
rows = []

for run in range(1, 6):
    a = [[random.random() for _ in range(n)] for _ in range(n)]
    b = [[random.random() for _ in range(n)] for _ in range(n)]

    start = time.perf_counter()
    c = matmul(a, b)
    elapsed = time.perf_counter() - start

    rows.append((run, elapsed, 2 * n**3 / elapsed / 1e9))
    print(f"run {run}: {elapsed:.3f} s, {rows[-1][2]:.4f} GFLOPS, c[0][0]={c[0][0]:.3f}")

with open('python-matmul.csv', 'w', newline='') as f:
    writer = csv.writer(f, delimiter=';')
    writer.writerow(['run', 'seconds', 'gflops'])
    writer.writerows((run, str(seconds).replace('.', ','), str(gflops).replace('.', ','))
                     for run, seconds, gflops in rows)

median = statistics.median(row[1] for row in rows)
print(f'median: {median:.3f} s, {2 * n**3 / median / 1e9:.4f} GFLOPS')
print(f'estimate for n=1024: {median * 64:.0f} s')
