FLAGS=-Wall -Wextra -Wmost -Weverything -framework Foundation -lobjc -o ios7crypt

all: test

test: ios7crypt
	./ios7crypt -e monkey
	./ios7crypt -d 050609012a4957

ios7crypt: IOS7Crypt.m
	clang $(FLAGS) IOS7Crypt.m

lint:
	oclint -rc=SHORT_VARIABLE_NAME=1 IOS7Crypt.m -- $(FLAGS)

clean:
	-rm *.exe
	-rm ios7crypt
