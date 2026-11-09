#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstdlib>
#include <iomanip>
#include <iostream>
#include <locale>
#include <vector>

using Matrix = std::vector<double>;
using Clock = std::chrono::steady_clock;

struct DecimalComma : std::numpunct<char> {
    char do_decimal_point() const override { return ','; }
};

Matrix naive(const Matrix& a, const Matrix& b, int n) {
    Matrix c(n * n, 0.0);

    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            for (int k = 0; k < n; ++k) {
                c[i * n + j] += a[i * n + k] * b[k * n + j];
            }
        }
    }

    return c;
}

Matrix add(const Matrix& a, const Matrix& b, double sign = 1.0) {
    Matrix result(a.size());

    for (std::size_t i = 0; i < a.size(); ++i) {
        result[i] = a[i] + sign * b[i];
    }

    return result;
}

Matrix strassen(const Matrix& a, const Matrix& b, int n) {
    if (n <= 64) {
        return naive(a, b, n);
    }

    int h = n / 2;
    Matrix a11(h * h), a12(h * h), a21(h * h), a22(h * h);
    Matrix b11(h * h), b12(h * h), b21(h * h), b22(h * h);

    for (int i = 0; i < h; ++i) {
        for (int j = 0; j < h; ++j) {
            int p = i * h + j;
            a11[p] = a[i * n + j];
            a12[p] = a[i * n + j + h];
            a21[p] = a[(i + h) * n + j];
            a22[p] = a[(i + h) * n + j + h];
            b11[p] = b[i * n + j];
            b12[p] = b[i * n + j + h];
            b21[p] = b[(i + h) * n + j];
            b22[p] = b[(i + h) * n + j + h];
        }
    }

    Matrix m1 = strassen(add(a11, a22), add(b11, b22), h);
    Matrix m2 = strassen(add(a21, a22), b11, h);
    Matrix m3 = strassen(a11, add(b12, b22, -1), h);
    Matrix m4 = strassen(a22, add(b21, b11, -1), h);
    Matrix m5 = strassen(add(a11, a12), b22, h);
    Matrix m6 = strassen(add(a21, a11, -1), add(b11, b12), h);
    Matrix m7 = strassen(add(a12, a22, -1), add(b21, b22), h);

    Matrix c(n * n);
    for (int i = 0; i < h; ++i) {
        for (int j = 0; j < h; ++j) {
            int p = i * h + j;
            c[i * n + j] = m1[p] + m4[p] - m5[p] + m7[p];
            c[i * n + j + h] = m3[p] + m5[p];
            c[(i + h) * n + j] = m2[p] + m4[p];
            c[(i + h) * n + j + h] = m1[p] - m2[p] + m3[p] + m6[p];
        }
    }

    return c;
}

Matrix multiply_strassen(const Matrix& a, const Matrix& b, int n) {
    int padded = 1;
    while (padded < n) {
        padded *= 2;
    }

    Matrix ap(padded * padded, 0.0), bp(padded * padded, 0.0);
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            ap[i * padded + j] = a[i * n + j];
            bp[i * padded + j] = b[i * n + j];
        }
    }

    Matrix cp = strassen(ap, bp, padded), c(n * n);
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            c[i * n + j] = cp[i * padded + j];
        }
    }

    return c;
}

int main() {
    std::cout.imbue(std::locale(std::locale::classic(), new DecimalComma));
    std::cout << "n;method;run;seconds;gflops;maxdiff\n" << std::setprecision(17);

    for (int n : {128, 256, 512, 1024}) {
        Matrix a(n * n), b(n * n);

        for (int i = 0; i < n * n; ++i) {
            a[i] = double(std::rand()) / RAND_MAX;
            b[i] = double(std::rand()) / RAND_MAX;
        }

        Matrix reference = naive(a, b, n);

        for (int method = 0; method < 2; ++method) {
            for (int run = 1; run <= 5; ++run) {
                auto start = Clock::now();
                Matrix c = method ? multiply_strassen(a, b, n) : naive(a, b, n);
                double seconds = std::chrono::duration<double>(Clock::now() - start).count();

                double diff = 0;
                for (std::size_t i = 0; i < c.size(); ++i) {
                    diff = std::max(diff, std::abs(c[i] - reference[i]));
                }

                std::cout << n << ';' << (method ? "strassen" : "naive") << ';' << run << ';'
                          << seconds << ';' << 2.0 * n * n * n / seconds / 1e9 << ';' << diff << '\n';
            }
        }
    }
}
