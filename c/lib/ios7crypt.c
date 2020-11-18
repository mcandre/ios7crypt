/*
    Andrew Pennebaker
    Copyright 2005-2011 Andrew Pennebaker
*/

#include "ios7crypt.h"

#include <ctype.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

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

void usage(char **argv) {
    printf("Usage: %s [options]\n\n", argv[0]);
    printf("-e <passwords>\n");
    printf("-d <hashes>\n");
}

// On success, eturns the number of characters encrypted.
// Otherwise, returns -1.
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
        (void) snprintf(
            hash + 2 + i * 2, 3,
            "%02x",
            (unsigned int)(password[i] ^ xlat[(seed++) % XLAT_SIZE])
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
    long seed = strtol(pair, NULL, 10);

    int index = 0;

    for (size_t i = 2; i < len; i += 2) {
        memset(pair, 0, sizeof(pair));
        strncpy(pair, hash + i, 2);

        errno = 0;
        int c = (int) strtol(pair, NULL, 16);

        if (errno != 0) {
            return -1;
        }

        password[index++] = (char)(c ^ xlat[(seed++) % XLAT_SIZE]);
    }

    return (int) (len-2)/2;
}

#ifdef __SANITIZE_ADDRESS__
bool prop_reversible(char *password) {
    char hash[25];
    memset(hash, 0, sizeof(hash));

    unsigned int prng_seed = (unsigned int) time(NULL);

    if (encrypt(prng_seed, password, hash) == -1) {
        return false;
    }

    char password2[12];
    memset(password2, 0, sizeof(password2));

    if (decrypt(hash, password2) == -1) {
        return false;
    }

    return strcmp(password, password2) == 0;
}

int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size) {
    size_t len = Size;

    if (len > 11) {
        len = 11;
    }

    char password[12];
    memset(password, 0, sizeof(password));
    memcpy(password, Data, len);
    prop_reversible(password);
    return 0;
}
#else
int main(int argc, char **argv) {
    unsigned int prng_seed = (unsigned int) time(NULL);

    if (argc < 2) {
        usage(argv);
        return EXIT_FAILURE;
    }

    if (strcmp(argv[1], "-h") == 0) {
        usage(argv);
        return EXIT_SUCCESS;
    }

    if (strcmp(argv[1], "-e") == 0) {
        if (argc < 3) {
            usage(argv);
            return EXIT_FAILURE;
        }

        char hash[25];
        memset(hash, 0, sizeof(hash));

        for (int i = 2; i < argc; i++) {
            char *password = argv[i];

            if (encrypt(prng_seed, password, hash) == -1) {
                fprintf(stderr, "error during encryption\n");
                return EXIT_FAILURE;
            }

            printf("%s\n", hash);
        }

        return EXIT_SUCCESS;
    } else if (strcmp(argv[1], "-d") == 0) {
        if (argc < 3) {
            usage(argv);
            return EXIT_FAILURE;
        }

        char password[11];
        memset(password, 0, sizeof(password));

        for (int i = 2; i < argc; i++) {
            char *hash = argv[i];

            if (decrypt(hash, password) == -1) {
                fprintf(stderr, "error during decryption\n");
                return EXIT_FAILURE;
            }

            printf("%s\n", password);
        }

        return EXIT_SUCCESS;
    }

    usage(argv);
    return EXIT_FAILURE;
}
#endif
