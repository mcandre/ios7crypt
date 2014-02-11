/*
   Andrew Pennebaker
   Copyright 2005-2011 Andrew Pennebaker

   Requires qc (https://github.com/mcandre/qc)
*/

#include <string.h>
#include <time.h>
#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>
#include "qc.h"
#include "ios7crypt.h"

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

void __attribute__((noreturn)) usage(char* const program) {
  printf("Usage: %s [options]\n\n", program);
  printf("-e <passwords>\n");
  printf("-d <hashes>\n");
  printf("-t unit test\n");

  exit(0);
}

void encrypt(char* const password, char* hash) {
  size_t password_length;

  int seed;

  size_t i;

  if (
    password != NULL &&
    strlen(password) > 0 &&
    hash != NULL
  ) {
    password_length = strlen(password);

    seed = rand() % 16;

    (void) snprintf(hash, 3, "%02d", seed);

    for (i = 0; i < password_length; i++) {
      (void) snprintf(
        hash + 2 + i * 2, 3,
        "%02x",
        (unsigned int) (password[i] ^ xlat[(seed++) % XLAT_SIZE])
      );
    }
  }
}

void decrypt(char* const hash, char* password) {
  long seed;
  size_t i;
  int index, c;

  char *pair = (char*) calloc(3, sizeof(char));

  if (
    hash != NULL &&
    strlen(hash) > 3 &&
    password != NULL &&
    pair != NULL) {

    strncat(pair, hash, 2);

    seed = strtol(pair, NULL, 10);

    index = 0;

    for (i = 2; i < strlen(hash); i += 2) {
      pair[0] = pair[1] = '\0';
      strncat(pair, hash + i, 2);
      c = (int) strtol(pair, NULL, 16);

      password[index++] = (char) (c ^ xlat[(seed++) % XLAT_SIZE]);
    }

    free(pair);
  }
}

bool reversible(void* const data) {
  char* password;
  char* hash;
  char* password2;
  int cmp;

  password = qc_args(char*, 0, sizeof(char*));

  hash = (char*) calloc((size_t) strlen(password) * 2 + 3, sizeof(char));

  if (hash == NULL) {
    printf("Out of memory.\n");
    return false;
  }

  encrypt(password, hash);

  password2 = (char*) calloc((size_t) strlen(hash) / 2 * sizeof(char), sizeof(char));

  if (password2 == NULL) {
    printf("Out of memory.\n");
    free(hash);
    free(password);

    return false;
  }

  decrypt(hash, password2);

  cmp = strcmp(password, password2);

  free(hash);
  free(password2);

  return cmp == 0;
}

int main(int const argc, char** const argv) {
  int i;

  char *password, *hash;

  srand((unsigned int) time(NULL));

  qc_init();

  if (argc < 2) {
    usage(argv[0]);
  }
  else if (strcmp(argv[1], "-e") == 0) {
    if (argc < 3) {
      usage(argv[0]);
    }

    for (i = 2; i < argc; i++) {
      password = argv[i];

      hash = (char *) calloc((size_t) strlen(password) * 2 + 3, sizeof(char));

      if (hash != NULL) {
        encrypt(password, hash);
        printf("%s\n", hash);

        free(hash);
      }
    }
  }
  else if (strcmp(argv[1], "-d") == 0) {
    if (argc < 3) {
      usage(argv[0]);
    }

    for (i = 2; i < argc; i++) {
      hash = argv[i];

      password = (char *) calloc((size_t) strlen(hash) / 2, sizeof(char));

      if (password != NULL) {
        decrypt(hash, password);
        printf("%s\n", password);

        free(password);
      }
    }
  }
  else if (strcmp(argv[1], "-t") == 0) {
    gen gs[] = { gen_string };
    gen ps[] = { print_string };

    for_all(reversible, 1, gs, ps, sizeof(char*));
  }
  else {
    usage(argv[0]);
  }

  return 0;
}
