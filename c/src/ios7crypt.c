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

int encrypt(
    char *hash,
    size_t hash_size,
    unsigned int prng_seed,
    char *password,
    size_t password_len
) {
    if (password_len > 11) {
        return -1;
    }

    int seed = rand_r(&prng_seed) % 16;
    int bytes_written = snprintf(hash, sizeof(hash)-1, "%02d", seed);

    if (bytes_written < 0 || bytes_written > (int) hash_size) {
        return bytes_written;
    }

    for (size_t i = 0; i < password_len; i++) {
        int p = (int) password[i];
        int b_w = snprintf(
            hash + 2 + i * 2, 3,
            "%02x",
            p ^ xlat[(seed++) % (int) xlat_len]
        );

        if (b_w < 0) {
            return b_w;
        }

        bytes_written += b_w;

        if (bytes_written > (int) hash_size) {
            return bytes_written;
        }
    }

    return bytes_written;
}

int decrypt(
    char *password,
    size_t password_size,
    char *hash,
    size_t hash_len
) {
    if (
        hash_len > 24 ||
        hash_len < 2 ||
        hash_len % 2 != 0 ||
        password_size < hash_len/2
    ) {
        return -1;
    }

    char pair[3];
    (void) snprintf(pair, sizeof(pair), "%s", hash);

    errno = 0;
    int seed = (int) strtol(pair, NULL, 10);

    if (errno != 0) {
        return -1;
    }

    int index = 0;

    for (size_t i = 2; i < hash_len; i += 2) {
        (void) snprintf(pair, sizeof(pair), "%s", hash+i);

        errno = 0;
        int c = (int) strtol(pair, NULL, 16);

        if (errno != 0) {
            return -1;
        }

        password[index++] = (char)(c ^ xlat[(seed++) % (int) xlat_len]);
    }

    password[index] = '\0';
    return index;
}
