#!/usr/bin/env perl

use strict;
use warnings;

use Test::LectroTest::Compat;

my @xlat=(
0x64, 0x73, 0x66, 0x64, 0x3b, 0x6b, 0x66, 0x6f,
0x41, 0x2c, 0x2e, 0x69, 0x79, 0x65, 0x77, 0x72,
0x6b, 0x6c, 0x64, 0x4a, 0x4b, 0x44, 0x48, 0x53,
0x55, 0x42, 0x73, 0x67, 0x76, 0x63, 0x61, 0x36,
0x39, 0x38, 0x33, 0x34, 0x6e, 0x63, 0x78, 0x76,
0x39, 0x38, 0x37, 0x33, 0x32, 0x35, 0x34, 0x6b,
0x3b, 0x66, 0x67, 0x38, 0x37
);

my $xlat_len = scalar @xlat;

sub encrypt {
    my $password = shift;

    my $seed = int(rand 15);

    my $hash = $seed;
    $hash = "0" . $hash if ($hash < 10);

    my $encrypted = "";

    for (my $i = 0; $i < length $password; $i++) {
        my $encrypted_byte = ord(substr($password, $i, 1)) ^ $xlat[($seed++) % $xlat_len];
        $encrypted .= unpack("H*", chr $encrypted_byte);
    }

    $hash .= $encrypted;

    return $hash;
}

sub decrypt {
    my $hash = shift;

    if (length $hash < 4) {
        return "";
    }
    elsif ($hash !~ /^([0-9]{2})([a-fA-F0-9]+)/) {
        return "Invalid hash";
    }

    my ($seed, $encrypted) = ($hash =~ /^([0-9]{2})([a-fA-F0-9]+)/i);

    my $len = length $encrypted;

    if ($len % 2 != 0) {
        $len--;
    }

    my $password;

    for (my $i = 0; $i < $len; $i += 2) {
        my $decrypted_byte = hex(substr($encrypted, $i, 2)) ^ $xlat[($seed++) % $xlat_len];
        $password .= chr($decrypted_byte);
    }

    return $password;
}

sub usage {
    print "Usage: $0 [options]\n";
    print "-e\t<password>\n";
    print "-d\t<hash>\n";
    print "-t\tself-test\n";

    exit 0;
}

sub test {
    holds(
    Property {
        ##[ password <- String(charset=>"\x00-\x7f") ]##
        decrypt(encrypt($password)) eq $password;
    }, name => "crypto should be reversible"
    );
}

sub main {
    if (@ARGV < 1) {
        usage;
    }

    my $mode = shift @ARGV;

    if ($mode eq "-e") {
        if (@ARGV < 1) {
            usage;
        }

        my $password = shift @ARGV;

        my $hash = encrypt $password;

        print "$hash\n";
    }
    elsif ($mode eq "-d") {
        if (@ARGV < 1) {
            usage;
        }

        my $hash = shift @ARGV;

        my $password = decrypt $hash;

        print "$password\n";
    }
    elsif ($mode eq "-t") {
        test;
    }
    else {
        usage;
    }
}

main unless caller;
