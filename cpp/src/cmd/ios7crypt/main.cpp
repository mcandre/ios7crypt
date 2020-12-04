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

#include "ios7crypt/ios7crypt.hpp"

#ifdef __SANITIZE_ADDRESS__
static bool PropReversible(std::string password) {
    auto prng_seed = uint(time(nullptr));
    auto hash = ios7crypt::Encrypt(prng_seed, password);
    auto password2 = ios7crypt::Decrypt(hash);

    if (!password2.has_value()) {
        return false;
    }

    return password.compare(password2.value()) == 0;
}

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size) {
    char password[12];
    auto password_sz = sizeof(password);
    auto password_len = Size;

    if (password_len > password_sz - 1) {
        password_len = password_sz - 1;
    }

    memcpy(password, Data, password_len);
    password[password_len] = '\0';
    PropReversible(std::string(password));
    return 0;
}
#else
static void Usage(std::vector<std::string_view> args) {
    std::cout << "Usage: " << args.at(0) << " [options]" << std::endl << std::endl <<
        "-e <password>" << std::endl <<
        "-d <hash>" << std::endl;
}

int main(const int argc, const char **argv) {
    uint prng_seed = uint(time(nullptr));

    auto args = std::vector<std::string_view>{argv, argv+argc};

    if (args.size() < 2) {
        Usage(args);
        exit(EXIT_FAILURE);
    }

    if (args.at(1).compare("-h") == 0) {
        Usage(args);
        exit(EXIT_SUCCESS);
    }

    if (args.at(1).compare("-e") == 0) {
        std::string password;

        try {
            password = std::string(args.at(2));
        } catch (const std::out_of_range) {
            Usage(args);
            return EXIT_FAILURE;
        }

        std::cout << ios7crypt::Encrypt(prng_seed, std::string(args.at(2))) << std::endl;
        return EXIT_SUCCESS;
    }

    if (args.at(1).compare("-d") == 0) {
        std::string hash;

        try {
            hash = std::string(args.at(2));
        } catch (const std::out_of_range) {
            Usage(args);
            exit(EXIT_FAILURE);
        }

        auto password = ios7crypt::Decrypt(std::string(args.at(2)));

        if (!password.has_value()) {
            std::cerr << "error during decryption" << std::endl;
            return EXIT_FAILURE;
        }

        std::cout << password.value() << std::endl;
        return EXIT_SUCCESS;
    }

    Usage(args);
    exit(EXIT_FAILURE);
}
#endif
