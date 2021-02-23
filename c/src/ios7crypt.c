/**
 * @copyright 2020 YelloSoft
*/

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "ios7crypt/ios7crypt.h"

static const unsigned char xlat[53] = {
    0x64, 0x73, 0x66, 0x64, 0x3b, 0x6b, 0x66, 0x6f,
    0x41, 0x2c, 0x2e, 0x69, 0x79, 0x65, 0x77, 0x72,
    0x6b, 0x6c, 0x64, 0x4a, 0x4b, 0x44, 0x48, 0x53,
    0x55, 0x42, 0x73, 0x67, 0x76, 0x63, 0x61, 0x36,
    0x39, 0x38, 0x33, 0x34, 0x6e, 0x63, 0x78, 0x76,
    0x39, 0x38, 0x37, 0x33, 0x32, 0x35, 0x34, 0x6b,
    0x3b, 0x66, 0x67, 0x38, 0x37
};

#define xlat_len (sizeof(xlat)/sizeof(int))

void encrypt(char *hash, unsigned int prng_seed, const char *password) {
    int seed = rand_r(&prng_seed) % 16;
    const size_t pair_sz = 3;
    (void) snprintf(hash, pair_sz, "%02d", seed);

    for (size_t i = 0; i < 11; i++) {
        const unsigned char p = (unsigned char) password[i];

        if (p == '\0') {
            break;
        }

        (void) snprintf(
            hash + 2 * (i + 1),
            pair_sz,
            "%02x",
            p ^ xlat[(seed++) % (unsigned char) xlat_len]
        );
    }
}

int decrypt(char *password, const char *hash) {
    char pair[3];
    const size_t pair_sz = sizeof(pair);

    (void) snprintf(pair, pair_sz, "%.*s", 2, hash);
    int seed = (int) strtol(pair, NULL, 10);

    size_t i;

    for (i = 0; i < 11; i++) {
        const size_t j = 2 * (i + 1);

        if (hash[j] == '\0') {
            break;
        }

        if (hash[j + 1] == '\0') {
            return -1;
        }

        (void) snprintf(pair, pair_sz, "%.*s", 2, hash + j);
        const int c = (int) strtol(pair, NULL, 16);
        const char p = (char) (c ^ xlat[(seed++) % (int) xlat_len]);
        password[i] = p;
    }

    password[i] = '\0';
    return 0;
}
