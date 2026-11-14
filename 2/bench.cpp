#include <algorithm>
#include <array>
#include <bit>
#include <chrono>
#include <cstdint>
#include <cstdlib>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <limits>
#include <sstream>
#include <string>
#include <vector>

extern "C" {
std::uint32_t bswap32(std::uint32_t x);
int is_pow2(std::uint64_t x);
std::uint32_t parity32(std::uint32_t x);
std::uint32_t popcount32(std::uint32_t x);
std::uint32_t ctz32(std::uint32_t x);
std::uint32_t clz32(std::uint32_t x);
std::uint64_t next_pow2(std::uint64_t x);
std::int64_t sign_extend(std::uint64_t x, unsigned b);
std::int32_t sat_add32(std::int32_t a, std::int32_t b);
}

int fails = 0;

void check_u(const char* name, std::uint64_t got, std::uint64_t want) {
    if (got != want) {
        if (fails < 10) {
            std::cout << "FAIL " << name << " got " << got << ", want " << want << '\n';
        }
        ++fails;
    }
}

void check_s(const char* name, std::int64_t got, std::int64_t want) {
    if (got != want) {
        if (fails < 10) {
            std::cout << "FAIL " << name << " got " << got << ", want " << want << '\n';
        }
        ++fails;
    }
}

std::int64_t sign_extend_ref(std::uint64_t x, unsigned b) {
    unsigned shift = 64 - b;
    return std::bit_cast<std::int64_t>(x << shift) >> shift;
}

std::int32_t sat_add_ref(std::int32_t a, std::int32_t b) {
    std::int64_t sum = std::int64_t(a) + std::int64_t(b);
    if (sum > INT32_MAX) return INT32_MAX;
    if (sum < INT32_MIN) return INT32_MIN;
    return std::int32_t(sum);
}

std::string decimal(double value) {
    std::ostringstream output;
    output << std::setprecision(17) << value;
    std::string text = output.str();
    std::replace(text.begin(), text.end(), '.', ',');
    return text;
}

int bench(const char* build, const char* baseline_seconds, bool standalone) {
    constexpr std::size_t size = 1u << 22;
    std::vector<std::uint32_t> values(size);
    std::uint32_t state = 2463534242u;

    for (std::uint32_t& value : values) {
        state ^= state << 13;
        state ^= state >> 17;
        state ^= state << 5;
        value = state;
    }

    std::array<double, 5> times{};
    std::ofstream runs;
    std::ofstream summary;
    if (!standalone) {
        runs.open("benchmark-runs.csv", std::ios::app);
        summary.open("benchmark-summary.csv", std::ios::app);
        if (!runs || !summary) {
            std::cerr << "Unable to open benchmark CSV files\n";
            return 1;
        }
    }

    for (std::size_t run = 0; run < times.size(); ++run) {
        std::uint64_t sum = 0;
        auto start = std::chrono::steady_clock::now();

        for (std::uint32_t value : values) {
            sum += popcount32(value);
        }

        times[run] = std::chrono::duration<double>(
            std::chrono::steady_clock::now() - start).count();
        if (standalone) {
            std::cout << "run " << run + 1 << ": " << times[run] << " s, sum " << sum << '\n';
        } else {
            runs << build << ';' << run + 1 << ';' << decimal(times[run]) << ';' << sum << '\n';
        }
    }

    std::sort(times.begin(), times.end());
    double median = times[2];
    double baseline = std::strtod(baseline_seconds, nullptr);
    double speedup = baseline > 0 ? baseline / median : 1.0;

    if (standalone) {
        std::cout << "median " << median << " s, min " << times.front()
                  << ", max " << times.back() << ", ns/element " << median * 1e9 / size << '\n';
    } else {
        summary << build << ';' << decimal(median) << ';' << decimal(times.front()) << ';'
                << decimal(times.back()) << ';' << decimal(median * 1e9 / size) << ';'
                << decimal(speedup) << '\n';

        if (!runs || !summary) {
            std::cerr << "Unable to write benchmark CSV files\n";
            return 1;
        }

        std::cout << std::setprecision(17) << median << '\n';
    }
    return 0;
}

