CC=clang++
FLAGS=-O2 -Wall -Wextra -Wmost -Weverything

all: test

test: ios7crypt
	./ios7crypt -e monkey
	./ios7crypt -d 050609012a4957

ios7crypt: ios7crypt.cpp ios7crypt.h
	$(CC) $(FLAGS) -o ios7crypt ios7crypt.cpp

cppcheck:
	cppcheck --enable=all --suppress=missingIncludeSystem .

cpplint:
	find . -type f -name '*.c' -exec cpplint --filter=-readability/streams,-build/header_guard,-whitespace/parens,-readability/braces,-whitespace/newline,-legal/copyright {} \;
	find . -type f -name '*.h' -exec cpplint --filter=-readability/streams,-build/header_guard,-whitespace/parens,-readability/braces,-whitespace/newline,-legal/copyright {} \;

splint:
	find . -type f -name '*.c' -exec splint {} \;

vera++:
	find . -type f -name '*.cpp' -exec vera++ -s {} \;
	find . -type f -name '*.c' -exec vera++ -s {} \;
	find . -type f -name '*.h' -exec vera++ -s {} \;

lint: cppcheck cpplint splint vera++

clean:
	-rm *.exe
	-rm ios7crypt
