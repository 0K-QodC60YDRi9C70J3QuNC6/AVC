import csv
import statistics
import sys

import matplotlib.pyplot as plt

source = sys.argv[1] if len(sys.argv) > 1 else 'matmul-O2.csv'
target = sys.argv[2] if len(sys.argv) > 2 else 'matmul-orders.png'
data = {}

with open(source, newline='') as f:
    for row in csv.DictReader(f, delimiter=';'):
        data.setdefault((row['method'], int(row['n'])), []).append(float(row['seconds'].replace(',', '.')))

for method in ['ijk', 'ikj', 'jik', 'jki', 'kij', 'kji']:
    sizes = sorted(n for m, n in data if m == method)
    plt.plot(sizes, [statistics.median(data[(method, n)]) for n in sizes], marker='o', label=method)

plt.xscale('log')
plt.yscale('log')
plt.xlabel('Matrix size n')
plt.ylabel('Median time, s')
plt.legend()
plt.grid(True, which='both')
plt.tight_layout()
plt.savefig(target, dpi=150)
