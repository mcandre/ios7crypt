FLAGS=-O

BIN=target/debug/ios7crypt

all: test

test: $(BIN)
	$(BIN) -e monkey
	$(BIN) -d 060b002f474b10

$(BIN): src/bin/ios7crypt.rs
	cargo build

clean:
	-rm -rf target
