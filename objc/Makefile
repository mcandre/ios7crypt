FLAGS=-Wall -Wextra -Wmost -Weverything -framework Foundation -lobjc -o ios7crypt

BIN=ios7crypt

all: test

test: $(BIN)
	./$(BIN) -e monkey
	./$(BIN) -d 050609012a4957

$(BIN): IOS7Crypt.m
	clang $(FLAGS) IOS7Crypt.m

lint: $(BIN)
	oclint -rc=SHORT_VARIABLE_NAME=1 IOS7Crypt.m -- $(FLAGS)

valgrind: $(BIN)
	valgrind --tool=memcheck --leak-check=yes --show-reachable=yes --track-fds=yes --dsymutil=yes ./$(BIN) -e monkey
	valgrind --tool=memcheck --leak-check=yes --show-reachable=yes --track-fds=yes --dsymutil=yes ./$(BIN) -d 050609012a4957

clean:
	-rm *.exe
	-rm $(BIN)
