all: test

test: compile
	erl -noshell -s ios7crypt -extra -e monkey
	erl -noshell -s ios7crypt -extra -d 020b0b55000316
	erl -noshell -s ios7crypt -extra -t

compile:
	for f in *.erl; do erlc -Wall +debug_info $$f; done

plt:
	dialyzer *.beam --build_plt --apps erts kernel stdlib

lint: compile
	dialyzer *.beam --quiet

clean:
	-rm *.beam
