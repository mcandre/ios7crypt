#!/usr/bin/env rdmd -version=ios7crypt

// Interpret:
// ./ios7crypt.d
//
// Compile:
// dmd ios7crypt.d -version=ios7crypt
//
// Run:
// ./ios7crypt

module ios7crypt;

import std.random;
import std.string;
import std.array;
import std.conv;
import std.stdio;

int[] xlatPrime = [
	0x64, 0x73, 0x66, 0x64, 0x3b, 0x6b, 0x66, 0x6f,
	0x41, 0x2c, 0x2e, 0x69, 0x79, 0x65, 0x77, 0x72,
	0x6b, 0x6c, 0x64, 0x4a, 0x4b, 0x44, 0x48, 0x53,
	0x55, 0x42, 0x73, 0x67, 0x76, 0x63, 0x61, 0x36,
	0x39, 0x38, 0x33, 0x34, 0x6e, 0x63, 0x78, 0x76,
	0x39, 0x38, 0x37, 0x33, 0x32, 0x35, 0x34, 0x6b,
	0x3b, 0x66, 0x67, 0x38, 0x37
];

int[] xlat(int i, int len) {
	if (len < 1) {
		return [];
	}
	else {
		return xlatPrime[i % xlatPrime.length] ~ xlat(i + 1, len - 1);
	}
}

string encrypt(string password) {
	auto seed = uniform(0, 16);

	int[] keys = xlat(seed, password.length);

	string[] cipherpairs = [];
	for(int i = 0; i < password.length; i++) {
		cipherpairs ~= format("%02x", keys[i] ^ password[i]);
	}

	return format("%02d%s", seed, join(cipherpairs, ""));
}

string decrypt(string hash) {
	if (hash.length < 4) {
		return "invalid hash";
	}

	try {
		auto seed = parse!(int)(hash[0..2]);

		int[] ciphertext = [];
		for(int i = 2; i < hash.length; i += 2) {
			try {
				auto c = parse!(int)(hash[i..i+2], 16);

				ciphertext ~= c;
			}
			catch(ConvException e) {
				break;
			}
		}

		int[] keys = xlat(seed, ciphertext.length);

		string password = "";
		for (int i = 0; i < ciphertext.length; i++) {
			password ~= ciphertext[i] ^ keys[i];
		}

		return password;
	}
	catch(ConvException e) {
		return "invalid hash";
	}
}

version (ios7crypt) {
	void main(string[] args) {
		string password = "monkey";

		writeln("Encrypting password: ", password);

		string hash = encrypt(password);

		writeln("Hash: ", hash);

		string password2 = decrypt(hash);

		writeln("Decrypted password: ", password2);

		// ...
	}
}