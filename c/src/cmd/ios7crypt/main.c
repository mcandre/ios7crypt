/**
 * @copyright 2020 YelloSoft
*/

#include "main.h"

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "ios7crypt/ios7crypt.h"

#ifdef __SANITIZE_ADDRESS__
bool prop_reversible(char *password) {
    char hash[25];
    memset(hash, 0, sizeof(hash));
    unsigned int prng_seed = (unsigned int) time(NULL);

    if (encrypt(hash, prng_seed, password) < 0) {
        return false;
    }

    char password2[12];
    memset(password2, 0, sizeof(password2));

    if (decrypt(password2, hash) < 0) {
        return false;
    }

    return strcmp(password, password2) == 0;
}

int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size) {
    char password[12];
    size_t password_sz = sizeof(password);
    size_t password_len = Size;

    if (password_len > password_sz - 1) {
        password_len = password_sz - 1;
    }

    memcpy(password, Data, password_len);
    password[password_len] = '\0';
    prop_reversible(password);
    return 0;
}
#else
void usage(char **argv) {
    printf("Usage: %s [options]\n\n", argv[0]);
    printf("-e <passwords>\n");
    printf("-d <hashes>\n");
}

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

            if (encrypt(hash, prng_seed, password) < 0) {
                fprintf(stderr, "error writing to buffer\n");
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

        char password[12];
        memset(password, 0, sizeof(password));

        for (int i = 2; i < argc; i++) {
            char *hash = argv[i];

            if (decrypt(password, hash) < 0) {
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
