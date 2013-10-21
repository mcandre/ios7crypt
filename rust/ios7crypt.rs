// ios7crypt.rs
// Andrew Pennebaker
// 7 Feb 2012

#[link(name = "ios7crypt")];

use std;
import std::getopts::*;
import result::*;

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

fn decrypt(hash : str) -> str {
  if str::char_len(hash) < 2u {
    ret "";
  }
  else {
    let seedStr : str = str::substr(hash, 0u, 2u);

    let seed : int = 0; // ...

    let hashStr : str = str::substr(hash, 2u, str::char_len(hash) - 2u);

    // ...

    ret "";
  }
}

fn test() {
  // ...
}

fn usage(program: str) {
  std::io::println("Usage: " + program + " [options]");
  std::io::println("-e --encrypt <password>\tEncrypt");
  std::io::println("-d --decrypt <hash>\tDecrypt");
  std::io::println("-t --test\t\tUnit test");
  std::io::println("-h --help\t\tUsage");
}

fn main(args: [str]) {
  check vec::is_not_empty(args);

  let program : str = vec::head(args);

  let opts = [
    optflag("h"),
    optflag("help"),
    optopt("e"),
    optopt("encrypt"),
    optopt("d"),
    optopt("decrypt"),
    optopt("t"),
    optopt("test")
  ];

  let match = alt getopts(vec::tail(args), opts) {
    ok(m) { m }
    err(f) { fail fail_str(f) }
  };

  if opt_present(match, "e") || opt_present(match, "encrypt") {
    let password : str = opt_str(match, "encrypt");

    let hash : str = encrypt(password);

    std::io::println(hash);
  }
  else if opt_present(match, "d") || opt_present(match, "decrypt") {
    let hash : str = opt_str(match, "decrypt");

    let password : str = decrypt(hash);

    std::io::println(password);
  }
  else if opt_present(match, "t") || opt_present(match, "test") {
    test();
  }
  else {
    usage(program);
  }
}
