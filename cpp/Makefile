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
	cpplint --filter=-build/header_guard,-whitespace/parens,-readability/braces,-whitespace/newline,-legal/copyright *.cpp *.h

lint: cppcheck

clean:
	-rm *.exe
	-rm ios7crypt
