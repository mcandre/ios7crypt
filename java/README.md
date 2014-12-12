# ios7crypt/java

IOS7Crypt password encrypter/decrypter in Java

# EXAMPLE

```
$ mvn package
$ mvn exec:java -Dexec.mainClass=us.yellosoft.ios7crypt.CommandLine -Dexec.args="-e monkey"
00091c080f5e12
$ mvn exec:java -Dexec.mainClass=us.yellosoft.ios7crypt.CommandLine -Dexec.args="-d 00091c080f5e12"
monkey
$ mvn exec:java -Dexec.mainClass=us.yellosoft.ios7crypt.IOS7CryptGUI
...
$ java -jar target/ios7crypt-0.0.1.jar
...
```

# REQUIREMENTS

* [JDK](http://www.oracle.com/technetwork/java/javase/downloads/index.html) 1.6+

# CODE COVERAGE

```
$ mvn site
$ open target/site/coburtura/index.html
```
