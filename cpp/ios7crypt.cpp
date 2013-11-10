#include <cstring>
#include <ctime>
#include <cstdlib>
#include <iostream>
#include "ios7crypt.h"
using std::cout;
using std::endl;

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

static void __attribute__((noreturn)) usage(char *program) {
  cout << "Usage: " << program << " [options]" << endl << endl;
  cout << "-e <passwords>" << endl;
  cout << "-d <hashes>" << endl;
  cout << "-t unit test" << endl;

  exit(0);
}

static int htoi(char x) {
  if (isdigit(x)) {
    return (int) (x - '0');
  }
  else {
    return (int) (toupper(x) - 'A' + 10);
  }
}

void encrypt(char *password, char *hash) {
  if (
    password != NULL &&
    strlen(password) > 0 &&
    hash != NULL
  ) {
    size_t password_length = strlen(password);

    int seed;

    size_t i;

    seed = rand() % 16;

    (void) snprintf(hash, 3, "%02d", seed);

    for (i = 0; i < password_length; i++) {
      (void) snprintf(hash + 2 + i * 2, 3, "%02x", (unsigned int) (password[i] ^ xlat[(seed++) % XLAT_SIZE]));
    }
  }
}

void decrypt(char *hash, char *password) {
  if (hash != NULL && strlen(hash) > 3 && password != NULL) {
    int seed = htoi(hash[0]) * 10 + htoi(hash[1]);

    int index = 0;

    int i;

    for (i = 2; i < (int) strlen(hash); i += 2) {
      int c = htoi(hash[i]) * 16 + htoi(hash[i + 1]);
      password[index++] = (char) (c ^ xlat[(seed++) % XLAT_SIZE]);
    }
  }
}

int main(int argc, char **argv) {
  int i;

  char *password;
  char *hash;

  srand((unsigned int) time(NULL));

  if (argc < 2) {
    usage(argv[0]);
  }
  else if (strcmp(argv[1], "-e") == 0) {
    if (argc < 3) {
      usage(argv[0]);
    }

    for (i = 2; i < argc; i++) {
      password = argv[i];

      hash = (char *) malloc((size_t) strlen(password) * 2 + 3);

      if (hash != NULL) {
        encrypt(password, hash);
        cout << hash << endl;

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

      password = (char *) malloc((size_t) strlen(hash) / 2);

      if (password != NULL) {
        decrypt(hash, password);
        cout << password << endl;

        free(password);
      }
    }
  }
  else {
    usage(argv[0]);
  }

  return 0;
}
