// ios7crypt.rs
// Andrew Pennebaker
// 7 Feb 2012

#[link(name = "ios7crypt")];

extern mod std;
extern mod extra;

use std::os::args;
use std::fmt;
use std::str::from_utf8;
use std::rand::{task_rng, Rng};

use std::iter::Zip;
use std::vec::VecIterator;
use std::iter::Iterator;

use std::option::Option;
use std::option::Some;
use std::option::None;

use extra::getopts::getopts;
use extra::getopts::Opt;
use extra::getopts::groups::OptGroup;
use extra::getopts::groups::optflag;
use extra::getopts::groups::optopt;
use extra::getopts::Matches;
use extra::getopts::groups::usage;

fn xlat_prime() -> [int, ..53] {
  return [
    0x64, 0x73, 0x66, 0x64, 0x3b, 0x6b, 0x66, 0x6f,
    0x41, 0x2c, 0x2e, 0x69, 0x79, 0x65, 0x77, 0x72,
    0x6b, 0x6c, 0x64, 0x4a, 0x4b, 0x44, 0x48, 0x53,
    0x55, 0x42, 0x73, 0x67, 0x76, 0x63, 0x61, 0x36,
    0x39, 0x38, 0x33, 0x34, 0x6e, 0x63, 0x78, 0x76,
    0x39, 0x38, 0x37, 0x33, 0x32, 0x35, 0x34, 0x6b,
    0x3b, 0x66, 0x67, 0x38, 0x37
  ];
}

fn xlat(i : uint, len : uint) -> ~[int] {
  let xs : [int, ..53] = xlat_prime();
  let xs_len : uint = xs.len();

  if len < 1u {
    return [].to_owned();
  }
  else {
    let head : int = xs[i % xs_len];
    let tail : ~[int] = xlat(i + 1u, len - 1u);

    return ([head] + tail).to_owned();
  }
}

fn xor(tp : &(int, int)) -> int {
  let (a, b) : (int, int) = *tp;
  return a ^ b;
}

fn encrypt(password : ~str) -> ~str {
  let rng = task_rng();

  let seed : uint = rng.gen_integer_range(0u, 16);

  let plaintext : &[int] = password.as_bytes().map( |e| *e as int );

  let keys : ~[int] = xlat(seed, password.len());

  assert_eq!(plaintext.len(), keys.len());

  let zipped : ~[(int, int)] = plaintext.iter().zip(keys.iter()).from_iterator();

  let ciphertext : ~[int] = zipped.map(xor);

  return fmt!(
    "%02d%s",
    seed as int,
    ciphertext.map( |c| { return fmt!("%02x", *c as uint); } ).connect("")
  );
}

fn decrypt(hash : ~str) -> ~str {
  if hash.len() < 2u {
    return "".to_owned();
  }
  else {
    let seedStr : &str = hash.slice_chars(0u, 2u);

    let seed : int = 0; // ...

    let hashStr : &str = hash.slice_chars(2u, hash.len() - 2u);

    // ...

    return "".to_owned();
  }
}

fn test() {
  // ...
}

fn main() {
  let args : ~[~str] = args();

  assert_eq!(args.len() > 0, true);

  let program : &~str = args.head();

  let opts : &[OptGroup] = ~[
    optflag("h", "help", "print usage info"),
    optopt("e", "encrypt", "encrypt a password", "VAL"),
    optopt("d", "decrypt", "decrypt a hash", "VAL"),
    optflag("t", "test", "run unit tests")
  ];

  let result : Matches = match getopts(args.tail(), opts.map(|e| { return e.long_to_short(); } )) {
    Ok(m) => m,
    Err(f) => fail!(usage(*program, opts))
  };

  if result.opt_present("e") || result.opt_present("encrypt") {
    let password : ~str = match result.opt_str("encrypt") {
      Some(v) => v,
      None => fail!(usage(*program, opts))
    };

    let hash : ~str = encrypt(password);

    println(hash);
  }
  else if result.opt_present("d") || result.opt_present("decrypt") {
    let hash : ~str = match result.opt_str("decrypt") {
      Some(v) => v,
      None => fail!(usage(*program, opts))
    };

    let password : ~str = decrypt(hash);

    println(password);
  }
  else if result.opt_present("t") || result.opt_present("test") {
    test();
  }
  else {
    fail!(usage(*program, opts))
  }
}
