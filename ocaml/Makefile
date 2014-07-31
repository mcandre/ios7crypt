BIN=bin/ios7crypt

all: test

test: $(BIN)
	./$(BIN) -t

$(BIN): ios7crypt.ml
	mkdir -p bin/
	ocamlfind ocamlc -w +a -package str,getopt,quickcheck -linkpkg -o $(BIN) ios7crypt.ml

clean:
	-rm -rf bin/
	-rm *.cmo
	-rm *.cmi
