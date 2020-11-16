/*
    Andrew Pennebaker
    Copyright 2005-2011 Andrew Pennebaker
*/

#include "ios7crypt.h"

#include <string.h>
#include <time.h>
#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>

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

void usage(const char *program) {
    printf("Usage: %s [options]\n\n", program);
    printf("-e <passwords>\n");
    printf("-d <hashes>\n");
}

void encrypt(unsigned int prng_seed, const char *password, char *hash) {
    if (password != NULL && hash != NULL) {
        size_t password_length = strlen(password);

        int seed = rand_r(&prng_seed) % 16;

        (void) snprintf(hash, sizeof(hash)-1, "%02d", seed);

        size_t i;

        for (i = 0; i < password_length; i++) {
            (void) snprintf(
                hash + 2 + i * 2, 3,
                "%02x",
                (unsigned int)(password[i] ^ xlat[(seed++) % XLAT_SIZE])
            );
        }
    }
}

char *decrypt(const char *hash, char *password) {
    if (hash == NULL || password == NULL) {
        return NULL;
    }

    char *pair = (char*) calloc(3, sizeof(char));

    if (pair == NULL) {
        fprintf(stderr, "out of memory\n");
        return NULL;
    }

    strncat(pair, hash, 2);

    long seed = strtol(pair, NULL, 10);
    int index = 0;

    for (size_t i = 2; i < strlen(hash); i += 2) {
        pair[0] = pair[1] = '\0';
        strncat(pair, hash + i, 2);
        int c = (int) strtol(pair, NULL, 16);
        password[index++] = (char)(c ^ xlat[(seed++) % XLAT_SIZE]);
    }

    free(pair);
    return password;
}

#ifdef __SANITIZE_ADDRESS__
bool prop_reversible(const char *password) {
    char *hash = (char*) calloc(
        (size_t) strlen(password) * 2 + 3,
        sizeof(char)
    );

    if (hash == NULL) {
        fprintf(stderr, "out of memory\n");
        return false;
    }

    unsigned int prng_seed = (unsigned int) time(NULL);
    encrypt(prng_seed, password, hash);

    char *password2 = (char*) calloc(
        (size_t) strlen(hash) / 2,
        sizeof(char)
    );

    if (password2 == NULL) {
        fprintf(stderr, "out of memory\n");
        free(hash);
        return false;
    }

    if (decrypt(hash, password2)) {
        free(password2);
        free(hash);
        return false;
    }

    int cmp = strcmp(password, password2);
    free(password2);
    free(hash);
    return cmp == 0;
}

int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size) {
    size_t len = Size;

    if (len > 11) {
        len = 11;
    }

    char *password = calloc(len+1, sizeof(char));

    if (password == NULL) {
        return 0;
    }

    for (size_t i = 0; i < len; i++) {
        password[i] = (char) (Data[i]);
    }

    prop_reversible(password);
    free(password);
    return 0;
}
#else
int main(int argc, char **argv) {
    unsigned int prng_seed = (unsigned int) time(NULL);

    if (argc < 2) {
        usage(argv[0]);
        return EXIT_FAILURE;
    }

    if (strcmp(argv[1], "-h") == 0) {
        usage(argv[0]);
        return EXIT_SUCCESS;
    }

    if (strcmp(argv[1], "-e") == 0) {
        if (argc < 3) {
            usage(argv[0]);
            return EXIT_FAILURE;
        }

        for (int i = 2; i < argc; i++) {
            char *password = argv[i];

            char *hash = (char *) calloc(
                (size_t) strlen(password) * 2 + 3,
                sizeof(char)
            );

            if (hash == NULL) {
                fprintf(stderr, "out of memory\n");
                return EXIT_FAILURE;
            }

            encrypt(prng_seed, password, hash);
            printf("%s\n", hash);
            free(hash);
        }

        return EXIT_SUCCESS;
    } else if (strcmp(argv[1], "-d") == 0) {
        if (argc < 3) {
            usage(argv[0]);
            return EXIT_FAILURE;
        }

        for (int i = 2; i < argc; i++) {
            char *hash = argv[i];

            char *password = (char *) calloc(
                (size_t) strlen(hash) / 2,
                sizeof(char)
            );

            if (password == NULL) {
                fprintf(stderr, "out of memory\n");
                return EXIT_FAILURE;
            }

            if (decrypt(hash, password) == NULL) {
                free(password);
                return EXIT_FAILURE;
            }

            printf("%s\n", password);
            free(password);
        }

        return EXIT_SUCCESS;
    }

    usage(argv[0]);
    return EXIT_FAILURE;
}
#endif
