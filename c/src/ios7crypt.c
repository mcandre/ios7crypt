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

#define XLAT_LEN (sizeof(xlat)/sizeof(int))

int encrypt(unsigned int prng_seed, char *password, char *hash) {
    if (password == NULL || hash == NULL) {
        return -1;
    }

    int seed = rand_r(&prng_seed) % 16;
    (void) snprintf(hash, sizeof(hash)-1, "%02d", seed);

    size_t len = strlen(password);

    if (len > 11) {
        len = 11;
    }

    for (size_t i = 0; i < len; i++) {
        int p = (int) password[i];
        (void) snprintf(
            hash + 2 + i * 2, 3,
            "%02x",
            p ^ xlat[(seed++) % (int) XLAT_LEN]
        );
    }

    return (int) len;
}

// On success, returns the number of characters decrypted.
// Otherwise, returns -1.
int decrypt(char *hash, char *password) {
    if (hash == NULL || password == NULL) {
        return -1;
    }

    size_t len = strlen(hash);

    if (len < 4 || len % 2 != 0) {
        return -1;
    }

    char pair[3];
    memset(pair, 0, sizeof(pair));
    strncpy(pair, hash, 2);

    errno = 0;
    int seed = (int) strtol(pair, NULL, 10);

    if (errno != 0) {
        return -1;
    }

    int index = 0;

    for (size_t i = 2; i < len; i += 2) {
        memset(pair, 0, sizeof(pair));
        strncpy(pair, hash + i, 2);

        errno = 0;
        int c = (int) strtol(pair, NULL, 16);

        if (errno != 0) {
            return -1;
        }

        password[index++] = (char)(c ^ xlat[(seed++) % (int) XLAT_LEN]);
    }

    return (int) (len-2)/2;
}
