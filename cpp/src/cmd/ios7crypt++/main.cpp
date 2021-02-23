/**
 * @copyright 2020 YelloSoft
 */

#include "main.hpp"

#include <cstring>

#ifdef __SANITIZE_ADDRESS
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#endif

#include <iostream>
#include <sstream>
#include <string>
#include <string_view>
#include <vector>

#include "ios7crypt++/ios7crypt++.hpp"

#ifdef __SANITIZE_ADDRESS__
static bool PropReversible(const std::string &password) {
    const auto prng_seed = uint(time(nullptr));
    const auto hash = ios7crypt::Encrypt(prng_seed, password);
    const auto password2 = ios7crypt::Decrypt(hash);

    if (!password2.has_value()) {
        return false;
    }

    return password.compare(password2.value()) == 0;
}

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size) {
    char password_cstr[12];
    const auto password_cstr_sz = sizeof(password_cstr);
    auto password_cstr_len = Size;

    if (password_cstr_len > password_cstr_sz - 1) {
        password_cstr_len = password_cstr_sz - 1;
    }

    memcpy(password_cstr, Data, password_cstr_len);
    password_cstr[password_cstr_len] = '\0';

    const auto &password = std::string(password_cstr);
    PropReversible(password);
    return 0;
}
#else
static void Usage(std::vector<std::string_view> args) {
    std::cout << "Usage: " << args.at(0) << " [options]" << std::endl << std::endl <<
        "-e <password>" << std::endl <<
        "-d <hash>" << std::endl;
}

int main(int argc, const char **argv) {
    const uint prng_seed = uint(time(nullptr));
    const auto args = std::vector<std::string_view>{argv, argv+argc};

    if (args.size() < 2) {
        Usage(args);
        exit(EXIT_FAILURE);
    }

    if (args.at(1).compare("-h") == 0) {
        Usage(args);
        exit(EXIT_SUCCESS);
    }

    if (args.at(1).compare("-e") == 0) {
        try {
            const auto &password = std::string(args.at(2));

            std::cout << ios7crypt::Encrypt(prng_seed, password) << std::endl;
            return EXIT_SUCCESS;
        } catch (const std::out_of_range) {
            Usage(args);
            return EXIT_FAILURE;
        }
    }

    if (args.at(1).compare("-d") == 0) {
        try {
            const auto &hash = std::string(args.at(2));

            const auto password = ios7crypt::Decrypt(hash);

            if (!password.has_value()) {
                std::cerr << "error during decryption" << std::endl;
                return EXIT_FAILURE;
            }

            std::cout << password.value() << std::endl;
            return EXIT_SUCCESS;
        } catch (const std::out_of_range) {
            Usage(args);
            exit(EXIT_FAILURE);
        }
    }

    Usage(args);
    exit(EXIT_FAILURE);
}
#endif
