#pragma once

/**
 * @copyright 2020 YelloSoft
 * @mainpage
 *
 * @ref ios7crypt manages Cisco IOSv7 hashes.
 */

#include <optional>
#include <string>
#ifdef __APPLE__
#include <sys/types.h>
#endif
#include <vector>

/**
 * @brief ios7crypt manages legacy Cisco hashes.
 */
namespace ios7crypt {
    /**
     * @brief Encrypt produces Cisco IOSv7 hashes.
     *
     * @param prng_seed PRNG seed
     * @param password plaintext
     *
     * @returns Cisco IOSv7 hash
     */
    std::string Encrypt(uint prng_seed, std::string password);

    /**
     * @brief Decrypt reverses Cisco IOSv7 hashes.
     *
     * @param hash Cisco IOSv7
     *
     * @returns password, or std::nullopt on error.
     */
    std::optional<std::string> Decrypt(std::string hash);
}
