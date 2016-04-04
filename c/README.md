# ios7crypt/c

IOS7Crypt password encrypter/decrypter in C

# EXAMPLE

```
$ git submodule init
$ git submodule update
$ cd qc/
$ cmake . && make
$ cd ../

$ cmake . && make

$ bin/ios7crypt -e monkey
0941410712000e

$ bin/ios7crypt -d 050609012a4957
monkey

$ bin/ios7crypt -t
+++ OK, passed 100 tests.
```

# REQUIREMENTS

## Compiler Collection

* [clang](http://clang.llvm.org/)

E.g. from Xcode

* [gcc](https://gcc.gnu.org/)

E.g. from Apt, Dnf, Homebrew, MinGW, Strawberry Perl

## CMake

* [cmake](https://cmake.org/)

E.g. `brew install cmake`

## Optional

* [Python](https://www.python.org/) 2+ (for infer)