int main(int argc, char** argv) {
    if (argc > 1 && std::string(argv[1]) == "--bench") {
        if (argc == 2) {
            return bench("O2", "0", true);
        }
        if (argc != 4) {
            std::cerr << "Usage: benchmark --bench [<build> <baseline_seconds>]\n";
            return 1;
        }
        return bench(argv[2], argv[3], false);
    }

    check_u("bswap32", bswap32(0x0a0b0c0du), 0x0d0c0b0au);
    check_u("is_pow2", is_pow2(0), 0);
    check_u("is_pow2", is_pow2(1), 1);
    check_u("is_pow2", is_pow2(std::uint64_t{1} << 63), 1);
    check_u("parity32", parity32(7), 1);
    check_u("parity32", parity32(3), 0);
    check_u("popcount32", popcount32(0), 0);
    check_u("popcount32", popcount32(UINT32_MAX), 32);
    check_s("sign_extend", sign_extend(0xf, 4), -1);
    check_s("sign_extend", sign_extend(0x7, 4), 7);
    check_s("sign_extend", sign_extend(0x80, 8), -128);
    check_s("sign_extend", sign_extend(UINT64_MAX, 64), -1);
    check_s("sat_add32", sat_add32(INT32_MAX, 1), INT32_MAX);
    check_s("sat_add32", sat_add32(INT32_MIN, -1), INT32_MIN);
    check_u("next_pow2", next_pow2(0), 1);
    check_u("next_pow2", next_pow2(8), 8);
    check_u("next_pow2", next_pow2(9), 16);

    std::uint32_t x = 1;
    for (int i = 0; i < 200000; ++i) {
        x = x * 1664525u + 1013904223u;
        check_u("popcount32", popcount32(x), __builtin_popcount(x));
        check_u("parity32", parity32(x), __builtin_parity(x));
        check_u("bswap32", bswap32(x), __builtin_bswap32(x));
        if (x != 0) {
            check_u("ctz32", ctz32(x), __builtin_ctz(x));
            check_u("clz32", clz32(x), __builtin_clz(x));
        }
        check_u("is_pow2", is_pow2(x), (x != 0) && ((x & (x - 1)) == 0));
    }

    for (unsigned b = 1; b <= 64; ++b) {
        std::uint64_t value = 0x0f0f0f0f0f0f0f0full;
        check_s("sign_extend", sign_extend(value, b), sign_extend_ref(value, b));
        check_s("sign_extend", sign_extend(~value, b), sign_extend_ref(~value, b));
    }

    std::int32_t edges[] = {INT32_MAX, INT32_MIN, -1, 0, 1, 12345, -12345};
    for (std::int32_t a : edges) {
        for (std::int32_t b : edges) {
            check_s("sat_add32", sat_add32(a, b), sat_add_ref(a, b));
        }
    }

    std::uint64_t powers[] = {0, 1, 2, 3, 7, 8, 9,
                              (std::uint64_t{1} << 31) - 1, std::uint64_t{1} << 31,
                              (std::uint64_t{1} << 62) - 1, std::uint64_t{1} << 62,
                              std::uint64_t{1} << 63};
    for (std::uint64_t value : powers) {
        std::uint64_t result = next_pow2(value);
        bool ok = result >= value && (result & (result - 1)) == 0 &&
                  (value <= 1 || result / 2 < value);
        if (!ok) {
            std::cout << "FAIL next_pow2(" << value << ") = " << result << '\n';
            ++fails;
        }
    }

    if (fails != 0) {
        std::cout << "FAILED: " << fails << '\n';
        return 1;
    }

    std::cout << "OK\n";
    return 0;
}
