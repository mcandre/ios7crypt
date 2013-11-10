all: test

test: IOS7Crypt.pm
	perl IOS7Crypt.pm -e monkey
	perl IOS7Crypt.pm -d 020b0b55000316

lint:
	-perlcritic . | grep -v "source OK"
