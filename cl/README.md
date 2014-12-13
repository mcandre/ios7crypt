# ios7crypt/cl

IOS7Crypt password encrypter/decrypter in Common Lisp (CLISP)

# EXAMPLE

```
$ ./ios7crypt.lisp -e monkey
1308181c00091d
$ ./ios7crypt.lisp -d 1308181c00091d
monkey
$ ./ios7crypt.lisp -t
Starting tests with seed #S(RANDOM-STATE #*1110100011000010111111110111100001111011111000000010010110010011)
....................................................................................................
1 test submitted; all passed.
```
