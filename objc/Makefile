FLAGS=-Wall -framework Foundation -lobjc -lbsd

LINUX_FLAGS=

ifneq ($(OS),Windows_NT)
	UNAME_S := $(shell uname -s)

	ifeq ($(UNAME_S),Linux)
		LINUX_FLAGS=-I `gnustep-config --variable=GNUSTEP_SYSTEM_HEADERS` -L `gnustep-config --variable=GNUSTEP_SYSTEM_LIBRARIES` -lgnustep-base -fconstant-string-class=NSConstantString -D_NATIVE_OBJC_EXCEPTIONS
	endif
endif

BIN=bin/ios7crypt

all: test

test: $(BIN)
	$(BIN) -e monkey
	$(BIN) -d 050609012a4957

$(BIN): IOS7Crypt.m
	mkdir -p bin/
	clang $(FLAGS) $(LINUX_FLAGS) -o $(BIN) IOS7Crypt.m

lint: $(BIN)
	oclint -rc=SHORT_VARIABLE_NAME=1 IOS7Crypt.m -- $(FLAGS)

valgrind: $(BIN)
	valgrind --tool=memcheck --leak-check=yes --show-reachable=yes --track-fds=yes --dsymutil=yes ./$(BIN) -e monkey
	valgrind --tool=memcheck --leak-check=yes --show-reachable=yes --track-fds=yes --dsymutil=yes ./$(BIN) -d 050609012a4957

clean:
	-rm -rf bin/
