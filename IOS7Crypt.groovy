#!/usr/bin/env groovy

/* Requires gruesome
   https://github.com/mcandre/gruesome */

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

	static onlyPairs(text) {
		def head = text.substring(0, 2)
		def tail = []

		if (text.length() > 3) {
			tail = onlyPairs(text.substring(2))
		}

		[head] + tail
	}

	static decrypt(password) {
		def seed = Integer.parseInt(password.substring(0, 2))
		def hexpairs = onlyPairs(password.substring(2))
		def ciphertext = hexpairs.collect({ pair -> Integer.parseInt(pair, 16) })
		def keys = xlat(seed, ciphertext.size)
		def plaintext = (0 .. (ciphertext.size - 1)).collect({ i -> ciphertext[i] ^ keys[i] })

		plaintext.collect({ e -> e as char }).join("")
	}

	static def reversible = { password -> decrypt(encrypt(password)) == password }

	static test() {
		Gruesome.forAll(reversible, [Gruesome.genString])
	}

	static main(args) {
		def cl = new CliBuilder(usage: "Usage: IOS7Crypt.groovy [options]")
		cl.h(longOpt: "help", "Show usage")
		cl.e(longOpt: "encrypt", argName: "password", args:1, "Encrypt password")
		cl.d(longOpt: "decrypt", argName: "hash", args:1, "Decrypt hash")
		cl.t(longOpt: "test", "Run unit tests")

		def mode = "help"
		def password = ""
		def hash = ""

		def opt = cl.parse(args)

		if (!opt) {
			System.exit(0)
		}

		if (opt.e) {
			mode = "encrypt"
			password = opt.e
		}

		if (opt.d) {
			mode = "decrypt"
			hash = opt.d
		}

		if (opt.t) {
			mode = "test"
		}

		if (mode == "help") {
			cl.usage()
		}
		else if (mode == "encrypt") {
			println encrypt(password)
		}
		else if (mode == "decrypt") {
			println decrypt(hash)
		}
		else if (mode == "test") {
			test()
		}
	}
}