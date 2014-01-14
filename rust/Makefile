all: test

test: ios7crypt
	./ios7crypt -e monkey
	./ios7crypt -d 060b002f474b10

ios7crypt: ios7crypt.rs
	rustc ios7crypt.rs

clean:
	-rm *.exe
	-rm ios7crypt
	-rm -rf *.dSYM
