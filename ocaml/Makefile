all: ios7crypt

ios7crypt: ios7crypt.ml
	ocamlfind ocamlc -package str,getopt,quickcheck -linkpkg -o ios7crypt ios7crypt.ml

clean:
	-rm ios7crypt
	-rm ios7crypt.cmo
	-rm ios7crypt.cmi