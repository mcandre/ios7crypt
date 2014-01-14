FLAGS=-w -wi

all: test

test: ios7crypt
	./ios7crypt -e monkey
	./ios7crypt -d 104306170e120b

ios7crypt: ios7crypt.d
	dmd $(FLAGS) ios7crypt.d -version=ios7crypt ~/.d/dashcheck.d

clean:
	-rm ios7crypt
	-rm ios7crypt.o
	-rm ios7crypt.d.deps
