#ifndef IOS7CRYPT_H
#define IOS7CRYPT_H

#include <string>
using std::string;

extern int xlat[];
extern int XLAT_SIZE;

static void usage(string program);
string encrypt(string password);
string decrypt(string hash);

#endif
