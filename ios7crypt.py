#!/usr/bin/env python3

import os, sys
from getopt import getopt

xlat = [
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
	return "%02d%s" % (seed, "".join(["%02x" % (ord(password[i]) ^ xlat[seed + i]) for i in range(len(password))]))

def decrypt(h):
	seed, h = int(h[:2]), h[2:]
	cipherBytes = [int(h[i : i + 2], 16) for i in range(0, len(h), 2)]
	return "".join([chr(cipherBytes[i] ^ xlat[(seed + i) % len(xlat)]) for i in range(len(cipherBytes))])

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
	ENCRYPT_MODE = "ENCRYPT"
	DECRYPT_MODE = "DECRYPT"
	TEST_MODE = "TEST"

	mode = ENCRYPT_MODE
	password = ""
	h = ""

	optlist, args = [], []

	try:
		optlist, args=getopt(sys.argv[1:], "e:d:th", ["encrypt=", "decrypt=", "test", "help"])
	except Exception:
		usage()

	if len(optlist) < 1:
		usage()

	for option, value in optlist:
		if option=="-h" or option=="--help":
			usage()
		elif option=="-e" or option=="--encrypt":
			mode = ENCRYPT_MODE
			password = value
		elif option=="-d" or option=="--decrypt":
			mode=DECRYPT_MODE
			h = value
		elif option=="-t" or option=="--test":
			mode=TEST_MODE

	if mode == ENCRYPT_MODE:
		print(encrypt(password))
	elif mode == DECRYPT_MODE:
		print(decrypt(h))
	elif mode == TEST_MODE:
		test()

if __name__=="__main__":
	main()