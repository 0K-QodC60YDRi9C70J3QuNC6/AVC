#!/bin/sh
set -eu

python3 bench.py
python3 plot_python.py

for level in O0 O2 O3; do
    if [ "$level" = O3 ]; then
        g++ -std=c++17 -O3 -march=native matmul.cpp -o /tmp/matmul-O3
    else
        g++ -std=c++17 "-$level" matmul.cpp -o "/tmp/matmul-$level"
    fi

    "/tmp/matmul-$level" > "matmul-$level.csv"

    if [ "$level" = O2 ]; then
        python3 plot_matmul.py "matmul-$level.csv" matmul-orders.png
    else
        python3 plot_matmul.py "matmul-$level.csv" "matmul-orders-$level.png"
    fi
done

g++ -std=c++17 -O2 strassen.cpp -o /tmp/strassen
/tmp/strassen > strassen.csv
python3 plot_strassen.py
