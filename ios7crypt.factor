#! /usr/bin/env factor

USING: kernel namespaces io command-line prettyprint ;
IN: ios7crypt

: usage ( -- )
    "Usage: ios7crypt.factor [options]" print
    "-encrypt <password>" print
    "-decrypt <hash>" print
    "-test" print
    "-help" print ;

: main ( -- )
    command-line get parse-command-line
    "help" get .
    ! [ usage ]
    ! [ "BLARGH" print ]
    ! if
    ;

MAIN: main