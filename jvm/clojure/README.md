# ios7crypt/clojure

IOS7Crypt encrypter/decrypter in Clojure

# EXAMPLE

```
$ gradle clean shadowJar
java -jar build/libs/clojure-all.jar -e monkey
141a1d05070133
$ java -jar build/libs/clojure-all.jar -d 141a1d05070133
monkey
```
