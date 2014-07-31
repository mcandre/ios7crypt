BIN=bin/ios7crypt

all: test

test: $(BIN)
	./$(BIN) -e monkey
	./$(BIN) -d 1308181c00091d

$(BIN): ios7crypt.pas
	mkdir -p bin/
	fpc -dios7crypt -o$(BIN) ios7crypt.pas

clean:
	-rm -rf bin/
	-rm *.o
