BIN=bin/ios7crypt

all: test

test: $(BIN)
	./$(BIN) -e monkey
	./$(BIN) -d 060b002f474b10

$(BIN): ios7crypt.rs
	mkdir -p bin/
	rustc -o $(BIN) ios7crypt.rs

clean:
	-rm -rf bin/
	-rm -rf *.dSYM/
