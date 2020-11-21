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
 * @param hash buffer
 * @param hash_size buffer size (bytes)
 * @param seed PRNG seed
 * @param password plaintext
 * @param password_len max password length (string). Shall not exceed 11.
 *
 * @returns bytes written. A value outside [0, hash_size] indicates error.
 */
int encrypt(char *hash, size_t hash_size, unsigned int seed, char *password, size_t password_len);

/**
 * decrypt reverses Cisco IOSv7 hashes.
 *
 * @param password buffer
 * @param password_size buffer size (bytes)
 * @param hash Cisco IOSv7
 * @param hash_len max hash length (string). Shall not exceed 24.
 *
 * @returns bytes written. A value outside [0, password_size] indicates error.
 */
int decrypt(char *password, size_t password_size, char *hash, size_t hash_len);
