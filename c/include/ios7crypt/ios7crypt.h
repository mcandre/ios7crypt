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
 * @param hash Cisco IOSv7 buffer
 * @param seed PRNG seed
 * @param password plaintext
 *
 * @returns the number of characters encrypted.
 */
int encrypt(char *hash, unsigned int seed, char *password);

/**
 * decrypt reverses Cisco IOSv7 hashes.
 *
 * @param password plaintext buffer
 * @param hash Cisco IOSv7
 *
 * @returns the number of characters decrypted, or -1 on error.
 */
int decrypt(char *password, char *hash);
