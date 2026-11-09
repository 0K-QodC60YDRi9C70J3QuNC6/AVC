import csv

import matplotlib.pyplot as plt

with open('python-matmul.csv', newline='') as f:
    rows = list(csv.DictReader(f, delimiter=';'))

plt.plot([int(r['run']) for r in rows], [float(r['seconds'].replace(',', '.')) for r in rows], 'o-')
plt.xlabel('Run')
plt.ylabel('Time, s')
plt.title('Python: 256 x 256 matrix multiplication')
plt.grid(True)
plt.savefig('python-matmul.png', dpi=150)
