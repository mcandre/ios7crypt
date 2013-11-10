#include <string>
#include <sstream>
#include <ctime>
#include <cstdlib>
#include <iostream>
#include "ios7crypt.h"
using std::cout;
using std::endl;
using std::string;
using std::stringstream;
using std::ios;
using std::stoi;

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

static void __attribute__((noreturn)) usage(string program) {
  cout << "Usage: " << program << " [options]" << endl << endl;
  cout << "-e <passwords>" << endl;
  cout << "-d <hashes>" << endl;
  cout << "-t unit test" << endl;

  exit(0);
}

string encrypt(string password) {
  stringstream hash;

  if (password.length() > 0) {
    size_t password_length = password.length();

    int seed;

    size_t i;

    seed = rand() % 16;

    hash.setf(ios::dec);
    hash.width(2);
    hash.fill('0');
    hash << seed;

    hash.setf(ios::hex);
    hash.width(2);
    hash.fill('0');

    for (i = 0; i < password_length; i++) {
      hash << (unsigned int) (password[i] ^ xlat[(seed++) % XLAT_SIZE]);
    }
  }

  return hash.str();
}

string decrypt(string hash) {
  stringstream password;

  if (hash.length() > 3) {
    int seed = stoi(hash.substr(0, 2), NULL, 10);

    size_t i;

    for (i = 2; i < hash.length(); i += 2) {
      int c = stoi(hash.substr(i, 2), NULL, 16);

      password << (char) (c ^ xlat[(seed++) % XLAT_SIZE]);
    }
  }

  return password.str();
}

int main(int argc, char **argv) {
  int i;

  srand((unsigned int) time(NULL));

  if (argc < 2) {
    usage(argv[0]);
  }
  else if (strcmp(argv[1], "-e") == 0) {
    if (argc < 3) {
      usage(argv[0]);
    }

    for (i = 2; i < argc; i++) {
      string password = argv[i];

      cout << encrypt(password) << endl;
    }
  }
  else if (strcmp(argv[1], "-d") == 0) {
    if (argc < 3) {
      usage(argv[0]);
    }

    for (i = 2; i < argc; i++) {
      string hash = argv[i];

      cout << decrypt(hash) << endl;
    }
  }
  else {
    usage(argv[0]);
  }

  return 0;
}
