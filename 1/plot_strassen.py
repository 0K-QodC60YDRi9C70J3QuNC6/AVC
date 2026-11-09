import csv
import statistics

import matplotlib.pyplot as plt

data = {}

with open('strassen.csv', newline='') as f:
    for row in csv.DictReader(f, delimiter=';'):
        data.setdefault((row['method'], int(row['n'])), []).append(float(row['seconds'].replace(',', '.')))

for method in ['naive', 'strassen']:
    sizes = sorted(n for m, n in data if m == method)
    plt.plot(sizes, [statistics.median(data[(method, n)]) for n in sizes], 'o-', label=method)

plt.xscale('log', base=2)
plt.yscale('log')
plt.xlabel('Matrix size n')
plt.ylabel('Median time, s')
plt.legend()
plt.grid(True, which='both')
plt.tight_layout()
plt.savefig('strassen.png', dpi=150)
