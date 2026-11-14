#include <bit>
#include <cstdint>
#include <limits>

extern "C" {

std::uint32_t bswap32(std::uint32_t x) {
    return ((x & 0x000000ffu) << 24) |
           ((x & 0x0000ff00u) << 8) |
           ((x & 0x00ff0000u) >> 8) |
           ((x & 0xff000000u) >> 24);
}

int is_pow2(std::uint64_t x) {
    return (x != 0) & ((x & (x - 1)) == 0);
}

std::uint32_t parity32(std::uint32_t x) {
    x ^= x >> 16;
    x ^= x >> 8;
    x ^= x >> 4;
    x ^= x >> 2;
    x ^= x >> 1;
    return x & 1u;
}

std::uint32_t popcount32(std::uint32_t x) {
    x = x - ((x >> 1) & 0x55555555u);
    x = (x & 0x33333333u) + ((x >> 2) & 0x33333333u);
    x = (x + (x >> 4)) & 0x0f0f0f0fu;
    return (x * 0x01010101u) >> 24;
}

std::uint32_t ctz32(std::uint32_t x) {
    static constexpr std::uint8_t positions[32] = {
        0, 1, 28, 2, 29, 14, 24, 3,
        30, 22, 20, 15, 25, 17, 4, 8,
        31, 27, 13, 23, 21, 19, 16, 7,
        26, 12, 18, 6, 11, 5, 10, 9
    };

    std::uint32_t lowest = x & (0u - x);
    std::uint32_t index = (lowest * 0x077cb531u) >> 27;
    std::uint32_t zero_mask = 0u - std::uint32_t(x == 0);

    return (std::uint32_t(positions[index]) & ~zero_mask) | (32u & zero_mask);
}

std::uint32_t clz32(std::uint32_t x) {
    std::uint32_t zero = std::uint32_t(x == 0);
    std::uint32_t count = 0;

    std::uint32_t shift = std::uint32_t((x >> 16) == 0) << 4;
    count += shift;
    x <<= shift;
    shift = std::uint32_t((x >> 24) == 0) << 3;
    count += shift;
    x <<= shift;
    shift = std::uint32_t((x >> 28) == 0) << 2;
    count += shift;
    x <<= shift;
    shift = std::uint32_t((x >> 30) == 0) << 1;
    count += shift;
    x <<= shift;
    count += std::uint32_t((x >> 31) == 0);

    return count + zero;
}

std::uint64_t next_pow2(std::uint64_t x) {
    x -= std::uint64_t(x != 0);
    x |= x >> 1;
    x |= x >> 2;
    x |= x >> 4;
    x |= x >> 8;
    x |= x >> 16;
    x |= x >> 32;
    return x + 1;
}

std::int64_t sign_extend(std::uint64_t x, unsigned b) {
    std::uint64_t mask = UINT64_MAX >> (64 - b);
    std::uint64_t sign = std::uint64_t{1} << (b - 1);
    std::uint64_t result = ((x & mask) ^ sign) - sign;
    return std::bit_cast<std::int64_t>(result);
}

std::int32_t sat_add32(std::int32_t a, std::int32_t b) {
    std::int64_t sum = std::int64_t(a) + std::int64_t(b);
    std::uint64_t upper_mask = 0u - std::uint64_t(sum > INT32_MAX);
    std::uint64_t lower_mask = 0u - std::uint64_t(sum < INT32_MIN);
    std::uint64_t middle_mask = ~(upper_mask | lower_mask);

    std::uint64_t result = (std::bit_cast<std::uint64_t>(sum) & middle_mask) |
                           (std::uint64_t(INT32_MAX) & upper_mask) |
                           (std::bit_cast<std::uint64_t>(std::int64_t(INT32_MIN)) & lower_mask);
    return std::int32_t(std::bit_cast<std::int64_t>(result));
}

int is_pow2_branchy(std::uint64_t x) {
    if (x == 0) {
        return 0;
    }

    while (x > 1) {
        if (x & 1u) {
            return 0;
        }
        x >>= 1;
    }

    return 1;
}

std::int32_t sat_add32_branchy(std::int32_t a, std::int32_t b) {
    std::int64_t sum = std::int64_t(a) + std::int64_t(b);

    if (sum > INT32_MAX) {
        return INT32_MAX;
    }
    if (sum < INT32_MIN) {
        return INT32_MIN;
    }

    return std::int32_t(sum);
}

}
