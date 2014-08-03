FLAGS=-w -wi

BIN=bin/ios7crypt

all: test

test: $(BIN)
	./$(BIN) -e monkey
	./$(BIN) -d 104306170e120b

$(BIN): ios7crypt.d
	mkdir -p bin/
	dmd $(FLAGS) -of$(BIN) ios7crypt.d -version=ios7crypt ~/.d/dashcheck.d

clean:
	-rm -rf bin/
	-rm *.o
	-rm *.d.deps
