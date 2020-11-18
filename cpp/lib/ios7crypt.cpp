// Copyright (C) YelloSoft

#include "ios7crypt.hh"

#include <cstring>
#include <iostream>
#include <sstream>
#include <string>

using std::cerr;
using std::cout;
using std::endl;
using std::ios;
using std::nullopt;
using std::stoi;
using std::string;
using std::stringstream;

int xlat[] = {
    0x64, 0x73, 0x66, 0x64, 0x3b, 0x6b, 0x66, 0x6f,
    0x41, 0x2c, 0x2e, 0x69, 0x79, 0x65, 0x77, 0x72,
    0x6b, 0x6c, 0x64, 0x4a, 0x4b, 0x44, 0x48, 0x53,
    0x55, 0x42, 0x73, 0x67, 0x76, 0x63, 0x61, 0x36,
    0x39, 0x38, 0x33, 0x34, 0x6e, 0x63, 0x78, 0x76,
    0x39, 0x38, 0x37, 0x33, 0x32, 0x35, 0x34, 0x6b,
    0x3b, 0x66, 0x67, 0x38, 0x37
};

int XLAT_SIZE = 53;

void usage(const char **argv) {
    cout << "Usage: " << argv[0] << " [options]" << endl << endl <<
        "-e <password>" << endl <<
        "-d <hash>" << endl;
}

// Returns a hash.
string encrypt(uint prng_seed, const string password) {
    auto seed = rand_r(&prng_seed) % 16;

    auto hash = stringstream();
    hash.setf(ios::dec, ios::basefield);
    hash.width(2);
    hash.fill('0');
    hash << seed;

    for (auto &p : password) {
        hash.setf(ios::hex, ios::basefield);
        hash.width(2);
        hash.fill('0');
        hash << uint(p ^ xlat[(seed++) % XLAT_SIZE]);
    }

    return hash.str();
}

// On success, returns a password.
// Otherwise, returns nullopt.
optional<string> decrypt(const string hash) {
    if (hash.length() < 4 || hash.length() % 2 != 0) {
        return nullopt;
    }

    auto seed = stoi(hash.substr(0, 2), nullptr, 10);
    auto password = stringstream();

    for (size_t i = 2; i < hash.length(); i += 2) {
        errno = 0;
        auto c = stoi(hash.substr(i, 2), nullptr, 16);

        if (errno != 0) {
            return nullopt;
        }

        password << char(c ^ xlat[(seed++) % XLAT_SIZE]);
    }

    return password.str();
}

#ifdef __SANITIZE_ADDRESS__
bool prop_reversible(string password) {
    auto prng_seed = uint(time(nullptr));
    auto hash = encrypt(prng_seed, password);
    auto password2 = decrypt(hash);

    if (!password2.has_value()) {
        return false;
    }

    return password.compare(password2.value()) == 0;
}

int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size) {
    auto len = Size;

    if (len > 11) {
        len = 11;
    }

    char password_buf[12];
    memset(password_buf, 0, sizeof(password_buf));
    memcpy(password_buf, Data, len);
    prop_reversible(string(password_buf));
    return 0;
}
#else
int main(const int argc, const char **argv) {
    uint prng_seed = uint(time(nullptr));

    if (argc < 2) {
        usage(argv);
        exit(EXIT_FAILURE);
    }

    if (strcmp(argv[1], "-h") == 0) {
        usage(argv);
        exit(EXIT_SUCCESS);
    }

    if (strcmp(argv[1], "-e") == 0) {
        if (argc < 3) {
            usage(argv);
        }

        cout << encrypt(prng_seed, argv[2]) << endl;
        return EXIT_SUCCESS;
    }

    if (strcmp(argv[1], "-d") == 0) {
        if (argc < 3) {
            usage(argv);
            exit(EXIT_FAILURE);
        }

        auto password = decrypt(argv[2]);

        if (!password.has_value()) {
            cerr << "error during decryption" << endl;
            return EXIT_FAILURE;
        }

        cout << password.value() << endl;
        return EXIT_SUCCESS;
    }

    usage(argv);
    exit(EXIT_FAILURE);
}
#endif
