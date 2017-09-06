# ios7crypt - IOS7Crypt in various programming languages

# EXAMPLE

```
$ cd python/
$ python ios7crypt.py -e monkey
1308181c00091d
$ python ios7crypt.py -d 1308181c00091d
monkey
```

# DISCLAIMER

Cisco routers have traditionally used an extremely weak encryption algorithm for protecting passwords (since IOSv7).

Cisco has [acknowledged](http://www.cisco.com/en/US/tech/tk59/technologies_tech_note09186a00809d38a7.shtml) this insecurity.

Herein are contained proof of concept decryption programs in a multitude of programming languages, not intended for any malicious hacking but for research purposes only.
