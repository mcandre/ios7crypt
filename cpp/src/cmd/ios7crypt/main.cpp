/**
 * @copyright 2020 YelloSoft
 */

#include "main.hpp"

#include <cstring>
#include <iostream>
#include <sstream>
#include <string>

#ifdef __SANITIZE_ADDRESS__
bool PropReversible(std::string password) {
    auto prng_seed = uint(time(nullptr));
    auto hash = ios7crypt::Encrypt(prng_seed, password);
    auto password2 = ios7crypt::Decrypt(hash);

    if (!password2.has_value()) {
        return false;
    }

    return password.compare(password2.value()) == 0;
}

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size) {
    auto len = Size;

    if (len > 11) {
        len = 11;
    }

    char password_buf[12];
    memset(password_buf, 0, sizeof(password_buf));
    memcpy(password_buf, Data, len);
    PropReversible(std::string(password_buf));
    return 0;
}
#else
void Usage(const char **argv) {
    std::cout << "Usage: " << argv[0] << " [options]" << std::endl << std::endl <<
        "-e <password>" << std::endl <<
        "-d <hash>" << std::endl;
}

int main(const int argc, const char **argv) {
    uint prng_seed = uint(time(nullptr));

    if (argc < 2) {
        Usage(argv);
        exit(EXIT_FAILURE);
    }

    if (strcmp(argv[1], "-h") == 0) {
        Usage(argv);
        exit(EXIT_SUCCESS);
    }

    if (strcmp(argv[1], "-e") == 0) {
        if (argc < 3) {
            Usage(argv);
        }

        std::cout << ios7crypt::Encrypt(prng_seed, argv[2]) << std::endl;
        return EXIT_SUCCESS;
    }

    if (strcmp(argv[1], "-d") == 0) {
        if (argc < 3) {
            Usage(argv);
            exit(EXIT_FAILURE);
        }

        auto password = ios7crypt::Decrypt(argv[2]);

        if (!password.has_value()) {
            std::cerr << "error during decryption" << std::endl;
            return EXIT_FAILURE;
        }

        std::cout << password.value() << std::endl;
        return EXIT_SUCCESS;
    }

    Usage(argv);
    exit(EXIT_FAILURE);
}
#endif
