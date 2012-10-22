#!/bin/sh

javac CommandLine.java
javac IOS7CryptGUI.java

jar cmf MANIFEST.MF IOS7Crypt.jar *.java *.class
