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
 * @param seed PRNG seed
 * @param password plaintext
 * @param hash Cisco IOSv7 buffer
 *
 * @returns the number of characters encrypted.
 */
int encrypt(unsigned int seed, char *password, char *hash);

/**
 * decrypt reverses Cisco IOSv7 hashes.
 *
 * @param hash Cisco IOSv7
 * @param password plaintext buffer
 *
 * @returns the number of characters decrypted, or -1 on error.
 */
int decrypt(char *hash, char *password);
