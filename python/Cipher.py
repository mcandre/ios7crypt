__author__="Andrew Pennebaker (andrew.pennebaker@gmail.com)"
__date__="21 Dec 2005 - 12 Apr 2006"
__copyright__="Copyright 2005 Andrew Pennebaker"
__version__="0.1"

class Cipher:
	"""Base class for ciphers"""

	MODES=["ECB"] # for one
	FAMILY="Ciphers"
	ALIASES=["Cipher", "Code"]

	BLOCK_SIZE=1 # bytes

	def __init__(self, secretKey=None, publicKey=None):
		"""Pass key (a string) here before encryption/decryption, unless it needs to be generated;
in that case use generateKey() then setKey()."""

		if secretKey!=None or publicKey!=None:
			self.setKeys(secretKey, publicKey)

	def generateKeyPair(self, length=1):
		"""Returns a list of secret key followed by public key if public-key algorithm or None if secret-key algorithm."""

		return [1, 2]

	def setKeys(self, secretKey=None, publicKey=None):
		"""Set the keys after calling generateKeyPair(). Normally keys are passed at construction."""

		self.secretKey=secretKey
		self.publicKey=publicKey

	def getKeys(self):
		return (self.secretKey, self.publicKey)

	def i2array(self, data):
		"""Convert integer into integer array"""

		if data.__class__==(1).__class__:
			return [data]

		return data

	def pad(self, data):
		"""Each algorithm uses its own padding scheme. Data is a string, returns string."""

		return data

	def depad(self, data):
		"""Data is a string, returns string."""

		return self.pad(data) # in this case, no padding

	def encrypt(self, data, mode=None, options=[None]):
		"""Data is a string, mode must be in MODES, returns string."""

		return self.pad(data)

	def decrypt(self, data, mode=None, options=[None]):
		"""Data is a string, mode must be in MODES, returns string."""

		return self.depad(data)

	def test(self):
		"""Tests the engines"""

		secretKey, publicKey=self.generateKeyPair()
		self.setKeys(secretKey, publicKey)

		plaintext="abc"
		ciphertext=self.encrypt(plaintext)
		decrypted=self.decrypt(ciphertext)

		if secretKey==1 and publicKey==2 and self.secretKey==secretKey and self.publicKey==publicKey and plaintext==decrypted:
			return ("OK", [])

		return ("FAIL", [secretKey, publicKey, plaintext, ciphertext, decrypted])