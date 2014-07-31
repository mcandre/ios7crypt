CC=clang
FLAGS=-O2 -Wall -Wextra -Wmost -Weverything -Wno-pointer-arith

BIN=ios7crypt

all: test

test: $(BIN)
	./$(BIN) -e monkey
	./$(BIN) -d 050609012a4957
	./$(BIN) -t

$(BIN): ios7crypt.c ios7crypt.h ../qc/qc.c ../qc/qc.h
	$(CC) $(FLAGS) -o $(BIN) ios7crypt.c ../qc/qc.c -lgc

cppcheck:
	cppcheck --enable=all --suppressions $$HOME/suppressions.cfg .

splint:
	find . -type f -name '*.[ch]' -exec splint {} \;

vera++:
	find . -type f -name '*.cpp' -o -name '*.[ch]' -exec vera++ -s {} \;

lint: cppcheck splint vera++

valgrind: $(BIN)
	valgrind --tool=memcheck --leak-check=yes --show-reachable=yes --track-fds=yes --dsymutil=yes ./$(BIN) -e monkey
	valgrind --tool=memcheck --leak-check=yes --show-reachable=yes --track-fds=yes --dsymutil=yes ./$(BIN) -d 050609012a4957

clean:
	-rm *.exe
	-rm $(BIN)
