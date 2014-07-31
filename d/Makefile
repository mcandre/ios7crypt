FLAGS=-w -wi

BIN=bin/ios7crypt

all: test

test: $(BIN)
	./ios7crypt -e monkey
	./ios7crypt -d 104306170e120b

$(BIN): ios7crypt.d
	mkdir -p bin/
	dmd $(FLAGS) ios7crypt.d -version=ios7crypt ~/.d/dashcheck.d

clean:
	-rm -rf bin/
	-rm *.o
	-rm *.d.deps
