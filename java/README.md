# ios7crypt/java

IOS7Crypt password encrypter/decrypter in Java

# EXAMPLE

```
$ gradle shadowJar
$ bin/ios7crypt -e monkey
00091c080f5e12
$ bin/ios7crypt -d 00091c080f5e12
monkey
$ java -jar build/libs/ios7crypt-all.jar
...
```

# REQUIREMENTS

* [JDK](http://www.oracle.com/technetwork/java/javase/downloads/index.html) 1.7+
* [Gradle](http://gradle.org/) 2.1+

## Optional

* [Sonar](http://www.sonarqube.org/)

E.g., `brew install gradle sonar sonar-runner`

# JAVADOCS

```
$ gradle javadoc
$ open build/docs/javadoc/index.html
```

# TEST + CODE COVERAGE

```
$ gradle jacoco
$ open build/reports/jacoco/test/html/index.html
```

# LINTING

```
$ gradle check
```

## Optional: Sonar

```
$ sonar start
$ gradle check sonar
$ open http://localhost:9000/
```
