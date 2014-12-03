# IOS7Crypt port for Rust

# Example

```
$ make
mkdir -p bin/
rustc -o bin/ios7crypt ios7crypt.rs -O -W missing-doc -W non-uppercase-statics -W unnecessary-qualification -W unnecessary-typecast -W unused-result
bin/ios7crypt -e monkey
1308181c00091d
bin/ios7crypt -d 060b002f474b10
monkey
```

# Requirements

* [Rust](http://www.rust-lang.org/) 0.12
