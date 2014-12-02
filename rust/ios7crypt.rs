//! IOS7Crypt port for Rust
//! Andrew Pennebaker
//! 7 Feb 2012 - 2 Dec 2014

#![crate_id(name = "ios7crypt")]

extern crate std;
extern crate getopts;

use std::os::args;
use std::rand::{task_rng};
use std::rand::distributions::{IndependentSample, Range};

use std::int::parse_bytes;
use std::str::from_utf8;

use std::iter::Iterator;

use std::option::Some;
use std::option::None;

use getopts::{getopts, OptGroup, optflag, optopt, usage, Matches};

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

fn xlat(i : uint, len : uint) -> Vec<int> {
  let xs : [int, ..53] = xlat_prime();
  let xs_len : uint = xs.len();

  if len < 1u {
    return Vec::new();
  }
  else {
    let mut head : Vec<int> = Vec::new();
    head.push(xs[i % xs_len]);

    let tail : Vec<int> = xlat(i + 1u, len - 1u);

    return head + tail;
  }
}

fn xor(tp : (&int, &int)) -> int {
  let (a, b) : (&int, &int) = tp;
  return (*a) ^ (*b);
}

fn encrypt(password : String) -> String {
  let mut rng = task_rng();

  let seed : uint = Range::new(0u, 16u).ind_sample(&mut rng);

  let password_bytes : &[u8] = password.as_bytes();

  let plaintext : Vec<int> = Vec::from_fn(password.len(), |index| *(password_bytes.get(index).unwrap()) as int );

  let keys : Vec<int> = xlat(seed, password.len());

  assert_eq!(plaintext.len(), keys.len());

  let zipped : Vec<(&int, &int)> = plaintext.iter().zip(keys.iter()).collect();

  let ciphertext : Vec<int> = Vec::from_fn(password.len(), |index| xor(*(zipped.get(index))));

  return format!(
    "{:02d}{}",
    seed as int,
    Vec::from_fn(password.len(), |index| format!("{:02x}", *(ciphertext.get(index)) as uint) ).connect("")
  );
}

fn decrypt(hash : String) -> String {
  if hash.len() < 2u {
    return "".to_string();
  }
  else {
    let hash_slice : &str = hash.as_slice();

    let seed_str : &str = hash_slice.slice(0u, 2u);

    let seed : uint = match parse_bytes(seed_str.as_bytes(), 10) {
      Some(v) => v as uint,
      None => fail!("Invalid seed")
    };

    let hash_str : &str = hash_slice.slice(2u, hash.len());

    let hexpairs : Vec<&str> = range(0, hash_str.len() / 2).map( |i| hash_str.slice_chars(i * 2, i * 2 + 2) ).collect();

    let ciphertext : Vec<int> = Vec::from_fn(hexpairs.len(), |index| match parse_bytes(hexpairs.get(index).as_bytes(), 16) {
        Some(v) => v,
        None => fail!("Invalid ciphertext")
      }
    );

    let keys : Vec<int> = xlat(seed, ciphertext.len());

    assert_eq!(ciphertext.len(), keys.len());

    let zipped : Vec<(&int, &int)> = ciphertext.iter().zip(keys.iter()).collect();

    let plainbytes : Vec<int> = Vec::from_fn(hexpairs.len(), |index| xor(*(zipped.get(index))));

    let plaintext : Vec<u8> = Vec::from_fn(plainbytes.len(), |index| (plainbytes.get(index).to_u8()).unwrap());

    let password : &str = from_utf8(plaintext.as_slice()).unwrap();

    return password.to_string();
  }
}

fn main() {
  let argv : Vec<String> = args();

  assert_eq!(argv.len() > 0, true);

  let program : &String = argv.get(0);

  let opts : &[OptGroup] = &[
    optflag("h", "help", "print usage info"),
    optopt("e", "encrypt", "encrypt a password", "VAL"),
    optopt("d", "decrypt", "decrypt a hash", "VAL"),
  ];

  let rest = argv.slice(1, argv.len());

  let result : Matches = getopts(rest, opts).unwrap();

  if result.opt_present("e") || result.opt_present("encrypt") {
    let password : String = result.opt_str("encrypt").unwrap();

    let hash : String = encrypt(password);

    println!("{}", hash);
  }
  else if result.opt_present("d") || result.opt_present("decrypt") {
    let hash : String = result.opt_str("decrypt").unwrap();

    let password : String = decrypt(hash);

    println!("{}", password);
  }
  else {
    println!("{}", usage(program.as_slice(), opts));
  }
}
