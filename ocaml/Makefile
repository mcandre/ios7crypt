all: test

test: ios7crypt
	./ios7crypt -t

ios7crypt: ios7crypt.ml
	ocamlfind ocamlc -w +a -package str,getopt,quickcheck -linkpkg -o ios7crypt ios7crypt.ml

clean:
	-rm *.exe
	-rm *.cmo
	-rm *.cmi
	-rm ios7crypt
