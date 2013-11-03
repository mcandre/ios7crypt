CC=gcc-4.7

all: test

test: ios7crypt
	./ios7crypt -e monkey
	./ios7crypt -d 050609012a4957
	./ios7crypt -t

ios7crypt: ios7crypt.c qc.c qc.h
	$(CC) -o ios7crypt -O2 ios7crypt.c qc.c qc.h -lgc -Wall

lint:
	splint ios7crypt.c

clean:
	-rm ios7crypt
