#pragma once

/* Copyright 2005-2011 Andrew Pennebaker */

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

extern int xlat[];
extern int XLAT_SIZE;

void usage(const char *program);
void encrypt(unsigned int seed, char *password, char *hash);
char* decrypt(char *hash, char *password);

#ifdef __SANITIZE_ADDRESS__
bool prop_reversible(char *password);
int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size);
#endif
