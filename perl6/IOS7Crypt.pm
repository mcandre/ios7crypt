#!/usr/bin/env perl6

module IOS7Crypt {
    my @xlat=(
    0x64, 0x73, 0x66, 0x64, 0x3b, 0x6b, 0x66, 0x6f,
    0x41, 0x2c, 0x2e, 0x69, 0x79, 0x65, 0x77, 0x72,
    0x6b, 0x6c, 0x64, 0x4a, 0x4b, 0x44, 0x48, 0x53,
    0x55, 0x42, 0x73, 0x67, 0x76, 0x63, 0x61, 0x36,
    0x39, 0x38, 0x33, 0x34, 0x6e, 0x63, 0x78, 0x76,
    0x39, 0x38, 0x37, 0x33, 0x32, 0x35, 0x34, 0x6b,
    0x3b, 0x66, 0x67, 0x38, 0x37
    );

    my $xlat_len = @xlat.end;

    sub encrypt is export {
        my $password = @_.shift();

        my $seed = 15.rand.floor;

        my $hash = $seed.fmt("%02d");

        my $encrypted = '';

        loop (my $i = 0; $i < $password.chars; $i++) {
            my $encrypted_byte = $password.substr($i, 1).ord +^ @xlat[($seed++) % $xlat_len];
            $encrypted ~= $encrypted_byte.fmt("%02x");
        }

        return $hash ~ $encrypted;
    }

    sub decrypt is export {
        my $hash = @_.shift();

        if ($hash.chars < 4) {
            return '';
        }
        elsif ($hash !~~ /^(\d**2)(<xdigit>+)/) {
            return "Invalid hash";
        }

        $hash ~~ /^(\d**2)(<xdigit>+)/;

        my $seed = :10("$/[0]");

        my $encrypted = "$/[1]";

        my $len = $encrypted.chars;

        if ($len % 2 != 0) {
            $len--;
        }

        my $password = '';

        loop (my $i = 0; $i < $len; $i += 2) {
            my $hexpair = $encrypted.substr($i, 2);

            my $encrypted_byte = :16($hexpair);

            my $decrypted_byte = $encrypted_byte +^ @xlat[($seed++) % $xlat_len];
            $password ~= $decrypted_byte.chr;
        }

        return $password;
    }

    sub usage is export {
        say "Usage: $*PROGRAM_NAME [options]";
        say '-e=<password>';
        say '-d=<hash>';

        exit 0;
    }
}

sub MAIN(:$e = '', :$d = '') {
    import IOS7Crypt;

    if ($e ne '') {
        my $hash = encrypt($e);
        say $hash;
    }
    elsif ($d ne '') {
        my $password = decrypt($d);
        say $password;
    }
    else {
        usage;
    }
}
