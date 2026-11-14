#include <cstdint>

extern "C" {

unsigned f_and(unsigned x) { return x & 0xffu; }
unsigned f_or(unsigned x) { return x | 1u; }
unsigned f_shl(unsigned x) { return x << 3; }
int f_sar(int x) { return x >> 3; }
unsigned f_xor(unsigned x) { return x ^ (x >> 16); }

int d7(int x) { return x / 7; }
int m7(int x) { return x % 7; }
int divide(int x, int divisor) { return x / divisor; }

void rotate_xor(std::uint32_t& a, std::uint32_t& b, std::uint32_t& c) {
    a ^= b;
    b ^= a;
    a ^= b;
    b ^= c;
    c ^= b;
    b ^= c;
}

void rotate_arithmetic(std::uint32_t& a, std::uint32_t& b, std::uint32_t& c) {
    a += b;
    b = a - b;
    a -= b;
    b += c;
    c = b - c;
    b -= c;
}

void rotate_temporary(std::uint32_t& a, std::uint32_t& b, std::uint32_t& c) {
    std::uint32_t temp = a;
    a = b;
    b = c;
    c = temp;
}

}
