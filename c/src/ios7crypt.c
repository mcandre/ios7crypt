/**
 * @copyright 2020 YelloSoft
*/

#include <ctype.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "ios7crypt/ios7crypt.h"

static int xlat[53] = {
    0x64, 0x73, 0x66, 0x64, 0x3b, 0x6b, 0x66, 0x6f,
    0x41, 0x2c, 0x2e, 0x69, 0x79, 0x65, 0x77, 0x72,
    0x6b, 0x6c, 0x64, 0x4a, 0x4b, 0x44, 0x48, 0x53,
    0x55, 0x42, 0x73, 0x67, 0x76, 0x63, 0x61, 0x36,
    0x39, 0x38, 0x33, 0x34, 0x6e, 0x63, 0x78, 0x76,
    0x39, 0x38, 0x37, 0x33, 0x32, 0x35, 0x34, 0x6b,
    0x3b, 0x66, 0x67, 0x38, 0x37
};

#define xlat_len (sizeof(xlat)/sizeof(int))

int encrypt(char *hash, unsigned int prng_seed, char *password) {
    int seed = rand_r(&prng_seed) % 16;
    size_t seed_sz = 3;
    int bytes_written = snprintf(hash, seed_sz, "%02d", seed);

    if (bytes_written < 0 || (size_t) bytes_written > seed_sz) {
        return -1;
    }

    size_t pair_sz = 3;

    for (size_t i = 0; i < 11; i++) {
        char p_char = password[i];

        if (p_char == '\0') {
            break;
        }

        int p = (int) p_char;

        bytes_written = snprintf(
            hash + 2 + i * 2,
            pair_sz,
            "%02x",
            p ^ xlat[(seed++) % (int) xlat_len]
        );

        if (bytes_written < 0 || (size_t) bytes_written > pair_sz) {
            return -1;
        }
    }

    return 0;
}

int decrypt(char *password, char *hash) {
    char pair[3];
    size_t pair_sz = sizeof(pair);
    memcpy(pair, hash, pair_sz - 1);
    pair[pair_sz - 1] = '\0';

    errno = 0;
    int seed = (int) strtol(pair, NULL, 10);

    if (errno != 0) {
        return -1;
    }

    int index = 0;

    for (size_t i = 2; i < 24; i += 2) {
        if (hash[i] == '\0') {
            break;
        }

        if (hash[i + 1] == '\0') {
            return -1;
        }

        memcpy(pair, hash + i, pair_sz - 1);
        pair[pair_sz - 1] = '\0';

        errno = 0;
        int c = (int) strtol(pair, NULL, 16);

        if (errno != 0) {
            return -1;
        }

        password[index++] = (char)(c ^ xlat[(seed++) % (int) xlat_len]);
    }

    password[index] = '\0';
    return 0;
}
