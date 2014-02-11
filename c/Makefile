CC=clang
FLAGS=-O2 -Wall -Wextra -Wmost -Weverything -Wno-pointer-arith

all: test

test: ios7crypt
	./ios7crypt -e monkey
	./ios7crypt -d 050609012a4957
	./ios7crypt -t

ios7crypt: ios7crypt.c ios7crypt.h qc.c qc.h
	$(CC) $(FLAGS) -o ios7crypt ios7crypt.c qc.c -lgc

splint:
	find . -type f -name '*.c' -exec splint {} \;
	find . -type f -name '*.h' -exec splint {} \;

vera++:
	find . -type f -name '*.cpp' -exec vera++ -s {} \;
	find . -type f -name '*.c' -exec vera++ -s {} \;
	find . -type f -name '*.h' -exec vera++ -s {} \;

lint: splint vera++

clean:
	-rm *.exe
	-rm ios7crypt
