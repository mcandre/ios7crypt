#! /usr/bin/env factor

USING:
    kernel
    namespaces
    sequences
    arrays
    strings
    grouping
    combinators
    io
    command-line
    math
    math.ranges
    math.parser
    random
    formatting ;

IN: ios7crypt

: xlat ( -- seq ) {
    HEX: 64 HEX: 73 HEX: 66 HEX: 64 HEX: 3b HEX: 6b HEX: 66 HEX: 6f
    HEX: 41 HEX: 2c HEX: 2e HEX: 69 HEX: 79 HEX: 65 HEX: 77 HEX: 72
    HEX: 6b HEX: 6c HEX: 64 HEX: 4a HEX: 4b HEX: 44 HEX: 48 HEX: 53
    HEX: 55 HEX: 42 HEX: 73 HEX: 67 HEX: 76 HEX: 63 HEX: 61 HEX: 36
    HEX: 39 HEX: 38 HEX: 33 HEX: 34 HEX: 6e HEX: 63 HEX: 78 HEX: 76
    HEX: 39 HEX: 38 HEX: 37 HEX: 33 HEX: 32 HEX: 35 HEX: 34 HEX: 6b
    HEX: 3b HEX: 66 HEX: 67 HEX: 38 HEX: 37
} ;

: xlat-nth ( n -- n ) xlat length mod xlat nth ;

: keys ( n r -- seq ) dup rot + 1 <range> [ xlat-nth ] map ;

: encrypt ( str -- str )
    >array ! passchars
    0 15 1 <range> random ! passchars seed
    swap 2dup length swap keys ! seed passchars keys
    [ bitxor ] 2map ! seed ciphertext
    [ "%02x" sprintf ] map "" join ! seed hexciphertext
    swap "%02d" sprintf swap

    append ;

: decrypt ( str -- str/f )
    dup 0 2 rot subseq 10 base> ! hash seed/f

    [ ! Is seed valid?
        ! hash seed

        swap dup length ! seed hash rawlen

        dup even? ! Reduce hash to valid hexpairs
        [ ]
        [ 1 - ]
        if ! seed hash len

        2 swap rot subseq 2 group ! seed hexpairs
        dup length rot keys swap ! keys hexpairs
        [ 16 base> ] map ! keys rawciphertext

        dup f swap member? ! Any invalid numbers?
        [ drop drop f ]
        [ [ bitxor ] 2map >string ]
        if
    ]
    [ drop f ]
    if* ;

: test ( -- )
    "monkey"
    "060b002f474b10"
    decrypt
    assert=

    "haberdasher"
    "12110415171908053923213a"
    decrypt
    assert=

    "All tests pass" print
    ;

: usage ( -- )
    "Usage: ios7crypt.factor [options]" print
    "-e=<password>" print
    "-d=<hash>" print
    "-t" print
    "-h" print ;

: main ( -- )
    command-line get parse-command-line

    {
        { [ "h" get ] [ usage ] }
        { [ "e" get string? ] [ "e" get encrypt print ] }
        { [ "d" get string? ] [ "d" get decrypt [ print ] [ "Invalid hash" print ] if* ] }
        { [ "t" get ] [ test ] }
        [ usage ]
    }
    cond ;

MAIN: main