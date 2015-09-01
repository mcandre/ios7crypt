# ios7crypt/java

IOS7Crypt password encrypter/decrypter in Java

# EXAMPLE

```
$ mvn package
$ bin/ios7crypt -e monkey
00091c080f5e12
$ bin/ios7crypt -d 00091c080f5e12
monkey
$ java -jar target/ios7crypt-0.0.1-jar-with-dependencies.jar
...
```

# REQUIREMENTS

* [JDK](http://www.oracle.com/technetwork/java/javase/downloads/index.html) 1.8+

# CODE COVERAGE

```
$ mvn site
$ open target/site/coburtura/index.html
```
