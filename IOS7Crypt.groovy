#!/usr/bin/env groovy

import java.util.Random

class IOS7Crypt {
	static def xlatPrime = [
		0x64, 0x73, 0x66, 0x64, 0x3b, 0x6b, 0x66, 0x6f,
		0x41, 0x2c, 0x2e, 0x69, 0x79, 0x65, 0x77, 0x72,
		0x6b, 0x6c, 0x64, 0x4a, 0x4b, 0x44, 0x48, 0x53,
		0x55, 0x42, 0x73, 0x67, 0x76, 0x63, 0x61, 0x36,
		0x39, 0x38, 0x33, 0x34, 0x6e, 0x63, 0x78, 0x76,
		0x39, 0x38, 0x37, 0x33, 0x32, 0x35, 0x34, 0x6b,
		0x3b, 0x66, 0x67, 0x38, 0x37
	]

	static xlat(i, len) {
		if (len < 1) {
			[]
		}
		else {
			def xLen = xlatPrime.size
			def safeIndex = (i % xLen) as int
			def head = xlatPrime[safeIndex]
			def tail = xlat(i + 1, len - 1)

			[head] + tail
		}
	}

	static encrypt(password) {
		def seed = (new Random().nextDouble() * 16) as int

		def plaintext = password.toCharArray().collect({ c -> c as int })

		def keys = xlat(seed, plaintext.size)

		def ciphertext = (0 .. (plaintext.size - 1)).collect({ i -> plaintext[i] ^ keys[i] })

		String.format("%02d%s", seed, ciphertext.collect({ e -> String.format("%02x", e) }).join(""))
	}

	static decrypt(password) {
		/* ... */
	}

	static test() {
		/* ... */
	}

	static main(args) {
		println (encrypt("monkey"))

		/* ... */
	}
}