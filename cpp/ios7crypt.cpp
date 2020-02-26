// Copyright (C) YelloSoft

#include "ios7crypt.hh"

#include <iostream>
#include <sstream>
#include <string>

using std::cout;
using std::endl;
using std::ios;
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

static void __attribute__((noreturn)) usage(string const program) {
    cout << "Usage: " << program << " [options]" << endl << endl <<
        "-e <password>" << endl <<
        "-d <hash>" << endl <<
        "-t unit test" << endl;
    exit(1);
}

string encrypt(string const password) {
    stringstream hash;

    if (password.length() > 0) {
        auto seed = rand() % 16;

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
    }

    return hash.str();
}

string decrypt(string const hash) {
    stringstream password;

    if (hash.length() > 3) {
        auto seed = stoi(hash.substr(0, 2), nullptr, 10);

        for (size_t i = 2; i < hash.length(); i += 2) {
            auto c = stoi(hash.substr(i, 2), nullptr, 16);
            password << char(c ^ xlat[(seed++) % XLAT_SIZE]);
        }
    }

    return password.str();
}

int main(int const argc, char** const argv) {
    if (argc < 2) {
        usage(argv[0]);
    }

    if (strcmp(argv[1], "-e") == 0) {
        if (argc < 3) {
            usage(argv[0]);
        }

        srand(uint(time(nullptr)));
        cout << encrypt(argv[2]) << endl;
        return 0;
    }

    if (strcmp(argv[1], "-d") == 0) {
        if (argc < 3) {
            usage(argv[0]);
        }

        cout << decrypt(argv[2]) << endl;
        return 0;
    }

    usage(argv[0]);
}
