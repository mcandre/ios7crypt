# ios7crypt/c

IOS7Crypt password encrypter/decrypter in C

# EXAMPLE

```
$ make
mkdir -p bin/
clang -O2 -Wall -Wextra -Wmost -Weverything -Wno-pointer-arith -o bin/ios7crypt ios7crypt.c ../qc/qc.c -lgc
./bin/ios7crypt -e monkey
0941410712000e
./bin/ios7crypt -d 050609012a4957
monkey
./bin/ios7crypt -t
+++ OK, passed 100 tests.
```

# REQUIREMENTS

* A C compiler (e.g., `clang`, `gcc`, `cl`)
* [qc](https://github.com/mcandre/qc)

## Optional

* [Python](https://www.python.org/) 2+ (for infer)
