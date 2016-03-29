CC=clang++
FLAGS=-O2 -Wall -Wextra -Wmost -Weverything

BIN=bin/ios7crypt

all: test

test: $(BIN)
	$(BIN) -e monkey
	$(BIN) -d 050609012a4957

$(BIN): ios7crypt.cpp ios7crypt.h
	mkdir -p bin/
	$(CC) $(FLAGS) -o $(BIN) ios7crypt.cpp

cppcheck:
	cppcheck --quiet --enable=all --suppressions-list=$$HOME/suppressions.cfg .

cpplint:
	find . -type f -name '*.cpp' -o -name '*.[ch]' -exec cpplint --filter=-readability/streams,-build/header_guard,-whitespace/parens,-readability/braces,-whitespace/newline,-legal/copyright {} \;

splint:
	find . -type f -name '*.c' -exec splint {} \;

vera++:
	find . -type f -name '*.cpp' -o -name '*.[ch]' -exec vera++ -s {} \;

astyle-apply:
	-find . -type d -name android -prune -o -type f -name "*.java" -o -name "*.cpp" -o -name "*.[chm]" -exec astyle {} \; | grep -v Unchanged

astyle:
	-find . -type d -name android -prune -o -type f -name "*.java" -o -name "*.cpp" -o -name "*.[chm]" -exec astyle --dry-run {} \; | grep -v Unchanged

clean-astyle:
	-find . -type f -name "*.orig" -exec rm {} \;

lint: cppcheck cpplint splint vera++ astyle

valgrind: $(BIN)
	valgrind --tool=memcheck --leak-check=yes --show-reachable=yes --track-fds=yes --dsymutil=yes ./$(BIN) -e monkey
	valgrind --tool=memcheck --leak-check=yes --show-reachable=yes --track-fds=yes --dsymutil=yes ./$(BIN) -d 050609012a4957

clean: clean-astyle
	-rm -rf bin/
