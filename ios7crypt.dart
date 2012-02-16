#!/usr/bin/env dart

#library("ios7crypt");

var xlatPrime = const [
	0x64, 0x73, 0x66, 0x64, 0x3b, 0x6b, 0x66, 0x6f,
	0x41, 0x2c, 0x2e, 0x69, 0x79, 0x65, 0x77, 0x72,
	0x6b, 0x6c, 0x64, 0x4a, 0x4b, 0x44, 0x48, 0x53,
	0x55, 0x42, 0x73, 0x67, 0x76, 0x63, 0x61, 0x36,
	0x39, 0x38, 0x33, 0x34, 0x6e, 0x63, 0x78, 0x76,
	0x39, 0x38, 0x37, 0x33, 0x32, 0x35, 0x34, 0x6b,
	0x3b, 0x66, 0x67, 0x38, 0x37
];

xlat(index, len) {
	if (len < 1) {
		return [];
	}
	else {
		var i = (index % xlatPrime.length).toInt();

		var head = xlatPrime[i];

		var res = [head];

		var tail = xlat(index + 1, len - 1);

		res.addAll(tail);

		return res;
	}
}

encrypt(password) {
	if (password.length < 1) {
		return "";
	}

	var seed = (Math.random() * 16).toInt();

	var keys = xlat(seed, password.length);

	var plaintext = [];

	for (var i = 0; i < password.length; i++) {
		plaintext.add(password.charCodeAt(i));
	}

	var ciphertext = [];

	for (var i = 0; i < plaintext.length; i++) {
		ciphertext.add(plaintext[i] ^ keys[i]);
	}

	var seedpair = "${seed}";

	if (seedpair.length < 2) {
		seedpair = "0${seedpair}";
	}

	var hexpairs = [];

	for (var i = 0; i < ciphertext.length; i++) {
		var pair = ciphertext[i].toRadixString(16);

		if (pair.length < 2) {
			pair = "0$pair";
		}

		hexpairs.add(pair);
	}

	return "${seedpair}${Strings.concatAll(hexpairs).toLowerCase()}";
}

pairs(text) {
	var ps = [text.substring(0, 2)];

	if (text.length > 3) {
		ps.addAll(pairs(text.substring(2)));
	}

	return ps;
}

decrypt(hash) {
	if (hash.length < 4) {
		return "";
	}

	var seedStr = hash.substring(0, 2);
	var hashStr = hash.substring(2);

	var seed = Math.parseInt(seedStr);

	var hexpairs = pairs(hashStr);

	var ciphertext = [];

	for (var i = 0; i < hexpairs.length; i++) {
		var cipher = Math.parseInt("0x" + hexpairs[i]);
		ciphertext.add(cipher);
	}

	var keys = xlat(seed, ciphertext.length);

	var plaintext = [];

	for (var i = 0; i < ciphertext.length; i++) {
		var plain = ciphertext[i] ^ keys[i];
		plaintext.add(plain);
	}

	var password = new String.fromCharCodes(plaintext);

	return password;
}

main() {
	//print(encrypt("monkey"));
	print(decrypt("00091c080f5e12"));
}