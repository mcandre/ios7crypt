#! /usr/bin/env factor

USING: io ;
IN: ios7crypt

: usage ( -- )
    "Usage: ios7crypt.factor [options]" print
    "-encrypt <password>" print
    "-decrypt <hash>" print
    "-test" print
    "-help" print ;

: main ( -- )
    usage
    ! ...
    ;

MAIN: main