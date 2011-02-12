__author__="Andrew Pennebaker (andrew.pennebaker@gmail.com)"
__date__="21 Dec 2005 - 12 Apr 2006"
__copyright__="Copyright 2006 Andrew Pennebaker"
__version__="0.4"

from Cipher import Cipher

import os, sys
from getopt import getopt

TEST_MODE="TEST"
ENCRYPT_MODE="ENCRYPT"
DECRYPT_MODE="DECRYPT"

class IOS7Crypt(Cipher):
	DEFAULT_KEY_SIZE=1

	BLOCK_SIZE=1

	MAX_SEED=16

	XLAT=[
		0x64, 0x73, 0x66, 0x64, 0x3b, 0x6b, 0x66, 0x6f,
		0x41, 0x2c, 0x2e, 0x69, 0x79, 0x65, 0x77, 0x72,
		0x6b, 0x6c, 0x64, 0x4a, 0x4b, 0x44, 0x48, 0x53,
		0x55, 0x42, 0x73, 0x67, 0x76, 0x63, 0x61, 0x36,
		0x39, 0x38, 0x33, 0x34, 0x6e, 0x63, 0x78, 0x76,
		0x39, 0x38, 0x37, 0x33, 0x32, 0x35, 0x34, 0x6b,
		0x3b, 0x66, 0x67, 0x38, 0x37
	]

	TRUNCATE=11

	def __init__(self, secretKey=None, publicKey=None): # ignore publicKey
		if secretKey==None:
			self.setKeys(self.generateKeyPair()[0])
		else:
			self.setKeys(secretKey)

	def generateKeyPair(self, length=1):
		if length!=1:
			raise Exception, "This algorithm's key is always length one"

		return [ord(os.urandom(1))%self.MAX_SEED, None]

	def setKeys(self, secretKey=0, publicKey=None): # ignore publicKey
		if secretKey<0 or secretKey>25:
			raise "Seed is 0 through 25 inclusive (properly 0 through 15 inclusive)"

		self.secretKey=secretKey
		self.publicKey=None

	def encrypt(self, password=[0]):
		if len(password)<1:
			raise TypeError, "Null password"
		elif len(password)>self.TRUNCATE:
			password=password[:self.TRUNCATE]

		hash="%02d%s" % (
			self.secretKey,
			"".join(["%02X" % (password[i]^self.XLAT[self.secretKey+i]) for i in range(len(password))])
		)

		return [ord(e) for e in hash]

	def decrypt(self, hash=[48, 48, 48, 48]): # "0000"
		if len(hash)<4:
			raise "Invalid hash length"

		hash="".join([chr(e) for e in hash])

		self.secretKey=int(hash[:2])

		encrypted=hash[2:]

		cipherBytes=[]
		i=0
		while i<len(encrypted):
			pair=encrypted[i:i+2]

			cipherBytes.append(int(pair, 16))

			i+=2

		return [cipherBytes[i]^self.XLAT[(self.secretKey+i)%len(self.XLAT)] for i in range(len(cipherBytes))]

	def test(self):
		plaintext=[97, 98, 99] # "abc"
		self.secretKey=self.generateKeyPair()[0]

		self.setKeys(secretKey)
		encrypted=self.encrypt(plaintext)
		decrypted=self.decrypt(encrypted)

		if decrypted==plaintext:
			return "OK"

		return [plaintext, self.secretKey, encrypted, decrypted]

def usage():
	print "Usage: %s [options] <data>" % (sys.argv[0])
	print "\n-e|--encrypt encrypt data"
	print "-d|--decrypt decrypt data"
	print "-s|--seed <seed>"
	print "\n-t|--test test engine"
	print "\n-h|--help (usage)"

	sys.exit()

def main():
	global TEST_MODE
	global ENCRYPT_MODE
	global DECRYPT_MODE

	mode=ENCRYPT_MODE
	password=[48]
	seed=None
	hash=[48, 48, 48, 48] # "0000"

	systemArgs=sys.argv[1:] # ignore program name

	optlist=[]
	args=[]

	try:
		optlist, args=getopt(systemArgs, "eds:th", ["encrypt", "decrypt", "seed=", "test", "help"])
	except Exception, e:
		usage()

	if len(optlist)<1 and len(args)<1:
		usage()

	for option, value in optlist:
		if option=="-h" or option=="--help":
			usage()
		elif option=="-t" or option=="--test":
			mode=TEST_MODE

		if option=="-e" or option=="--encrypt":
			mode=ENCRYPT_MODE
		elif option=="-d" or option=="--decrypt":
			mode=DECRYPT_MODE
		elif option=="-s" or option=="--seed":
			try:
				seed=int(value)
				if seed<0 or seed>25:
					raise Exception
			except Exception, e:
				raise "Seed is between 0 and 25 inclusive"

	if mode==TEST_MODE:
		cipher=IOS7Crypt()
		print cipher.test()
	elif mode==ENCRYPT_MODE:
		password=[ord(e) for e in args[0]]
		cipher=IOS7Crypt(seed)
		print "".join([chr(e) for e in cipher.encrypt(password)])
	elif mode==DECRYPT_MODE:
		hash=[ord(e) for e in args[0]]
		cipher=IOS7Crypt(seed)
		print "".join([chr(e) for e in cipher.decrypt(hash)])

if __name__=="__main__":
	main()