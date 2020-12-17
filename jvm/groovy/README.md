# IOS7Crypt.groovy

# EXAMPLE

```
$ gradle shadowJar
$ bin/ios7crypt -e monkey
060b002f474b10
$ bin/ios7crypt -d 060b002f474b10
monkey
```

# REQUIREMENTS

* [JDK](http://www.oracle.com/technetwork/java/javase/downloads/index.html) 1.11+
* [Gradle](http://gradle.org/) 6+
* [Gruesome](https://github.com/mcandre/gruesome) 0.1

## Optional

* [Sonar](http://www.sonarqube.org/)

E.g., `brew install gradle sonar sonar-runner`
