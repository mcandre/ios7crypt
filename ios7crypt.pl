#!/usr/bin/env perl

use Test::LectroTest;
use strict;
use warnings;

my @xlat=(
	0x64, 0x73, 0x66, 0x64, 0x3b, 0x6b, 0x66, 0x6f,
	0x41, 0x2c, 0x2e, 0x69, 0x79, 0x65, 0x77, 0x72,
	0x6b, 0x6c, 0x64, 0x4a, 0x4b, 0x44, 0x48, 0x53,
	0x55, 0x42, 0x73, 0x67, 0x76, 0x63, 0x61, 0x36,
	0x39, 0x38, 0x33, 0x34, 0x6e, 0x63, 0x78, 0x76,
	0x39, 0x38, 0x37, 0x33, 0x32, 0x35, 0x34, 0x6b,
	0x3b, 0x66, 0x67, 0x38, 0x37
);

sub encrypt {
	my $password = shift;

	my $seed = int(rand 15);

	my $hash = $seed;
	$hash = "0" . $hash if ($hash < 10);

	my $encrypted;

	my $stop = length $password;

	for (my $i = 0; $i < $stop; $i++) {
		$password =~ s/^(.)//;
		my $encrypted_byte = ord($1) ^ $xlat[$seed++];
		$encrypted .= unpack("H*", chr $encrypted_byte);
	}

	$hash .= $encrypted;

	return $hash;
}

sub decrypt {
	my $hash = shift;

	my $password;

	my ($seed, $encrypted) = ($hash =~ /^(\d{2})([\da-f]+)/i);

	my $stop = length($encrypted) / 2;

	for (my $i = 0; $i < $stop; $i++) {
		$encrypted =~ s/^([\da-f]{2})//i;
		my $decrypted_byte = hex($1) ^ $xlat[$seed++];
		$password .= chr($decrypted_byte);
	}

	return $password;
}

sub usage {
	print "Usage: $0 [options]\n";
	print "-e\t<password>\n";
	print "-d\t<hash>\n";

	exit 0;
}

sub test {
	Property {
		##[ password <- String ]##
		decrypt(encrypt($password)) eq $password;
	}, name => "crypto should be reversible";
}

if (@ARGV < 1) {
	usage;
}

my $mode = shift;

if ($mode eq "-e") {
	if (@ARGV < 1) {
		usage;
	}

	my $password = shift;

	my $hash = encrypt $password;

	print "$hash\n";
}
elsif ($mode eq "-d") {
	if (@ARGV < 1) {
		usage;
	}

	my $hash = shift;

	my $password = decrypt $hash;

	print "$password\n";
}
elsif ($mode eq "-t") {
	test;
}
else {
	usage;
}