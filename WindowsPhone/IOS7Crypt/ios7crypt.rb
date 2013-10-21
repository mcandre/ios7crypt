# Author:: Andrew Pennebaker
# Copyright:: Copyright 2012 Andrew Pennebaker
#
# == Synopsis
#
# ios7crypt: encrypts and decrypts passwords with Cisco IOS7 algorithm

$xlat=[
	0x64, 0x73, 0x66, 0x64, 0x3b, 0x6b, 0x66, 0x6f,
	0x41, 0x2c, 0x2e, 0x69, 0x79, 0x65, 0x77, 0x72,
	0x6b, 0x6c, 0x64, 0x4a, 0x4b, 0x44, 0x48, 0x53,
	0x55, 0x42, 0x73, 0x67, 0x76, 0x63, 0x61, 0x36,
	0x39, 0x38, 0x33, 0x34, 0x6e, 0x63, 0x78, 0x76,
	0x39, 0x38, 0x37, 0x33, 0x32, 0x35, 0x34, 0x6b,
	0x3b, 0x66, 0x67, 0x38, 0x37
]

def encrypt(password)
	seed=rand(16)

	hash=(0 .. (password.length-1)).collect { |i| $xlat[(seed+i) % $xlat.length] ^ password[i] }

	format("%02d", seed) + hash.collect { |e| format("%02x", e) }.join("")
end

def decrypt(hash)
	seed=hash[0, 2].to_i

	hash=hash[2, hash.length-1]

	pairs=(0 .. (hash.length/2-1)).collect { |i| hash[i*2, 2].to_i(16) }

	decrypted=(0 .. (pairs.length-1)).collect { |i| $xlat[(seed+i) % $xlat.length] ^ pairs[i] }

	decrypted.collect { |e| e.chr }.join("")
end