/**
 * @copyright 2020 YelloSoft
 */

#include <cstring>
#include <iostream>
#include <sstream>
#include <string>

#include "ios7crypt/ios7crypt.hpp"

static std::vector<int> Xlat() {
    const int bs[53] = {
        0x64, 0x73, 0x66, 0x64, 0x3b, 0x6b, 0x66, 0x6f,
        0x41, 0x2c, 0x2e, 0x69, 0x79, 0x65, 0x77, 0x72,
        0x6b, 0x6c, 0x64, 0x4a, 0x4b, 0x44, 0x48, 0x53,
        0x55, 0x42, 0x73, 0x67, 0x76, 0x63, 0x61, 0x36,
        0x39, 0x38, 0x33, 0x34, 0x6e, 0x63, 0x78, 0x76,
        0x39, 0x38, 0x37, 0x33, 0x32, 0x35, 0x34, 0x6b,
        0x3b, 0x66, 0x67, 0x38, 0x37
    };

    return std::vector<int>(bs, bs + sizeof(bs)/sizeof(int));
}

std::string ios7crypt::Encrypt(uint prng_seed, std::string password) {
    auto xs = Xlat();
    auto seed = int(rand_r(&prng_seed) % 16);

    auto hash = std::stringstream();
    hash.setf(std::ios::dec, std::ios::basefield);
    hash.width(2);
    hash.fill('0');
    hash << seed;

    for (auto &p_char : password) {
        auto p = int(p_char);
        hash.setf(std::ios::hex, std::ios::basefield);
        hash.width(2);
        hash.fill('0');
        hash << int(p ^ xs.at(size_t((seed++) % int(xs.size()))));
    }

    return hash.str();
}

std::optional<std::string> ios7crypt::Decrypt(std::string hash) {
    if (hash.length() < 4 || hash.length() % 2 != 0) {
        return std::nullopt;
    }

    auto xs = Xlat();

    errno = 0;
    auto seed = std::stoi(hash.substr(0, 2), nullptr, 10);

    if (errno != 0) {
        return nullptr;
    }

    auto password = std::stringstream();

    for (size_t i = 2; i < hash.length(); i += 2) {
        errno = 0;
        auto c = std::stoi(hash.substr(i, 2), nullptr, 16);

        if (errno != 0) {
            return std::nullopt;
        }

        password << char(c ^ xs.at(size_t((seed++) % int(xs.size()))));
    }

    return password.str();
}
