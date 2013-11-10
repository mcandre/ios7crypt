#ifndef IOS7CRYPT_H
#define IOS7CRYPT_H

#include <cstring>

extern int xlat[];
extern int XLAT_SIZE;

static void usage(char *program);
static int htoi(char x);
void encrypt(char *password, char *hash);
void decrypt(char *hash, char *password);

#endif
