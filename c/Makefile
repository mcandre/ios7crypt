CC=gcc-4.7

all: test

test: ios7crypt
	./ios7crypt -e monkey
	./ios7crypt -d 050609012a4957

ios7crypt: ios7crypt.c qc.c qc.h
	$(CC) -o ios7crypt ios7crypt.c qc.c qc.h -lgc -Wall

lint:
	splint *.c *.h 2>&1

clean:
	-rm ios7crypt
