#pragma once

// Copyright (C) YelloSoft

#include <string>

#ifdef __APPLE__
#include <sys/types.h>
#endif

using std::string;

extern int xlat[];
extern int XLAT_SIZE;

void usage(const char **argv);
string encrypt(uint prng_seed, const string password);
string decrypt(const string hash);

#ifdef __SANITIZE_ADDRESS__
bool prop_reversible(string password);
extern "C" int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size);
#endif
