/**
 * @copyright 2020 YelloSoft
 */

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include <string>
#include <vector>

#include "ios7crypt/ios7crypt.hpp"

#ifdef __SANITIZE_ADDRESS__
bool PropReversible(std::string password);
extern "C" int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size);
#else
void Usage(const char **argv);
int main(const int argc, const char **argv);
#endif
