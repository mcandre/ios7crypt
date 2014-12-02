# Example

```
$ mvn package
$ mvn exec:java -Dexec.mainClass=us.yellosoft.ios7crypt.CommandLine -Dexec.args="-e monkey"
00091c080f5e12
$ mvn exec:java -Dexec.mainClass=us.yellosoft.ios7crypt.CommandLine -Dexec.args="-d 00091c080f5e12"
monkey
$ mvn exec:java -Dexec.mainClass=us.yellosoft.ios7crypt.IOS7CryptGUI
...
```

# Code coverage

```
$ mvn site
$ open target/site/coburtura/index.html
```
