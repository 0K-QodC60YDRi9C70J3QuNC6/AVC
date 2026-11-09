#include <algorithm>
#include <chrono>
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

void multiply(const Matrix& a, const Matrix& b, Matrix& c, int n, int method) {
    switch (method) {
    case 0:
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < n; ++j) {
                for (int k = 0; k < n; ++k) {
                    c[i * n + j] += a[i * n + k] * b[k * n + j];
                }
            }
        }
        break;
    case 1:
        for (int i = 0; i < n; ++i) {
            for (int k = 0; k < n; ++k) {
                for (int j = 0; j < n; ++j) {
                    c[i * n + j] += a[i * n + k] * b[k * n + j];
                }
            }
        }
        break;
    case 2:
        for (int j = 0; j < n; ++j) {
            for (int i = 0; i < n; ++i) {
                for (int k = 0; k < n; ++k) {
                    c[i * n + j] += a[i * n + k] * b[k * n + j];
                }
            }
        }
        break;
    case 3:
        for (int j = 0; j < n; ++j) {
            for (int k = 0; k < n; ++k) {
                for (int i = 0; i < n; ++i) {
                    c[i * n + j] += a[i * n + k] * b[k * n + j];
                }
            }
        }
        break;
    case 4:
        for (int k = 0; k < n; ++k) {
            for (int i = 0; i < n; ++i) {
                for (int j = 0; j < n; ++j) {
                    c[i * n + j] += a[i * n + k] * b[k * n + j];
                }
            }
        }
        break;
    case 5:
        for (int k = 0; k < n; ++k) {
            for (int j = 0; j < n; ++j) {
                for (int i = 0; i < n; ++i) {
                    c[i * n + j] += a[i * n + k] * b[k * n + j];
                }
            }
        }
    }
}

int main() {
    const char* names[] = {"ijk", "ikj", "jik", "jki", "kij", "kji"};

    std::cout.imbue(std::locale(std::locale::classic(), new DecimalComma));
    std::cout << "n;method;run;seconds;gflops;control\n" << std::setprecision(17);

    for (int n : {128, 256, 384, 512}) {
        Matrix a(n * n), b(n * n), c(n * n);

        for (int i = 0; i < n * n; ++i) {
            a[i] = double(std::rand()) / RAND_MAX;
            b[i] = double(std::rand()) / RAND_MAX;
        }

        for (int method = 0; method < 6; ++method) {
            for (int run = 1; run <= 5; ++run) {
                std::fill(c.begin(), c.end(), 0.0);

                auto start = Clock::now();
                multiply(a, b, c, n, method);
                double seconds = std::chrono::duration<double>(Clock::now() - start).count();

                std::cout << n << ';' << names[method] << ';' << run << ';' << seconds << ';'
                          << 2.0 * n * n * n / seconds / 1e9 << ';' << c[7 * n + 7] << '\n';
            }
        }
    }
}
