all: test

compile: ios7crypt.erl
	erlc -Wall +debug_info ios7crypt.erl

test: compile
	erl -noshell -s ios7crypt -extra -e monkey
	erl -noshell -s ios7crypt -extra -d 020b0b55000316

~/.dialyzer_plt: compile
	dialyzer *.beam --build_plt --quiet

lint: ~/.dialyzer_plt
	dialyzer *.beam

clean:
	-rm *.beam
