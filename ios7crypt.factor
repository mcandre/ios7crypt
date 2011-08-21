#! /usr/bin/env factor

USING: kernel namespaces combinators io command-line ;
IN: ios7crypt

: encrypt ( str -- str )
    ! ...
    ;

: decrypt ( str -- str )
    ! ...
    ;

: test ( -- )
    "Testing..." print
    ! ...
    ;

: usage ( -- )
    "Usage: ios7crypt.factor [options]" print
    "-e <password>" print
    "-d <hash>" print
    "-t" print
    "-h" print ;

: main ( -- )
    command-line get parse-command-line

    {
        { [ "h" get ] [ usage ] }
        { [ "e" get ] [ "e" get encrypt print ] }
        { [ "d" get ] [ "d" get decrypt print ] }
        { [ "t" get ] [ test ] }
        [ usage ]
    }
    cond ;

MAIN: main