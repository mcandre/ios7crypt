#pragma once

/**
 * @copyright 2020 YelloSoft
 */

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#ifdef __SANITIZE_ADDRESS__
int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size);
#endif
