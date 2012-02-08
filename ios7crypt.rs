// ios7crypt.rs
// Andrew Pennebaker
// 7 Feb 2012

#[link(name = "ios7crypt")];

use std;

fn xlat_prime() -> [int] {
	ret [
		0x64, 0x73, 0x66, 0x64, 0x3b, 0x6b, 0x66, 0x6f,
		0x41, 0x2c, 0x2e, 0x69, 0x79, 0x65, 0x77, 0x72,
		0x6b, 0x6c, 0x64, 0x4a, 0x4b, 0x44, 0x48, 0x53,
		0x55, 0x42, 0x73, 0x67, 0x76, 0x63, 0x61, 0x36,
		0x39, 0x38, 0x33, 0x34, 0x6e, 0x63, 0x78, 0x76,
		0x39, 0x38, 0x37, 0x33, 0x32, 0x35, 0x34, 0x6b,
		0x3b, 0x66, 0x67, 0x38, 0x37
	];
}

fn xlat(i : uint, len : uint) -> [int] {
	let xs : [int] = xlat_prime();
	let xs_len : uint = vec::len(xs);

	if len < 1u {
		ret [];
	}
	else {
		let head : int = xs[i % xs_len];
		let tail : [int] = xlat(i + 1u, len - 1u);

		ret [head] + tail;
	}
}

fn xor(tp : (int, int)) -> int {
	let (a, b) : (int, int) = tp;
	ret a ^ b;
}

fn encrypt(password : str) -> str {
	let r : float = std::rand::mk_rng().next_float();

	let seed : uint = (r * 16.0f) as uint;

	let plaintext : [int] = vec::map(str::chars(password), { |c| ret c as int; });

	let keys : [int] = xlat(seed, str::char_len(password));

	check vec::same_length(plaintext, keys);

	let zipped : [(int, int)] = vec::zip(plaintext, keys);

	let ciphertext : [int] = vec::map(zipped, xor);

	ret #fmt(
		"%02d%s",
		seed as int,
		str::connect(
			vec::map(ciphertext, { |c| ret #fmt("%02x", c as uint); }),
			""
		)
	);
}

fn decrypt(password : str) -> str {
	// ...

	ret "";
}

fn usage() {
	// ...
}

fn main() {
	// ...

	std::io::println(encrypt("monkey"));
}