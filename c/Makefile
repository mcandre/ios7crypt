CC=gcc-4.7

all: ios7crypt

ios7crypt: ios7crypt.c qc.c qc.h
	$(CC) -o ios7crypt ios7crypt.c qc.c qc.h -lgc -Wall

lint:
	splint *.c *.h

clean:
	-rm ios7crypt
