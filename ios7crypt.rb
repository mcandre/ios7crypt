#!/usr/bin/env ruby

# Author:: Andrew Pennebaker
# Copyright:: Copyright 2007 Andrew Pennebaker
#
# == Synopsis
#
# ios7crypt: encrypts and decrypts passwords with Cisco IOS7 algorithm
#
# == Usage
#
# ios7crypt [OPTIONS]
#
# --help, -h:
#    show help
#
# --encrypt, -e <password>
#    prints out the encrypted password as a hash
#
# --decrypt, -d <hash>
#    prints out the decrypted hash as a password
#
# --test, -t
#    runs unit tests

require "rubygems"
require "rushcheck"
require "getoptlong"
require "rdoc/usage"

$xlat=[
	0x64, 0x73, 0x66, 0x64, 0x3b, 0x6b, 0x66, 0x6f,
	0x41, 0x2c, 0x2e, 0x69, 0x79, 0x65, 0x77, 0x72,
	0x6b, 0x6c, 0x64, 0x4a, 0x4b, 0x44, 0x48, 0x53,
	0x55, 0x42, 0x73, 0x67, 0x76, 0x63, 0x61, 0x36,
	0x39, 0x38, 0x33, 0x34, 0x6e, 0x63, 0x78, 0x76,
	0x39, 0x38, 0x37, 0x33, 0x32, 0x35, 0x34, 0x6b,
	0x3b, 0x66, 0x67, 0x38, 0x37
]

class String
	def encrypt
		seed=rand(16)

		hash=(0 .. (self.length-1)).collect { |i| $xlat[(seed+i) % $xlat.length] ^ self[i] }

		format("%02d", seed) + hash.collect { |e| format("%02x", e) }.join("")
	end

	def decrypt
		seed=self[0, 2].to_i

		hash=self[2, self.length-1]

		pairs=(0 .. (hash.length/2-1)).collect { |i| hash[i*2, 2].to_i(16) }

		decrypted=(0 .. (pairs.length-1)).collect { |i| $xlat[(seed+i) % $xlat.length] ^ pairs[i] }

		decrypted.collect { |e| e.chr }.join("")
	end
end

def test
	RushCheck::Assertion.new(String) { |s| s == s.encrypt.decrypt }.check
end

def main
	mode = :usage

	password = ""
	hash = ""

	opts=GetoptLong.new(
		["--help", "-h", GetoptLong::NO_ARGUMENT],
		["--encrypt", "-e", GetoptLong::REQUIRED_ARGUMENT],
		["--decrypt", "-d", GetoptLong::REQUIRED_ARGUMENT],
		["--test", "-t", GetoptLong::NO_ARGUMENT]
	)

	opts.each { |option, value|
		case option
		when "--help"
			RDoc::usage("Usage")
		when "--encrypt"
			mode = :encrypt
			password = value
		when "--decrypt"
			mode = :decrypt
			hash = value
		when "--test"
			mode = :test
		end
	}

	case mode
	when :usage
		RDoc::usage("Usage")
	when :encrypt
		puts password.encrypt
	when :decrypt
		puts hash.decrypt
	when :test
		test
	end
end

if __FILE__==$0
	begin
		main
	rescue Interrupt => e
		nil
	end
end