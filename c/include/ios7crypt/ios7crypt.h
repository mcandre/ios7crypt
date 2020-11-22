#pragma once

/**
 * @copyright 2020 YelloSoft
 * @mainpage
 *
 * @ref encrypt produces Cisco IOSv7 hashes.
 *
 * @ref decrypt reverses Cisco IOSv7 hashes.
 */

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

/**
 * encrypt produces Cisco IOSv7 hashes.
 *
 * @param hash buffer (1 + 2 * password bytes)
 * @param seed PRNG seed
 * @param password truncated to 11 characters + null terminator
 *
 * @returns zero. -1 indicates error.
 */
int encrypt(char *hash, unsigned int seed, char *password);

/**
 * decrypt reverses Cisco IOSv7 hashes.
 *
 * @param password buffer
 * @param hash max 24 characters + null terminator
 *
 * @returns zero. -1 indicates error.
 */
int decrypt(char *password, char *hash);
