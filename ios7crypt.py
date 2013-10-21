#!/usr/bin/env python3

"""IOS7Crypt password encryptor/decryptor"""

import os, sys
from getopt import getopt

XLAT = [
  0x64, 0x73, 0x66, 0x64, 0x3b, 0x6b, 0x66, 0x6f,
  0x41, 0x2c, 0x2e, 0x69, 0x79, 0x65, 0x77, 0x72,
  0x6b, 0x6c, 0x64, 0x4a, 0x4b, 0x44, 0x48, 0x53,
  0x55, 0x42, 0x73, 0x67, 0x76, 0x63, 0x61, 0x36,
  0x39, 0x38, 0x33, 0x34, 0x6e, 0x63, 0x78, 0x76,
  0x39, 0x38, 0x37, 0x33, 0x32, 0x35, 0x34, 0x6b,
  0x3b, 0x66, 0x67, 0x38, 0x37
  ]

def encrypt(password):
  seed = ord(os.urandom(1)) % 16
  return "%02d%s" % (seed, "".join(
    ["%02x" % (
      ord(password[i]) ^ XLAT[seed + i]
    ) for i in range(len(password))])
  )

def decrypt(h):
  seed, h = int(h[:2]), h[2:]
  cipher_bytes = [int(h[i : i + 2], 16) for i in range(0, len(h), 2)]
  return "".join(
    [chr(
      cipher_bytes[i] ^ XLAT[(seed + i) % len(XLAT)]
    ) for i in range(len(cipher_bytes))]
  )

def test():
  # ...

  pass

def usage():
  print("Usage: %s [options]" % (sys.argv[0]))
  print("-e --encrypt\t<password>")
  print("-d --decrypt\t<hash>")
  print("-t --test\trun unit tests")
  print("-h --help\tusage")

  sys.exit()

def main():
  encrypt_mode = "ENCRYPT"
  decrypt_mode = "DECRYPT"
  test_mode = "TEST"

  mode = encrypt_mode
  password = ""
  h = ""

  optlist, args = [], []

  try:
    optlist, args = getopt(
      sys.argv[1:],
      "e:d:th",
      ["encrypt=", "decrypt=", "test", "help"]
    )
  except Exception:
    usage()

  if len(optlist) < 1:
    usage()

  for option, value in optlist:
    if option == "-h" or option == "--help":
      usage()
    elif option == "-e" or option == "--encrypt":
      mode = encrypt_mode
      password = value
    elif option == "-d" or option == "--decrypt":
      mode = decrypt_mode
      h = value
    elif option == "-t" or option == "--test":
      mode = test_mode

  if mode == encrypt_mode:
    print(encrypt(password))
  elif mode == decrypt_mode:
    print(decrypt(h))
  elif mode == test_mode:
    test()

if __name__ == "__main__":
  main()
