all: test

test: IOS7Crypt.pm
	perl IOS7Crypt.pm -e monkey
	perl IOS7Crypt.pm -d 020b0b55000316

perl:
	-for f in *.pl; do perl -MO=Lint -cw $$f 2>&1 | grep -v "syntax OK"; done
	-for f in **/*.pl; do perl -MO=Lint -cw $$f 2>&1 | grep -v "syntax OK"; done
	-for f in *.pm; do perl -MO=Lint -cw $$f 2>&1 | grep -v "syntax OK"; done
	-for f in **/*.pm; do perl -MO=Lint -cw $$f 2>&1 | grep -v "syntax OK"; done

perlcritic:
	-perlcritic . | grep -v "source OK"

lint: perl perlcritic
