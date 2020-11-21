#pragma once

/**
 * @copyright 2020 YelloSoft
 */

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#ifdef __SANITIZE_ADDRESS__
bool prop_reversible(char *password);
int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size);
#else
void usage(char **argv);
int main(int argc, char **argv);
#endif
