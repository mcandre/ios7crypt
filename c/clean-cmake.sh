#!/bin/sh
unset IFS
set -euf

rm -rf crash-*
rm -rf leak-*
rm -rf debug
rm -rf bin
rm -rf Testing
rm -f Makefile

/usr/bin/find . \
    -iwholename '*cmake*' \
    -not -name CMakeLists.txt \
    -not -name clean-cmake.sh \
    -print \
    -exec rm -rf '{}' \;
